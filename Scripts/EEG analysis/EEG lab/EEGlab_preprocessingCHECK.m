clear
clc

subject='pro00087153_0021';
protocolfolder='C:\Users\allen\Box Sync\Desktop\Allen_Rowland_EEG\protocol_00087153';
trial='t1';

%% Load/define data

% Load S1 data
s1=load(fullfile(protocolfolder,subject,'analysis','EEGlab','Pre-ICA.mat'));

% Load S2 data
s2=load(fullfile(protocolfolder,subject,'analysis','EEGlab','ICA-Removed.mat'));

% Dedicate trial data
fs=1024;
processingData=s1.eegevents.(trial).processingData;
latency=s1.eegevents.(trial).urevent(1).latency;
eventtime=(latency+processingData{7}.VRsignal(1,1))/fs;

% Channel
channel=18;
%% Create figure
figure;
sgtitle([subject,' - ',trial,' - Channel ',num2str(channel)],'Interpreter','none')

% Plot import
subplot(6,6,[1 2])
xdata=processingData{1}.data(channel,(eventtime*fs)-(0.5*fs):(eventtime*fs)+(1*fs));
ydata=(1:numel(xdata))/fs;
plot(ydata,xdata)
title(processingData{1}.details)
xlim([0 ydata(end)])
ylim([-40 40]);

ph(1)=subplot(6,6,3);
[pxx,f]=pwelch(xdata,[],[],[],fs);
plot(f,log10(pxx));

% Plot Downsample
subplot(6,6,[7 8])
fs=256;
xdata=processingData{2}.data(channel,(eventtime*fs)-(0.5*fs):(eventtime*fs)+(1*fs));
ydata=(1:numel(xdata))/fs;
plot(ydata,xdata)
title(processingData{2}.details)
xlim([0 ydata(end)])
ylim([-40 40]);

ph(2)=subplot(6,6,9);
[pxx,f]=pwelch(xdata,[],[],[],fs);
plot(f,log10(pxx));

% Plot High Pass Filter (0.5)
subplot(6,6,[13 14])
xdata=processingData{3}.data(channel,(eventtime*fs)-(0.5*fs):(eventtime*fs)+(1*fs));
ydata=(1:numel(xdata))/fs;
plot(ydata,xdata)
title(processingData{3}.details)
xlim([0 ydata(end)])
ylim([-40 40]);

ph(3)=subplot(6,6,15);
[pxx,f]=pwelch(xdata,[],[],[],fs);
plot(f,log10(pxx));

% Plot Notch Filter 
subplot(6,6,[19 20])
xdata=processingData{4}.data(channel,(eventtime*fs)-(0.5*fs):(eventtime*fs)+(1*fs));
ydata=(1:numel(xdata))/fs;
plot(ydata,xdata)
title(processingData{4}.details)
xlim([0 ydata(end)])
ylim([-40 40]);

ph(4)=subplot(6,6,21);
[pxx,f]=pwelch(xdata,[],[],[],fs);
plot(f,log10(pxx));

% Plot Removed bad channels and interpolate
subplot(6,6,[25 26])
xdata=processingData{5}.data(channel,(eventtime*fs)-(0.5*fs):(eventtime*fs)+(1*fs));
ydata=(1:numel(xdata))/fs;
plot(ydata,xdata)
title(processingData{5}.details)
xlim([0 ydata(end)])
ylim([-40 40]);

ph(5)=subplot(6,6,27);
[pxx,f]=pwelch(xdata,[],[],[],fs);
plot(f,log10(pxx));

% Plot rereference to average
subplot(6,6,[31 32])
xdata=processingData{6}.data(channel,(eventtime*fs)-(0.5*fs):(eventtime*fs)+(1*fs));
ydata=(1:numel(xdata))/fs;
plot(ydata,xdata)
title(processingData{6}.details)
xlim([0 ydata(end)])
ylim([-40 40]);

ph(6)=subplot(6,6,33);
[pxx,f]=pwelch(xdata,[],[],[],fs);
plot(f,log10(pxx));

% Plot epoch trial
subplot(6,6,[4 5])
xdata=processingData{7}.data(channel,latency-(0.5*fs):latency+(1*fs),1);
ydata=(1:numel(xdata))/fs;
plot(ydata,xdata)
title(processingData{7}.details)
xlim([0 ydata(end)])
ylim([-40 40]);

ph(7)=subplot(6,6,6);
[pxx,f]=pwelch(xdata,[],[],[],fs);
plot(f,log10(pxx));

% Plot Artifact Subspace Reconstruction
subplot(6,6,[10 11])
xdata=processingData{8}.data(channel,latency-(0.5*fs):latency+(1*fs),1);
ydata=(1:numel(xdata))/fs;
plot(ydata,xdata)
title(processingData{8}.details)
xlim([0 ydata(end)])
ylim([-40 40]);

ph(8)=subplot(6,6,12);
[pxx,f]=pwelch(xdata,[],[],[],fs);
plot(f,log10(pxx));


% Plot second rereferencing
subplot(6,6,[16 17])
xdata=processingData{9}.data(channel,latency-(0.5*fs):latency+(1*fs),1);
ydata=(1:numel(xdata))/fs;
plot(ydata,xdata)
title(processingData{9}.details)
xlim([0 ydata(end)])
ylim([-40 40]);

ph(9)=subplot(6,6,18);
[pxx,f]=pwelch(xdata,[],[],[],fs);
plot(f,log10(pxx));


% Plot reach epoch
subplot(6,6,[22 23])
xdata=processingData{10}.data(channel,:,1);
ydata=(1:numel(xdata))/fs;
plot(ydata,xdata)
title(processingData{10}.details)
xlim([0 ydata(end)])
ylim([-40 40]);

ph(10)=subplot(6,6,24);
[pxx,f]=pwelch(xdata,[],[],[],fs);
plot(f,log10(pxx));

% Plot ICA removed epoch
subplot(6,6,[28 29])
xdata=s2.eegevents.(trial).data(channel,:,1);
ydata=(1:numel(xdata))/fs;
plot(ydata,xdata)
title('ICA removed (heart)')
xlim([0 ydata(end)])
ylim([-40 40]);

ph(11)=subplot(6,6,30);
[pxx,f]=pwelch(xdata,[],[],[],fs);
plot(f,log10(pxx))

linkaxes(ph)
xlim([0 100])