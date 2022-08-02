function nr_timePSD_ipad_PREP(sum_filedirnm)
% Creates a time-varying power spectral density plot and a time-varying
% coherence plot aligned to movement onset.
% Movement onset for each active movement epoch is determined using
% emg/accel/task button timing data.

% Note: .mat files containing ecog/LFP data and EMG data must be in the
% same directory, otherwise warning message will prompt user to do so then
% try again.

% Created by S.Shimamoto  11/6/2008

% Revised by SS (12/17/2008) to load 'ecog' strucutre array from APMconv7 for raw
% ecog/lfp data instead of using raw_ecog_lfp double array from
% APMconv7_coh.  Script title changed from 'time_psd' to 'timePSD' for
% consistency with 'ecogPSD'

% Revised by SS (2/24/2009) to accomodate for data recorded by AlphaOmega
% system.  timePSD works on GL4k AND AlphaOmega recordings.

% Minor change by ALC (9/10/09) to add an if/else clause to the Save Data cell 
% such that if there is no LFP channel, the program will not try to save
% C_trans as an output variable.

% Minor change be ALC (3/4/10) to save the M1_ch variable to the output, as
% this is needed for group-level analysis with timeZ_SEM code.
%% initialize

%% load ecog data

%load .mat file containing ecog_lfp_raw_data
load(sum_filedirnm)

% cd(pathname);
% load([pathname filename]);
% filename=strrep(filename,'_ecog.mat','');% this takes off the _ecog ending of the filename;
% outputname = strrep(filename,'.mat',''); % outputname has no '.mat' extensions or any other misc tags; used later to save figures
%outputname = 'ps_pd_0072';

if ~isempty(strfind(sum_filedirnm,'ps_'))
    sum_filedirnm_ps = strfind(sum_filedirnm,'ps_');
    sbj = sum_filedirnm(sum_filedirnm_ps(1):sum_filedirnm_ps(1)+9);
elseif ~isempty(strfind(sum_filedirnm,'ec_'))
    sum_filedirnm_ec = strfind(sum_filedirnm,'ec_');
    sbj = sum_filedirnm(sum_filedirnm_ec(1):sum_filedirnm_ec(1)+9);
end


% load(name)
% filename=strrep(name,'_ecog','');% this takes off the _ecog ending of the filename;
% outputname = strrep(name,'.mat',''); % outputname has no '.mat' extensions or any other misc tags; used later to save figures
%% define variables

WINDOW = 512*Fs/1000;           
NOVERLAP = 462*Fs/1000;                
NFFT = 512*Fs/1000;     

FRAME_ADVANCE=WINDOW-NOVERLAP;
PRE = 2;      % time (sec) before movement onset
POST = 2;       % time (sec) after

ADD = 1;     % add more time to increase # windows in each snippet
BL = [2 1];  % baseline period before movement onset for calculating percent power change

%% ask user about system used for recording data
% typesystem = menu('Select the system used for recording data','Guideline 4000','Alpha Omega');
typesystem = 2;
% note: typesystem = 1 (GL4k), typesystem = 2 (AO)



%% Determine prep onset
 move_onset = ecog.prep_time(trials_ok)/Fs;
 
%% calculate normalized time-varying PSD

% calculate spectrogram for all ecog/LFP. gives the fft of each segment in each column, and the next column moves in time by window-noverlap samples

% FOR PREP ONSET
% remove movement onset that doesn't have enough time for pre-movement parsing
if move_onset(1)<(PRE+(WINDOW/(2*Fs)))
    move_onset=move_onset(2:end);
end


n_data_ch=length(ecog.contact_pair);
n_epochs = length(move_onset);

