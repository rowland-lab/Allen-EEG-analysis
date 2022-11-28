function step_03_nr_ac_eeg_anal_ser_sum_freq_plots_v01d(grp,epoch_type,freq_band,version, save_figs,save_data,date_str)

%7/3/22
% I first ran this with the original gen_02 data just to make sure it would
% run...DONE
% No sig differences for cs, but there are for hc ipsi stim, beta increases
% then decreases with stim off
% Next I compared to the saved figs for gen_02 and they were identical
% in order to run for gen_03, a number of changes needed to be made:
% I changed how I assigned ipsi vs contra channels (again I manually
% changed 42 and 43 for now)

% 9/24/22
%This is optimized for the ica removed power cohort

% sum fig using epochsWhole

%%%THIS CAN OBVIOUSLY BE OPTIMIZED BY MAKING A FOR LOOP FOR STM VS NON
%%%(AND IPSI VS CONTRA WITHIN EACH

%tomorrow just finish substituting freqband for beta, then convert into
%function, save fig, figure out what data the lin reg function needs, save
%that, then compare final figs to the ones generated on left then you are
%readuy to move onto lin reg...DONE

% grp='cs';
% epoch_type='epochsWhole';
% freq_band='beta';
% date_str='2022_09_24';
% version='h';
% save_figs='yes';
% save_data='yes';

subjectData=[];
datafolder='/home/rowlandn/nr_data_analysis/data_analyzed/eeg/gen_03/data';
sbj=dir(fullfile(datafolder,'pro000*'));
sbj={sbj.name}'; 
calc_icoh=true;
calc_kin=true;
calc_labpower=true;
%date_str='2022_09_24';
%version='h';
%labl='ew';
%save_data='yes';
% FOI_label={'delta','theta','alpha','beta','gamma'};%can add more if you want
% FOI_freq={{1,4},{5,8},{8,12},{13,30},{30,50}};


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

mean_mean_var=['~/nr_data_analysis/data_analyzed/eeg/gen_03/analysis_pow/',date_str,'/gen_03_ver_',version,'_ew_mean_mean_',freq_band,'_ind_all.mat'];
load(mean_mean_var)

if strcmp(grp,'cs')
    sbjs_stm=['03';'04';'05';'42';'43'];
    for n=1:size(sbjs_stm,1)
        load(['/home/rowlandn/nr_data_analysis/data_analyzed/data_for_dlc/pro00087153_00',sbjs_stm(n,:),...
        '_sessioninfo.mat'])
        if strcmp(sessioninfo.stimlat,'R')
            elec_stm_ipsi(n)=18;
            elec_stm_cont(n)=7;
        elseif strcmp(sessioninfo.stimlat,'L')
            elec_stm_ipsi(n)=7;
            elec_stm_cont(n)=18;
        end
        l1_stm_str{n}=sbjs_stm(n,:);
%     elec_stm_ipsi=[7,7,18,18,7];
%     elec_stm_cont=[18,18,7,7,18];
    end
    %manually change for 42 and 43
    elec_stm_ipsi(4)=18;
    elec_stm_cont(4)=7;
    elec_stm_ipsi(5)=7;
    elec_stm_cont(5)=18;
    sbjs_non=['13';'15';'17';'18';'21'];
    for n=1:size(sbjs_non,1)
        load(['/home/rowlandn/nr_data_analysis/data_analyzed/data_for_dlc/pro00087153_00',sbjs_non(n,:),...
        '_sessioninfo.mat'])
        if strcmp(sessioninfo.stimlat,'R')
            elec_non_ipsi(n)=18;
            elec_non_cont(n)=7;
        elseif strcmp(sessioninfo.stimlat,'L')
            elec_non_ipsi(n)=7;
            elec_non_cont(n)=18;
        end
        l1_non_str{n}=sbjs_non(n,:);
    end
%     elec_non_ipsi=[18,7,18,18,18];
%     elec_non_cont=[7,18,7,7,7];
elseif strcmp(grp,'hc')
    sbjs_stm=['22';'24';'25';'26';'29';'30'];
    for n=1:size(sbjs_stm,1)
        load(['/home/rowlandn/nr_data_analysis/data_analyzed/data_for_dlc/pro00087153_00',sbjs_stm(n,:),...
        '_sessioninfo.mat'])
        if strcmp(sessioninfo.stimlat,'R')
            elec_stm_ipsi(n)=18;
            elec_stm_cont(n)=7;
        elseif strcmp(sessioninfo.stimlat,'L')
            elec_stm_ipsi(n)=7;
            elec_stm_cont(n)=18;
        end
        l1_stm_str{n}=sbjs_stm(n,:);
    end
%     elec_stm_ipsi=[18,7,7,7,7,18];
%     elec_stm_cont=[7,18,18,18,18,7];
    sbjs_non=['20';'23';'27';'28';'36'];
    for n=1:size(sbjs_non,1)
        load(['/home/rowlandn/nr_data_analysis/data_analyzed/data_for_dlc/pro00087153_00',sbjs_non(n,:),...
        '_sessioninfo.mat'])
        if strcmp(sessioninfo.stimlat,'R')
            elec_non_ipsi(n)=18;
            elec_non_cont(n)=7;
        elseif strcmp(sessioninfo.stimlat,'L')
            elec_non_ipsi(n)=7;
            elec_non_cont(n)=18;
        end
        l1_non_str{n}=sbjs_non(n,:)
    end
%     elec_non_ipsi=[7,18,7,7,7];
%     elec_non_cont=[18,7,18,18,18];
end

if strcmp(epoch_type,'epochsWhole')
    labl='ew';
elseif strcmp(epoch_type,'vrevents')
    labl='vr';
end

if strcmp(freq_band,'delta')
    frq_rng_st=1;
    frq_rng_ed=4;
elseif strcmp(freq_band,'theta')
    frq_rng_st=4;
    frq_rng_ed=8;
elseif strcmp(freq_band,'alpha')
    frq_rng_st=8;
    frq_rng_ed=12;
elseif strcmp(freq_band,'beta')
    frq_rng_st=13;
    frq_rng_ed=31
elseif strcmp(freq_band,'gamma')
    frq_rng_st=30;
    frq_rng_ed=50;
end

phase={'atStartPosition';'cueEvent';'targetUp'};

for i=1:21
    sbjs{i}=subjectData(i).SubjectName
end

for i=1:21
    for j=1:size(sbjs_stm,1)
        sbj_stm_i(j)=find(endsWith(sbjs,sbjs_stm(j,:)))
    end
    
    for j=1:size(sbjs_non,1)
        sbj_non_i(j)=find(endsWith(sbjs,sbjs_non(j,:)))
    end
end
   
%stim ipsi
count=0;
for i=elec_stm_ipsi
    count=count+1
    for j=1:4
        for k=1:3
            for h=sbj_stm_i
                psd_time_all=subjectData(h).power.data(1:50,:,i,k,j);
                psd_time_mean=mean(psd_time_all,2);
                eval(['psd_ipsi_stm_t',num2str(j),'_p',num2str(k),'_time_mean_all(:,h)=psd_time_mean;'])
            end
            eval(['psd_ipsi_stm_t',num2str(j),'_p',num2str(k),'_time_mean_find=psd_ipsi_stm_t',...
                num2str(j),'_p',num2str(k),'_time_mean_all(:,sbj_stm_i)';])
            clear *all
        end
    end
end

for i=1:4
    for j=1:3
        for k=1:size(sbjs_stm,1)
            eval(['mean_mean_sum_',freq_band,'_t',num2str(i),'_p',num2str(j),'_stm_ipsi(',num2str(k),')=mean_mean_',freq_band,'_sbj',num2str(sbjs_stm(k,:)),...
                '_ch',num2str(elec_stm_ipsi(k)),'_t',num2str(i),'_p',num2str(j),';'])
        end
    end
end

for i=1:4
    for j=1:3
        eval(['mean_mean_mean_sum_',freq_band,'_t',num2str(i),'_p',num2str(j),'_stm_ipsi=mean(mean_mean_sum_',freq_band,'_t',num2str(i),'_p',num2str(j),'_stm_ipsi);'])
        eval(['se_mean_mean_sum_',freq_band,'_t',num2str(i),'_p',num2str(j),'_stm_ipsi=std(mean_mean_sum_',freq_band,'_t',num2str(i),'_p',num2str(j),...
            '_stm_ipsi)/sqrt(size(mean_mean_sum_',freq_band,'_t',num2str(i),'_p',num2str(j),'_stm_ipsi,2));'])
    end
end

figure; set(gcf,'Position',[3 47 744 898]); hold on
count=0
for j=1:3
    for i=1:4
        count=count+1
        if j==1
            subplot(8,5,i); hold on
            sp=i;
        elseif j==2
            subplot(8,5,i+5); hold on
            sp=i+5;
        elseif j==3
            subplot(8,5,i+10); hold on
            sp=i+10;
        end
         
        for k=1:size(sbjs_stm,1)
            eval(['plot(psd_ipsi_stm_t',num2str(i),'_p',num2str(j),'_time_mean_find,''LineWidth'',2)'])
        end
        
        if sp<10
            eval(['ylim_0',num2str(sp),'=get(gca,''ylim'')'])
        elseif sp>=10
            eval(['ylim_',num2str(sp),'=get(gca,''ylim'')'])
        end
           
        if count==1
            ylabel('atStartPosition')
            title([grp,' all:ipsi stm:t1:',freq_band,':',labl,':ver ',version])
        elseif count==2
            title('t2')
        elseif count==3
            title('t3')
        elseif count==4
            title('t4')
        elseif count==5
            ylabel('cueEvent')
        elseif count==9
            ylabel('targetUp')
        elseif count==12
            l1=legend;
        end
    end
end
min_ylim=min([ylim_01(1) ylim_02(1) ylim_03(1) ylim_04(1) ylim_06(1) ylim_07(1) ylim_08(1) ylim_09(1) ylim_11(1) ylim_12(1) ylim_13(1) ylim_14(1)])
max_ylim=max([ylim_01(2) ylim_02(2) ylim_03(2) ylim_04(2) ylim_06(2) ylim_07(2) ylim_08(2) ylim_09(2) ylim_11(2) ylim_12(2) ylim_13(2) ylim_14(2)])
for i=[1 2 3 4 6 7 8 9 11 12 13 14]
    subplot(8,5,i)
    set(gca,'ylim',[min_ylim max_ylim])
    plot([frq_rng_st frq_rng_st],[min_ylim max_ylim],'r')
    plot([frq_rng_ed frq_rng_ed],[min_ylim max_ylim],'r')
end
%set(l1,'String',{'sbj03','sbj04','sbj05','sbj42','sbj43'},'Position',[0.7837 0.5323 0.1051 0.0797])
set(l1,'String',l1_stm_str,'Position',[0.7837 0.5323 0.1051 0.0797])

subplot(8,5,5); hold on
eval(['bar([mean_mean_mean_sum_',freq_band,'_t1_p1_stm_ipsi mean_mean_mean_sum_',freq_band,'_t2_p1_stm_ipsi mean_mean_mean_sum_',freq_band,'_t3_p1_stm_ipsi mean_mean_mean_sum_',freq_band,'_t4_p1_stm_ipsi])'])
eval(['errorbar([mean_mean_mean_sum_',freq_band,'_t1_p1_stm_ipsi mean_mean_mean_sum_',freq_band,'_t2_p1_stm_ipsi mean_mean_mean_sum_',freq_band,'_t3_p1_stm_ipsi mean_mean_mean_sum_',freq_band,'_t4_p1_stm_ipsi],'...
    '[se_mean_mean_sum_',freq_band,'_t1_p1_stm_ipsi se_mean_mean_sum_',freq_band,'_t2_p1_stm_ipsi se_mean_mean_sum_',freq_band,'_t3_p1_stm_ipsi se_mean_mean_sum_',freq_band,'_t4_p1_stm_ipsi],''.k'')'])
set(gca,'XTick',[1:4],'XTickLabel',['t1';'t2';'t3';'t4'])
eval(['[p_mean_mean_sum_',freq_band,'_p1,anovatab_mean_mean_sum_',freq_band,'_p1,stats_mean_mean_sum_',freq_band,'_p1]='...
    'kruskalwallis([mean_mean_sum_',freq_band,'_t1_p1_stm_ipsi'',mean_mean_sum_',freq_band,'_t2_p1_stm_ipsi'',mean_mean_sum_',freq_band,'_t3_p1_stm_ipsi'',mean_mean_sum_',freq_band,'_t4_p1_stm_ipsi''],[],''off'')'])
if eval(['p_mean_mean_sum_',freq_band,'_p1<=0.05'])
    eval(['title(num2str(p_mean_mean_sum_',freq_band,'_p1),''Color'',[1 0 0])'])
else
    eval(['title(num2str(p_mean_mean_sum_',freq_band,'_p1))'])
end
eval(['nr_multcompare_ind_tdcs_plot(stats_mean_mean_sum_',freq_band,'_p1,min_ylim)'])

subplot(8,5,10); hold on
eval(['bar([mean_mean_mean_sum_',freq_band,'_t1_p2_stm_ipsi mean_mean_mean_sum_',freq_band,'_t2_p2_stm_ipsi mean_mean_mean_sum_',freq_band,'_t3_p2_stm_ipsi mean_mean_mean_sum_',freq_band,'_t4_p2_stm_ipsi])'])
eval(['errorbar([mean_mean_mean_sum_',freq_band,'_t1_p2_stm_ipsi mean_mean_mean_sum_',freq_band,'_t2_p2_stm_ipsi mean_mean_mean_sum_',freq_band,'_t3_p2_stm_ipsi mean_mean_mean_sum_',freq_band,'_t4_p2_stm_ipsi],'...
    '[se_mean_mean_sum_',freq_band,'_t1_p2_stm_ipsi se_mean_mean_sum_',freq_band,'_t2_p2_stm_ipsi se_mean_mean_sum_',freq_band,'_t3_p2_stm_ipsi se_mean_mean_sum_',freq_band,'_t4_p2_stm_ipsi],''.k'')'])
set(gca,'XTick',[1:4],'XTickLabel',['t1';'t2';'t3';'t4'])
eval(['[p_mean_mean_sum_',freq_band,'_p2,anovatab_mean_mean_sum_',freq_band,'_p2,stats_mean_mean_sum_',freq_band,'_p2]='...
    'kruskalwallis([mean_mean_sum_',freq_band,'_t1_p2_stm_ipsi'',mean_mean_sum_',freq_band,'_t2_p2_stm_ipsi'',mean_mean_sum_',freq_band,'_t3_p2_stm_ipsi'',mean_mean_sum_',freq_band,'_t4_p2_stm_ipsi''],[],''off'')'])
if eval(['p_mean_mean_sum_',freq_band,'_p2<=0.05'])
    eval(['title(num2str(p_mean_mean_sum_',freq_band,'_p2),''Color'',[1 0 0])'])
else
    eval(['title(num2str(p_mean_mean_sum_',freq_band,'_p2))'])
end
eval(['nr_multcompare_ind_tdcs_plot(stats_mean_mean_sum_',freq_band,'_p2,min_ylim)'])

subplot(8,5,15); hold on
eval(['bar([mean_mean_mean_sum_',freq_band,'_t1_p3_stm_ipsi mean_mean_mean_sum_',freq_band,'_t2_p3_stm_ipsi mean_mean_mean_sum_',freq_band,'_t3_p3_stm_ipsi mean_mean_mean_sum_',freq_band,'_t4_p3_stm_ipsi])'])
eval(['errorbar([mean_mean_mean_sum_',freq_band,'_t1_p3_stm_ipsi mean_mean_mean_sum_',freq_band,'_t2_p3_stm_ipsi mean_mean_mean_sum_',freq_band,'_t3_p3_stm_ipsi mean_mean_mean_sum_',freq_band,'_t4_p3_stm_ipsi],'...
    '[se_mean_mean_sum_',freq_band,'_t1_p3_stm_ipsi se_mean_mean_sum_',freq_band,'_t2_p3_stm_ipsi se_mean_mean_sum_',freq_band,'_t3_p3_stm_ipsi se_mean_mean_sum_',freq_band,'_t4_p3_stm_ipsi],''.k'')'])
set(gca,'XTick',[1:4],'XTickLabel',['t1';'t2';'t3';'t4'])
eval(['[p_mean_mean_sum_',freq_band,'_p3,anovatab_mean_mean_sum_',freq_band,'_p3,stats_mean_mean_sum_',freq_band,'_p3]='...
    'kruskalwallis([mean_mean_sum_',freq_band,'_t1_p3_stm_ipsi'',mean_mean_sum_',freq_band,'_t2_p3_stm_ipsi'',mean_mean_sum_',freq_band,'_t3_p3_stm_ipsi'',mean_mean_sum_',freq_band,'_t4_p3_stm_ipsi''],[],''off'')'])
if eval(['p_mean_mean_sum_',freq_band,'_p3<=0.05'])
    eval(['title(num2str(p_mean_mean_sum_',freq_band,'_p3),''Color'',[1 0 0])'])
else
    eval(['title(num2str(p_mean_mean_sum_',freq_band,'_p3))'])
end
eval(['nr_multcompare_ind_tdcs_plot(stats_mean_mean_sum_',freq_band,'_p3,min_ylim)'])

subplot(8,5,16); hold on
eval(['bar([mean_mean_mean_sum_',freq_band,'_t1_p1_stm_ipsi mean_mean_mean_sum_',freq_band,'_t1_p2_stm_ipsi mean_mean_mean_sum_',freq_band,'_t1_p3_stm_ipsi])'])
eval(['errorbar([mean_mean_mean_sum_',freq_band,'_t1_p1_stm_ipsi mean_mean_mean_sum_',freq_band,'_t1_p2_stm_ipsi mean_mean_mean_sum_',freq_band,'_t1_p3_stm_ipsi],'...
    '[se_mean_mean_sum_',freq_band,'_t1_p1_stm_ipsi se_mean_mean_sum_',freq_band,'_t1_p2_stm_ipsi se_mean_mean_sum_',freq_band,'_t1_p3_stm_ipsi],''.k'')'])
set(gca,'XTick',[1:3],'XTickLabel',['h';'p';'m'])
eval(['[p_mean_mean_sum_',freq_band,'_t1,anovatab_mean_mean_sum_',freq_band,'_t1,stats_mean_mean_sum_',freq_band,'_t1]='...
    'kruskalwallis([mean_mean_sum_',freq_band,'_t1_p1_stm_ipsi'',mean_mean_sum_',freq_band,'_t1_p2_stm_ipsi'',mean_mean_sum_',freq_band,'_t1_p3_stm_ipsi''],[],''off'')'])
if eval(['p_mean_mean_sum_',freq_band,'_t1<=0.05'])
    eval(['title(num2str(p_mean_mean_sum_',freq_band,'_t1),''Color'',[1 0 0])'])
else
    eval(['title(num2str(p_mean_mean_sum_',freq_band,'_t1))'])
end
eval(['nr_multcompare_ind_tdcs_plot(stats_mean_mean_sum_',freq_band,'_t1,0)'])

subplot(8,5,17); hold on
eval(['bar([mean_mean_mean_sum_',freq_band,'_t2_p1_stm_ipsi mean_mean_mean_sum_',freq_band,'_t2_p2_stm_ipsi mean_mean_mean_sum_',freq_band,'_t2_p3_stm_ipsi])'])
eval(['errorbar([mean_mean_mean_sum_',freq_band,'_t2_p1_stm_ipsi mean_mean_mean_sum_',freq_band,'_t2_p2_stm_ipsi mean_mean_mean_sum_',freq_band,'_t2_p3_stm_ipsi],'...
    '[se_mean_mean_sum_',freq_band,'_t2_p1_stm_ipsi se_mean_mean_sum_',freq_band,'_t2_p2_stm_ipsi se_mean_mean_sum_',freq_band,'_t2_p3_stm_ipsi],''.k'')'])
set(gca,'XTick',[1:3],'XTickLabel',['h';'p';'m'])
eval(['[p_mean_mean_sum_',freq_band,'_t2,anovatab_mean_mean_sum_',freq_band,'_t2,stats_mean_mean_sum_',freq_band,'_t2]='...
    'kruskalwallis([mean_mean_sum_',freq_band,'_t2_p1_stm_ipsi'',mean_mean_sum_',freq_band,'_t2_p2_stm_ipsi'',mean_mean_sum_',freq_band,'_t2_p3_stm_ipsi''],[],''off'')'])
if eval(['p_mean_mean_sum_',freq_band,'_t2<=0.05'])
    eval(['title(num2str(p_mean_mean_sum_',freq_band,'_t2),''Color'',[1 0 0])'])
else
    eval(['title(num2str(p_mean_mean_sum_',freq_band,'_t2))'])
end
eval(['nr_multcompare_ind_tdcs_plot(stats_mean_mean_sum_',freq_band,'_t2,0)'])

subplot(8,5,18); hold on
eval(['bar([mean_mean_mean_sum_',freq_band,'_t3_p1_stm_ipsi mean_mean_mean_sum_',freq_band,'_t3_p2_stm_ipsi mean_mean_mean_sum_',freq_band,'_t3_p3_stm_ipsi])'])
eval(['errorbar([mean_mean_mean_sum_',freq_band,'_t3_p1_stm_ipsi mean_mean_mean_sum_',freq_band,'_t3_p2_stm_ipsi mean_mean_mean_sum_',freq_band,'_t3_p3_stm_ipsi],'...
    '[se_mean_mean_sum_',freq_band,'_t3_p1_stm_ipsi se_mean_mean_sum_',freq_band,'_t3_p2_stm_ipsi se_mean_mean_sum_',freq_band,'_t3_p3_stm_ipsi],''.k'')'])
set(gca,'XTick',[1:3],'XTickLabel',['h';'p';'m'])
eval(['[p_mean_mean_sum_',freq_band,'_t3,anovatab_mean_mean_sum_',freq_band,'_t3,stats_mean_mean_sum_',freq_band,'_t3]='...
    'kruskalwallis([mean_mean_sum_',freq_band,'_t3_p1_stm_ipsi'',mean_mean_sum_',freq_band,'_t3_p2_stm_ipsi'',mean_mean_sum_',freq_band,'_t3_p3_stm_ipsi''],[],''off'')'])
if eval(['p_mean_mean_sum_',freq_band,'_t3<=0.05'])
    eval(['title(num2str(p_mean_mean_sum_',freq_band,'_t3),''Color'',[1 0 0])'])
else
    eval(['title(num2str(p_mean_mean_sum_',freq_band,'_t3))'])
end
eval(['nr_multcompare_ind_tdcs_plot(stats_mean_mean_sum_',freq_band,'_t3,0)'])

subplot(8,5,19); hold on
eval(['bar([mean_mean_mean_sum_',freq_band,'_t4_p1_stm_ipsi mean_mean_mean_sum_',freq_band,'_t4_p2_stm_ipsi mean_mean_mean_sum_',freq_band,'_t4_p3_stm_ipsi])'])
eval(['errorbar([mean_mean_mean_sum_',freq_band,'_t4_p1_stm_ipsi mean_mean_mean_sum_',freq_band,'_t4_p2_stm_ipsi mean_mean_mean_sum_',freq_band,'_t4_p3_stm_ipsi],'...
    '[se_mean_mean_sum_',freq_band,'_t4_p1_stm_ipsi se_mean_mean_sum_',freq_band,'_t4_p2_stm_ipsi se_mean_mean_sum_',freq_band,'_t4_p3_stm_ipsi],''.k'')'])
set(gca,'XTick',[1:3],'XTickLabel',['h';'p';'m'])
eval(['[p_mean_mean_sum_',freq_band,'_t4,anovatab_mean_mean_sum_',freq_band,'_t4,stats_mean_mean_sum_',freq_band,'_t4]='...
    'kruskalwallis([mean_mean_sum_',freq_band,'_t4_p1_stm_ipsi'',mean_mean_sum_',freq_band,'_t4_p2_stm_ipsi'',mean_mean_sum_',freq_band,'_t4_p3_stm_ipsi''],[],''off'')'])
if eval(['p_mean_mean_sum_',freq_band,'_t4<=0.05'])
    eval(['title(num2str(p_mean_mean_sum_',freq_band,'_t4),''Color'',[1 0 0])'])
else
    eval(['title(num2str(p_mean_mean_sum_',freq_band,'_t4))'])
end
eval(['nr_multcompare_ind_tdcs_plot(stats_mean_mean_sum_',freq_band,'_t4,0)'])
%clear *ipsi
clear anovatab* p_mean* stats* 

%stim cont
count=0;
for i=elec_stm_cont
    count=count+1
    for j=1:4
        for k=1:3
            for h=sbj_stm_i
                psd_time_all=subjectData(h).power.data(1:50,:,i,k,j);
                psd_time_mean=mean(psd_time_all,2);
                eval(['psd_cont_stm_t',num2str(j),'_p',num2str(k),'_time_mean_all(:,h)=psd_time_mean;'])
            end
            eval(['psd_cont_stm_t',num2str(j),'_p',num2str(k),'_time_mean_find=psd_cont_stm_t',...
                num2str(j),'_p',num2str(k),'_time_mean_all(:,sbj_stm_i);'])
            clear *all
        end
    end
end

for i=1:4
    for j=1:3
        for k=1:size(sbjs_stm,1)
            eval(['mean_mean_sum_',freq_band,'_t',num2str(i),'_p',num2str(j),'_stm_cont(',num2str(k),')=mean_mean_',freq_band,'_sbj',num2str(sbjs_stm(k,:)),...
                '_ch',num2str(elec_stm_cont(k)),'_t',num2str(i),'_p',num2str(j)])
        end
    end
end

for i=1:4
    for j=1:3
        eval(['mean_mean_mean_sum_',freq_band,'_t',num2str(i),'_p',num2str(j),'_stm_cont=mean(mean_mean_sum_',freq_band,'_t',num2str(i),'_p',num2str(j),'_stm_cont)'])
        eval(['se_mean_mean_sum_',freq_band,'_t',num2str(i),'_p',num2str(j),'_stm_cont=std(mean_mean_sum_',freq_band,'_t',num2str(i),'_p',num2str(j),...
            '_stm_cont)/sqrt(size(mean_mean_sum_',freq_band,'_t',num2str(i),'_p',num2str(j),'_stm_cont,2))'])
    end
end

count=20
for j=1:3
    for i=1:4
        count=count+1
        if j==1
            subplot(8,5,i+20); hold on
            sp=i+20;
        elseif j==2
            subplot(8,5,i+25); hold on
            sp=i+25;
        elseif j==3
            subplot(8,5,i+30); hold on
            sp=i+30;
        end
         
        for k=1:size(sbjs_stm,1)
            eval(['plot(psd_cont_stm_t',num2str(i),'_p',num2str(j),'_time_mean_find,''LineWidth'',2)'])
        end
        
        eval(['ylim_',num2str(sp),'=get(gca,''ylim'')'])
           
        if count==21
            ylabel('atStartPosition')
            title('cont stim:t1')
        elseif count==22
            title('t2')
        elseif count==23
            title('t3')
        elseif count==24
            title('t4')
        elseif count==25
            ylabel('cueEvent')
        elseif count==29
            ylabel('targetUp')
        elseif count==32
            l2=legend
        end
    end
end
min_ylim=min([ylim_21(1) ylim_22(1) ylim_23(1) ylim_24(1) ylim_26(1) ylim_27(1) ylim_28(1) ylim_29(1) ylim_31(1) ylim_32(1) ylim_33(1) ylim_34(1)])
max_ylim=max([ylim_21(2) ylim_22(2) ylim_23(2) ylim_24(2) ylim_26(2) ylim_27(2) ylim_28(2) ylim_29(2) ylim_31(2) ylim_32(2) ylim_33(2) ylim_34(2)])
for i=[21 22 23 24 26 27 28 29 31 32 33 34]
    subplot(8,5,i)
    set(gca,'ylim',[min_ylim max_ylim])
    plot([frq_rng_st frq_rng_st],[min_ylim max_ylim],'r')
    plot([frq_rng_ed frq_rng_ed],[min_ylim max_ylim],'r')
end
set(l2,'String',l1_stm_str,'Position',[0.7837 0.1033 0.1051 0.0803])

subplot(8,5,25); hold on
eval(['bar([mean_mean_mean_sum_',freq_band,'_t1_p1_stm_cont mean_mean_mean_sum_',freq_band,'_t2_p1_stm_cont mean_mean_mean_sum_',freq_band,'_t3_p1_stm_cont mean_mean_mean_sum_',freq_band,'_t4_p1_stm_cont])'])
eval(['errorbar([mean_mean_mean_sum_',freq_band,'_t1_p1_stm_cont mean_mean_mean_sum_',freq_band,'_t2_p1_stm_cont mean_mean_mean_sum_',freq_band,'_t3_p1_stm_cont mean_mean_mean_sum_',freq_band,'_t4_p1_stm_cont],'...
    '[se_mean_mean_sum_',freq_band,'_t1_p1_stm_cont se_mean_mean_sum_',freq_band,'_t2_p1_stm_cont se_mean_mean_sum_',freq_band,'_t3_p1_stm_cont se_mean_mean_sum_',freq_band,'_t4_p1_stm_cont],''.k'')'])
set(gca,'XTick',[1:4],'XTickLabel',['t1';'t2';'t3';'t4'])
eval(['[p_mean_mean_sum_',freq_band,'_p1,anovatab_mean_mean_sum_',freq_band,'_p1,stats_mean_mean_sum_',freq_band,'_p1]='...
    'kruskalwallis([mean_mean_sum_',freq_band,'_t1_p1_stm_cont'',mean_mean_sum_',freq_band,'_t2_p1_stm_cont'',mean_mean_sum_',freq_band,'_t3_p1_stm_cont'',mean_mean_sum_',freq_band,'_t4_p1_stm_cont''],[],''off'')'])
if eval(['p_mean_mean_sum_',freq_band,'_p1<=0.05'])
    eval(['title(num2str(p_mean_mean_sum_',freq_band,'_p1),''Color'',[1 0 0])'])
else
    eval(['title(num2str(p_mean_mean_sum_',freq_band,'_p1))'])
end
eval(['nr_multcompare_ind_tdcs_plot(stats_mean_mean_sum_',freq_band,'_p1,min_ylim)'])

subplot(8,5,30); hold on
eval(['bar([mean_mean_mean_sum_',freq_band,'_t1_p2_stm_cont mean_mean_mean_sum_',freq_band,'_t2_p2_stm_cont mean_mean_mean_sum_',freq_band,'_t3_p2_stm_cont mean_mean_mean_sum_',freq_band,'_t4_p2_stm_cont])'])
eval(['errorbar([mean_mean_mean_sum_',freq_band,'_t1_p2_stm_cont mean_mean_mean_sum_',freq_band,'_t2_p2_stm_cont mean_mean_mean_sum_',freq_band,'_t3_p2_stm_cont mean_mean_mean_sum_',freq_band,'_t4_p2_stm_cont],'...
    '[se_mean_mean_sum_',freq_band,'_t1_p2_stm_cont se_mean_mean_sum_',freq_band,'_t2_p2_stm_cont se_mean_mean_sum_',freq_band,'_t3_p2_stm_cont se_mean_mean_sum_',freq_band,'_t4_p2_stm_cont],''.k'')'])
set(gca,'XTick',[1:4],'XTickLabel',['t1';'t2';'t3';'t4'])
eval(['[p_mean_mean_sum_',freq_band,'_p2,anovatab_mean_mean_sum_',freq_band,'_p2,stats_mean_mean_sum_',freq_band,'_p2]='...
    'kruskalwallis([mean_mean_sum_',freq_band,'_t1_p2_stm_cont'',mean_mean_sum_',freq_band,'_t2_p2_stm_cont'',mean_mean_sum_',freq_band,'_t3_p2_stm_cont'',mean_mean_sum_',freq_band,'_t4_p2_stm_cont''],[],''off'')'])
if eval(['p_mean_mean_sum_',freq_band,'_p2<=0.05'])
    eval(['title(num2str(p_mean_mean_sum_',freq_band,'_p2),''Color'',[1 0 0])'])
else
    eval(['title(num2str(p_mean_mean_sum_',freq_band,'_p2))'])
end
eval(['nr_multcompare_ind_tdcs_plot(stats_mean_mean_sum_',freq_band,'_p2,min_ylim)'])

subplot(8,5,35); hold on
eval(['bar([mean_mean_mean_sum_',freq_band,'_t1_p3_stm_cont mean_mean_mean_sum_',freq_band,'_t2_p3_stm_cont mean_mean_mean_sum_',freq_band,'_t3_p3_stm_cont mean_mean_mean_sum_',freq_band,'_t4_p3_stm_cont])'])
eval(['errorbar([mean_mean_mean_sum_',freq_band,'_t1_p3_stm_cont mean_mean_mean_sum_',freq_band,'_t2_p3_stm_cont mean_mean_mean_sum_',freq_band,'_t3_p3_stm_cont mean_mean_mean_sum_',freq_band,'_t4_p3_stm_cont],'...
    '[se_mean_mean_sum_',freq_band,'_t1_p3_stm_cont se_mean_mean_sum_',freq_band,'_t2_p3_stm_cont se_mean_mean_sum_',freq_band,'_t3_p3_stm_cont se_mean_mean_sum_',freq_band,'_t4_p3_stm_cont],''.k'')'])
set(gca,'XTick',[1:4],'XTickLabel',['t1';'t2';'t3';'t4'])
eval(['[p_mean_mean_sum_',freq_band,'_p3,anovatab_mean_mean_sum_',freq_band,'_p3,stats_mean_mean_sum_',freq_band,'_p3]='...
    'kruskalwallis([mean_mean_sum_',freq_band,'_t1_p3_stm_cont'',mean_mean_sum_',freq_band,'_t2_p3_stm_cont'',mean_mean_sum_',freq_band,'_t3_p3_stm_cont'',mean_mean_sum_',freq_band,'_t4_p3_stm_cont''],[],''off'')'])
if eval(['p_mean_mean_sum_',freq_band,'_p3<=0.05'])
    eval(['title(num2str(p_mean_mean_sum_',freq_band,'_p3),''Color'',[1 0 0])'])
else
    eval(['title(num2str(p_mean_mean_sum_',freq_band,'_p3))'])
end
eval(['nr_multcompare_ind_tdcs_plot(stats_mean_mean_sum_',freq_band,'_p3,min_ylim)'])

subplot(8,5,36); hold on
eval(['bar([mean_mean_mean_sum_',freq_band,'_t1_p1_stm_cont mean_mean_mean_sum_',freq_band,'_t1_p2_stm_cont mean_mean_mean_sum_',freq_band,'_t1_p3_stm_cont])'])
eval(['errorbar([mean_mean_mean_sum_',freq_band,'_t1_p1_stm_cont mean_mean_mean_sum_',freq_band,'_t1_p2_stm_cont mean_mean_mean_sum_',freq_band,'_t1_p3_stm_cont],'...
    '[se_mean_mean_sum_',freq_band,'_t1_p1_stm_cont se_mean_mean_sum_',freq_band,'_t1_p2_stm_cont se_mean_mean_sum_',freq_band,'_t1_p3_stm_cont],''.k'')'])
set(gca,'XTick',[1:3],'XTickLabel',['h';'p';'m'])
eval(['[p_mean_mean_sum_',freq_band,'_t1,anovatab_mean_mean_sum_',freq_band,'_t1,stats_mean_mean_sum_',freq_band,'_t1]='...
    'kruskalwallis([mean_mean_sum_',freq_band,'_t1_p1_stm_cont'',mean_mean_sum_',freq_band,'_t1_p2_stm_cont'',mean_mean_sum_',freq_band,'_t1_p3_stm_cont''],[],''off'')'])
if eval(['p_mean_mean_sum_',freq_band,'_t1<=0.05'])
    eval(['title(num2str(p_mean_mean_sum_',freq_band,'_t1),''Color'',[1 0 0])'])
else
    eval(['title(num2str(p_mean_mean_sum_',freq_band,'_t1))'])
end
eval(['nr_multcompare_ind_tdcs_plot(stats_mean_mean_sum_',freq_band,'_t1,0)'])

subplot(8,5,37); hold on
eval(['bar([mean_mean_mean_sum_',freq_band,'_t2_p1_stm_cont mean_mean_mean_sum_',freq_band,'_t2_p2_stm_cont mean_mean_mean_sum_',freq_band,'_t2_p3_stm_cont])'])
eval(['errorbar([mean_mean_mean_sum_',freq_band,'_t2_p1_stm_cont mean_mean_mean_sum_',freq_band,'_t2_p2_stm_cont mean_mean_mean_sum_',freq_band,'_t2_p3_stm_cont],'...
    '[se_mean_mean_sum_',freq_band,'_t2_p1_stm_cont se_mean_mean_sum_',freq_band,'_t2_p2_stm_cont se_mean_mean_sum_',freq_band,'_t2_p3_stm_cont],''.k'')'])
set(gca,'XTick',[1:3],'XTickLabel',['h';'p';'m'])
eval(['[p_mean_mean_sum_',freq_band,'_t2,anovatab_mean_mean_sum_',freq_band,'_t2,stats_mean_mean_sum_',freq_band,'_t2]='...
    'kruskalwallis([mean_mean_sum_',freq_band,'_t2_p1_stm_cont'',mean_mean_sum_',freq_band,'_t2_p2_stm_cont'',mean_mean_sum_',freq_band,'_t2_p3_stm_cont''],[],''off'')'])
if eval(['p_mean_mean_sum_',freq_band,'_t2<=0.05'])
    eval(['title(num2str(p_mean_mean_sum_',freq_band,'_t2),''Color'',[1 0 0])'])
else
    eval(['title(num2str(p_mean_mean_sum_',freq_band,'_t2))'])
end
eval(['nr_multcompare_ind_tdcs_plot(stats_mean_mean_sum_',freq_band,'_t2,0)'])

subplot(8,5,38); hold on
eval(['bar([mean_mean_mean_sum_',freq_band,'_t3_p1_stm_cont mean_mean_mean_sum_',freq_band,'_t3_p2_stm_cont mean_mean_mean_sum_',freq_band,'_t3_p3_stm_cont])'])
eval(['errorbar([mean_mean_mean_sum_',freq_band,'_t3_p1_stm_cont mean_mean_mean_sum_',freq_band,'_t3_p2_stm_cont mean_mean_mean_sum_',freq_band,'_t3_p3_stm_cont],'...
    '[se_mean_mean_sum_',freq_band,'_t3_p1_stm_cont se_mean_mean_sum_',freq_band,'_t3_p2_stm_cont se_mean_mean_sum_',freq_band,'_t3_p3_stm_cont],''.k'')'])
set(gca,'XTick',[1:3],'XTickLabel',['h';'p';'m'])
eval(['[p_mean_mean_sum_',freq_band,'_t3,anovatab_mean_mean_sum_',freq_band,'_t3,stats_mean_mean_sum_',freq_band,'_t3]='...
    'kruskalwallis([mean_mean_sum_',freq_band,'_t3_p1_stm_cont'',mean_mean_sum_',freq_band,'_t3_p2_stm_cont'',mean_mean_sum_',freq_band,'_t3_p3_stm_cont''],[],''off'')'])
if eval(['p_mean_mean_sum_',freq_band,'_t3<=0.05'])
    eval(['title(num2str(p_mean_mean_sum_',freq_band,'_t3),''Color'',[1 0 0])'])
else
    eval(['title(num2str(p_mean_mean_sum_',freq_band,'_t3))'])
end
eval(['nr_multcompare_ind_tdcs_plot(stats_mean_mean_sum_',freq_band,'_t3,0)'])

subplot(8,5,39); hold on
eval(['bar([mean_mean_mean_sum_',freq_band,'_t4_p1_stm_cont mean_mean_mean_sum_',freq_band,'_t4_p2_stm_cont mean_mean_mean_sum_',freq_band,'_t4_p3_stm_cont])'])
eval(['errorbar([mean_mean_mean_sum_',freq_band,'_t4_p1_stm_cont mean_mean_mean_sum_',freq_band,'_t4_p2_stm_cont mean_mean_mean_sum_',freq_band,'_t4_p3_stm_cont],'...
    '[se_mean_mean_sum_',freq_band,'_t4_p1_stm_cont se_mean_mean_sum_',freq_band,'_t4_p2_stm_cont se_mean_mean_sum_',freq_band,'_t4_p3_stm_cont],''.k'')'])
set(gca,'XTick',[1:3],'XTickLabel',['h';'p';'m'])
eval(['[p_mean_mean_sum_',freq_band,'_t4,anovatab_mean_mean_sum_',freq_band,'_t4,stats_mean_mean_sum_',freq_band,'_t4]='...
    'kruskalwallis([mean_mean_sum_',freq_band,'_t4_p1_stm_cont'',mean_mean_sum_',freq_band,'_t4_p2_stm_cont'',mean_mean_sum_',freq_band,'_t4_p3_stm_cont''],[],''off'')'])
if eval(['p_mean_mean_sum_',freq_band,'_t4<=0.05'])
    eval(['title(num2str(p_mean_mean_sum_',freq_band,'_t4),''Color'',[1 0 0])'])
else
    eval(['title(num2str(p_mean_mean_sum_',freq_band,'_t4))'])
end
eval(['nr_multcompare_ind_tdcs_plot(stats_mean_mean_sum_',freq_band,'_t4,0)'])

clear anovatab* p_mean* stats* 

if strcmp(save_figs,'yes')
    saveas(gcf,['~/nr_data_analysis/data_analyzed/eeg/gen_03/analysis_pow/',date_str,'/gen_03_ver_',version,'_',labl,'_sum_',freq_band,'_',grp,'_stm.fig'],'fig')
end

%non ipsi
count=0;
for i=elec_non_ipsi
    count=count+1
    for j=1:4
        for k=1:3
            for h=sbj_non_i
                psd_time_all=subjectData(h).power.data(1:50,:,i,k,j);
                psd_time_mean=mean(psd_time_all,2);
                eval(['psd_ipsi_non_t',num2str(j),'_p',num2str(k),'_time_mean_all(:,h)=psd_time_mean;'])
            end
            eval(['psd_ipsi_non_t',num2str(j),'_p',num2str(k),'_time_mean_find=psd_ipsi_non_t',...
                num2str(j),'_p',num2str(k),'_time_mean_all(:,sbj_non_i)';])
            clear *all
        end
    end
end

for i=1:4
    for j=1:3
        for k=1:size(sbjs_non,1)
            eval(['mean_mean_sum_',freq_band,'_t',num2str(i),'_p',num2str(j),'_non_ipsi(',num2str(k),')=mean_mean_',freq_band,'_sbj',num2str(sbjs_non(k,:)),...
                '_ch',num2str(elec_non_ipsi(k)),'_t',num2str(i),'_p',num2str(j)])
        end
    end
end

for i=1:4
    for j=1:3
        eval(['mean_mean_mean_sum_',freq_band,'_t',num2str(i),'_p',num2str(j),'_non_ipsi=mean(mean_mean_sum_',freq_band,'_t',num2str(i),'_p',num2str(j),'_non_ipsi)'])
        eval(['se_mean_mean_sum_',freq_band,'_t',num2str(i),'_p',num2str(j),'_non_ipsi=std(mean_mean_sum_',freq_band,'_t',num2str(i),'_p',num2str(j),...
            '_non_ipsi)/sqrt(size(mean_mean_sum_',freq_band,'_t',num2str(i),'_p',num2str(j),'_non_ipsi,2))'])
    end
end

figure; set(gcf,'Position',[3 47 744 898]); hold on
count=0
for j=1:3
    for i=1:4
        count=count+1
        if j==1
            subplot(8,5,i); hold on
            sp=i;
        elseif j==2
            subplot(8,5,i+5); hold on
            sp=i+5;
        elseif j==3
            subplot(8,5,i+10); hold on
            sp=i+10;
        end
         
        for k=1:size(sbjs_non,1)
            eval(['plot(psd_ipsi_non_t',num2str(i),'_p',num2str(j),'_time_mean_find,''LineWidth'',2)'])
        end
        
        if sp<10
            eval(['ylim_0',num2str(sp),'=get(gca,''ylim'')'])
        elseif sp>=10
            eval(['ylim_',num2str(sp),'=get(gca,''ylim'')'])
        end
           
        if count==1
            ylabel('atStartPosition')
            %title([grp,' all:ipsi non:t1:',labl])
            title([grp,' all:ipsi non:t1:',freq_band,':',labl,':ver ',version])
        elseif count==2
            title('t2')
        elseif count==3
            title('t3')
        elseif count==4
            title('t4')
        elseif count==5
            ylabel('cueEvent')
        elseif count==9
            ylabel('targetUp')
        elseif count==12
            l1=legend;
        end
    end
end
min_ylim=min([ylim_01(1) ylim_02(1) ylim_03(1) ylim_04(1) ylim_06(1) ylim_07(1) ylim_08(1) ylim_09(1) ylim_11(1) ylim_12(1) ylim_13(1) ylim_14(1)])
max_ylim=max([ylim_01(2) ylim_02(2) ylim_03(2) ylim_04(2) ylim_06(2) ylim_07(2) ylim_08(2) ylim_09(2) ylim_11(2) ylim_12(2) ylim_13(2) ylim_14(2)])
for i=[1 2 3 4 6 7 8 9 11 12 13 14]
    subplot(8,5,i)
    set(gca,'ylim',[min_ylim max_ylim])
    plot([frq_rng_st frq_rng_st],[min_ylim max_ylim],'r')
    plot([frq_rng_ed frq_rng_ed],[min_ylim max_ylim],'r')
end
set(l1,'String',l1_non_str,'Position',[0.7837 0.5323 0.1051 0.0797])

subplot(8,5,5); hold on
eval(['bar([mean_mean_mean_sum_',freq_band,'_t1_p1_non_ipsi mean_mean_mean_sum_',freq_band,'_t2_p1_non_ipsi mean_mean_mean_sum_',freq_band,'_t3_p1_non_ipsi mean_mean_mean_sum_',freq_band,'_t4_p1_non_ipsi])'])
eval(['errorbar([mean_mean_mean_sum_',freq_band,'_t1_p1_non_ipsi mean_mean_mean_sum_',freq_band,'_t2_p1_non_ipsi mean_mean_mean_sum_',freq_band,'_t3_p1_non_ipsi mean_mean_mean_sum_',freq_band,'_t4_p1_non_ipsi],'...
    '[se_mean_mean_sum_',freq_band,'_t1_p1_non_ipsi se_mean_mean_sum_',freq_band,'_t2_p1_non_ipsi se_mean_mean_sum_',freq_band,'_t3_p1_non_ipsi se_mean_mean_sum_',freq_band,'_t4_p1_non_ipsi],''.k'')'])
set(gca,'XTick',[1:4],'XTickLabel',['t1';'t2';'t3';'t4'])
eval(['[p_mean_mean_sum_',freq_band,'_p1,anovatab_mean_mean_sum_',freq_band,'_p1,stats_mean_mean_sum_',freq_band,'_p1]='...
    'kruskalwallis([mean_mean_sum_',freq_band,'_t1_p1_non_ipsi'',mean_mean_sum_',freq_band,'_t2_p1_non_ipsi'',mean_mean_sum_',freq_band,'_t3_p1_non_ipsi'',mean_mean_sum_',freq_band,'_t4_p1_non_ipsi''],[],''off'')'])
if eval(['p_mean_mean_sum_',freq_band,'_p1<=0.05'])
    eval(['title(num2str(p_mean_mean_sum_',freq_band,'_p1),''Color'',[1 0 0])'])
else
    eval(['title(num2str(p_mean_mean_sum_',freq_band,'_p1))'])
end
eval(['nr_multcompare_ind_tdcs_plot(stats_mean_mean_sum_',freq_band,'_p1,min_ylim)'])

subplot(8,5,10); hold on
eval(['bar([mean_mean_mean_sum_',freq_band,'_t1_p2_non_ipsi mean_mean_mean_sum_',freq_band,'_t2_p2_non_ipsi mean_mean_mean_sum_',freq_band,'_t3_p2_non_ipsi mean_mean_mean_sum_',freq_band,'_t4_p2_non_ipsi])'])
eval(['errorbar([mean_mean_mean_sum_',freq_band,'_t1_p2_non_ipsi mean_mean_mean_sum_',freq_band,'_t2_p2_non_ipsi mean_mean_mean_sum_',freq_band,'_t3_p2_non_ipsi mean_mean_mean_sum_',freq_band,'_t4_p2_non_ipsi],'...
    '[se_mean_mean_sum_',freq_band,'_t1_p2_non_ipsi se_mean_mean_sum_',freq_band,'_t2_p2_non_ipsi se_mean_mean_sum_',freq_band,'_t3_p2_non_ipsi se_mean_mean_sum_',freq_band,'_t4_p2_non_ipsi],''.k'')'])
set(gca,'XTick',[1:4],'XTickLabel',['t1';'t2';'t3';'t4'])
eval(['[p_mean_mean_sum_',freq_band,'_p2,anovatab_mean_mean_sum_',freq_band,'_p2,stats_mean_mean_sum_',freq_band,'_p2]='...
    'kruskalwallis([mean_mean_sum_',freq_band,'_t1_p2_non_ipsi'',mean_mean_sum_',freq_band,'_t2_p2_non_ipsi'',mean_mean_sum_',freq_band,'_t3_p2_non_ipsi'',mean_mean_sum_',freq_band,'_t4_p2_non_ipsi''],[],''off'')'])
if eval(['p_mean_mean_sum_',freq_band,'_p2<=0.05'])
    eval(['title(num2str(p_mean_mean_sum_',freq_band,'_p2),''Color'',[1 0 0])'])
else
    eval(['title(num2str(p_mean_mean_sum_',freq_band,'_p2))'])
end
eval(['nr_multcompare_ind_tdcs_plot(stats_mean_mean_sum_',freq_band,'_p2,min_ylim)'])

subplot(8,5,15); hold on
eval(['bar([mean_mean_mean_sum_',freq_band,'_t1_p3_non_ipsi mean_mean_mean_sum_',freq_band,'_t2_p3_non_ipsi mean_mean_mean_sum_',freq_band,'_t3_p3_non_ipsi mean_mean_mean_sum_',freq_band,'_t4_p3_non_ipsi])'])
eval(['errorbar([mean_mean_mean_sum_',freq_band,'_t1_p3_non_ipsi mean_mean_mean_sum_',freq_band,'_t2_p3_non_ipsi mean_mean_mean_sum_',freq_band,'_t3_p3_non_ipsi mean_mean_mean_sum_',freq_band,'_t4_p3_non_ipsi],'...
    '[se_mean_mean_sum_',freq_band,'_t1_p3_non_ipsi se_mean_mean_sum_',freq_band,'_t2_p3_non_ipsi se_mean_mean_sum_',freq_band,'_t3_p3_non_ipsi se_mean_mean_sum_',freq_band,'_t4_p3_non_ipsi],''.k'')'])
set(gca,'XTick',[1:4],'XTickLabel',['t1';'t2';'t3';'t4'])
eval(['[p_mean_mean_sum_',freq_band,'_p3,anovatab_mean_mean_sum_',freq_band,'_p3,stats_mean_mean_sum_',freq_band,'_p3]='...
    'kruskalwallis([mean_mean_sum_',freq_band,'_t1_p3_non_ipsi'',mean_mean_sum_',freq_band,'_t2_p3_non_ipsi'',mean_mean_sum_',freq_band,'_t3_p3_non_ipsi'',mean_mean_sum_',freq_band,'_t4_p3_non_ipsi''],[],''off'')'])
if eval(['p_mean_mean_sum_',freq_band,'_p3<=0.05'])
    eval(['title(num2str(p_mean_mean_sum_',freq_band,'_p3),''Color'',[1 0 0])'])
else
    eval(['title(num2str(p_mean_mean_sum_',freq_band,'_p3))'])
end
eval(['nr_multcompare_ind_tdcs_plot(stats_mean_mean_sum_',freq_band,'_p3,min_ylim)'])

subplot(8,5,16); hold on
eval(['bar([mean_mean_mean_sum_',freq_band,'_t1_p1_non_ipsi mean_mean_mean_sum_',freq_band,'_t1_p2_non_ipsi mean_mean_mean_sum_',freq_band,'_t1_p3_non_ipsi])'])
eval(['errorbar([mean_mean_mean_sum_',freq_band,'_t1_p1_non_ipsi mean_mean_mean_sum_',freq_band,'_t1_p2_non_ipsi mean_mean_mean_sum_',freq_band,'_t1_p3_non_ipsi],'...
    '[se_mean_mean_sum_',freq_band,'_t1_p1_non_ipsi se_mean_mean_sum_',freq_band,'_t1_p2_non_ipsi se_mean_mean_sum_',freq_band,'_t1_p3_non_ipsi],''.k'')'])
set(gca,'XTick',[1:3],'XTickLabel',['h';'p';'m'])
eval(['[p_mean_mean_sum_',freq_band,'_t1,anovatab_mean_mean_sum_',freq_band,'_t1,stats_mean_mean_sum_',freq_band,'_t1]='...
    'kruskalwallis([mean_mean_sum_',freq_band,'_t1_p1_non_ipsi'',mean_mean_sum_',freq_band,'_t1_p2_non_ipsi'',mean_mean_sum_',freq_band,'_t1_p3_non_ipsi''],[],''off'')'])
if eval(['p_mean_mean_sum_',freq_band,'_t1<=0.05'])
    eval(['title(num2str(p_mean_mean_sum_',freq_band,'_t1),''Color'',[1 0 0])'])
else
    eval(['title(num2str(p_mean_mean_sum_',freq_band,'_t1))'])
end
eval(['nr_multcompare_ind_tdcs_plot(stats_mean_mean_sum_',freq_band,'_t1,0)'])

subplot(8,5,17); hold on
eval(['bar([mean_mean_mean_sum_',freq_band,'_t2_p1_non_ipsi mean_mean_mean_sum_',freq_band,'_t2_p2_non_ipsi mean_mean_mean_sum_',freq_band,'_t2_p3_non_ipsi])'])
eval(['errorbar([mean_mean_mean_sum_',freq_band,'_t2_p1_non_ipsi mean_mean_mean_sum_',freq_band,'_t2_p2_non_ipsi mean_mean_mean_sum_',freq_band,'_t2_p3_non_ipsi],'...
    '[se_mean_mean_sum_',freq_band,'_t2_p1_non_ipsi se_mean_mean_sum_',freq_band,'_t2_p2_non_ipsi se_mean_mean_sum_',freq_band,'_t2_p3_non_ipsi],''.k'')'])
set(gca,'XTick',[1:3],'XTickLabel',['h';'p';'m'])
eval(['[p_mean_mean_sum_',freq_band,'_t2,anovatab_mean_mean_sum_',freq_band,'_t2,stats_mean_mean_sum_',freq_band,'_t2]='...
    'kruskalwallis([mean_mean_sum_',freq_band,'_t2_p1_non_ipsi'',mean_mean_sum_',freq_band,'_t2_p2_non_ipsi'',mean_mean_sum_',freq_band,'_t2_p3_non_ipsi''],[],''off'')'])
if eval(['p_mean_mean_sum_',freq_band,'_t2<=0.05'])
    eval(['title(num2str(p_mean_mean_sum_',freq_band,'_t2),''Color'',[1 0 0])'])
else
    eval(['title(num2str(p_mean_mean_sum_',freq_band,'_t2))'])
end
eval(['nr_multcompare_ind_tdcs_plot(stats_mean_mean_sum_',freq_band,'_t2,0)'])

subplot(8,5,18); hold on
eval(['bar([mean_mean_mean_sum_',freq_band,'_t3_p1_non_ipsi mean_mean_mean_sum_',freq_band,'_t3_p2_non_ipsi mean_mean_mean_sum_',freq_band,'_t3_p3_non_ipsi])'])
eval(['errorbar([mean_mean_mean_sum_',freq_band,'_t3_p1_non_ipsi mean_mean_mean_sum_',freq_band,'_t3_p2_non_ipsi mean_mean_mean_sum_',freq_band,'_t3_p3_non_ipsi],'...
    '[se_mean_mean_sum_',freq_band,'_t3_p1_non_ipsi se_mean_mean_sum_',freq_band,'_t3_p2_non_ipsi se_mean_mean_sum_',freq_band,'_t3_p3_non_ipsi],''.k'')'])
set(gca,'XTick',[1:3],'XTickLabel',['h';'p';'m'])
eval(['[p_mean_mean_sum_',freq_band,'_t3,anovatab_mean_mean_sum_',freq_band,'_t3,stats_mean_mean_sum_',freq_band,'_t3]='...
    'kruskalwallis([mean_mean_sum_',freq_band,'_t3_p1_non_ipsi'',mean_mean_sum_',freq_band,'_t3_p2_non_ipsi'',mean_mean_sum_',freq_band,'_t3_p3_non_ipsi''],[],''off'')'])
if eval(['p_mean_mean_sum_',freq_band,'_t3<=0.05'])
    eval(['title(num2str(p_mean_mean_sum_',freq_band,'_t3),''Color'',[1 0 0])'])
else
    eval(['title(num2str(p_mean_mean_sum_',freq_band,'_t3))'])
end
eval(['nr_multcompare_ind_tdcs_plot(stats_mean_mean_sum_',freq_band,'_t3,0)'])

subplot(8,5,19); hold on
eval(['bar([mean_mean_mean_sum_',freq_band,'_t4_p1_non_ipsi mean_mean_mean_sum_',freq_band,'_t4_p2_non_ipsi mean_mean_mean_sum_',freq_band,'_t4_p3_non_ipsi])'])
eval(['errorbar([mean_mean_mean_sum_',freq_band,'_t4_p1_non_ipsi mean_mean_mean_sum_',freq_band,'_t4_p2_non_ipsi mean_mean_mean_sum_',freq_band,'_t4_p3_non_ipsi],'...
    '[se_mean_mean_sum_',freq_band,'_t4_p1_non_ipsi se_mean_mean_sum_',freq_band,'_t4_p2_non_ipsi se_mean_mean_sum_',freq_band,'_t4_p3_non_ipsi],''.k'')'])
set(gca,'XTick',[1:3],'XTickLabel',['h';'p';'m'])
eval(['[p_mean_mean_sum_',freq_band,'_t4,anovatab_mean_mean_sum_',freq_band,'_t4,stats_mean_mean_sum_',freq_band,'_t4]='...
    'kruskalwallis([mean_mean_sum_',freq_band,'_t4_p1_non_ipsi'',mean_mean_sum_',freq_band,'_t4_p2_non_ipsi'',mean_mean_sum_',freq_band,'_t4_p3_non_ipsi''],[],''off'')'])
if eval(['p_mean_mean_sum_',freq_band,'_t4<=0.05'])
    eval(['title(num2str(p_mean_mean_sum_',freq_band,'_t4),''Color'',[1 0 0])'])
else
    eval(['title(num2str(p_mean_mean_sum_',freq_band,'_t4))'])
end
eval(['nr_multcompare_ind_tdcs_plot(stats_mean_mean_sum_',freq_band,'_t4,0)'])

clear anovatab* p_mean* stats* 
%clear *ipsi

%non cont
count=0;
for i=elec_non_cont
    count=count+1
    for j=1:4
        for k=1:3
            for h=sbj_non_i
                psd_time_all=subjectData(h).power.data(1:50,:,i,k,j);
                psd_time_mean=mean(psd_time_all,2);
                eval(['psd_cont_non_t',num2str(j),'_p',num2str(k),'_time_mean_all(:,h)=psd_time_mean;'])
            end
            eval(['psd_cont_non_t',num2str(j),'_p',num2str(k),'_time_mean_find=psd_cont_non_t',...
                num2str(j),'_p',num2str(k),'_time_mean_all(:,sbj_non_i);'])
            clear *all
        end
    end
end

for i=1:4
    for j=1:3
        for k=1:size(sbjs_non,1)
            eval(['mean_mean_sum_',freq_band,'_t',num2str(i),'_p',num2str(j),'_non_cont(',num2str(k),')=mean_mean_',freq_band,'_sbj',num2str(sbjs_non(k,:)),...
                '_ch',num2str(elec_non_cont(k)),'_t',num2str(i),'_p',num2str(j)])
        end
    end
end

for i=1:4
    for j=1:3
        eval(['mean_mean_mean_sum_',freq_band,'_t',num2str(i),'_p',num2str(j),'_non_cont=mean(mean_mean_sum_',freq_band,'_t',num2str(i),'_p',num2str(j),'_non_cont)'])
        eval(['se_mean_mean_sum_',freq_band,'_t',num2str(i),'_p',num2str(j),'_non_cont=std(mean_mean_sum_',freq_band,'_t',num2str(i),'_p',num2str(j),...
            '_non_cont)/sqrt(size(mean_mean_sum_',freq_band,'_t',num2str(i),'_p',num2str(j),'_non_cont,2))'])
    end
end


count=20
for j=1:3
    for i=1:4
        count=count+1
        if j==1
            subplot(8,5,i+20); hold on
            sp=i+20;
        elseif j==2
            subplot(8,5,i+25); hold on
            sp=i+25;
        elseif j==3
            subplot(8,5,i+30); hold on
            sp=i+30;
        end
         
        for k=1:size(sbjs_non,1)
            eval(['plot(psd_cont_non_t',num2str(i),'_p',num2str(j),'_time_mean_find,''LineWidth'',2)'])
        end
        
        eval(['ylim_',num2str(sp),'=get(gca,''ylim'')'])
           
        if count==21
            ylabel('atStartPosition')
            title('cont non:t1')
        elseif count==22
            title('t2')
        elseif count==23
            title('t3')
        elseif count==24
            title('t4')
        elseif count==25
            ylabel('cueEvent')
        elseif count==29
            ylabel('targetUp')
        elseif count==32
            l2=legend
        end
    end
end
min_ylim=min([ylim_21(1) ylim_22(1) ylim_23(1) ylim_24(1) ylim_26(1) ylim_27(1) ylim_28(1) ylim_29(1) ylim_31(1) ylim_32(1) ylim_33(1) ylim_34(1)])
max_ylim=max([ylim_21(2) ylim_22(2) ylim_23(2) ylim_24(2) ylim_26(2) ylim_27(2) ylim_28(2) ylim_29(2) ylim_31(2) ylim_32(2) ylim_33(2) ylim_34(2)])
for i=[21 22 23 24 26 27 28 29 31 32 33 34]
    subplot(8,5,i)
    set(gca,'ylim',[min_ylim max_ylim])
    plot([frq_rng_st frq_rng_st],[min_ylim max_ylim],'r')
    plot([frq_rng_ed frq_rng_ed],[min_ylim max_ylim],'r')
end
set(l2,'String',l1_non_str,'Position',[0.7837 0.1033 0.1051 0.0803])

subplot(8,5,25); hold on
eval(['bar([mean_mean_mean_sum_',freq_band,'_t1_p1_non_cont mean_mean_mean_sum_',freq_band,'_t2_p1_non_cont mean_mean_mean_sum_',freq_band,'_t3_p1_non_cont mean_mean_mean_sum_',freq_band,'_t4_p1_non_cont])'])
eval(['errorbar([mean_mean_mean_sum_',freq_band,'_t1_p1_non_cont mean_mean_mean_sum_',freq_band,'_t2_p1_non_cont mean_mean_mean_sum_',freq_band,'_t3_p1_non_cont mean_mean_mean_sum_',freq_band,'_t4_p1_non_cont],'...
    '[se_mean_mean_sum_',freq_band,'_t1_p1_non_cont se_mean_mean_sum_',freq_band,'_t2_p1_non_cont se_mean_mean_sum_',freq_band,'_t3_p1_non_cont se_mean_mean_sum_',freq_band,'_t4_p1_non_cont],''.k'')'])
set(gca,'XTick',[1:4],'XTickLabel',['t1';'t2';'t3';'t4'])
eval(['[p_mean_mean_sum_',freq_band,'_p1,anovatab_mean_mean_sum_',freq_band,'_p1,stats_mean_mean_sum_',freq_band,'_p1]='...
    'kruskalwallis([mean_mean_sum_',freq_band,'_t1_p1_non_cont'',mean_mean_sum_',freq_band,'_t2_p1_non_cont'',mean_mean_sum_',freq_band,'_t3_p1_non_cont'',mean_mean_sum_',freq_band,'_t4_p1_non_cont''],[],''off'')'])
if eval(['p_mean_mean_sum_',freq_band,'_p1<=0.05'])
    eval(['title(num2str(p_mean_mean_sum_',freq_band,'_p1),''Color'',[1 0 0])'])
else
    eval(['title(num2str(p_mean_mean_sum_',freq_band,'_p1))'])
end
eval(['nr_multcompare_ind_tdcs_plot(stats_mean_mean_sum_',freq_band,'_p1,min_ylim)'])

subplot(8,5,30); hold on
eval(['bar([mean_mean_mean_sum_',freq_band,'_t1_p2_non_cont mean_mean_mean_sum_',freq_band,'_t2_p2_non_cont mean_mean_mean_sum_',freq_band,'_t3_p2_non_cont mean_mean_mean_sum_',freq_band,'_t4_p2_non_cont])'])
eval(['errorbar([mean_mean_mean_sum_',freq_band,'_t1_p2_non_cont mean_mean_mean_sum_',freq_band,'_t2_p2_non_cont mean_mean_mean_sum_',freq_band,'_t3_p2_non_cont mean_mean_mean_sum_',freq_band,'_t4_p2_non_cont],'...
    '[se_mean_mean_sum_',freq_band,'_t1_p2_non_cont se_mean_mean_sum_',freq_band,'_t2_p2_non_cont se_mean_mean_sum_',freq_band,'_t3_p2_non_cont se_mean_mean_sum_',freq_band,'_t4_p2_non_cont],''.k'')'])
set(gca,'XTick',[1:4],'XTickLabel',['t1';'t2';'t3';'t4'])
eval(['[p_mean_mean_sum_',freq_band,'_p2,anovatab_mean_mean_sum_',freq_band,'_p2,stats_mean_mean_sum_',freq_band,'_p2]='...
    'kruskalwallis([mean_mean_sum_',freq_band,'_t1_p2_non_cont'',mean_mean_sum_',freq_band,'_t2_p2_non_cont'',mean_mean_sum_',freq_band,'_t3_p2_non_cont'',mean_mean_sum_',freq_band,'_t4_p2_non_cont''],[],''off'')'])
if eval(['p_mean_mean_sum_',freq_band,'_p2<=0.05'])
    eval(['title(num2str(p_mean_mean_sum_',freq_band,'_p2),''Color'',[1 0 0])'])
else
    eval(['title(num2str(p_mean_mean_sum_',freq_band,'_p2))'])
end
eval(['nr_multcompare_ind_tdcs_plot(stats_mean_mean_sum_',freq_band,'_p2,min_ylim)'])

subplot(8,5,35); hold on
eval(['bar([mean_mean_mean_sum_',freq_band,'_t1_p3_non_cont mean_mean_mean_sum_',freq_band,'_t2_p3_non_cont mean_mean_mean_sum_',freq_band,'_t3_p3_non_cont mean_mean_mean_sum_',freq_band,'_t4_p3_non_cont])'])
eval(['errorbar([mean_mean_mean_sum_',freq_band,'_t1_p3_non_cont mean_mean_mean_sum_',freq_band,'_t2_p3_non_cont mean_mean_mean_sum_',freq_band,'_t3_p3_non_cont mean_mean_mean_sum_',freq_band,'_t4_p3_non_cont],'...
    '[se_mean_mean_sum_',freq_band,'_t1_p3_non_cont se_mean_mean_sum_',freq_band,'_t2_p3_non_cont se_mean_mean_sum_',freq_band,'_t3_p3_non_cont se_mean_mean_sum_',freq_band,'_t4_p3_non_cont],''.k'')'])
set(gca,'XTick',[1:4],'XTickLabel',['t1';'t2';'t3';'t4'])
eval(['[p_mean_mean_sum_',freq_band,'_p3,anovatab_mean_mean_sum_',freq_band,'_p3,stats_mean_mean_sum_',freq_band,'_p3]='...
    'kruskalwallis([mean_mean_sum_',freq_band,'_t1_p3_non_cont'',mean_mean_sum_',freq_band,'_t2_p3_non_cont'',mean_mean_sum_',freq_band,'_t3_p3_non_cont'',mean_mean_sum_',freq_band,'_t4_p3_non_cont''],[],''off'')'])
if eval(['p_mean_mean_sum_',freq_band,'_p3<=0.05'])
    eval(['title(num2str(p_mean_mean_sum_',freq_band,'_p3),''Color'',[1 0 0])'])
else
    eval(['title(num2str(p_mean_mean_sum_',freq_band,'_p3))'])
end
eval(['nr_multcompare_ind_tdcs_plot(stats_mean_mean_sum_',freq_band,'_p3,min_ylim)'])

subplot(8,5,36); hold on
eval(['bar([mean_mean_mean_sum_',freq_band,'_t1_p1_non_cont mean_mean_mean_sum_',freq_band,'_t1_p2_non_cont mean_mean_mean_sum_',freq_band,'_t1_p3_non_cont])'])
eval(['errorbar([mean_mean_mean_sum_',freq_band,'_t1_p1_non_cont mean_mean_mean_sum_',freq_band,'_t1_p2_non_cont mean_mean_mean_sum_',freq_band,'_t1_p3_non_cont],'...
    '[se_mean_mean_sum_',freq_band,'_t1_p1_non_cont se_mean_mean_sum_',freq_band,'_t1_p2_non_cont se_mean_mean_sum_',freq_band,'_t1_p3_non_cont],''.k'')'])
set(gca,'XTick',[1:3],'XTickLabel',['h';'p';'m'])
eval(['[p_mean_mean_sum_',freq_band,'_t1,anovatab_mean_mean_sum_',freq_band,'_t1,stats_mean_mean_sum_',freq_band,'_t1]='...
    'kruskalwallis([mean_mean_sum_',freq_band,'_t1_p1_non_cont'',mean_mean_sum_',freq_band,'_t1_p2_non_cont'',mean_mean_sum_',freq_band,'_t1_p3_non_cont''],[],''off'')'])
if eval(['p_mean_mean_sum_',freq_band,'_t1<=0.05'])
    eval(['title(num2str(p_mean_mean_sum_',freq_band,'_t1),''Color'',[1 0 0])'])
else
    eval(['title(num2str(p_mean_mean_sum_',freq_band,'_t1))'])
end
eval(['nr_multcompare_ind_tdcs_plot(stats_mean_mean_sum_',freq_band,'_t1,0)'])

subplot(8,5,37); hold on
eval(['bar([mean_mean_mean_sum_',freq_band,'_t2_p1_non_cont mean_mean_mean_sum_',freq_band,'_t2_p2_non_cont mean_mean_mean_sum_',freq_band,'_t2_p3_non_cont])'])
eval(['errorbar([mean_mean_mean_sum_',freq_band,'_t2_p1_non_cont mean_mean_mean_sum_',freq_band,'_t2_p2_non_cont mean_mean_mean_sum_',freq_band,'_t2_p3_non_cont],'...
    '[se_mean_mean_sum_',freq_band,'_t2_p1_non_cont se_mean_mean_sum_',freq_band,'_t2_p2_non_cont se_mean_mean_sum_',freq_band,'_t2_p3_non_cont],''.k'')'])
set(gca,'XTick',[1:3],'XTickLabel',['h';'p';'m'])
eval(['[p_mean_mean_sum_',freq_band,'_t2,anovatab_mean_mean_sum_',freq_band,'_t2,stats_mean_mean_sum_',freq_band,'_t2]='...
    'kruskalwallis([mean_mean_sum_',freq_band,'_t2_p1_non_cont'',mean_mean_sum_',freq_band,'_t2_p2_non_cont'',mean_mean_sum_',freq_band,'_t2_p3_non_cont''],[],''off'')'])
if eval(['p_mean_mean_sum_',freq_band,'_t2<=0.05'])
    eval(['title(num2str(p_mean_mean_sum_',freq_band,'_t2),''Color'',[1 0 0])'])
else
    eval(['title(num2str(p_mean_mean_sum_',freq_band,'_t2))'])
end
eval(['nr_multcompare_ind_tdcs_plot(stats_mean_mean_sum_',freq_band,'_t2,0)'])

subplot(8,5,38); hold on
eval(['bar([mean_mean_mean_sum_',freq_band,'_t3_p1_non_cont mean_mean_mean_sum_',freq_band,'_t3_p2_non_cont mean_mean_mean_sum_',freq_band,'_t3_p3_non_cont])'])
eval(['errorbar([mean_mean_mean_sum_',freq_band,'_t3_p1_non_cont mean_mean_mean_sum_',freq_band,'_t3_p2_non_cont mean_mean_mean_sum_',freq_band,'_t3_p3_non_cont],'...
    '[se_mean_mean_sum_',freq_band,'_t3_p1_non_cont se_mean_mean_sum_',freq_band,'_t3_p2_non_cont se_mean_mean_sum_',freq_band,'_t3_p3_non_cont],''.k'')'])
set(gca,'XTick',[1:3],'XTickLabel',['h';'p';'m'])
eval(['[p_mean_mean_sum_',freq_band,'_t3,anovatab_mean_mean_sum_',freq_band,'_t3,stats_mean_mean_sum_',freq_band,'_t3]='...
    'kruskalwallis([mean_mean_sum_',freq_band,'_t3_p1_non_cont'',mean_mean_sum_',freq_band,'_t3_p2_non_cont'',mean_mean_sum_',freq_band,'_t3_p3_non_cont''],[],''off'')'])
if eval(['p_mean_mean_sum_',freq_band,'_t3<=0.05'])
    eval(['title(num2str(p_mean_mean_sum_',freq_band,'_t3),''Color'',[1 0 0])'])
else
    eval(['title(num2str(p_mean_mean_sum_',freq_band,'_t3))'])
end
eval(['nr_multcompare_ind_tdcs_plot(stats_mean_mean_sum_',freq_band,'_t3,0)'])

subplot(8,5,39); hold on
eval(['bar([mean_mean_mean_sum_',freq_band,'_t4_p1_non_cont mean_mean_mean_sum_',freq_band,'_t4_p2_non_cont mean_mean_mean_sum_',freq_band,'_t4_p3_non_cont])'])
eval(['errorbar([mean_mean_mean_sum_',freq_band,'_t4_p1_non_cont mean_mean_mean_sum_',freq_band,'_t4_p2_non_cont mean_mean_mean_sum_',freq_band,'_t4_p3_non_cont],'...
    '[se_mean_mean_sum_',freq_band,'_t4_p1_non_cont se_mean_mean_sum_',freq_band,'_t4_p2_non_cont se_mean_mean_sum_',freq_band,'_t4_p3_non_cont],''.k'')'])
set(gca,'XTick',[1:3],'XTickLabel',['h';'p';'m'])
eval(['[p_mean_mean_sum_',freq_band,'_t4,anovatab_mean_mean_sum_',freq_band,'_t4,stats_mean_mean_sum_',freq_band,'_t4]='...
    'kruskalwallis([mean_mean_sum_',freq_band,'_t4_p1_non_cont'',mean_mean_sum_',freq_band,'_t4_p2_non_cont'',mean_mean_sum_',freq_band,'_t4_p3_non_cont''],[],''off'')'])
if eval(['p_mean_mean_sum_',freq_band,'_t4<=0.05'])
    eval(['title(num2str(p_mean_mean_sum_',freq_band,'_t4),''Color'',[1 0 0])'])
else
    eval(['title(num2str(p_mean_mean_sum_',freq_band,'_t4))'])
end
eval(['nr_multcompare_ind_tdcs_plot(stats_mean_mean_sum_',freq_band,'_t4,0)'])

clear anovatab* p_mean* stats* 
%clear anovatab* find* mean_mean_mean_* mean_mean_beta* p* psd* se* stats* ylim*

if strcmp(save_figs,'yes')
    saveas(gcf,['~/nr_data_analysis/data_analyzed/eeg/gen_03/analysis_pow/',date_str,'/gen_03_ver_',version,'_',labl,'_sum_',freq_band,'_',grp,'_non.fig'],'fig')
end

if strcmp(save_data,'yes')
        save(['~/nr_data_analysis/data_analyzed/eeg/gen_03/analysis_pow/',date_str,'/gen_03_ver_',version,'_',labl,'_mean_mean_',freq_band,'_sum_',grp] ,['mean_mean_sum_',freq_band,'*']) 
end

