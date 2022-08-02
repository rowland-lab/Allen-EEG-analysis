sbjs_stm=['03';'04';'05';'42';'43'];
elec_stm_ipsi=[7,7,18,18,7];
elec_stm_cont=[18,18,7,7,18];
sbjs_non=['13';'15';'17';'18';'21'];
elec_non_ipsi=[18,7,18,18,18];
elec_non_cont=[7,18,7,7,7];
plot_color=['k','b','g','c','m'];
phase={'atStartPosition';'cueEvent';'targetUp'}
metrics={'reaction_time';'hand_path_length';'avg_vel';'max_vel';'vel_peak';
    'time_max_vel';'time_max_vel_norm';'avg_accel';'max_accel';'accur';
    'norm_jerk';'idx_curv'}
cohort={'cs';'hc'};
stim_status={'stm';'non'};
lat={'ipsi';'cont'};
freq={'delta';'theta';'alpha';'beta';'low_gamma';'high_gamma'};






for i=1:5
    load(['/home/rowlandn/nr_data_analysis/data_analyzed/eeg/pro00087153_00',sbjs_stm(i,:),...
        '/analysis/S2-metrics/pro00087153_00',sbjs_stm(i,:),'_S2-Metrics.mat'])
    for j=1:12
        for k=1:4
            eval(['lr_beta_metric_',metrics{j},'_t',num2str(k),'(',num2str(i),')=metricdat.data{',num2str(j),'}(',num2str(k),')'])
        end
    end
    clear movementstart trialData metricdat s2rejecttrials
end

%%

for i=1%:2 (cohort)
    for j=2%1%:2 (stim_status)
        for k=1%:2 (lat)
            for l=4%1:6 (freq)
                for m=1:12%:12 % (metrics)
                    for n=1:4 %t
                        for o=1:3 %p
        eval(['pfit_',cohort{i},'_',stim_status{j},'_',lat{k},'_',freq{l},'_',metrics{m},'_t',num2str(n),'_p',num2str(o),'=polyfit(mean_mean_sum_',freq{l},'_',...
            't',num2str(n),'_p',num2str(o),'_',stim_status{j},'_',lat{k},',lr_',freq{l},'_metric_',metrics{m},'_t',num2str(n),',1)'])
        eval(['pval_',cohort{i},'_',stim_status{j},'_',lat{k},'_',freq{l},'_',metrics{m},'_t',num2str(n),'_p',num2str(o),'=polyval(pfit_',cohort{i},'_',...
            stim_status{j},'_',lat{k},'_',freq{l},'_',metrics{m},'_t',num2str(n),'_p',num2str(o),',mean_mean_sum_',freq{l},'_t',num2str(n),'_p',num2str(o),...
            '_',stim_status{j},'_',lat{k},')'])
        eval(['[r_',cohort{i},'_',stim_status{j},'_',lat{k},'_',freq{l},'_',metrics{m},'_t',num2str(n),'_p',num2str(o),',p_cc_',cohort{i},'_',stim_status{j},...
            '_',lat{k},'_',freq{l},'_',metrics{m},'_t',num2str(n),'_p',num2str(o),']=corrcoef(mean_mean_sum_',freq{l},'_t',num2str(n),'_p',num2str(o),'_',...
            stim_status{j},'_',lat{k},',lr_',freq{l},'_metric_',metrics{m},'_t',num2str(n),')'])
                        end
                    end
                end
            end
        end
    end
end
sp_table=[1:48];
figure
set(gcf,'Position',[228 -167 651 917])
count=0;
for i=1%:2 (cohort)
    for j=2%1%:2 (stim_status)
        for k=1%:2 (lat)
            for l=4%1:6 (freq)
                for m=1:12%:12 % (metrics)
                    for n=1:4%:4 %t
                        for o=3%1:3 %p
                            count=count+1;
                            subplot(12,4,sp_table(count)); hold on
                            eval(['plot(mean_mean_sum_',freq{l},'_t',num2str(n),'_p',num2str(o),'_',stim_status{j},'_',lat{k},',lr_',freq{l},'_metric_',metrics{m},...
                                '_t',num2str(n),',''.k'')'])
                            for p=1:5
                                eval(['text(mean_mean_sum_',freq{l},'_t',num2str(n),'_p',num2str(o),'_',stim_status{j},'_',lat{k},'(p),lr_',freq{l},'_metric_',...
                                    metrics{m},'_t',num2str(n),'(p),sbjs_',stim_status{j},'(p,:),''Color'',plot_color(p))'])
                            end
                            eval(['plot(mean_mean_sum_',freq{l},'_t',num2str(n),'_p',num2str(o),'_',stim_status{j},'_',lat{k},',pval_',cohort{i},'_',stim_status{j},...
                                '_',lat{k},'_',freq{l},'_',metrics{m},'_t',num2str(n),'_p',num2str(o),',''r'',''LineWidth'',2)'])
                            if eval(['p_cc_',cohort{i},'_',stim_status{j},'_',lat{k},'_',freq{l},'_',metrics{m},'_t',num2str(n),'_p',num2str(o),'(2)'])<0.05
                                eval(['title(num2str(p_cc_',cohort{i},'_',stim_status{j},'_',lat{k},'_',freq{l},'_',metrics{m},'_t',num2str(n),'_p',num2str(o),...
                                    '(2)),''Color'',[1 0 0])'])
                            else
                                eval(['title(num2str(p_cc_',cohort{i},'_',stim_status{j},'_',lat{k},'_',freq{l},'_',metrics{m},'_t',num2str(n),'_p',num2str(o),...
                                    '(2)))'])
                            end
                            
                            if count==1
                                ylabel('rt')
                            elseif count==5
                                ylabel('hpl')
                            elseif count==9
                                ylabel('av')
                            elseif count==13
                                ylabel('mv')
                            elseif count==17
                                ylabel('vp')
                             elseif count==21
                                ylabel('tmv')
                             elseif count==25
                                ylabel('tmvn')
                             elseif count==29
                                ylabel('aa')
                             elseif count==33
                                ylabel('ma')
                             elseif count==37
                                ylabel('acc')
                             elseif count==41
                                ylabel('nj')
                             elseif count==45
                                ylabel('idc')
                             end
                        end
                    end
                end
            end
        end
    end
end
    
%set(gca,'xlim',[0 xlim_cs_stm_ipsi_rest_beta],'ylim',[0 ylim_kin_metrics_cs_non_accur])
pfit_cs_stm_ipsi_beta_reaction_time_t1_p3=polyfit(mean_sum_beta_t1_p3_stm_ipsi,lr_beta_metric_reaction_time_t1,1)
pval_cs_stm_ipsi_beta_reaction_time_t1_p3=polyval(pfit_cs_stm_ipsi_beta_reaction_time_t1_p3,mean_sum_beta_t1_p3_stm_ipsi)
[r_cs_stm_ipsi_beta_reaction_time_t1_p3,p_cs_stm_ipsi_beta_reaction_time_t1_p3]=corrcoef(mean_sum_beta_t1_p3_stm_ipsi,lr_beta_metric_reaction_time_t1)
plot(mean_sum_beta_t1_p3_stm_ipsi,lr_beta_metric_reaction_time_t1,'.k')
for i=1:5
    text(mean_sum_beta_t1_p3_stm_ipsi(i),lr_beta_metric_reaction_time_t1(i),sbjs_stm(i,:),'Color',plot_color(i))
end
plot(mean_sum_beta_t1_p3_stm_ipsi,pval_cs_stm_ipsi_beta_reaction_time_t1_p3,'r','LineWidth',2)
if p_cs_stm_ipsi_beta_reaction_time_t1_p3(2)<0.05
    title(num2str(p_cs_stm_ipsi_beta_reaction_time_t1_p3(2)),'Color',[1 0 0])
else
    title(num2str(p_cs_stm_ipsi_beta_reaction_time_t1_p3(2)))
end
ylabel('rt')
%set(gca,'ylim',[0.15 0.9],'xlim',[0.3 1.3])

subplot(12,4,2); hold on
%set(gca,'xlim',[0 xlim_cs_stm_ipsi_rest_beta],'ylim',[0 ylim_kin_metrics_cs_non_accur])
pfit_cs_stm_ipsi_beta_reaction_time_t2_p3=polyfit(mean_sum_beta_t2_p3_stm_ipsi,lr_beta_metric_reaction_time_t2,1)
pval_cs_stm_ipsi_beta_reaction_time_t2_p3=polyval(pfit_cs_stm_ipsi_beta_reaction_time_t2_p3,mean_sum_beta_t2_p3_stm_ipsi)
[r_cs_stm_ipsi_beta_reaction_time_t2_p3,p_cs_stm_ipsi_beta_reaction_time_t2_p3]=corrcoef(mean_sum_beta_t2_p3_stm_ipsi,lr_beta_metric_reaction_time_t2)
plot(mean_sum_beta_t2_p3_stm_ipsi,lr_beta_metric_reaction_time_t2,'.k')
for i=1:5
    text(mean_sum_beta_t2_p3_stm_ipsi(i),lr_beta_metric_reaction_time_t2(i),sbjs_stm(i,:),'Color',plot_color(i))
end
plot(mean_sum_beta_t2_p3_stm_ipsi,pval_cs_stm_ipsi_beta_reaction_time_t2_p3,'r','LineWidth',2)
if p_cs_stm_ipsi_beta_reaction_time_t2_p3(2)<0.05
    title(num2str(p_cs_stm_ipsi_beta_reaction_time_t2_p3(2)),'Color',[1 0 0])
else
    title(num2str(p_cs_stm_ipsi_beta_reaction_time_t2_p3(2)))
end

subplot(12,4,3); hold on
%set(gca,'xlim',[0 xlim_cs_stm_ipsi_rest_beta],'ylim',[0 ylim_kin_metrics_cs_non_accur])
pfit_cs_stm_ipsi_beta_reaction_time_t3_p3=polyfit(mean_sum_beta_t3_p3_stm_ipsi,lr_beta_metric_reaction_time_t3,1)
pval_cs_stm_ipsi_beta_reaction_time_t3_p3=polyval(pfit_cs_stm_ipsi_beta_reaction_time_t3_p3,mean_sum_beta_t3_p3_stm_ipsi)
[r_cs_stm_ipsi_beta_reaction_time_t3_p3,p_cs_stm_ipsi_beta_reaction_time_t3_p3]=corrcoef(mean_sum_beta_t3_p3_stm_ipsi,lr_beta_metric_reaction_time_t3)
plot(mean_sum_beta_t3_p3_stm_ipsi,lr_beta_metric_reaction_time_t3,'.k')
for i=1:5
    text(mean_sum_beta_t3_p3_stm_ipsi(i),lr_beta_metric_reaction_time_t3(i),sbjs_stm(i,:),'Color',plot_color(i))
