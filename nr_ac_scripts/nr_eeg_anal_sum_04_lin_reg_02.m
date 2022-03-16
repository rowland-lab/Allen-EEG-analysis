load ~/nr_data_analysis/data_analyzed/eeg/metrics
load ~/nr_data_analysis/data_analyzed/eeg/data_sum_eeg_anal_05a_plot_01_13_sub_stats_42_43_nonnorm_data_only

kin_metrics.cs.stm.accur=MetricBetaPower_accur_stm;
kin_metrics.cs.stm.avg_accel=MetricBetaPower_avg_accel_stm;
kin_metrics.cs.stm.avg_vel=MetricBetaPower_avg_vel_stm;
kin_metrics.cs.stm.hand_path_length=MetricBetaPower_hand_path_length_stm;
kin_metrics.cs.stm.idx_curv=MetricBetaPower_idx_curv_stm;
kin_metrics.cs.stm.max_accel=MetricBetaPower_max_accel_stm;
kin_metrics.cs.stm.max_vel=MetricBetaPower_max_vel_stm;
kin_metrics.cs.stm.norm_jerk=MetricBetaPower_norm_jerk_stm;
kin_metrics.cs.stm.reaction_time=MetricBetaPower_reaction_time_stm;
kin_metrics.cs.stm.time_max_vel=MetricBetaPower_time_max_vel_stm;
kin_metrics.cs.stm.time_max_vel_norm=MetricBetaPower_time_to_max_vel_norm_stm;
kin_metrics.cs.stm.vel_peak=MetricBetaPower_vel_peak_stm;


sbjs_stm=['03';'04';'05';'42';'43'];
plot_color=['k','b','g','c','m']

%% cs_stm_ipsi_move_beta
figure
set(gcf,'Position',[228 100 1367 1271])

%Accuracy
xlim_cs_stm_ipsi_move_beta=max(max(data_sum_cs_stm_ipsi_move_beta))
ylim_kin_metrics_cs_non_accur=max(max(kin_metrics.cs.stm.accur))

subplot(12,4,1); hold on
set(gca,'xlim',[0 xlim_cs_stm_ipsi_move_beta],'ylim',[0 ylim_kin_metrics_cs_non_accur])
pfit_cs_stm_ipsi_move_beta_bl_accur=polyfit(data_sum_cs_stm_ipsi_move_beta(:,1),kin_metrics.cs.stm.accur(:,1),1)
pval_cs_stm_ipsi_move_beta_bl_accur=polyval(pfit_cs_stm_ipsi_move_beta_bl_accur,data_sum_cs_stm_ipsi_move_beta(:,1))
[r_cs_stm_ipsi_move_beta_bl_accur,p_cs_stm_ipsi_move_beta_bl_accur]=corrcoef(data_sum_cs_stm_ipsi_move_beta(:,1),kin_metrics.cs.stm.accur(:,1))
for i=1:size(data_sum_cs_stm_ipsi_move_beta(:,1),1)
    text(data_sum_cs_stm_ipsi_move_beta(i,1),kin_metrics.cs.stm.accur(i,1),sbjs_non(i,:),'Color',plot_color(i))
end
plot(data_sum_cs_stm_ipsi_move_beta(:,1),pval_cs_stm_ipsi_move_beta_bl_accur,'r','LineWidth',2)
if p_cs_stm_ipsi_move_beta_bl_accur(2)<0.05
    title(['cs stm ipsi move beta ',num2str(p_cs_stm_ipsi_move_beta_bl_accur(2))],'Color',[1 0 0])
else
    title(['cs stm ipsi move beta ',num2str(p_cs_stm_ipsi_move_beta_bl_accur(2))])
end
ylabel('Accur')

subplot(12,4,2); hold on
set(gca,'xlim',[0 xlim_cs_stm_ipsi_move_beta],'ylim',[0 ylim_kin_metrics_cs_non_accur])
pfit_cs_stm_ipsi_move_beta_es_accur=polyfit(data_sum_cs_stm_ipsi_move_beta(:,2),kin_metrics.cs.stm.accur(:,2),1)
pval_cs_stm_ipsi_move_beta_es_accur=polyval(pfit_cs_stm_ipsi_move_beta_es_accur,data_sum_cs_stm_ipsi_move_beta(:,2))
[r_cs_stm_ipsi_move_beta_es_accur,p_cs_stm_ipsi_move_beta_es_accur]=corrcoef(data_sum_cs_stm_ipsi_move_beta(:,2),kin_metrics.cs.stm.accur(:,2))
for i=1:size(data_sum_cs_stm_ipsi_move_beta(:,2),1)
    text(data_sum_cs_stm_ipsi_move_beta(i,2),kin_metrics.cs.stm.accur(i,2),sbjs_non(i,:),'Color',plot_color(i))
end
plot(data_sum_cs_stm_ipsi_move_beta(:,2),pval_cs_stm_ipsi_move_beta_es_accur,'r','LineWidth',2)
if p_cs_stm_ipsi_move_beta_es_accur(2)<0.05
    title(num2str(p_cs_stm_ipsi_move_beta_es_accur(2)),'Color',[1 0 0])
else
    title(num2str(p_cs_stm_ipsi_move_beta_es_accur(2)))
end

subplot(12,4,3); hold on
set(gca,'xlim',[0 xlim_cs_stm_ipsi_move_beta],'ylim',[0 ylim_kin_metrics_cs_non_accur])
pfit_cs_stm_ipsi_move_beta_ls_accur=polyfit(data_sum_cs_stm_ipsi_move_beta(:,3),kin_metrics.cs.stm.accur(:,3),1)
pval_cs_stm_ipsi_move_beta_ls_accur=polyval(pfit_cs_stm_ipsi_move_beta_ls_accur,data_sum_cs_stm_ipsi_move_beta(:,3))
[r_cs_stm_ipsi_move_beta_ls_accur,p_cs_stm_ipsi_move_beta_ls_accur]=corrcoef(data_sum_cs_stm_ipsi_move_beta(:,3),kin_metrics.cs.stm.accur(:,3))
for i=1:size(data_sum_cs_stm_ipsi_move_beta(:,3),1)
    text(data_sum_cs_stm_ipsi_move_beta(i,3),kin_metrics.cs.stm.accur(i,3),sbjs_non(i,:),'Color',plot_color(i))
end
plot(data_sum_cs_stm_ipsi_move_beta(:,3),pval_cs_stm_ipsi_move_beta_ls_accur,'r','LineWidth',2)
if p_cs_stm_ipsi_move_beta_ls_accur(2)<0.05
    title(num2str(p_cs_stm_ipsi_move_beta_ls_accur(2)),'Color',[1 0 0])
else
    title(num2str(p_cs_stm_ipsi_move_beta_ls_accur(2)))
end

subplot(12,4,4); hold on
set(gca,'xlim',[0 xlim_cs_stm_ipsi_move_beta],'ylim',[0 ylim_kin_metrics_cs_non_accur])
pfit_cs_stm_ipsi_move_beta_ps_accur=polyfit(data_sum_cs_stm_ipsi_move_beta(:,4),kin_metrics.cs.stm.accur(:,4),1)
pval_cs_stm_ipsi_move_beta_ps_accur=polyval(pfit_cs_stm_ipsi_move_beta_ps_accur,data_sum_cs_stm_ipsi_move_beta(:,4))
[r_cs_stm_ipsi_move_beta_ps_accur,p_cs_stm_ipsi_move_beta_ps_accur]=corrcoef(data_sum_cs_stm_ipsi_move_beta(:,4),kin_metrics.cs.stm.accur(:,4))
for i=1:size(data_sum_cs_stm_ipsi_move_beta(:,4),1)
    text(data_sum_cs_stm_ipsi_move_beta(i,4),kin_metrics.cs.stm.accur(i,4),sbjs_non(i,:),'Color',plot_color(i))
end
plot(data_sum_cs_stm_ipsi_move_beta(:,4),pval_cs_stm_ipsi_move_beta_ps_accur,'r','LineWidth',2)
if p_cs_stm_ipsi_move_beta_ps_accur(2)<0.05
    title(num2str(p_cs_stm_ipsi_move_beta_ps_accur(2)),'Color',[1 0 0])
else
    title(num2str(p_cs_stm_ipsi_move_beta_ps_accur(2)))
end

%Avg Accel
xlim_cs_stm_ipsi_move_beta=max(max(data_sum_cs_stm_ipsi_move_beta))
ylim_kin_metrics_cs_non_avg_accel=max(max(kin_metrics.cs.stm.avg_accel))

subplot(12,4,5); hold on
set(gca,'xlim',[0 xlim_cs_stm_ipsi_move_beta],'ylim',[0 ylim_kin_metrics_cs_non_avg_accel])
pfit_cs_stm_ipsi_move_beta_bl_avg_accel=polyfit(data_sum_cs_stm_ipsi_move_beta(:,1),kin_metrics.cs.stm.avg_accel(:,1),1)
pval_cs_stm_ipsi_move_beta_bl_avg_accel=polyval(pfit_cs_stm_ipsi_move_beta_bl_avg_accel,data_sum_cs_stm_ipsi_move_beta(:,1))
[r_cs_stm_ipsi_move_beta_bl_avg_accel,p_cs_stm_ipsi_move_beta_bl_avg_accel]=corrcoef(data_sum_cs_stm_ipsi_move_beta(:,1),kin_metrics.cs.stm.avg_accel(:,1))
for i=1:size(data_sum_cs_stm_ipsi_move_beta(:,1),1)
    text(data_sum_cs_stm_ipsi_move_beta(i,1),kin_metrics.cs.stm.avg_accel(i,1),sbjs_non(i,:),'Color',plot_color(i))
end
plot(data_sum_cs_stm_ipsi_move_beta(:,1),pval_cs_stm_ipsi_move_beta_bl_avg_accel,'r','LineWidth',2)
if p_cs_stm_ipsi_move_beta_bl_avg_accel(2)<0.05
    title(num2str(p_cs_stm_ipsi_move_beta_bl_avg_accel(2)),'Color',[1 0 0])
else
    title(num2str(p_cs_stm_ipsi_move_beta_bl_avg_accel(2)))
end
ylabel('avg accel')