for i = 1:n_data_ch
    data = ecog.contact_pair(i).remontaged_ecog_signal;
    for j=1:n_epochs
        % take snippet of data around emg_onset from selected ecog/LFP channel add offset to increase # windows for fft
        first = int32(Fs*(move_onset(j)-(PRE))-WINDOW/2); % WINDOW/2 offset will make spectrogram start at moveonset-PRE at appropriately centered PSD
        last = int32(Fs*(move_onset(j)+(POST+ADD))-WINDOW/2);
        snip = data(first:last);
        %calculate spectrogram of snippet 3D matrix 'S' has the fft power value stored in [frequncy,time,epoch number] arrangement
        S(:,:,j) = spectrogram(snip,WINDOW,NOVERLAP,NFFT,Fs); %#ok<AGROW>
    end

    %find the magnitude of the fft represented in each column of S
    S_mag=abs(S);

    %calculate average across all epochs 
    %note: S_move_mag contains spectrograms from each epoch in the 3rd dimension. The average across all epochs are then calculated and stored in the 
    %3rd dimension of S_move_mag_mean.  S_move_mag_mean collects averaged spectrogram for each data channel in the 3rd dimension.DO NOT GET CONFUSED!
    S_mag_mean(:,:,i) = mean(S_mag,3); %#ok<AGROW>
    
    % clear some variables before next loop, this is probably not necessary but do it just in case
    clear data S S_mag;
end

%setup up the frequency (faxis)and time (taxis) axes data
[nfchans,nframes] = size(S_mag_mean(:,:,1));
nfchansteps = nfchans - 1;
maxfreq = Fs/2;
faxis = maxfreq*(0:nfchansteps)/nfchansteps;
t_res = FRAME_ADVANCE/Fs; % temporal resolution of spectrogram (sec)
taxis = (0:(nframes-1))* t_res;
taxis = taxis -PRE; %shift by PRE

% normalize to baseline values
if PRE<BL(1)
    error(['The baseline period for PSD plot currently begins '...
        '%d seconds before onset of movement. This value cannot be more than %d seconds '...
        'as determined by variable PRE'],BL(1),PRE);
else
    first = int32(((PRE-BL(1))/t_res)+1);
    last = int32((PRE-BL(2))/t_res);
    % to plot A with colors representing the log10 of power, uncomment this line:
    A2plot_rp = log10(S_mag_mean);
    % to plot A with colors representing raw data values, uncomment this line:
    % A2plot = S_move_mag_mean;
    for i = 1:n_data_ch
        %echo('plotting')
        for j = 1:nfchans
            bl = A2plot_rp(j,first:last,i);
            blmean = mean(bl);
            A2plot_rp(j,:,i) = A2plot_rp(j,:,i)/blmean; 
        end
    end    
end

assignin('base','A2plot_rp',A2plot_rp)

%% calculate time-varying transformed coherence

% calculate time-varying coherence if LFP exists
if n_data_ch==6
    lfp = ecog.contact_pair(6).remontaged_ecog_signal;
    for i=1:n_data_ch-1
        data = ecog.contact_pair(i).remontaged_ecog_signal;
        for j = 1:n_epochs
            first = int32(Fs*(move_onset(j)-(PRE))-WINDOW/2);% WINDOW/2 offset will make spectrogram start at moveonset-PRE at appropriately centered PSD
            last = int32(Fs*(move_onset(j)+(POST+ADD))-WINDOW/2);
            snip = data(first:last);
            snip_lfp = lfp(first:last);
            counter=1;
            coh_store=[];
            for k=1:nframes
                x = snip(counter:counter+WINDOW-1);
                y = snip_lfp(counter:counter+WINDOW-1);
%                 coh = mscohere(x,y,WINDOW,[],NFFT,Fs);
                coh = mscohere(x,y,[],[],NFFT,Fs);
%                 coh = mscohere(x,y,[],[],[],Fs);
                coh_store = [coh_store coh]; %#ok<AGROW>
                counter = counter+FRAME_ADVANCE;
            end
            % populate 3D matrix C with coherence for each epoch
            C(:,:,j)=coh_store; %#ok<AGROW>
        end
        % find mean across all epochs
        C_mean(:,:,i) = mean(C,3); %#ok<AGROW>
        % populate 3D matrix C_trans with transformed coherence for each
        % contact pair
        C_trans(:,:,i)=atanh(sqrt(C_mean(:,:,i))); %#ok<AGROW>
    end
end

%% plot data

%assignin('base','A2plot_rp',A2plot_rp)
% plot MOVEMENT ONSET spectrogram for all ecog/lfp data 
hf1 = figure;
val1 = min(min(min(A2plot_rp(1:100,:,:))));
val2 = max(max(max(A2plot_rp(1:100,:,:))));
clims1 = [val1 val2];
data_ch_names = {'e12','e23','e34','e45','e56','LFP'};

