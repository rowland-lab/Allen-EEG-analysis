function nr_eeg_anal_02_cfg(filename,dx,stim_stat,cond)



%% cfg 
data.cfg.info.n_sbj=filename(47:48);
data.cfg.info.i_chan=[1:22];
data.cfg.info.dx=dx;
data.cfg.info.Fs=1024;
data.cfg.info.stim_stat=stim_stat;
data.cfg.trial_data.t1.cond=cond;

data.cfg.trial_data.t1.filename=filename;

% freq bands
data.cfg.info.frq_band_txt{1}='delta';
data.cfg.info.frq_band_txt{2}='theta';
data.cfg.info.frq_band_txt{3}='alpha';
data.cfg.info.frq_band_txt{4}='beta';
data.cfg.info.frq_band_txt{5}='gamma_l';
data.cfg.info.frq_band_txt{6}='gamma_bb';
data.cfg.info.frq_band_ind{1}=['2:3'];
data.cfg.info.frq_band_ind{2}=['3:5'];
data.cfg.info.frq_band_ind{3}=['5:7'];
data.cfg.info.frq_band_ind{4}=['8:16'];
data.cfg.info.frq_band_ind{5}=['16:27'];
data.cfg.info.frq_band_ind{6}=['37:103'];

% filters
[n1_b, n1_a]=butter(3,2*[57 63]/data.cfg.info.Fs,'stop');%60 Hz
[n2_b, n2_a]=butter(3,2*[117 123]/data.cfg.info.Fs,'stop');%120 Hz
[n3_b, n3_a]=butter(3,2*[177 183]/data.cfg.info.Fs,'stop');%180 Hz

% parse trials
names_trial_num=regexp(fieldnames(data.cfg.trial_data),'[0-9]','match');
for i=1:size(names_trial_num,1)
    n_trial(i)=str2double(names_trial_num{i});
end

data.cfg.info.n_trial=n_trial;
%Hold on this code until we get more of the correct inputs
% resample and filter signals
for i=1:size(n_trial,2)
    eval(['[temp_struct,temp.t',num2str(i)','.sig.all]=edfread(data.cfg.trial_data.t',num2str(i),'.filename);'])
    %eval(['temp.t',num2str(i),'.sig.trig=resample(double(temp.t',num2str(i),'.sig.all.streams.Trig.data)'',2^10,5^5);'])
    %eval(['temp.t',num2str(i),'.sig.ecog=filtfilt(n3_b,n3_a,filtfilt(n2_b,n2_a,resample(double(temp.t',num2str(i),'.sig.all.streams.ECOG.data)'',2^10,5^5)));'])
    %eval(['temp.t',num2str(i),'.sig.eeg=filtfilt(temp.t',num2str(i),'.sig.all)''));'])
    %eval(['temp.t',num2str(i),'.sig.amps=resample(double(temp.t',num2str(i),'.sig.all.streams.amps.data)'',2^10,5^5);'])
    %eval(['temp.t',num2str(i),'.sig.sync=resample(double(temp.t',num2str(i),'.sig.all.streams.Sync.data)'',2^10,5^5);'])
end

% for i=1:size(n_trial,2)
%     eval(['data.trials.t',num2str(i),'.sig.trig=temp.t',num2str(i),'.sig.trig'])
%     eval(['data.trials.t',num2str(i),'.sig.ecog=temp.t',num2str(i),'.sig.ecog'])
%     eval(['data.trials.t',num2str(i),'.sig.amps=temp.t',num2str(i),'.sig.amps'])
%     eval(['data.trials.t',num2str(i),'.sig.sync=temp.t',num2str(i),'.sig.sync'])
% end

data.trials.t1.sig.eeg=temp.t1.sig.all(1:22,:)';
data.trials.t1.sig.eeg=filtfilt(n1_b,n1_a,data.trials.t1.sig.eeg);
data.trials.t1.sig.eeg=filtfilt(n2_b,n2_a,data.trials.t1.sig.eeg);
data.trials.t1.sig.eeg=filtfilt(n3_b,n3_a,data.trials.t1.sig.eeg);
data.trials.t1.sig.eeg(:,23)=temp.t1.sig.all(41,:);


% %plot data (unscaled)
% for i=1:size(n_trial,2)
%     for j=1:22%40%size(data.cfg.info.i_chan,2)
%         if j==1
%             figure
%             set(gcf,'Position',[3007 49 820 1419])
%         end
%         eval(['plot(data.trials.t',num2str(i),'.sig.eeg(:,',num2str(j),')*10+j*1e4)']); hold on
%     end
% %     eval(['plot(data.trials.t',num2str(i),'.sig.sync(:,1))']);
% %     eval(['plot(data.trials.t',num2str(i),'.sig.trig(:,1))']);
% %     eval(['plot(data.trials.t',num2str(i),'.sig.amps(:,1))']);
% %     legend('Lch1','Lch2','Lch3','Lch4','Lch5','Lch6','sync','trig','amps')
%     %title(eval(['data.cfg.trial_data.t',num2str(i),'.cond']))
% end

%do this manually
figure; 
%set(gcf,'Position',[549   303   583   767]); hold on
set(gcf,'Position',[6 56 830 1412]); hold on
plot(data.trials.t1.sig.eeg(:,1)*2)
plot(data.trials.t1.sig.eeg(:,2)*2-1000)
plot(data.trials.t1.sig.eeg(:,3)*2-2000)
plot(data.trials.t1.sig.eeg(:,4)*2-3000)
plot(data.trials.t1.sig.eeg(:,5)*2-4000)
plot(data.trials.t1.sig.eeg(:,6)*2-5000)
plot(data.trials.t1.sig.eeg(:,7)*2-6000)
plot(data.trials.t1.sig.eeg(:,8)*2-7000)
plot(data.trials.t1.sig.eeg(:,9)*2-8000)
plot(data.trials.t1.sig.eeg(:,10)*2-9000)
plot(data.trials.t1.sig.eeg(:,11)*2-10000)
plot(data.trials.t1.sig.eeg(:,12)*2-11000)
plot(data.trials.t1.sig.eeg(:,13)*2-12000)
plot(data.trials.t1.sig.eeg(:,14)*2-13000)
plot(data.trials.t1.sig.eeg(:,15)*2-14000)
plot(data.trials.t1.sig.eeg(:,16)*2-15000)
plot(data.trials.t1.sig.eeg(:,17)*2-16000)
plot(data.trials.t1.sig.eeg(:,18)*2-17000)
plot(data.trials.t1.sig.eeg(:,19)*2-18000)
plot(data.trials.t1.sig.eeg(:,20)*2-19000)
plot(data.trials.t1.sig.eeg(:,21)*2-20000)
plot(data.trials.t1.sig.eeg(:,22)*2-21000)
plot(data.trials.t1.sig.eeg(:,23)/1e3-22000)
set(gca,'ylim',[-4e4 0.5e4])
legend('Fp1','F7 ','T3 ','T5 ','O1 ','F3 ','C3 ','P3 ','A1 ','Fz ','Cz ','Fp2','F8 ',...
    'T4 ','T6 ','O2 ','F4 ','C4 ','P4 ','A2 ','Fpz ','Pz ','VR ')
title(['pro00087153 00',data.cfg.info.n_sbj])


assignin('base','data',data)
assignin('base','temp',temp)
