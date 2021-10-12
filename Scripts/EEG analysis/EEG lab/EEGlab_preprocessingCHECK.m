subject='pro00087153_0003';
protocolfolder='C:\Users\allen\Box Sync\Desktop\Allen_Rowland_EEG\protocol_00087153';

s1=load(fullfile(protocolfolder,subject,'analysis','EEGlab','Pre-ICA.mat'));
s2=load(fullfile(protocolfolder,subject,'analysis','EEGlab','ICA-Removed.mat'));

processingData=s1.eegevents.t1.processingData;

latency=5.715223880595295e+02;
eventtime=(latency+processingData{7}.VRsignal(1,1))/256;
channel=7;

figure;

% Plot import
subplot(6,2,1)
xdata=processingData{1}.data(channel,(eventtime*1024)-(0.5*1024):(eventtime*1024)+(1*1024));
ydata=(1:numel(xdata))/1024;
plot(ydata,xdata)
title(processingData{1}.details)
xlim([1 ydata(end)])
ylim([-40 40]);

% Plot Downsample
subplot(6,2,3)
xdata=processingData{2}.data(channel,(eventtime*256)-(0.5*256):(eventtime*256)+(1*256));
ydata=(1:numel(xdata))/256;
plot(ydata,xdata)
title(processingData{2}.details)
xlim([1 ydata(end)])
ylim([-40 40]);

% Plot High Pass Filter (0.5)
subplot(6,2,5)
xdata=processingData{3}.data(channel,(eventtime*256)-(0.5*256):(eventtime*256)+(1*256));
ydata=(1:numel(xdata))/256;
plot(ydata,xdata)
title(processingData{3}.details)
xlim([1 ydata(end)])
ylim([-40 40]);

% Plot Notch Filter 
subplot(6,2,7)
xdata=processingData{4}.data(channel,(eventtime*256)-(0.5*256):(eventtime*256)+(1*256));
ydata=(1:numel(xdata))/256;
plot(ydata,xdata)
title(processingData{4}.details)
xlim([1 ydata(end)])
ylim([-40 40]);

% Plot Removed bad channels and interpolate
subplot(6,2,9)
xdata=processingData{5}.data(channel,(eventtime*256)-(0.5*256):(eventtime*256)+(1*256));
ydata=(1:numel(xdata))/256;
plot(ydata,xdata)
title(processingData{5}.details)
xlim([1 ydata(end)])
ylim([-40 40]);

% Plot rereference to average
subplot(6,2,11)
xdata=processingData{6}.data(channel,(eventtime*256)-(0.5*256):(eventtime*256)+(1*256));
ydata=(1:numel(xdata))/256;
plot(ydata,xdata)
title(processingData{6}.details)
xlim([1 ydata(end)])
ylim([-40 40]);

% Plot epoch trial
subplot(6,2,2)
xdata=processingData{7}.data(channel,latency-(0.5*256):latency+(1*256),1);
ydata=(1:numel(xdata))/256;
plot(ydata,xdata)
title(processingData{7}.details)
xlim([1 ydata(end)])
ylim([-40 40]);

% Plot Artifact Subspace Reconstruction
subplot(6,2,4)
xdata=processingData{8}.data(channel,latency-(0.5*256):latency+(1*256),1);
ydata=(1:numel(xdata))/256;
plot(ydata,xdata)
title(processingData{8}.details)
xlim([1 ydata(end)])
ylim([-40 40]);

% Plot second rereferencing
subplot(6,2,6)
xdata=processingData{9}.data(channel,latency-(0.5*256):latency+(1*256),1);
ydata=(1:numel(xdata))/256;
plot(ydata,xdata)
title(processingData{9}.details)
xlim([1 ydata(end)])
ylim([-40 40]);

% Plot reach epoch
subplot(6,2,8)
xdata=processingData{10}.data(channel,:,1);
ydata=(1:numel(xdata))/256;
plot(ydata,xdata)
title(processingData{10}.details)
xlim([1 ydata(end)])
ylim([-40 40]);

% Plot ICA removed epoch
subplot(6,2,10)
xdata=s2.eegevents.t1.data(channel,:,1);
ydata=(1:numel(xdata))/256;
plot(ydata,xdata)
title('ICA removed (heart)')
xlim([1 ydata(end)])
ylim([-40 40]);
