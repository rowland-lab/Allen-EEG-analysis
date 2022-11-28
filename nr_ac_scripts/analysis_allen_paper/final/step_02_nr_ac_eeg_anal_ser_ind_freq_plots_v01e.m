%%function step_03_nr_ac_eeg_anal_ser_ind_freq_plots_v01e(sbjs,filt,freq_band,epoch_type,version,date_str,save_fig,save_data)

%% Create subjectData variable
subjectData=[];
datafolder='/home/rowlandn/nr_data_analysis/data_analyzed/eeg/gen_03/data';
sbj=dir(fullfile(datafolder,'pro000*'));
sbj={sbj.name}'; 
calc_icoh=true;
calc_kin=true;
calc_labpower=true;
date_str='2022_09_24';
version='h';
labl='ew';
save_data='yes';
save_fig='yes';
FOI_label={'delta','theta','alpha','beta','gamma'};%can add more if you want
FOI_freq={{1,4},{5,8},{8,12},{13,30},{30,50}};


parfor s=1:numel(sbj)
    % Analysis folder
    anfold=fullfile(datafolder,sbj{s},'analysis');
    
    % Subject number
    subjectData(s).SubjectName=sbj{s};
    
    % Load S1 data
    disp(['Loading S1 data for...',sbj{s}])
    s1dat=load(fullfile(anfold,'S1-VR_preproc',[sbj{s},'_S1-VRdata_preprocessed.mat']));
    subjectData(s).sessioninfo=s1dat.sessioninfo;
    
    if calc_icoh||calc_labpower
        eeglabDat=load(fullfile(anfold,'EEGlab','EEGlab_Total.mat'));
        trials=fieldnames(eeglabDat.eegevents_ft.trials);
        for t=1:numel(trials)
            trialdat=eeglabDat.eegevents_ft.trials.(trials{t});
            for p=1:size(trialdat,1)
                if calc_icoh
                    
                    icoh_freq=trialdat(p).ft_iCoh.freq;
                    icoh_label=trialdat(p).ft_iCoh.labelcmb;
                    icoh_dim={'Label','Frequency','Reaches','Phase','Trial'};
                    if t==1 && p==1
                        tempicoh=nan(size(icoh_label,1),size(icoh_freq,2),12,size(trialdat,1),numel(trials));
                    end
                    tempicoh(:,:,1:size(trialdat(p).ft_iCoh.cohspctrm,3),p,t)=trialdat(p).ft_iCoh.cohspctrm;
                end
                if calc_labpower
                    power_times=trialdat(p).power.times;
                    power_freqs=trialdat(p).power.freqs;
                    chans=trialdat(p).chanlocs;
                    power_dim={'Frequency','Time','Channels','Phase','Trial'};
                    if t==1 && p==1
                        temppower=[];
                    end
                    temppower(:,:,:,p,t)=trialdat(p).power.ersp;
                end
            end
        end
        
        if calc_icoh
            disp(['Calculating EEGLAB icoh for...',sbj{s}])
            subjectData(s).iCoh.data=tempicoh;
            subjectData(s).iCoh.freq=icoh_freq;
            subjectData(s).iCoh.label=icoh_label;
            subjectData(s).iCoh.dim=icoh_dim;
        end
        
        if calc_labpower
            disp(['Calculating EEGLAB Power for...',sbj{s}])
            subjectData(s).power.data=temppower;
            subjectData(s).power.freq=power_freqs;
            subjectData(s).power.times=power_times;
            subjectData(s).power.chans=chans;
            subjectData(s).power.dim=power_dim;
        end
    end
    
    if calc_kin
        disp(['Calculating Kinematics for...',sbj{s}])
        metricDat=load(fullfile(anfold,'S2-metrics',[sbj{s},'_S2-Metrics.mat']));
        kinData=metricDat.metricdatraw.data;
        kinLabel=metricDat.metricdat.label;
        
        subjectData(s).kinematics.data=kinData;
        subjectData(s).kinematics.label=kinLabel;
    end
end
%%%%%%%%



