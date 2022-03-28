function [A2plot,faxis,taxis]=nr_tdcs_spectrogram_01(ecog_data,n_chan)

% variables
Fs=1024;
%WINDOW=1024; 
WINDOW=512; 
%NOVERLAP=924; % 90% overlap 
NOVERLAP=462;
%NFFT=2048;
NFFT=1024;
%NFFT=512;

%NFFT=2^nextpow2(size(ecog_data,1));
FRAME_ADVANCE=WINDOW-NOVERLAP;

% calculate spectrogram
for i=1:n_chan
    S(:,:,i)=spectrogram(ecog_data(:,i),WINDOW,NOVERLAP,NFFT,Fs);
end
% for i=1:6
%     S(:,:,i)=spectrogram(data.trials.t1.sig.ecog(:,i),WINDOW,NOVERLAP,NFFT,Fs);
% end

S_mag=abs(S);
[nfchans,nframes] = size(S_mag(:,:,1));
%[nfchans,nframes] = size(S_mag(:,:,:));
nfchansteps=nfchans-1;
maxfreq=Fs/2;
faxis=maxfreq*(0:nfchansteps)/nfchansteps;
t_res=FRAME_ADVANCE/Fs; % temporal resolution of spectrogram (sec)
%taxis=(0:(nframes-1))* t_res;
taxis=((512/2)/Fs:(nframes-1))* t_res; %(512/2)/Fs = 0.2560)



A2plot=log10(S_mag);
ff=find(faxis<=200);


% % Surf encodes data points at the edges and takes the color from
%         % the last edge so we need to add an additional point so that surf
%         % does the right thing. This is important especially when
%         % spectrogram has only one estimate (e.g. window length = signal
%         % length). Although this issue also exists on the frequency
%         % direction we will not add an extra row since we will never
%         % encounter a single frequency point estimate. For the plot we set
%         % time values to be at: nwin/2-a/2, nwin/2+a/2, nwin/2+3a/2,
%         % nwin/2+5a/2 ... where a is the number of new samples for each
%         % segment (i.e. nwind-noverlap). For the case of zero overlap this
%         % corresponds to 0, nwind, 2*nwind, ...        
%         a = nwind - noverlap;
%         t = [(nwind/2-a/2)/Fs  t+((a/2)/Fs)]; 
%         
%         [(WINDOW/2-FRAME_ADVANCE/2)/Fs (FRAME_ADVANCE/2)/FS
%         
%         Fs=1000;
% %WINDOW=1024; 
% WINDOW=512; 
% %NOVERLAP=924; % 90% overlap 
% NOVERLAP=462;
% %NFFT=1024;
% NFFT=512;
% FRAME_ADVANCE=WINDOW-NOVERLAP;
