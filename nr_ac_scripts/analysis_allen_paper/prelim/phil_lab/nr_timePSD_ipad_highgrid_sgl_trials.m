function [S_rp,S_pm,S_mr,faxis,taxis] = nr_timePSD_ipad_highgrid_sgl_trials_ud(dat_file,trials_ok_ud)
% Creates a time-varying power spectral density plot and a time-varying
% coherence plot aligned to movement onset.
% Movement onset for each active movement epoch is determined using
% emg/accel/task button timing data.

% Created by S.Shimamoto  11/6/2008

% Revised by CDH (11/23/2011)

%% load ecog data and parse sbj

load(dat_file)

if ~isempty(strfind(dat_file,'ps_'))
    dat_file_ps = strfind(dat_file,'ps_');
    sbj = dat_file(dat_file_ps(1):dat_file_ps(1)+9);
elseif ~isempty(strfind(dat_file,'ec_'))
    dat_file_ec = strfind(dat_file,'ec_');
    sbj = dat_file(dat_file_ec(1):dat_file_ec(1)+9);
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

if n_ecog == 5
    prep_onset = ecog.prep_time(trials_ok_ud)/Fs;
elseif n_ecog == 28
    prep_onset = ecog.prep_time/Fs;
end

move_onset=ecog.active_time/Fs;
move_offset=ecog.rest_time/Fs;

%% REST-PREP
%---------------------
% remove movement onset that doesn't have enough time for pre-movement parsing
% if move_onset(1)<(PRE+(WINDOW/(2*Fs)))
%     move_onset=move_onset(2:end);
% end

if n_ecog == 5
    if prep_onset(1)<(PRE+(WINDOW/(2*Fs)))
        prep_onset=prep_onset(2:end);
    end
else
end

n_data_ch=n_ecog;
n_epochs = length(prep_onset);

for i = 1:n_data_ch
    data = ecog.contact_pair(i).remontaged_ecog_signal;
    if n_ecog == 5
        for j=1:n_epochs
            % take snippet of data around emg_onset from selected ecog/LFP channel add offset to increase # windows for fft
            first = int32(Fs*(prep_onset(j)-(PRE))-WINDOW/2); % WINDOW/2 offset will make spectrogram start at moveonset-PRE at appropriately centered PSD
            last = int32(Fs*(prep_onset(j)+(POST+ADD))-WINDOW/2);
            snip = data(first:last);
            %calculate spectrogram of snippet 3D matrix 'S' has the fft power value stored in [frequncy,time,epoch number] arrangement
            S(:,:,j) = spectrogram(snip,WINDOW,NOVERLAP,NFFT,Fs); %#ok<AGROW>
        end
    elseif n_ecog == 28
        for jj=1:length(trials_ok_ud); %1:n_epochs
            j=trials_ok_ud(jj);
            % take snippet of data around emg_onset from selected ecog/LFP channel add offset to increase # windows for fft
            first = int32(Fs*(prep_onset(j)-(PRE))-WINDOW/2); % WINDOW/2 offset will make spectrogram start at moveonset-PRE at appropriately centered PSD
            last = int32(Fs*(prep_onset(j)+(POST+ADD))-WINDOW/2);
            snip = data(first:last);
            %calculate spectrogram of snippet 3D matrix 'S' has the fft power value stored in [frequncy,time,epoch number] arrangement
            S(:,:,jj) = spectrogram(snip,WINDOW,NOVERLAP,NFFT,Fs); %#ok<AGROW>
        end
    end

    %find the magnitude of the fft represented in each column of S
    S_mag=abs(S);
    S_rp_eval = ['S_rp.S_rp_ch_',num2str(i),' = S_mag;'];
    eval(S_rp_eval)

    %calculate average across all epochs 
    %note: S_move_mag contains spectrograms from each epoch in the 3rd dimension. The average across all epochs are then calculated and stored in the 
    %3rd dimension of S_move_mag_mean.  S_move_mag_mean collects averaged spectrogram for each data channel in the 3rd dimension.DO NOT GET CONFUSED!
    S_mag_mean_rp(:,:,i) = mean(S_mag,3); %#ok<AGROW> can change to median
    
    % clear some variables before next loop, this is probably not necessary but do it just in case
    clear data S S_mag;
end