end
plot(mean_sum_beta_t3_p3_stm_ipsi,pval_cs_stm_ipsi_beta_reaction_time_t3_p3,'r','LineWidth',2)
if p_cs_stm_ipsi_beta_reaction_time_t3_p3(2)<0.05
    title(num2str(p_cs_stm_ipsi_beta_reaction_time_t3_p3(2)),'Color',[1 0 0])
else
    title(num2str(p_cs_stm_ipsi_beta_reaction_time_t3_p3(2)))
end

%figure
subplot(2,2,2); hold on
%set(gca,'xlim',[0 xlim_cs_stm_ipsi_rest_beta],'ylim',[0 ylim_kin_metrics_cs_non_accur])
pfit_cs_stm_ipsi_beta_reaction_time_t4_p3=polyfit(mean_sum_beta_t4_p3_stm_ipsi,lr_beta_metric_reaction_time_t4,1)
pval_cs_stm_ipsi_beta_reaction_time_t4_p3=polyval(pfit_cs_stm_ipsi_beta_reaction_time_t4_p3,mean_sum_beta_t4_p3_stm_ipsi)
[r_cs_stm_ipsi_beta_reaction_time_t4_p3,p_cs_stm_ipsi_beta_reaction_time_t4_p3]=corrcoef(mean_sum_beta_t4_p3_stm_ipsi,lr_beta_metric_reaction_time_t4)
plot(mean_sum_beta_t4_p3_stm_ipsi,lr_beta_metric_reaction_time_t4,'.k')
for i=1:5
    text(mean_sum_beta_t4_p3_stm_ipsi(i),lr_beta_metric_reaction_time_t4(i),sbjs_stm(i,:),'Color',plot_color(i))
end
plot(mean_sum_beta_t4_p3_stm_ipsi,pval_cs_stm_ipsi_beta_reaction_time_t4_p3,'r','LineWidth',2)
if p_cs_stm_ipsi_beta_reaction_time_t4_p3(2)<0.05
    title(num2str(p_cs_stm_ipsi_beta_reaction_time_t4_p3(2)),'Color',[1 0 0])
else
    title(num2str(p_cs_stm_ipsi_beta_reaction_time_t4_p3(2)))
end
set(gca,'ylim',[0.15 0.9],'xlim',[0.3 1.3])

%hand_path_length
subplot(12,4,5); hold on
%set(gca,'xlim',[0 xlim_cs_stm_ipsi_rest_beta],'ylim',[0 ylim_kin_metrics_cs_non_accur])
pfit_cs_stm_ipsi_beta_hand_path_length_t1_p3=polyfit(mean_sum_beta_t1_p3_stm_ipsi,lr_beta_metric_hand_path_length_t1,1)
pval_cs_stm_ipsi_beta_hand_path_length_t1_p3=polyval(pfit_cs_stm_ipsi_beta_hand_path_length_t1_p3,mean_sum_beta_t1_p3_stm_ipsi)
[r_cs_stm_ipsi_beta_hand_path_length_t1_p3,p_cs_stm_ipsi_beta_hand_path_length_t1_p3]=corrcoef(mean_sum_beta_t1_p3_stm_ipsi,lr_beta_metric_hand_path_length_t1)
plot(mean_sum_beta_t1_p3_stm_ipsi,lr_beta_metric_hand_path_length_t1,'.k')
for i=1:5
    text(mean_sum_beta_t1_p3_stm_ipsi(i),lr_beta_metric_hand_path_length_t1(i),sbjs_stm(i,:),'Color',plot_color(i))
end
plot(mean_sum_beta_t1_p3_stm_ipsi,pval_cs_stm_ipsi_beta_hand_path_length_t1_p3,'r','LineWidth',2)
if p_cs_stm_ipsi_beta_hand_path_length_t1_p3(2)<0.05
    title(num2str(p_cs_stm_ipsi_beta_hand_path_length_t1_p3(2)),'Color',[1 0 0])
else
    title(num2str(p_cs_stm_ipsi_beta_hand_path_length_t1_p3(2)))
end
ylabel('hpl')

subplot(12,4,6); hold on
%set(gca,'xlim',[0 xlim_cs_stm_ipsi_rest_beta],'ylim',[0 ylim_kin_metrics_cs_non_accur])
pfit_cs_stm_ipsi_beta_hand_path_length_t2_p3=polyfit(mean_sum_beta_t2_p3_stm_ipsi,lr_beta_metric_hand_path_length_t2,1)
pval_cs_stm_ipsi_beta_hand_path_length_t2_p3=polyval(pfit_cs_stm_ipsi_beta_hand_path_length_t2_p3,mean_sum_beta_t2_p3_stm_ipsi)
[r_cs_stm_ipsi_beta_hand_path_length_t2_p3,p_cs_stm_ipsi_beta_hand_path_length_t2_p3]=corrcoef(mean_sum_beta_t2_p3_stm_ipsi,lr_beta_metric_hand_path_length_t2)
plot(mean_sum_beta_t2_p3_stm_ipsi,lr_beta_metric_hand_path_length_t2,'.k')
for i=1:5
    text(mean_sum_beta_t2_p3_stm_ipsi(i),lr_beta_metric_hand_path_length_t2(i),sbjs_stm(i,:),'Color',plot_color(i))
end
plot(mean_sum_beta_t2_p3_stm_ipsi,pval_cs_stm_ipsi_beta_hand_path_length_t2_p3,'r','LineWidth',2)
if p_cs_stm_ipsi_beta_hand_path_length_t2_p3(2)<0.05
    title(num2str(p_cs_stm_ipsi_beta_hand_path_length_t2_p3(2)),'Color',[1 0 0])
else
    title(num2str(p_cs_stm_ipsi_beta_hand_path_length_t2_p3(2)))
end

subplot(12,4,7); hold on
%set(gca,'xlim',[0 xlim_cs_stm_ipsi_rest_beta],'ylim',[0 ylim_kin_metrics_cs_non_accur])
pfit_cs_stm_ipsi_beta_hand_path_length_t3_p3=polyfit(mean_sum_beta_t3_p3_stm_ipsi,lr_beta_metric_hand_path_length_t3,1)
pval_cs_stm_ipsi_beta_hand_path_length_t3_p3=polyval(pfit_cs_stm_ipsi_beta_hand_path_length_t3_p3,mean_sum_beta_t3_p3_stm_ipsi)
[r_cs_stm_ipsi_beta_hand_path_length_t3_p3,p_cs_stm_ipsi_beta_hand_path_length_t3_p3]=corrcoef(mean_sum_beta_t3_p3_stm_ipsi,lr_beta_metric_hand_path_length_t3)
plot(mean_sum_beta_t3_p3_stm_ipsi,lr_beta_metric_hand_path_length_t3,'.k')
for i=1:5
    text(mean_sum_beta_t3_p3_stm_ipsi(i),lr_beta_metric_hand_path_length_t3(i),sbjs_stm(i,:),'Color',plot_color(i))
end
plot(mean_sum_beta_t3_p3_stm_ipsi,pval_cs_stm_ipsi_beta_hand_path_length_t3_p3,'r','LineWidth',2)
if p_cs_stm_ipsi_beta_hand_path_length_t3_p3(2)<0.05
    title(num2str(p_cs_stm_ipsi_beta_hand_path_length_t3_p3(2)),'Color',[1 0 0])
else
    title(num2str(p_cs_stm_ipsi_beta_hand_path_length_t3_p3(2)))
end

subplot(12,4,8); hold on
%set(gca,'xlim',[0 xlim_cs_stm_ipsi_rest_beta],'ylim',[0 ylim_kin_metrics_cs_non_accur])
pfit_cs_stm_ipsi_beta_hand_path_length_t4_p3=polyfit(mean_sum_beta_t4_p3_stm_ipsi,lr_beta_metric_hand_path_length_t4,1)
pval_cs_stm_ipsi_beta_hand_path_length_t4_p3=polyval(pfit_cs_stm_ipsi_beta_hand_path_length_t4_p3,mean_sum_beta_t4_p3_stm_ipsi)
[r_cs_stm_ipsi_beta_hand_path_length_t4_p3,p_cs_stm_ipsi_beta_hand_path_length_t4_p3]=corrcoef(mean_sum_beta_t4_p3_stm_ipsi,lr_beta_metric_hand_path_length_t4)
plot(mean_sum_beta_t4_p3_stm_ipsi,lr_beta_metric_hand_path_length_t4,'.k')
for i=1:5
    text(mean_sum_beta_t4_p3_stm_ipsi(i),lr_beta_metric_hand_path_length_t4(i),sbjs_stm(i,:),'Color',plot_color(i))
end
plot(mean_sum_beta_t4_p3_stm_ipsi,pval_cs_stm_ipsi_beta_hand_path_length_t4_p3,'r','LineWidth',2)
if p_cs_stm_ipsi_beta_hand_path_length_t4_p3(2)<0.05
    title(num2str(p_cs_stm_ipsi_beta_hand_path_length_t4_p3(2)),'Color',[1 0 0])
else
    title(num2str(p_cs_stm_ipsi_beta_hand_path_length_t4_p3(2)))
end

%avg vel
subplot(12,4,9); hold on
%set(gca,'xlim',[0 xlim_cs_stm_ipsi_rest_beta],'ylim',[0 ylim_kin_metrics_cs_non_accur])
pfit_cs_stm_ipsi_beta_avg_vel_t1_p3=polyfit(mean_sum_beta_t1_p3_stm_ipsi,lr_beta_metric_avg_vel_t1,1)
pval_cs_stm_ipsi_beta_avg_vel_t1_p3=polyval(pfit_cs_stm_ipsi_beta_avg_vel_t1_p3,mean_sum_beta_t1_p3_stm_ipsi)
[r_cs_stm_ipsi_beta_avg_vel_t1_p3,p_cs_stm_ipsi_beta_avg_vel_t1_p3]=corrcoef(mean_sum_beta_t1_p3_stm_ipsi,lr_beta_metric_avg_vel_t1)
plot(mean_sum_beta_t1_p3_stm_ipsi,lr_beta_metric_avg_vel_t1,'.k')
for i=1:5
    text(mean_sum_beta_t1_p3_stm_ipsi(i),lr_beta_metric_avg_vel_t1(i),sbjs_stm(i,:),'Color',plot_color(i))
end
plot(mean_sum_beta_t1_p3_stm_ipsi,pval_cs_stm_ipsi_beta_avg_vel_t1_p3,'r','LineWidth',2)
if p_cs_stm_ipsi_beta_avg_vel_t1_p3(2)<0.05
    title(num2str(p_cs_stm_ipsi_beta_avg_vel_t1_p3(2)),'Color',[1 0 0])
else
    title(num2str(p_cs_stm_ipsi_beta_avg_vel_t1_p3(2)))
end
ylabel('av')