subplot(12,4,6); hold on
set(gca,'xlim',[0 xlim_cs_stm_ipsi_move_beta],'ylim',[0 ylim_kin_metrics_cs_non_avg_accel])
pfit_cs_stm_ipsi_move_beta_es_avg_accel=polyfit(data_sum_cs_stm_ipsi_move_beta(:,2),kin_metrics.cs.stm.avg_accel(:,2),1)
pval_cs_stm_ipsi_move_beta_es_avg_accel=polyval(pfit_cs_stm_ipsi_move_beta_es_avg_accel,data_sum_cs_stm_ipsi_move_beta(:,2))
[r_cs_stm_ipsi_move_beta_es_avg_accel,p_cs_stm_ipsi_move_beta_es_avg_accel]=corrcoef(data_sum_cs_stm_ipsi_move_beta(:,2),kin_metrics.cs.stm.avg_accel(:,2))
for i=1:size(data_sum_cs_stm_ipsi_move_beta(:,2),1)
    text(data_sum_cs_stm_ipsi_move_beta(i,2),kin_metrics.cs.stm.avg_accel(i,2),sbjs_non(i,:),'Color',plot_color(i))
end
plot(data_sum_cs_stm_ipsi_move_beta(:,2),pval_cs_stm_ipsi_move_beta_es_avg_accel,'r','LineWidth',2)
if p_cs_stm_ipsi_move_beta_es_avg_accel(2)<0.05
    title(num2str(p_cs_stm_ipsi_move_beta_es_avg_accel(2)),'Color',[1 0 0])
else
    title(num2str(p_cs_stm_ipsi_move_beta_es_avg_accel(2)))
end

subplot(12,4,7); hold on
set(gca,'xlim',[0 xlim_cs_stm_ipsi_move_beta],'ylim',[0 ylim_kin_metrics_cs_non_avg_accel])
pfit_cs_stm_ipsi_move_beta_ls_avg_accel=polyfit(data_sum_cs_stm_ipsi_move_beta(:,3),kin_metrics.cs.stm.avg_accel(:,3),1)
pval_cs_stm_ipsi_move_beta_ls_avg_accel=polyval(pfit_cs_stm_ipsi_move_beta_ls_avg_accel,data_sum_cs_stm_ipsi_move_beta(:,3))
[r_cs_stm_ipsi_move_beta_ls_avg_accel,p_cs_stm_ipsi_move_beta_ls_avg_accel]=corrcoef(data_sum_cs_stm_ipsi_move_beta(:,3),kin_metrics.cs.stm.avg_accel(:,3))
for i=1:size(data_sum_cs_stm_ipsi_move_beta(:,3),1)
    text(data_sum_cs_stm_ipsi_move_beta(i,3),kin_metrics.cs.stm.avg_accel(i,3),sbjs_non(i,:),'Color',plot_color(i))
end
plot(data_sum_cs_stm_ipsi_move_beta(:,3),pval_cs_stm_ipsi_move_beta_ls_avg_accel,'r','LineWidth',2)
if p_cs_stm_ipsi_move_beta_ls_avg_accel(2)<0.05
    title(num2str(p_cs_stm_ipsi_move_beta_ls_avg_accel(2)),'Color',2)
else
    title(num2str(p_cs_stm_ipsi_move_beta_ls_avg_accel(2)))
end

subplot(12,4,8); hold on
set(gca,'xlim',[0 xlim_cs_stm_ipsi_move_beta],'ylim',[0 ylim_kin_metrics_cs_non_avg_accel])
pfit_cs_stm_ipsi_move_beta_ps_avg_accel=polyfit(data_sum_cs_stm_ipsi_move_beta(:,4),kin_metrics.cs.stm.avg_accel(:,4),1)
pval_cs_stm_ipsi_move_beta_ps_avg_accel=polyval(pfit_cs_stm_ipsi_move_beta_ps_avg_accel,data_sum_cs_stm_ipsi_move_beta(:,4))
[r_cs_stm_ipsi_move_beta_ps_avg_accel,p_cs_stm_ipsi_move_beta_ps_avg_accel]=corrcoef(data_sum_cs_stm_ipsi_move_beta(:,4),kin_metrics.cs.stm.avg_accel(:,4))
for i=1:size(data_sum_cs_stm_ipsi_move_beta(:,4),1)
    text(data_sum_cs_stm_ipsi_move_beta(i,4),kin_metrics.cs.stm.avg_accel(i,4),sbjs_non(i,:),'Color',plot_color(i))
end
plot(data_sum_cs_stm_ipsi_move_beta(:,4),pval_cs_stm_ipsi_move_beta_ps_avg_accel,'r','LineWidth',2)
if p_cs_stm_ipsi_move_beta_ps_avg_accel(2)<0.05
    title(num2str(p_cs_stm_ipsi_move_beta_ps_avg_accel(2)),'Color',[1 0 0])
else
    title(num2str(p_cs_stm_ipsi_move_beta_ps_avg_accel(2)))
end

%Avg Vel
xlim_cs_stm_ipsi_move_beta=max(max(data_sum_cs_stm_ipsi_move_beta))
ylim_kin_metrics_cs_non_avg_vel=max(max(kin_metrics.cs.stm.avg_vel))

subplot(12,4,9); hold on
set(gca,'xlim',[0 xlim_cs_stm_ipsi_move_beta],'ylim',[0 ylim_kin_metrics_cs_non_avg_vel])
pfit_cs_stm_ipsi_move_beta_bl_avg_vel=polyfit(data_sum_cs_stm_ipsi_move_beta(:,1),kin_metrics.cs.stm.avg_vel(:,1),1)
pval_cs_stm_ipsi_move_beta_bl_avg_vel=polyval(pfit_cs_stm_ipsi_move_beta_bl_avg_vel,data_sum_cs_stm_ipsi_move_beta(:,1))
[r_cs_stm_ipsi_move_beta_bl_avg_vel,p_cs_stm_ipsi_move_beta_bl_avg_vel]=corrcoef(data_sum_cs_stm_ipsi_move_beta(:,1),kin_metrics.cs.stm.avg_vel(:,1))
for i=1:size(data_sum_cs_stm_ipsi_move_beta(:,1),1)
    text(data_sum_cs_stm_ipsi_move_beta(i,1),kin_metrics.cs.stm.avg_vel(i,1),sbjs_non(i,:),'Color',plot_color(i))
end
plot(data_sum_cs_stm_ipsi_move_beta(:,1),pval_cs_stm_ipsi_move_beta_bl_avg_vel,'r','LineWidth',2)
if p_cs_stm_ipsi_move_beta_bl_avg_vel(2)<0.05
    title(num2str(p_cs_stm_ipsi_move_beta_bl_avg_vel(2)),'Color',[1 0 0])
else
    title(num2str(p_cs_stm_ipsi_move_beta_bl_avg_vel(2)))
end
ylabel('avg vel')

subplot(12,4,10); hold on
set(gca,'xlim',[0 xlim_cs_stm_ipsi_move_beta],'ylim',[0 ylim_kin_metrics_cs_non_avg_vel])
pfit_cs_stm_ipsi_move_beta_es_avg_vel=polyfit(data_sum_cs_stm_ipsi_move_beta(:,2),kin_metrics.cs.stm.avg_vel(:,2),1)
pval_cs_stm_ipsi_move_beta_es_avg_vel=polyval(pfit_cs_stm_ipsi_move_beta_es_avg_vel,data_sum_cs_stm_ipsi_move_beta(:,2))
[r_cs_stm_ipsi_move_beta_es_avg_vel,p_cs_stm_ipsi_move_beta_es_avg_vel]=corrcoef(data_sum_cs_stm_ipsi_move_beta(:,2),kin_metrics.cs.stm.avg_vel(:,2))
for i=1:size(data_sum_cs_stm_ipsi_move_beta(:,2),1)
    text(data_sum_cs_stm_ipsi_move_beta(i,2),kin_metrics.cs.stm.avg_vel(i,2),sbjs_non(i,:),'Color',plot_color(i))
end
plot(data_sum_cs_stm_ipsi_move_beta(:,2),pval_cs_stm_ipsi_move_beta_es_avg_vel,'r','LineWidth',2)
if p_cs_stm_ipsi_move_beta_es_avg_vel(2)<0.05
    title(num2str(p_cs_stm_ipsi_move_beta_es_avg_vel(2)),'Color',[1 0 0])
else
    title(num2str(p_cs_stm_ipsi_move_beta_es_avg_vel(2)))
end

subplot(12,4,11); hold on
set(gca,'xlim',[0 xlim_cs_stm_ipsi_move_beta],'ylim',[0 ylim_kin_metrics_cs_non_avg_vel])
pfit_cs_stm_ipsi_move_beta_ls_avg_vel=polyfit(data_sum_cs_stm_ipsi_move_beta(:,3),kin_metrics.cs.stm.avg_vel(:,3),1)
pval_cs_stm_ipsi_move_beta_ls_avg_vel=polyval(pfit_cs_stm_ipsi_move_beta_ls_avg_vel,data_sum_cs_stm_ipsi_move_beta(:,3))
[r_cs_stm_ipsi_move_beta_ls_avg_vel,p_cs_stm_ipsi_move_beta_ls_avg_vel]=corrcoef(data_sum_cs_stm_ipsi_move_beta(:,3),kin_metrics.cs.stm.avg_vel(:,3))
for i=1:size(data_sum_cs_stm_ipsi_move_beta(:,3),1)
    text(data_sum_cs_stm_ipsi_move_beta(i,3),kin_metrics.cs.stm.avg_vel(i,3),sbjs_non(i,:),'Color',plot_color(i))
end
plot(data_sum_cs_stm_ipsi_move_beta(:,3),pval_cs_stm_ipsi_move_beta_ls_avg_vel,'r','LineWidth',2)
if p_cs_stm_ipsi_move_beta_ls_avg_vel(2)<0.05
    title(num2str(p_cs_stm_ipsi_move_beta_ls_avg_vel(2)),'Color',[1 0 0])
else
    title(num2str(p_cs_stm_ipsi_move_beta_ls_avg_vel(2)))
end

subplot(12,4,12); hold on
set(gca,'xlim',[0 xlim_cs_stm_ipsi_move_beta],'ylim',[0 ylim_kin_metrics_cs_non_avg_vel])
pfit_cs_stm_ipsi_move_beta_ps_avg_vel=polyfit(data_sum_cs_stm_ipsi_move_beta(:,4),kin_metrics.cs.stm.avg_vel(:,4),1)
pval_cs_stm_ipsi_move_beta_ps_avg_vel=polyval(pfit_cs_stm_ipsi_move_beta_ps_avg_vel,data_sum_cs_stm_ipsi_move_beta(:,4))
[r_cs_stm_ipsi_move_beta_ps_avg_vel,p_cs_stm_ipsi_move_beta_ps_avg_vel]=corrcoef(data_sum_cs_stm_ipsi_move_beta(:,4),kin_metrics.cs.stm.avg_vel(:,4))
for i=1:size(data_sum_cs_stm_ipsi_move_beta(:,4),1)
    text(data_sum_cs_stm_ipsi_move_beta(i,4),kin_metrics.cs.stm.avg_vel(i,4),sbjs_non(i,:),'Color',plot_color(i))
