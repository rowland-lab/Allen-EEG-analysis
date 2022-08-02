function nr_eeg_anal_05_replot_data_orig(data_file)

%%%%data_file='~/nr_data_analysis/data_analyzed/eeg/data_eeg_anal_move_pro00087153_0005.mat'
load(data_file)
data=eval(data_file(38:72))

figure
set(gcf,'Position',[4 570 900 910])

subplot(4,4,1); hold on
plot(log10(data.trials.t1.psd.e1.saw(1:103,7)))
plot(log10(data.trials.t1.psd.e1.saw(1:103,18)))
title([data.cfg.info.dx,' ',data.cfg.info.stim_stat,' e1 ',...
    data.cfg.info.n_sbj,' ',data.cfg.trial_data.t1.cond])
legend('7','18')
y_lim_01_1=get(gca,'ylim');

subplot(4,4,5); hold on
plot(log10(data.trials.t1.psd.e2.saw(1:103,7)))
plot(log10(data.trials.t1.psd.e2.saw(1:103,18)))
title('e2')
legend('7','18')
y_lim_01_2=get(gca,'ylim');

subplot(4,4,9); hold on
plot(log10(data.trials.t1.psd.e3.saw(1:103,7)))
plot(log10(data.trials.t1.psd.e3.saw(1:103,18)))
title('e3')
legend('7','18')
y_lim_01_3=get(gca,'ylim');

subplot(4,4,13); hold on
plot(log10(data.trials.t1.psd.e4.saw(1:103,7)))
plot(log10(data.trials.t1.psd.e4.saw(1:103,18)))
title('e4')
legend('7','18')
y_lim_01_4=get(gca,'ylim');

subplot(4,4,1)
set(gca,'ylim',[min([y_lim_01_1(1) y_lim_01_2(1) y_lim_01_3(1) y_lim_01_4(1)]),...
    max([y_lim_01_1(2) y_lim_01_2(2) y_lim_01_3(2) y_lim_01_4(2)])])
subplot(4,4,5)
set(gca,'ylim',[min([y_lim_01_1(1) y_lim_01_2(1) y_lim_01_3(1) y_lim_01_4(1)]),...
    max([y_lim_01_1(2) y_lim_01_2(2) y_lim_01_3(2) y_lim_01_4(2)])])
subplot(4,4,9)
set(gca,'ylim',[min([y_lim_01_1(1) y_lim_01_2(1) y_lim_01_3(1) y_lim_01_4(1)]),...
    max([y_lim_01_1(2) y_lim_01_2(2) y_lim_01_3(2) y_lim_01_4(2)])])
subplot(4,4,13)
set(gca,'ylim',[min([y_lim_01_1(1) y_lim_01_2(1) y_lim_01_3(1) y_lim_01_4(1)]),...
    max([y_lim_01_1(2) y_lim_01_2(2) y_lim_01_3(2) y_lim_01_4(2)])])
%

subplot(4,4,2); hold on
bar(data.trials.t1.psd.e1.sai.means.beta(:,7))
mean_sai_means_e1_7=mean(data.trials.t1.psd.e1.sai.means.beta(:,7));
std_sai_means_e1_7=std(data.trials.t1.psd.e1.sai.means.beta(:,7));
plot([0 size(data.trials.t1.psd.e1.sai.means.beta(:,7),1)],...
    [mean_sai_means_e1_7 mean_sai_means_e1_7],'r','LineWidth',2)
plot([0 size(data.trials.t1.psd.e1.sai.means.beta(:,7),1)],...
    [mean_sai_means_e1_7+3*std_sai_means_e1_7 mean_sai_means_e1_7+3*std_sai_means_e1_7],'--r','LineWidth',2)
title('e1 7')
y_lim_02_1=get(gca,'ylim');

subplot(4,4,3); hold on
bar(data.trials.t1.psd.e1.sai.means.beta(:,18))
title('e1 18')
y_lim_02_2=get(gca,'ylim');
mean_sai_means_e1_18=mean(data.trials.t1.psd.e1.sai.means.beta(:,18));
std_sai_means_e1_18=std(data.trials.t1.psd.e1.sai.means.beta(:,18));
plot([0 size(data.trials.t1.psd.e1.sai.means.beta(:,18),1)],...
    [mean_sai_means_e1_18 mean_sai_means_e1_18],'r','LineWidth',2)