subplot(12,4,10); hold on
%set(gca,'xlim',[0 xlim_cs_stm_ipsi_rest_beta],'ylim',[0 ylim_kin_metrics_cs_non_accur])
pfit_cs_stm_ipsi_beta_avg_vel_t2_p3=polyfit(mean_sum_beta_t2_p3_stm_ipsi,lr_beta_metric_avg_vel_t2,1)
pval_cs_stm_ipsi_beta_avg_vel_t2_p3=polyval(pfit_cs_stm_ipsi_beta_avg_vel_t2_p3,mean_sum_beta_t2_p3_stm_ipsi)
[r_cs_stm_ipsi_beta_avg_vel_t2_p3,p_cs_stm_ipsi_beta_avg_vel_t2_p3]=corrcoef(mean_sum_beta_t2_p3_stm_ipsi,lr_beta_metric_avg_vel_t2)
plot(mean_sum_beta_t2_p3_stm_ipsi,lr_beta_metric_avg_vel_t2,'.k')
for i=1:5
    text(mean_sum_beta_t2_p3_stm_ipsi(i),lr_beta_metric_avg_vel_t2(i),sbjs_stm(i,:),'Color',plot_color(i))
end
plot(mean_sum_beta_t2_p3_stm_ipsi,pval_cs_stm_ipsi_beta_avg_vel_t2_p3,'r','LineWidth',2)
if p_cs_stm_ipsi_beta_avg_vel_t2_p3(2)<0.05
    title(num2str(p_cs_stm_ipsi_beta_avg_vel_t2_p3(2)),'Color',[1 0 0])
else
    title(num2str(p_cs_stm_ipsi_beta_avg_vel_t2_p3(2)))
end

subplot(12,4,11); hold on
%set(gca,'xlim',[0 xlim_cs_stm_ipsi_rest_beta],'ylim',[0 ylim_kin_metrics_cs_non_accur])
pfit_cs_stm_ipsi_beta_avg_vel_t3_p3=polyfit(mean_sum_beta_t3_p3_stm_ipsi,lr_beta_metric_avg_vel_t3,1)
pval_cs_stm_ipsi_beta_avg_vel_t3_p3=polyval(pfit_cs_stm_ipsi_beta_avg_vel_t3_p3,mean_sum_beta_t3_p3_stm_ipsi)
[r_cs_stm_ipsi_beta_avg_vel_t3_p3,p_cs_stm_ipsi_beta_avg_vel_t3_p3]=corrcoef(mean_sum_beta_t3_p3_stm_ipsi,lr_beta_metric_avg_vel_t3)
plot(mean_sum_beta_t3_p3_stm_ipsi,lr_beta_metric_avg_vel_t3,'.k')
for i=1:5
    text(mean_sum_beta_t3_p3_stm_ipsi(i),lr_beta_metric_avg_vel_t3(i),sbjs_stm(i,:),'Color',plot_color(i))
end
plot(mean_sum_beta_t3_p3_stm_ipsi,pval_cs_stm_ipsi_beta_avg_vel_t3_p3,'r','LineWidth',2)
if p_cs_stm_ipsi_beta_avg_vel_t3_p3(2)<0.05
    title(num2str(p_cs_stm_ipsi_beta_avg_vel_t3_p3(2)),'Color',[1 0 0])
else
    title(num2str(p_cs_stm_ipsi_beta_avg_vel_t3_p3(2)))
end

subplot(12,4,12); hold on
%set(gca,'xlim',[0 xlim_cs_stm_ipsi_rest_beta],'ylim',[0 ylim_kin_metrics_cs_non_accur])
pfit_cs_stm_ipsi_beta_avg_vel_t4_p3=polyfit(mean_sum_beta_t4_p3_stm_ipsi,lr_beta_metric_avg_vel_t4,1)
pval_cs_stm_ipsi_beta_avg_vel_t4_p3=polyval(pfit_cs_stm_ipsi_beta_avg_vel_t4_p3,mean_sum_beta_t4_p3_stm_ipsi)
[r_cs_stm_ipsi_beta_avg_vel_t4_p3,p_cs_stm_ipsi_beta_avg_vel_t4_p3]=corrcoef(mean_sum_beta_t4_p3_stm_ipsi,lr_beta_metric_avg_vel_t4)
plot(mean_sum_beta_t4_p3_stm_ipsi,lr_beta_metric_avg_vel_t4,'.k')
for i=1:5
    text(mean_sum_beta_t4_p3_stm_ipsi(i),lr_beta_metric_avg_vel_t4(i),sbjs_stm(i,:),'Color',plot_color(i))
end
plot(mean_sum_beta_t4_p3_stm_ipsi,pval_cs_stm_ipsi_beta_avg_vel_t4_p3,'r','LineWidth',2)
if p_cs_stm_ipsi_beta_avg_vel_t4_p3(2)<0.05
    title(num2str(p_cs_stm_ipsi_beta_avg_vel_t4_p3(2)),'Color',[1 0 0])
else
    title(num2str(p_cs_stm_ipsi_beta_avg_vel_t4_p3(2)))
end

%max_vel
subplot(12,4,13); hold on
%set(gca,'xlim',[0 xlim_cs_stm_ipsi_rest_beta],'ylim',[0 ylim_kin_metrics_cs_non_accur])
pfit_cs_stm_ipsi_beta_max_vel_t1_p3=polyfit(mean_sum_beta_t1_p3_stm_ipsi,lr_beta_metric_max_vel_t1,1)
pval_cs_stm_ipsi_beta_max_vel_t1_p3=polyval(pfit_cs_stm_ipsi_beta_max_vel_t1_p3,mean_sum_beta_t1_p3_stm_ipsi)
[r_cs_stm_ipsi_beta_max_vel_t1_p3,p_cs_stm_ipsi_beta_max_vel_t1_p3]=corrcoef(mean_sum_beta_t1_p3_stm_ipsi,lr_beta_metric_max_vel_t1)
plot(mean_sum_beta_t1_p3_stm_ipsi,lr_beta_metric_max_vel_t1,'.k')
for i=1:5
    text(mean_sum_beta_t1_p3_stm_ipsi(i),lr_beta_metric_max_vel_t1(i),sbjs_stm(i,:),'Color',plot_color(i))
end
plot(mean_sum_beta_t1_p3_stm_ipsi,pval_cs_stm_ipsi_beta_max_vel_t1_p3,'r','LineWidth',2)
if p_cs_stm_ipsi_beta_max_vel_t1_p3(2)<0.05
    title(num2str(p_cs_stm_ipsi_beta_max_vel_t1_p3(2)),'Color',[1 0 0])
else
    title(num2str(p_cs_stm_ipsi_beta_max_vel_t1_p3(2)))
end
ylabel('mv')

subplot(12,4,14); hold on
%set(gca,'xlim',[0 xlim_cs_stm_ipsi_rest_beta],'ylim',[0 ylim_kin_metrics_cs_non_accur])
pfit_cs_stm_ipsi_beta_max_vel_t2_p3=polyfit(mean_sum_beta_t2_p3_stm_ipsi,lr_beta_metric_max_vel_t2,1)
pval_cs_stm_ipsi_beta_max_vel_t2_p3=polyval(pfit_cs_stm_ipsi_beta_max_vel_t2_p3,mean_sum_beta_t2_p3_stm_ipsi)
[r_cs_stm_ipsi_beta_max_vel_t2_p3,p_cs_stm_ipsi_beta_max_vel_t2_p3]=corrcoef(mean_sum_beta_t2_p3_stm_ipsi,lr_beta_metric_max_vel_t2)
plot(mean_sum_beta_t2_p3_stm_ipsi,lr_beta_metric_max_vel_t2,'.k')
for i=1:5
    text(mean_sum_beta_t2_p3_stm_ipsi(i),lr_beta_metric_max_vel_t2(i),sbjs_stm(i,:),'Color',plot_color(i))
end
plot(mean_sum_beta_t2_p3_stm_ipsi,pval_cs_stm_ipsi_beta_max_vel_t2_p3,'r','LineWidth',2)
if p_cs_stm_ipsi_beta_max_vel_t2_p3(2)<0.05
    title(num2str(p_cs_stm_ipsi_beta_max_vel_t2_p3(2)),'Color',[1 0 0])
else
    title(num2str(p_cs_stm_ipsi_beta_max_vel_t2_p3(2)))
end

subplot(12,4,15); hold on
%set(gca,'xlim',[0 xlim_cs_stm_ipsi_rest_beta],'ylim',[0 ylim_kin_metrics_cs_non_accur])
pfit_cs_stm_ipsi_beta_max_vel_t3_p3=polyfit(mean_sum_beta_t3_p3_stm_ipsi,lr_beta_metric_max_vel_t3,1)
pval_cs_stm_ipsi_beta_max_vel_t3_p3=polyval(pfit_cs_stm_ipsi_beta_max_vel_t3_p3,mean_sum_beta_t3_p3_stm_ipsi)
[r_cs_stm_ipsi_beta_max_vel_t3_p3,p_cs_stm_ipsi_beta_max_vel_t3_p3]=corrcoef(mean_sum_beta_t3_p3_stm_ipsi,lr_beta_metric_max_vel_t3)
plot(mean_sum_beta_t3_p3_stm_ipsi,lr_beta_metric_max_vel_t3,'.k')
for i=1:5
    text(mean_sum_beta_t3_p3_stm_ipsi(i),lr_beta_metric_max_vel_t3(i),sbjs_stm(i,:),'Color',plot_color(i))
end
plot(mean_sum_beta_t3_p3_stm_ipsi,pval_cs_stm_ipsi_beta_max_vel_t3_p3,'r','LineWidth',2)
if p_cs_stm_ipsi_beta_max_vel_t3_p3(2)<0.05
    title(num2str(p_cs_stm_ipsi_beta_max_vel_t3_p3(2)),'Color',[1 0 0])
else
    title(num2str(p_cs_stm_ipsi_beta_max_vel_t3_p3(2)))
end

subplot(12,4,16); hold on
%set(gca,'xlim',[0 xlim_cs_stm_ipsi_rest_beta],'ylim',[0 ylim_kin_metrics_cs_non_accur])
pfit_cs_stm_ipsi_beta_max_vel_t4_p3=polyfit(mean_sum_beta_t4_p3_stm_ipsi,lr_beta_metric_max_vel_t4,1)
pval_cs_stm_ipsi_beta_max_vel_t4_p3=polyval(pfit_cs_stm_ipsi_beta_max_vel_t4_p3,mean_sum_beta_t4_p3_stm_ipsi)
[r_cs_stm_ipsi_beta_max_vel_t4_p3,p_cs_stm_ipsi_beta_max_vel_t4_p3]=corrcoef(mean_sum_beta_t4_p3_stm_ipsi,lr_beta_metric_max_vel_t4)
plot(mean_sum_beta_t4_p3_stm_ipsi,lr_beta_metric_max_vel_t4,'.k')
for i=1:5
    text(mean_sum_beta_t4_p3_stm_ipsi(i),lr_beta_metric_max_vel_t4(i),sbjs_stm(i,:),'Color',plot_color(i))