end
plot(data_sum_cs_stm_ipsi_move_beta(:,4),pval_cs_stm_ipsi_move_beta_ps_avg_vel,'r','LineWidth',2)
if p_cs_stm_ipsi_move_beta_ps_avg_vel(2)<0.05
    title(num2str(p_cs_stm_ipsi_move_beta_ps_avg_vel(2)),'Color',[1 0 0])
else
    title(num2str(p_cs_stm_ipsi_move_beta_ps_avg_vel(2)))
end

%Hand Path Length
xlim_cs_stm_ipsi_move_beta=max(max(data_sum_cs_stm_ipsi_move_beta))
ylim_kin_metrics_cs_non_hand_path_length=max(max(kin_metrics.cs.stm.hand_path_length))

subplot(12,4,13); hold on
set(gca,'xlim',[0 xlim_cs_stm_ipsi_move_beta],'ylim',[0 ylim_kin_metrics_cs_non_hand_path_length])
pfit_cs_stm_ipsi_move_beta_bl_hand_path_length=polyfit(data_sum_cs_stm_ipsi_move_beta(:,1),kin_metrics.cs.stm.hand_path_length(:,1),1)
pval_cs_stm_ipsi_move_beta_bl_hand_path_length=polyval(pfit_cs_stm_ipsi_move_beta_bl_hand_path_length,data_sum_cs_stm_ipsi_move_beta(:,1))
[r_cs_stm_ipsi_move_beta_bl_hand_path_length,p_cs_stm_ipsi_move_beta_bl_hand_path_length]=corrcoef(data_sum_cs_stm_ipsi_move_beta(:,1),kin_metrics.cs.stm.hand_path_length(:,1))
for i=1:size(data_sum_cs_stm_ipsi_move_beta(:,1),1)
    text(data_sum_cs_stm_ipsi_move_beta(i,1),kin_metrics.cs.stm.hand_path_length(i,1),sbjs_non(i,:),'Color',plot_color(i))
end
plot(data_sum_cs_stm_ipsi_move_beta(:,1),pval_cs_stm_ipsi_move_beta_bl_hand_path_length,'r','LineWidth',2)
if p_cs_stm_ipsi_move_beta_bl_hand_path_length(2)<0.05
    title(num2str(p_cs_stm_ipsi_move_beta_bl_hand_path_length(2)),'Color',[1 0 0])
else
    title(num2str(p_cs_stm_ipsi_move_beta_bl_hand_path_length(2)))
end
ylabel('hnd path')

subplot(12,4,14); hold on
set(gca,'xlim',[0 xlim_cs_stm_ipsi_move_beta],'ylim',[0 ylim_kin_metrics_cs_non_hand_path_length])
pfit_cs_stm_ipsi_move_beta_es_hand_path_length=polyfit(data_sum_cs_stm_ipsi_move_beta(:,2),kin_metrics.cs.stm.hand_path_length(:,2),1)
pval_cs_stm_ipsi_move_beta_es_hand_path_length=polyval(pfit_cs_stm_ipsi_move_beta_es_hand_path_length,data_sum_cs_stm_ipsi_move_beta(:,2))
[r_cs_stm_ipsi_move_beta_es_hand_path_length,p_cs_stm_ipsi_move_beta_es_hand_path_length]=corrcoef(data_sum_cs_stm_ipsi_move_beta(:,2),kin_metrics.cs.stm.hand_path_length(:,2))
for i=1:size(data_sum_cs_stm_ipsi_move_beta(:,2),1)
    text(data_sum_cs_stm_ipsi_move_beta(i,2),kin_metrics.cs.stm.hand_path_length(i,2),sbjs_non(i,:),'Color',plot_color(i))
end
plot(data_sum_cs_stm_ipsi_move_beta(:,2),pval_cs_stm_ipsi_move_beta_es_hand_path_length,'r','LineWidth',2)
if p_cs_stm_ipsi_move_beta_es_hand_path_length(2)<0.05
    title(num2str(p_cs_stm_ipsi_move_beta_es_hand_path_length(2)),'Color',[1 0 0])
else
    title(num2str(p_cs_stm_ipsi_move_beta_es_hand_path_length(2)))
end

subplot(12,4,15); hold on
set(gca,'xlim',[0 xlim_cs_stm_ipsi_move_beta],'ylim',[0 ylim_kin_metrics_cs_non_hand_path_length])
pfit_cs_stm_ipsi_move_beta_ls_hand_path_length=polyfit(data_sum_cs_stm_ipsi_move_beta(:,3),kin_metrics.cs.stm.hand_path_length(:,3),1)
pval_cs_stm_ipsi_move_beta_ls_hand_path_length=polyval(pfit_cs_stm_ipsi_move_beta_ls_hand_path_length,data_sum_cs_stm_ipsi_move_beta(:,3))
[r_cs_stm_ipsi_move_beta_ls_hand_path_length,p_cs_stm_ipsi_move_beta_ls_hand_path_length]=corrcoef(data_sum_cs_stm_ipsi_move_beta(:,3),kin_metrics.cs.stm.hand_path_length(:,3))
for i=1:size(data_sum_cs_stm_ipsi_move_beta(:,3),1)
    text(data_sum_cs_stm_ipsi_move_beta(i,3),kin_metrics.cs.stm.hand_path_length(i,3),sbjs_non(i,:),'Color',plot_color(i))
end
plot(data_sum_cs_stm_ipsi_move_beta(:,3),pval_cs_stm_ipsi_move_beta_ls_hand_path_length,'r','LineWidth',2)
if p_cs_stm_ipsi_move_beta_ls_hand_path_length(2)<0.05
    title(num2str(p_cs_stm_ipsi_move_beta_ls_hand_path_length(2)),'Color',[1 0 0])
else
    title(num2str(p_cs_stm_ipsi_move_beta_ls_hand_path_length(2)))
end

subplot(12,4,16); hold on
set(gca,'xlim',[0 xlim_cs_stm_ipsi_move_beta],'ylim',[0 ylim_kin_metrics_cs_non_hand_path_length])
pfit_cs_stm_ipsi_move_beta_ps_hand_path_length=polyfit(data_sum_cs_stm_ipsi_move_beta(:,4),kin_metrics.cs.stm.hand_path_length(:,4),1)
pval_cs_stm_ipsi_move_beta_ps_hand_path_length=polyval(pfit_cs_stm_ipsi_move_beta_ps_hand_path_length,data_sum_cs_stm_ipsi_move_beta(:,4))
[r_cs_stm_ipsi_move_beta_ps_hand_path_length,p_cs_stm_ipsi_move_beta_ps_hand_path_length]=corrcoef(data_sum_cs_stm_ipsi_move_beta(:,4),kin_metrics.cs.stm.hand_path_length(:,4))
for i=1:size(data_sum_cs_stm_ipsi_move_beta(:,4),1)
    text(data_sum_cs_stm_ipsi_move_beta(i,4),kin_metrics.cs.stm.hand_path_length(i,4),sbjs_non(i,:),'Color',plot_color(i))
end
plot(data_sum_cs_stm_ipsi_move_beta(:,4),pval_cs_stm_ipsi_move_beta_ps_hand_path_length,'r','LineWidth',2)
if p_cs_stm_ipsi_move_beta_ps_hand_path_length(2)<0.05
    title(num2str(p_cs_stm_ipsi_move_beta_ps_hand_path_length(2)),'Color',[1 0 0])
else
    title(num2str(p_cs_stm_ipsi_move_beta_ps_hand_path_length(2)))
end

%Index of curvature
xlim_cs_stm_ipsi_move_beta=max(max(data_sum_cs_stm_ipsi_move_beta))
ylim_kin_metrics_cs_non_idx_curv=max(max(kin_metrics.cs.stm.idx_curv))

subplot(12,4,17); hold on
set(gca,'xlim',[0 xlim_cs_stm_ipsi_move_beta],'ylim',[0 ylim_kin_metrics_cs_non_idx_curv])
pfit_cs_stm_ipsi_move_beta_bl_idx_curv=polyfit(data_sum_cs_stm_ipsi_move_beta(:,1),kin_metrics.cs.stm.idx_curv(:,1),1)
pval_cs_stm_ipsi_move_beta_bl_idx_curv=polyval(pfit_cs_stm_ipsi_move_beta_bl_idx_curv,data_sum_cs_stm_ipsi_move_beta(:,1))
[r_cs_stm_ipsi_move_beta_bl_idx_curv,p_cs_stm_ipsi_move_beta_bl_idx_curv]=corrcoef(data_sum_cs_stm_ipsi_move_beta(:,1),kin_metrics.cs.stm.idx_curv(:,1))
for i=1:size(data_sum_cs_stm_ipsi_move_beta(:,1),1)
    text(data_sum_cs_stm_ipsi_move_beta(i,1),kin_metrics.cs.stm.idx_curv(i,1),sbjs_non(i,:),'Color',plot_color(i))
end
plot(data_sum_cs_stm_ipsi_move_beta(:,1),pval_cs_stm_ipsi_move_beta_bl_idx_curv,'r','LineWidth',2)
if p_cs_stm_ipsi_move_beta_bl_idx_curv(2)<0.05
    title(num2str(p_cs_stm_ipsi_move_beta_bl_idx_curv(2)),'Color',[1 0 0])
else
    title(num2str(p_cs_stm_ipsi_move_beta_bl_idx_curv(2)))
end
ylabel('idx crv')

subplot(12,4,18); hold on
set(gca,'xlim',[0 xlim_cs_stm_ipsi_move_beta],'ylim',[0 ylim_kin_metrics_cs_non_idx_curv])
pfit_cs_stm_ipsi_move_beta_es_idx_curv=polyfit(data_sum_cs_stm_ipsi_move_beta(:,2),kin_metrics.cs.stm.idx_curv(:,2),1)
pval_cs_stm_ipsi_move_beta_es_idx_curv=polyval(pfit_cs_stm_ipsi_move_beta_es_idx_curv,data_sum_cs_stm_ipsi_move_beta(:,2))
[r_cs_stm_ipsi_move_beta_es_idx_curv,p_cs_stm_ipsi_move_beta_es_idx_curv]=corrcoef(data_sum_cs_stm_ipsi_move_beta(:,2),kin_metrics.cs.stm.idx_curv(:,2))
for i=1:size(data_sum_cs_stm_ipsi_move_beta(:,2),1)
    text(data_sum_cs_stm_ipsi_move_beta(i,2),kin_metrics.cs.stm.idx_curv(i,2),sbjs_non(i,:),'Color',plot_color(i))
