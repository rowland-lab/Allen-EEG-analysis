%%
% %cs
% sbjs_stm=['03';'04';'05';'42';'43'];
% elec_stm_ipsi=[7,7,18,18,7];
% elec_stm_cont=[18,18,7,7,18];
% 
% % sbjs_non=['13';'15';'17';'18';'21'];
% % elec_non_ipsi=[18,7,18,18,18];
% % elec_non_cont=[7,18,7,7,7];
% plot_color=['k','b','g','c','m'];

%make an if statement to run hc and need to be able to run 5 or 6 element
%arrays, will need to specify elec_stm variables as cs or hc

%also there's a slight bug, you have to run hc stm and non separately bc of
%the differences in 5 vs 6 subjects. you may have to modify the variable
%name from e.g. lr_beta_metric_accur_t1 to lr_beta_metric_accur_hc_stm_t1 or something like that 
%else its really annoying to have to change j below to 1 or 2 for each foor
%loop (oh and i to 2)

%hc
sbjs_stm=['22';'24';'25';'26';'29';'30'];
elec_stm_ipsi=[18,7,7,7,7,18];
elec_stm_cont=[7,18,18,18,18,7];
plot_color=['k','b','g','c','m','y'];

sbjs_non=['20';'23';'27';'28';'36'];
elec_non_ipsi=[7,18,7,7,7];
elec_non_cont=[18,7,18,18,18];
plot_color=['k','b','g','c','m'];



phase={'atStartPosition';'cueEvent';'targetUp'}
metrics={'reaction_time';'hand_path_length';'avg_vel';'max_vel';'vel_peak';
    'time_max_vel';'time_max_vel_norm';'avg_accel';'max_accel';'accur';
    'norm_jerk';'idx_curv'}

% metrics={'reaction_time';'hand_path_length';'max_vel';'time_max_vel_norm';'max_accel';'accur'}

% % metrics={'accur';'avg_accel';'avg_vel';'hand_path_length';'idx_curv';
% %     'max_accel';'max_vel';'norm_jerk';'reaction_time';'time_max_vel';
% %     'time_max_vel_norm';'vel_peak'}
cohort={'cs';'hc'};
stim_status={'stm';'non'};
lat={'ipsi';'cont'};
freq={'delta';'theta';'alpha';'beta';'low_gamma';'high_gamma'};
%sp_table=[1:48];
sp_table=[1:24]; %6 metrics

for i=11%:size(sbjs_stm,1)%%%NEEDS TO BE CHANGED IN EVERY SINGLE 
    %FOR LOOP IN THE SCRIPT!!
    load(['/home/rowlandn/nr_data_analysis/data_analyzed/eeg/gen_02/data/pro00087153_00',sbjs_stm(i,:),...
        '/analysis/S2-metrics/pro00087153_00',sbjs_stm(i,:),'_S2-Metrics.mat'])
    for j=[1 2 4 7 9 10]%1:6 %# of metrics
        for k=1:4
            eval(['lr_beta_metric_',metrics{j},'_t',num2str(k),'(',num2str(i),')=metricdat.data{',num2str(j),'}(',num2str(k),')'])
        end
    end
    clear movementstart trialData metricdat s2rejecttrials