end
plot(mean_sum_beta_t4_p3_stm_ipsi,pval_cs_stm_ipsi_beta_max_vel_t4_p3,'r','LineWidth',2)
if p_cs_stm_ipsi_beta_max_vel_t4_p3(2)<0.05
    title(num2str(p_cs_stm_ipsi_beta_max_vel_t4_p3(2)),'Color',[1 0 0])
else
    title(num2str(p_cs_stm_ipsi_beta_max_vel_t4_p3(2)))
end

%vel_peak
subplot(12,4,17); hold on
%set(gca,'xlim',[0 xlim_cs_stm_ipsi_rest_beta],'ylim',[0 ylim_kin_metrics_cs_non_accur])
pfit_cs_stm_ipsi_beta_vel_peak_t1_p3=polyfit(mean_sum_beta_t1_p3_stm_ipsi,lr_beta_metric_vel_peak_t1,1)
pval_cs_stm_ipsi_beta_vel_peak_t1_p3=polyval(pfit_cs_stm_ipsi_beta_vel_peak_t1_p3,mean_sum_beta_t1_p3_stm_ipsi)
[r_cs_stm_ipsi_beta_vel_peak_t1_p3,p_cs_stm_ipsi_beta_vel_peak_t1_p3]=corrcoef(mean_sum_beta_t1_p3_stm_ipsi,lr_beta_metric_vel_peak_t1)
plot(mean_sum_beta_t1_p3_stm_ipsi,lr_beta_metric_vel_peak_t1,'.k')
for i=1:5
    text(mean_sum_beta_t1_p3_stm_ipsi(i),lr_beta_metric_vel_peak_t1(i),sbjs_stm(i,:),'Color',plot_color(i))
end
plot(mean_sum_beta_t1_p3_stm_ipsi,pval_cs_stm_ipsi_beta_vel_peak_t1_p3,'r','LineWidth',2)
if p_cs_stm_ipsi_beta_vel_peak_t1_p3(2)<0.05
    title(num2str(p_cs_stm_ipsi_beta_vel_peak_t1_p3(2)),'Color',[1 0 0])
else
    title(num2str(p_cs_stm_ipsi_beta_vel_peak_t1_p3(2)))
end
ylabel('vp')

subplot(12,4,18); hold on
%set(gca,'xlim',[0 xlim_cs_stm_ipsi_rest_beta],'ylim',[0 ylim_kin_metrics_cs_non_accur])
pfit_cs_stm_ipsi_beta_vel_peak_t2_p3=polyfit(mean_sum_beta_t2_p3_stm_ipsi,lr_beta_metric_vel_peak_t2,1)
pval_cs_stm_ipsi_beta_vel_peak_t2_p3=polyval(pfit_cs_stm_ipsi_beta_vel_peak_t2_p3,mean_sum_beta_t2_p3_stm_ipsi)
[r_cs_stm_ipsi_beta_vel_peak_t2_p3,p_cs_stm_ipsi_beta_vel_peak_t2_p3]=corrcoef(mean_sum_beta_t2_p3_stm_ipsi,lr_beta_metric_vel_peak_t2)
plot(mean_sum_beta_t2_p3_stm_ipsi,lr_beta_metric_vel_peak_t2,'.k')
for i=1:5
    text(mean_sum_beta_t2_p3_stm_ipsi(i),lr_beta_metric_vel_peak_t2(i),sbjs_stm(i,:),'Color',plot_color(i))
end
plot(mean_sum_beta_t2_p3_stm_ipsi,pval_cs_stm_ipsi_beta_vel_peak_t2_p3,'r','LineWidth',2)
if p_cs_stm_ipsi_beta_vel_peak_t2_p3(2)<0.05
    title(num2str(p_cs_stm_ipsi_beta_vel_peak_t2_p3(2)),'Color',[1 0 0])
else
    title(num2str(p_cs_stm_ipsi_beta_vel_peak_t2_p3(2)))
end

subplot(12,4,19); hold on
%set(gca,'xlim',[0 xlim_cs_stm_ipsi_rest_beta],'ylim',[0 ylim_kin_metrics_cs_non_accur])
pfit_cs_stm_ipsi_beta_vel_peak_t3_p3=polyfit(mean_sum_beta_t3_p3_stm_ipsi,lr_beta_metric_vel_peak_t3,1)
pval_cs_stm_ipsi_beta_vel_peak_t3_p3=polyval(pfit_cs_stm_ipsi_beta_vel_peak_t3_p3,mean_sum_beta_t3_p3_stm_ipsi)
[r_cs_stm_ipsi_beta_vel_peak_t3_p3,p_cs_stm_ipsi_beta_vel_peak_t3_p3]=corrcoef(mean_sum_beta_t3_p3_stm_ipsi,lr_beta_metric_vel_peak_t3)
plot(mean_sum_beta_t3_p3_stm_ipsi,lr_beta_metric_vel_peak_t3,'.k')
for i=1:5
    text(mean_sum_beta_t3_p3_stm_ipsi(i),lr_beta_metric_vel_peak_t3(i),sbjs_stm(i,:),'Color',plot_color(i))
end
plot(mean_sum_beta_t3_p3_stm_ipsi,pval_cs_stm_ipsi_beta_vel_peak_t3_p3,'r','LineWidth',2)
if p_cs_stm_ipsi_beta_vel_peak_t3_p3(2)<0.05
    title(num2str(p_cs_stm_ipsi_beta_vel_peak_t3_p3(2)),'Color',[1 0 0])
else
    title(num2str(p_cs_stm_ipsi_beta_vel_peak_t3_p3(2)))
end

subplot(12,4,20); hold on
%set(gca,'xlim',[0 xlim_cs_stm_ipsi_rest_beta],'ylim',[0 ylim_kin_metrics_cs_non_accur])
pfit_cs_stm_ipsi_beta_vel_peak_t4_p3=polyfit(mean_sum_beta_t4_p3_stm_ipsi,lr_beta_metric_vel_peak_t4,1)
pval_cs_stm_ipsi_beta_vel_peak_t4_p3=polyval(pfit_cs_stm_ipsi_beta_vel_peak_t4_p3,mean_sum_beta_t4_p3_stm_ipsi)
[r_cs_stm_ipsi_beta_vel_peak_t4_p3,p_cs_stm_ipsi_beta_vel_peak_t4_p3]=corrcoef(mean_sum_beta_t4_p3_stm_ipsi,lr_beta_metric_vel_peak_t4)
plot(mean_sum_beta_t4_p3_stm_ipsi,lr_beta_metric_vel_peak_t4,'.k')
for i=1:5
    text(mean_sum_beta_t4_p3_stm_ipsi(i),lr_beta_metric_vel_peak_t4(i),sbjs_stm(i,:),'Color',plot_color(i))
end
plot(mean_sum_beta_t4_p3_stm_ipsi,pval_cs_stm_ipsi_beta_vel_peak_t4_p3,'r','LineWidth',2)
if p_cs_stm_ipsi_beta_vel_peak_t4_p3(2)<0.05
    title(num2str(p_cs_stm_ipsi_beta_vel_peak_t4_p3(2)),'Color',[1 0 0])
else
    title(num2str(p_cs_stm_ipsi_beta_vel_peak_t4_p3(2)))
end

%time_max_vel
subplot(12,4,21); hold on
%set(gca,'xlim',[0 xlim_cs_stm_ipsi_rest_beta],'ylim',[0 ylim_kin_metrics_cs_non_accur])
pfit_cs_stm_ipsi_beta_time_max_vel_t1_p3=polyfit(mean_sum_beta_t1_p3_stm_ipsi,lr_beta_metric_time_max_vel_t1,1)
pval_cs_stm_ipsi_beta_time_max_vel_t1_p3=polyval(pfit_cs_stm_ipsi_beta_time_max_vel_t1_p3,mean_sum_beta_t1_p3_stm_ipsi)
[r_cs_stm_ipsi_beta_time_max_vel_t1_p3,p_cs_stm_ipsi_beta_time_max_vel_t1_p3]=corrcoef(mean_sum_beta_t1_p3_stm_ipsi,lr_beta_metric_time_max_vel_t1)
plot(mean_sum_beta_t1_p3_stm_ipsi,lr_beta_metric_time_max_vel_t1,'.k')
for i=1:5
    text(mean_sum_beta_t1_p3_stm_ipsi(i),lr_beta_metric_time_max_vel_t1(i),sbjs_stm(i,:),'Color',plot_color(i))
end
plot(mean_sum_beta_t1_p3_stm_ipsi,pval_cs_stm_ipsi_beta_time_max_vel_t1_p3,'r','LineWidth',2)
if p_cs_stm_ipsi_beta_time_max_vel_t1_p3(2)<0.05
    title(num2str(p_cs_stm_ipsi_beta_time_max_vel_t1_p3(2)),'Color',[1 0 0])
else
    title(num2str(p_cs_stm_ipsi_beta_time_max_vel_t1_p3(2)))
end
ylabel('tmv')

subplot(12,4,22); hold on
%set(gca,'xlim',[0 xlim_cs_stm_ipsi_rest_beta],'ylim',[0 ylim_kin_metrics_cs_non_accur])
pfit_cs_stm_ipsi_beta_time_max_vel_t2_p3=polyfit(mean_sum_beta_t2_p3_stm_ipsi,lr_beta_metric_time_max_vel_t2,1)
pval_cs_stm_ipsi_beta_time_max_vel_t2_p3=polyval(pfit_cs_stm_ipsi_beta_time_max_vel_t2_p3,mean_sum_beta_t2_p3_stm_ipsi)
[r_cs_stm_ipsi_beta_time_max_vel_t2_p3,p_cs_stm_ipsi_beta_time_max_vel_t2_p3]=corrcoef(mean_sum_beta_t2_p3_stm_ipsi,lr_beta_metric_time_max_vel_t2)
plot(mean_sum_beta_t2_p3_stm_ipsi,lr_beta_metric_time_max_vel_t2,'.k')
for i=1:5
    text(mean_sum_beta_t2_p3_stm_ipsi(i),lr_beta_metric_time_max_vel_t2(i),sbjs_stm(i,:),'Color',plot_color(i))
end
plot(mean_sum_beta_t2_p3_stm_ipsi,pval_cs_stm_ipsi_beta_time_max_vel_t2_p3,'r','LineWidth',2)
if p_cs_stm_ipsi_beta_time_max_vel_t2_p3(2)<0.05
    title(num2str(p_cs_stm_ipsi_beta_time_max_vel_t2_p3(2)),'Color',[1 0 0])
else
    title(num2str(p_cs_stm_ipsi_beta_time_max_vel_t2_p3(2)))
end

