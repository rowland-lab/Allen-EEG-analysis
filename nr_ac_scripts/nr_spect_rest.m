function nr_spec_rest1(dat_file)

%% variables
Fs=1000;
WINDOW=1024;           
NOVERLAP=924; % 90% overlap             
NFFT=1024;
FRAME_ADVANCE=WINDOW-NOVERLAP;

%% load data
load(dat_file);
 
dat_file_ps=strfind(dat_file,'ps_');
sbj=dat_file(dat_file_ps(1):dat_file_ps(1)+9);
dir=dat_file(1:max(strfind(dat_file,'/')));

cond_idx=strfind(dat_file,'rest');
cond=dat_file(cond_idx+5:end-4);

%% calculate spectrogram
n_data_ch=length(ecog.contact_pair);

for i=1:n_data_ch
    S(:,:,i)=spectrogram(ecog.contact_pair(i).remontaged_ecog_signal(mid_ecog_sig_segment),WINDOW,NOVERLAP,NFFT,Fs); 
end

S_mag=abs(S);

[nfchans,nframes] = size(S_mag(:,:,:));
nfchansteps=nfchans-1;
maxfreq=Fs/2;
faxis=maxfreq*(0:nfchansteps)/nfchansteps;
t_res=FRAME_ADVANCE/Fs;                     % temporal resolution of spectrogram (sec)
taxis=(0:(nframes-1))* t_res;

A2plot=log10(S_mag);
ff=find(faxis<=200);
val1=min(min(min(A2plot(1:ff,:,:))));
val2=max(max(max(A2plot(1:ff,:,:))));
%clims1 = [val1 val2];
clims1 = [-2 7];

figure;
%set(gcf,'Position',[100 10 560 740])
set(gcf,'Position',[50 10 560 740])
for i=1:n_data_ch
    subplot(7,4,i);
    hold(gca,'on');
    tmp1=A2plot(1:200,:,i); %chopping A2plot will allow the whole colobar to be represented
    faxis_new = faxis(1:200);
    imagesc(taxis,faxis_new,tmp1,clims1);
    hold(gca,'off');
    set(gca,'YDir','normal');
    set(gca,'XLim',[taxis(1) taxis(end)])
    set(gca,'YLim',[faxis_new(1) faxis_new(end)])
    if i==1;
        title([sbj(1:2),'\_',sbj(4:5),'\_',sbj(7:10),'  ',cond,'  ','rest']);
    else
        title(num2str(i))
    end
end

% put a color scale indicator next to the time-frequency plot
colorbar([0.9307 0.1048 0.02354 0.8226]);

