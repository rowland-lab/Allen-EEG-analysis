function nr_ac_eeg_anal_ser_lin_reg_v01c(grp_stmstat,freq_band,mean_mean_sum_var,save_figs,save_data)



% grp_stmstat='hc_stm'
% freq_band='beta'
% mean_mean_sum_var='~/nr_data_analysis/data_analyzed/eeg/gen_02/data/cs_mean_mean_sum_beta_all.mat'
% save_figs='no'
% save_data='yes'

if strcmp(grp_stmstat,'cs_stm')
    sbjs=['03';'04';'05';'42';'43'];
    elec_stm_ipsi=[7,7,18,18,7];
    elec_stm_cont=[18,18,7,7,18];
    plot_color=['k','b','g','c','m'];
    stm_idx=1;
elseif strcmp(grp_stmstat,'cs_non')
    sbjs=['13';'15';'17';'18';'21'];
    elec_non_ipsi=[18,7,18,18,18];
    elec_non_cont=[7,18,7,7,7];
    stm_idx=2;
    plot_color=['k','b','g','c','m'];
elseif strcmp(grp_stmstat,'hc_stm')
    sbjs=['22';'24';'25';'26';'29';'30'];
    elec_stm_ipsi=[18,7,7,7,7,18];
    elec_stm_cont=[7,18,18,18,18,7];
    stm_idx=1;
    plot_color=['k','b','g','c','m','y'];
elseif strcmp(grp_stmstat,'hc_non')
    sbjs=['20';'23';'27';'28';'36'];
    elec_non_ipsi=[7,18,7,7,7];
    elec_non_cont=[18,7,18,18,18];
    stm_idx=2;
    plot_color=['k','b','g','c','m'];
end

phase={'atStartPosition';'cueEvent';'targetUp'}
metrics={'reaction_time';'hand_path_length';'avg_vel';'max_vel';'vel_peak';
         'time_max_vel';'time_max_vel_norm';'avg_accel';'max_accel';'accur';
         'norm_jerk';'idx_curv'}
stim_status={'stm';'non'};
lat={'ipsi';'cont'};

freq={'delta';'theta';'alpha';'beta';'low_gamma';'high_gamma'};
if strcmp(freq_band,'delta')
    freq_idx=1;
elseif strcmp(freq_band,'theta')
    freq_idx=2;
elseif strcmp(freq_band,'alpha')
    freq_idx=3;
elseif strcmp(freq_band,'beta')
    freq_idx=4;
elseif strcmp(freq_band,'low_gamma')
    freq_idx=5;
elseif strcmp(freq_band,'high_gamma')
    freq_idx=6;
end
        
sp_table=[1:48];

load(mean_mean_sum_var)

for i=1:size(sbjs,1)
    load(['/home/rowlandn/nr_data_analysis/data_analyzed/eeg/gen_02/data/pro00087153_00',sbjs(i,:),...
        '/analysis/S2-metrics/pro00087153_00',sbjs(i,:),'_S2-Metrics.mat'])
    for j=1:12 %metrics
        for k=1:4 %trials
            eval(['lr_',freq_band,'_metric_',metrics{j},'_t',num2str(k),'(',num2str(i),')=metricdat.data{',num2str(j),'}(',num2str(k),')'])
        end
    end
    clear movementstart trialData metricdat s2rejecttrials
end

for j=stm_idx 
    for k=1:2 %lat
        count=0
        for l=freq_idx
            for o=1:3 %p
                for m=1:12 %metrics
                    for n=1:4 %t                           
                        eval(['pfit_',grp_stmstat(1:2),'_',stim_status{j},'_',lat{k},'_',freq{l},'_',metrics{m},'_t',num2str(n),'_p',num2str(o),'=polyfit(mean_mean_sum_',freq{l},'_',...
                            't',num2str(n),'_p',num2str(o),'_',stim_status{j},'_',lat{k},',lr_',freq{l},'_metric_',metrics{m},'_t',num2str(n),',1)'])
                        eval(['pval_',grp_stmstat(1:2),'_',stim_status{j},'_',lat{k},'_',freq{l},'_',metrics{m},'_t',num2str(n),'_p',num2str(o),'=polyval(pfit_',grp_stmstat(1:2),'_',...
                            stim_status{j},'_',lat{k},'_',freq{l},'_',metrics{m},'_t',num2str(n),'_p',num2str(o),',mean_mean_sum_',freq{l},'_t',num2str(n),'_p',num2str(o),...
                            '_',stim_status{j},'_',lat{k},')'])
                        eval(['[r_',grp_stmstat(1:2),'_',stim_status{j},'_',lat{k},'_',freq{l},'_',metrics{m},'_t',num2str(n),'_p',num2str(o),',p_cc_',grp_stmstat(1:2),'_',stim_status{j},...
                            '_',lat{k},'_',freq{l},'_',metrics{m},'_t',num2str(n),'_p',num2str(o),']=corrcoef(mean_mean_sum_',freq{l},'_t',num2str(n),'_p',num2str(o),'_',...
                            stim_status{j},'_',lat{k},',lr_',freq{l},'_metric_',metrics{m},'_t',num2str(n),')'])
                      end
                end
            end
        end
    end