subplot(12,4,23); hold on
%set(gca,'xlim',[0 xlim_cs_stm_ipsi_rest_beta],'ylim',[0 ylim_kin_metrics_cs_non_accur])
pfit_cs_stm_ipsi_beta_time_max_vel_t3_p3=polyfit(mean_sum_beta_t3_p3_stm_ipsi,lr_beta_metric_time_max_vel_t3,1)
pval_cs_stm_ipsi_beta_time_max_vel_t3_p3=polyval(pfit_cs_stm_ipsi_beta_time_max_vel_t3_p3,mean_sum_beta_t3_p3_stm_ipsi)
[r_cs_stm_ipsi_beta_time_max_vel_t3_p3,p_cs_stm_ipsi_beta_time_max_vel_t3_p3]=corrcoef(mean_sum_beta_t3_p3_stm_ipsi,lr_beta_metric_time_max_vel_t3)
plot(mean_sum_beta_t3_p3_stm_ipsi,lr_beta_metric_time_max_vel_t3,'.k')
for i=1:5
    text(mean_sum_beta_t3_p3_stm_ipsi(i),lr_beta_metric_time_max_vel_t3(i),sbjs_stm(i,:),'Color',plot_color(i))
end
plot(mean_sum_beta_t3_p3_stm_ipsi,pval_cs_stm_ipsi_beta_time_max_vel_t3_p3,'r','LineWidth',2)
if p_cs_stm_ipsi_beta_time_max_vel_t3_p3(2)<0.05
    title(num2str(p_cs_stm_ipsi_beta_time_max_vel_t3_p3(2)),'Color',[1 0 0])
else
    title(num2str(p_cs_stm_ipsi_beta_time_max_vel_t3_p3(2)))
end

subplot(12,4,24); hold on
%set(gca,'xlim',[0 xlim_cs_stm_ipsi_rest_beta],'ylim',[0 ylim_kin_metrics_cs_non_accur])
pfit_cs_stm_ipsi_beta_time_max_vel_t4_p3=polyfit(mean_sum_beta_t4_p3_stm_ipsi,lr_beta_metric_time_max_vel_t4,1)
pval_cs_stm_ipsi_beta_time_max_vel_t4_p3=polyval(pfit_cs_stm_ipsi_beta_time_max_vel_t4_p3,mean_sum_beta_t4_p3_stm_ipsi)
[r_cs_stm_ipsi_beta_time_max_vel_t4_p3,p_cs_stm_ipsi_beta_time_max_vel_t4_p3]=corrcoef(mean_sum_beta_t4_p3_stm_ipsi,lr_beta_metric_time_max_vel_t4)
plot(mean_sum_beta_t4_p3_stm_ipsi,lr_beta_metric_time_max_vel_t4,'.k')
for i=1:5
    text(mean_sum_beta_t4_p3_stm_ipsi(i),lr_beta_metric_time_max_vel_t4(i),sbjs_stm(i,:),'Color',plot_color(i))
end
plot(mean_sum_beta_t4_p3_stm_ipsi,pval_cs_stm_ipsi_beta_time_max_vel_t4_p3,'r','LineWidth',2)
if p_cs_stm_ipsi_beta_time_max_vel_t4_p3(2)<0.05
    title(num2str(p_cs_stm_ipsi_beta_time_max_vel_t4_p3(2)),'Color',[1 0 0])
else
    title(num2str(p_cs_stm_ipsi_beta_time_max_vel_t4_p3(2)))
end

%time_max_vel_norm
subplot(12,4,25); hold on
%set(gca,'xlim',[0 xlim_cs_stm_ipsi_rest_beta],'ylim',[0 ylim_kin_metrics_cs_non_accur])
pfit_cs_stm_ipsi_beta_time_max_vel_norm_t1_p3=polyfit(mean_sum_beta_t1_p3_stm_ipsi,lr_beta_metric_time_max_vel_norm_t1,1)
pval_cs_stm_ipsi_beta_time_max_vel_norm_t1_p3=polyval(pfit_cs_stm_ipsi_beta_time_max_vel_norm_t1_p3,mean_sum_beta_t1_p3_stm_ipsi)
[r_cs_stm_ipsi_beta_time_max_vel_norm_t1_p3,p_cs_stm_ipsi_beta_time_max_vel_norm_t1_p3]=corrcoef(mean_sum_beta_t1_p3_stm_ipsi,lr_beta_metric_time_max_vel_norm_t1)
plot(mean_sum_beta_t1_p3_stm_ipsi,lr_beta_metric_time_max_vel_norm_t1,'.k')
for i=1:5
    text(mean_sum_beta_t1_p3_stm_ipsi(i),lr_beta_metric_time_max_vel_norm_t1(i),sbjs_stm(i,:),'Color',plot_color(i))
end
plot(mean_sum_beta_t1_p3_stm_ipsi,pval_cs_stm_ipsi_beta_time_max_vel_norm_t1_p3,'r','LineWidth',2)
if p_cs_stm_ipsi_beta_time_max_vel_norm_t1_p3(2)<0.05
    title(num2str(p_cs_stm_ipsi_beta_time_max_vel_norm_t1_p3(2)),'Color',[1 0 0])
else
    title(num2str(p_cs_stm_ipsi_beta_time_max_vel_norm_t1_p3(2)))
end
ylabel('tmvn')

subplot(12,4,26); hold on
%set(gca,'xlim',[0 xlim_cs_stm_ipsi_rest_beta],'ylim',[0 ylim_kin_metrics_cs_non_accur])
pfit_cs_stm_ipsi_beta_time_max_vel_norm_t2_p3=polyfit(mean_sum_beta_t2_p3_stm_ipsi,lr_beta_metric_time_max_vel_norm_t2,1)
pval_cs_stm_ipsi_beta_time_max_vel_norm_t2_p3=polyval(pfit_cs_stm_ipsi_beta_time_max_vel_norm_t2_p3,mean_sum_beta_t2_p3_stm_ipsi)
[r_cs_stm_ipsi_beta_time_max_vel_norm_t2_p3,p_cs_stm_ipsi_beta_time_max_vel_norm_t2_p3]=corrcoef(mean_sum_beta_t2_p3_stm_ipsi,lr_beta_metric_time_max_vel_norm_t2)
plot(mean_sum_beta_t2_p3_stm_ipsi,lr_beta_metric_time_max_vel_norm_t2,'.k')
for i=1:5
    text(mean_sum_beta_t2_p3_stm_ipsi(i),lr_beta_metric_time_max_vel_norm_t2(i),sbjs_stm(i,:),'Color',plot_color(i))
end
plot(mean_sum_beta_t2_p3_stm_ipsi,pval_cs_stm_ipsi_beta_time_max_vel_norm_t2_p3,'r','LineWidth',2)
if p_cs_stm_ipsi_beta_time_max_vel_norm_t2_p3(2)<0.05
    title(num2str(p_cs_stm_ipsi_beta_time_max_vel_norm_t2_p3(2)),'Color',[1 0 0])
else
    title(num2str(p_cs_stm_ipsi_beta_time_max_vel_norm_t2_p3(2)))
end

subplot(12,4,27); hold on
%set(gca,'xlim',[0 xlim_cs_stm_ipsi_rest_beta],'ylim',[0 ylim_kin_metrics_cs_non_accur])
pfit_cs_stm_ipsi_beta_time_max_vel_norm_t3_p3=polyfit(mean_sum_beta_t3_p3_stm_ipsi,lr_beta_metric_time_max_vel_norm_t3,1)
pval_cs_stm_ipsi_beta_time_max_vel_norm_t3_p3=polyval(pfit_cs_stm_ipsi_beta_time_max_vel_norm_t3_p3,mean_sum_beta_t3_p3_stm_ipsi)
[r_cs_stm_ipsi_beta_time_max_vel_norm_t3_p3,p_cs_stm_ipsi_beta_time_max_vel_norm_t3_p3]=corrcoef(mean_sum_beta_t3_p3_stm_ipsi,lr_beta_metric_time_max_vel_norm_t3)
plot(mean_sum_beta_t3_p3_stm_ipsi,lr_beta_metric_time_max_vel_norm_t3,'.k')
for i=1:5
    text(mean_sum_beta_t3_p3_stm_ipsi(i),lr_beta_metric_time_max_vel_norm_t3(i),sbjs_stm(i,:),'Color',plot_color(i))
end
plot(mean_sum_beta_t3_p3_stm_ipsi,pval_cs_stm_ipsi_beta_time_max_vel_norm_t3_p3,'r','LineWidth',2)
if p_cs_stm_ipsi_beta_time_max_vel_norm_t3_p3(2)<0.05
    title(num2str(p_cs_stm_ipsi_beta_time_max_vel_norm_t3_p3(2)),'Color',[1 0 0])
else
    title(num2str(p_cs_stm_ipsi_beta_time_max_vel_norm_t3_p3(2)))
end

subplot(12,4,28); hold on
%set(gca,'xlim',[0 xlim_cs_stm_ipsi_rest_beta],'ylim',[0 ylim_kin_metrics_cs_non_accur])
pfit_cs_stm_ipsi_beta_time_max_vel_norm_t4_p3=polyfit(mean_sum_beta_t4_p3_stm_ipsi,lr_beta_metric_time_max_vel_norm_t4,1)
pval_cs_stm_ipsi_beta_time_max_vel_norm_t4_p3=polyval(pfit_cs_stm_ipsi_beta_time_max_vel_norm_t4_p3,mean_sum_beta_t4_p3_stm_ipsi)
[r_cs_stm_ipsi_beta_time_max_vel_norm_t4_p3,p_cs_stm_ipsi_beta_time_max_vel_norm_t4_p3]=corrcoef(mean_sum_beta_t4_p3_stm_ipsi,lr_beta_metric_time_max_vel_norm_t4)
plot(mean_sum_beta_t4_p3_stm_ipsi,lr_beta_metric_time_max_vel_norm_t4,'.k')
for i=1:5
    text(mean_sum_beta_t4_p3_stm_ipsi(i),lr_beta_metric_time_max_vel_norm_t4(i),sbjs_stm(i,:),'Color',plot_color(i))
end
plot(mean_sum_beta_t4_p3_stm_ipsi,pval_cs_stm_ipsi_beta_time_max_vel_norm_t4_p3,'r','LineWidth',2)
if p_cs_stm_ipsi_beta_time_max_vel_norm_t4_p3(2)<0.05
    title(num2str(p_cs_stm_ipsi_beta_time_max_vel_norm_t4_p3(2)),'Color',[1 0 0])
else
    title(num2str(p_cs_stm_ipsi_beta_time_max_vel_norm_t4_p3(2)))
end

