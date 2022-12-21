clear
clc

subject='pro00087153_0003';
protocolfolder = 'C:\Users\Allen\Documents\data';
trial='t1';

%% Load/define data

% Load matfile
matfile = load(fullfile(protocolfolder,subject,'analysis','EEGlab','EEGlab_Total.mat'));

% Dedicate trial data
trialData = matfile.eegevents_icarem.trials.(trial);
processingData = trialData.processingData;

% Channel
channel=18;
%% Create figure
figure;
sgtitle([subject,' - ',trial,' - Channel ',num2str(channel)],'Interpreter','none')

% Plot import
subplot(6,6,[1 2])
eventtime = processingData{1}.events(1).latency;
fs = 1024;
xdata=processingData{1}.data(channel,(eventtime)-(0.5*fs):(eventtime)+(1*fs));
ydata=(1:numel(xdata))/fs;
plot(ydata,xdata)
title(processingData{1}.details)
xlim([0 ydata(end)])
ylim([-40 40]);

ph(1)=subplot(6,6,3);
[pxx,f]=pwelch(xdata,[],[],[],fs);
plot(f,log10(pxx));
xlim([0 100])
ylim([-4 0.5])

% Plot Downsample
subplot(6,6,[7 8])
fs=256;
eventtime = processingData{2}.events(1).latency;
xdata=processingData{2}.data(channel,(eventtime)-(0.5*fs):(eventtime)+(1*fs));
ydata=(1:numel(xdata))/fs;
plot(ydata,xdata)
title(processingData{2}.details)
xlim([0 ydata(end)])
ylim([-40 40]);

ph(2)=subplot(6,6,9);
[pxx,f]=pwelch(xdata,[],[],[],fs);
plot(f,log10(pxx));
xlim([0 100])
ylim([-4 0.5])

% Plot High Pass Filter (0.5)
subplot(6,6,[13 14])
eventtime = processingData{3}.events(1).latency;
xdata=processingData{3}.data(channel,(eventtime)-(0.5*fs):(eventtime)+(1*fs));
ydata=(1:numel(xdata))/fs;
plot(ydata,xdata)
title(processingData{3}.details)
xlim([0 ydata(end)])
ylim([-40 40]);

ph(3)=subplot(6,6,15);
[pxx,f]=pwelch(xdata,[],[],[],fs);
plot(f,log10(pxx));
xlim([0 100])
ylim([-4 0.5])

% Plot Notch Filter 
subplot(6,6,[19 20])
eventtime = processingData{4}.events(1).latency;
xdata=processingData{4}.data(channel,(eventtime)-(0.5*fs):(eventtime)+(1*fs));
ydata=(1:numel(xdata))/fs;
plot(ydata,xdata)
title(processingData{4}.details)
xlim([0 ydata(end)])
ylim([-40 40]);

ph(4)=subplot(6,6,21);
[pxx,f]=pwelch(xdata,[],[],[],fs);
plot(f,log10(pxx));
xlim([0 100])
ylim([-4 0.5])

% Plot Removed bad channels and interpolate
subplot(6,6,[25 26])
eventtime = processingData{5}.events(1).latency;
xdata=processingData{5}.data(channel,(eventtime)-(0.5*fs):(eventtime)+(1*fs));
ydata=(1:numel(xdata))/fs;
plot(ydata,xdata)
title(processingData{5}.details)
xlim([0 ydata(end)])
ylim([-40 40]);

ph(5)=subplot(6,6,27);
[pxx,f]=pwelch(xdata,[],[],[],fs);
plot(f,log10(pxx));
xlim([0 100])
ylim([-4 0.5])

% Plot ICA removed
subplot(6,6,[31 32])
eventtime = processingData{6}.events(1).latency;
xdata=processingData{6}.data(channel,(eventtime)-(0.5*fs):(eventtime)+(1*fs));
ydata=(1:numel(xdata))/fs;
plot(ydata,xdata)
title(processingData{6}.details)
xlim([0 ydata(end)])
ylim([-40 40]);

ph(6)=subplot(6,6,33);
[pxx,f]=pwelch(xdata,[],[],[],fs);
plot(f,log10(pxx));
xlim([0 100])
ylim([-4 0.5])

% Plot find bad channels and interpolate
subplot(6,6,[4 5])
eventtime = processingData{7}.events(1).latency;
xdata=processingData{7}.data(channel,eventtime-(0.5*fs):eventtime+(1*fs),1);
ydata=(1:numel(xdata))/fs;
plot(ydata,xdata)
title(processingData{7}.details)
xlim([0 ydata(end)])
ylim([-40 40]);

ph(7)=subplot(6,6,6);
[pxx,f]=pwelch(xdata,[],[],[],fs);
plot(f,log10(pxx));
xlim([0 100])
ylim([-4 0.5])

% Plot Artifact Subspace Reconstruction
subplot(6,6,[10 11])
eventtime = processingData{8}.events(1).latency;
xdata=processingData{8}.data(channel,eventtime-(0.5*fs):eventtime+(1*fs),1);
ydata=(1:numel(xdata))/fs;
plot(ydata,xdata)
title(processingData{8}.details)
xlim([0 ydata(end)])
ylim([-40 40]);

ph(8)=subplot(6,6,12);
[pxx,f]=pwelch(xdata,[],[],[],fs);
plot(f,log10(pxx));
xlim([0 100])
ylim([-4 0.5])