%setup up the frequency (faxis)and time (taxis) axes data
%assignin('base','S_mag_mean_rp',S_mag_mean_rp)
[nfchans,nframes] = size(S_mag_mean_rp(:,:,1));
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
    first = 21;%int32(((PRE-BL(1))/t_res)+1);
    last = 40;%int32((PRE-BL(2))/t_res);
    % to plot A with colors representing the log10 of power, uncomment this line:
    A2plot_rp = log10(S_mag_mean_rp);
    % to plot A with colors representing raw data values, uncomment this line:
    % A2plot_rp = S_move_mag_mean;
    for i = 1:n_data_ch
        for j = 1:nfchans
            bl = A2plot_rp(j,first:last,i);
            blmean = mean(bl);
            A2plot_rp(j,:,i) = A2plot_rp(j,:,i)/blmean; 
        end
    end
end
%assignin('base','A2plot_rp',A2plot_rp)

% plot MOVEMENT ONSET spectrogram for all ecog/lfp data 
hf1 = figure;
ff = find(faxis==125);
val1 = min(min(min(A2plot_rp(1:ff,:,:))));
val2 = max(max(max(A2plot_rp(1:ff,:,:))));
clims1 = [val1 val2];
%clims1 = [0.8 1.3];

M1_ch=M1_ch1;
for i = 1:n_data_ch/2
    subplot(3,5,i);
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
    set(gca,'Ylim',[0 200]);
    % axis labels/title
    xlabel('time (sec)');
    ylabel('frequency (Hz)');
    if i==1
        title([sbj num2str(i) ]);
%             title([name(1:end-5) sprintf('\n') '# epochs=' num2str(n_epochs) sprintf('\n') data_ch_names{i} ' aligned to mvt onset']);
    elseif i==M1_ch1
        title(['M1=' num2str(i) ],'FontWeight','b');
    else
        title( num2str(i) );
    end
end

hf1 = figure;
ff = find(faxis==125);
val1 = min(min(min(A2plot_rp(1:ff,:,:))));
val2 = max(max(max(A2plot_rp(1:ff,:,:))));
clims1 = [val1 val2];
for j = 1:n_data_ch/2
    subplot(3,5,j);
    i = j+14;
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
    set(gca,'Ylim',[0 200]);
    % axis labels/title
    xlabel('time (sec)');
    ylabel('frequency (Hz)');
    if i==1
        title([sbj num2str(i) ]);
%             title([name(1:end-5) sprintf('\n') '# epochs=' num2str(n_epochs) sprintf('\n') data_ch_names{i} ' aligned to mvt onset']);
    elseif i==M1_ch1
        title(['M1=' num2str(i) ],'FontWeight','b');
    else
        title( num2str(i) );
    end
end

% put a color scale indicator next to the time-frequency plot
colorbar([0.9307 0.1048 0.02354 0.8226]);

%% calculate normalized time-varying PSD

% calculate spectrogram for all ecog/LFP. gives the fft of each segment in each column, and the next column moves in time by window-noverlap samples

% FOR MOVE ONSET
%---------------------
% remove movement onset that doesn't have enough time for pre-movement parsing
% if move_onset(1)<(PRE+(WINDOW/(2*Fs)))
%     move_onset=move_onset(2:end);
% end

n_data_ch=length(ecog.contact_pair);
n_epochs = length(move_onset);

for i = 1:n_data_ch
    data = ecog.contact_pair(i).remontaged_ecog_signal;
    for jj=1:length(trials_ok_ud); %1:n_epochs
        j=trials_ok_ud(jj);
        % take snippet of data around emg_onset from selected ecog/LFP channel add offset to increase # windows for fft
        first = int32(Fs*(move_onset(j)-(PRE))-WINDOW/2); % WINDOW/2 offset will make spectrogram start at moveonset-PRE at appropriately centered PSD
        last = int32(Fs*(move_onset(j)+(POST+ADD))-WINDOW/2);
        snip = data(first:last);
        %calculate spectrogram of snippet 3D matrix 'S' has the fft power value stored in [frequncy,time,epoch number] arrangement
        S(:,:,jj) = spectrogram(snip,WINDOW,NOVERLAP,NFFT,Fs); %#ok<AGROW>
    end

    %find the magnitude of the fft represented in each column of S
    
    S_mag=abs(S);
    S_pm_eval = ['S_pm.S_pm_ch_',num2str(i),' = S_mag;'];
    eval(S_pm_eval)

    %calculate average across all epochs 
    %note: S_move_mag contains spectrograms from each epoch in the 3rd dimension. The average across all epochs are then calculated and stored in the 
    %3rd dimension of S_move_mag_median.  S_move_mag_median collects averaged spectrogram for each data channel in the 3rd dimension.DO NOT GET CONFUSED!
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
    A2plot = log10(S_mag_mean);
    % to plot A with colors representing raw data values, uncomment this line:
%     A2plot = S_move_mag_mean;
    for i = 1:n_data_ch
        for j = 1:nfchans
            bl = A2plot(j,first:last,i);
            blmean = mean(bl);
            A2plot(j,:,i) = A2plot(j,:,i)/blmean; 
        end
    end
end


% remove noise
% x=[31 32 33 60 61 62 63 92 93 94];
% A2plot(x,:,:)=nan;

% plot MOVEMENT ONSET spectrogram for all ecog/lfp data 
hf1 = figure;
ff = find(faxis==125);
val1 = min(min(min(A2plot(1:ff,:,:))));
val2 = max(max(max(A2plot(1:ff,:,:))));
% clims1 = [val1 val2];
clims1 = [0.8 1.3];

M1_ch=M1_ch1;
for i = 1:n_data_ch/2
    subplot(3,5,i);
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
    set(gca,'Ylim',[0 200]);
    % axis labels/title
    xlabel('time (sec)');
    ylabel('frequency (Hz)');
    if i==1
        title([sbj num2str(i) ]);
%             title([name(1:end-5) sprintf('\n') '# epochs=' num2str(n_epochs) sprintf('\n') data_ch_names{i} ' aligned to mvt onset']);
    elseif i==M1_ch1
        title(['M1=' num2str(i) ],'FontWeight','b');
    else
        title( num2str(i) );
    end
end

% put a color scale indicator next to the time-frequency plot
colorbar([0.9307 0.1048 0.02354 0.8226]);


%========================== UNCOMMENT!!!!!
% save the figure
%saveas(hf1,[filename '_timePSD_Mvt_on_raw1'],'fig');
%saveas(hf1,[filename(1:11),'fig_spc_ecg_mn1_',filename(20:end)],'fig');
%UNCOMMENT LATER!!!!!!!!!
%print(hf1,[filename(1:11),'pdf_spc_ecg_mn1_',filename(20:end-4)],'-dpdf');

% plot MOVEMENT ONSET spectrogram for all ecog/lfp data 
hf1 = figure;
ff = find(faxis==125);
val1 = min(min(min(A2plot(1:ff,:,:))));
val2 = max(max(max(A2plot(1:ff,:,:))));
% clims1 = [val1 val2];
clims1 = [0.8 1.3];

M1_ch=M1_ch2;
for j = 1:n_data_ch/2
    subplot(3,5,j);
    i=j+14
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
    set(gca,'Ylim',[0 200]);
    % axis labels/title
    xlabel('time (sec)');
    ylabel('frequency (Hz)');
    if i==1
        title([name(1:end-5) num2str(i) ]);
%             title([name(1:end-5) sprintf('\n') '# epochs=' num2str(n_epochs) sprintf('\n') data_ch_names{i} ' aligned to mvt onset']);
    elseif i==M1_ch
        title(['M1=' num2str(i) ],'FontWeight','b');
    else
        title( num2str(i) );
    end
end

% put a color scale indicator next to the time-frequency plot
colorbar([0.9307 0.1048 0.02354 0.8226]);

% save the figure
%saveas(hf1,[filename '_timePSD_Mvt_on_raw2'],'fig');
% saveas(hf1,[filename(1:11),'fig_spc_ecg_mn2_',filename(20:end)],'fig');
% print(hf1,[filename(1:11),'pdf_spc_ecg_mn2_',filename(20:end-4)],'-dpdf');

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
    %for jj=1:length(trials_ok_ud)-1;
    for jj=1:length(trials_ok_ud);
        j = trials_ok_ud(jj);%1:n_epochs

        % take snippet of data around emg_onset from selected ecog/LFP channel add offset to increase # windows for fft
        first = int32(Fs*(move_offset(j)-(PRE))-WINDOW/2); % WINDOW/2 offset will make spectrogram start at moveonset-PRE at appropriately centered PSD
        last = int32(Fs*(move_offset(j)+(POST+ADD))-WINDOW/2);
        snip = data(first:last);
        %calculate spectrogram of snippet 3D matrix 'S' has the fft power value stored in [frequncy,time,epoch number] arrangement
        %S_off(:,:,j) = spectrogram(snip,WINDOW,NOVERLAP,NFFT,Fs); %#ok<AGROW>
        S_off(:,:,jj) = spectrogram(snip,WINDOW,NOVERLAP,NFFT,Fs); %#ok<AGROW>
    end

    %find the magnitude of the fft represented in each column of S
    S_off_mag=abs(S_off);
    
    S_mr_eval = ['S_mr.S_mr_ch_',num2str(i),' = S_off_mag;'];
    eval(S_mr_eval)

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

