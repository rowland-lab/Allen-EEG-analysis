function nr_timePSD_ipad_MVT(sum_filedirnm)
% Creates a time-varying power spectral density plot and a time-varying
% coherence plot aligned to movement onset.
% Movement onset for each active movement epoch is determined using
% emg/accel/task button timing data.

% Created by S.Shimamoto  11/6/2008

% Revised by CDH (11/23/2011)

%% load ecog data
load(sum_filedirnm)

% %load .mat file containing ecog_lfp_raw_data
% [filename pathname]=uigetfile('*_ecog.mat','Select .mat file containing ecog/lfp raw data');
% cd(pathname);
% load([pathname filename]);
% filename=strrep(filename,'_ecog.mat','');% this takes off the _ecog ending of the filename;
% sbj = strrep(filename,'.mat',''); % outputname has no '.mat' extensions or any other misc tags; used later to save figures

% load(name)
% filename = name;

if ~isempty(strfind(sum_filedirnm,'ps_'))
    sum_filedirnm_ps = strfind(sum_filedirnm,'ps_');
    sbj = sum_filedirnm(sum_filedirnm_ps(1):sum_filedirnm_ps(1)+9);
elseif ~isempty(strfind(sum_filedirnm,'ec_'))
    sum_filedirnm_ec = strfind(sum_filedirnm,'ec_');
    sbj = sum_filedirnm(sum_filedirnm_ec(1):sum_filedirnm_ec(1)+9);
end

%% define variables


WINDOW = 512*Fs/1000;           
NOVERLAP = 462*Fs/1000;                
NFFT = 512*Fs/1000;     

FRAME_ADVANCE=WINDOW-NOVERLAP;
PRE = 2;      % time (sec) before movement onset
POST = 2;       % time (sec) after

ADD = 1;     % add more time to increase # windows in each snippet
BL = [2 1];  % baseline period before movement onset for calculating percent power change


% %% determine movement onset
% 
% % if there are no previously saved onset times or if user wants to run
% % onset detection again, run detectEMG
% if ~exist('ecog.move_time')
%     
%     typedata = menu('Detect movement onset using EMG/accel/task button?','EMG','accel','task button');
%     % note: typedata = 1 (EMG data), typedata = 2 (accel data), typedata = 3 (task button)
%     
%     % find active epoch timestamps from ecog structure
%     epoch_ts = ecog.touch_time/Fs; % take the go signal to detect the movement onset and convert the time in sec
%     
%     % determine movement onset time on accel, emg or button
%     if typedata==1
%         move = emg.chan(1).raw;
%     elseif typedata==2
%         move = aux.chan(2).raw;
%     else
%         move = aux.chan(3).raw;
%         
%     end
% %     move=eegfilt(move,Fs,1,4);
%      %create time matching time vector
%     nsamples = length(move); %#ok<NODEF>
%     T = 1/(Fs);
%     time = 0:T:T*(nsamples-1);
%     
%     % Detect move onset
%     move_onset = DetectEMG(time,move,epoch_ts);
%     
%      % Detect move offset
%     move_offset = DetectEMG(time,move,epoch_ts+2);
% else
%     move_onset = epoch_ts;
%     move_offset = epoch_off_ts;
% end
%      
% ecog.move_time = int32(move_onset*Fs);
% ecog.move_off_time = int32(move_offset*Fs);
% save(name,'ecog','-append')
% 
move_onset=ecog.active_time/Fs;
move_offset=ecog.rest_time/Fs;

%% calculate normalized time-varying PSD

% calculate spectrogram for all ecog/LFP. gives the fft of each segment in each column, and the next column moves in time by window-noverlap samples

% FOR MOVE ONSET
%---------------------
% remove movement onset that doesn't have enough time for pre-movement parsing
% if move_onset(1)<(PRE+(WINDOW/(2*Fs)))
%     move_onset=move_onset(2:end);
% end

n_data_ch=n_ecog;
n_epochs = length(move_onset);