%avg_accel
subplot(12,4,29); hold on
%set(gca,'xlim',[0 xlim_cs_stm_ipsi_rest_beta],'ylim',[0 ylim_kin_metrics_cs_non_accur])
pfit_cs_stm_ipsi_beta_avg_accel_t1_p3=polyfit(mean_sum_beta_t1_p3_stm_ipsi,lr_beta_metric_avg_accel_t1,1)
pval_cs_stm_ipsi_beta_avg_accel_t1_p3=polyval(pfit_cs_stm_ipsi_beta_avg_accel_t1_p3,mean_sum_beta_t1_p3_stm_ipsi)
[r_cs_stm_ipsi_beta_avg_accel_t1_p3,p_cs_stm_ipsi_beta_avg_accel_t1_p3]=corrcoef(mean_sum_beta_t1_p3_stm_ipsi,lr_beta_metric_avg_accel_t1)
plot(mean_sum_beta_t1_p3_stm_ipsi,lr_beta_metric_avg_accel_t1,'.k')
for i=1:5
    text(mean_sum_beta_t1_p3_stm_ipsi(i),lr_beta_metric_avg_accel_t1(i),sbjs_stm(i,:),'Color',plot_color(i))
end
plot(mean_sum_beta_t1_p3_stm_ipsi,pval_cs_stm_ipsi_beta_avg_accel_t1_p3,'r','LineWidth',2)
if p_cs_stm_ipsi_beta_avg_accel_t1_p3(2)<0.05
    title(num2str(p_cs_stm_ipsi_beta_avg_accel_t1_p3(2)),'Color',[1 0 0])
else
    title(num2str(p_cs_stm_ipsi_beta_avg_accel_t1_p3(2)))
end
ylabel('aa')

subplot(12,4,30); hold on
%set(gca,'xlim',[0 xlim_cs_stm_ipsi_rest_beta],'ylim',[0 ylim_kin_metrics_cs_non_accur])
pfit_cs_stm_ipsi_beta_avg_accel_t2_p3=polyfit(mean_sum_beta_t2_p3_stm_ipsi,lr_beta_metric_avg_accel_t2,1)
pval_cs_stm_ipsi_beta_avg_accel_t2_p3=polyval(pfit_cs_stm_ipsi_beta_avg_accel_t2_p3,mean_sum_beta_t2_p3_stm_ipsi)
[r_cs_stm_ipsi_beta_avg_accel_t2_p3,p_cs_stm_ipsi_beta_avg_accel_t2_p3]=corrcoef(mean_sum_beta_t2_p3_stm_ipsi,lr_beta_metric_avg_accel_t2)
plot(mean_sum_beta_t2_p3_stm_ipsi,lr_beta_metric_avg_accel_t2,'.k')
for i=1:5
    text(mean_sum_beta_t2_p3_stm_ipsi(i),lr_beta_metric_avg_accel_t2(i),sbjs_stm(i,:),'Color',plot_color(i))
end
plot(mean_sum_beta_t2_p3_stm_ipsi,pval_cs_stm_ipsi_beta_avg_accel_t2_p3,'r','LineWidth',2)
if p_cs_stm_ipsi_beta_avg_accel_t2_p3(2)<0.05
    title(num2str(p_cs_stm_ipsi_beta_avg_accel_t2_p3(2)),'Color',[1 0 0])
else
    title(num2str(p_cs_stm_ipsi_beta_avg_accel_t2_p3(2)))
end

subplot(12,4,31); hold on
%set(gca,'xlim',[0 xlim_cs_stm_ipsi_rest_beta],'ylim',[0 ylim_kin_metrics_cs_non_accur])
pfit_cs_stm_ipsi_beta_avg_accel_t3_p3=polyfit(mean_sum_beta_t3_p3_stm_ipsi,lr_beta_metric_avg_accel_t3,1)
pval_cs_stm_ipsi_beta_avg_accel_t3_p3=polyval(pfit_cs_stm_ipsi_beta_avg_accel_t3_p3,mean_sum_beta_t3_p3_stm_ipsi)
[r_cs_stm_ipsi_beta_avg_accel_t3_p3,p_cs_stm_ipsi_beta_avg_accel_t3_p3]=corrcoef(mean_sum_beta_t3_p3_stm_ipsi,lr_beta_metric_avg_accel_t3)
plot(mean_sum_beta_t3_p3_stm_ipsi,lr_beta_metric_avg_accel_t3,'.k')
for i=1:5
    text(mean_sum_beta_t3_p3_stm_ipsi(i),lr_beta_metric_avg_accel_t3(i),sbjs_stm(i,:),'Color',plot_color(i))
end
plot(mean_sum_beta_t3_p3_stm_ipsi,pval_cs_stm_ipsi_beta_avg_accel_t3_p3,'r','LineWidth',2)
if p_cs_stm_ipsi_beta_avg_accel_t3_p3(2)<0.05
    title(num2str(p_cs_stm_ipsi_beta_avg_accel_t3_p3(2)),'Color',[1 0 0])
else
    title(num2str(p_cs_stm_ipsi_beta_avg_accel_t3_p3(2)))
end

subplot(12,4,32); hold on
%set(gca,'xlim',[0 xlim_cs_stm_ipsi_rest_beta],'ylim',[0 ylim_kin_metrics_cs_non_accur])
pfit_cs_stm_ipsi_beta_avg_accel_t4_p3=polyfit(mean_sum_beta_t4_p3_stm_ipsi,lr_beta_metric_avg_accel_t4,1)
pval_cs_stm_ipsi_beta_avg_accel_t4_p3=polyval(pfit_cs_stm_ipsi_beta_avg_accel_t4_p3,mean_sum_beta_t4_p3_stm_ipsi)
[r_cs_stm_ipsi_beta_avg_accel_t4_p3,p_cs_stm_ipsi_beta_avg_accel_t4_p3]=corrcoef(mean_sum_beta_t4_p3_stm_ipsi,lr_beta_metric_avg_accel_t4)
plot(mean_sum_beta_t4_p3_stm_ipsi,lr_beta_metric_avg_accel_t4,'.k')
for i=1:5
    text(mean_sum_beta_t4_p3_stm_ipsi(i),lr_beta_metric_avg_accel_t4(i),sbjs_stm(i,:),'Color',plot_color(i))
end
plot(mean_sum_beta_t4_p3_stm_ipsi,pval_cs_stm_ipsi_beta_avg_accel_t4_p3,'r','LineWidth',2)
if p_cs_stm_ipsi_beta_avg_accel_t4_p3(2)<0.05
    title(num2str(p_cs_stm_ipsi_beta_avg_accel_t4_p3(2)),'Color',[1 0 0])
else
    title(num2str(p_cs_stm_ipsi_beta_avg_accel_t4_p3(2)))
end

%max_accel
subplot(12,4,33); hold on
%set(gca,'xlim',[0 xlim_cs_stm_ipsi_rest_beta],'ylim',[0 ylim_kin_metrics_cs_non_accur])
pfit_cs_stm_ipsi_beta_max_accel_t1_p3=polyfit(mean_sum_beta_t1_p3_stm_ipsi,lr_beta_metric_max_accel_t1,1)
pval_cs_stm_ipsi_beta_max_accel_t1_p3=polyval(pfit_cs_stm_ipsi_beta_max_accel_t1_p3,mean_sum_beta_t1_p3_stm_ipsi)
[r_cs_stm_ipsi_beta_max_accel_t1_p3,p_cs_stm_ipsi_beta_max_accel_t1_p3]=corrcoef(mean_sum_beta_t1_p3_stm_ipsi,lr_beta_metric_max_accel_t1)
plot(mean_sum_beta_t1_p3_stm_ipsi,lr_beta_metric_max_accel_t1,'.k')
for i=1:5
    text(mean_sum_beta_t1_p3_stm_ipsi(i),lr_beta_metric_max_accel_t1(i),sbjs_stm(i,:),'Color',plot_color(i))
end
plot(mean_sum_beta_t1_p3_stm_ipsi,pval_cs_stm_ipsi_beta_max_accel_t1_p3,'r','LineWidth',2)
if p_cs_stm_ipsi_beta_max_accel_t1_p3(2)<0.05
    title(num2str(p_cs_stm_ipsi_beta_max_accel_t1_p3(2)),'Color',[1 0 0])
else
    title(num2str(p_cs_stm_ipsi_beta_max_accel_t1_p3(2)))
end
ylabel('ma')

subplot(12,4,34); hold on
%set(gca,'xlim',[0 xlim_cs_stm_ipsi_rest_beta],'ylim',[0 ylim_kin_metrics_cs_non_accur])
pfit_cs_stm_ipsi_beta_max_accel_t2_p3=polyfit(mean_sum_beta_t2_p3_stm_ipsi,lr_beta_metric_max_accel_t2,1)
pval_cs_stm_ipsi_beta_max_accel_t2_p3=polyval(pfit_cs_stm_ipsi_beta_max_accel_t2_p3,mean_sum_beta_t2_p3_stm_ipsi)
[r_cs_stm_ipsi_beta_max_accel_t2_p3,p_cs_stm_ipsi_beta_max_accel_t2_p3]=corrcoef(mean_sum_beta_t2_p3_stm_ipsi,lr_beta_metric_max_accel_t2)
plot(mean_sum_beta_t2_p3_stm_ipsi,lr_beta_metric_max_accel_t2,'.k')
for i=1:5
    text(mean_sum_beta_t2_p3_stm_ipsi(i),lr_beta_metric_max_accel_t2(i),sbjs_stm(i,:),'Color',plot_color(i))
end
plot(mean_sum_beta_t2_p3_stm_ipsi,pval_cs_stm_ipsi_beta_max_accel_t2_p3,'r','LineWidth',2)
if p_cs_stm_ipsi_beta_max_accel_t2_p3(2)<0.05
    title(num2str(p_cs_stm_ipsi_beta_max_accel_t2_p3(2)),'Color',[1 0 0])
else
    title(num2str(p_cs_stm_ipsi_beta_max_accel_t2_p3(2)))
end

subplot(12,4,35); hold on
%set(gca,'xlim',[0 xlim_cs_stm_ipsi_rest_beta],'ylim',[0 ylim_kin_metrics_cs_non_accur])
pfit_cs_stm_ipsi_beta_max_accel_t3_p3=polyfit(mean_sum_beta_t3_p3_stm_ipsi,lr_beta_metric_max_accel_t3,1)
pval_cs_stm_ipsi_beta_max_accel_t3_p3=polyval(pfit_cs_stm_ipsi_beta_max_accel_t3_p3,mean_sum_beta_t3_p3_stm_ipsi)
[r_cs_stm_ipsi_beta_max_accel_t3_p3,p_cs_stm_ipsi_beta_max_accel_t3_p3]=corrcoef(mean_sum_beta_t3_p3_stm_ipsi,lr_beta_metric_max_accel_t3)
plot(mean_sum_beta_t3_p3_stm_ipsi,lr_beta_metric_max_accel_t3,'.k')
for i=1:5
    text(mean_sum_beta_t3_p3_stm_ipsi(i),lr_beta_metric_max_accel_t3(i),sbjs_stm(i,:),'Color',plot_color(i))
end
plot(mean_sum_beta_t3_p3_stm_ipsi,pval_cs_stm_ipsi_beta_max_accel_t3_p3,'r','LineWidth',2)
if p_cs_stm_ipsi_beta_max_accel_t3_p3(2)<0.05
    title(num2str(p_cs_stm_ipsi_beta_max_accel_t3_p3(2)),'Color',[1 0 0])