end
plot(data_sum_cs_stm_ipsi_move_beta(:,2),pval_cs_stm_ipsi_move_beta_es_idx_curv,'r','LineWidth',2)
if p_cs_stm_ipsi_move_beta_es_idx_curv(2)<0.05
    title(num2str(p_cs_stm_ipsi_move_beta_es_idx_curv(2)),'Color',[1 0 0])
else
    title(num2str(p_cs_stm_ipsi_move_beta_es_idx_curv(2)))
end

subplot(12,4,19); hold on
set(gca,'xlim',[0 xlim_cs_stm_ipsi_move_beta],'ylim',[0 ylim_kin_metrics_cs_non_idx_curv])
pfit_cs_stm_ipsi_move_beta_ls_idx_curv=polyfit(data_sum_cs_stm_ipsi_move_beta(:,3),kin_metrics.cs.stm.idx_curv(:,3),1)
pval_cs_stm_ipsi_move_beta_ls_idx_curv=polyval(pfit_cs_stm_ipsi_move_beta_ls_idx_curv,data_sum_cs_stm_ipsi_move_beta(:,3))
[r_cs_stm_ipsi_move_beta_ls_idx_curv,p_cs_stm_ipsi_move_beta_ls_idx_curv]=corrcoef(data_sum_cs_stm_ipsi_move_beta(:,3),kin_metrics.cs.stm.idx_curv(:,3))
for i=1:size(data_sum_cs_stm_ipsi_move_beta(:,3),1)
    text(data_sum_cs_stm_ipsi_move_beta(i,3),kin_metrics.cs.stm.idx_curv(i,3),sbjs_non(i,:),'Color',plot_color(i))
end
plot(data_sum_cs_stm_ipsi_move_beta(:,3),pval_cs_stm_ipsi_move_beta_ls_idx_curv,'r','LineWidth',2)
if p_cs_stm_ipsi_move_beta_ls_idx_curv(2)<0.05
    title(num2str(p_cs_stm_ipsi_move_beta_ls_idx_curv(2)),'Color',[1 0 0])
else
    title(num2str(p_cs_stm_ipsi_move_beta_ls_idx_curv(2)))
end

subplot(12,4,20); hold on
set(gca,'xlim',[0 xlim_cs_stm_ipsi_move_beta],'ylim',[0 ylim_kin_metrics_cs_non_idx_curv])
pfit_cs_stm_ipsi_move_beta_ps_idx_curv=polyfit(data_sum_cs_stm_ipsi_move_beta(:,4),kin_metrics.cs.stm.idx_curv(:,4),1)
pval_cs_stm_ipsi_move_beta_ps_idx_curv=polyval(pfit_cs_stm_ipsi_move_beta_ps_idx_curv,data_sum_cs_stm_ipsi_move_beta(:,4))
[r_cs_stm_ipsi_move_beta_ps_idx_curv,p_cs_stm_ipsi_move_beta_ps_idx_curv]=corrcoef(data_sum_cs_stm_ipsi_move_beta(:,4),kin_metrics.cs.stm.idx_curv(:,4))
for i=1:size(data_sum_cs_stm_ipsi_move_beta(:,4),1)
    text(data_sum_cs_stm_ipsi_move_beta(i,4),kin_metrics.cs.stm.idx_curv(i,4),sbjs_non(i,:),'Color',plot_color(i))
end
plot(data_sum_cs_stm_ipsi_move_beta(:,4),pval_cs_stm_ipsi_move_beta_ps_idx_curv,'r','LineWidth',2)
if p_cs_stm_ipsi_move_beta_ps_idx_curv(2)<0.05
    title(num2str(p_cs_stm_ipsi_move_beta_ps_idx_curv(2)),'Color',[1 0 0])
else
    title(num2str(p_cs_stm_ipsi_move_beta_ps_idx_curv(2)))
end

%Max accel
xlim_cs_stm_ipsi_move_beta=max(max(data_sum_cs_stm_ipsi_move_beta))
ylim_kin_metrics_cs_non_max_accel=max(max(kin_metrics.cs.stm.max_accel))

subplot(12,4,21); hold on
set(gca,'xlim',[0 xlim_cs_stm_ipsi_move_beta],'ylim',[0 ylim_kin_metrics_cs_non_max_accel])
pfit_cs_stm_ipsi_move_beta_bl_max_accel=polyfit(data_sum_cs_stm_ipsi_move_beta(:,1),kin_metrics.cs.stm.max_accel(:,1),1)
pval_cs_stm_ipsi_move_beta_bl_max_accel=polyval(pfit_cs_stm_ipsi_move_beta_bl_max_accel,data_sum_cs_stm_ipsi_move_beta(:,1))
[r_cs_stm_ipsi_move_beta_bl_max_accel,p_cs_stm_ipsi_move_beta_bl_max_accel]=corrcoef(data_sum_cs_stm_ipsi_move_beta(:,1),kin_metrics.cs.stm.max_accel(:,1))
for i=1:size(data_sum_cs_stm_ipsi_move_beta(:,1),1)
    text(data_sum_cs_stm_ipsi_move_beta(i,1),kin_metrics.cs.stm.max_accel(i,1),sbjs_non(i,:),'Color',plot_color(i))
end
plot(data_sum_cs_stm_ipsi_move_beta(:,1),pval_cs_stm_ipsi_move_beta_bl_max_accel,'r','LineWidth',2)
if p_cs_stm_ipsi_move_beta_bl_max_accel(2)<0.05
    title(num2str(p_cs_stm_ipsi_move_beta_bl_max_accel(2)),'Color',[1 0 0])
else
    title(num2str(p_cs_stm_ipsi_move_beta_bl_max_accel(2)))
end
ylabel('max accel')

subplot(12,4,22); hold on
set(gca,'xlim',[0 xlim_cs_stm_ipsi_move_beta],'ylim',[0 ylim_kin_metrics_cs_non_max_accel])
pfit_cs_stm_ipsi_move_beta_es_max_accel=polyfit(data_sum_cs_stm_ipsi_move_beta(:,2),kin_metrics.cs.stm.max_accel(:,2),1)
pval_cs_stm_ipsi_move_beta_es_max_accel=polyval(pfit_cs_stm_ipsi_move_beta_es_max_accel,data_sum_cs_stm_ipsi_move_beta(:,2))
[r_cs_stm_ipsi_move_beta_es_max_accel,p_cs_stm_ipsi_move_beta_es_max_accel]=corrcoef(data_sum_cs_stm_ipsi_move_beta(:,2),kin_metrics.cs.stm.max_accel(:,2))
for i=1:size(data_sum_cs_stm_ipsi_move_beta(:,2),1)
    text(data_sum_cs_stm_ipsi_move_beta(i,2),kin_metrics.cs.stm.max_accel(i,2),sbjs_non(i,:),'Color',plot_color(i))
end
plot(data_sum_cs_stm_ipsi_move_beta(:,2),pval_cs_stm_ipsi_move_beta_es_max_accel,'r','LineWidth',2)
if p_cs_stm_ipsi_move_beta_es_max_accel(2)<0.05
    title(num2str(p_cs_stm_ipsi_move_beta_es_max_accel(2)),'Color',[1 0 0])
else
    title(num2str(p_cs_stm_ipsi_move_beta_es_max_accel(2)))
end

subplot(12,4,23); hold on
set(gca,'xlim',[0 xlim_cs_stm_ipsi_move_beta],'ylim',[0 ylim_kin_metrics_cs_non_max_accel])
pfit_cs_stm_ipsi_move_beta_ls_max_accel=polyfit(data_sum_cs_stm_ipsi_move_beta(:,3),kin_metrics.cs.stm.max_accel(:,3),1)
pval_cs_stm_ipsi_move_beta_ls_max_accel=polyval(pfit_cs_stm_ipsi_move_beta_ls_max_accel,data_sum_cs_stm_ipsi_move_beta(:,3))
[r_cs_stm_ipsi_move_beta_ls_max_accel,p_cs_stm_ipsi_move_beta_ls_max_accel]=corrcoef(data_sum_cs_stm_ipsi_move_beta(:,3),kin_metrics.cs.stm.max_accel(:,3))
for i=1:size(data_sum_cs_stm_ipsi_move_beta(:,3),1)
    text(data_sum_cs_stm_ipsi_move_beta(i,3),kin_metrics.cs.stm.max_accel(i,3),sbjs_non(i,:),'Color',plot_color(i))
end
plot(data_sum_cs_stm_ipsi_move_beta(:,3),pval_cs_stm_ipsi_move_beta_ls_max_accel,'r','LineWidth',2)
if p_cs_stm_ipsi_move_beta_ls_max_accel(2)<0.05
    title(num2str(p_cs_stm_ipsi_move_beta_ls_max_accel(2)),'Color',[1 0 0])
else
    title(num2str(p_cs_stm_ipsi_move_beta_ls_max_accel(2)))
end

subplot(12,4,24); hold on
set(gca,'xlim',[0 xlim_cs_stm_ipsi_move_beta],'ylim',[0 ylim_kin_metrics_cs_non_max_accel])
pfit_cs_stm_ipsi_move_beta_ps_max_accel=polyfit(data_sum_cs_stm_ipsi_move_beta(:,4),kin_metrics.cs.stm.max_accel(:,4),1)
pval_cs_stm_ipsi_move_beta_ps_max_accel=polyval(pfit_cs_stm_ipsi_move_beta_ps_max_accel,data_sum_cs_stm_ipsi_move_beta(:,4))
[r_cs_stm_ipsi_move_beta_ps_max_accel,p_cs_stm_ipsi_move_beta_ps_max_accel]=corrcoef(data_sum_cs_stm_ipsi_move_beta(:,4),kin_metrics.cs.stm.max_accel(:,4))
for i=1:size(data_sum_cs_stm_ipsi_move_beta(:,4),1)
    text(data_sum_cs_stm_ipsi_move_beta(i,4),kin_metrics.cs.stm.max_accel(i,4),sbjs_non(i,:),'Color',plot_color(i))