for i = 1:n_data_ch
    subplot(2,3,i);
    hold(gca,'on');
    % make the time-frequency plot
    tmp1 = A2plot_rp(1:100,:,i); %chopping A2plot will allow the whole colobar to be represented
    faxis_new = faxis(1:100);
    imagesc(taxis,faxis_new,tmp1,clims1);
%     imagesc(taxis,faxis,A2plot(:,:,i),clims1);
    %plot vertical bar at movement onset
    plot([0 0],ylim,'k:');
    hold(gca,'off');
    % set the y-axis direction (YDir) to have zero at the bottom
    set(gca,'YDir','normal');
    % set xlim and ylim
    set(gca,'Xlim',[0-PRE POST]);
    set(gca,'Ylim',[0 120]);
    % axis labels/title
    xlabel('time (sec)');
    ylabel('frequency (Hz)');
    if i==1
        
        title([sbj sprintf('\n') '# epochs=' num2str(n_epochs) sprintf('\n') data_ch_names{i} ' aligned to Cue onset']);
        
    elseif i==M1_ch1
        title(data_ch_names{i},'FontWeight','b');
    else
        title(data_ch_names{i});
    end

end

% put a color scale indicator next to the time-frequency plot
colorbar([0.9307 0.1048 0.02354 0.8226]);


% plot coherence
if n_data_ch==6
    hf2 = figure;
    val3 = min(min(min(C_trans(1:100,:,:))));
    val4 = max(max(max(C_trans(1:100,:,:))));
    clims2 = [val3 val4];
    f=linspace(0,Fs/2,size(C_trans,1));
    for i=1:n_data_ch-1
        subplot(2,3,i);
        hold(gca,'on');
        assignin('base','C_trans',C_trans)
        tmp2 = C_trans(1:100,:,i);%chopping C_trans will allow the whole colobar to be represented
        %assignin('base','tmp',tmp)
        f_new=f(1:100);
        imagesc(taxis,f_new,tmp2,clims2);
        %     imagesc(taxis,f,C_trans(:,:,i),clims2);
        % set the y-axis direction (YDir) to have zero at the bottom
        set(gca,'YDir','normal');
        % set xlim and ylim
        set(gca,'Xlim',[0-PRE POST]);
        set(gca,'Ylim',[0 120]);
        %plot vertical bar at movement onset
        plot([0 0],ylim,'k:');
        hold(gca,'off');
        % axis labels/title
        xlabel('time (sec)');
        ylabel('frequency (Hz)');
        if i==1
            
            title([sbj sprintf('\n') '# epochs=' num2str(n_epochs) sprintf('\n') data_ch_names{i} '-LFP aligned to Cue onset']);
            
        elseif i==M1_ch1
            title([data_ch_names{i} '-LFP'],'FontWeight','b');
        else
            title([data_ch_names{i} '-LFP']);
        end
    end
    % put a color scale indicator next to the time-coherence plot
    colorbar([0.9307 0.1048 0.02354 0.8226]);
end
%assignin('base','C_trans',C_trans)
% %% save data
% 
% if n_data_ch==6  
%         save([filename(1:11),'anl_fig_spc_prp',filename(12:end)],'A2plot','C_trans','faxis','taxis','move_onset','M1_ch1');
%         saveas(hf1,[filename '_timePSD_Prep'],'fig');
%         saveas(hf2,[filename '_timeCOH_Prep'],'fig');
% else
%      
%         save([filename(1:11),'anl_spc_ecg_prp_',filename(20:end)],'A2plot','faxis','taxis','move_onset','M1_ch');
%         %save([filename '_timePSD_Prep.mat'],'A2plot','faxis','taxis','move_onset','M1_ch');
%         saveas(hf1,[filename(1:11),'fig_spc_ecg_prp_',filename(20:end-4)],'fig');
%         print(hf1,[filename(1:11),'pdf_spc_ecg_prp_',filename(20:end-4)],'-dpdf');
%         %saveas(hf1,[filename '_timePSD_Prep'],'fig');
% end
%close all

%     cd('~/Dropbox/cluster_files/proj/lab/starr/ecog/gamma/v03/')
%     num_fig = findall(0,'type','figure');
%     for i = 1:num_fig
%     print(i,'-dpsc2',['fig_temp_',sbj],'-append')
%     end



return;


%ps2pdf('psfile',['fig_temp_',sbj,'.ps'],'pdffile',['fig_pdf_',sbj,'.pdf'],'gspapersize','a4', 'deletepsfile', 1)