end


fig_count=0
for j=stm_idx
    for k=1:2 %lat
        count=0
        for l=freq_idx %freq
            for o=1:3 %p
                fig_count=fig_count+1
                eval(['fh_',num2str(fig_count),'=figure'])
                set(gcf,'Position',[228 -167 651 917])
                count=0
                for m=1:12 %metrics
                    for n=1:4 %t
                          count=count+1
                          subplot(12,4,sp_table(count)); hold on
                          eval(['plot(mean_mean_sum_',freq{l},'_t',num2str(n),'_p',num2str(o),'_',stim_status{j},'_',lat{k},',lr_',freq{l},'_metric_',metrics{m},...
                            '_t',num2str(n),',''.k'')'])
                        for p=1:size(sbjs,1)
%                             eval(['text(mean_mean_sum_',freq{l},'_t',num2str(n),'_p',num2str(o),'_',stim_status{j},'_',lat{k},'(p),lr_',freq{l},'_metric_',...
%                                 metrics{m},'_t',num2str(n),'(p),'sbjs_',stim_status{j},'(p,:),''Color'',plot_color(p))'])
                            eval(['text(mean_mean_sum_',freq{l},'_t',num2str(n),'_p',num2str(o),'_',stim_status{j},'_',lat{k},'(p),lr_',freq{l},'_metric_',...
                                metrics{m},'_t',num2str(n),'(p),sbjs(p,:),''Color'',plot_color(p))'])
                            
                        end
                        eval(['plot(mean_mean_sum_',freq{l},'_t',num2str(n),'_p',num2str(o),'_',stim_status{j},'_',lat{k},',pval_',grp_stmstat(1:2),'_',stim_status{j},...
                            '_',lat{k},'_',freq{l},'_',metrics{m},'_t',num2str(n),'_p',num2str(o),',''r'',''LineWidth'',2)'])
                        if eval(['p_cc_',grp_stmstat(1:2),'_',stim_status{j},'_',lat{k},'_',freq{l},'_',metrics{m},'_t',num2str(n),'_p',num2str(o),'(2)'])<0.05
                            eval(['title(num2str(p_cc_',grp_stmstat(1:2),'_',stim_status{j},'_',lat{k},'_',freq{l},'_',metrics{m},'_t',num2str(n),'_p',num2str(o),...
                                '(2)),''Color'',[1 0 0])'])
                        else
                            eval(['title(num2str(p_cc_',grp_stmstat(1:2),'_',stim_status{j},'_',lat{k},'_',freq{l},'_',metrics{m},'_t',num2str(n),'_p',num2str(o),...
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
                %eval(['annotation(''textbox'',[0.3323 0.9538 0.3409 0.0297],''String'',[''',grp_stmstat(1:2),' ',stim_status{j},' ',lat{k},' ',freq{l},' p',num2str(o),'''],''FitBoxtoText'',''on'')'])
            end
        end
    end
end
    

% separate p-value
for j=stm_idx
    for k=1:2 %lat
        for l=freq_idx 
            for o=1:3 %p
                eval(['who_p_',grp_stmstat(1:2),'_',stim_status{j},'_',lat{k},'_',freq{l},'_p',num2str(o),...
                    '=who(''-regexp'',''^p_cc_',grp_stmstat(1:2),'_\w*',stim_status{j},'_',lat{k},'_',freq{l},'\w*_p',num2str(o),''');'])
            end
        end
    end
end


%rearrange in correct order
metric_reorder_table=[33,34,35,36,13,14,15,16,9,10,11,12,25,26,27,28,45,46,47,48,41,42,43,44,37,38,39,40,5,6,7,8,21,22,23,24,...
    1,2,3,4,29,30,31,32,17,18,19,20];
for j=stm_idx
    for k=1:2 %lat
        for l=freq_idx
            for o=1:3 %p
                for p=1:48 %change back to 48 for 12 metrics
                    eval(['who_eval1_p_',grp_stmstat(1:2),'_',stim_status{j},'_',lat{k},'_',freq{l},'_p',num2str(o),'{',num2str(p),'}',...
                        '=eval(who_p_',grp_stmstat(1:2),'_',stim_status{j},'_',lat{k},'_',freq{l},'_p',num2str(o),'{metric_reorder_table(',num2str(p),')})'])
                    eval(['who_eval2_p_',grp_stmstat(1:2),'_',stim_status{j},'_',lat{k},'_',freq{l},'_p',num2str(o),'(',num2str(p),')',...
                         '=who_eval1_p_',grp_stmstat(1:2),'_',stim_status{j},'_',lat{k},'_',freq{l},'_p',num2str(o),'{',num2str(p),'}(2)'''])
                end
            end
        end
    end
end


%reshape
for j=stm_idx
    for k=1:2 %lat
        for l=freq_idx 
            for o=1:3 %p
                eval(['who_eval3_p_',grp_stmstat(1:2),'_',stim_status{j},'_',lat{k},'_',freq{l},'_p',num2str(o),'=reshape(who_eval2_p_',...
                       grp_stmstat(1:2),'_',stim_status{j},'_',lat{k},'_',freq{l},'_p',num2str(o),',4,12)'''])
            end
        end
    end
end


% fdr
for j=stm_idx
    for k=1:2 %lat
        for l=freq_idx 
            for o=1:3 %p
                for p=1:12 %metrics
                    eval(['pcorr_',grp_stmstat(1:2),'_',stim_status{j},'_',lat{k},'_',freq{l},'_p',num2str(o),'(',num2str(p),...
                        ',:)=mafdr(who_eval3_p_',grp_stmstat(1:2),'_',stim_status{j},'_',lat{k},'_',freq{l},'_p',num2str(o),'(',...
                        num2str(p),',:),''BHFDR'',''true'')'])
                end
            end
        end
    end
end

%retitle with corrected p-values
fig_count=0;
for j=stm_idx
    for k=1:2 %lat
        count=0
        for l=freq_idx
            for o=1:3 %p
                fig_count=fig_count+1
                eval(['figure(fh_',num2str(fig_count),')'])
                count=0
                eval(['pcorr_reshape_',grp_stmstat(1:2),'_',stim_status{j},'_',lat{k},'_',freq{l},'_p',num2str(o),'=reshape(pcorr_',grp_stmstat(1:2),'_',stim_status{j},'_',lat{k},...
                    '_',freq{l},'_p',num2str(o),''',1,48)'])
                for m=1:12 %metrics
                    for n=1:4 %t
                        count=count+1;
                        subplot(12,4,sp_table(count)); hold on
                        if eval(['pcorr_reshape_',grp_stmstat(1:2),'_',stim_status{j},'_',lat{k},'_',freq{l},'_p',num2str(o),'(',num2str(count),')'])<0.05
                            eval(['title(num2str(pcorr_reshape_',grp_stmstat(1:2),'_',stim_status{j},'_',lat{k},'_',freq{l},'_p',num2str(o),'(',num2str(count),')),''Color'',[1 0 0])'])
                        else
                            eval(['title(num2str(pcorr_reshape_',grp_stmstat(1:2),'_',stim_status{j},'_',lat{k},'_',freq{l},'_p',num2str(o),'(',num2str(count),')))'])
                        end
                    end
                end
                eval(['annotation(''textbox'',[0.3323 0.9538 0.3409 0.0297],''String'',[''',grp_stmstat(1:2),' ',stim_status{j},' ',lat{k},' ',freq{l},' p',num2str(o),' corrected''],''FitBoxtoText'',''on'')'])
                if strcmp(save_figs,'yes')
                    saveas(gcf,['~/nr_data_analysis/data_analyzed/eeg/gen_02/figures/gen_02_verc_corr_lr_',grp_stmstat,'_',lat{k},'_',freq{l},'_p',num2str(o),'.fig'],'fig')
                end
            end
        end
    end
end

if strcmp(save_data,'yes')
        save(['~/nr_data_analysis/data_analyzed/eeg/gen_02/data/gen_02_verc_',grp_stmstat,'_corr_lr_',freq_band,'_all']) 
end