end
plot(data_sum_cs_stm_ipsi_move_beta(:,4),pval_cs_stm_ipsi_move_beta_ps_max_accel,'r','LineWidth',2)
if p_cs_stm_ipsi_move_beta_ps_max_accel(2)<0.05
    title(num2str(p_cs_stm_ipsi_move_beta_ps_max_accel(2)),'Color',[1 0 0])
else
    title(num2str(p_cs_stm_ipsi_move_beta_ps_max_accel(2)))
end

%Max vel
xlim_cs_stm_ipsi_move_beta=max(max(data_sum_cs_stm_ipsi_move_beta))
ylim_kin_metrics_cs_non_max_vel=max(max(kin_metrics.cs.stm.max_vel))

subplot(12,4,25); hold on
set(gca,'xlim',[0 xlim_cs_stm_ipsi_move_beta],'ylim',[0 ylim_kin_metrics_cs_non_max_vel])
pfit_cs_stm_ipsi_move_beta_bl_max_vel=polyfit(data_sum_cs_stm_ipsi_move_beta(:,1),kin_metrics.cs.stm.max_vel(:,1),1)
pval_cs_stm_ipsi_move_beta_bl_max_vel=polyval(pfit_cs_stm_ipsi_move_beta_bl_max_vel,data_sum_cs_stm_ipsi_move_beta(:,1))
[r_cs_stm_ipsi_move_beta_bl_max_vel,p_cs_stm_ipsi_move_beta_bl_max_vel]=corrcoef(data_sum_cs_stm_ipsi_move_beta(:,1),kin_metrics.cs.stm.max_vel(:,1))
for i=1:size(data_sum_cs_stm_ipsi_move_beta(:,1),1)
    text(data_sum_cs_stm_ipsi_move_beta(i,1),kin_metrics.cs.stm.max_vel(i,1),sbjs_non(i,:),'Color',plot_color(i))
end
plot(data_sum_cs_stm_ipsi_move_beta(:,1),pval_cs_stm_ipsi_move_beta_bl_max_vel,'r','LineWidth',2)
if p_cs_stm_ipsi_move_beta_bl_max_vel(2)<0.05
    title(num2str(p_cs_stm_ipsi_move_beta_bl_max_vel(2)),'Color',[1 0 0])
else
    title(num2str(p_cs_stm_ipsi_move_beta_bl_max_vel(2)))
end
ylabel('max vel')

subplot(12,4,26); hold on
set(gca,'xlim',[0 xlim_cs_stm_ipsi_move_beta],'ylim',[0 ylim_kin_metrics_cs_non_max_vel])
pfit_cs_stm_ipsi_move_beta_es_max_vel=polyfit(data_sum_cs_stm_ipsi_move_beta(:,2),kin_metrics.cs.stm.max_vel(:,2),1)
pval_cs_stm_ipsi_move_beta_es_max_vel=polyval(pfit_cs_stm_ipsi_move_beta_es_max_vel,data_sum_cs_stm_ipsi_move_beta(:,2))
[r_cs_stm_ipsi_move_beta_es_max_vel,p_cs_stm_ipsi_move_beta_es_max_vel]=corrcoef(data_sum_cs_stm_ipsi_move_beta(:,2),kin_metrics.cs.stm.max_vel(:,2))
for i=1:size(data_sum_cs_stm_ipsi_move_beta(:,2),1)
    text(data_sum_cs_stm_ipsi_move_beta(i,2),kin_metrics.cs.stm.max_vel(i,2),sbjs_non(i,:),'Color',plot_color(i))
end
plot(data_sum_cs_stm_ipsi_move_beta(:,2),pval_cs_stm_ipsi_move_beta_es_max_vel,'r','LineWidth',2)
if p_cs_stm_ipsi_move_beta_es_max_vel(2)<0.05
    title(num2str(p_cs_stm_ipsi_move_beta_es_max_vel(2)),'Color',[1 0 0])
else
    title(num2str(p_cs_stm_ipsi_move_beta_es_max_vel(2)))
end

subplot(12,4,27); hold on
set(gca,'xlim',[0 xlim_cs_stm_ipsi_move_beta],'ylim',[0 ylim_kin_metrics_cs_non_max_vel])
pfit_cs_stm_ipsi_move_beta_ls_max_vel=polyfit(data_sum_cs_stm_ipsi_move_beta(:,3),kin_metrics.cs.stm.max_vel(:,3),1)
pval_cs_stm_ipsi_move_beta_ls_max_vel=polyval(pfit_cs_stm_ipsi_move_beta_ls_max_vel,data_sum_cs_stm_ipsi_move_beta(:,3))
[r_cs_stm_ipsi_move_beta_ls_max_vel,p_cs_stm_ipsi_move_beta_ls_max_vel]=corrcoef(data_sum_cs_stm_ipsi_move_beta(:,3),kin_metrics.cs.stm.max_vel(:,3))
for i=1:size(data_sum_cs_stm_ipsi_move_beta(:,3),1)
    text(data_sum_cs_stm_ipsi_move_beta(i,3),kin_metrics.cs.stm.max_vel(i,3),sbjs_non(i,:),'Color',plot_color(i))
end
plot(data_sum_cs_stm_ipsi_move_beta(:,3),pval_cs_stm_ipsi_move_beta_ls_max_vel,'r','LineWidth',2)
if p_cs_stm_ipsi_move_beta_ls_max_vel(2)<0.05
    title(num2str(p_cs_stm_ipsi_move_beta_ls_max_vel(2)),'Color',[1 0 0])
else
    title(num2str(p_cs_stm_ipsi_move_beta_ls_max_vel(2)))
end

subplot(12,4,28); hold on
set(gca,'xlim',[0 xlim_cs_stm_ipsi_move_beta],'ylim',[0 ylim_kin_metrics_cs_non_max_vel])
pfit_cs_stm_ipsi_move_beta_ps_max_vel=polyfit(data_sum_cs_stm_ipsi_move_beta(:,4),kin_metrics.cs.stm.max_vel(:,4),1)
pval_cs_stm_ipsi_move_beta_ps_max_vel=polyval(pfit_cs_stm_ipsi_move_beta_ps_max_vel,data_sum_cs_stm_ipsi_move_beta(:,4))
[r_cs_stm_ipsi_move_beta_ps_max_vel,p_cs_stm_ipsi_move_beta_ps_max_vel]=corrcoef(data_sum_cs_stm_ipsi_move_beta(:,4),kin_metrics.cs.stm.max_vel(:,4))
for i=1:size(data_sum_cs_stm_ipsi_move_beta(:,4),1)
    text(data_sum_cs_stm_ipsi_move_beta(i,4),kin_metrics.cs.stm.max_vel(i,4),sbjs_non(i,:),'Color',plot_color(i))
end
plot(data_sum_cs_stm_ipsi_move_beta(:,4),pval_cs_stm_ipsi_move_beta_ps_max_vel,'r','LineWidth',2)
if p_cs_stm_ipsi_move_beta_ps_max_vel(2)<0.05
    title(num2str(p_cs_stm_ipsi_move_beta_ps_max_vel(2)),'Color',[1 0 0])
else
    title(num2str(p_cs_stm_ipsi_move_beta_ps_max_vel(2)))
end

%norm jerk
xlim_cs_stm_ipsi_move_beta=max(max(data_sum_cs_stm_ipsi_move_beta))
ylim_kin_metrics_cs_non_norm_jerk=max(max(kin_metrics.cs.stm.norm_jerk))

subplot(12,4,29); hold on
set(gca,'xlim',[0 xlim_cs_stm_ipsi_move_beta],'ylim',[0 ylim_kin_metrics_cs_non_norm_jerk])
pfit_cs_stm_ipsi_move_beta_bl_norm_jerk=polyfit(data_sum_cs_stm_ipsi_move_beta(:,1),kin_metrics.cs.stm.norm_jerk(:,1),1)
pval_cs_stm_ipsi_move_beta_bl_norm_jerk=polyval(pfit_cs_stm_ipsi_move_beta_bl_norm_jerk,data_sum_cs_stm_ipsi_move_beta(:,1))
[r_cs_stm_ipsi_move_beta_bl_norm_jerk,p_cs_stm_ipsi_move_beta_bl_norm_jerk]=corrcoef(data_sum_cs_stm_ipsi_move_beta(:,1),kin_metrics.cs.stm.norm_jerk(:,1))
for i=1:size(data_sum_cs_stm_ipsi_move_beta(:,1),1)
    text(data_sum_cs_stm_ipsi_move_beta(i,1),kin_metrics.cs.stm.norm_jerk(i,1),sbjs_non(i,:),'Color',plot_color(i))
end
plot(data_sum_cs_stm_ipsi_move_beta(:,1),pval_cs_stm_ipsi_move_beta_bl_norm_jerk,'r','LineWidth',2)
if p_cs_stm_ipsi_move_beta_bl_norm_jerk(2)<0.05
    title(num2str(p_cs_stm_ipsi_move_beta_bl_norm_jerk(2)),'Color',[1 0 0])
else
    title(num2str(p_cs_stm_ipsi_move_beta_bl_norm_jerk(2)))
end
ylabel('nrm jrk')

subplot(12,4,30); hold on
set(gca,'xlim',[0 xlim_cs_stm_ipsi_move_beta],'ylim',[0 ylim_kin_metrics_cs_non_norm_jerk])
pfit_cs_stm_ipsi_move_beta_es_norm_jerk=polyfit(data_sum_cs_stm_ipsi_move_beta(:,2),kin_metrics.cs.stm.norm_jerk(:,2),1)
pval_cs_stm_ipsi_move_beta_es_norm_jerk=polyval(pfit_cs_stm_ipsi_move_beta_es_norm_jerk,data_sum_cs_stm_ipsi_move_beta(:,2))
[r_cs_stm_ipsi_move_beta_es_norm_jerk,p_cs_stm_ipsi_move_beta_es_norm_jerk]=corrcoef(data_sum_cs_stm_ipsi_move_beta(:,2),kin_metrics.cs.stm.norm_jerk(:,2))
for i=1:size(data_sum_cs_stm_ipsi_move_beta(:,2),1)
    text(data_sum_cs_stm_ipsi_move_beta(i,2),kin_metrics.cs.stm.norm_jerk(i,2),sbjs_non(i,:),'Color',plot_color(i))
end
plot(data_sum_cs_stm_ipsi_move_beta(:,2),pval_cs_stm_ipsi_move_beta_es_norm_jerk,'r','LineWidth',2)
if p_cs_stm_ipsi_move_beta_es_norm_jerk(2)<0.05
    title(num2str(p_cs_stm_ipsi_move_beta_es_norm_jerk(2)),'Color',[1 0 0])