for i = 1:n_data_ch
    data = ecog.contact_pair(i).remontaged_ecog_signal;
    for jj=1:length(trials_ok); %1:n_epochs
        j=trials_ok(jj);
        % take snippet of data around emg_onset from selected ecog/LFP channel add offset to increase # windows for fft
        first = int32(Fs*(move_onset(j)-(PRE))-WINDOW/2); % WINDOW/2 offset will make spectrogram start at moveonset-PRE at appropriately centered PSD
        last = int32(Fs*(move_onset(j)+(POST+ADD))-WINDOW/2);
        snip = data(first:last);
        %calculate spectrogram of snippet 3D matrix 'S' has the fft power value stored in [frequncy,time,epoch number] arrangement
        S(:,:,j) = spectrogram(snip,WINDOW,NOVERLAP,NFFT,Fs); %#ok<AGROW>
        %spectrogram(snip,WINDOW,NOVERLAP,NFFT,Fs); %#ok<AGROW>
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
%assignin('base','S_mag_mean',S_mag_mean)
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
    A2plot = log10(S_mag_mean);
    % to plot A with colors representing raw data values, uncomment this line:
    % A2plot = S_move_mag_mean;
    for i = 1:n_data_ch
        for j = 1:nfchans
            bl = A2plot(j,first:last,i);
            blmean = mean(bl);
            A2plot(j,:,i) = A2plot(j,:,i)/blmean; 
        end
    end
end

% plot MOVEMENT ONSET spectrogram for all ecog/lfp data 
hf1 = figure;
val1 = min(min(min(A2plot(1:100,:,:))));
val2 = max(max(max(A2plot(1:100,:,:))));
clims1 = [val1 val2];
data_ch_names = {'e12','e23','e34','e45','e56','LFP'};

% assignin('base','A2plot',A2plot)
% assignin('base','taxis',taxis)
% assignin('base','faxis',faxis)
% assignin('base','clims1',clims1)


for i = 1:n_data_ch
    subplot(2,3,i);
    hold(gca,'on');
    % make the time-frequency plot
    tmp1 = A2plot(1:100,:,i); %chopping A2plot will allow the whole colobar to be represented
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
            title([sbj sprintf('\n') '# epochs=' num2str(n_epochs) sprintf('\n') data_ch_names{i} ' aligned to mvt onset']);
    elseif i==M1_ch1
        title(data_ch_names{i},'FontWeight','b');
    else
        title(data_ch_names{i});
    end
end

% put a color scale indicator next to the time-frequency plot
colorbar([0.9307 0.1048 0.02354 0.8226]);

% % save the figure
% %saveas(hf1,[filename '_timePSD_Mvt_on'],'fig');
% saveas(hf1,[filename(1:11),'fig_spc_ecg_mvn_',filename(20:end-4)],'fig');
% print(hf1,[filename(1:11),'pdf_spc_ecg_mvn_',filename(20:end-4)],'-dpdf');


% FOR MOVE OFFSET
%---------------------

% remove movement onset that doesn't have enough time for pre-movement parsing
% if move_offset(1)<(PRE+(WINDOW/(2*Fs)))
%     move_offset=move_offset(2:end);
% end

n_data_ch=n_ecog;
n_epochs = length(move_offset);