end
% %%%%% coding for pca/fa%%%%%%
% metric_idx=[0 4 8 12 16 20 24 28 32 36 40 44]
% for j=1:12
%         for k=1:4
%             if j==1
%                 eval(['metric_pca_cs_stm(:,',num2str(k),')=lr_beta_metric_',metrics{j},'_t',num2str(k),''''])
%             else
%                 eval(['metric_pca_cs_stm(:,',num2str(metric_idx(j)+k),')=lr_beta_metric_',metrics{j},'_t',num2str(k),''''])
%             end
%         end
% end
% 
% for j=1:12
%         for k=1:4
%             if j==1
%                 eval(['metric_pca_cs_non(:,',num2str(k),')=lr_beta_metric_',metrics{j},'_t',num2str(k),''''])
%             else
%                 eval(['metric_pca_cs_non(:,',num2str(metric_idx(j)+k),')=lr_beta_metric_',metrics{j},'_t',num2str(k),''''])
%             end
%         end
% end
% 
% for j=1:12
%         for k=1:4
%             if j==1
%                 eval(['metric_pca_hc_stm(:,',num2str(k),')=lr_beta_metric_',metrics{j},'_t',num2str(k),''''])
%             else
%                 eval(['metric_pca_hc_stm(:,',num2str(metric_idx(j)+k),')=lr_beta_metric_',metrics{j},'_t',num2str(k),''''])
%             end
%         end
% end
% 
% for j=1:12
%         for k=1:4
%             if j==1
%                 eval(['metric_pca_hc_non(:,',num2str(k),')=lr_beta_metric_',metrics{j},'_t',num2str(k),''''])
%             else
%                 eval(['metric_pca_hc_non(:,',num2str(metric_idx(j)+k),')=lr_beta_metric_',metrics{j},'_t',num2str(k),''''])
%             end
%         end
% end
% 
% metric_pca_all=[metric_pca_cs_stm;metric_pca_cs_non;metric_pca_hc_stm;metric_pca_hc_non]
% 
% [COEFF, SCORE, LATENT, TSQUARED, EXPLAINED]=pca(metric_pca_all,'Options','display')
% 
% %%%%%%%%%%%%%%%%%%%%%%%

for i=2%1%:2 %(cohort)
    for j=2%:2 %(stim_status)
        %count=0
        for k=1%:2 %(lat)
            count=0
            for l=4%1:6 %(freq)
                %count=count+1
                for o=1:3 %(p)
                    %count=count+1
                      for m=[1 2 4 7 9 10]%1:6 %(metrics)
                          %count=count+1
                          for n=1:4 %(t)                            
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

fig_count=0
%count=0;
for i=2%:2 %(cohort)
    for j=2%:2 %(stim_status)
        %count=0
        for k=1%:2 %(lat)
            count=0
            %figure
            %set(gcf,'Position',[228 -167 651 917])
            for l=4%1:6 %(freq)
                %count=count+1
                %figure
                %fig_count=fig_count+1
                %set(gcf,'Position',[228 -167 651 917])
                  for o=1:3 %(p)
                    fig_count=fig_count+1
                    eval(['fh_',num2str(fig_count),'=figure'])
                    set(gcf,'Position',[228 -167 651 917])
                    count=0
                    %count=count+1
                      for m=[1 2 4 7 9 10]%1:6 %(metrics)
                          %count=count+1
                          for n=1:4 %(t)
                              count=count+1
                              subplot(6,4,sp_table(count)); hold on
                            eval(['plot(mean_mean_sum_',freq{l},'_t',num2str(n),'_p',num2str(o),'_',stim_status{j},'_',lat{k},',lr_',freq{l},'_metric_',metrics{m},...
                                '_t',num2str(n),',''.k'')'])
                            for p=1:size(sbjs_stm,1)
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
                            
%                             if count==1
%                                 ylabel('rt')
%                             elseif count==5
%                                 ylabel('hpl')
%                             elseif count==9
%                                 ylabel('av')
%                             elseif count==13
%                                 ylabel('mv')
%                             elseif count==17
%                                 ylabel('vp')
%                              elseif count==21
%                                 ylabel('tmv')
%                              elseif count==25
%                                 ylabel('tmvn')
%                              elseif count==29
%                                 ylabel('aa')
%                              elseif count==33
%                                 ylabel('ma')
%                              elseif count==37
%                                 ylabel('acc')
%                              elseif count==41
%                                 ylabel('nj')
%                              elseif count==45
%                                 ylabel('idc')
%                             end
                             
                            if count==1
                                ylabel('rt')
                            elseif count==5
                                ylabel('hpl')
                            elseif count==9
                                ylabel('mv')
                            elseif count==13
                                ylabel('tmvn')
                            elseif count==17
                                ylabel('ma')
                             elseif count==21
                                ylabel('acc')
%                              elseif count==25
%                                 ylabel('tmvn')
%                              elseif count==29
%                                 ylabel('aa')
%                              elseif count==33
%                                 ylabel('ma')
%                              elseif count==37
%                                 ylabel('acc')
%                              elseif count==41
%                                 ylabel('nj')
%                              elseif count==45
%                                 ylabel('idc')
                             end
                            
                        end
                    end
                    eval(['annotation(''textbox'',[0.35 0.67 0.2 0.3],''String'',[''',cohort{i},' ',stim_status{j},' ',lat{k},' ',freq{l},' p',num2str(o),'''],''FitBoxtoText'',''on'')'])
                end
            end
        end
    end
end

% separate p-value
for i=2%:2 %(cohort)
    for j=2%:2 %(stim_status)
        for k=1%:2 %(lat)
            for l=4 %1:6 %(freq)
                for o=1:3 %(p)
                    eval(['who_p_',cohort{i},'_',stim_status{j},'_',lat{k},'_',freq{l},'_p',num2str(o),...
                        '=who(''-regexp'',''^p_cc_',cohort{i},'_\w*',stim_status{j},'_',lat{k},'_',freq{l},'\w*_p',num2str(o),''');'])
                end
            end
        end
    end
end

%rearrange in correct order
% metric_reorder_table=[33,34,35,36,13,14,15,16,9,10,11,12,25,26,27,28,45,46,47,48,41,42,43,44,37,38,39,40,5,6,7,8,21,22,23,24,...
%     1,2,3,4,29,30,31,32,17,18,19,20];
metric_reorder_table=[17,18,19,20,5,6,7,8,13,14,15,16,21,22,23,24,9,10,11,12,1,2,3,4];
for i=2%:2 %(cohort)
    for j=2%:2 %(stim_status)
        for k=1%:2 %(lat)
            for l=4 %1:6 %(freq)
                for o=1:3 %(p)
                    for p=1:24 %change back to 48 for 12 metrics
                        eval(['who_eval1_p_',cohort{i},'_',stim_status{j},'_',lat{k},'_',freq{l},'_p',num2str(o),'{',num2str(p),'}',...
                            '=eval(who_p_',cohort{i},'_',stim_status{j},'_',lat{k},'_',freq{l},'_p',num2str(o),'{metric_reorder_table(',num2str(p),')})'])
                        eval(['who_eval2_p_',cohort{i},'_',stim_status{j},'_',lat{k},'_',freq{l},'_p',num2str(o),'(',num2str(p),')',...
                             '=who_eval1_p_',cohort{i},'_',stim_status{j},'_',lat{k},'_',freq{l},'_p',num2str(o),'{',num2str(p),'}(2)'''])
                    end
                end
            end
        end
    end
end

%reshape
for i=2%:2 %(cohort)
    for j=2%:2 %(stim_status)
        for k=1%:2 %(lat)
            for l=4 %1:6 %(freq)
                for o=1:3 %(p)
                    eval(['who_eval3_p_',cohort{i},'_',stim_status{j},'_',lat{k},'_',freq{l},'_p',num2str(o),'=reshape(who_eval2_p_',...
                           cohort{i},'_',stim_status{j},'_',lat{k},'_',freq{l},'_p',num2str(o),',4,6)'''])
                     %cohort{i},'_',stim_status{j},'_',lat{k},'_',freq{l},'_p',num2str(o),',4,12)'''])
                end
            end
        end
    end
end

% fdr
for i=2%:2 %(cohort)
    for j=2%:2 %(stim_status)
        for k=1%:2 %(lat)
            for l=4 %1:6 %(freq)
                for o=1:3 %(p)
                    for p=1:6 %change back to 12 if 12 metrics
                        eval(['pcorr_',cohort{i},'_',stim_status{j},'_',lat{k},'_',freq{l},'_p',num2str(o),'(',num2str(p),...
                            ',:)=mafdr(who_eval3_p_',cohort{i},'_',stim_status{j},'_',lat{k},'_',freq{l},'_p',num2str(o),'(',...
                            num2str(p),',:),''BHFDR'',''true'')'])
                    end
                end
            end
        end
    end
end

%retitle with corrected p-values
fig_count=0;
for i=2%:2 %(cohort)
    for j=2%:2 %(stim_status)
        for k=1%:2 %(lat)
            count=0
            for l=4%1:6 %(freq)
                for o=1:3 %(p)
                    fig_count=fig_count+1
                    eval(['figure(fh_',num2str(fig_count),')'])
                    count=0
                    eval(['pcorr_reshape_',cohort{i},'_',stim_status{j},'_',lat{k},'_',freq{l},'_p',num2str(o),'=reshape(pcorr_',cohort{i},'_',stim_status{j},'_',lat{k},...
                        '_',freq{l},'_p',num2str(o),''',1,24)'])
                    %'_',freq{l},'_p',num2str(o),''',1,48)'])
                    for m=1:6 %(metrics)
                        for n=1:4 %(t)
                            count=count+1;
                            subplot(6,4,sp_table(count)); hold on
                            if eval(['pcorr_reshape_',cohort{i},'_',stim_status{j},'_',lat{k},'_',freq{l},'_p',num2str(o),'(',num2str(count),')'])<0.05
                                eval(['title(num2str(pcorr_reshape_',cohort{i},'_',stim_status{j},'_',lat{k},'_',freq{l},'_p',num2str(o),'(',num2str(count),')),''Color'',[1 0 0])'])
                            else
                                eval(['title(num2str(pcorr_reshape_',cohort{i},'_',stim_status{j},'_',lat{k},'_',freq{l},'_p',num2str(o),'(',num2str(count),')))'])
                            end
                        end
                    end
                    eval(['annotation(''textbox'',[0.35 0.67 0.2 0.3],''String'',[''',cohort{i},' ',stim_status{j},' ',lat{k},' ',freq{l},' p',num2str(o),' corrected''],''FitBoxtoText'',''on'')'])
                end
            end
        end
    end
end