else
    title(num2str(p_cs_stm_ipsi_beta_max_accel_t3_p3(2)))
end

subplot(12,4,36); hold on
%set(gca,'xlim',[0 xlim_cs_stm_ipsi_rest_beta],'ylim',[0 ylim_kin_metrics_cs_non_accur])
pfit_cs_stm_ipsi_beta_max_accel_t4_p3=polyfit(mean_sum_beta_t4_p3_stm_ipsi,lr_beta_metric_max_accel_t4,1)
pval_cs_stm_ipsi_beta_max_accel_t4_p3=polyval(pfit_cs_stm_ipsi_beta_max_accel_t4_p3,mean_sum_beta_t4_p3_stm_ipsi)
[r_cs_stm_ipsi_beta_max_accel_t4_p3,p_cs_stm_ipsi_beta_max_accel_t4_p3]=corrcoef(mean_sum_beta_t4_p3_stm_ipsi,lr_beta_metric_max_accel_t4)
plot(mean_sum_beta_t4_p3_stm_ipsi,lr_beta_metric_max_accel_t4,'.k')
for i=1:5
    text(mean_sum_beta_t4_p3_stm_ipsi(i),lr_beta_metric_max_accel_t4(i),sbjs_stm(i,:),'Color',plot_color(i))
end
plot(mean_sum_beta_t4_p3_stm_ipsi,pval_cs_stm_ipsi_beta_max_accel_t4_p3,'r','LineWidth',2)
if p_cs_stm_ipsi_beta_max_accel_t4_p3(2)<0.05
    title(num2str(p_cs_stm_ipsi_beta_max_accel_t4_p3(2)),'Color',[1 0 0])
else
    title(num2str(p_cs_stm_ipsi_beta_max_accel_t4_p3(2)))
end

%accur
subplot(12,4,37); hold on
%set(gca,'xlim',[0 xlim_cs_stm_ipsi_rest_beta],'ylim',[0 ylim_kin_metrics_cs_non_accur])
pfit_cs_stm_ipsi_beta_accur_t1_p3=polyfit(mean_sum_beta_t1_p3_stm_ipsi,lr_beta_metric_accur_t1,1)
pval_cs_stm_ipsi_beta_accur_t1_p3=polyval(pfit_cs_stm_ipsi_beta_accur_t1_p3,mean_sum_beta_t1_p3_stm_ipsi)
[r_cs_stm_ipsi_beta_accur_t1_p3,p_cs_stm_ipsi_beta_accur_t1_p3]=corrcoef(mean_sum_beta_t1_p3_stm_ipsi,lr_beta_metric_accur_t1)
plot(mean_sum_beta_t1_p3_stm_ipsi,lr_beta_metric_accur_t1,'.k')
for i=1:5
    text(mean_sum_beta_t1_p3_stm_ipsi(i),lr_beta_metric_accur_t1(i),sbjs_stm(i,:),'Color',plot_color(i))
end
plot(mean_sum_beta_t1_p3_stm_ipsi,pval_cs_stm_ipsi_beta_accur_t1_p3,'r','LineWidth',2)
if p_cs_stm_ipsi_beta_accur_t1_p3(2)<0.05
    title(num2str(p_cs_stm_ipsi_beta_accur_t1_p3(2)),'Color',[1 0 0])
else
    title(num2str(p_cs_stm_ipsi_beta_accur_t1_p3(2)))
end
ylabel('acc')

subplot(12,4,38); hold on
%set(gca,'xlim',[0 xlim_cs_stm_ipsi_rest_beta],'ylim',[0 ylim_kin_metrics_cs_non_accur])
pfit_cs_stm_ipsi_beta_accur_t2_p3=polyfit(mean_sum_beta_t2_p3_stm_ipsi,lr_beta_metric_accur_t2,1)
pval_cs_stm_ipsi_beta_accur_t2_p3=polyval(pfit_cs_stm_ipsi_beta_accur_t2_p3,mean_sum_beta_t2_p3_stm_ipsi)
[r_cs_stm_ipsi_beta_accur_t2_p3,p_cs_stm_ipsi_beta_accur_t2_p3]=corrcoef(mean_sum_beta_t2_p3_stm_ipsi,lr_beta_metric_accur_t2)
plot(mean_sum_beta_t2_p3_stm_ipsi,lr_beta_metric_accur_t2,'.k')
for i=1:5
    text(mean_sum_beta_t2_p3_stm_ipsi(i),lr_beta_metric_accur_t2(i),sbjs_stm(i,:),'Color',plot_color(i))
end
plot(mean_sum_beta_t2_p3_stm_ipsi,pval_cs_stm_ipsi_beta_accur_t2_p3,'r','LineWidth',2)
if p_cs_stm_ipsi_beta_accur_t2_p3(2)<0.05
    title(num2str(p_cs_stm_ipsi_beta_accur_t2_p3(2)),'Color',[1 0 0])
else
    title(num2str(p_cs_stm_ipsi_beta_accur_t2_p3(2)))
end

subplot(12,4,39); hold on
%set(gca,'xlim',[0 xlim_cs_stm_ipsi_rest_beta],'ylim',[0 ylim_kin_metrics_cs_non_accur])
pfit_cs_stm_ipsi_beta_accur_t3_p3=polyfit(mean_sum_beta_t3_p3_stm_ipsi,lr_beta_metric_accur_t3,1)
pval_cs_stm_ipsi_beta_accur_t3_p3=polyval(pfit_cs_stm_ipsi_beta_accur_t3_p3,mean_sum_beta_t3_p3_stm_ipsi)
[r_cs_stm_ipsi_beta_accur_t3_p3,p_cs_stm_ipsi_beta_accur_t3_p3]=corrcoef(mean_sum_beta_t3_p3_stm_ipsi,lr_beta_metric_accur_t3)
plot(mean_sum_beta_t3_p3_stm_ipsi,lr_beta_metric_accur_t3,'.k')
for i=1:5
    text(mean_sum_beta_t3_p3_stm_ipsi(i),lr_beta_metric_accur_t3(i),sbjs_stm(i,:),'Color',plot_color(i))
end
plot(mean_sum_beta_t3_p3_stm_ipsi,pval_cs_stm_ipsi_beta_accur_t3_p3,'r','LineWidth',2)
if p_cs_stm_ipsi_beta_accur_t3_p3(2)<0.05
    title(num2str(p_cs_stm_ipsi_beta_accur_t3_p3(2)),'Color',[1 0 0])
else
    title(num2str(p_cs_stm_ipsi_beta_accur_t3_p3(2)))
end

subplot(12,4,40); hold on
%set(gca,'xlim',[0 xlim_cs_stm_ipsi_rest_beta],'ylim',[0 ylim_kin_metrics_cs_non_accur])
pfit_cs_stm_ipsi_beta_accur_t4_p3=polyfit(mean_sum_beta_t4_p3_stm_ipsi,lr_beta_metric_accur_t4,1)
pval_cs_stm_ipsi_beta_accur_t4_p3=polyval(pfit_cs_stm_ipsi_beta_accur_t4_p3,mean_sum_beta_t4_p3_stm_ipsi)
[r_cs_stm_ipsi_beta_accur_t4_p3,p_cs_stm_ipsi_beta_accur_t4_p3]=corrcoef(mean_sum_beta_t4_p3_stm_ipsi,lr_beta_metric_accur_t4)
plot(mean_sum_beta_t4_p3_stm_ipsi,lr_beta_metric_accur_t4,'.k')
for i=1:5
    text(mean_sum_beta_t4_p3_stm_ipsi(i),lr_beta_metric_accur_t4(i),sbjs_stm(i,:),'Color',plot_color(i))
end
plot(mean_sum_beta_t4_p3_stm_ipsi,pval_cs_stm_ipsi_beta_accur_t4_p3,'r','LineWidth',2)
if p_cs_stm_ipsi_beta_accur_t4_p3(2)<0.05
    title(num2str(p_cs_stm_ipsi_beta_accur_t4_p3(2)),'Color',[1 0 0])
else
    title(num2str(p_cs_stm_ipsi_beta_accur_t4_p3(2)))
end

%norm_jerk
subplot(12,4,41); hold on
%set(gca,'xlim',[0 xlim_cs_stm_ipsi_rest_beta],'ylim',[0 ylim_kin_metrics_cs_non_norm_jerk])
pfit_cs_stm_ipsi_beta_norm_jerk_t1_p3=polyfit(mean_sum_beta_t1_p3_stm_ipsi,lr_beta_metric_norm_jerk_t1,1)
pval_cs_stm_ipsi_beta_norm_jerk_t1_p3=polyval(pfit_cs_stm_ipsi_beta_norm_jerk_t1_p3,mean_sum_beta_t1_p3_stm_ipsi)
[r_cs_stm_ipsi_beta_norm_jerk_t1_p3,p_cs_stm_ipsi_beta_norm_jerk_t1_p3]=corrcoef(mean_sum_beta_t1_p3_stm_ipsi,lr_beta_metric_norm_jerk_t1)
plot(mean_sum_beta_t1_p3_stm_ipsi,lr_beta_metric_norm_jerk_t1,'.k')
for i=1:5
    text(mean_sum_beta_t1_p3_stm_ipsi(i),lr_beta_metric_norm_jerk_t1(i),sbjs_stm(i,:),'Color',plot_color(i))
end
plot(mean_sum_beta_t1_p3_stm_ipsi,pval_cs_stm_ipsi_beta_norm_jerk_t1_p3,'r','LineWidth',2)
if p_cs_stm_ipsi_beta_norm_jerk_t1_p3(2)<0.05
    title(num2str(p_cs_stm_ipsi_beta_norm_jerk_t1_p3(2)),'Color',[1 0 0])
else
    title(num2str(p_cs_stm_ipsi_beta_norm_jerk_t1_p3(2)))
end
ylabel('acc')

subplot(12,4,42); hold on
%set(gca,'xlim',[0 xlim_cs_stm_ipsi_rest_beta],'ylim',[0 ylim_kin_metrics_cs_non_norm_jerk])
pfit_cs_stm_ipsi_beta_norm_jerk_t2_p3=polyfit(mean_sum_beta_t2_p3_stm_ipsi,lr_beta_metric_norm_jerk_t2,1)
pval_cs_stm_ipsi_beta_norm_jerk_t2_p3=polyval(pfit_cs_stm_ipsi_beta_norm_jerk_t2_p3,mean_sum_beta_t2_p3_stm_ipsi)
[r_cs_stm_ipsi_beta_norm_jerk_t2_p3,p_cs_stm_ipsi_beta_norm_jerk_t2_p3]=corrcoef(mean_sum_beta_t2_p3_stm_ipsi,lr_beta_metric_norm_jerk_t2)
plot(mean_sum_beta_t2_p3_stm_ipsi,lr_beta_metric_norm_jerk_t2,'.k')
for i=1:5
    text(mean_sum_beta_t2_p3_stm_ipsi(i),lr_beta_metric_norm_jerk_t2(i),sbjs_stm(i,:),'Color',plot_color(i))