for i = 1:n_data_ch
    data = ecog.contact_pair(i).remontaged_ecog_signal;
    for jj=1:length(trials_ok)-1;
        j = trials_ok(jj);%1:n_epochs

        % take snippet of data around emg_onset from selected ecog/LFP channel add offset to increase # windows for fft
        first = int32(Fs*(move_offset(j)-(PRE))-WINDOW/2); % WINDOW/2 offset will make spectrogram start at moveonset-PRE at appropriately centered PSD
        last = int32(Fs*(move_offset(j)+(POST+ADD))-WINDOW/2);
        snip = data(first:last);
        %calculate spectrogram of snippet 3D matrix 'S' has the fft power value stored in [frequncy,time,epoch number] arrangement
        S_off(:,:,j) = spectrogram(snip,WINDOW,NOVERLAP,NFFT,Fs); %#ok<AGROW>
    end

    %find the magnitude of the fft represented in each column of S
    S_off_mag=abs(S_off);

    %calculate average across all epochs 
    %note: S_move_mag contains spectrograms from each epoch in the 3rd dimension. The average across all epochs are then calculated and stored in the 
    %3rd dimension of S_move_mag_mean.  S_move_mag_mean collects averaged spectrogram for each data channel in the 3rd dimension.DO NOT GET CONFUSED!
    S_off_mag_mean(:,:,i) = mean(S_off_mag,3); %#ok<AGROW>
    
    % clear some variables before next loop, this is probably not necessary but do it just in case
    clear data S_off S_off_mag;
end

%setup up the frequency (faxis)and time (taxis) axes data
[nfchans,nframes] = size(S_off_mag_mean(:,:,1));
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
    first = int32(((PRE+BL(2))/t_res)+1);
    last = int32((PRE+BL(1))/t_res);
    % to plot A with colors representing the log10 of power, uncomment this line:
    A2plot_off = log10(S_off_mag_mean);
    % to plot A with colors representing raw data values, uncomment this line:
    % A2plot = S_move_mag_mean;
    for i = 1:n_data_ch
        for j = 1:nfchans
            bl = A2plot_off(j,first:last,i);
            blmean = mean(bl);
            A2plot_off(j,:,i) = A2plot_off(j,:,i)/blmean; 
        end
    end
end

% plot MOVEMENT OFFSET spectrogram for all ecog/lfp data 
hf1 = figure;
val1 = min(min(min(A2plot_off(1:100,:,:))));
val2 = max(max(max(A2plot_off(1:100,:,:))));
clims1 = [val1 val2];
data_ch_names = {'e12','e23','e34','e45','e56','LFP'};

for i = 1:n_data_ch
    subplot(2,3,i);
    hold(gca,'on');
    % make the time-frequency plot
    tmp1 = A2plot_off(1:100,:,i); %chopping A2plot will allow the whole colobar to be represented
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
            title([sbj sprintf('\n') '# epochs=' num2str(n_epochs) sprintf('\n') data_ch_names{i} ' aligned to mvt offset']);
    elseif i==M1_ch1
        title(data_ch_names{i},'FontWeight','b');
    else
        title(data_ch_names{i});
    end
end

% put a color scale indicator next to the time-frequency plot
colorbar([0.9307 0.1048 0.02354 0.8226]);



% %% Print figures
% num_fig = findall(0,'type','figure');
% for i = 1:num_fig
%     print(i,'-dpsc2',['fig_temp_',sbj],'-append')
% end


%ps2pdf('psfile',['fig_temp_',sbj,'.ps'],'pdffile',['fig_pdf_',sbj,'.pdf'],'gspapersize','a4', 'deletepsfile', 1)


% % save the figure
% %saveas(hf1,[filename '_timePSD_Mvt_off'],'fig');
% saveas(hf1,[filename(1:11),'fig_spc_ecg_mvf_',filename(20:end-4)],'fig');
% print(hf1,[filename(1:11),'pdf_spc_ecg_mvf_',filename(20:end-4)],'-dpdf');

