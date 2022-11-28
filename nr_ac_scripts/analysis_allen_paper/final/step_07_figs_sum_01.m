%step_07_figs_sum


sbj_num=['03';'04';'05';'42';'43';'13';'15';'17';'18';'21';'22';'24';'25';'26';'29';'30';'20';'23';'27';'28';'36'];
for i=1%3:21%1
    eval(['trials_',sbj_num(i,:),'=step_01_nr_ac_eeg_anal_ser_data_vis_03([''~/nr_data_analysis/data_analyzed/eeg/gen_03/data/pro00087153_00',sbj_num(i,:),'''])'])
eval(['trials_all{i,1}=trials_',sbj_num(i,:),'{1}'])
eval(['trials_all{i,2}=trials_',sbj_num(i,:),'{2}'])
eval(['trials_all{i,3}=trials_',sbj_num(i,:),'{3}'])



end
% ok so what i learned from this analysis is that the first 4 epochs are
% hardcoded into the analysis. So if I look through these and the first 4
% are always the first 4 I'm interested in then you already have what you
% need
function step_02_nr_ac_eeg_anal_ser_outlier_analysis_rest_v01c(sbjfolder,filt,plot_ind,scroll,save_outliers,freq_band,version)


sbj_num=['03';'04';'05';'42';'43';'13';'15';'17';'18';'21';'22';'24';'25';'26';'29';'30';'20';'23';'27';'28';'36'];
freq_band={'alpha';'beta';'gamma'};
for i=3%:3
    for j=1:21
        eval(['sbjfolder=[''~/nr_data_analysis/data_analyzed/eeg/gen_03/data/pro00087153_00',sbj_num(j,:),''']'])
        step_02_nr_ac_eeg_anal_ser_outlier_analysis_rest_v01c(sbjfolder,'yes','no','no','yes',freq_band{i},'g')
        clear c*
    end
end

function step_02_nr_ac_eeg_anal_ser_outlier_analysis_v01b(sbjfolder,filt,plot_ind,scroll,save_outliers,freq_band,version)

sbj_num=['03';'04';'05';'42';'43';'13';'15';'17';'18';'21';'22';'24';'25';'26';'29';'30';'20';'23';'27';'28';'36'];
freq_band={'alpha';'beta';'gamma'};
for i=3%:3
    for j=1:21
        eval(['sbjfolder=[''~/nr_data_analysis/data_analyzed/eeg/gen_03/data/pro00087153_00',sbj_num(j,:),''']'])
        step_02_nr_ac_eeg_anal_ser_outlier_analysis_v01b(sbjfolder,'yes','no','no','yes',freq_band{i},'g')
        clear c*
    end
end


sbjfind=strfind(sbjfolder,'pro');
sbjname=sbjfolder(sbjfind:sbjfind+15);
plot_ind='no'
scroll='no'
save_outliers='yes'
freq_band='beta'
version='e'


function step_03_nr_ac_eeg_anal_ser_ind_freq_plots_v01d(sbjs,filt,freq_band,epoch_type,version,date_str,save_fig,save_data)

freq_band={'alpha';'beta';'gamma'};
for i=3%:3
    step_03_nr_ac_eeg_anal_ser_ind_freq_plots_v01d('all','yes',freq_band{i},'epochsWhole','g','2022_09_17','yes','yes')
end



if strcmp(sbjs,'all')
    sbjs_all=['03';'04';'05';'42';'43';'13';'15';'17';'18';'21';'22';'24';'25';'26';'29';'30';'20';'23';'27';'28';'36'];
end

%grp='cs'
save_fig='no';
save_data='no';
freq_band='beta';
epoch_type='epochsWhole';
version='e';
date_str='2022_09_03';

function step_03_nr_ac_eeg_anal_ser_sum_freq_plots_v01c(grp,epoch_type,freq_band,version,save_figs,save_data,date_str)

freq_band={'alpha';'beta';'gamma'};
for i=3%:3
    step_03_nr_ac_eeg_anal_ser_sum_freq_plots_v01c('hc','epochsWhole',freq_band{i},'g','yes','yes','2022_09_17')
end

grp='TRY FRIEDMAN!!!!!';
epoch_type='epochsWhole';
freq_band='beta';
date_str='2022_09_05';
version='f';
mean_mean_var=['~/nr_data_analysis/data_analyzed/eeg/gen_03/analysis_pow/',date_str,'/gen_03_ver_',version,'_ew_mean_mean_',freq_band,'_ind_all.mat'];
save_figs='no';
save_data='no';

function step_03_nr_ac_eeg_anal_ser_sum_freq_plots_v01d(grp,epoch_type,freq_band,version, save_figs,save_data,date_str)
function step_03_nr_ac_eeg_anal_ser_sum_freq_plots_v01d(grp,epoch_type,freq_band,version, save_figs,save_data,date_str)

freq_band={'delta';'theta';'alpha';'beta';'gamma'};
grps={'cs';'hc'};
for i=1:2
    for j=1:2%3:5
        step_03_nr_ac_eeg_anal_ser_sum_freq_plots_v01d(grps{i},'epochsWhole',freq_band{j},'h','yes','yes','2022_09_24')
    end
end

grp='TRY FRIEDMAN!!!!!';
epoch_type='epochsWhole';
freq_band='beta';
date_str='2022_09_05';
version='f';
mean_mean_var=['~/nr_data_analysis/data_analyzed/eeg/gen_03/analysis_pow/',date_str,'/gen_03_ver_',version,'_ew_mean_mean_',freq_band,'_ind_all.mat'];
save_figs='no';
save_data='no';

function step_04_nr_ac_eeg_anal_ser_lin_reg_v01c(grp_stm,freq_band,version,epoch_type,save_figs,save_data,date_str)

freq_band={'delta';'theta';'alpha';'beta';'gamma'};
ds_stm={'cs_stm';'cs_non';'hc_stm';'hc_non'};
for i=5%3:5
    for j=1:4
        step_04_nr_ac_eeg_anal_ser_lin_reg_v01c(ds_stm{j},freq_band{i},'h','epochsWhole','yes','yes','2022_09_24')
    end
end




function step_04_nr_ac_eeg_anal_ser_lin_reg_v01d(grp_stm,freq_band,version,epoch_type,save_figs,save_data,date_str)

freq_band={'alpha';'beta';'gamma'};
ds_stm={'cs_stm';'cs_non';'hc_stm';'hc_non'};
for i=2%:3
    for j=1%:4
        step_04_nr_ac_eeg_anal_ser_lin_reg_v01d(ds_stm{j},freq_band{i},'h','epochsWhole','yes','yes','2022_09_24')
    end
end

% 9/5/22
% adding rest epochs

% grp_stm='cs_stm';
% freq_band='beta';
% version='f';
% epoch_type='epochsWhole';
% save_figs='no'
% save_data='no'
% date_str='2022_09_05';


%% for the filt data, need to get it in the same format as the non_filt data

clear
sbj_num=['03';'04';'05';'42';'43';'13';'15';'17';'18';'21';'22';'24';'25';'26';'29';'30';'20';'23';'27';'28';'36'];
for i=4:21
    cd(['~/nr_data_analysis/data_analyzed/eeg/gen_03/data/pro00087153_00',sbj_num(i,:),'/analysis/S3-EEGanalysis'])
    load('s3_dat_filt.mat')
    epochs_rest.rest2=epochs.rest2;
    clear epochs p*
    save('s3_dat_filt_rest.mat','epochs_rest')
    clear e*
end
%% going back to icoh data

% questions for allemn

a=subjectData(1).power.data(:,:,7,3,4);
b=mean(a,2);
%legend
figure; plot(a)
%b=squeeze(a);
figure; plot(b); hold on; plot(a')
legend

figure; set(gcf,'Position',[534 -93 754 891])
figure
for i=1:4
    for j=1:3
        a=subjectData(1).power.data(:,:,7,j,i);
        b=mean(a,2);
        subplot(4,1,1); hold on
        plot(b)
        
count=0;
for j=1:3
    for i=1:4
        count=count+1;
        if j==1
            subplot(10,5,i+5); hold on
            sp=i+5;
        elseif j==2
            subplot(10,5,i+10); hold on
            sp=i+10;
        elseif j==3
            subplot(10,5,i+15); hold on
            sp=i+15;
        end
         
        for k=1:size(sbjs_non,1)
            eval(['plot(psd_sbj',num2str(sbjs_non(k,:)),'_ch',num2str(elec_non_ipsi(k)),'_t',num2str(i),'_p',num2str(j),'_frq,',...
                'psd_mean_sbj',num2str(sbjs_non(k,:)),'_ch',num2str(elec_non_ipsi(k)),'_t',num2str(i),'_p',num2str(j),'_saw,''LineWidth'',2)'])
        end
        
        if count+4<10
            eval(['ylim_0',num2str(count+4),'=get(gca,''ylim'');'])
        elseif count+4>=10
            eval(['ylim_',num2str(count+4),'=get(gca,''ylim'');'])
        end
           
        if count==1
            ylabel('atStartPosition')
%             title([grp,' all:ipsi non:t1:',labl])
%         elseif count==2
%             title('t2')
%         elseif count==3
%             title('t3')
%         elseif count==4
%             title('t4')
        elseif count==5
            ylabel('cueEvent')
        elseif count==9
            ylabel('targetUp')
        elseif count==12
            l1_non_ipsi=legend;
        end
    end
end   


%                     tempcoh(i,:)=permute(mean(mean(tempdata(i).iCoh.data(electrode_idx,freq_idx,:,ph,trial_idx),2,'omitnan'),3,'omitnan'),[5 4 3 2 1]);
                    tempdat=mean(mean(sbjicoh.data(:,FOI_idx,:,p,TOI_idx),2,'omitnan'),3,'omitnan');



