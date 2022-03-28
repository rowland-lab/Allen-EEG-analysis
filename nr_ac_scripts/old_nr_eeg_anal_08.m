nr_eeg_anal_07_replot_epochs(data_eeg_anal_rest_pro00087153_0003)

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
















set(gca,'XTickLabel',

eval(['plot(data.trials.t',num2str(i),'.sig.eeg(:,',num2str(j),')*2-j*1e4)']); hold on

figure; plot(data_eeg_anal_rest_pro00087153_0003

figure; plot(temp.t1.sig.all(41,:))