else
    title(num2str(p_cs_stm_ipsi_move_beta_es_norm_jerk(2)))
end

subplot(12,4,31); hold on
set(gca,'xlim',[0 xlim_cs_stm_ipsi_move_beta],'ylim',[0 ylim_kin_metrics_cs_non_norm_jerk])
pfit_cs_stm_ipsi_move_beta_ls_norm_jerk=polyfit(data_sum_cs_stm_ipsi_move_beta(:,3),kin_metrics.cs.stm.norm_jerk(:,3),1)
pval_cs_stm_ipsi_move_beta_ls_norm_jerk=polyval(pfit_cs_stm_ipsi_move_beta_ls_norm_jerk,data_sum_cs_stm_ipsi_move_beta(:,3))
[r_cs_stm_ipsi_move_beta_ls_norm_jerk,p_cs_stm_ipsi_move_beta_ls_norm_jerk]=corrcoef(data_sum_cs_stm_ipsi_move_beta(:,3),kin_metrics.cs.stm.norm_jerk(:,3))
for i=1:size(data_sum_cs_stm_ipsi_move_beta(:,3),1)
    text(data_sum_cs_stm_ipsi_move_beta(i,3),kin_metrics.cs.stm.norm_jerk(i,3),sbjs_non(i,:),'Color',plot_color(i))
end
plot(data_sum_cs_stm_ipsi_move_beta(:,3),pval_cs_stm_ipsi_move_beta_ls_norm_jerk,'r','LineWidth',2)
if p_cs_stm_ipsi_move_beta_ls_norm_jerk(2)<0.05
    title(num2str(p_cs_stm_ipsi_move_beta_ls_norm_jerk(2)),'Color',[1 0 0])
else
    title(num2str(p_cs_stm_ipsi_move_beta_ls_norm_jerk(2)))
end

subplot(12,4,32); hold on
set(gca,'xlim',[0 xlim_cs_stm_ipsi_move_beta],'ylim',[0 ylim_kin_metrics_cs_non_norm_jerk])
pfit_cs_stm_ipsi_move_beta_ps_norm_jerk=polyfit(data_sum_cs_stm_ipsi_move_beta(:,4),kin_metrics.cs.stm.norm_jerk(:,4),1)
pval_cs_stm_ipsi_move_beta_ps_norm_jerk=polyval(pfit_cs_stm_ipsi_move_beta_ps_norm_jerk,data_sum_cs_stm_ipsi_move_beta(:,4))
[r_cs_stm_ipsi_move_beta_ps_norm_jerk,p_cs_stm_ipsi_move_beta_ps_norm_jerk]=corrcoef(data_sum_cs_stm_ipsi_move_beta(:,4),kin_metrics.cs.stm.norm_jerk(:,4))
for i=1:size(data_sum_cs_stm_ipsi_move_beta(:,4),1)
    text(data_sum_cs_stm_ipsi_move_beta(i,4),kin_metrics.cs.stm.norm_jerk(i,4),sbjs_non(i,:),'Color',plot_color(i))
end
plot(data_sum_cs_stm_ipsi_move_beta(:,4),pval_cs_stm_ipsi_move_beta_ps_norm_jerk,'r','LineWidth',2)
if p_cs_stm_ipsi_move_beta_ps_norm_jerk(2)<0.05
    title(num2str(p_cs_stm_ipsi_move_beta_ps_norm_jerk(2)),'Color',[1 0 0])
else
    title(num2str(p_cs_stm_ipsi_move_beta_ps_norm_jerk(2)))
end

%reaction time
xlim_cs_stm_ipsi_move_beta=max(max(data_sum_cs_stm_ipsi_move_beta))
ylim_kin_metrics_cs_non_reaction_time=max(max(kin_metrics.cs.stm.reaction_time))

subplot(12,4,33); hold on
set(gca,'xlim',[0 xlim_cs_stm_ipsi_move_beta],'ylim',[0 ylim_kin_metrics_cs_non_reaction_time])
pfit_cs_stm_ipsi_move_beta_bl_reaction_time=polyfit(data_sum_cs_stm_ipsi_move_beta(:,1),kin_metrics.cs.stm.reaction_time(:,1),1)
pval_cs_stm_ipsi_move_beta_bl_reaction_time=polyval(pfit_cs_stm_ipsi_move_beta_bl_reaction_time,data_sum_cs_stm_ipsi_move_beta(:,1))
[r_cs_stm_ipsi_move_beta_bl_reaction_time,p_cs_stm_ipsi_move_beta_bl_reaction_time]=corrcoef(data_sum_cs_stm_ipsi_move_beta(:,1),kin_metrics.cs.stm.reaction_time(:,1))
for i=1:size(data_sum_cs_stm_ipsi_move_beta(:,1),1)
    text(data_sum_cs_stm_ipsi_move_beta(i,1),kin_metrics.cs.stm.reaction_time(i,1),sbjs_non(i,:),'Color',plot_color(i))
end
plot(data_sum_cs_stm_ipsi_move_beta(:,1),pval_cs_stm_ipsi_move_beta_bl_reaction_time,'r','LineWidth',2)
if p_cs_stm_ipsi_move_beta_bl_reaction_time(2)<0.05
    title(num2str(p_cs_stm_ipsi_move_beta_bl_reaction_time(2)),'Color',[1 0 0])
else
    title(num2str(p_cs_stm_ipsi_move_beta_bl_reaction_time(2)))
end
ylabel('rct time')

subplot(12,4,34); hold on
set(gca,'xlim',[0 xlim_cs_stm_ipsi_move_beta],'ylim',[0 ylim_kin_metrics_cs_non_reaction_time])
pfit_cs_stm_ipsi_move_beta_es_reaction_time=polyfit(data_sum_cs_stm_ipsi_move_beta(:,2),kin_metrics.cs.stm.reaction_time(:,2),1)
pval_cs_stm_ipsi_move_beta_es_reaction_time=polyval(pfit_cs_stm_ipsi_move_beta_es_reaction_time,data_sum_cs_stm_ipsi_move_beta(:,2))
[r_cs_stm_ipsi_move_beta_es_reaction_time,p_cs_stm_ipsi_move_beta_es_reaction_time]=corrcoef(data_sum_cs_stm_ipsi_move_beta(:,2),kin_metrics.cs.stm.reaction_time(:,2))
for i=1:size(data_sum_cs_stm_ipsi_move_beta(:,2),1)
    text(data_sum_cs_stm_ipsi_move_beta(i,2),kin_metrics.cs.stm.reaction_time(i,2),sbjs_non(i,:),'Color',plot_color(i))
end
plot(data_sum_cs_stm_ipsi_move_beta(:,2),pval_cs_stm_ipsi_move_beta_es_reaction_time,'r','LineWidth',2)
if p_cs_stm_ipsi_move_beta_es_reaction_time(2)<0.05
    title(num2str(p_cs_stm_ipsi_move_beta_es_reaction_time(2)),'Color',[1 0 0])
else
    title(num2str(p_cs_stm_ipsi_move_beta_es_reaction_time(2)))
end

subplot(12,4,35); hold on
set(gca,'xlim',[0 xlim_cs_stm_ipsi_move_beta],'ylim',[0 ylim_kin_metrics_cs_non_reaction_time])
pfit_cs_stm_ipsi_move_beta_ls_reaction_time=polyfit(data_sum_cs_stm_ipsi_move_beta(:,3),kin_metrics.cs.stm.reaction_time(:,3),1)
pval_cs_stm_ipsi_move_beta_ls_reaction_time=polyval(pfit_cs_stm_ipsi_move_beta_ls_reaction_time,data_sum_cs_stm_ipsi_move_beta(:,3))
[r_cs_stm_ipsi_move_beta_ls_reaction_time,p_cs_stm_ipsi_move_beta_ls_reaction_time]=corrcoef(data_sum_cs_stm_ipsi_move_beta(:,3),kin_metrics.cs.stm.reaction_time(:,3))
for i=1:size(data_sum_cs_stm_ipsi_move_beta(:,3),1)
    text(data_sum_cs_stm_ipsi_move_beta(i,3),kin_metrics.cs.stm.reaction_time(i,3),sbjs_non(i,:),'Color',plot_color(i))
end
plot(data_sum_cs_stm_ipsi_move_beta(:,3),pval_cs_stm_ipsi_move_beta_ls_reaction_time,'r','LineWidth',2)
if p_cs_stm_ipsi_move_beta_ls_reaction_time(2)<0.05
    title(num2str(p_cs_stm_ipsi_move_beta_ls_reaction_time(2)),'Color',2)
else
    title(num2str(p_cs_stm_ipsi_move_beta_ls_reaction_time(2)))
end

subplot(12,4,36); hold on
set(gca,'xlim',[0 xlim_cs_stm_ipsi_move_beta],'ylim',[0 ylim_kin_metrics_cs_non_reaction_time])
pfit_cs_stm_ipsi_move_beta_ps_reaction_time=polyfit(data_sum_cs_stm_ipsi_move_beta(:,4),kin_metrics.cs.stm.reaction_time(:,4),1)
pval_cs_stm_ipsi_move_beta_ps_reaction_time=polyval(pfit_cs_stm_ipsi_move_beta_ps_reaction_time,data_sum_cs_stm_ipsi_move_beta(:,4))
[r_cs_stm_ipsi_move_beta_ps_reaction_time,p_cs_stm_ipsi_move_beta_ps_reaction_time]=corrcoef(data_sum_cs_stm_ipsi_move_beta(:,4),kin_metrics.cs.stm.reaction_time(:,4))
for i=1:size(data_sum_cs_stm_ipsi_move_beta(:,4),1)
    text(data_sum_cs_stm_ipsi_move_beta(i,4),kin_metrics.cs.stm.reaction_time(i,4),sbjs_non(i,:),'Color',plot_color(i))
end
plot(data_sum_cs_stm_ipsi_move_beta(:,4),pval_cs_stm_ipsi_move_beta_ps_reaction_time,'r','LineWidth',2)
if p_cs_stm_ipsi_move_beta_ps_reaction_time(2)<0.05
    title(num2str(p_cs_stm_ipsi_move_beta_ps_reaction_time(2)),'Color',[1 0 0])
else
    title(num2str(p_cs_stm_ipsi_move_beta_ps_reaction_time(2)))
end

%time max vel
xlim_cs_stm_ipsi_move_beta=max(max(data_sum_cs_stm_ipsi_move_beta))
ylim_kin_metrics_cs_non_time_max_vel=max(max(kin_metrics.cs.stm.time_max_vel))