plot([0 size(data.trials.t1.psd.e1.sai.means.beta(:,18),1)],...
    [mean_sai_means_e1_18+3*std_sai_means_e1_18 mean_sai_means_e1_18+3*std_sai_means_e1_18],'--r','LineWidth',2)

subplot(4,4,6); hold on
bar(data.trials.t1.psd.e2.sai.means.beta(:,7))
title('e2 7')
y_lim_02_3=get(gca,'ylim');
mean_sai_means_e2_7=mean(data.trials.t1.psd.e2.sai.means.beta(:,7));
std_sai_means_e2_7=std(data.trials.t1.psd.e2.sai.means.beta(:,7));
plot([0 size(data.trials.t1.psd.e2.sai.means.beta(:,7),1)],...
    [mean_sai_means_e2_7 mean_sai_means_e2_7],'r','LineWidth',2)
plot([0 size(data.trials.t1.psd.e2.sai.means.beta(:,7),1)],...
    [mean_sai_means_e2_7+3*std_sai_means_e2_7 mean_sai_means_e2_7+3*std_sai_means_e2_7],'--r','LineWidth',2)

subplot(4,4,7); hold on
bar(data.trials.t1.psd.e2.sai.means.beta(:,18))
title('e2 18')
y_lim_02_4=get(gca,'ylim');
mean_sai_means_e2_18=mean(data.trials.t1.psd.e2.sai.means.beta(:,18));
std_sai_means_e2_18=std(data.trials.t1.psd.e2.sai.means.beta(:,18));
plot([0 size(data.trials.t1.psd.e2.sai.means.beta(:,18),1)],...
    [mean_sai_means_e2_18 mean_sai_means_e2_18],'r','LineWidth',2)
plot([0 size(data.trials.t1.psd.e2.sai.means.beta(:,18),1)],...
    [mean_sai_means_e2_18+3*std_sai_means_e2_18 mean_sai_means_e2_18+3*std_sai_means_e2_18],'--r','LineWidth',2)

subplot(4,4,10); hold on
bar(data.trials.t1.psd.e3.sai.means.beta(:,7))
title('e3 7')
y_lim_02_5=get(gca,'ylim');
mean_sai_means_e3_7=mean(data.trials.t1.psd.e3.sai.means.beta(:,7));
std_sai_means_e3_7=std(data.trials.t1.psd.e3.sai.means.beta(:,7));
plot([0 size(data.trials.t1.psd.e3.sai.means.beta(:,7),1)],...
    [mean_sai_means_e3_7 mean_sai_means_e3_7],'r','LineWidth',2)
plot([0 size(data.trials.t1.psd.e3.sai.means.beta(:,7),1)],...
    [mean_sai_means_e3_7+3*std_sai_means_e3_7 mean_sai_means_e3_7+3*std_sai_means_e3_7],'--r','LineWidth',2)

subplot(4,4,11); hold on
bar(data.trials.t1.psd.e3.sai.means.beta(:,18))
title('e3 18')
y_lim_02_6=get(gca,'ylim');
mean_sai_means_e3_18=mean(data.trials.t1.psd.e3.sai.means.beta(:,18));
std_sai_means_e3_18=std(data.trials.t1.psd.e3.sai.means.beta(:,18));
plot([0 size(data.trials.t1.psd.e3.sai.means.beta(:,18),1)],...
    [mean_sai_means_e3_18 mean_sai_means_e3_18],'r','LineWidth',2)
plot([0 size(data.trials.t1.psd.e3.sai.means.beta(:,18),1)],...
    [mean_sai_means_e3_18+3*std_sai_means_e3_18 mean_sai_means_e3_18+3*std_sai_means_e3_18],'--r','LineWidth',2)

subplot(4,4,14); hold on
bar(data.trials.t1.psd.e4.sai.means.beta(:,7))
title('e4 7')
y_lim_02_7=get(gca,'ylim');
mean_sai_means_e4_7=mean(data.trials.t1.psd.e4.sai.means.beta(:,7));
std_sai_means_e4_7=std(data.trials.t1.psd.e4.sai.means.beta(:,7));
plot([0 size(data.trials.t1.psd.e4.sai.means.beta(:,7),1)],...
    [mean_sai_means_e4_7 mean_sai_means_e4_7],'r','LineWidth',2)