% %% calculate time-varying transformed coherence
% 
% % calculate time-varying coherence if LFP exists
% if n_data_ch==6
%     lfp = ecog.contact_pair(6).remontaged_ecog_signal;
%     for i=1:n_data_ch-1
%         data = ecog.contact_pair(i).remontaged_ecog_signal;
%         for j = 1:length(trials_ok)%n_epochs
%             first = int32(Fs*(move_onset(j)-(PRE))-WINDOW/2);% WINDOW/2 offset will make spectrogram start at moveonset-PRE at appropriately centered PSD
%             last = int32(Fs*(move_onset(j)+(POST+ADD))-WINDOW/2);
%             snip = data(first:last);
%             snip_lfp = lfp(first:last);
%             counter=1;
%             coh_store=[];
%             for k=1:nframes
%                 x = snip(counter:counter+WINDOW-1);
%                 y = snip_lfp(counter:counter+WINDOW-1);
%                 coh = mscohere(x,y,[],[],NFFT,Fs);
%                 coh_store = [coh_store coh]; %#ok<AGROW>
%                 counter = counter+FRAME_ADVANCE;
%             end
%             % populate 3D matrix C with coherence for each epoch
%             C(:,:,j)=coh_store; %#ok<AGROW>
%         end
%         % find mean across all epochs
%         C_mean(:,:,i) = mean(C,3); %#ok<AGROW>
%         % populate 3D matrix C_trans with transformed coherence for each contact pair
%         C_trans(:,:,i)=atanh(sqrt(C_mean(:,:,i))); %#ok<AGROW>
%     end
% end



% % plot coherence
% if n_data_ch==6
%     hf2 = figure;
%     val3 = min(min(min(C_trans(1:100,:,:))));
%     val4 = max(max(max(C_trans(1:100,:,:))));
%     clims2 = [val3 val4];
%     f=linspace(0,Fs/2,size(C_trans,1));
%     for i=1:n_data_ch-1
%         subplot(2,3,i);
%         hold(gca,'on');
%         tmp2 = C_trans(1:100,:,i);%chopping C_trans will allow the whole colobar to be represented
%         f_new=f(1:100);
%         imagesc(taxis,f_new,tmp2,clims2);
%         %     imagesc(taxis,f,C_trans(:,:,i),clims2);
%         % set the y-axis direction (YDir) to have zero at the bottom
%         set(gca,'YDir','normal');
%         % set xlim and ylim
%         set(gca,'Xlim',[0-PRE POST]);
%         set(gca,'Ylim',[0 120]);
%         %plot vertical bar at movement onset
%         plot([0 0],ylim,'k:');
%         hold(gca,'off');
%         % axis labels/title
%         xlabel('time (sec)');
%         ylabel('frequency (Hz)');
%         if i==1
%             title([name(1:end-5) sprintf('\n') '# epochs=' num2str(n_epochs) sprintf('\n') data_ch_names{i} '-LFP aligned to mvt onset']);
%         elseif i==M1_ch
%             title([data_ch_names{i} '-LFP'],'FontWeight','b');
%         else
%             title([data_ch_names{i} '-LFP']);
%         end
%     end
%     % put a color scale indicator next to the time-coherence plot
%     colorbar([0.9307 0.1048 0.02354 0.8226]);
% end
% 
%% save data

% SAS 6/9/2009: 'A2plot' included in output file, 'S_move_mag_mean' (the
% unnormalized version of 'A2plot') is excluded because of redundancy in
% saved variables.

% save variables and figure
    %ALC 9/10/09: added if/else clause to allow code to save data without
    %an LFP channel by ignoring C-trans variable
% if n_data_ch==6  
%         save([name(1:end-5) '_timePSD_Mvt.mat'],'A2plot','C_trans','faxis','taxis','move_onset','M1_ch');
%         saveas(hf1,[name(1:end-5) '_timePSD_Mvt'],'fig');
%         saveas(hf2,[name(1:end-5) '_timeCOH_Mvt'],'fig');
% else
%  save([filename(1:11),'anl_spc_ecg_mov_',filename(20:end)],'A2plot','A2plot_off','faxis','taxis','move_onset','move_offset','M1_ch','S_mag_mean','S_off_mag_mean');
%         %save([filename '_timePSD_Mvt.mat'],'A2plot','A2plot_off','faxis','taxis','move_onset','move_offset','M1_ch','S_mag_mean','S_off_mag_mean');
%         saveas(hf1,[name(1:end-5) '_timePSD_Mvt'],'fig');
% end
% return;