end
plot(mean_sum_beta_t2_p3_stm_ipsi,pval_cs_stm_ipsi_beta_norm_jerk_t2_p3,'r','LineWidth',2)
if p_cs_stm_ipsi_beta_norm_jerk_t2_p3(2)<0.05
    title(num2str(p_cs_stm_ipsi_beta_norm_jerk_t2_p3(2)),'Color',[1 0 0])
else
    title(num2str(p_cs_stm_ipsi_beta_norm_jerk_t2_p3(2)))
end

subplot(12,4,43); hold on
%set(gca,'xlim',[0 xlim_cs_stm_ipsi_rest_beta],'ylim',[0 ylim_kin_metrics_cs_non_norm_jerk])
pfit_cs_stm_ipsi_beta_norm_jerk_t3_p3=polyfit(mean_sum_beta_t3_p3_stm_ipsi,lr_beta_metric_norm_jerk_t3,1)
pval_cs_stm_ipsi_beta_norm_jerk_t3_p3=polyval(pfit_cs_stm_ipsi_beta_norm_jerk_t3_p3,mean_sum_beta_t3_p3_stm_ipsi)
[r_cs_stm_ipsi_beta_norm_jerk_t3_p3,p_cs_stm_ipsi_beta_norm_jerk_t3_p3]=corrcoef(mean_sum_beta_t3_p3_stm_ipsi,lr_beta_metric_norm_jerk_t3)
plot(mean_sum_beta_t3_p3_stm_ipsi,lr_beta_metric_norm_jerk_t3,'.k')
for i=1:5
    text(mean_sum_beta_t3_p3_stm_ipsi(i),lr_beta_metric_norm_jerk_t3(i),sbjs_stm(i,:),'Color',plot_color(i))
end
plot(mean_sum_beta_t3_p3_stm_ipsi,pval_cs_stm_ipsi_beta_norm_jerk_t3_p3,'r','LineWidth',2)
if p_cs_stm_ipsi_beta_norm_jerk_t3_p3(2)<0.05
    title(num2str(p_cs_stm_ipsi_beta_norm_jerk_t3_p3(2)),'Color',[1 0 0])
else
    title(num2str(p_cs_stm_ipsi_beta_norm_jerk_t3_p3(2)))
end

subplot(12,4,44); hold on
%set(gca,'xlim',[0 xlim_cs_stm_ipsi_rest_beta],'ylim',[0 ylim_kin_metrics_cs_non_norm_jerk])
pfit_cs_stm_ipsi_beta_norm_jerk_t4_p3=polyfit(mean_sum_beta_t4_p3_stm_ipsi,lr_beta_metric_norm_jerk_t4,1)
pval_cs_stm_ipsi_beta_norm_jerk_t4_p3=polyval(pfit_cs_stm_ipsi_beta_norm_jerk_t4_p3,mean_sum_beta_t4_p3_stm_ipsi)
[r_cs_stm_ipsi_beta_norm_jerk_t4_p3,p_cs_stm_ipsi_beta_norm_jerk_t4_p3]=corrcoef(mean_sum_beta_t4_p3_stm_ipsi,lr_beta_metric_norm_jerk_t4)
plot(mean_sum_beta_t4_p3_stm_ipsi,lr_beta_metric_norm_jerk_t4,'.k')
for i=1:5
    text(mean_sum_beta_t4_p3_stm_ipsi(i),lr_beta_metric_norm_jerk_t4(i),sbjs_stm(i,:),'Color',plot_color(i))
end
plot(mean_sum_beta_t4_p3_stm_ipsi,pval_cs_stm_ipsi_beta_norm_jerk_t4_p3,'r','LineWidth',2)
if p_cs_stm_ipsi_beta_norm_jerk_t4_p3(2)<0.05
    title(num2str(p_cs_stm_ipsi_beta_norm_jerk_t4_p3(2)),'Color',[1 0 0])
else
    title(num2str(p_cs_stm_ipsi_beta_norm_jerk_t4_p3(2)))
end

%idx_curv
subplot(12,4,45); hold on
%set(gca,'xlim',[0 xlim_cs_stm_ipsi_rest_beta],'ylim',[0 ylim_kin_metrics_cs_non_idx_curv])
pfit_cs_stm_ipsi_beta_idx_curv_t1_p3=polyfit(mean_sum_beta_t1_p3_stm_ipsi,lr_beta_metric_idx_curv_t1,1)
pval_cs_stm_ipsi_beta_idx_curv_t1_p3=polyval(pfit_cs_stm_ipsi_beta_idx_curv_t1_p3,mean_sum_beta_t1_p3_stm_ipsi)
[r_cs_stm_ipsi_beta_idx_curv_t1_p3,p_cs_stm_ipsi_beta_idx_curv_t1_p3]=corrcoef(mean_sum_beta_t1_p3_stm_ipsi,lr_beta_metric_idx_curv_t1)
plot(mean_sum_beta_t1_p3_stm_ipsi,lr_beta_metric_idx_curv_t1,'.k')
for i=1:5
    text(mean_sum_beta_t1_p3_stm_ipsi(i),lr_beta_metric_idx_curv_t1(i),sbjs_stm(i,:),'Color',plot_color(i))
end
plot(mean_sum_beta_t1_p3_stm_ipsi,pval_cs_stm_ipsi_beta_idx_curv_t1_p3,'r','LineWidth',2)
if p_cs_stm_ipsi_beta_idx_curv_t1_p3(2)<0.05
    title(num2str(p_cs_stm_ipsi_beta_idx_curv_t1_p3(2)),'Color',[1 0 0])
else
    title(num2str(p_cs_stm_ipsi_beta_idx_curv_t1_p3(2)))
end
ylabel('ic')

subplot(12,4,46); hold on
%set(gca,'xlim',[0 xlim_cs_stm_ipsi_rest_beta],'ylim',[0 ylim_kin_metrics_cs_non_idx_curv])
pfit_cs_stm_ipsi_beta_idx_curv_t2_p3=polyfit(mean_sum_beta_t2_p3_stm_ipsi,lr_beta_metric_idx_curv_t2,1)
pval_cs_stm_ipsi_beta_idx_curv_t2_p3=polyval(pfit_cs_stm_ipsi_beta_idx_curv_t2_p3,mean_sum_beta_t2_p3_stm_ipsi)
[r_cs_stm_ipsi_beta_idx_curv_t2_p3,p_cs_stm_ipsi_beta_idx_curv_t2_p3]=corrcoef(mean_sum_beta_t2_p3_stm_ipsi,lr_beta_metric_idx_curv_t2)
plot(mean_sum_beta_t2_p3_stm_ipsi,lr_beta_metric_idx_curv_t2,'.k')
for i=1:5
    text(mean_sum_beta_t2_p3_stm_ipsi(i),lr_beta_metric_idx_curv_t2(i),sbjs_stm(i,:),'Color',plot_color(i))
end
plot(mean_sum_beta_t2_p3_stm_ipsi,pval_cs_stm_ipsi_beta_idx_curv_t2_p3,'r','LineWidth',2)
if p_cs_stm_ipsi_beta_idx_curv_t2_p3(2)<0.05
    title(num2str(p_cs_stm_ipsi_beta_idx_curv_t2_p3(2)),'Color',[1 0 0])
else
    title(num2str(p_cs_stm_ipsi_beta_idx_curv_t2_p3(2)))
end

subplot(12,4,47); hold on
%set(gca,'xlim',[0 xlim_cs_stm_ipsi_rest_beta],'ylim',[0 ylim_kin_metrics_cs_non_idx_curv])
pfit_cs_stm_ipsi_beta_idx_curv_t3_p3=polyfit(mean_sum_beta_t3_p3_stm_ipsi,lr_beta_metric_idx_curv_t3,1)
pval_cs_stm_ipsi_beta_idx_curv_t3_p3=polyval(pfit_cs_stm_ipsi_beta_idx_curv_t3_p3,mean_sum_beta_t3_p3_stm_ipsi)
[r_cs_stm_ipsi_beta_idx_curv_t3_p3,p_cs_stm_ipsi_beta_idx_curv_t3_p3]=corrcoef(mean_sum_beta_t3_p3_stm_ipsi,lr_beta_metric_idx_curv_t3)
plot(mean_sum_beta_t3_p3_stm_ipsi,lr_beta_metric_idx_curv_t3,'.k')
for i=1:5
    text(mean_sum_beta_t3_p3_stm_ipsi(i),lr_beta_metric_idx_curv_t3(i),sbjs_stm(i,:),'Color',plot_color(i))
end
plot(mean_sum_beta_t3_p3_stm_ipsi,pval_cs_stm_ipsi_beta_idx_curv_t3_p3,'r','LineWidth',2)
if p_cs_stm_ipsi_beta_idx_curv_t3_p3(2)<0.05
    title(num2str(p_cs_stm_ipsi_beta_idx_curv_t3_p3(2)),'Color',[1 0 0])
else
    title(num2str(p_cs_stm_ipsi_beta_idx_curv_t3_p3(2)))
end

subplot(12,4,48); hold on
%set(gca,'xlim',[0 xlim_cs_stm_ipsi_rest_beta],'ylim',[0 ylim_kin_metrics_cs_non_idx_curv])
pfit_cs_stm_ipsi_beta_idx_curv_t4_p3=polyfit(mean_sum_beta_t4_p3_stm_ipsi,lr_beta_metric_idx_curv_t4,1)
pval_cs_stm_ipsi_beta_idx_curv_t4_p3=polyval(pfit_cs_stm_ipsi_beta_idx_curv_t4_p3,mean_sum_beta_t4_p3_stm_ipsi)
[r_cs_stm_ipsi_beta_idx_curv_t4_p3,p_cs_stm_ipsi_beta_idx_curv_t4_p3]=corrcoef(mean_sum_beta_t4_p3_stm_ipsi,lr_beta_metric_idx_curv_t4)
plot(mean_sum_beta_t4_p3_stm_ipsi,lr_beta_metric_idx_curv_t4,'.k')
for i=1:5
    text(mean_sum_beta_t4_p3_stm_ipsi(i),lr_beta_metric_idx_curv_t4(i),sbjs_stm(i,:),'Color',plot_color(i))
end
plot(mean_sum_beta_t4_p3_stm_ipsi,pval_cs_stm_ipsi_beta_idx_curv_t4_p3,'r','LineWidth',2)
if p_cs_stm_ipsi_beta_idx_curv_t4_p3(2)<0.05
    title(num2str(p_cs_stm_ipsi_beta_idx_curv_t4_p3(2)),'Color',[1 0 0])
else
    title(num2str(p_cs_stm_ipsi_beta_idx_curv_t4_p3(2)))
end


















