% sbjs_all=['03';'04';'05';'42';'43';'13';'15';'17';'18';'21';'22';'24';'25';'26';'29';'30';'20';'23';'27';'28';'36'];
% sbjs_all_cell={'03';'04';'05';'42';'43';'13';'15';'17';'18';'21';'22';'24';'25';'26';'29';'30';'20';'23';'27';'28';'36'};
% 
% if strcmp(sbjs,'all')
%     sbjs_all=sbjs_all;
% else
%     sbj_find=strfind(sbjs_all_cell,sbjs);
%     for i=1:size(sbj_find,1)
%         if isempty(sbj_find{i})
%         else
%             find_sbj_find(i)=find(sbj_find{i})
%         end
%     end
%     sbjs_ind=find(find_sbj_find);
%     sbjs_all=sbjs_all(sbjs_ind,:);
% end


% just 5 more things: label freq band to left of plots ( i would do five diff colors), label p1, p2, p3 on
% right sided plots, label t1-t4 just 1 time at bottom right, then add
% multcompare and save data and you're done

%psd plots
for h=1:21
    sbj_num=subjectData(h).SubjectName(15:16);
    figure; set(gcf,'Position',[1512 -14 566 891])

    count=0;
    for i=[7 18]
        for j=1:4
            count=count+1
            for k=1:3
                if i==7
                    ax(count)=subplot(12,7,j); hold on
                    title(['t',num2str(j)])
                elseif i==18
                    ax(count)=subplot(12,7,j+42); hold on
                    title(['t',num2str(j)])
                end
                psd_time_all=subjectData(h).power.data(1:50,:,i,k,j);
                psd_time_mean=mean(psd_time_all,2);
                plot(psd_time_mean,'LineWidth',2);
                %eval(['ylim',num2str(count),'=get(gca,''ylim'');'])
                %xlabel('Hz')
            end
            if count==4
                l1=legend('hold','prep','move')
                set(l1,'Position',[0.6046 0.8614 0.1418 0.0498])
            elseif count==8
                l2=legend('hold','prep','move')
                set(l2,'Position',[0.5951 0.4541 0.1418 0.0498])
            end
        end

        if i==7
            linkaxes(ax(1:4))
        elseif i==18
            linkaxes(ax(5:8))
        end
    end

    %calculate means and supermeans   
    for i=[7 18]
        for j=1:4
            for k=1:3
                for l=1:5
                    eval(['mean_',FOI_label{l},'_sbj',sbj_num,'_ch',num2str(i),'_t',num2str(j),'_p',num2str(k),'=',...
                       'subjectData(h).power.data(cell2mat(FOI_freq{l}(1)):cell2mat(FOI_freq{l}(2)),1:6:60,i,k,j);'])
                    eval(['mean_mean_',FOI_label{l},'_sbj',sbj_num,'_ch',num2str(i),'_t',num2str(j),'_p',num2str(k),'=',...
                       'mean(mean(mean_',FOI_label{l},'_sbj',sbj_num,'_ch',num2str(i),'_t',num2str(j),'_p',num2str(k),'));'])
                    eval(['se_mean_',FOI_label{l},'_sbj',sbj_num,'_ch',num2str(i),'_t',num2str(j),'_p',num2str(k),'=',...
                       'std(mean(mean_',FOI_label{l},'_sbj',sbj_num,'_ch',num2str(i),'_t',num2str(j),'_p',num2str(k),'))/',...
                       'sqrt(size(mean(mean_',FOI_label{l},'_sbj',sbj_num,'_ch',num2str(i),'_t',num2str(j),'_p',num2str(k),'),2));'])
                end
            end
        end
    end

    %grouping variables
    grp_vart=[linspace(1,1,10),linspace(2,2,10),linspace(3,3,10)];
    grp_varp=[linspace(1,1,10),linspace(2,2,10),linspace(3,3,10),linspace(4,4,10)];

    %stats
    for i=[7 18]
        for j=1:4
            for l=1:5
                 eval(['[pt_mean_',FOI_label{l},'_sbj',sbj_num,'_ch',num2str(i),'_t',num2str(j),',',...
                    'ttable_mean_',FOI_label{l},'_sbj',sbj_num,'_ch',num2str(i),'_t',num2str(j),',',...
                    'sttats_mean_',FOI_label{l},'_sbj',sbj_num,'_ch',num2str(i),'_t',num2str(j),']=',...
                    'kruskalwallis([mean_',FOI_label{l},'_sbj',sbj_num,'_ch',num2str(i),'_t',num2str(j),'_p1,',...
                    'mean_',FOI_label{l},'_sbj',sbj_num,'_ch',num2str(i),'_t',num2str(j),'_p2,',...
                    'mean_',FOI_label{l},'_sbj',sbj_num,'_ch',num2str(i),'_t',num2str(j),'_p3],[grp_vart],''off'');'])
            end
        end
    end

    for i=[7 18]
        for k=1:3
            for l=1:5
                 eval(['[pp_mean_',FOI_label{l},'_sbj',sbj_num,'_ch',num2str(i),'_p',num2str(k),',',...
                    'tpable_mean_',FOI_label{l},'_sbj',sbj_num,'_ch',num2str(i),'_p',num2str(k),',',...
                    'sptats_mean_',FOI_label{l},'_sbj',sbj_num,'_ch',num2str(i),'_p',num2str(k),']=',...
                    'kruskalwallis([mean_',FOI_label{l},'_sbj',sbj_num,'_ch',num2str(i),'_t1_p',num2str(k)...
                    ',mean_',FOI_label{l},'_sbj',sbj_num,'_ch',num2str(i),'_t2_p',num2str(k)...
                    ',mean_',FOI_label{l},'_sbj',sbj_num,'_ch',num2str(i),'_t3_p',num2str(k)...
                    ',mean_',FOI_label{l},'_sbj',sbj_num,'_ch',num2str(i),'_t4_p',num2str(k),'],[grp_varp],''off'');'])
            end
        end
    end

    %comparison among phases - setting up barplot arrays
    for i=[7 18]
        for j=1:4
            for k=1:3
                for l=1:5
                    eval(['barp_mean_mean_',FOI_label{l},'_sbj',sbj_num,'_ch',num2str(i),'_t',num2str(j),'(k)=',...
                        'mean_mean_',FOI_label{l},'_sbj',sbj_num,'_ch',num2str(i),'_t',num2str(j),'_p',num2str(k)])
                    eval(['errorbarp_mean_mean_',FOI_label{l},'_sbj',sbj_num,'_ch',num2str(i),'_t',num2str(j),'(k)=',...
                        'se_mean_',FOI_label{l},'_sbj',sbj_num,'_ch',num2str(i),'_t',num2str(j),'_p',num2str(k)])
                end
            end
        end
    end

    %comparison among trials - setting up barplot arrays
    for i=[7 18]
        for k=1:3
            for j=1:4
                for l=1:5
                    eval(['bart_mean_mean_',FOI_label{l},'_sbj',sbj_num,'_ch',num2str(i),'_p',num2str(k),'(j)=',...
                        'mean_mean_',FOI_label{l},'_sbj',sbj_num,'_ch',num2str(i),'_t',num2str(j),'_p',num2str(k)])
                    eval(['errorbart_mean_mean_',FOI_label{l},'_sbj',sbj_num,'_ch',num2str(i),'_p',num2str(k),'(j)=',...
                        'se_mean_',FOI_label{l},'_sbj',sbj_num,'_ch',num2str(i),'_t',num2str(j),'_p',num2str(k)])
                end
            end
        end
    end

    spp7=[8,9,10,11,15,16,17,18,22,23,24,25,29,30,31,32,36,37,38,39];
    spp18=[50,51,52,53,57,58,59,60,64,65,66,67,71,72,73,74,78,79,80,81];
    for i=[7 18]
        count=0;
        if i==7
            
            for l=1:5 
                for j=1:4
                    count=count+1;
                    subplot(12,7,spp7(count)); hold on
                    eval(['bar(barp_mean_mean_',FOI_label{l},'_sbj',sbj_num,'_ch',num2str(i),'_t',num2str(j),')'])
                    eval(['errorbar(barp_mean_mean_',FOI_label{l},'_sbj',sbj_num,'_ch',num2str(i),'_t',num2str(j),',',...
                        'errorbarp_mean_mean_',FOI_label{l},'_sbj',sbj_num,'_ch',num2str(i),'_t',num2str(j),',''k.'')'])
                    set(gca,'XTickLabel',[])
                    if eval(['pt_mean_',FOI_label{l},'_sbj',sbj_num,'_ch',num2str(i),'_t',num2str(j)])<=0.05
                        title(eval(['pt_mean_',FOI_label{l},'_sbj',sbj_num,'_ch',num2str(i),'_t',num2str(j)]),...
                            'FontSize',6,'Color',[1 0 0])
                    else
                        title(eval(['pt_mean_',FOI_label{l},'_sbj',sbj_num,'_ch',num2str(i),'_t',num2str(j)]),...
                            'FontSize',6)
                    end
                    if count==1
                        subplot(12,7,spp7(count))
                        ylabel('delta','FontSize',8)
                    elseif count==5
                        subplot(12,7,spp7(count))
                        ylabel('theta','Color','b','FontSize',8)
                    elseif count==9
                        subplot(12,7,spp7(count))
                        ylabel('alpha','Color','g','FontSize',8)
                    elseif count==13
                        subplot(12,7,spp7(count))
                        ylabel('beta','Color','c','FontSize',8)
                    elseif count==17
                        subplot(12,7,spp7(count))
                        ylabel('gamma','Color','m','FontSize',8)
                    end
            
                    %title([FOI_label{l},' t',num2str(j),' c',num2str(i)])
                end
            end
            
        elseif i==18
            for l=1:5
                for j=1:4
                    count=count+1;
                     subplot(12,7,spp18(count)); hold on
                    eval(['bar(barp_mean_mean_',FOI_label{l},'_sbj',sbj_num,'_ch',num2str(i),'_t',num2str(j),')'])
                    eval(['errorbar(barp_mean_mean_',FOI_label{l},'_sbj',sbj_num,'_ch',num2str(i),'_t',num2str(j),',',...
                        'errorbarp_mean_mean_',FOI_label{l},'_sbj',sbj_num,'_ch',num2str(i),'_t',num2str(j),',''k.'')'])
                    if count>=16
                        set(gca,'XTick',[1 2 3],'XTickLabel',{'h';'p';'m'})
                    else
                        set(gca,'XTickLabel',[])
                    end
                    if eval(['pt_mean_',FOI_label{l},'_sbj',sbj_num,'_ch',num2str(i),'_t',num2str(j)])<=0.05
                        title(eval(['pt_mean_',FOI_label{l},'_sbj',sbj_num,'_ch',num2str(i),'_t',num2str(j)]),...
                            'FontSize',6,'Color',[1 0 0])
                    else
                        title(eval(['pt_mean_',FOI_label{l},'_sbj',sbj_num,'_ch',num2str(i),'_t',num2str(j)]),...
                            'FontSize',6)
                    end
                    if count==1
                        subplot(12,7,spp18(count))
                        ylabel('delta','FontSize',8)
                    elseif count==5
                        subplot(12,7,spp18(count))
                        ylabel('theta','Color','b','FontSize',8)
                    elseif count==9
                        subplot(12,7,spp18(count))
                        ylabel('alpha','Color','g','FontSize',8)
                    elseif count==13
                        subplot(12,7,spp18(count))
                        ylabel('beta','Color','c','FontSize',8)
                    elseif count==17
                        subplot(12,7,spp18(count))
                        ylabel('gamma','Color','m','FontSize',8)
                    end
                    %title([FOI_label{l},' t',num2str(j),' c',num2str(i)])
                end
            end
        end
    end

    spt7=[12,13,14,19,20,21,26,27,28,33,34,35,40,41,42];
    spt18=[54,55,56,61,62,63,68,69,70,75,76,77,82,83,84];
    for i=[7 18]
        count=0;
        if i==7
            for l=1:5 
                for k=1:3
                    count=count+1;
                    subplot(12,7,spt7(count)); hold on
                    eval(['bar(bart_mean_mean_',FOI_label{l},'_sbj',sbj_num,'_ch',num2str(i),'_p',num2str(k),')'])
                    eval(['errorbar(bart_mean_mean_',FOI_label{l},'_sbj',sbj_num,'_ch',num2str(i),'_p',num2str(k),',',...
                        'errorbart_mean_mean_',FOI_label{l},'_sbj',sbj_num,'_ch',num2str(i),'_p',num2str(k),',''k.'')'])
                    set(gca,'XTickLabel',[])
                    if eval(['pp_mean_',FOI_label{l},'_sbj',sbj_num,'_ch',num2str(i),'_p',num2str(k)])<=0.05
                        title(eval(['pp_mean_',FOI_label{l},'_sbj',sbj_num,'_ch',num2str(i),'_p',num2str(k)]),...
                            'FontSize',6,'Color',[1 0 0])
                    else
                        title(eval(['pp_mean_',FOI_label{l},'_sbj',sbj_num,'_ch',num2str(i),'_p',num2str(k)]),...
                            'FontSize',6)
                    end
                    if count==1
                        annotation('textbox',[0.607 0.840 0.049 0.030],'String','p1','FitBoxToText','on')
                    elseif count==2
                        annotation('textbox',[0.716 0.840 0.049 0.030],'String','p2','FitBoxToText','on')
                    elseif count==3
                        annotation('textbox',[0.834 0.840 0.049 0.030],'String','p3','FitBoxToText','on')
                    %title([FOI_label{l},' t',num2str(j),' c',num2str(i)])
                    end
                end
            end
        elseif i==18
            for l=1:5
                for k=1:3
                    count=count+1;
                     subplot(12,7,spt18(count)); hold on
                    eval(['bar(bart_mean_mean_',FOI_label{l},'_sbj',sbj_num,'_ch',num2str(i),'_p',num2str(k),')'])
                    eval(['errorbar(bart_mean_mean_',FOI_label{l},'_sbj',sbj_num,'_ch',num2str(i),'_p',num2str(k),',',...
                        'errorbart_mean_mean_',FOI_label{l},'_sbj',sbj_num,'_ch',num2str(i),'_p',num2str(k),',''k.'')'])
                    if count>=82
                        set(gca,'XTick',[1 2 3 4],'XTickLabel',{'t1';'t2';'t3';'t4'})
                    else
                        set(gca,'XTickLabel',[])
                    end
                    
                    if eval(['pp_mean_',FOI_label{l},'_sbj',sbj_num,'_ch',num2str(i),'_p',num2str(k)])<=0.05
                        title(eval(['pp_mean_',FOI_label{l},'_sbj',sbj_num,'_ch',num2str(i),'_p',num2str(k)]),...
                            'FontSize',6,'Color',[1 0 0])
                    else
                        title(eval(['pp_mean_',FOI_label{l},'_sbj',sbj_num,'_ch',num2str(i),'_p',num2str(k)]),...
                            'FontSize',6)
                    end
                    %title([FOI_label{l},' p',num2str(k),' c',num2str(i)])
                    if count>=13
                        set(gca,'XTick',[1:4],'XTickLabel',{'t1';'t2';'t3';'t4'},'FontSize',6)
                    end
                end 
            end
        end
    end

    sgtitle(['sbj',sbj_num])
    
    if strcmp(save_fig,'yes')
        saveas(gcf,['~/nr_data_analysis/data_analyzed/eeg/gen_03/analysis_pow/',date_str,'/gen_03_ver_',version,'_',labl,'_ind_',...
            'sbj_',sbj_num,'.fig'],'fig')
    end  
    
    
    clear bar* count errorbar* grp* mean_a* mean_b* mean_d* mean_g* mean_t* p* se* sp* st* t*
end

if strcmp(save_data,'yes')
    for i=1:5
        save(['~/nr_data_analysis/data_analyzed/eeg/gen_03/analysis_pow/',date_str,'/gen_03_ver_',version,...
            '_',labl,'_mean_mean_',FOI_label{i},'_ind_all'] ,['mean_mean_',FOI_label{i},'*']) 
    end
end



 