% % remove noise
% x=[31 32 33 61 62 63 92 93 94];
% A2plot_off(x,:,:)=nan;

% plot MOVEMENT OFFSET spectrogram for all ecog/lfp data 
hf1 = figure;
val1 = min(min(min(A2plot_off(1:100,:,:))));
val2 = max(max(max(A2plot_off(1:100,:,:))));
% clims1 = [val1 val2];
clims1 = [0.8 1.3];
M1_ch=M1_ch1;
for i = 1:n_data_ch/2
    subplot(3,5,i);
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
    set(gca,'Ylim',[0 200]);
    % axis labels/title
    xlabel('time (sec)');
    ylabel('frequency (Hz)');
    if i==1
        title([sbj num2str(i) ]);
%             title([name(1:end-5) sprintf('\n') '# epochs=' num2str(n_epochs) sprintf('\n') data_ch_names{i} ' aligned to mvt onset']);
    elseif i==M1_ch1
        title(['M1=' num2str(i) ],'FontWeight','b');
    else
        title( num2str(i) );
    end
end

% put a color scale indicator next to the time-frequency plot
colorbar([0.9307 0.1048 0.02354 0.8226]);

% save the figure
%saveas(hf1,[filename '_timePSD_Mvt_off_raw1'],'fig');
% saveas(hf1,[filename(1:11),'fig_spc_ecg_mf1_',filename(20:end)],'fig');
% print(hf1,[filename(1:11),'pdf_spc_ecg_mf1_',filename(20:end-4)],'-dpdf');

% plot MOVEMENT ONSET spectrogram for all ecog/lfp data 
hf1 = figure;
ff = find(faxis==125);
val1 = min(min(min(A2plot(1:ff,:,:))));
val2 = max(max(max(A2plot(1:ff,:,:))));
% clims1 = [val1 val2];
clims1 = [0.8 1.3];

M1_ch=M1_ch2;
for j = 1:n_data_ch/2
    subplot(3,5,j);
    i=j+14;
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
    set(gca,'Ylim',[0 200]);
    % axis labels/title
    xlabel('time (sec)');
    ylabel('frequency (Hz)');
    if i==1
        title([name(1:end-5) num2str(i) ]);
%             title([name(1:end-5) sprintf('\n') '# epochs=' num2str(n_epochs) sprintf('\n') data_ch_names{i} ' aligned to mvt onset']);
    elseif i==M1_ch
        title(['M1=' num2str(i) ],'FontWeight','b');
    else
        title( num2str(i) );
    end
end

% put a color scale indicator next to the time-frequency plot
colorbar([0.9307 0.1048 0.02354 0.8226]);

figure
for i = 1:14
    subplot(7,2,i); 
    eval(['imagesc(squeeze(S_rp.S_rp_ch_',num2str(i),'(70:200,:,:))'')'])
    text(95,1,num2str(i))
end

figure
for i = 15:28
    subplot(7,2,i-14); 
    eval(['imagesc(squeeze(S_rp.S_rp_ch_',num2str(i),'(53,:,:))'')'])
    text(95,1,num2str(i))
end

figure
for i = 1:14
    subplot(7,2,i); 
    eval(['imagesc(squeeze(S_pm.S_pm_ch_',num2str(i),'(53,:,:))'')'])
    text(95,1,num2str(i))
end

figure
for i = 15:28
    subplot(7,2,i-14); 
    eval(['imagesc(squeeze(S_pm.S_pm_ch_',num2str(i),'(53,:,:))'')'])
    text(95,1,num2str(i))
end

figure
for i = 1:14
    subplot(7,2,i); 
    eval(['imagesc(squeeze(S_mr.S_mr_ch_',num2str(i),'(53,:,:))'')'])
    text(95,1,num2str(i))
end

figure
for i = 15:28
    subplot(7,2,i-14); 
    eval(['imagesc(squeeze(S_mr.S_mr_ch_',num2str(i),'(53:54,:,:))'')'])
    text(95,1,num2str(i))
end