subplot(12,4,37); hold on
set(gca,'xlim',[0 xlim_cs_stm_ipsi_move_beta],'ylim',[0 ylim_kin_metrics_cs_non_time_max_vel])
pfit_cs_stm_ipsi_move_beta_bl_time_max_vel=polyfit(data_sum_cs_stm_ipsi_move_beta(:,1),kin_metrics.cs.stm.time_max_vel(:,1),1)
pval_cs_stm_ipsi_move_beta_bl_time_max_vel=polyval(pfit_cs_stm_ipsi_move_beta_bl_time_max_vel,data_sum_cs_stm_ipsi_move_beta(:,1))
[r_cs_stm_ipsi_move_beta_bl_time_max_vel,p_cs_stm_ipsi_move_beta_bl_time_max_vel]=corrcoef(data_sum_cs_stm_ipsi_move_beta(:,1),kin_metrics.cs.stm.time_max_vel(:,1))
for i=1:size(data_sum_cs_stm_ipsi_move_beta(:,1),1)
    text(data_sum_cs_stm_ipsi_move_beta(i,1),kin_metrics.cs.stm.time_max_vel(i,1),sbjs_non(i,:),'Color',plot_color(i))
end
plot(data_sum_cs_stm_ipsi_move_beta(:,1),pval_cs_stm_ipsi_move_beta_bl_time_max_vel,'r','LineWidth',2)
if p_cs_stm_ipsi_move_beta_bl_time_max_vel(2)<0.05
    title(num2str(p_cs_stm_ipsi_move_beta_bl_time_max_vel(2)),'Color',[1 0 0])
else
    title(num2str(p_cs_stm_ipsi_move_beta_bl_time_max_vel(2)))
end
ylabel('tmax vel')

subplot(12,4,38); hold on
set(gca,'xlim',[0 xlim_cs_stm_ipsi_move_beta],'ylim',[0 ylim_kin_metrics_cs_non_time_max_vel])
pfit_cs_stm_ipsi_move_beta_es_time_max_vel=polyfit(data_sum_cs_stm_ipsi_move_beta(:,2),kin_metrics.cs.stm.time_max_vel(:,2),1)
pval_cs_stm_ipsi_move_beta_es_time_max_vel=polyval(pfit_cs_stm_ipsi_move_beta_es_time_max_vel,data_sum_cs_stm_ipsi_move_beta(:,2))
[r_cs_stm_ipsi_move_beta_es_time_max_vel,p_cs_stm_ipsi_move_beta_es_time_max_vel]=corrcoef(data_sum_cs_stm_ipsi_move_beta(:,2),kin_metrics.cs.stm.time_max_vel(:,2))
for i=1:size(data_sum_cs_stm_ipsi_move_beta(:,2),1)
    text(data_sum_cs_stm_ipsi_move_beta(i,2),kin_metrics.cs.stm.time_max_vel(i,2),sbjs_non(i,:),'Color',plot_color(i))
end
plot(data_sum_cs_stm_ipsi_move_beta(:,2),pval_cs_stm_ipsi_move_beta_es_time_max_vel,'r','LineWidth',2)
if p_cs_stm_ipsi_move_beta_es_time_max_vel(2)<0.05
    title(num2str(p_cs_stm_ipsi_move_beta_es_time_max_vel(2)),'Color',[1 0 0])
else
    title(num2str(p_cs_stm_ipsi_move_beta_es_time_max_vel(2)))
end

subplot(12,4,39); hold on
set(gca,'xlim',[0 xlim_cs_stm_ipsi_move_beta],'ylim',[0 ylim_kin_metrics_cs_non_time_max_vel])
pfit_cs_stm_ipsi_move_beta_ls_time_max_vel=polyfit(data_sum_cs_stm_ipsi_move_beta(:,3),kin_metrics.cs.stm.time_max_vel(:,3),1)
pval_cs_stm_ipsi_move_beta_ls_time_max_vel=polyval(pfit_cs_stm_ipsi_move_beta_ls_time_max_vel,data_sum_cs_stm_ipsi_move_beta(:,3))
[r_cs_stm_ipsi_move_beta_ls_time_max_vel,p_cs_stm_ipsi_move_beta_ls_time_max_vel]=corrcoef(data_sum_cs_stm_ipsi_move_beta(:,3),kin_metrics.cs.stm.time_max_vel(:,3))
for i=1:size(data_sum_cs_stm_ipsi_move_beta(:,3),1)
    text(data_sum_cs_stm_ipsi_move_beta(i,3),kin_metrics.cs.stm.time_max_vel(i,3),sbjs_non(i,:),'Color',plot_color(i))
end
plot(data_sum_cs_stm_ipsi_move_beta(:,3),pval_cs_stm_ipsi_move_beta_ls_time_max_vel,'r','LineWidth',2)
if p_cs_stm_ipsi_move_beta_ls_time_max_vel(2)<0.05
    title(num2str(p_cs_stm_ipsi_move_beta_ls_time_max_vel(2)),'Color',[1 0 0])
else
    title(num2str(p_cs_stm_ipsi_move_beta_ls_time_max_vel(2)))
end

subplot(12,4,40); hold on
set(gca,'xlim',[0 xlim_cs_stm_ipsi_move_beta],'ylim',[0 ylim_kin_metrics_cs_non_time_max_vel])
pfit_cs_stm_ipsi_move_beta_ps_time_max_vel=polyfit(data_sum_cs_stm_ipsi_move_beta(:,4),kin_metrics.cs.stm.time_max_vel(:,4),1)
pval_cs_stm_ipsi_move_beta_ps_time_max_vel=polyval(pfit_cs_stm_ipsi_move_beta_ps_time_max_vel,data_sum_cs_stm_ipsi_move_beta(:,4))
[r_cs_stm_ipsi_move_beta_ps_time_max_vel,p_cs_stm_ipsi_move_beta_ps_time_max_vel]=corrcoef(data_sum_cs_stm_ipsi_move_beta(:,4),kin_metrics.cs.stm.time_max_vel(:,4))
for i=1:size(data_sum_cs_stm_ipsi_move_beta(:,4),1)
    text(data_sum_cs_stm_ipsi_move_beta(i,4),kin_metrics.cs.stm.time_max_vel(i,4),sbjs_non(i,:),'Color',plot_color(i))
end
plot(data_sum_cs_stm_ipsi_move_beta(:,4),pval_cs_stm_ipsi_move_beta_ps_time_max_vel,'r','LineWidth',2)
if p_cs_stm_ipsi_move_beta_ps_time_max_vel(2)<0.05
    title(num2str(p_cs_stm_ipsi_move_beta_ps_time_max_vel(2)),'Color',[1 0 0])
else
    title(num2str(p_cs_stm_ipsi_move_beta_ps_time_max_vel(2)))
end

%time max vel norm
xlim_cs_stm_ipsi_move_beta=max(max(data_sum_cs_stm_ipsi_move_beta))
ylim_kin_metrics_cs_non_time_max_vel_norm=max(max(kin_metrics.cs.stm.time_max_vel_norm))

subplot(12,4,41); hold on
set(gca,'xlim',[0 xlim_cs_stm_ipsi_move_beta],'ylim',[0 ylim_kin_metrics_cs_non_time_max_vel_norm])
pfit_cs_stm_ipsi_move_beta_bl_time_max_vel_norm=polyfit(data_sum_cs_stm_ipsi_move_beta(:,1),kin_metrics.cs.stm.time_max_vel_norm(:,1),1)
pval_cs_stm_ipsi_move_beta_bl_time_max_vel_norm=polyval(pfit_cs_stm_ipsi_move_beta_bl_time_max_vel_norm,data_sum_cs_stm_ipsi_move_beta(:,1))
[r_cs_stm_ipsi_move_beta_bl_time_max_vel_norm,p_cs_stm_ipsi_move_beta_bl_time_max_vel_norm]=corrcoef(data_sum_cs_stm_ipsi_move_beta(:,1),kin_metrics.cs.stm.time_max_vel_norm(:,1))
for i=1:size(data_sum_cs_stm_ipsi_move_beta(:,1),1)
    text(data_sum_cs_stm_ipsi_move_beta(i,1),kin_metrics.cs.stm.time_max_vel_norm(i,1),sbjs_non(i,:),'Color',plot_color(i))
end
plot(data_sum_cs_stm_ipsi_move_beta(:,1),pval_cs_stm_ipsi_move_beta_bl_time_max_vel_norm,'r','LineWidth',2)
if p_cs_stm_ipsi_move_beta_bl_time_max_vel_norm(2)<0.05
    title(num2str(p_cs_stm_ipsi_move_beta_bl_time_max_vel_norm(2)),'Color',[1 0 0])
else
    title(num2str(p_cs_stm_ipsi_move_beta_bl_time_max_vel_norm(2)))
end
ylabel('tmax veln')

subplot(12,4,42); hold on
set(gca,'xlim',[0 xlim_cs_stm_ipsi_move_beta],'ylim',[0 ylim_kin_metrics_cs_non_time_max_vel_norm])
pfit_cs_stm_ipsi_move_beta_es_time_max_vel_norm=polyfit(data_sum_cs_stm_ipsi_move_beta(:,2),kin_metrics.cs.stm.time_max_vel_norm(:,2),1)
pval_cs_stm_ipsi_move_beta_es_time_max_vel_norm=polyval(pfit_cs_stm_ipsi_move_beta_es_time_max_vel_norm,data_sum_cs_stm_ipsi_move_beta(:,2))
[r_cs_stm_ipsi_move_beta_es_time_max_vel_norm,p_cs_stm_ipsi_move_beta_es_time_max_vel_norm]=corrcoef(data_sum_cs_stm_ipsi_move_beta(:,2),kin_metrics.cs.stm.time_max_vel_norm(:,2))
for i=1:size(data_sum_cs_stm_ipsi_move_beta(:,2),1)
    text(data_sum_cs_stm_ipsi_move_beta(i,2),kin_metrics.cs.stm.time_max_vel_norm(i,2),sbjs_non(i,:),'Color',plot_color(i))
end
plot(data_sum_cs_stm_ipsi_move_beta(:,2),pval_cs_stm_ipsi_move_beta_es_time_max_vel_norm,'r','LineWidth',2)
if p_cs_stm_ipsi_move_beta_es_time_max_vel_norm(2)<0.05
    title(num2str(p_cs_stm_ipsi_move_beta_es_time_max_vel_norm(2)),'Color',[1 0 0])