plot([0 size(data.trials.t1.psd.e4.sai.means.beta(:,7),1)],...
    [mean_sai_means_e4_7+3*std_sai_means_e4_7 mean_sai_means_e4_7+3*std_sai_means_e4_7],'--r','LineWidth',2)

subplot(4,4,15); hold on
bar(data.trials.t1.psd.e4.sai.means.beta(:,18))
title('e4 18')
y_lim_02_8=get(gca,'ylim');
mean_sai_means_e4_18=mean(data.trials.t1.psd.e4.sai.means.beta(:,18));
std_sai_means_e4_18=std(data.trials.t1.psd.e4.sai.means.beta(:,18));
plot([0 size(data.trials.t1.psd.e4.sai.means.beta(:,18),1)],...
    [mean_sai_means_e4_18 mean_sai_means_e4_18],'r','LineWidth',2)
plot([0 size(data.trials.t1.psd.e4.sai.means.beta(:,18),1)],...
    [mean_sai_means_e4_18+3*std_sai_means_e4_18 mean_sai_means_e4_18+3*std_sai_means_e4_18],'--r','LineWidth',2)


subplot(4,4,2)
set(gca,'ylim',[min([y_lim_02_1(1) y_lim_02_2(1) y_lim_02_3(1) y_lim_02_4(1) y_lim_02_5(1) y_lim_02_6(1) y_lim_02_7(1) y_lim_02_8(1)]),...
    max([y_lim_02_1(2) y_lim_02_2(2) y_lim_02_3(2) y_lim_02_4(2) y_lim_02_5(2) y_lim_02_6(2) y_lim_02_7(2) y_lim_02_8(2)])])

subplot(4,4,3)
set(gca,'ylim',[min([y_lim_02_1(1) y_lim_02_2(1) y_lim_02_3(1) y_lim_02_4(1) y_lim_02_5(1) y_lim_02_6(1) y_lim_02_7(1) y_lim_02_8(1)]),...
    max([y_lim_02_1(2) y_lim_02_2(2) y_lim_02_3(2) y_lim_02_4(2) y_lim_02_5(2) y_lim_02_6(2) y_lim_02_7(2) y_lim_02_8(2)])])

subplot(4,4,6)
set(gca,'ylim',[min([y_lim_02_1(1) y_lim_02_2(1) y_lim_02_3(1) y_lim_02_4(1) y_lim_02_5(1) y_lim_02_6(1) y_lim_02_7(1) y_lim_02_8(1)]),...
    max([y_lim_02_1(2) y_lim_02_2(2) y_lim_02_3(2) y_lim_02_4(2) y_lim_02_5(2) y_lim_02_6(2) y_lim_02_7(2) y_lim_02_8(2)])])

subplot(4,4,7)
set(gca,'ylim',[min([y_lim_02_1(1) y_lim_02_2(1) y_lim_02_3(1) y_lim_02_4(1) y_lim_02_5(1) y_lim_02_6(1) y_lim_02_7(1) y_lim_02_8(1)]),...
    max([y_lim_02_1(2) y_lim_02_2(2) y_lim_02_3(2) y_lim_02_4(2) y_lim_02_5(2) y_lim_02_6(2) y_lim_02_7(2) y_lim_02_8(2)])])

subplot(4,4,10)
set(gca,'ylim',[min([y_lim_02_1(1) y_lim_02_2(1) y_lim_02_3(1) y_lim_02_4(1) y_lim_02_5(1) y_lim_02_6(1) y_lim_02_7(1) y_lim_02_8(1)]),...
    max([y_lim_02_1(2) y_lim_02_2(2) y_lim_02_3(2) y_lim_02_4(2) y_lim_02_5(2) y_lim_02_6(2) y_lim_02_7(2) y_lim_02_8(2)])])

