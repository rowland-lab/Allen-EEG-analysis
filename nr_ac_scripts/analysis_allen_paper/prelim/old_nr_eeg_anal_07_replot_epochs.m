function nr_eeg_anal_07_replot_epochs(data_file)

%data_file=data_eeg_anal_rest_pro00087153_0003;
data=data_eeg_anal_rest_pro00087153_0004;
data=data_file;
n_trial=data.cfg.info.n_trial;

% filters
[n1_b, n1_a]=butter(3,2*[57 63]/data.cfg.info.Fs,'stop');%60 Hz
[n2_b, n2_a]=butter(3,2*[117 123]/data.cfg.info.Fs,'stop');%120 Hz
[n3_b, n3_a]=butter(3,2*[177 183]/data.cfg.info.Fs,'stop');%180 Hz

% parse epochs
for i=1:size(n_trial,2)
    names_epoch=fieldnames(data.trials);
end

for i=1:size(n_trial,2)
    num_epoch(i)=size(fieldnames(eval(['data.trials.',names_epoch{i},'.epochs'])),1);
end

mat_trial_epoch_sort=sortrows([n_trial;num_epoch]');
mat_trial_epoch=[(1:size(n_trial,2))',mat_trial_epoch_sort(:,1),mat_trial_epoch_sort(:,2)];
data.cfg.info.mat_trial_epoch=mat_trial_epoch;

%define new epochs
e1_7_st=data.trials.t1.epochs_new.e1_7(1,1)
e1_7_ed=data.trials.t1.epochs_new.e1_7(1,2)
e1_18_st=data.trials.t1.epochs_new.e1_18(1,1)
e1_18_ed=data.trials.t1.epochs_new.e1_18(1,2)

e2_7_st=data.trials.t1.epochs_new.e2_7(1,1)
e2_7_ed=data.trials.t1.epochs_new.e2_7(1,2)
e2_18_st=data.trials.t1.epochs_new.e2_18(1,1)
e2_18_ed=data.trials.t1.epochs_new.e2_18(1,2)

e3_7_st=data.trials.t1.epochs_new.e3_7(1,1)
e3_7_ed=data.trials.t1.epochs_new.e3_7(1,2)
e3_18_st=data.trials.t1.epochs_new.e3_18(1,1)
e3_18_ed=data.trials.t1.epochs_new.e3_18(1,2)

e4_7_st=data.trials.t1.epochs_new.e4_7(1,1)
e4_7_ed=data.trials.t1.epochs_new.e4_7(1,2)
e4_18_st=data.trials.t1.epochs_new.e4_18(1,1)
e4_18_ed=data.trials.t1.epochs_new.e4_18(1,2)

%need to add ch23 back in for plotting purposes
for i=1:size(n_trial,2)
    eval(['[temp_struct,temp.t',num2str(i)','.sig.all]=edfread(data.cfg.trial_data.t',num2str(i),'.filename);'])
    %eval(['temp.t',num2str(i),'.sig.trig=resample(double(temp.t',num2str(i),'.sig.all.streams.Trig.data)'',2^10,5^5);'])
    %eval(['temp.t',num2str(i),'.sig.ecog=filtfilt(n3_b,n3_a,filtfilt(n2_b,n2_a,resample(double(temp.t',num2str(i),'.sig.all.streams.ECOG.data)'',2^10,5^5)));'])
    %eval(['temp.t',num2str(i),'.sig.eeg=filtfilt(temp.t',num2str(i),'.sig.all)''));'])
    %eval(['temp.t',num2str(i),'.sig.amps=resample(double(temp.t',num2str(i),'.sig.all.streams.amps.data)'',2^10,5^5);'])
    %eval(['temp.t',num2str(i),'.sig.sync=resample(double(temp.t',num2str(i),'.sig.all.streams.Sync.data)'',2^10,5^5);'])
end

data.trials.t1.sig.eeg=temp.t1.sig.all(1:22,:)';
data.trials.t1.sig.eeg=filtfilt(n1_b,n1_a,data.trials.t1.sig.eeg);
data.trials.t1.sig.eeg=filtfilt(n2_b,n2_a,data.trials.t1.sig.eeg);
data.trials.t1.sig.eeg=filtfilt(n3_b,n3_a,data.trials.t1.sig.eeg);
data.trials.t1.sig.eeg(:,23)=temp.t1.sig.all(41,:);

% plot data with epochs
figure; hold on
subplot(1,2,1)
set(gcf,'Position',[6 56 1487 1412])
for i=1:size(n_trial,2)
    for j=1:23%size(data.cfg.info.i_chan,2)
%         if j==1
%             figure; set(gcf,'Position',[6 56 1487 1412])
%         end
        if j==23
            eval(['plot(data.trials.t',num2str(i),'.sig.eeg(:,',num2str(j),')/10e2-j*1e3)']); hold on
        else
            eval(['plot(data.trials.t',num2str(i),'.sig.eeg(:,',num2str(j),')*2-j*1e3)']); hold on
        end
    end
    yplotlim=get(gca,'ylim');
    %eval(['plot(data.trials.t',num2str(i),'.sig.sync(:,1))']);
    %eval(['plot(data.trials.t',num2str(i),'.sig.trig(:,1))']);
    %eval(['plot(data.trials.t',num2str(i),'.sig.amps(:,1)/100)']);
    for k=1:mat_trial_epoch(i,3)
        eval(['plot([data.trials.t',num2str(i),'.epochs.e',num2str(k),'(1) data.trials.t',num2str(i),'.epochs.e',num2str(k),'(1)],[yplotlim(1) yplotlim(2)],''g'')']);
        eval(['plot([data.trials.t',num2str(i),'.epochs.e',num2str(k),'(2) data.trials.t',num2str(i),'.epochs.e',num2str(k),'(2)],[yplotlim(1) yplotlim(2)],''r'')']);
    end
    %legend('Lch1','Lch2','Lch3','Lch4','Lch5','Lch6','current')
    %title(eval(['data.cfg.trial_data.t',num2str(i),'.cond']))
    %use this instead title(['s',data.cfg.info.n_sbj,' t',num2str(i),' ',eval(['data.cfg.trial_data.t',num2str(i),'.cond']),' e',num2str(j),' all channels'])
            
end
title(['pro00087153 00',data.cfg.info.n_sbj,' ',data.cfg.trial_data.t1.cond])

subplot(4,2,2); hold on
plot(data.trials.t1.sig.eeg(:,7))
plot(data.trials.t1.sig.eeg(:,18)-300)
plot(data.trials.t1.sig.eeg(:,23)/1e4-400)
set(gca,'xlim',[data.trials.t1.epochs.e1(1)-100000 data.trials.t1.epochs.e1(2)+100000])
ylim_e1=get(gca,'ylim')
plot([data.trials.t1.epochs.e1(1) data.trials.t1.epochs.e1(1)],[ylim_e1(1) ylim_e1(2)],'g')
plot([data.trials.t1.epochs.e1(2) data.trials.t1.epochs.e1(2)],[ylim_e1(1) ylim_e1(2)],'r')

plot([data.trials.t1.epochs_new.e1_7(1) data.trials.t1.epochs_new.e1_7(2)],[100 100],'k')
plot([data.trials.t1.epochs_new.e1_7(1) data.trials.t1.epochs_new.e1_7(2)],[-100 -100],'k')
plot([data.trials.t1.epochs_new.e1_7(1) data.trials.t1.epochs_new.e1_7(1)],[-100 100],'k')
plot([data.trials.t1.epochs_new.e1_7(2) data.trials.t1.epochs_new.e1_7(2)],[-100 100],'k')

plot([data.trials.t1.epochs_new.e1_18(1) data.trials.t1.epochs_new.e1_18(2)],[-200 -200],'k')
plot([data.trials.t1.epochs_new.e1_18(1) data.trials.t1.epochs_new.e1_18(2)],[-400 -400],'k')
plot([data.trials.t1.epochs_new.e1_18(1) data.trials.t1.epochs_new.e1_18(1)],[-400 -200],'k')
plot([data.trials.t1.epochs_new.e1_18(2) data.trials.t1.epochs_new.e1_18(2)],[-400 -200],'k')
title('e1')

subplot(4,2,4); hold on
plot(data.trials.t1.sig.eeg(:,7))
plot(data.trials.t1.sig.eeg(:,18)-300)
plot(data.trials.t1.sig.eeg(:,23)/1e4-400)
set(gca,'xlim',[data.trials.t1.epochs.e2(1)-100000 data.trials.t1.epochs.e2(2)+100000])
ylim_e2=get(gca,'ylim')
plot([data.trials.t1.epochs.e2(1) data.trials.t1.epochs.e2(1)],[ylim_e2(1) ylim_e2(2)],'g')
plot([data.trials.t1.epochs.e2(2) data.trials.t1.epochs.e2(2)],[ylim_e2(1) ylim_e2(2)],'r')

plot([data.trials.t1.epochs_new.e2_7(1) data.trials.t1.epochs_new.e2_7(2)],[100 100],'k')
plot([data.trials.t1.epochs_new.e2_7(1) data.trials.t1.epochs_new.e2_7(2)],[-100 -100],'k')
plot([data.trials.t1.epochs_new.e2_7(1) data.trials.t1.epochs_new.e2_7(1)],[-100 100],'k')
plot([data.trials.t1.epochs_new.e2_7(2) data.trials.t1.epochs_new.e2_7(2)],[-100 100],'k')

plot([data.trials.t1.epochs_new.e2_18(1) data.trials.t1.epochs_new.e2_18(2)],[-200 -200],'k')
plot([data.trials.t1.epochs_new.e2_18(1) data.trials.t1.epochs_new.e2_18(2)],[-400 -400],'k')
plot([data.trials.t1.epochs_new.e2_18(1) data.trials.t1.epochs_new.e2_18(1)],[-400 -200],'k')
plot([data.trials.t1.epochs_new.e2_18(2) data.trials.t1.epochs_new.e2_18(2)],[-400 -200],'k')
title('e2')

subplot(4,2,6); hold on
plot(data.trials.t1.sig.eeg(:,7))
plot(data.trials.t1.sig.eeg(:,18)-300)
plot(data.trials.t1.sig.eeg(:,23)/1e4-400)
set(gca,'xlim',[data.trials.t1.epochs.e3(1)-100000 data.trials.t1.epochs.e3(2)+100000])
ylim_e3=get(gca,'ylim')
plot([data.trials.t1.epochs.e3(1) data.trials.t1.epochs.e3(1)],[ylim_e3(1) ylim_e3(2)],'g')
plot([data.trials.t1.epochs.e3(2) data.trials.t1.epochs.e3(2)],[ylim_e3(1) ylim_e3(2)],'r')

plot([data.trials.t1.epochs_new.e3_7(1) data.trials.t1.epochs_new.e3_7(2)],[100 100],'k')
plot([data.trials.t1.epochs_new.e3_7(1) data.trials.t1.epochs_new.e3_7(2)],[-100 -100],'k')
plot([data.trials.t1.epochs_new.e3_7(1) data.trials.t1.epochs_new.e3_7(1)],[-100 100],'k')
plot([data.trials.t1.epochs_new.e3_7(2) data.trials.t1.epochs_new.e3_7(2)],[-100 100],'k')

plot([data.trials.t1.epochs_new.e3_18(1) data.trials.t1.epochs_new.e3_18(2)],[-200 -200],'k')
plot([data.trials.t1.epochs_new.e3_18(1) data.trials.t1.epochs_new.e3_18(2)],[-400 -400],'k')
plot([data.trials.t1.epochs_new.e3_18(1) data.trials.t1.epochs_new.e3_18(1)],[-400 -200],'k')
plot([data.trials.t1.epochs_new.e3_18(2) data.trials.t1.epochs_new.e3_18(2)],[-400 -200],'k')
title('e3')

subplot(4,2,8); hold on
plot(data.trials.t1.sig.eeg(:,7))
plot(data.trials.t1.sig.eeg(:,18)-300)
plot(data.trials.t1.sig.eeg(:,23)/1e4-400)
set(gca,'xlim',[data.trials.t1.epochs.e4(1)-100000 data.trials.t1.epochs.e4(2)+100000])
ylim_e4=get(gca,'ylim')
plot([data.trials.t1.epochs.e4(1) data.trials.t1.epochs.e4(1)],[ylim_e4(1) ylim_e4(2)],'g')
plot([data.trials.t1.epochs.e4(2) data.trials.t1.epochs.e4(2)],[ylim_e4(1) ylim_e4(2)],'r')

plot([data.trials.t1.epochs_new.e4_7(1) data.trials.t1.epochs_new.e4_7(2)],[100 100],'k')
plot([data.trials.t1.epochs_new.e4_7(1) data.trials.t1.epochs_new.e4_7(2)],[-100 -100],'k')
plot([data.trials.t1.epochs_new.e4_7(1) data.trials.t1.epochs_new.e4_7(1)],[-100 100],'k')
plot([data.trials.t1.epochs_new.e4_7(2) data.trials.t1.epochs_new.e4_7(2)],[-100 100],'k')

plot([data.trials.t1.epochs_new.e4_18(1) data.trials.t1.epochs_new.e4_18(2)],[-200 -200],'k')
plot([data.trials.t1.epochs_new.e4_18(1) data.trials.t1.epochs_new.e4_18(2)],[-400 -400],'k')
plot([data.trials.t1.epochs_new.e4_18(1) data.trials.t1.epochs_new.e4_18(1)],[-400 -200],'k')
plot([data.trials.t1.epochs_new.e4_18(2) data.trials.t1.epochs_new.e4_18(2)],[-400 -200],'k')
title('e4')






%data.trials.t1.sig.eeg(:,23)=[];

assignin('base','data',data)