else
    title(num2str(p_cs_stm_ipsi_move_beta_es_time_max_vel_norm(2)))
end

subplot(12,4,43); hold on
set(gca,'xlim',[0 xlim_cs_stm_ipsi_move_beta],'ylim',[0 ylim_kin_metrics_cs_non_time_max_vel_norm])
pfit_cs_stm_ipsi_move_beta_ls_time_max_vel_norm=polyfit(data_sum_cs_stm_ipsi_move_beta(:,3),kin_metrics.cs.stm.time_max_vel_norm(:,3),1)
pval_cs_stm_ipsi_move_beta_ls_time_max_vel_norm=polyval(pfit_cs_stm_ipsi_move_beta_ls_time_max_vel_norm,data_sum_cs_stm_ipsi_move_beta(:,3))
[r_cs_stm_ipsi_move_beta_ls_time_max_vel_norm,p_cs_stm_ipsi_move_beta_ls_time_max_vel_norm]=corrcoef(data_sum_cs_stm_ipsi_move_beta(:,3),kin_metrics.cs.stm.time_max_vel_norm(:,3))
for i=1:size(data_sum_cs_stm_ipsi_move_beta(:,3),1)
    text(data_sum_cs_stm_ipsi_move_beta(i,3),kin_metrics.cs.stm.time_max_vel_norm(i,3),sbjs_non(i,:),'Color',plot_color(i))
end
plot(data_sum_cs_stm_ipsi_move_beta(:,3),pval_cs_stm_ipsi_move_beta_ls_time_max_vel_norm,'r','LineWidth',2)
if p_cs_stm_ipsi_move_beta_ls_time_max_vel_norm(2)<0.05
    title(num2str(p_cs_stm_ipsi_move_beta_ls_time_max_vel_norm(2)),'Color',[1 0 0])
else
    title(num2str(p_cs_stm_ipsi_move_beta_ls_time_max_vel_norm(2)))
end

subplot(12,4,44); hold on
set(gca,'xlim',[0 xlim_cs_stm_ipsi_move_beta],'ylim',[0 ylim_kin_metrics_cs_non_time_max_vel_norm])
pfit_cs_stm_ipsi_move_beta_ps_time_max_vel_norm=polyfit(data_sum_cs_stm_ipsi_move_beta(:,4),kin_metrics.cs.stm.time_max_vel_norm(:,4),1)
pval_cs_stm_ipsi_move_beta_ps_time_max_vel_norm=polyval(pfit_cs_stm_ipsi_move_beta_ps_time_max_vel_norm,data_sum_cs_stm_ipsi_move_beta(:,4))
[r_cs_stm_ipsi_move_beta_ps_time_max_vel_norm,p_cs_stm_ipsi_move_beta_ps_time_max_vel_norm]=corrcoef(data_sum_cs_stm_ipsi_move_beta(:,4),kin_metrics.cs.stm.time_max_vel_norm(:,4))
for i=1:size(data_sum_cs_stm_ipsi_move_beta(:,4),1)
    text(data_sum_cs_stm_ipsi_move_beta(i,4),kin_metrics.cs.stm.time_max_vel_norm(i,4),sbjs_non(i,:),'Color',plot_color(i))
end
plot(data_sum_cs_stm_ipsi_move_beta(:,4),pval_cs_stm_ipsi_move_beta_ps_time_max_vel_norm,'r','LineWidth',2)
if p_cs_stm_ipsi_move_beta_ps_time_max_vel_norm(2)<0.05
    title(num2str(p_cs_stm_ipsi_move_beta_ps_time_max_vel_norm(2)),'Color',[1 0 0])
else
    title(num2str(p_cs_stm_ipsi_move_beta_ps_time_max_vel_norm(2)))
end

%vel peak
xlim_cs_stm_ipsi_move_beta=max(max(data_sum_cs_stm_ipsi_move_beta))
ylim_kin_metrics_cs_non_vel_peak=max(max(kin_metrics.cs.stm.vel_peak))

subplot(12,4,45); hold on
set(gca,'xlim',[0 xlim_cs_stm_ipsi_move_beta],'ylim',[0 ylim_kin_metrics_cs_non_vel_peak])
pfit_cs_stm_ipsi_move_beta_bl_vel_peak=polyfit(data_sum_cs_stm_ipsi_move_beta(:,1),kin_metrics.cs.stm.vel_peak(:,1),1)
pval_cs_stm_ipsi_move_beta_bl_vel_peak=polyval(pfit_cs_stm_ipsi_move_beta_bl_vel_peak,data_sum_cs_stm_ipsi_move_beta(:,1))
[r_cs_stm_ipsi_move_beta_bl_vel_peak,p_cs_stm_ipsi_move_beta_bl_vel_peak]=corrcoef(data_sum_cs_stm_ipsi_move_beta(:,1),kin_metrics.cs.stm.vel_peak(:,1))
for i=1:size(data_sum_cs_stm_ipsi_move_beta(:,1),1)
    text(data_sum_cs_stm_ipsi_move_beta(i,1),kin_metrics.cs.stm.vel_peak(i,1),sbjs_non(i,:),'Color',plot_color(i))
end
plot(data_sum_cs_stm_ipsi_move_beta(:,1),pval_cs_stm_ipsi_move_beta_bl_vel_peak,'r','LineWidth',2)
if p_cs_stm_ipsi_move_beta_bl_vel_peak(2)<0.05
    title(num2str(p_cs_stm_ipsi_move_beta_bl_vel_peak(2)),'Color',[1 0 0])
else
    title(num2str(p_cs_stm_ipsi_move_beta_bl_vel_peak(2)))
end
ylabel('vel peak')

subplot(12,4,46); hold on
set(gca,'xlim',[0 xlim_cs_stm_ipsi_move_beta],'ylim',[0 ylim_kin_metrics_cs_non_vel_peak])
pfit_cs_stm_ipsi_move_beta_es_vel_peak=polyfit(data_sum_cs_stm_ipsi_move_beta(:,2),kin_metrics.cs.stm.vel_peak(:,2),1)
pval_cs_stm_ipsi_move_beta_es_vel_peak=polyval(pfit_cs_stm_ipsi_move_beta_es_vel_peak,data_sum_cs_stm_ipsi_move_beta(:,2))
[r_cs_stm_ipsi_move_beta_es_vel_peak,p_cs_stm_ipsi_move_beta_es_vel_peak]=corrcoef(data_sum_cs_stm_ipsi_move_beta(:,2),kin_metrics.cs.stm.vel_peak(:,2))
for i=1:size(data_sum_cs_stm_ipsi_move_beta(:,2),1)
    text(data_sum_cs_stm_ipsi_move_beta(i,2),kin_metrics.cs.stm.vel_peak(i,2),sbjs_non(i,:),'Color',plot_color(i))
end
plot(data_sum_cs_stm_ipsi_move_beta(:,2),pval_cs_stm_ipsi_move_beta_es_vel_peak,'r','LineWidth',2)
if p_cs_stm_ipsi_move_beta_es_vel_peak(2)<0.05
    title(num2str(p_cs_stm_ipsi_move_beta_es_vel_peak(2)),'Color',[1 0 0])
else
    title(num2str(p_cs_stm_ipsi_move_beta_es_vel_peak(2)))
end

subplot(12,4,47); hold on
set(gca,'xlim',[0 xlim_cs_stm_ipsi_move_beta],'ylim',[0 ylim_kin_metrics_cs_non_vel_peak])
pfit_cs_stm_ipsi_move_beta_ls_vel_peak=polyfit(data_sum_cs_stm_ipsi_move_beta(:,3),kin_metrics.cs.stm.vel_peak(:,3),1)
pval_cs_stm_ipsi_move_beta_ls_vel_peak=polyval(pfit_cs_stm_ipsi_move_beta_ls_vel_peak,data_sum_cs_stm_ipsi_move_beta(:,3))
[r_cs_stm_ipsi_move_beta_ls_vel_peak,p_cs_stm_ipsi_move_beta_ls_vel_peak]=corrcoef(data_sum_cs_stm_ipsi_move_beta(:,3),kin_metrics.cs.stm.vel_peak(:,3))
for i=1:size(data_sum_cs_stm_ipsi_move_beta(:,3),1)
    text(data_sum_cs_stm_ipsi_move_beta(i,3),kin_metrics.cs.stm.vel_peak(i,3),sbjs_non(i,:),'Color',plot_color(i))
end
plot(data_sum_cs_stm_ipsi_move_beta(:,3),pval_cs_stm_ipsi_move_beta_ls_vel_peak,'r','LineWidth',2)
if p_cs_stm_ipsi_move_beta_ls_vel_peak(2)<0.05
    title(num2str(p_cs_stm_ipsi_move_beta_ls_vel_peak(2)),'Color',[1 0 0])
else
    title(num2str(p_cs_stm_ipsi_move_beta_ls_vel_peak(2)))
end

subplot(12,4,48); hold on
set(gca,'xlim',[0 xlim_cs_stm_ipsi_move_beta],'ylim',[0 ylim_kin_metrics_cs_non_vel_peak])
pfit_cs_stm_ipsi_move_beta_ps_vel_peak=polyfit(data_sum_cs_stm_ipsi_move_beta(:,4),kin_metrics.cs.stm.vel_peak(:,4),1)
pval_cs_stm_ipsi_move_beta_ps_vel_peak=polyval(pfit_cs_stm_ipsi_move_beta_ps_vel_peak,data_sum_cs_stm_ipsi_move_beta(:,4))
[r_cs_stm_ipsi_move_beta_ps_vel_peak,p_cs_stm_ipsi_move_beta_ps_vel_peak]=corrcoef(data_sum_cs_stm_ipsi_move_beta(:,4),kin_metrics.cs.stm.vel_peak(:,4))
for i=1:size(data_sum_cs_stm_ipsi_move_beta(:,4),1)
    text(data_sum_cs_stm_ipsi_move_beta(i,4),kin_metrics.cs.stm.vel_peak(i,4),sbjs_non(i,:),'Color',plot_color(i))
end
plot(data_sum_cs_stm_ipsi_move_beta(:,4),pval_cs_stm_ipsi_move_beta_ps_vel_peak,'r','LineWidth',2)
if p_cs_stm_ipsi_move_beta_ps_vel_peak(2)<0.05
    title(num2str(p_cs_stm_ipsi_move_beta_ps_vel_peak(2)),'Color',[1 0 0])
else
    title(num2str(p_cs_stm_ipsi_move_beta_ps_vel_peak(2)))
end