subplot(4,4,11)
set(gca,'ylim',[min([y_lim_02_1(1) y_lim_02_2(1) y_lim_02_3(1) y_lim_02_4(1) y_lim_02_5(1) y_lim_02_6(1) y_lim_02_7(1) y_lim_02_8(1)]),...
    max([y_lim_02_1(2) y_lim_02_2(2) y_lim_02_3(2) y_lim_02_4(2) y_lim_02_5(2) y_lim_02_6(2) y_lim_02_7(2) y_lim_02_8(2)])])

subplot(4,4,14)
set(gca,'ylim',[min([y_lim_02_1(1) y_lim_02_2(1) y_lim_02_3(1) y_lim_02_4(1) y_lim_02_5(1) y_lim_02_6(1) y_lim_02_7(1) y_lim_02_8(1)]),...
    max([y_lim_02_1(2) y_lim_02_2(2) y_lim_02_3(2) y_lim_02_4(2) y_lim_02_5(2) y_lim_02_6(2) y_lim_02_7(2) y_lim_02_8(2)])])

subplot(4,4,15)
set(gca,'ylim',[min([y_lim_02_1(1) y_lim_02_2(1) y_lim_02_3(1) y_lim_02_4(1) y_lim_02_5(1) y_lim_02_6(1) y_lim_02_7(1) y_lim_02_8(1)]),...
    max([y_lim_02_1(2) y_lim_02_2(2) y_lim_02_3(2) y_lim_02_4(2) y_lim_02_5(2) y_lim_02_6(2) y_lim_02_7(2) y_lim_02_8(2)])])
%

subplot(4,4,4); hold on
plot(log10(data.trials.t1.psd.e1.saw(1:103,7)))
plot(log10(data.trials.t1.psd.e2.saw(1:103,7)))
plot(log10(data.trials.t1.psd.e3.saw(1:103,7)))
plot(log10(data.trials.t1.psd.e4.saw(1:103,7)))
title('e1-4 7')
legend('e1','e2','e3','e4')
y_lim_03_1=get(gca,'ylim');

subplot(4,4,8); hold on
plot(log10(data.trials.t1.psd.e1.saw(1:103,18)))
plot(log10(data.trials.t1.psd.e2.saw(1:103,18)))
plot(log10(data.trials.t1.psd.e3.saw(1:103,18)))
plot(log10(data.trials.t1.psd.e4.saw(1:103,18)))
title('e1-4 18')
legend('e1','e2','e3','e4')
y_lim_03_2=get(gca,'ylim');

subplot(4,4,4)
set(gca,'ylim',[min([y_lim_03_1(1) y_lim_03_2(1)]) max([y_lim_03_1(2) y_lim_03_2(2)])])

subplot(4,4,8)
set(gca,'ylim',[min([y_lim_03_1(1) y_lim_03_2(1)]) max([y_lim_03_1(2) y_lim_03_2(2)])])


subplot(4,4,12); hold on
bar(data.plots.beta.c7.supermeans)
errorbar(data.plots.beta.c7.supermeans,...
    data.plots.beta.c7.ses,'.k')
set(gca,'XTick',[1:4],'XTickLabel',{'e1','e2','e3','e4'})
if data.cfg.info.stim_elc=='c3'
    title('7 stm')
else
    title('7 non')
end
y_lim_04_1=get(gca,'ylim');

subplot(4,4,16); hold on
bar(data.plots.beta.c18.supermeans)
errorbar(data.plots.beta.c18.supermeans,...
    data.plots.beta.c18.ses,'.k')
set(gca,'XTick',[1:4],'XTickLabel',{'e1','e2','e3','e4'})
if data.cfg.info.stim_elc=='c4'
    title('18 stm')
else
    title('18 non')
end
y_lim_04_2=get(gca,'ylim');

subplot(4,4,12)
set(gca,'ylim',[min([y_lim_04_1(1) y_lim_04_2(1)]) max([y_lim_04_1(2) y_lim_04_2(2)])])

subplot(4,4,16)
set(gca,'ylim',[min([y_lim_04_1(1) y_lim_04_2(1)]) max([y_lim_04_1(2) y_lim_04_2(2)])])

cd ~/nr_data_analysis/data_analyzed/eeg
saveas(gcf,[data.cfg.info.dx,'_',data.cfg.info.stim_stat,'_',...
    data.cfg.info.n_sbj,'_',data.cfg.trial_data.t1.cond,'_01.pdf'])













