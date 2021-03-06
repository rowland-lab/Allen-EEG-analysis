clc
close all
clear all

% Enter in protocol folder
protocolfolder='/home/rowlandn/nr_data_analysis/data_analyzed/eeg/gen_03/data';
%protocolfolder='C:\Users\allen\Box Sync\Desktop\Allen_Rowland_EEG\protocol_00087153';

% Detect subjects
sbj=dir(fullfile(protocolfolder,'pro000*'));
sbj={sbj.name}';

% Gitpath
gitpath='/home/rowlandn/nr_data_analysis/data_scripts/ac/Allen-EEG-analysis';
%gitpath='C:\Users\allen\Documents\GitHub\Allen-EEG-analysis';
cd(gitpath)
allengit_genpaths(gitpath,'EEG')
%

%% Import data

calc_icoh=true;
calc_kin=true;
calc_labpower=true;

subjectData=[];
parfor s=1:21%:numel(sbj)
    % Analysis folder
    anfold=fullfile(protocolfolder,sbj{s},'analysis');
    
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


%% Analysis - column scatter? still not sure if this is ideal way to show this

TOI={'pre-stim (baseline)','intrastim (5 min)','intrastim (15 min)','post-stim (5 min)'};
FOI_label={'Alpha','Beta','Gamma'};%can add more if you want
FOI_freq={{8,12},{13,30},{30,50}};
phases={'Hold','Prep','Reach'};
DOI={'stroke','healthy'};
stimtypes=[0,2];
stimname={'Sham','Stim'};
%analysisFolder='C:\Users\allen\Box Sync\Desktop\Allen_Rowland_EEG\protocol_00087153\Analysis';
analysisfolder='/home/rowlandn/nr_data_analysis/data_analyzed/eeg/gen_03/Analysis';
% columnscatter(subjectData,datlabel,TOI,FOI_label,FOI_freq,phases,DOI,stimtypes,stimname,savefolder)
iCohFolder=fullfile(analysisfolder,'iCohcolscat');
mkdir(iCohFolder);
exportData=columnscatter(subjectData,'iCoh',TOI,FOI_label,FOI_freq,phases,DOI,stimtypes,stimname,iCohFolder);
%data_grp_icoh=exportData;
c=clock;
y=sprintf('%0.5g',[c(1)]);
m=sprintf('%0.5g',[c(2)]);
d=sprintf('%0.5g',[c(3)]);
if str2num(m)<10
    m=['0',m];
end
if str2num(d)<10
    d=['0',d];
end
date=[y,'_',m,'_',d];
%icohcolscatfilenm=['data_grp_icoh_colscat_',date]
eval([['data_grp_icoh_colscat_',date],'=exportData']);
%eval([eval(icohcolscatfilenm),'=exportData']);
save([iCohFolder,'/',['data_grp_icoh_colscat_',date]],['data_grp_icoh_colscat_',date])

%%
% linreg(subjectData,datlabel,TOI,FOI_label,FOI_freq,phases,DOI,stimtypes,stimname,savefolder)
linReg_folder=fullfile(analysisfolder,'iCohlinReg');
mkdir(linReg_folder);
linreg_dat=linreg(subjectData,{'iCoh','IOC'},TOI,FOI_label,FOI_freq,phases,DOI,stimtypes,stimname,linReg_folder);
% data_grp_icoh=exportData;
% c=clock;
% y=sprintf('%0.5g',[c(1)]);
% m=sprintf('%0.5g',[c(2)]);
% d=sprintf('%0.5g',[c(3)]);
% if str2num(m)<10
%     m=['0',m];
% end
% if str2num(d)<10
%     d=['0',d];
% end
% date=[y,'_',m,'_',d];
% 
% eval([['data_grp_icoh_linreg_',date],'=linreg_dat']);
% save([linReg_folder,'/',['data_grp_icoh_linreg_',date]],['data_grp_icoh_linreg_',date])

%  %hits
%  movement duration
%  reaction time
%  velocity peaks
%  avg acceleration


% {'movementDuration'}
% {'reactionTime'}
% {'handpathlength'}
% {'avgVelocity'}
% {'maxVelocity'}
% {'velocityPeaks'}
% {'timeToMaxVelocity'}
% {'timeToMaxVelocity_n'}
% {'avgAcceleration'}
% {'maxAcceleration'}
% {'accuracy'}
% {'normalizedJerk'}
% {'IOC'}


%%
linReg_folder=fullfile(analysisfolder,'iCohlinReg');
mkdir(linReg_folder);
linreg_dat=linreg2(subjectData,{'iCoh','IOC'},TOI,FOI_label,FOI_freq,phases,DOI,stimtypes,stimname,linReg_folder);

%not much here, just confirm that code is correct and move on


%% iCoh Bar 
TOI={'pre-stim (baseline)','intrastim (5 min)','intrastim (15 min)','post-stim (5 min)'};
FOI_label={'Alpha','Beta','Gamma'};
FOI_freq={{8,12},{13,30},{30,50}};
phases={'Hold','Prep','Reach'};
DOI={'stroke','healthy'};
stimtypes=[0,2];
stimname={'Sham','Stim'};

%analysisFolder='C:\Users\allen\Box Sync\Desktop\Allen_Rowland_EEG\protocol_00087153\Analysis';
analysisfolder='/home/rowlandn/nr_data_analysis/data_analyzed/eeg/gen_03/Analysis';
iCohbar_folder=fullfile(analysisfolder,'iCohbar');
mkdir(iCohbar_folder);
export=[];
for f=1:numel(FOI_label)
    figure
    ax_count=1;
    for ph=1:numel(phases)
        for d=1:numel(DOI)
            ax=subplot(numel(phases),numel(DOI),ax_count);
            ax_count=ax_count+1;
            hold on
            
            clear b n
            n=[];
            anovaInput=[];
            for s=1:numel(stimtypes)
                session_data={subjectData.sessioninfo};
                sbj_idx=cellfun(@(x) x.stimamp==stimtypes(s),session_data) & cellfun(@(x) strcmp(x.dx,DOI{d}),session_data);
                tempdata=subjectData(sbj_idx);
                
                tempcoh=[];
                for i=1:numel(tempdata)
                    freq_idx=tempdata(i).iCoh.freq>=FOI_freq{f}{1}&tempdata(i).iCoh.freq<=FOI_freq{f}{2};
                    electrode_idx=all(strcmp(tempdata(i).iCoh.label,'C3')+strcmp(tempdata(i).iCoh.label,'C4'),2);
                    trial_idx=cellfun(@(x) any(strcmp(x,TOI)),tempdata(i).sessioninfo.trialnames);
                    tempcoh(i,:)=permute(mean(mean(tempdata(i).iCoh.data(electrode_idx,freq_idx,:,ph,trial_idx),2,'omitnan'),3,'omitnan'),[5 4 3 2 1]);
                end
                bardat=mean(tempcoh,1);
                sem=std(tempcoh,1,'omitnan')./sqrt(sum(~isnan(tempcoh),1));

                if s==1
                    xdat=(1:size(bardat,2))-0.2;
                else
                    xdat=(1:size(bardat,2))+0.2;
                end
                errorbar(xdat,bardat,sem,'LineStyle','none')

                b(s)=bar(xdat,bardat,0.2);

                n(s)=size(tempcoh,1);

                anovaInput{s}=tempcoh;
            end
            
            title(sprintf('%s - %s',DOI{d},phases{ph}))
            xticks([1:4])
            xticklabels({'Pre','Intra-5','Intra-15','Post-5'});
            ylabel('Beta iCoh')
            ylim([0 1])
            mixANOVA(anovaInput,b);
            export.(FOI_label{f}).(DOI{d})(ph,:)=anovaInput;

            legend(b,{['Sham n=',num2str(n(1))],['Stim n=',num2str(n(2))]})
        end
    end
    sgtitle(FOI_label{f})
    figname=['iCoh Bar ',FOI_label{f}];
	saveas(gcf,fullfile(iCohbar_folder,[figname,'.jpeg']))
end

%reformat into barplot structure
data_grp_icoh_barmat.stroke.hold(:,1)=data_grp_icoh_colscat_2022_04_10_acdata.Beta.Hold.data{1}(:,1)
data_grp_icoh_barmat.stroke.hold(:,2)=data_grp_icoh_colscat_2022_04_10_acdata.Beta.Hold.data{1}(:,2)
data_grp_icoh_barmat.stroke.hold(:,3)=data_grp_icoh_colscat_2022_04_10_acdata.Beta.Hold.data{2}(:,1)
data_grp_icoh_barmat.stroke.hold(:,4)=data_grp_icoh_colscat_2022_04_10_acdata.Beta.Hold.data{2}(:,2)
data_grp_icoh_barmat.stroke.hold(:,5)=data_grp_icoh_colscat_2022_04_10_acdata.Beta.Hold.data{3}(:,1)
data_grp_icoh_barmat.stroke.hold(:,6)=data_grp_icoh_colscat_2022_04_10_acdata.Beta.Hold.data{3}(:,2)
data_grp_icoh_barmat.stroke.hold(:,7)=data_grp_icoh_colscat_2022_04_10_acdata.Beta.Hold.data{4}(:,1)
data_grp_icoh_barmat.stroke.hold(:,8)=data_grp_icoh_colscat_2022_04_10_acdata.Beta.Hold.data{4}(:,2)

data_grp_icoh_barmat.stroke.prep(:,1)=data_grp_icoh_colscat_2022_04_10_acdata.Beta.Prep.data{1}(:,1)
data_grp_icoh_barmat.stroke.prep(:,2)=data_grp_icoh_colscat_2022_04_10_acdata.Beta.Prep.data{1}(:,2)
data_grp_icoh_barmat.stroke.prep(:,3)=data_grp_icoh_colscat_2022_04_10_acdata.Beta.Prep.data{2}(:,1)
data_grp_icoh_barmat.stroke.prep(:,4)=data_grp_icoh_colscat_2022_04_10_acdata.Beta.Prep.data{2}(:,2)
data_grp_icoh_barmat.stroke.prep(:,5)=data_grp_icoh_colscat_2022_04_10_acdata.Beta.Prep.data{3}(:,1)
data_grp_icoh_barmat.stroke.prep(:,6)=data_grp_icoh_colscat_2022_04_10_acdata.Beta.Prep.data{3}(:,2)
data_grp_icoh_barmat.stroke.prep(:,7)=data_grp_icoh_colscat_2022_04_10_acdata.Beta.Prep.data{4}(:,1)
data_grp_icoh_barmat.stroke.prep(:,8)=data_grp_icoh_colscat_2022_04_10_acdata.Beta.Prep.data{4}(:,2)

data_grp_icoh_barmat.stroke.reach(:,1)=data_grp_icoh_colscat_2022_04_10_acdata.Beta.Reach.data{1}(:,1)
data_grp_icoh_barmat.stroke.reach(:,2)=data_grp_icoh_colscat_2022_04_10_acdata.Beta.Reach.data{1}(:,2)
data_grp_icoh_barmat.stroke.reach(:,3)=data_grp_icoh_colscat_2022_04_10_acdata.Beta.Reach.data{2}(:,1)
data_grp_icoh_barmat.stroke.reach(:,4)=data_grp_icoh_colscat_2022_04_10_acdata.Beta.Reach.data{2}(:,2)
data_grp_icoh_barmat.stroke.reach(:,5)=data_grp_icoh_colscat_2022_04_10_acdata.Beta.Reach.data{3}(:,1)
data_grp_icoh_barmat.stroke.reach(:,6)=data_grp_icoh_colscat_2022_04_10_acdata.Beta.Reach.data{3}(:,2)
data_grp_icoh_barmat.stroke.reach(:,7)=data_grp_icoh_colscat_2022_04_10_acdata.Beta.Reach.data{4}(:,1)
data_grp_icoh_barmat.stroke.reach(:,8)=data_grp_icoh_colscat_2022_04_10_acdata.Beta.Reach.data{4}(:,2)

data_grp_icoh_barmat.healthy.hold(:,1)=data_grp_icoh_colscat_2022_04_10_acdata.Beta.Hold.data{1}(:,3)
data_grp_icoh_barmat.healthy.hold(:,2)=data_grp_icoh_colscat_2022_04_10_acdata.Beta.Hold.data{1}(:,4)
data_grp_icoh_barmat.healthy.hold(:,3)=data_grp_icoh_colscat_2022_04_10_acdata.Beta.Hold.data{2}(:,3)
data_grp_icoh_barmat.healthy.hold(:,4)=data_grp_icoh_colscat_2022_04_10_acdata.Beta.Hold.data{2}(:,4)
data_grp_icoh_barmat.healthy.hold(:,5)=data_grp_icoh_colscat_2022_04_10_acdata.Beta.Hold.data{3}(:,3)
data_grp_icoh_barmat.healthy.hold(:,6)=data_grp_icoh_colscat_2022_04_10_acdata.Beta.Hold.data{3}(:,4)
data_grp_icoh_barmat.healthy.hold(:,7)=data_grp_icoh_colscat_2022_04_10_acdata.Beta.Hold.data{4}(:,3)
data_grp_icoh_barmat.healthy.hold(:,8)=data_grp_icoh_colscat_2022_04_10_acdata.Beta.Hold.data{4}(:,4)

data_grp_icoh_barmat.healthy.prep(:,1)=data_grp_icoh_colscat_2022_04_10_acdata.Beta.Prep.data{1}(:,3)
data_grp_icoh_barmat.healthy.prep(:,2)=data_grp_icoh_colscat_2022_04_10_acdata.Beta.Prep.data{1}(:,4)
data_grp_icoh_barmat.healthy.prep(:,3)=data_grp_icoh_colscat_2022_04_10_acdata.Beta.Prep.data{2}(:,3)
data_grp_icoh_barmat.healthy.prep(:,4)=data_grp_icoh_colscat_2022_04_10_acdata.Beta.Prep.data{2}(:,4)
data_grp_icoh_barmat.healthy.prep(:,5)=data_grp_icoh_colscat_2022_04_10_acdata.Beta.Prep.data{3}(:,3)
data_grp_icoh_barmat.healthy.prep(:,6)=data_grp_icoh_colscat_2022_04_10_acdata.Beta.Prep.data{3}(:,4)
data_grp_icoh_barmat.healthy.prep(:,7)=data_grp_icoh_colscat_2022_04_10_acdata.Beta.Prep.data{4}(:,3)
data_grp_icoh_barmat.healthy.prep(:,8)=data_grp_icoh_colscat_2022_04_10_acdata.Beta.Prep.data{4}(:,4)

data_grp_icoh_barmat.healthy.reach(:,1)=data_grp_icoh_colscat_2022_04_10_acdata.Beta.Reach.data{1}(:,3)
data_grp_icoh_barmat.healthy.reach(:,2)=data_grp_icoh_colscat_2022_04_10_acdata.Beta.Reach.data{1}(:,4)
data_grp_icoh_barmat.healthy.reach(:,3)=data_grp_icoh_colscat_2022_04_10_acdata.Beta.Reach.data{2}(:,3)
data_grp_icoh_barmat.healthy.reach(:,4)=data_grp_icoh_colscat_2022_04_10_acdata.Beta.Reach.data{2}(:,4)
data_grp_icoh_barmat.healthy.reach(:,5)=data_grp_icoh_colscat_2022_04_10_acdata.Beta.Reach.data{3}(:,3)
data_grp_icoh_barmat.healthy.reach(:,6)=data_grp_icoh_colscat_2022_04_10_acdata.Beta.Reach.data{3}(:,4)
data_grp_icoh_barmat.healthy.reach(:,7)=data_grp_icoh_colscat_2022_04_10_acdata.Beta.Reach.data{4}(:,3)
data_grp_icoh_barmat.healthy.reach(:,8)=data_grp_icoh_colscat_2022_04_10_acdata.Beta.Reach.data{4}(:,4)
data_grp_icoh_barmat.labels.soi={'sham';'stim';'sham';'stim';'sham';'stim';'sham';'stim'};
data_grp_icoh_barmat.labels.poi={'pre';'pre';'intra5';'intra5';'intra15';'intra15';'post5';'post5'};

c=clock;
y=sprintf('%0.5g',[c(1)]);
m=sprintf('%0.5g',[c(2)]);
d=sprintf('%0.5g',[c(3)]);
if str2num(m)<10
    m=['0',m];
end
if str2num(d)<10
    d=['0',d];
end
date=[y,'_',m,'_',d];

eval([['data_grp_icohbar_',date],'=data_grp_icoh_barmat']);
save([iCohbar_folder,'/',['data_grp_icohbar_',date]],['data_grp_icohbar_',date])

%confirm Allen's plot
figure
subplot(3,2,1); hold on
bar([nanmean(data_grp_icoh_barmat.stroke.hold(:,1)),nanmean(data_grp_icoh_barmat.stroke.hold(:,2)),0,...
nanmean(data_grp_icoh_barmat.stroke.hold(:,3)),nanmean(data_grp_icoh_barmat.stroke.hold(:,4)),0,...
nanmean(data_grp_icoh_barmat.stroke.hold(:,5)),nanmean(data_grp_icoh_barmat.stroke.hold(:,6)),0,...
nanmean(data_grp_icoh_barmat.stroke.hold(:,7)),nanmean(data_grp_icoh_barmat.stroke.hold(:,8))])

errorbar([nanmean(data_grp_icoh_barmat.stroke.hold(:,1)),nanmean(data_grp_icoh_barmat.stroke.hold(:,2)),0,...
nanmean(data_grp_icoh_barmat.stroke.hold(:,3)),nanmean(data_grp_icoh_barmat.stroke.hold(:,4)),0,...
nanmean(data_grp_icoh_barmat.stroke.hold(:,5)),nanmean(data_grp_icoh_barmat.stroke.hold(:,6)),0,...
nanmean(data_grp_icoh_barmat.stroke.hold(:,7)),nanmean(data_grp_icoh_barmat.stroke.hold(:,8))],...
[nanstd(data_grp_icoh_barmat.stroke.hold(:,1))/sqrt(5),nanstd(data_grp_icoh_barmat.stroke.hold(:,2))/sqrt(5),0,...
nanstd(data_grp_icoh_barmat.stroke.hold(:,3))/sqrt(5),nanstd(data_grp_icoh_barmat.stroke.hold(:,4))/sqrt(5),0,...
nanstd(data_grp_icoh_barmat.stroke.hold(:,5))/sqrt(5),nanstd(data_grp_icoh_barmat.stroke.hold(:,6))/sqrt(5),0,...
nanstd(data_grp_icoh_barmat.stroke.hold(:,7))/sqrt(5),nanstd(data_grp_icoh_barmat.stroke.hold(:,8))/sqrt(5)],'.k')
title('stroke hold')

subplot(3,2,3); hold on
bar([nanmean(data_grp_icoh_barmat.stroke.prep(:,1)),nanmean(data_grp_icoh_barmat.stroke.prep(:,2)),0,...
nanmean(data_grp_icoh_barmat.stroke.prep(:,3)),nanmean(data_grp_icoh_barmat.stroke.prep(:,4)),0,...
nanmean(data_grp_icoh_barmat.stroke.prep(:,5)),nanmean(data_grp_icoh_barmat.stroke.prep(:,6)),0,...
nanmean(data_grp_icoh_barmat.stroke.prep(:,7)),nanmean(data_grp_icoh_barmat.stroke.prep(:,8))])

errorbar([nanmean(data_grp_icoh_barmat.stroke.prep(:,1)),nanmean(data_grp_icoh_barmat.stroke.prep(:,2)),0,...
nanmean(data_grp_icoh_barmat.stroke.prep(:,3)),nanmean(data_grp_icoh_barmat.stroke.prep(:,4)),0,...
nanmean(data_grp_icoh_barmat.stroke.prep(:,5)),nanmean(data_grp_icoh_barmat.stroke.prep(:,6)),0,...
nanmean(data_grp_icoh_barmat.stroke.prep(:,7)),nanmean(data_grp_icoh_barmat.stroke.prep(:,8))],...
[nanstd(data_grp_icoh_barmat.stroke.prep(:,1))/sqrt(5),nanstd(data_grp_icoh_barmat.stroke.prep(:,2))/sqrt(5),0,...
nanstd(data_grp_icoh_barmat.stroke.prep(:,3))/sqrt(5),nanstd(data_grp_icoh_barmat.stroke.prep(:,4))/sqrt(5),0,...
nanstd(data_grp_icoh_barmat.stroke.prep(:,5))/sqrt(5),nanstd(data_grp_icoh_barmat.stroke.prep(:,6))/sqrt(5),0,...
nanstd(data_grp_icoh_barmat.stroke.prep(:,7))/sqrt(5),nanstd(data_grp_icoh_barmat.stroke.prep(:,8))/sqrt(5)],'.k')
title('stroke prep')

subplot(3,2,5); hold on
bar([nanmean(data_grp_icoh_barmat.stroke.reach(:,1)),nanmean(data_grp_icoh_barmat.stroke.reach(:,2)),0,...
nanmean(data_grp_icoh_barmat.stroke.reach(:,3)),nanmean(data_grp_icoh_barmat.stroke.reach(:,4)),0,...
nanmean(data_grp_icoh_barmat.stroke.reach(:,5)),nanmean(data_grp_icoh_barmat.stroke.reach(:,6)),0,...
nanmean(data_grp_icoh_barmat.stroke.reach(:,7)),nanmean(data_grp_icoh_barmat.stroke.reach(:,8))])

errorbar([nanmean(data_grp_icoh_barmat.stroke.reach(:,1)),nanmean(data_grp_icoh_barmat.stroke.reach(:,2)),0,...
nanmean(data_grp_icoh_barmat.stroke.reach(:,3)),nanmean(data_grp_icoh_barmat.stroke.reach(:,4)),0,...
nanmean(data_grp_icoh_barmat.stroke.reach(:,5)),nanmean(data_grp_icoh_barmat.stroke.reach(:,6)),0,...
nanmean(data_grp_icoh_barmat.stroke.reach(:,7)),nanmean(data_grp_icoh_barmat.stroke.reach(:,8))],...
[nanstd(data_grp_icoh_barmat.stroke.reach(:,1))/sqrt(5),nanstd(data_grp_icoh_barmat.stroke.reach(:,2))/sqrt(5),0,...
nanstd(data_grp_icoh_barmat.stroke.reach(:,3))/sqrt(5),nanstd(data_grp_icoh_barmat.stroke.reach(:,4))/sqrt(5),0,...
nanstd(data_grp_icoh_barmat.stroke.reach(:,5))/sqrt(5),nanstd(data_grp_icoh_barmat.stroke.reach(:,6))/sqrt(5),0,...
nanstd(data_grp_icoh_barmat.stroke.reach(:,7))/sqrt(5),nanstd(data_grp_icoh_barmat.stroke.reach(:,8))/sqrt(5)],'.k')
title('stroke reach')

subplot(3,2,2); hold on
bar([nanmean(data_grp_icoh_barmat.healthy.hold(:,1)),nanmean(data_grp_icoh_barmat.healthy.hold(:,2)),0,...
nanmean(data_grp_icoh_barmat.healthy.hold(:,3)),nanmean(data_grp_icoh_barmat.healthy.hold(:,4)),0,...
nanmean(data_grp_icoh_barmat.healthy.hold(:,5)),nanmean(data_grp_icoh_barmat.healthy.hold(:,6)),0,...
nanmean(data_grp_icoh_barmat.healthy.hold(:,7)),nanmean(data_grp_icoh_barmat.healthy.hold(:,8))])

errorbar([nanmean(data_grp_icoh_barmat.healthy.hold(:,1)),nanmean(data_grp_icoh_barmat.healthy.hold(:,2)),0,...
nanmean(data_grp_icoh_barmat.healthy.hold(:,3)),nanmean(data_grp_icoh_barmat.healthy.hold(:,4)),0,...
nanmean(data_grp_icoh_barmat.healthy.hold(:,5)),nanmean(data_grp_icoh_barmat.healthy.hold(:,6)),0,...
nanmean(data_grp_icoh_barmat.healthy.hold(:,7)),nanmean(data_grp_icoh_barmat.healthy.hold(:,8))],...
[nanstd(data_grp_icoh_barmat.healthy.hold(:,1))/sqrt(5),nanstd(data_grp_icoh_barmat.healthy.hold(:,2))/sqrt(6),0,...
nanstd(data_grp_icoh_barmat.healthy.hold(:,3))/sqrt(5),nanstd(data_grp_icoh_barmat.healthy.hold(:,4))/sqrt(6),0,...
nanstd(data_grp_icoh_barmat.healthy.hold(:,5))/sqrt(5),nanstd(data_grp_icoh_barmat.healthy.hold(:,6))/sqrt(6),0,...
nanstd(data_grp_icoh_barmat.healthy.hold(:,7))/sqrt(5),nanstd(data_grp_icoh_barmat.healthy.hold(:,8))/sqrt(6)],'.k')
title('healthy hold')

subplot(3,2,4); hold on
bar([nanmean(data_grp_icoh_barmat.healthy.prep(:,1)),nanmean(data_grp_icoh_barmat.healthy.prep(:,2)),0,...
nanmean(data_grp_icoh_barmat.healthy.prep(:,3)),nanmean(data_grp_icoh_barmat.healthy.prep(:,4)),0,...
nanmean(data_grp_icoh_barmat.healthy.prep(:,5)),nanmean(data_grp_icoh_barmat.healthy.prep(:,6)),0,...
nanmean(data_grp_icoh_barmat.healthy.prep(:,7)),nanmean(data_grp_icoh_barmat.healthy.prep(:,8))])

errorbar([nanmean(data_grp_icoh_barmat.healthy.prep(:,1)),nanmean(data_grp_icoh_barmat.healthy.prep(:,2)),0,...
nanmean(data_grp_icoh_barmat.healthy.prep(:,3)),nanmean(data_grp_icoh_barmat.healthy.prep(:,4)),0,...
nanmean(data_grp_icoh_barmat.healthy.prep(:,5)),nanmean(data_grp_icoh_barmat.healthy.prep(:,6)),0,...
nanmean(data_grp_icoh_barmat.healthy.prep(:,7)),nanmean(data_grp_icoh_barmat.healthy.prep(:,8))],...
[nanstd(data_grp_icoh_barmat.healthy.prep(:,1))/sqrt(5),nanstd(data_grp_icoh_barmat.healthy.prep(:,2))/sqrt(6),0,...
nanstd(data_grp_icoh_barmat.healthy.prep(:,3))/sqrt(5),nanstd(data_grp_icoh_barmat.healthy.prep(:,4))/sqrt(6),0,...
nanstd(data_grp_icoh_barmat.healthy.prep(:,5))/sqrt(5),nanstd(data_grp_icoh_barmat.healthy.prep(:,6))/sqrt(6),0,...
nanstd(data_grp_icoh_barmat.healthy.prep(:,7))/sqrt(5),nanstd(data_grp_icoh_barmat.healthy.prep(:,8))/sqrt(6)],'.k')
title('healthy prep')

subplot(3,2,6); hold on
bar([nanmean(data_grp_icoh_barmat.healthy.reach(:,1)),nanmean(data_grp_icoh_barmat.healthy.reach(:,2)),0,...
nanmean(data_grp_icoh_barmat.healthy.reach(:,3)),nanmean(data_grp_icoh_barmat.healthy.reach(:,4)),0,...
nanmean(data_grp_icoh_barmat.healthy.reach(:,5)),nanmean(data_grp_icoh_barmat.healthy.reach(:,6)),0,...
nanmean(data_grp_icoh_barmat.healthy.reach(:,7)),nanmean(data_grp_icoh_barmat.healthy.reach(:,8))])

errorbar([nanmean(data_grp_icoh_barmat.healthy.reach(:,1)),nanmean(data_grp_icoh_barmat.healthy.reach(:,2)),0,...
nanmean(data_grp_icoh_barmat.healthy.reach(:,3)),nanmean(data_grp_icoh_barmat.healthy.reach(:,4)),0,...
nanmean(data_grp_icoh_barmat.healthy.reach(:,5)),nanmean(data_grp_icoh_barmat.healthy.reach(:,6)),0,...
nanmean(data_grp_icoh_barmat.healthy.reach(:,7)),nanmean(data_grp_icoh_barmat.healthy.reach(:,8))],...
[nanstd(data_grp_icoh_barmat.healthy.reach(:,1))/sqrt(5),nanstd(data_grp_icoh_barmat.healthy.reach(:,2))/sqrt(6),0,...
nanstd(data_grp_icoh_barmat.healthy.reach(:,3))/sqrt(5),nanstd(data_grp_icoh_barmat.healthy.reach(:,4))/sqrt(6),0,...
nanstd(data_grp_icoh_barmat.healthy.reach(:,5))/sqrt(5),nanstd(data_grp_icoh_barmat.healthy.reach(:,6))/sqrt(6),0,...
nanstd(data_grp_icoh_barmat.healthy.reach(:,7))/sqrt(5),nanstd(data_grp_icoh_barmat.healthy.reach(:,8))/sqrt(6)],'.k')
title('healthy reach')
%
%% Coherence matrix

TOI={'pre-stim (baseline)','intrastim (5 min)','intrastim (15 min)','post-stim (5 min)'};
TOI_mod={'prestim','intra5','intra15','poststim5'};
phases={'Hold','Prep','Reach'};
DOI={'stroke','healthy'};
stimtypes=[0,2];
stimname={'Sham','Stim'};
electrodes={'A1','Fp1','F7','T3','T5','O1','F3','C3','P3','Fz','Cz','Pz','A2','Fp2','F8','T4','T6','O2','F4','C4','P4'};
norm=false;
FOI_label={'Alpha','Beta','Gamma'};
FOI_freq={{8,12},{13,30},{30,50}};
savefigures=true;
%outpath='C:\Users\allen\Desktop\RowlandFigs_11_22_21\Coh';
analysisfolder='/home/rowlandn/nr_data_analysis/data_analyzed/eeg/gen_03/Analysis';
iCohMatrixFolder=fullfile(analysisfolder,'iCohMatrix');
mkdir(iCohMatrixFolder);
outpath=iCohMatrixFolder


for f=1:numel(FOI_freq)
    for d=1:numel(DOI)
        %figure('WindowState','Maximized');
        figure; set(gcf,'Position',[2371 385 593 430])
        set(gcf,'color','w');
        ax_count=1;
        clear h
        for t=1:numel(TOI)
            for p=1:numel(phases)
                
                tempdisease=[];
                tempstim=[];
                matcoh=[];
                
                for s=1:numel(sbj)
                    
                    % Calculate coherence
                    sbjicoh=subjectData(s).iCoh;
                    FOI_idx=sbjicoh.freq>=FOI_freq{f}{1} & sbjicoh.freq<=FOI_freq{f}{2};
                    TOI_idx=strcmp(subjectData(s).sessioninfo.trialnames,TOI{t});
                    tempdat=mean(mean(sbjicoh.data(:,FOI_idx,:,p,TOI_idx),2,'omitnan'),3,'omitnan');
                    tempmatcoh=nan(numel(electrodes));
                    for i=1:numel(tempdat)
                        templabel=sbjicoh.label(i,:);
                        tempmatcoh(strcmp(templabel{1},electrodes),strcmp(templabel{2},electrodes))=tempdat(i);
                        tempmatcoh(strcmp(templabel{2},electrodes),strcmp(templabel{1},electrodes))=tempdat(i);
                        
                        % Make diag nan
                        tempmatcoh(logical(diag(ones(size(tempmatcoh,1),1))))=nan;
                    end
                    matcoh(:,:,s)=tempmatcoh;
                    %eval(['matcoh_',FOI_label{f},'_',DOI{d},'_',TOI{t},'_',phases{p},'=matcoh;'])
                    
                    % Organize disease
                    tempdisease{s,1}=subjectData(s).sessioninfo.dx;
                    
                    % Organize stim
                    tempstim(s,1)=subjectData(s).sessioninfo.stimamp;
                end
                
                for s=1:numel(stimtypes)
                    h(ax_count)=subplot(numel(TOI),numel(phases)*numel(stimtypes),p+((s-1)*numel(phases))+((t-1)*numel(phases)*numel(stimtypes)));
                    ax_count=ax_count+1;
                    idx=tempstim==stimtypes(s)&strcmp(tempdisease,DOI{d});
                    eval(['data_grp_icohmat_',FOI_label{f},'_',DOI{d},'_',TOI_mod{t},'_',phases{p},'_',stimname{s},'=matcoh(:,:,idx);'])
                    imagescDat=mean(matcoh(:,:,idx),3);
                    if norm
                        imagescDat(logical(diag(ones(size(imagescDat,1),1))))=mean(imagescDat,'all');
                        imagescDat=mat2gray(imagescDat);
                        imagescDat(logical(diag(ones(size(imagescDat,1),1))))=nan;
                    end
                    imagesc(imagescDat,[0.4 0.7])
                    axis square
                    
                    colormap('jet');
                    xticks([1:numel(electrodes)])
                    xticklabels(electrodes)
                    yticks([1:numel(electrodes)])
                    yticklabels(electrodes)
                    title(phases{p})
                    subtitle(stimname{s})
                    ylabel(TOI{t})
                end
            end
        end
        
        % Colorbar
        cbh = colorbar(h(end));
        cbh.Location='layout';
        cbh.Position=[.9314 .11 .0281 .8150];
        ylabel(cbh,'Coherence','FontSize',12)
        if norm
            ylabel(cbh,['Normalized ',FOI_label{f},' Coherence'],'FontSize',12)
            figtitle=sprintf('%s Coherence Matrix - %s Normalized',FOI_label{f},DOI{d});
        else
            ylabel(cbh,['Coherence ',FOI_label{f}],'FontSize',12)
            figtitle=sprintf('%s Coherence Matrix - %s',FOI_label{f},DOI{d});
        end
        
        % Title
        sgtitle(DOI{d})
        
%         % Save figure
%         if savefigures
%             savefig(gcf,fullfile(outpath,figtitle));
%             saveas(gcf,fullfile(iCohMatrixFolder,[figtitle,'.jpeg']))
%         end
        
        %close all
    end
end

c=clock;
y=sprintf('%0.5g',[c(1)]);
m=sprintf('%0.5g',[c(2)]);
d=sprintf('%0.5g',[c(3)]);
if str2num(m)<10
    m=['0',m];
end
if str2num(d)<10
    d=['0',d];
end
date=[y,'_',m,'_',d];

% eval([['data_grp_icohmatrices_',date],'=data_grp_icoh_barmat']);
save([iCohMatrixFolder,'/',['data_grp_icohmatrices_',date]],['data_grp_icohmat*'])

                


%Create subject name variable
for s=1:size(subjectData,2)
    tempdisease{s,1}=subjectData(s).sessioninfo.dx;
    tempstim(s,1)=subjectData(s).sessioninfo.stimamp;
end

sbj_name=cell(6,numel(DOI)*numel(stimtypes));
sbjcount=1;
for d=1:numel(DOI)
    for s=1:numel(stimtypes)
        idx=strcmp(tempdisease,DOI{d})&tempstim==stimtypes(s);
        hold on
        ydat=tempdat(idx);
        sbjs=extractAfter({subjectData(idx).SubjectName},'pro00087153_00');
        sbj_name(1:numel(sbjs),sbjcount)=sbjs;
        sbjcount=sbjcount+1;
    end
end
   
% This is for individual matrices
for sbj=1:numel(sbj_name)
    
    if isempty(sbj_name{sbj})
    else
        figure; set(gcf,'Position',[2133 109 1214 834])

        if sbj>=1 & sbj<=6
            distype='stroke';
            stimtype='Sham';
        elseif sbj>=7 & sbj<=12
            distype='stroke';
            stimtype='Stim';
        elseif sbj>=13 & sbj<=18
            distype='healthy';
            stimtype='Sham';
        elseif sbj>=19 & sbj<=24
            distype='healthy';
            stimtype='Stim';
        end

        %extract subject row
        [sbj_r,sbj_c]=ind2sub(size(sbj_name),sbj);

        for t=1:numel(TOI)
            subplot(4,3,3*t-2)
            if t==1
                eval(['imagescDat=data_grp_icohmat_Beta_',distype,'_prestim_Hold_',stimtype,'(:,:,sbj_r);']);
                eval(['imagescDat_p1_t1=data_grp_icohmat_Beta_',distype,'_prestim_Hold_',stimtype,'(20,8,sbj_r);']);
                %imagescDat=data_grp_icohmat_Beta_stroke_prestim_Hold_Stim(:,:,sbj);
            elseif t==2
                eval(['imagescDat=data_grp_icohmat_Beta_',distype,'_intra5_Hold_',stimtype,'(:,:,sbj_r);']);
                eval(['imagescDat_p1_t2=data_grp_icohmat_Beta_',distype,'_intra5_Hold_',stimtype,'(20,8,sbj_r);']);
                %imagescDat=data_grp_icohmat_Beta_stroke_intra5_Hold_Stim(:,:,sbj);
            elseif t==3
                eval(['imagescDat=data_grp_icohmat_Beta_',distype,'_intra15_Hold_',stimtype,'(:,:,sbj_r);']);
                eval(['imagescDat_p1_t3=data_grp_icohmat_Beta_',distype,'_intra15_Hold_',stimtype,'(20,8,sbj_r);']);
                %imagescDat=data_grp_icohmat_Beta_stroke_intra15_Hold_Stim(:,:,sbj);
            elseif t==4
                eval(['imagescDat=data_grp_icohmat_Beta_',distype,'_poststim5_Hold_',stimtype,'(:,:,sbj_r);']);
                eval(['imagescDat_p1_t4=data_grp_icohmat_Beta_',distype,'_poststim5_Hold_',stimtype,'(20,8,sbj_r);']);
                %imagescDat=data_grp_icohmat_Beta_stroke_poststim5_Hold_Stim(:,:,sbj);
            end

        %             if norm
        %                 imagescDat1(logical(diag(ones(size(imagescDat1,1),1))))=mean(imagescDat1,'all');
        %                 imagescDat1=mat2gray(imagescDat1);
        %                 imagescDat1(logical(diag(ones(size(imagescDat1,1),1))))=nan;
        %             end
            imagesc(imagescDat,[0.4 0.7])
            %axis square

            colormap('jet');
            xticks([1:numel(electrodes)])
            xticklabels(electrodes)
            yticks([1:numel(electrodes)])
            yticklabels(electrodes)
            title(phases{1})%p
            %subtitle(stimname{2})%s
            subtitle(stimtype)
            ylabel(TOI{t})

        end

        for t=1:numel(TOI)
            subplot(4,3,3*t-1)
            if t==1
                eval(['imagescDat=data_grp_icohmat_Beta_',distype,'_prestim_Prep_',stimtype,'(:,:,sbj_r);']);
                eval(['imagescDat_p2_t1=data_grp_icohmat_Beta_',distype,'_prestim_Prep_',stimtype,'(20,8,sbj_r);']);
                %imagescDat=data_grp_icohmat_Beta_stroke_prestim_Prep_Stim(:,:,sbj);
            elseif t==2
                eval(['imagescDat=data_grp_icohmat_Beta_',distype,'_intra5_Prep_',stimtype,'(:,:,sbj_r);']);
                eval(['imagescDat_p2_t2=data_grp_icohmat_Beta_',distype,'_intra5_Prep_',stimtype,'(20,8,sbj_r);']);
                %imagescDat=data_grp_icohmat_Beta_stroke_intra5_Prep_Stim(:,:,sbj);
            elseif t==3
                eval(['imagescDat=data_grp_icohmat_Beta_',distype,'_intra15_Prep_',stimtype,'(:,:,sbj_r);']);
                eval(['imagescDat_p2_t3=data_grp_icohmat_Beta_',distype,'_intra15_Prep_',stimtype,'(20,8,sbj_r);']);
                %imagescDat=data_grp_icohmat_Beta_stroke_intra15_Prep_Stim(:,:,sbj);
            elseif t==4
                eval(['imagescDat=data_grp_icohmat_Beta_',distype,'_poststim5_Prep_',stimtype,'(:,:,sbj_r);']);
                eval(['imagescDat_p2_t4=data_grp_icohmat_Beta_',distype,'_poststim5_Prep_',stimtype,'(20,8,sbj_r);']);
                %imagescDat=data_grp_icohmat_Beta_stroke_poststim5_Prep_Stim(:,:,sbj);
            end

    %             if norm
    %                 imagescDat1(logical(diag(ones(size(imagescDat1,1),1))))=mean(imagescDat1,'all');
    %                 imagescDat1=mat2gray(imagescDat1);
    %                 imagescDat1(logical(diag(ones(size(imagescDat1,1),1))))=nan;
    %             end
            imagesc(imagescDat,[0.4 0.7])
            %axis square

            colormap('jet');
            xticks([1:numel(electrodes)])
            xticklabels(electrodes)
            yticks([1:numel(electrodes)])
            yticklabels(electrodes)
            title(phases{2})%p
            %subtitle(stimname{2})%s
            subtitle(stimtype)
            ylabel(TOI{t})

        end

        for t=1:numel(TOI)
            subplot(4,3,3*t)
            if t==1
                eval(['imagescDat=data_grp_icohmat_Beta_',distype,'_prestim_Reach_',stimtype,'(:,:,sbj_r);']);
                eval(['imagescDat_p3_t1=data_grp_icohmat_Beta_',distype,'_prestim_Reach_',stimtype,'(20,8,sbj_r);']);
                %imagescDat=data_grp_icohmat_Beta_stroke_prestim_Reach_Stim(:,:,sbj);
            elseif t==2
                eval(['imagescDat=data_grp_icohmat_Beta_',distype,'_intra5_Reach_',stimtype,'(:,:,sbj_r);']);
                eval(['imagescDat_p3_t2=data_grp_icohmat_Beta_',distype,'_intra5_Reach_',stimtype,'(20,8,sbj_r);']);
                %imagescDat=data_grp_icohmat_Beta_stroke_intra5_Reach_Stim(:,:,sbj);
            elseif t==3
                eval(['imagescDat=data_grp_icohmat_Beta_',distype,'_intra15_Reach_',stimtype,'(:,:,sbj_r);']);
                eval(['imagescDat_p3_t3=data_grp_icohmat_Beta_',distype,'_intra15_Reach_',stimtype,'(20,8,sbj_r);']);
                %imagescDat=data_grp_icohmat_Beta_stroke_intra15_Reach_Stim(:,:,sbj);
            elseif t==4
                eval(['imagescDat=data_grp_icohmat_Beta_',distype,'_poststim5_Reach_',stimtype,'(:,:,sbj_r);']);
                eval(['imagescDat_p3_t4=data_grp_icohmat_Beta_',distype,'_poststim5_Reach_',stimtype,'(20,8,sbj_r);']);
                %imagescDat=data_grp_icohmat_Beta_stroke_poststim5_Reach_Stim(:,:,sbj);
            end

    %             if norm
    %                 imagescDat1(logical(diag(ones(size(imagescDat1,1),1))))=mean(imagescDat1,'all');
    %                 imagescDat1=mat2gray(imagescDat1);
    %                 imagescDat1(logical(diag(ones(size(imagescDat1,1),1))))=nan;
    %             end
            imagesc(imagescDat,[0.4 0.7])
            %axis square

            colormap('jet');
            xticks([1:numel(electrodes)])
            xticklabels(electrodes)
            yticks([1:numel(electrodes)])
            yticklabels(electrodes)
            title(phases{3})%p
            %subtitle(stimname{2})%s
            subtitle(stimtype)
            ylabel(TOI{t})

        end
        %sbj
        sgtitle([sbj_name{sbj},' ',distype,' ',stimtype])
        %[sbj_name{sbj},' ',distype,' ',stimtype]

        %Colorbar
        %cbh = colorbar(h(end));
        cbh = colorbar;
        cbh.Location='layout';
        cbh.Position=[.9314 .11 .0281 .8150];
        ylabel(cbh,'Coherence','FontSize',12)
        f=2;
        if norm
            ylabel(cbh,['Normalized ',FOI_label{f},' Coherence'],'FontSize',12)
            figtitle=sprintf('%s Coherence Matrix - %s Normalized',FOI_label{f},DOI{d});
        else
            ylabel(cbh,['Coherence ',FOI_label{f}],'FontSize',12)
            figtitle=sprintf('%s Coherence Matrix - %s',FOI_label{f},DOI{d});
        end
        
        imagescDat_ind_c3_c4{sbj_r,sbj_c}(1,1)=imagescDat_p1_t1;
        imagescDat_ind_c3_c4{sbj_r,sbj_c}(2,1)=imagescDat_p1_t2;
        imagescDat_ind_c3_c4{sbj_r,sbj_c}(3,1)=imagescDat_p1_t3;
        imagescDat_ind_c3_c4{sbj_r,sbj_c}(4,1)=imagescDat_p1_t4;

        imagescDat_ind_c3_c4{sbj_r,sbj_c}(1,2)=imagescDat_p2_t1;
        imagescDat_ind_c3_c4{sbj_r,sbj_c}(2,2)=imagescDat_p2_t2;
        imagescDat_ind_c3_c4{sbj_r,sbj_c}(3,2)=imagescDat_p2_t3;
        imagescDat_ind_c3_c4{sbj_r,sbj_c}(4,2)=imagescDat_p2_t4;

        imagescDat_ind_c3_c4{sbj_r,sbj_c}(1,3)=imagescDat_p3_t1;
        imagescDat_ind_c3_c4{sbj_r,sbj_c}(2,3)=imagescDat_p3_t2;
        imagescDat_ind_c3_c4{sbj_r,sbj_c}(3,3)=imagescDat_p3_t3;
        imagescDat_ind_c3_c4{sbj_r,sbj_c}(4,3)=imagescDat_p3_t4;
    end
end

clear data_grp_icohmat_*

%This is for ind c3-4 plots
figure; set(gcf,'Position',[2133 109 1214 834])
sp_vec=[1,7,13,19,2,8,14,20,3,9,15,21,4,10,16,22,5,11,17,23,NaN,NaN,NaN,24]
for sbj=1:numel(sbj_name)
    %if isempty(sbj_name{sbj})
    if isnan(sp_vec(sbj))
    else
        subplot(6,4,sbj)
        imagesc(imagescDat_ind_c3_c4{sp_vec(sbj)},[0.4 0.7])
        ylabel(sbj_name{sp_vec(sbj)},'Fontweight','bold')
        colormap('jet');
        set(gca,'YTick',[1:4],'YTickLabel',['pre';'i05';'i15';'pos'],'XTick',[1:3],'XTickLabel',['H';'P';'R'])
        if sbj==1
            title('stroke')
            subtitle ('sham')
        elseif sbj==2
            title('stroke')
            subtitle ('stim')
        elseif sbj==3
            title('healthy')
            subtitle ('sham')
        elseif sbj==4
            title('healthy')
            subtitle ('stim')
        end
            
        %Colorbar
        cbh = colorbar;
        cbh.Location='layout';
        cbh.Position=[.9314 .11 .0281 .8150];
        ylabel(cbh,'Coherence','FontSize',12)
        f=2;
        if norm
            ylabel(cbh,['Normalized ',FOI_label{f},' C3-4 Coherence'],'FontSize',12)
            figtitle=sprintf('%s Coherence Matrix - %s Normalized',FOI_label{f},DOI{d});
        else
            ylabel(cbh,['C3-4 Coherence ',FOI_label{f}],'FontSize',12)
            figtitle=sprintf('%s Coherence Matrix - %s',FOI_label{f},DOI{d});
        end
    end
end
    
%% put titles and subtitles on columns
% 

%then plot means in 2 or more ways
%then perhaps plot percentages

for sbj=1:numel(imagescDat_ind_c3_c4)
    if isempty(sbj_name{sbj})
    else
        %for 
            
            if sbj>=1 & sbj<=6
                distype='stroke';
                stimtype='sham';
                [sbj_r,sbj_c]=ind2sub(size(sbj_name),sbj);
                eval(['all_imagescDat_ind_c3_c4_beta_',distype,'_',stimtype,'_pre_hold(sbj_r)=imagescDat_ind_c3_c4{sbj_r,1}(1,1);']);
                eval(['all_imagescDat_ind_c3_c4_beta_',distype,'_',stimtype,'_i05_hold(sbj_r)=imagescDat_ind_c3_c4{sbj_r,1}(2,1);']);
                eval(['all_imagescDat_ind_c3_c4_beta_',distype,'_',stimtype,'_i15_hold(sbj_r)=imagescDat_ind_c3_c4{sbj_r,1}(3,1);']);
                eval(['all_imagescDat_ind_c3_c4_beta_',distype,'_',stimtype,'_pos_hold(sbj_r)=imagescDat_ind_c3_c4{sbj_r,1}(4,1);']);
                
                eval(['all_imagescDat_ind_c3_c4_beta_',distype,'_',stimtype,'_pre_prep(sbj_r)=imagescDat_ind_c3_c4{sbj_r,1}(1,2);']);
                eval(['all_imagescDat_ind_c3_c4_beta_',distype,'_',stimtype,'_i05_prep(sbj_r)=imagescDat_ind_c3_c4{sbj_r,1}(2,2);']);
                eval(['all_imagescDat_ind_c3_c4_beta_',distype,'_',stimtype,'_i15_prep(sbj_r)=imagescDat_ind_c3_c4{sbj_r,1}(3,2);']);
                eval(['all_imagescDat_ind_c3_c4_beta_',distype,'_',stimtype,'_pos_prep(sbj_r)=imagescDat_ind_c3_c4{sbj_r,1}(4,2);']);
                
                eval(['all_imagescDat_ind_c3_c4_beta_',distype,'_',stimtype,'_pre_reac(sbj_r)=imagescDat_ind_c3_c4{sbj_r,1}(1,3);']);
                eval(['all_imagescDat_ind_c3_c4_beta_',distype,'_',stimtype,'_i05_reac(sbj_r)=imagescDat_ind_c3_c4{sbj_r,1}(2,3);']);
                eval(['all_imagescDat_ind_c3_c4_beta_',distype,'_',stimtype,'_i15_reac(sbj_r)=imagescDat_ind_c3_c4{sbj_r,1}(3,3);']);
                eval(['all_imagescDat_ind_c3_c4_beta_',distype,'_',stimtype,'_pos_reac(sbj_r)=imagescDat_ind_c3_c4{sbj_r,1}(4,3);']);
                
            elseif sbj>=7 & sbj<=12
                distype='stroke';
                stimtype='stim';
                [sbj_r,sbj_c]=ind2sub(size(sbj_name),sbj);
                eval(['all_imagescDat_ind_c3_c4_beta_',distype,'_',stimtype,'_pre_hold(sbj_r)=imagescDat_ind_c3_c4{sbj_r,2}(1,1);']);
                eval(['all_imagescDat_ind_c3_c4_beta_',distype,'_',stimtype,'_i05_hold(sbj_r)=imagescDat_ind_c3_c4{sbj_r,2}(2,1);']);
                eval(['all_imagescDat_ind_c3_c4_beta_',distype,'_',stimtype,'_i15_hold(sbj_r)=imagescDat_ind_c3_c4{sbj_r,2}(3,1);']);
                eval(['all_imagescDat_ind_c3_c4_beta_',distype,'_',stimtype,'_pos_hold(sbj_r)=imagescDat_ind_c3_c4{sbj_r,2}(4,1);']);
                
                eval(['all_imagescDat_ind_c3_c4_beta_',distype,'_',stimtype,'_pre_prep(sbj_r)=imagescDat_ind_c3_c4{sbj_r,2}(1,2);']);
                eval(['all_imagescDat_ind_c3_c4_beta_',distype,'_',stimtype,'_i05_prep(sbj_r)=imagescDat_ind_c3_c4{sbj_r,2}(2,2);']);
                eval(['all_imagescDat_ind_c3_c4_beta_',distype,'_',stimtype,'_i15_prep(sbj_r)=imagescDat_ind_c3_c4{sbj_r,2}(3,2);']);
                eval(['all_imagescDat_ind_c3_c4_beta_',distype,'_',stimtype,'_pos_prep(sbj_r)=imagescDat_ind_c3_c4{sbj_r,2}(4,2);']);
                
                eval(['all_imagescDat_ind_c3_c4_beta_',distype,'_',stimtype,'_pre_reac(sbj_r)=imagescDat_ind_c3_c4{sbj_r,2}(1,3);']);
                eval(['all_imagescDat_ind_c3_c4_beta_',distype,'_',stimtype,'_i05_reac(sbj_r)=imagescDat_ind_c3_c4{sbj_r,2}(2,3);']);
                eval(['all_imagescDat_ind_c3_c4_beta_',distype,'_',stimtype,'_i15_reac(sbj_r)=imagescDat_ind_c3_c4{sbj_r,2}(3,3);']);
                eval(['all_imagescDat_ind_c3_c4_beta_',distype,'_',stimtype,'_pos_reac(sbj_r)=imagescDat_ind_c3_c4{sbj_r,2}(4,3);']);
            elseif sbj>=13 & sbj<=18
                distype='healthy';
                stimtype='sham';
                [sbj_r,sbj_c]=ind2sub(size(sbj_name),sbj);
                eval(['all_imagescDat_ind_c3_c4_beta_',distype,'_',stimtype,'_pre_hold(sbj_r)=imagescDat_ind_c3_c4{sbj_r,3}(1,1);']);
                eval(['all_imagescDat_ind_c3_c4_beta_',distype,'_',stimtype,'_i05_hold(sbj_r)=imagescDat_ind_c3_c4{sbj_r,3}(2,1);']);
                eval(['all_imagescDat_ind_c3_c4_beta_',distype,'_',stimtype,'_i15_hold(sbj_r)=imagescDat_ind_c3_c4{sbj_r,3}(3,1);']);
                eval(['all_imagescDat_ind_c3_c4_beta_',distype,'_',stimtype,'_pos_hold(sbj_r)=imagescDat_ind_c3_c4{sbj_r,3}(4,1);']);
                
                eval(['all_imagescDat_ind_c3_c4_beta_',distype,'_',stimtype,'_pre_prep(sbj_r)=imagescDat_ind_c3_c4{sbj_r,3}(1,2);']);
                eval(['all_imagescDat_ind_c3_c4_beta_',distype,'_',stimtype,'_i05_prep(sbj_r)=imagescDat_ind_c3_c4{sbj_r,3}(2,2);']);
                eval(['all_imagescDat_ind_c3_c4_beta_',distype,'_',stimtype,'_i15_prep(sbj_r)=imagescDat_ind_c3_c4{sbj_r,3}(3,2);']);
                eval(['all_imagescDat_ind_c3_c4_beta_',distype,'_',stimtype,'_pos_prep(sbj_r)=imagescDat_ind_c3_c4{sbj_r,3}(4,2);']);
                
                eval(['all_imagescDat_ind_c3_c4_beta_',distype,'_',stimtype,'_pre_reac(sbj_r)=imagescDat_ind_c3_c4{sbj_r,3}(1,3);']);
                eval(['all_imagescDat_ind_c3_c4_beta_',distype,'_',stimtype,'_i05_reac(sbj_r)=imagescDat_ind_c3_c4{sbj_r,3}(2,3);']);
                eval(['all_imagescDat_ind_c3_c4_beta_',distype,'_',stimtype,'_i15_reac(sbj_r)=imagescDat_ind_c3_c4{sbj_r,3}(3,3);']);
                eval(['all_imagescDat_ind_c3_c4_beta_',distype,'_',stimtype,'_pos_reac(sbj_r)=imagescDat_ind_c3_c4{sbj_r,3}(4,3);']); 
            elseif sbj>=19 & sbj<=24
                distype='healthy';
                stimtype='stim';
                [sbj_r,sbj_c]=ind2sub(size(sbj_name),sbj);
                eval(['all_imagescDat_ind_c3_c4_beta_',distype,'_',stimtype,'_pre_hold(sbj_r)=imagescDat_ind_c3_c4{sbj_r,4}(1,1);']);
                eval(['all_imagescDat_ind_c3_c4_beta_',distype,'_',stimtype,'_i05_hold(sbj_r)=imagescDat_ind_c3_c4{sbj_r,4}(2,1);']);
                eval(['all_imagescDat_ind_c3_c4_beta_',distype,'_',stimtype,'_i15_hold(sbj_r)=imagescDat_ind_c3_c4{sbj_r,4}(3,1);']);
                eval(['all_imagescDat_ind_c3_c4_beta_',distype,'_',stimtype,'_pos_hold(sbj_r)=imagescDat_ind_c3_c4{sbj_r,4}(4,1);']);
                
                eval(['all_imagescDat_ind_c3_c4_beta_',distype,'_',stimtype,'_pre_prep(sbj_r)=imagescDat_ind_c3_c4{sbj_r,4}(1,2);']);
                eval(['all_imagescDat_ind_c3_c4_beta_',distype,'_',stimtype,'_i05_prep(sbj_r)=imagescDat_ind_c3_c4{sbj_r,4}(2,2);']);
                eval(['all_imagescDat_ind_c3_c4_beta_',distype,'_',stimtype,'_i15_prep(sbj_r)=imagescDat_ind_c3_c4{sbj_r,4}(3,2);']);
                eval(['all_imagescDat_ind_c3_c4_beta_',distype,'_',stimtype,'_pos_prep(sbj_r)=imagescDat_ind_c3_c4{sbj_r,4}(4,2);']);
                
                eval(['all_imagescDat_ind_c3_c4_beta_',distype,'_',stimtype,'_pre_reac(sbj_r)=imagescDat_ind_c3_c4{sbj_r,4}(1,3);']);
                eval(['all_imagescDat_ind_c3_c4_beta_',distype,'_',stimtype,'_i05_reac(sbj_r)=imagescDat_ind_c3_c4{sbj_r,4}(2,3);']);
                eval(['all_imagescDat_ind_c3_c4_beta_',distype,'_',stimtype,'_i15_reac(sbj_r)=imagescDat_ind_c3_c4{sbj_r,4}(3,3);']);
                eval(['all_imagescDat_ind_c3_c4_beta_',distype,'_',stimtype,'_pos_reac(sbj_r)=imagescDat_ind_c3_c4{sbj_r,4}(4,3);']); 
            end
    end
end

distype={'stroke';'healthy'};
stimtype={'sham';'stim'};
timetype={'pre';'i05';'i15';'pos'};
phasetype={'hold';'prep';'reac'};

for i=1:size(distype,1)
    for j=1:size(stimtype,1)
        for k=1:size(timetype,1)
            for l=1:size(phasetype,1)
                eval(['mean_all_imagescDat_ind_c3_c4_beta_',distype{i},'_',stimtype{j},'_',timetype{k},'_',phasetype{l},...
                    '=mean(all_imagescDat_ind_c3_c4_beta_',distype{i},'_',stimtype{j},'_',timetype{k},'_',phasetype{l},')'])
                eval(['se_all_imagescDat_ind_c3_c4_beta_',distype{i},'_',stimtype{j},'_',timetype{k},'_',phasetype{l},...
                    '=std(all_imagescDat_ind_c3_c4_beta_',distype{i},'_',stimtype{j},'_',timetype{k},'_',phasetype{l},')',...
                    '/sqrt(size(all_imagescDat_ind_c3_c4_beta_',distype{i},'_',stimtype{j},'_',timetype{k},'_',phasetype{l},',2))'])
            end
        end
    end
end

%stats - friedman
%across timetype
for i=1:size(distype,1)
    for j=1:size(stimtype,1)
        %for k=1:size(timetype,1)
            for l=1:size(phasetype,1)
                eval(['[p_friedman_all_imagescDat_ind_c3_c4_beta_',distype{i},'_',stimtype{j},'_',phasetype{l},',',...
                    'tab_friedman_all_imagescDat_ind_c3_c4_beta_',distype{i},'_',stimtype{j},'_',phasetype{l},',',...
                    'stats_friedman_all_imagescDat_ind_c3_c4_beta_',distype{i},'_',stimtype{j},'_',phasetype{l},']',...
                    '=friedman([all_imagescDat_ind_c3_c4_beta_',distype{i},'_',stimtype{j},'_pre_',phasetype{l},';',...
                              'all_imagescDat_ind_c3_c4_beta_',distype{i},'_',stimtype{j},'_i05_',phasetype{l},';',...
                              'all_imagescDat_ind_c3_c4_beta_',distype{i},'_',stimtype{j},'_i15_',phasetype{l},';',...
                              'all_imagescDat_ind_c3_c4_beta_',distype{i},'_',stimtype{j},'_pos_',phasetype{l},']'');'])
                eval(['mc_friedman_all_imagescDat_ind_c3_c4_beta_',distype{i},'_',stimtype{j},'_',phasetype{l},...
                      '=multcompare(stats_friedman_all_imagescDat_ind_c3_c4_beta_',distype{i},'_',stimtype{j},'_',phasetype{l},');'])
                          
%                 eval(['se_all_imagescDat_ind_c3_c4_beta_',distype{i},'_',stimtype{j},'_',timetype{k},'_',phasetype{l},...
%                     '=std(all_imagescDat_ind_c3_c4_beta_',distype{i},'_',stimtype{j},'_',timetype{k},'_',phasetype{l},')',...
%                     '/sqrt(size(all_imagescDat_ind_c3_c4_beta_',distype{i},'_',stimtype{j},'_',timetype{k},'_',phasetype{l},',2))'])
            end
        %end
    end
end

%across phasetype
for i=1:size(distype,1)
    for j=1:size(stimtype,1)
        for k=1:size(timetype,1)
            %for l=1:size(phasetype,1)
                eval(['[p_friedman_all_imagescDat_ind_c3_c4_beta_',distype{i},'_',stimtype{j},'_',timetype{k},',',...
                    'tab_friedman_all_imagescDat_ind_c3_c4_beta_',distype{i},'_',stimtype{j},'_',timetype{k},',',...
                    'stats_friedman_all_imagescDat_ind_c3_c4_beta_',distype{i},'_',stimtype{j},'_',timetype{k},']',...
                    '=friedman([all_imagescDat_ind_c3_c4_beta_',distype{i},'_',stimtype{j},'_',timetype{k},'_hold;',...
                              'all_imagescDat_ind_c3_c4_beta_',distype{i},'_',stimtype{j},'_',timetype{k},'_prep;',...
                              'all_imagescDat_ind_c3_c4_beta_',distype{i},'_',stimtype{j},'_',timetype{k},'_reac]'');'])
                eval(['mc_friedman_all_imagescDat_ind_c3_c4_beta_',distype{i},'_',stimtype{j},'_',timetype{k},...
                      '=multcompare(stats_friedman_all_imagescDat_ind_c3_c4_beta_',distype{i},'_',stimtype{j},'_',timetype{k},',''display'',''off'');'])
                          
%                 eval(['se_all_imagescDat_ind_c3_c4_beta_',distype{i},'_',stimtype{j},'_',timetype{k},'_',phasetype{l},...
%                     '=std(all_imagescDat_ind_c3_c4_beta_',distype{i},'_',stimtype{j},'_',timetype{k},'_',phasetype{l},')',...
%                     '/sqrt(size(all_imagescDat_ind_c3_c4_beta_',distype{i},'_',stimtype{j},'_',timetype{k},'_',phasetype{l},',2))'])
            %end
        end
    end
end


% [p,table,stats]=friedman([all_imagescDat_ind_c3_c4_beta_stroke_stim_pre_reac;all_imagescDat_ind_c3_c4_beta_stroke_stim_i05_reac;...
%                           all_imagescDat_ind_c3_c4_beta_stroke_stim_i15_reac;all_imagescDat_ind_c3_c4_beta_stroke_stim_pos_reac]')
% COMPARISON = multcompare(stats)
%                       
% BL=[0.5968740907125;0.60956363056717;0.64248700082649;0.62456119385797;0.65382116439671]
% ES=[0.60447079436641;0.62848175223161;0.62651855710951;0.59707599354251;0.59279576383614]
% LS=[0.57004871516244;0.63022053788203;0.63314978680261;0.62036362893798;0.60171930518002]
% Post=[0.65474435031108;0.63926509577160;0.66380602712918;0.66638809071409;0.61612567126317]
% 
% ac_data_grp_icohmat_Beta_stroke_prestim_Reach_Stim(8,20,1)
% 
% 
% [p,table,stats]=friedman([BL,ES,LS,Post])

figure; set(gcf,'Position',[2133 109 1214 834])
%Stroke sham
subplot(7,4,1); hold on
bar([mean_all_imagescDat_ind_c3_c4_beta_stroke_sham_pre_hold mean_all_imagescDat_ind_c3_c4_beta_stroke_sham_i05_hold ,...
    mean_all_imagescDat_ind_c3_c4_beta_stroke_sham_i15_hold mean_all_imagescDat_ind_c3_c4_beta_stroke_sham_pos_hold])
errorbar([mean_all_imagescDat_ind_c3_c4_beta_stroke_sham_pre_hold mean_all_imagescDat_ind_c3_c4_beta_stroke_sham_i05_hold ,...
    mean_all_imagescDat_ind_c3_c4_beta_stroke_sham_i15_hold mean_all_imagescDat_ind_c3_c4_beta_stroke_sham_pos_hold],...
    [se_all_imagescDat_ind_c3_c4_beta_stroke_sham_pre_hold se_all_imagescDat_ind_c3_c4_beta_stroke_sham_i05_hold ,...
    se_all_imagescDat_ind_c3_c4_beta_stroke_sham_i15_hold se_all_imagescDat_ind_c3_c4_beta_stroke_sham_pos_hold],'.k')
set(gca,'XTick',[1:4],'XTickLabel',{'pre';'i05';'i15';'pos'},'YLim',[0.5 0.7])
ylabel('beta c3-c4 icoh')
title('Stroke Sham Hold')
if p_friedman_all_imagescDat_ind_c3_c4_beta_stroke_sham_hold < 0.05
    text(5,0.7,num2str(p_friedman_all_imagescDat_ind_c3_c4_beta_stroke_sham_hold),'Color','r','Rotation',270)
else
    text(5,0.7,num2str(p_friedman_all_imagescDat_ind_c3_c4_beta_stroke_sham_hold),'Rotation',270)
end
    

subplot(7,4,5); hold on
bar([mean_all_imagescDat_ind_c3_c4_beta_stroke_sham_pre_prep mean_all_imagescDat_ind_c3_c4_beta_stroke_sham_i05_prep ,...
    mean_all_imagescDat_ind_c3_c4_beta_stroke_sham_i15_prep mean_all_imagescDat_ind_c3_c4_beta_stroke_sham_pos_prep])
errorbar([mean_all_imagescDat_ind_c3_c4_beta_stroke_sham_pre_prep mean_all_imagescDat_ind_c3_c4_beta_stroke_sham_i05_prep ,...
    mean_all_imagescDat_ind_c3_c4_beta_stroke_sham_i15_prep mean_all_imagescDat_ind_c3_c4_beta_stroke_sham_pos_prep],...
    [se_all_imagescDat_ind_c3_c4_beta_stroke_sham_pre_prep se_all_imagescDat_ind_c3_c4_beta_stroke_sham_i05_prep ,...
    se_all_imagescDat_ind_c3_c4_beta_stroke_sham_i15_prep se_all_imagescDat_ind_c3_c4_beta_stroke_sham_pos_prep],'.k')
set(gca,'XTick',[1:4],'XTickLabel',{'pre';'i05';'i15';'pos'},'YLim',[0.5 0.7])
ylabel('beta c3-c4 icoh')
title('Stroke Sham Prep')
if p_friedman_all_imagescDat_ind_c3_c4_beta_stroke_sham_prep < 0.05
    text(5,0.7,num2str(p_friedman_all_imagescDat_ind_c3_c4_beta_stroke_sham_prep),'Color','r','Rotation',270)
else
    text(5,0.7,num2str(p_friedman_all_imagescDat_ind_c3_c4_beta_stroke_sham_prep),'Rotation',270)
end

subplot(7,4,9); hold on
bar([mean_all_imagescDat_ind_c3_c4_beta_stroke_sham_pre_reac mean_all_imagescDat_ind_c3_c4_beta_stroke_sham_i05_reac ,...
    mean_all_imagescDat_ind_c3_c4_beta_stroke_sham_i15_reac mean_all_imagescDat_ind_c3_c4_beta_stroke_sham_pos_reac])
errorbar([mean_all_imagescDat_ind_c3_c4_beta_stroke_sham_pre_reac mean_all_imagescDat_ind_c3_c4_beta_stroke_sham_i05_reac ,...
    mean_all_imagescDat_ind_c3_c4_beta_stroke_sham_i15_reac mean_all_imagescDat_ind_c3_c4_beta_stroke_sham_pos_reac],...
    [se_all_imagescDat_ind_c3_c4_beta_stroke_sham_pre_reac se_all_imagescDat_ind_c3_c4_beta_stroke_sham_i05_reac ,...
    se_all_imagescDat_ind_c3_c4_beta_stroke_sham_i15_reac se_all_imagescDat_ind_c3_c4_beta_stroke_sham_pos_reac],'.k')
set(gca,'XTick',[1:4],'XTickLabel',{'pre';'i05';'i15';'pos'},'YLim',[0.5 0.7])
ylabel('beta c3-c4 icoh')
title('Stroke Sham Reach')
if p_friedman_all_imagescDat_ind_c3_c4_beta_stroke_sham_reac < 0.05
    text(5,0.7,num2str(p_friedman_all_imagescDat_ind_c3_c4_beta_stroke_sham_reac),'Color','r','Rotation',270)
else
    text(5,0.7,num2str(p_friedman_all_imagescDat_ind_c3_c4_beta_stroke_sham_reac),'Rotation',270)
end

subplot(7,4,13); hold on
bar([mean_all_imagescDat_ind_c3_c4_beta_stroke_sham_pre_hold mean_all_imagescDat_ind_c3_c4_beta_stroke_sham_pre_prep ,...
    mean_all_imagescDat_ind_c3_c4_beta_stroke_sham_pre_reac])
errorbar([mean_all_imagescDat_ind_c3_c4_beta_stroke_sham_pre_hold mean_all_imagescDat_ind_c3_c4_beta_stroke_sham_pre_prep ,...
    mean_all_imagescDat_ind_c3_c4_beta_stroke_sham_pre_reac],...
    [se_all_imagescDat_ind_c3_c4_beta_stroke_sham_pre_hold se_all_imagescDat_ind_c3_c4_beta_stroke_sham_pre_prep ,...
    se_all_imagescDat_ind_c3_c4_beta_stroke_sham_pre_reac],'.k')
set(gca,'XTick',[1:3],'XTickLabel',{'hold';'prep';'reac'},'YLim',[0.5 0.7])
ylabel('beta c3-c4 icoh')
title('Stroke Sham Pre')
if p_friedman_all_imagescDat_ind_c3_c4_beta_stroke_sham_pre < 0.05
    text(4,0.7,num2str(p_friedman_all_imagescDat_ind_c3_c4_beta_stroke_sham_pre),'Color','r','Rotation',270)
else
    text(4,0.7,num2str(p_friedman_all_imagescDat_ind_c3_c4_beta_stroke_sham_pre),'Rotation',270)
end

subplot(7,4,17); hold on
bar([mean_all_imagescDat_ind_c3_c4_beta_stroke_sham_i05_hold mean_all_imagescDat_ind_c3_c4_beta_stroke_sham_i05_prep ,...
    mean_all_imagescDat_ind_c3_c4_beta_stroke_sham_i05_reac])
errorbar([mean_all_imagescDat_ind_c3_c4_beta_stroke_sham_i05_hold mean_all_imagescDat_ind_c3_c4_beta_stroke_sham_i05_prep ,...
    mean_all_imagescDat_ind_c3_c4_beta_stroke_sham_i05_reac],...
    [se_all_imagescDat_ind_c3_c4_beta_stroke_sham_i05_hold se_all_imagescDat_ind_c3_c4_beta_stroke_sham_i05_prep ,...
    se_all_imagescDat_ind_c3_c4_beta_stroke_sham_i05_reac],'.k')
set(gca,'XTick',[1:3],'XTickLabel',{'hold';'prep';'reac'},'YLim',[0.5 0.7])
ylabel('beta c3-c4 icoh')
title('Stroke Sham i05')
if p_friedman_all_imagescDat_ind_c3_c4_beta_stroke_sham_i05 < 0.05
    text(4,0.7,num2str(p_friedman_all_imagescDat_ind_c3_c4_beta_stroke_sham_i05),'Color','r','Rotation',270)
else
    text(4,0.7,num2str(p_friedman_all_imagescDat_ind_c3_c4_beta_stroke_sham_i05),'Rotation',270)
end

subplot(7,4,21); hold on
bar([mean_all_imagescDat_ind_c3_c4_beta_stroke_sham_i15_hold mean_all_imagescDat_ind_c3_c4_beta_stroke_sham_i15_prep ,...
    mean_all_imagescDat_ind_c3_c4_beta_stroke_sham_i15_reac])
errorbar([mean_all_imagescDat_ind_c3_c4_beta_stroke_sham_i15_hold mean_all_imagescDat_ind_c3_c4_beta_stroke_sham_i15_prep ,...
    mean_all_imagescDat_ind_c3_c4_beta_stroke_sham_i15_reac],...
    [se_all_imagescDat_ind_c3_c4_beta_stroke_sham_i15_hold se_all_imagescDat_ind_c3_c4_beta_stroke_sham_i15_prep ,...
    se_all_imagescDat_ind_c3_c4_beta_stroke_sham_i15_reac],'.k')
set(gca,'XTick',[1:3],'XTickLabel',{'hold';'prep';'reac'},'YLim',[0.5 0.7])
ylabel('beta c3-c4 icoh')
title('Stroke Sham i15')
if p_friedman_all_imagescDat_ind_c3_c4_beta_stroke_sham_i15 < 0.05
    text(4,0.7,num2str(p_friedman_all_imagescDat_ind_c3_c4_beta_stroke_sham_i15),'Color','r','Rotation',270)
else
    text(4,0.7,num2str(p_friedman_all_imagescDat_ind_c3_c4_beta_stroke_sham_i15),'Rotation',270)
end

subplot(7,4,25); hold on
bar([mean_all_imagescDat_ind_c3_c4_beta_stroke_sham_pos_hold mean_all_imagescDat_ind_c3_c4_beta_stroke_sham_pos_prep ,...
    mean_all_imagescDat_ind_c3_c4_beta_stroke_sham_pos_reac])
errorbar([mean_all_imagescDat_ind_c3_c4_beta_stroke_sham_pos_hold mean_all_imagescDat_ind_c3_c4_beta_stroke_sham_pos_prep ,...
    mean_all_imagescDat_ind_c3_c4_beta_stroke_sham_pos_reac],...
    [se_all_imagescDat_ind_c3_c4_beta_stroke_sham_pos_hold se_all_imagescDat_ind_c3_c4_beta_stroke_sham_pos_prep ,...
    se_all_imagescDat_ind_c3_c4_beta_stroke_sham_pos_reac],'.k')
set(gca,'XTick',[1:3],'XTickLabel',{'hold';'prep';'reac'},'YLim',[0.5 0.7])
ylabel('beta c3-c4 icoh')
title('Stroke Sham pos')
if p_friedman_all_imagescDat_ind_c3_c4_beta_stroke_sham_pos < 0.05
    text(4,0.7,num2str(p_friedman_all_imagescDat_ind_c3_c4_beta_stroke_sham_pos),'Color','r','Rotation',270)
else
    text(4,0.7,num2str(p_friedman_all_imagescDat_ind_c3_c4_beta_stroke_sham_pos),'Rotation',270)
end

%stroke stim
subplot(7,4,2); hold on
bar([mean_all_imagescDat_ind_c3_c4_beta_stroke_stim_pre_hold mean_all_imagescDat_ind_c3_c4_beta_stroke_stim_i05_hold ,...
    mean_all_imagescDat_ind_c3_c4_beta_stroke_stim_i15_hold mean_all_imagescDat_ind_c3_c4_beta_stroke_stim_pos_hold])
errorbar([mean_all_imagescDat_ind_c3_c4_beta_stroke_stim_pre_hold mean_all_imagescDat_ind_c3_c4_beta_stroke_stim_i05_hold ,...
    mean_all_imagescDat_ind_c3_c4_beta_stroke_stim_i15_hold mean_all_imagescDat_ind_c3_c4_beta_stroke_stim_pos_hold],...
    [se_all_imagescDat_ind_c3_c4_beta_stroke_stim_pre_hold se_all_imagescDat_ind_c3_c4_beta_stroke_stim_i05_hold ,...
    se_all_imagescDat_ind_c3_c4_beta_stroke_stim_i15_hold se_all_imagescDat_ind_c3_c4_beta_stroke_stim_pos_hold],'.k')
set(gca,'XTick',[1:4],'XTickLabel',{'pre';'i05';'i15';'pos'},'YLim',[0.5 0.7])
ylabel('beta c3-c4 icoh')
title('Stroke Stim Hold')
if p_friedman_all_imagescDat_ind_c3_c4_beta_stroke_stim_hold < 0.05
    text(5,0.7,num2str(p_friedman_all_imagescDat_ind_c3_c4_beta_stroke_stim_hold),'Color','r','Rotation',270)
else
    text(5,0.7,num2str(p_friedman_all_imagescDat_ind_c3_c4_beta_stroke_stim_hold),'Rotation',270)
end

subplot(7,4,6); hold on
bar([mean_all_imagescDat_ind_c3_c4_beta_stroke_stim_pre_prep mean_all_imagescDat_ind_c3_c4_beta_stroke_stim_i05_prep ,...
    mean_all_imagescDat_ind_c3_c4_beta_stroke_stim_i15_prep mean_all_imagescDat_ind_c3_c4_beta_stroke_stim_pos_prep])
errorbar([mean_all_imagescDat_ind_c3_c4_beta_stroke_stim_pre_prep mean_all_imagescDat_ind_c3_c4_beta_stroke_stim_i05_prep ,...
    mean_all_imagescDat_ind_c3_c4_beta_stroke_stim_i15_prep mean_all_imagescDat_ind_c3_c4_beta_stroke_stim_pos_prep],...
    [se_all_imagescDat_ind_c3_c4_beta_stroke_stim_pre_prep se_all_imagescDat_ind_c3_c4_beta_stroke_stim_i05_prep ,...
    se_all_imagescDat_ind_c3_c4_beta_stroke_stim_i15_prep se_all_imagescDat_ind_c3_c4_beta_stroke_stim_pos_prep],'.k')
set(gca,'XTick',[1:4],'XTickLabel',{'pre';'i05';'i15';'pos'},'YLim',[0.5 0.7])
ylabel('beta c3-c4 icoh')
title('Stroke Stim Prep')
if p_friedman_all_imagescDat_ind_c3_c4_beta_stroke_stim_prep < 0.05
    text(5,0.7,num2str(p_friedman_all_imagescDat_ind_c3_c4_beta_stroke_stim_prep),'Color','r','Rotation',270)
else
    text(5,0.7,num2str(p_friedman_all_imagescDat_ind_c3_c4_beta_stroke_stim_prep),'Rotation',270)
end

subplot(7,4,10); hold on
bar([mean_all_imagescDat_ind_c3_c4_beta_stroke_stim_pre_reac mean_all_imagescDat_ind_c3_c4_beta_stroke_stim_i05_reac ,...
    mean_all_imagescDat_ind_c3_c4_beta_stroke_stim_i15_reac mean_all_imagescDat_ind_c3_c4_beta_stroke_stim_pos_reac])
errorbar([mean_all_imagescDat_ind_c3_c4_beta_stroke_stim_pre_reac mean_all_imagescDat_ind_c3_c4_beta_stroke_stim_i05_reac ,...
    mean_all_imagescDat_ind_c3_c4_beta_stroke_stim_i15_reac mean_all_imagescDat_ind_c3_c4_beta_stroke_stim_pos_reac],...
    [se_all_imagescDat_ind_c3_c4_beta_stroke_stim_pre_reac se_all_imagescDat_ind_c3_c4_beta_stroke_stim_i05_reac ,...
    se_all_imagescDat_ind_c3_c4_beta_stroke_stim_i15_reac se_all_imagescDat_ind_c3_c4_beta_stroke_stim_pos_reac],'.k')
set(gca,'XTick',[1:4],'XTickLabel',{'pre';'i05';'i15';'pos'},'YLim',[0.5 0.7])
ylabel('beta c3-c4 icoh')
title('Stroke Stim Reach')
if p_friedman_all_imagescDat_ind_c3_c4_beta_stroke_stim_reac < 0.05
    text(5,0.7,num2str(p_friedman_all_imagescDat_ind_c3_c4_beta_stroke_stim_reac),'Color','r','Rotation',270)
else
    text(5,0.7,num2str(p_friedman_all_imagescDat_ind_c3_c4_beta_stroke_stim_reac),'Rotation',270)
end
                   
subplot(7,4,14); hold on
bar([mean_all_imagescDat_ind_c3_c4_beta_stroke_stim_pre_hold mean_all_imagescDat_ind_c3_c4_beta_stroke_stim_pre_prep ,...
    mean_all_imagescDat_ind_c3_c4_beta_stroke_stim_pre_reac])
errorbar([mean_all_imagescDat_ind_c3_c4_beta_stroke_stim_pre_hold mean_all_imagescDat_ind_c3_c4_beta_stroke_stim_pre_prep ,...
    mean_all_imagescDat_ind_c3_c4_beta_stroke_stim_pre_reac],...
    [se_all_imagescDat_ind_c3_c4_beta_stroke_stim_pre_hold se_all_imagescDat_ind_c3_c4_beta_stroke_stim_pre_prep ,...
    se_all_imagescDat_ind_c3_c4_beta_stroke_stim_pre_reac],'.k')
set(gca,'XTick',[1:3],'XTickLabel',{'hold';'prep';'reac'},'YLim',[0.5 0.7])
ylabel('beta c3-c4 icoh')
title('Stroke Stim Pre')
if p_friedman_all_imagescDat_ind_c3_c4_beta_stroke_stim_pre < 0.05
    text(4,0.7,num2str(p_friedman_all_imagescDat_ind_c3_c4_beta_stroke_stim_pre),'Color','r','Rotation',270)
else
    text(4,0.7,num2str(p_friedman_all_imagescDat_ind_c3_c4_beta_stroke_stim_pre),'Rotation',270)
end

subplot(7,4,18); hold on
bar([mean_all_imagescDat_ind_c3_c4_beta_stroke_stim_i05_hold mean_all_imagescDat_ind_c3_c4_beta_stroke_stim_i05_prep ,...
    mean_all_imagescDat_ind_c3_c4_beta_stroke_stim_i05_reac])
errorbar([mean_all_imagescDat_ind_c3_c4_beta_stroke_stim_i05_hold mean_all_imagescDat_ind_c3_c4_beta_stroke_stim_i05_prep ,...
    mean_all_imagescDat_ind_c3_c4_beta_stroke_stim_i05_reac],...
    [se_all_imagescDat_ind_c3_c4_beta_stroke_stim_i05_hold se_all_imagescDat_ind_c3_c4_beta_stroke_stim_i05_prep ,...
    se_all_imagescDat_ind_c3_c4_beta_stroke_stim_i05_reac],'.k')
set(gca,'XTick',[1:3],'XTickLabel',{'hold';'prep';'reac'},'YLim',[0.5 0.7])
ylabel('beta c3-c4 icoh')
title('Stroke Stim i05')
if p_friedman_all_imagescDat_ind_c3_c4_beta_stroke_stim_i05 < 0.05
    text(4,0.7,num2str(p_friedman_all_imagescDat_ind_c3_c4_beta_stroke_stim_i05),'Color','r','Rotation',270)
else
    text(4,0.7,num2str(p_friedman_all_imagescDat_ind_c3_c4_beta_stroke_stim_i05),'Rotation',270)
end

subplot(7,4,22); hold on
bar([mean_all_imagescDat_ind_c3_c4_beta_stroke_stim_i15_hold mean_all_imagescDat_ind_c3_c4_beta_stroke_stim_i15_prep ,...
    mean_all_imagescDat_ind_c3_c4_beta_stroke_stim_i15_reac])
errorbar([mean_all_imagescDat_ind_c3_c4_beta_stroke_stim_i15_hold mean_all_imagescDat_ind_c3_c4_beta_stroke_stim_i15_prep ,...
    mean_all_imagescDat_ind_c3_c4_beta_stroke_stim_i15_reac],...
    [se_all_imagescDat_ind_c3_c4_beta_stroke_stim_i15_hold se_all_imagescDat_ind_c3_c4_beta_stroke_stim_i15_prep ,...
    se_all_imagescDat_ind_c3_c4_beta_stroke_stim_i15_reac],'.k')
set(gca,'XTick',[1:3],'XTickLabel',{'hold';'prep';'reac'},'YLim',[0.5 0.7])
ylabel('beta c3-c4 icoh')
title('Stroke Stim i15')
if p_friedman_all_imagescDat_ind_c3_c4_beta_stroke_stim_i15 < 0.05
    text(4,0.7,num2str(p_friedman_all_imagescDat_ind_c3_c4_beta_stroke_stim_i15),'Color','r','Rotation',270)
else
    text(4,0.7,num2str(p_friedman_all_imagescDat_ind_c3_c4_beta_stroke_stim_i15),'Rotation',270)
end

subplot(7,4,26); hold on
bar([mean_all_imagescDat_ind_c3_c4_beta_stroke_stim_pos_hold mean_all_imagescDat_ind_c3_c4_beta_stroke_stim_pos_prep ,...
    mean_all_imagescDat_ind_c3_c4_beta_stroke_stim_pos_reac])
errorbar([mean_all_imagescDat_ind_c3_c4_beta_stroke_stim_pos_hold mean_all_imagescDat_ind_c3_c4_beta_stroke_stim_pos_prep ,...
    mean_all_imagescDat_ind_c3_c4_beta_stroke_stim_pos_reac],...
    [se_all_imagescDat_ind_c3_c4_beta_stroke_stim_pos_hold se_all_imagescDat_ind_c3_c4_beta_stroke_stim_pos_prep ,...
    se_all_imagescDat_ind_c3_c4_beta_stroke_stim_pos_reac],'.k')
set(gca,'XTick',[1:3],'XTickLabel',{'hold';'prep';'reac'},'YLim',[0.5 0.7])
ylabel('beta c3-c4 icoh')
title('Stroke Stim pos')
if p_friedman_all_imagescDat_ind_c3_c4_beta_stroke_stim_pos < 0.05
    text(4,0.7,num2str(p_friedman_all_imagescDat_ind_c3_c4_beta_stroke_stim_pos),'Color','r','Rotation',270)
else
    text(4,0.7,num2str(p_friedman_all_imagescDat_ind_c3_c4_beta_stroke_stim_pos),'Rotation',270)
end


%healthy sham
subplot(7,4,3); hold on
bar([mean_all_imagescDat_ind_c3_c4_beta_healthy_sham_pre_hold mean_all_imagescDat_ind_c3_c4_beta_healthy_sham_i05_hold ,...
    mean_all_imagescDat_ind_c3_c4_beta_healthy_sham_i15_hold mean_all_imagescDat_ind_c3_c4_beta_healthy_sham_pos_hold])
errorbar([mean_all_imagescDat_ind_c3_c4_beta_healthy_sham_pre_hold mean_all_imagescDat_ind_c3_c4_beta_healthy_sham_i05_hold ,...
    mean_all_imagescDat_ind_c3_c4_beta_healthy_sham_i15_hold mean_all_imagescDat_ind_c3_c4_beta_healthy_sham_pos_hold],...
    [se_all_imagescDat_ind_c3_c4_beta_healthy_sham_pre_hold se_all_imagescDat_ind_c3_c4_beta_healthy_sham_i05_hold ,...
    se_all_imagescDat_ind_c3_c4_beta_healthy_sham_i15_hold se_all_imagescDat_ind_c3_c4_beta_healthy_sham_pos_hold],'.k')
set(gca,'XTick',[1:4],'XTickLabel',{'pre';'i05';'i15';'pos'},'YLim',[0.5 0.7])
ylabel('beta c3-c4 icoh')
title('Healthy Sham Hold')
if p_friedman_all_imagescDat_ind_c3_c4_beta_healthy_sham_hold < 0.05
    text(5,0.7,num2str(p_friedman_all_imagescDat_ind_c3_c4_beta_healthy_sham_hold),'Color','r','Rotation',270)
else
    text(5,0.7,num2str(p_friedman_all_imagescDat_ind_c3_c4_beta_healthy_sham_hold),'Rotation',270)
end

subplot(7,4,7); hold on
bar([mean_all_imagescDat_ind_c3_c4_beta_healthy_sham_pre_prep mean_all_imagescDat_ind_c3_c4_beta_healthy_sham_i05_prep ,...
    mean_all_imagescDat_ind_c3_c4_beta_healthy_sham_i15_prep mean_all_imagescDat_ind_c3_c4_beta_healthy_sham_pos_prep])
errorbar([mean_all_imagescDat_ind_c3_c4_beta_healthy_sham_pre_prep mean_all_imagescDat_ind_c3_c4_beta_healthy_sham_i05_prep ,...
    mean_all_imagescDat_ind_c3_c4_beta_healthy_sham_i15_prep mean_all_imagescDat_ind_c3_c4_beta_healthy_sham_pos_prep],...
    [se_all_imagescDat_ind_c3_c4_beta_healthy_sham_pre_prep se_all_imagescDat_ind_c3_c4_beta_healthy_sham_i05_prep ,...
    se_all_imagescDat_ind_c3_c4_beta_healthy_sham_i15_prep se_all_imagescDat_ind_c3_c4_beta_healthy_sham_pos_prep],'.k')
set(gca,'XTick',[1:4],'XTickLabel',{'pre';'i05';'i15';'pos'},'YLim',[0.5 0.7])
ylabel('beta c3-c4 icoh')
title('Healthy Sham Prep')
if p_friedman_all_imagescDat_ind_c3_c4_beta_healthy_sham_prep < 0.05
    text(5,0.7,num2str(p_friedman_all_imagescDat_ind_c3_c4_beta_healthy_sham_prep),'Color','r','Rotation',270)
else
    text(5,0.7,num2str(p_friedman_all_imagescDat_ind_c3_c4_beta_healthy_sham_prep),'Rotation',270)
end

subplot(7,4,11); hold on
bar([mean_all_imagescDat_ind_c3_c4_beta_healthy_sham_pre_reac mean_all_imagescDat_ind_c3_c4_beta_healthy_sham_i05_reac ,...
    mean_all_imagescDat_ind_c3_c4_beta_healthy_sham_i15_reac mean_all_imagescDat_ind_c3_c4_beta_healthy_sham_pos_reac])
errorbar([mean_all_imagescDat_ind_c3_c4_beta_healthy_sham_pre_reac mean_all_imagescDat_ind_c3_c4_beta_healthy_sham_i05_reac ,...
    mean_all_imagescDat_ind_c3_c4_beta_healthy_sham_i15_reac mean_all_imagescDat_ind_c3_c4_beta_healthy_sham_pos_reac],...
    [se_all_imagescDat_ind_c3_c4_beta_healthy_sham_pre_reac se_all_imagescDat_ind_c3_c4_beta_healthy_sham_i05_reac ,...
    se_all_imagescDat_ind_c3_c4_beta_healthy_sham_i15_reac se_all_imagescDat_ind_c3_c4_beta_healthy_sham_pos_reac],'.k')
set(gca,'XTick',[1:4],'XTickLabel',{'pre';'i05';'i15';'pos'},'YLim',[0.5 0.7])
ylabel('beta c3-c4 icoh')
title('Healthy Sham Reach')
if p_friedman_all_imagescDat_ind_c3_c4_beta_healthy_sham_reac < 0.05
    text(5,0.7,num2str(p_friedman_all_imagescDat_ind_c3_c4_beta_healthy_sham_reac),'Color','r','Rotation',270)
else
    text(5,0.7,num2str(p_friedman_all_imagescDat_ind_c3_c4_beta_healthy_sham_reac),'Rotation',270)
end

subplot(7,4,15); hold on
bar([mean_all_imagescDat_ind_c3_c4_beta_healthy_sham_pre_hold mean_all_imagescDat_ind_c3_c4_beta_healthy_sham_pre_prep ,...
    mean_all_imagescDat_ind_c3_c4_beta_healthy_sham_pre_reac])
errorbar([mean_all_imagescDat_ind_c3_c4_beta_healthy_sham_pre_hold mean_all_imagescDat_ind_c3_c4_beta_healthy_sham_pre_prep ,...
    mean_all_imagescDat_ind_c3_c4_beta_healthy_sham_pre_reac],...
    [se_all_imagescDat_ind_c3_c4_beta_healthy_sham_pre_hold se_all_imagescDat_ind_c3_c4_beta_healthy_sham_pre_prep ,...
    se_all_imagescDat_ind_c3_c4_beta_healthy_sham_pre_reac],'.k')
set(gca,'XTick',[1:3],'XTickLabel',{'hold';'prep';'reac'},'YLim',[0.5 0.7])
ylabel('beta c3-c4 icoh')
title('Healthy Sham Pre')
if p_friedman_all_imagescDat_ind_c3_c4_beta_healthy_sham_pre < 0.05
    text(4,0.7,num2str(p_friedman_all_imagescDat_ind_c3_c4_beta_healthy_sham_pre),'Color','r','Rotation',270)
else
    text(4,0.7,num2str(p_friedman_all_imagescDat_ind_c3_c4_beta_healthy_sham_pre),'Rotation',270)
end

subplot(7,4,19); hold on
bar([mean_all_imagescDat_ind_c3_c4_beta_healthy_sham_i05_hold mean_all_imagescDat_ind_c3_c4_beta_healthy_sham_i05_prep ,...
    mean_all_imagescDat_ind_c3_c4_beta_healthy_sham_i05_reac])
errorbar([mean_all_imagescDat_ind_c3_c4_beta_healthy_sham_i05_hold mean_all_imagescDat_ind_c3_c4_beta_healthy_sham_i05_prep ,...
    mean_all_imagescDat_ind_c3_c4_beta_healthy_sham_i05_reac],...
    [se_all_imagescDat_ind_c3_c4_beta_healthy_sham_i05_hold se_all_imagescDat_ind_c3_c4_beta_healthy_sham_i05_prep ,...
    se_all_imagescDat_ind_c3_c4_beta_healthy_sham_i05_reac],'.k')
set(gca,'XTick',[1:3],'XTickLabel',{'hold';'prep';'reac'},'YLim',[0.5 0.7])
ylabel('beta c3-c4 icoh')
title('Healthy Sham i05')
if p_friedman_all_imagescDat_ind_c3_c4_beta_healthy_sham_i05 < 0.05
    text(4,0.7,num2str(p_friedman_all_imagescDat_ind_c3_c4_beta_healthy_sham_i05),'Color','r','Rotation',270)
else
    text(4,0.7,num2str(p_friedman_all_imagescDat_ind_c3_c4_beta_healthy_sham_i05),'Rotation',270)
end

subplot(7,4,23); hold on
bar([mean_all_imagescDat_ind_c3_c4_beta_healthy_sham_i15_hold mean_all_imagescDat_ind_c3_c4_beta_healthy_sham_i15_prep ,...
    mean_all_imagescDat_ind_c3_c4_beta_healthy_sham_i15_reac])
errorbar([mean_all_imagescDat_ind_c3_c4_beta_healthy_sham_i15_hold mean_all_imagescDat_ind_c3_c4_beta_healthy_sham_i15_prep ,...
    mean_all_imagescDat_ind_c3_c4_beta_healthy_sham_i15_reac],...
    [se_all_imagescDat_ind_c3_c4_beta_healthy_sham_i15_hold se_all_imagescDat_ind_c3_c4_beta_healthy_sham_i15_prep ,...
    se_all_imagescDat_ind_c3_c4_beta_healthy_sham_i15_reac],'.k')
set(gca,'XTick',[1:3],'XTickLabel',{'hold';'prep';'reac'},'YLim',[0.5 0.7])
ylabel('beta c3-c4 icoh')
title('Healthy Sham i15')
if p_friedman_all_imagescDat_ind_c3_c4_beta_healthy_sham_i15 < 0.05
    text(4,0.7,num2str(p_friedman_all_imagescDat_ind_c3_c4_beta_healthy_sham_i15),'Color','r','Rotation',270)
else
    text(4,0.7,num2str(p_friedman_all_imagescDat_ind_c3_c4_beta_healthy_sham_i15),'Rotation',270)
end

subplot(7,4,27); hold on
bar([mean_all_imagescDat_ind_c3_c4_beta_healthy_sham_pos_hold mean_all_imagescDat_ind_c3_c4_beta_healthy_sham_pos_prep ,...
    mean_all_imagescDat_ind_c3_c4_beta_healthy_sham_pos_reac])
errorbar([mean_all_imagescDat_ind_c3_c4_beta_healthy_sham_pos_hold mean_all_imagescDat_ind_c3_c4_beta_healthy_sham_pos_prep ,...
    mean_all_imagescDat_ind_c3_c4_beta_healthy_sham_pos_reac],...
    [se_all_imagescDat_ind_c3_c4_beta_healthy_sham_pos_hold se_all_imagescDat_ind_c3_c4_beta_healthy_sham_pos_prep ,...
    se_all_imagescDat_ind_c3_c4_beta_healthy_sham_pos_reac],'.k')
set(gca,'XTick',[1:3],'XTickLabel',{'hold';'prep';'reac'},'YLim',[0.5 0.7])
ylabel('beta c3-c4 icoh')
title('Healthy Sham pos')
if p_friedman_all_imagescDat_ind_c3_c4_beta_healthy_sham_pos < 0.05
    text(4,0.7,num2str(p_friedman_all_imagescDat_ind_c3_c4_beta_healthy_sham_pos),'Color','r','Rotation',270)
else
    text(4,0.7,num2str(p_friedman_all_imagescDat_ind_c3_c4_beta_healthy_sham_pos),'Rotation',270)
end


%healthy stim
subplot(7,4,4); hold on
bar([mean_all_imagescDat_ind_c3_c4_beta_healthy_stim_pre_hold mean_all_imagescDat_ind_c3_c4_beta_healthy_stim_i05_hold ,...
    mean_all_imagescDat_ind_c3_c4_beta_healthy_stim_i15_hold mean_all_imagescDat_ind_c3_c4_beta_healthy_stim_pos_hold])
errorbar([mean_all_imagescDat_ind_c3_c4_beta_healthy_stim_pre_hold mean_all_imagescDat_ind_c3_c4_beta_healthy_stim_i05_hold ,...
    mean_all_imagescDat_ind_c3_c4_beta_healthy_stim_i15_hold mean_all_imagescDat_ind_c3_c4_beta_healthy_stim_pos_hold],...
    [se_all_imagescDat_ind_c3_c4_beta_healthy_stim_pre_hold se_all_imagescDat_ind_c3_c4_beta_healthy_stim_i05_hold ,...
    se_all_imagescDat_ind_c3_c4_beta_healthy_stim_i15_hold se_all_imagescDat_ind_c3_c4_beta_healthy_stim_pos_hold],'.k')
set(gca,'XTick',[1:4],'XTickLabel',{'pre';'i05';'i15';'pos'},'YLim',[0.5 0.7])
ylabel('beta c3-c4 icoh')
title('Healthy Stim Hold')
if p_friedman_all_imagescDat_ind_c3_c4_beta_healthy_stim_hold < 0.05
    text(5,0.7,num2str(p_friedman_all_imagescDat_ind_c3_c4_beta_healthy_stim_hold),'Color','r','Rotation',270)
else
    text(5,0.7,num2str(p_friedman_all_imagescDat_ind_c3_c4_beta_healthy_stim_hold),'Rotation',270)
end

subplot(7,4,8); hold on
bar([mean_all_imagescDat_ind_c3_c4_beta_healthy_stim_pre_prep mean_all_imagescDat_ind_c3_c4_beta_healthy_stim_i05_prep ,...
    mean_all_imagescDat_ind_c3_c4_beta_healthy_stim_i15_prep mean_all_imagescDat_ind_c3_c4_beta_healthy_stim_pos_prep])
errorbar([mean_all_imagescDat_ind_c3_c4_beta_healthy_stim_pre_prep mean_all_imagescDat_ind_c3_c4_beta_healthy_stim_i05_prep ,...
    mean_all_imagescDat_ind_c3_c4_beta_healthy_stim_i15_prep mean_all_imagescDat_ind_c3_c4_beta_healthy_stim_pos_prep],...
    [se_all_imagescDat_ind_c3_c4_beta_healthy_stim_pre_prep se_all_imagescDat_ind_c3_c4_beta_healthy_stim_i05_prep ,...
    se_all_imagescDat_ind_c3_c4_beta_healthy_stim_i15_prep se_all_imagescDat_ind_c3_c4_beta_healthy_stim_pos_prep],'.k')
set(gca,'XTick',[1:4],'XTickLabel',{'pre';'i05';'i15';'pos'},'YLim',[0.5 0.7])
ylabel('beta c3-c4 icoh')
title('Healthy Stim Prep')
if p_friedman_all_imagescDat_ind_c3_c4_beta_healthy_stim_prep < 0.05
    text(5,0.7,num2str(p_friedman_all_imagescDat_ind_c3_c4_beta_healthy_stim_prep),'Color','r','Rotation',270)
else
    text(5,0.7,num2str(p_friedman_all_imagescDat_ind_c3_c4_beta_healthy_stim_prep),'Rotation',270)
end

subplot(7,4,12); hold on
bar([mean_all_imagescDat_ind_c3_c4_beta_healthy_stim_pre_reac mean_all_imagescDat_ind_c3_c4_beta_healthy_stim_i05_reac ,...
    mean_all_imagescDat_ind_c3_c4_beta_healthy_stim_i15_reac mean_all_imagescDat_ind_c3_c4_beta_healthy_stim_pos_reac])
errorbar([mean_all_imagescDat_ind_c3_c4_beta_healthy_stim_pre_reac mean_all_imagescDat_ind_c3_c4_beta_healthy_stim_i05_reac ,...
    mean_all_imagescDat_ind_c3_c4_beta_healthy_stim_i15_reac mean_all_imagescDat_ind_c3_c4_beta_healthy_stim_pos_reac],...
    [se_all_imagescDat_ind_c3_c4_beta_healthy_stim_pre_reac se_all_imagescDat_ind_c3_c4_beta_healthy_stim_i05_reac ,...
    se_all_imagescDat_ind_c3_c4_beta_healthy_stim_i15_reac se_all_imagescDat_ind_c3_c4_beta_healthy_stim_pos_reac],'.k')
set(gca,'XTick',[1:4],'XTickLabel',{'pre';'i05';'i15';'pos'},'YLim',[0.5 0.7])
ylabel('beta c3-c4 icoh')
title('Healthy Stim Reach')
if p_friedman_all_imagescDat_ind_c3_c4_beta_healthy_stim_reac < 0.05
    text(5,0.7,num2str(p_friedman_all_imagescDat_ind_c3_c4_beta_healthy_stim_reac),'Color','r','Rotation',270)
else
    text(5,0.7,num2str(p_friedman_all_imagescDat_ind_c3_c4_beta_healthy_stim_reac),'Rotation',270)
end

subplot(7,4,16); hold on
bar([mean_all_imagescDat_ind_c3_c4_beta_healthy_stim_pre_hold mean_all_imagescDat_ind_c3_c4_beta_healthy_stim_pre_prep ,...
    mean_all_imagescDat_ind_c3_c4_beta_healthy_stim_pre_reac])
errorbar([mean_all_imagescDat_ind_c3_c4_beta_healthy_stim_pre_hold mean_all_imagescDat_ind_c3_c4_beta_healthy_stim_pre_prep ,...
    mean_all_imagescDat_ind_c3_c4_beta_healthy_stim_pre_reac],...
    [se_all_imagescDat_ind_c3_c4_beta_healthy_stim_pre_hold se_all_imagescDat_ind_c3_c4_beta_healthy_stim_pre_prep ,...
    se_all_imagescDat_ind_c3_c4_beta_healthy_stim_pre_reac],'.k')
set(gca,'XTick',[1:3],'XTickLabel',{'hold';'prep';'reac'},'YLim',[0.5 0.7])
ylabel('beta c3-c4 icoh')
title('Healthy Stim Pre')
if p_friedman_all_imagescDat_ind_c3_c4_beta_healthy_stim_pre < 0.05
    text(4,0.7,num2str(p_friedman_all_imagescDat_ind_c3_c4_beta_healthy_stim_pre),'Color','r','Rotation',270)
else
    text(4,0.7,num2str(p_friedman_all_imagescDat_ind_c3_c4_beta_healthy_stim_pre),'Rotation',270)
end

subplot(7,4,20); hold on
bar([mean_all_imagescDat_ind_c3_c4_beta_healthy_stim_i05_hold mean_all_imagescDat_ind_c3_c4_beta_healthy_stim_i05_prep ,...
    mean_all_imagescDat_ind_c3_c4_beta_healthy_stim_i05_reac])
errorbar([mean_all_imagescDat_ind_c3_c4_beta_healthy_stim_i05_hold mean_all_imagescDat_ind_c3_c4_beta_healthy_stim_i05_prep ,...
    mean_all_imagescDat_ind_c3_c4_beta_healthy_stim_i05_reac],...
    [se_all_imagescDat_ind_c3_c4_beta_healthy_stim_i05_hold se_all_imagescDat_ind_c3_c4_beta_healthy_stim_i05_prep ,...
    se_all_imagescDat_ind_c3_c4_beta_healthy_stim_i05_reac],'.k')
set(gca,'XTick',[1:3],'XTickLabel',{'hold';'prep';'reac'},'YLim',[0.5 0.7])
ylabel('beta c3-c4 icoh')
title('Healthy Stim i05')
if p_friedman_all_imagescDat_ind_c3_c4_beta_healthy_stim_i05 < 0.05
    text(4,0.7,num2str(p_friedman_all_imagescDat_ind_c3_c4_beta_healthy_stim_i05),'Color','r','Rotation',270)
else
    text(4,0.7,num2str(p_friedman_all_imagescDat_ind_c3_c4_beta_healthy_stim_i05),'Rotation',270)
end

subplot(7,4,24); hold on
bar([mean_all_imagescDat_ind_c3_c4_beta_healthy_stim_i15_hold mean_all_imagescDat_ind_c3_c4_beta_healthy_stim_i15_prep ,...
    mean_all_imagescDat_ind_c3_c4_beta_healthy_stim_i15_reac])
errorbar([mean_all_imagescDat_ind_c3_c4_beta_healthy_stim_i15_hold mean_all_imagescDat_ind_c3_c4_beta_healthy_stim_i15_prep ,...
    mean_all_imagescDat_ind_c3_c4_beta_healthy_stim_i15_reac],...
    [se_all_imagescDat_ind_c3_c4_beta_healthy_stim_i15_hold se_all_imagescDat_ind_c3_c4_beta_healthy_stim_i15_prep ,...
    se_all_imagescDat_ind_c3_c4_beta_healthy_stim_i15_reac],'.k')
set(gca,'XTick',[1:3],'XTickLabel',{'hold';'prep';'reac'},'YLim',[0.5 0.7])
ylabel('beta c3-c4 icoh')
title('Healthy Stim i15')
if p_friedman_all_imagescDat_ind_c3_c4_beta_healthy_stim_i15 < 0.05
    text(4,0.7,num2str(p_friedman_all_imagescDat_ind_c3_c4_beta_healthy_stim_i15),'Color','r','Rotation',270)
else
    text(4,0.7,num2str(p_friedman_all_imagescDat_ind_c3_c4_beta_healthy_stim_i15),'Rotation',270)
end

subplot(7,4,28); hold on
bar([mean_all_imagescDat_ind_c3_c4_beta_healthy_stim_pos_hold mean_all_imagescDat_ind_c3_c4_beta_healthy_stim_pos_prep ,...
    mean_all_imagescDat_ind_c3_c4_beta_healthy_stim_pos_reac])
errorbar([mean_all_imagescDat_ind_c3_c4_beta_healthy_stim_pos_hold mean_all_imagescDat_ind_c3_c4_beta_healthy_stim_pos_prep ,...
    mean_all_imagescDat_ind_c3_c4_beta_healthy_stim_pos_reac],...
    [se_all_imagescDat_ind_c3_c4_beta_healthy_stim_pos_hold se_all_imagescDat_ind_c3_c4_beta_healthy_stim_pos_prep ,...
    se_all_imagescDat_ind_c3_c4_beta_healthy_stim_pos_reac],'.k')
set(gca,'XTick',[1:3],'XTickLabel',{'hold';'prep';'reac'},'YLim',[0.5 0.7])
ylabel('beta c3-c4 icoh')
title('Healthy Stim pos')
if p_friedman_all_imagescDat_ind_c3_c4_beta_healthy_stim_pos < 0.05
    text(4,0.7,num2str(p_friedman_all_imagescDat_ind_c3_c4_beta_healthy_stim_pos),'Color','r','Rotation',270)
else
    text(4,0.7,num2str(p_friedman_all_imagescDat_ind_c3_c4_beta_healthy_stim_pos),'Rotation',270)
end

%stats - friedman
%across stimtype
for i=1:size(distype,1)
    %for j=1:size(stimtype,1)
        for k=1:size(timetype,1)
            for l=1:size(phasetype,1)
                eval(['[p_rank_all_imagescDat_ind_c3_c4_beta_',distype{i},'_',timetype{k},'_',phasetype{l},',',...
                    'tab_rank_all_imagescDat_ind_c3_c4_beta_',distype{i},'_',timetype{k},'_',phasetype{l},',',...
                    'stats_rank_all_imagescDat_ind_c3_c4_beta_',distype{i},'_',timetype{k},'_',phasetype{l},']',...
                    '=ranksum(all_imagescDat_ind_c3_c4_beta_',distype{i},'_sham_',timetype{k},'_',phasetype{l},',',...
                              'all_imagescDat_ind_c3_c4_beta_',distype{i},'_stim_',timetype{k},'_',phasetype{l},');'])
%                 eval(['mc_rank_all_imagescDat_ind_c3_c4_beta_',distype{i},'_',timetype{k},'_',phasetype{l},...
%                       '=multcompare(stats_rank_all_imagescDat_ind_c3_c4_beta_',distype{i},'_',timetype{k},'_',phasetype{l},')'])
%                           
%                 eval(['se_all_imagescDat_ind_c3_c4_beta_',distype{i},'_',stimtype{j},'_',timetype{k},'_',phasetype{l},...
%                     '=std(all_imagescDat_ind_c3_c4_beta_',distype{i},'_',stimtype{j},'_',timetype{k},'_',phasetype{l},')',...
%                     '/sqrt(size(all_imagescDat_ind_c3_c4_beta_',distype{i},'_',stimtype{j},'_',timetype{k},'_',phasetype{l},',2))'])
            end
        end
    %end
end

%for i=1:size(distype,1)
    for j=1:size(stimtype,1)
        for k=1:size(timetype,1)
            for l=1:size(phasetype,1)
                eval(['[p_rank_all_imagescDat_ind_c3_c4_beta_',stimtype{j},'_',timetype{k},'_',phasetype{l},',',...
                    'tab_rank_all_imagescDat_ind_c3_c4_beta_',stimtype{j},'_',timetype{k},'_',phasetype{l},',',...
                    'stats_rank_all_imagescDat_ind_c3_c4_beta_',stimtype{j},'_',timetype{k},'_',phasetype{l},']',...
                    '=ranksum(all_imagescDat_ind_c3_c4_beta_healthy','_',stimtype{j},'_',timetype{k},'_',phasetype{l},',',...
                              'all_imagescDat_ind_c3_c4_beta_stroke','_',stimtype{j},'_',timetype{k},'_',phasetype{l},');'])
%                 eval(['mc_rank_all_imagescDat_ind_c3_c4_beta_',distype{i},'_',timetype{k},'_',phasetype{l},...
%                       '=multcompare(stats_rank_all_imagescDat_ind_c3_c4_beta_',distype{i},'_',timetype{k},'_',phasetype{l},')'])
%                           
%                 eval(['se_all_imagescDat_ind_c3_c4_beta_',distype{i},'_',stimtype{j},'_',timetype{k},'_',phasetype{l},...
%                     '=std(all_imagescDat_ind_c3_c4_beta_',distype{i},'_',stimtype{j},'_',timetype{k},'_',phasetype{l},')',...
%                     '/sqrt(size(all_imagescDat_ind_c3_c4_beta_',distype{i},'_',stimtype{j},'_',timetype{k},'_',phasetype{l},',2))'])
            end
        end
    end
%end

 
figure; set(gcf,'Position',[2133 109 1214 834])
%stroke
subplot(7,4,1); hold on
     bar([1,4,7,10],[mean_all_imagescDat_ind_c3_c4_beta_stroke_sham_pre_hold,...  
                     mean_all_imagescDat_ind_c3_c4_beta_stroke_sham_i05_hold,... 
                     mean_all_imagescDat_ind_c3_c4_beta_stroke_sham_i15_hold,... 
                     mean_all_imagescDat_ind_c3_c4_beta_stroke_sham_pos_hold],0.2)
errorbar([1,4,7,10],[mean_all_imagescDat_ind_c3_c4_beta_stroke_sham_pre_hold,...  
                     mean_all_imagescDat_ind_c3_c4_beta_stroke_sham_i05_hold,... 
                     mean_all_imagescDat_ind_c3_c4_beta_stroke_sham_i15_hold,... 
                     mean_all_imagescDat_ind_c3_c4_beta_stroke_sham_pos_hold],...
                      [se_all_imagescDat_ind_c3_c4_beta_stroke_sham_pre_hold,...  
                       se_all_imagescDat_ind_c3_c4_beta_stroke_sham_i05_hold,... 
                       se_all_imagescDat_ind_c3_c4_beta_stroke_sham_i15_hold,... 
                       se_all_imagescDat_ind_c3_c4_beta_stroke_sham_pos_hold],'.k')
     bar([2,5,8,11],[mean_all_imagescDat_ind_c3_c4_beta_stroke_stim_pre_hold,...  
                     mean_all_imagescDat_ind_c3_c4_beta_stroke_stim_i05_hold,... 
                     mean_all_imagescDat_ind_c3_c4_beta_stroke_stim_i15_hold,... 
                     mean_all_imagescDat_ind_c3_c4_beta_stroke_stim_pos_hold],0.2)
errorbar([2,5,8,11],[mean_all_imagescDat_ind_c3_c4_beta_stroke_stim_pre_hold,...  
                     mean_all_imagescDat_ind_c3_c4_beta_stroke_stim_i05_hold,... 
                     mean_all_imagescDat_ind_c3_c4_beta_stroke_stim_i15_hold,... 
                     mean_all_imagescDat_ind_c3_c4_beta_stroke_stim_pos_hold],...
                      [se_all_imagescDat_ind_c3_c4_beta_stroke_stim_pre_hold,...  
                       se_all_imagescDat_ind_c3_c4_beta_stroke_stim_i05_hold,... 
                       se_all_imagescDat_ind_c3_c4_beta_stroke_stim_i15_hold,... 
                       se_all_imagescDat_ind_c3_c4_beta_stroke_stim_pos_hold],'.k')
legend('Sham','','Stim','')
set(gca,'XTick',[1 4 7 10],'XTickLabel',{'pre';'i05';'i15';'pos'},'YLim',[0.5 0.8])
ylabel('beta c3-c4 icoh')
title('Stroke - Hold')
if p_rank_all_imagescDat_ind_c3_c4_beta_stroke_pre_hold<0.05
    text(1.5,0.7,'*','Color','r')
end
if p_rank_all_imagescDat_ind_c3_c4_beta_stroke_i05_hold<0.05
    text(4.5,0.7,'*','Color','r')
end
if p_rank_all_imagescDat_ind_c3_c4_beta_stroke_i15_hold<0.05
    text(7.5,0.7,'*','Color','r')
end
if p_rank_all_imagescDat_ind_c3_c4_beta_stroke_pos_hold<0.05
    text(10.5,0.7,'*','Color','r')
end
   
subplot(7,4,5); hold on
     bar([1,4,7,10],[mean_all_imagescDat_ind_c3_c4_beta_stroke_sham_pre_prep,...  
                     mean_all_imagescDat_ind_c3_c4_beta_stroke_sham_i05_prep,... 
                     mean_all_imagescDat_ind_c3_c4_beta_stroke_sham_i15_prep,... 
                     mean_all_imagescDat_ind_c3_c4_beta_stroke_sham_pos_prep],0.2)
errorbar([1,4,7,10],[mean_all_imagescDat_ind_c3_c4_beta_stroke_sham_pre_prep,...  
                     mean_all_imagescDat_ind_c3_c4_beta_stroke_sham_i05_prep,... 
                     mean_all_imagescDat_ind_c3_c4_beta_stroke_sham_i15_prep,... 
                     mean_all_imagescDat_ind_c3_c4_beta_stroke_sham_pos_prep],...
                      [se_all_imagescDat_ind_c3_c4_beta_stroke_sham_pre_prep,...  
                       se_all_imagescDat_ind_c3_c4_beta_stroke_sham_i05_prep,... 
                       se_all_imagescDat_ind_c3_c4_beta_stroke_sham_i15_prep,... 
                       se_all_imagescDat_ind_c3_c4_beta_stroke_sham_pos_prep],'.k')
     bar([2,5,8,11],[mean_all_imagescDat_ind_c3_c4_beta_stroke_stim_pre_prep,...  
                     mean_all_imagescDat_ind_c3_c4_beta_stroke_stim_i05_prep,... 
                     mean_all_imagescDat_ind_c3_c4_beta_stroke_stim_i15_prep,... 
                     mean_all_imagescDat_ind_c3_c4_beta_stroke_stim_pos_prep],0.2)
errorbar([2,5,8,11],[mean_all_imagescDat_ind_c3_c4_beta_stroke_stim_pre_prep,...  
                     mean_all_imagescDat_ind_c3_c4_beta_stroke_stim_i05_prep,... 
                     mean_all_imagescDat_ind_c3_c4_beta_stroke_stim_i15_prep,... 
                     mean_all_imagescDat_ind_c3_c4_beta_stroke_stim_pos_prep],...
                      [se_all_imagescDat_ind_c3_c4_beta_stroke_stim_pre_prep,...  
                       se_all_imagescDat_ind_c3_c4_beta_stroke_stim_i05_prep,... 
                       se_all_imagescDat_ind_c3_c4_beta_stroke_stim_i15_prep,... 
                       se_all_imagescDat_ind_c3_c4_beta_stroke_stim_pos_prep],'.k')
%legend('Sham','','Stim','')
set(gca,'XTick',[1 4 7 10],'XTickLabel',{'pre';'i05';'i15';'pos'},'YLim',[0.5 0.8])
ylabel('beta c3-c4 icoh')
title('Stroke - Prep')
if p_rank_all_imagescDat_ind_c3_c4_beta_stroke_pre_prep<0.05
    text(1.5,0.7,'*','Color','r')
end
if p_rank_all_imagescDat_ind_c3_c4_beta_stroke_i05_prep<0.05
    text(4.5,0.7,'*','Color','r')
end
if p_rank_all_imagescDat_ind_c3_c4_beta_stroke_i15_prep<0.05
    text(7.5,0.7,'*','Color','r')
end
if p_rank_all_imagescDat_ind_c3_c4_beta_stroke_pos_prep<0.05
    text(10.5,0.7,'*','Color','r')
end

subplot(7,4,9); hold on
     bar([1,4,7,10],[mean_all_imagescDat_ind_c3_c4_beta_stroke_sham_pre_reac,...  
                     mean_all_imagescDat_ind_c3_c4_beta_stroke_sham_i05_reac,... 
                     mean_all_imagescDat_ind_c3_c4_beta_stroke_sham_i15_reac,... 
                     mean_all_imagescDat_ind_c3_c4_beta_stroke_sham_pos_reac],0.2)
errorbar([1,4,7,10],[mean_all_imagescDat_ind_c3_c4_beta_stroke_sham_pre_reac,...  
                     mean_all_imagescDat_ind_c3_c4_beta_stroke_sham_i05_reac,... 
                     mean_all_imagescDat_ind_c3_c4_beta_stroke_sham_i15_reac,... 
                     mean_all_imagescDat_ind_c3_c4_beta_stroke_sham_pos_reac],...
                      [se_all_imagescDat_ind_c3_c4_beta_stroke_sham_pre_reac,...  
                       se_all_imagescDat_ind_c3_c4_beta_stroke_sham_i05_reac,... 
                       se_all_imagescDat_ind_c3_c4_beta_stroke_sham_i15_reac,... 
                       se_all_imagescDat_ind_c3_c4_beta_stroke_sham_pos_reac],'.k')
     bar([2,5,8,11],[mean_all_imagescDat_ind_c3_c4_beta_stroke_stim_pre_reac,...  
                     mean_all_imagescDat_ind_c3_c4_beta_stroke_stim_i05_reac,... 
                     mean_all_imagescDat_ind_c3_c4_beta_stroke_stim_i15_reac,... 
                     mean_all_imagescDat_ind_c3_c4_beta_stroke_stim_pos_reac],0.2)
errorbar([2,5,8,11],[mean_all_imagescDat_ind_c3_c4_beta_stroke_stim_pre_reac,...  
                     mean_all_imagescDat_ind_c3_c4_beta_stroke_stim_i05_reac,... 
                     mean_all_imagescDat_ind_c3_c4_beta_stroke_stim_i15_reac,... 
                     mean_all_imagescDat_ind_c3_c4_beta_stroke_stim_pos_reac],...
                      [se_all_imagescDat_ind_c3_c4_beta_stroke_stim_pre_reac,...  
                       se_all_imagescDat_ind_c3_c4_beta_stroke_stim_i05_reac,... 
                       se_all_imagescDat_ind_c3_c4_beta_stroke_stim_i15_reac,... 
                       se_all_imagescDat_ind_c3_c4_beta_stroke_stim_pos_reac],'.k')
%legend('Sham','','Stim','')
set(gca,'XTick',[1 4 7 10],'XTickLabel',{'pre';'i05';'i15';'pos'},'YLim',[0.5 0.8])
ylabel('beta c3-c4 icoh')
title('Stroke - Reach')
if p_rank_all_imagescDat_ind_c3_c4_beta_stroke_pre_reac<0.05
    text(1.5,0.7,'*','Color','r')
end
if p_rank_all_imagescDat_ind_c3_c4_beta_stroke_i05_reac<0.05
    text(4.5,0.7,'*','Color','r')
end
if p_rank_all_imagescDat_ind_c3_c4_beta_stroke_i15_reac<0.05
    text(7.5,0.7,'*','Color','r')
end
if p_rank_all_imagescDat_ind_c3_c4_beta_stroke_pos_reac<0.05
    text(10.5,0.7,'*','Color','r')
end

subplot(7,4,13); hold on
     bar([1,4,7],[mean_all_imagescDat_ind_c3_c4_beta_stroke_sham_pre_hold,...  
                  mean_all_imagescDat_ind_c3_c4_beta_stroke_sham_pre_prep,... 
                  mean_all_imagescDat_ind_c3_c4_beta_stroke_sham_pre_reac],0.2)
errorbar([1,4,7],[mean_all_imagescDat_ind_c3_c4_beta_stroke_sham_pre_hold,...  
                  mean_all_imagescDat_ind_c3_c4_beta_stroke_sham_pre_prep,... 
                  mean_all_imagescDat_ind_c3_c4_beta_stroke_sham_pre_reac],...
                   [se_all_imagescDat_ind_c3_c4_beta_stroke_sham_pre_hold,...  
                    se_all_imagescDat_ind_c3_c4_beta_stroke_sham_pre_prep,... 
                    se_all_imagescDat_ind_c3_c4_beta_stroke_sham_pre_reac],'.k')
     bar([2,5,8],[mean_all_imagescDat_ind_c3_c4_beta_stroke_stim_pre_hold,...  
                  mean_all_imagescDat_ind_c3_c4_beta_stroke_stim_pre_prep,... 
                  mean_all_imagescDat_ind_c3_c4_beta_stroke_stim_pre_reac],0.2)
errorbar([2,5,8],[mean_all_imagescDat_ind_c3_c4_beta_stroke_stim_pre_hold,...  
                  mean_all_imagescDat_ind_c3_c4_beta_stroke_stim_pre_prep,... 
                  mean_all_imagescDat_ind_c3_c4_beta_stroke_stim_pre_reac],...
                   [se_all_imagescDat_ind_c3_c4_beta_stroke_stim_pre_hold,...  
                    se_all_imagescDat_ind_c3_c4_beta_stroke_stim_pre_prep,... 
                    se_all_imagescDat_ind_c3_c4_beta_stroke_stim_pre_reac],'.k')
%legend('Sham','','Stim','')
set(gca,'XTick',[1 4 7],'XTickLabel',{'hold';'prep';'reac'},'YLim',[0.5 0.9])
ylabel('beta c3-c4 icoh')
title('Stroke - Pre')
if p_rank_all_imagescDat_ind_c3_c4_beta_stroke_pre_hold<0.05
    text(1.5,0.7,'*','Color','r')
end
if p_rank_all_imagescDat_ind_c3_c4_beta_stroke_pre_prep<0.05
    text(4.5,0.7,'*','Color','r')
end
if p_rank_all_imagescDat_ind_c3_c4_beta_stroke_pre_reac<0.05
    text(7.5,0.7,'*','Color','r')
end

subplot(7,4,17); hold on
     bar([1,4,7],[mean_all_imagescDat_ind_c3_c4_beta_stroke_sham_i05_hold,...  
                  mean_all_imagescDat_ind_c3_c4_beta_stroke_sham_i05_prep,... 
                  mean_all_imagescDat_ind_c3_c4_beta_stroke_sham_i05_reac],0.2)
errorbar([1,4,7],[mean_all_imagescDat_ind_c3_c4_beta_stroke_sham_i05_hold,...  
                  mean_all_imagescDat_ind_c3_c4_beta_stroke_sham_i05_prep,... 
                  mean_all_imagescDat_ind_c3_c4_beta_stroke_sham_i05_reac],...
                   [se_all_imagescDat_ind_c3_c4_beta_stroke_sham_i05_hold,...  
                    se_all_imagescDat_ind_c3_c4_beta_stroke_sham_i05_prep,... 
                    se_all_imagescDat_ind_c3_c4_beta_stroke_sham_i05_reac],'.k')
     bar([2,5,8],[mean_all_imagescDat_ind_c3_c4_beta_stroke_stim_i05_hold,...  
                  mean_all_imagescDat_ind_c3_c4_beta_stroke_stim_i05_prep,... 
                  mean_all_imagescDat_ind_c3_c4_beta_stroke_stim_i05_reac],0.2)
errorbar([2,5,8],[mean_all_imagescDat_ind_c3_c4_beta_stroke_stim_i05_hold,...  
                  mean_all_imagescDat_ind_c3_c4_beta_stroke_stim_i05_prep,... 
                  mean_all_imagescDat_ind_c3_c4_beta_stroke_stim_i05_reac],...
                   [se_all_imagescDat_ind_c3_c4_beta_stroke_stim_i05_hold,...  
                    se_all_imagescDat_ind_c3_c4_beta_stroke_stim_i05_prep,... 
                    se_all_imagescDat_ind_c3_c4_beta_stroke_stim_i05_reac],'.k')
%legend('Sham','','Stim','')
set(gca,'XTick',[1 4 7],'XTickLabel',{'hold';'prep';'reac'},'YLim',[0.5 0.9])
ylabel('beta c3-c4 icoh')
title('Stroke - I05')
if p_rank_all_imagescDat_ind_c3_c4_beta_stroke_i05_hold<0.05
    text(1.5,0.7,'*','Color','r')
end
if p_rank_all_imagescDat_ind_c3_c4_beta_stroke_i05_prep<0.05
    text(4.5,0.7,'*','Color','r')
end
if p_rank_all_imagescDat_ind_c3_c4_beta_stroke_i05_reac<0.05
    text(7.5,0.7,'*','Color','r')
end

subplot(7,4,21); hold on
     bar([1,4,7],[mean_all_imagescDat_ind_c3_c4_beta_stroke_sham_i15_hold,...  
                  mean_all_imagescDat_ind_c3_c4_beta_stroke_sham_i15_prep,... 
                  mean_all_imagescDat_ind_c3_c4_beta_stroke_sham_i15_reac],0.2)
errorbar([1,4,7],[mean_all_imagescDat_ind_c3_c4_beta_stroke_sham_i15_hold,...  
                  mean_all_imagescDat_ind_c3_c4_beta_stroke_sham_i15_prep,... 
                  mean_all_imagescDat_ind_c3_c4_beta_stroke_sham_i15_reac],...
                   [se_all_imagescDat_ind_c3_c4_beta_stroke_sham_i15_hold,...  
                    se_all_imagescDat_ind_c3_c4_beta_stroke_sham_i15_prep,... 
                    se_all_imagescDat_ind_c3_c4_beta_stroke_sham_i15_reac],'.k')
     bar([2,5,8],[mean_all_imagescDat_ind_c3_c4_beta_stroke_stim_i15_hold,...  
                  mean_all_imagescDat_ind_c3_c4_beta_stroke_stim_i15_prep,... 
                  mean_all_imagescDat_ind_c3_c4_beta_stroke_stim_i15_reac],0.2)
errorbar([2,5,8],[mean_all_imagescDat_ind_c3_c4_beta_stroke_stim_i15_hold,...  
                  mean_all_imagescDat_ind_c3_c4_beta_stroke_stim_i15_prep,... 
                  mean_all_imagescDat_ind_c3_c4_beta_stroke_stim_i15_reac],...
                   [se_all_imagescDat_ind_c3_c4_beta_stroke_stim_i15_hold,...  
                    se_all_imagescDat_ind_c3_c4_beta_stroke_stim_i15_prep,... 
                    se_all_imagescDat_ind_c3_c4_beta_stroke_stim_i15_reac],'.k')
%legend('Sham','','Stim','')
set(gca,'XTick',[1 4 7],'XTickLabel',{'hold';'prep';'reac'},'YLim',[0.5 0.9])
ylabel('beta c3-c4 icoh')
title('Stroke - I15')
if p_rank_all_imagescDat_ind_c3_c4_beta_stroke_i15_hold<0.05
    text(1.5,0.7,'*','Color','r')
end
if p_rank_all_imagescDat_ind_c3_c4_beta_stroke_i15_prep<0.05
    text(4.5,0.7,'*','Color','r')
end
if p_rank_all_imagescDat_ind_c3_c4_beta_stroke_i15_reac<0.05
    text(7.5,0.7,'*','Color','r')
end

subplot(7,4,25); hold on
     bar([1,4,7],[mean_all_imagescDat_ind_c3_c4_beta_stroke_sham_pos_hold,...  
                  mean_all_imagescDat_ind_c3_c4_beta_stroke_sham_pos_prep,... 
                  mean_all_imagescDat_ind_c3_c4_beta_stroke_sham_pos_reac],0.2)
errorbar([1,4,7],[mean_all_imagescDat_ind_c3_c4_beta_stroke_sham_pos_hold,...  
                  mean_all_imagescDat_ind_c3_c4_beta_stroke_sham_pos_prep,... 
                  mean_all_imagescDat_ind_c3_c4_beta_stroke_sham_pos_reac],...
                   [se_all_imagescDat_ind_c3_c4_beta_stroke_sham_pos_hold,...  
                    se_all_imagescDat_ind_c3_c4_beta_stroke_sham_pos_prep,... 
                    se_all_imagescDat_ind_c3_c4_beta_stroke_sham_pos_reac],'.k')
     bar([2,5,8],[mean_all_imagescDat_ind_c3_c4_beta_stroke_stim_pos_hold,...  
                  mean_all_imagescDat_ind_c3_c4_beta_stroke_stim_pos_prep,... 
                  mean_all_imagescDat_ind_c3_c4_beta_stroke_stim_pos_reac],0.2)
errorbar([2,5,8],[mean_all_imagescDat_ind_c3_c4_beta_stroke_stim_pos_hold,...  
                  mean_all_imagescDat_ind_c3_c4_beta_stroke_stim_pos_prep,... 
                  mean_all_imagescDat_ind_c3_c4_beta_stroke_stim_pos_reac],...
                   [se_all_imagescDat_ind_c3_c4_beta_stroke_stim_pos_hold,...  
                    se_all_imagescDat_ind_c3_c4_beta_stroke_stim_pos_prep,... 
                    se_all_imagescDat_ind_c3_c4_beta_stroke_stim_pos_reac],'.k')
%legend('Sham','','Stim','')
set(gca,'XTick',[1 4 7],'XTickLabel',{'hold';'prep';'reac'},'YLim',[0.5 0.9])
ylabel('beta c3-c4 icoh')
title('Stroke - Pos')
if p_rank_all_imagescDat_ind_c3_c4_beta_stroke_pos_hold<0.05
    text(1.5,0.7,'*','Color','r')
end
if p_rank_all_imagescDat_ind_c3_c4_beta_stroke_pos_prep<0.05
    text(4.5,0.7,'*','Color','r')
end
if p_rank_all_imagescDat_ind_c3_c4_beta_stroke_pos_reac<0.05
    text(7.5,0.7,'*','Color','r')
end

%healthy
subplot(7,4,2); hold on
     bar([1,4,7,10],[mean_all_imagescDat_ind_c3_c4_beta_healthy_sham_pre_hold,...  
                     mean_all_imagescDat_ind_c3_c4_beta_healthy_sham_i05_hold,... 
                     mean_all_imagescDat_ind_c3_c4_beta_healthy_sham_i15_hold,... 
                     mean_all_imagescDat_ind_c3_c4_beta_healthy_sham_pos_hold],0.2)
errorbar([1,4,7,10],[mean_all_imagescDat_ind_c3_c4_beta_healthy_sham_pre_hold,...  
                     mean_all_imagescDat_ind_c3_c4_beta_healthy_sham_i05_hold,... 
                     mean_all_imagescDat_ind_c3_c4_beta_healthy_sham_i15_hold,... 
                     mean_all_imagescDat_ind_c3_c4_beta_healthy_sham_pos_hold],...
                      [se_all_imagescDat_ind_c3_c4_beta_healthy_sham_pre_hold,...  
                       se_all_imagescDat_ind_c3_c4_beta_healthy_sham_i05_hold,... 
                       se_all_imagescDat_ind_c3_c4_beta_healthy_sham_i15_hold,... 
                       se_all_imagescDat_ind_c3_c4_beta_healthy_sham_pos_hold],'.k')
     bar([2,5,8,11],[mean_all_imagescDat_ind_c3_c4_beta_healthy_stim_pre_hold,...  
                     mean_all_imagescDat_ind_c3_c4_beta_healthy_stim_i05_hold,... 
                     mean_all_imagescDat_ind_c3_c4_beta_healthy_stim_i15_hold,... 
                     mean_all_imagescDat_ind_c3_c4_beta_healthy_stim_pos_hold],0.2)
errorbar([2,5,8,11],[mean_all_imagescDat_ind_c3_c4_beta_healthy_stim_pre_hold,...  
                     mean_all_imagescDat_ind_c3_c4_beta_healthy_stim_i05_hold,... 
                     mean_all_imagescDat_ind_c3_c4_beta_healthy_stim_i15_hold,... 
                     mean_all_imagescDat_ind_c3_c4_beta_healthy_stim_pos_hold],...
                      [se_all_imagescDat_ind_c3_c4_beta_healthy_stim_pre_hold,...  
                       se_all_imagescDat_ind_c3_c4_beta_healthy_stim_i05_hold,... 
                       se_all_imagescDat_ind_c3_c4_beta_healthy_stim_i15_hold,... 
                       se_all_imagescDat_ind_c3_c4_beta_healthy_stim_pos_hold],'.k')
legend('Sham','','Stim','')
set(gca,'XTick',[1 4 7 10],'XTickLabel',{'pre';'i05';'i15';'pos'},'YLim',[0.5 0.8])
ylabel('beta c3-c4 icoh')
title('Healthy - Hold')
if p_rank_all_imagescDat_ind_c3_c4_beta_healthy_pre_hold<0.05
    text(1.5,0.7,'*','Color','r')
end
if p_rank_all_imagescDat_ind_c3_c4_beta_healthy_i05_hold<0.05
    text(4.5,0.7,'*','Color','r')
end
if p_rank_all_imagescDat_ind_c3_c4_beta_healthy_i15_hold<0.05
    text(7.5,0.7,'*','Color','r')
end
if p_rank_all_imagescDat_ind_c3_c4_beta_healthy_pos_hold<0.05
    text(10.5,0.7,'*','Color','r')
end

subplot(7,4,6); hold on
     bar([1,4,7,10],[mean_all_imagescDat_ind_c3_c4_beta_healthy_sham_pre_prep,...  
                     mean_all_imagescDat_ind_c3_c4_beta_healthy_sham_i05_prep,... 
                     mean_all_imagescDat_ind_c3_c4_beta_healthy_sham_i15_prep,... 
                     mean_all_imagescDat_ind_c3_c4_beta_healthy_sham_pos_prep],0.2)
errorbar([1,4,7,10],[mean_all_imagescDat_ind_c3_c4_beta_healthy_sham_pre_prep,...  
                     mean_all_imagescDat_ind_c3_c4_beta_healthy_sham_i05_prep,... 
                     mean_all_imagescDat_ind_c3_c4_beta_healthy_sham_i15_prep,... 
                     mean_all_imagescDat_ind_c3_c4_beta_healthy_sham_pos_prep],...
                      [se_all_imagescDat_ind_c3_c4_beta_healthy_sham_pre_prep,...  
                       se_all_imagescDat_ind_c3_c4_beta_healthy_sham_i05_prep,... 
                       se_all_imagescDat_ind_c3_c4_beta_healthy_sham_i15_prep,... 
                       se_all_imagescDat_ind_c3_c4_beta_healthy_sham_pos_prep],'.k')
     bar([2,5,8,11],[mean_all_imagescDat_ind_c3_c4_beta_healthy_stim_pre_prep,...  
                     mean_all_imagescDat_ind_c3_c4_beta_healthy_stim_i05_prep,... 
                     mean_all_imagescDat_ind_c3_c4_beta_healthy_stim_i15_prep,... 
                     mean_all_imagescDat_ind_c3_c4_beta_healthy_stim_pos_prep],0.2)
errorbar([2,5,8,11],[mean_all_imagescDat_ind_c3_c4_beta_healthy_stim_pre_prep,...  
                     mean_all_imagescDat_ind_c3_c4_beta_healthy_stim_i05_prep,... 
                     mean_all_imagescDat_ind_c3_c4_beta_healthy_stim_i15_prep,... 
                     mean_all_imagescDat_ind_c3_c4_beta_healthy_stim_pos_prep],...
                      [se_all_imagescDat_ind_c3_c4_beta_healthy_stim_pre_prep,...  
                       se_all_imagescDat_ind_c3_c4_beta_healthy_stim_i05_prep,... 
                       se_all_imagescDat_ind_c3_c4_beta_healthy_stim_i15_prep,... 
                       se_all_imagescDat_ind_c3_c4_beta_healthy_stim_pos_prep],'.k')
%legend('Sham','','Stim','')
set(gca,'XTick',[1 4 7 10],'XTickLabel',{'pre';'i05';'i15';'pos'},'YLim',[0.5 0.8])
ylabel('beta c3-c4 icoh')
title('Healthy - Prep')
if p_rank_all_imagescDat_ind_c3_c4_beta_healthy_pre_prep<0.05
    text(1.5,0.7,'*','Color','r')
end
if p_rank_all_imagescDat_ind_c3_c4_beta_healthy_i05_prep<0.05
    text(4.5,0.7,'*','Color','r')
end
if p_rank_all_imagescDat_ind_c3_c4_beta_healthy_i15_prep<0.05
    text(7.5,0.7,'*','Color','r')
end
if p_rank_all_imagescDat_ind_c3_c4_beta_healthy_pos_prep<0.05
    text(10.5,0.7,'*','Color','r')
end

subplot(7,4,10); hold on
     bar([1,4,7,10],[mean_all_imagescDat_ind_c3_c4_beta_healthy_sham_pre_reac,...  
                     mean_all_imagescDat_ind_c3_c4_beta_healthy_sham_i05_reac,... 
                     mean_all_imagescDat_ind_c3_c4_beta_healthy_sham_i15_reac,... 
                     mean_all_imagescDat_ind_c3_c4_beta_healthy_sham_pos_reac],0.2)
errorbar([1,4,7,10],[mean_all_imagescDat_ind_c3_c4_beta_healthy_sham_pre_reac,...  
                     mean_all_imagescDat_ind_c3_c4_beta_healthy_sham_i05_reac,... 
                     mean_all_imagescDat_ind_c3_c4_beta_healthy_sham_i15_reac,... 
                     mean_all_imagescDat_ind_c3_c4_beta_healthy_sham_pos_reac],...
                      [se_all_imagescDat_ind_c3_c4_beta_healthy_sham_pre_reac,...  
                       se_all_imagescDat_ind_c3_c4_beta_healthy_sham_i05_reac,... 
                       se_all_imagescDat_ind_c3_c4_beta_healthy_sham_i15_reac,... 
                       se_all_imagescDat_ind_c3_c4_beta_healthy_sham_pos_reac],'.k')
     bar([2,5,8,11],[mean_all_imagescDat_ind_c3_c4_beta_healthy_stim_pre_reac,...  
                     mean_all_imagescDat_ind_c3_c4_beta_healthy_stim_i05_reac,... 
                     mean_all_imagescDat_ind_c3_c4_beta_healthy_stim_i15_reac,... 
                     mean_all_imagescDat_ind_c3_c4_beta_healthy_stim_pos_reac],0.2)
errorbar([2,5,8,11],[mean_all_imagescDat_ind_c3_c4_beta_healthy_stim_pre_reac,...  
                     mean_all_imagescDat_ind_c3_c4_beta_healthy_stim_i05_reac,... 
                     mean_all_imagescDat_ind_c3_c4_beta_healthy_stim_i15_reac,... 
                     mean_all_imagescDat_ind_c3_c4_beta_healthy_stim_pos_reac],...
                      [se_all_imagescDat_ind_c3_c4_beta_healthy_stim_pre_reac,...  
                       se_all_imagescDat_ind_c3_c4_beta_healthy_stim_i05_reac,... 
                       se_all_imagescDat_ind_c3_c4_beta_healthy_stim_i15_reac,... 
                       se_all_imagescDat_ind_c3_c4_beta_healthy_stim_pos_reac],'.k')
%legend('Sham','','Stim','')
set(gca,'XTick',[1 4 7 10],'XTickLabel',{'pre';'i05';'i15';'pos'},'YLim',[0.5 0.8])
ylabel('beta c3-c4 icoh')
title('Healthy - Reach')
if p_rank_all_imagescDat_ind_c3_c4_beta_healthy_pre_reac<0.05
    text(1.5,0.7,'*','Color','r')
end
if p_rank_all_imagescDat_ind_c3_c4_beta_healthy_i05_reac<0.05
    text(4.5,0.7,'*','Color','r')
end
if p_rank_all_imagescDat_ind_c3_c4_beta_healthy_i15_reac<0.05
    text(7.5,0.7,'*','Color','r')
end
if p_rank_all_imagescDat_ind_c3_c4_beta_healthy_pos_reac<0.05
    text(10.5,0.7,'*','Color','r')
end

subplot(7,4,14); hold on
     bar([1,4,7],[mean_all_imagescDat_ind_c3_c4_beta_healthy_sham_pre_hold,...  
                  mean_all_imagescDat_ind_c3_c4_beta_healthy_sham_pre_prep,... 
                  mean_all_imagescDat_ind_c3_c4_beta_healthy_sham_pre_reac],0.2)
errorbar([1,4,7],[mean_all_imagescDat_ind_c3_c4_beta_healthy_sham_pre_hold,...  
                  mean_all_imagescDat_ind_c3_c4_beta_healthy_sham_pre_prep,... 
                  mean_all_imagescDat_ind_c3_c4_beta_healthy_sham_pre_reac],...
                   [se_all_imagescDat_ind_c3_c4_beta_healthy_sham_pre_hold,...  
                    se_all_imagescDat_ind_c3_c4_beta_healthy_sham_pre_prep,... 
                    se_all_imagescDat_ind_c3_c4_beta_healthy_sham_pre_reac],'.k')
     bar([2,5,8],[mean_all_imagescDat_ind_c3_c4_beta_healthy_stim_pre_hold,...  
                  mean_all_imagescDat_ind_c3_c4_beta_healthy_stim_pre_prep,... 
                  mean_all_imagescDat_ind_c3_c4_beta_healthy_stim_pre_reac],0.2)
errorbar([2,5,8],[mean_all_imagescDat_ind_c3_c4_beta_healthy_stim_pre_hold,...  
                  mean_all_imagescDat_ind_c3_c4_beta_healthy_stim_pre_prep,... 
                  mean_all_imagescDat_ind_c3_c4_beta_healthy_stim_pre_reac],...
                   [se_all_imagescDat_ind_c3_c4_beta_healthy_stim_pre_hold,...  
                    se_all_imagescDat_ind_c3_c4_beta_healthy_stim_pre_prep,... 
                    se_all_imagescDat_ind_c3_c4_beta_healthy_stim_pre_reac],'.k')
%legend('Sham','','Stim','')
set(gca,'XTick',[1 4 7],'XTickLabel',{'hold';'prep';'reac'},'YLim',[0.5 0.9])
ylabel('beta c3-c4 icoh')
title('Healthy - Pre')
if p_rank_all_imagescDat_ind_c3_c4_beta_healthy_pre_hold<0.05
    text(1.5,0.7,'*','Color','r')
end
if p_rank_all_imagescDat_ind_c3_c4_beta_healthy_pre_prep<0.05
    text(4.5,0.7,'*','Color','r')
end
if p_rank_all_imagescDat_ind_c3_c4_beta_healthy_pre_reac<0.05
    text(7.5,0.7,'*','Color','r')
end

subplot(7,4,18); hold on
     bar([1,4,7],[mean_all_imagescDat_ind_c3_c4_beta_healthy_sham_i05_hold,...  
                  mean_all_imagescDat_ind_c3_c4_beta_healthy_sham_i05_prep,... 
                  mean_all_imagescDat_ind_c3_c4_beta_healthy_sham_i05_reac],0.2)
errorbar([1,4,7],[mean_all_imagescDat_ind_c3_c4_beta_healthy_sham_i05_hold,...  
                  mean_all_imagescDat_ind_c3_c4_beta_healthy_sham_i05_prep,... 
                  mean_all_imagescDat_ind_c3_c4_beta_healthy_sham_i05_reac],...
                   [se_all_imagescDat_ind_c3_c4_beta_healthy_sham_i05_hold,...  
                    se_all_imagescDat_ind_c3_c4_beta_healthy_sham_i05_prep,... 
                    se_all_imagescDat_ind_c3_c4_beta_healthy_sham_i05_reac],'.k')
     bar([2,5,8],[mean_all_imagescDat_ind_c3_c4_beta_healthy_stim_i05_hold,...  
                  mean_all_imagescDat_ind_c3_c4_beta_healthy_stim_i05_prep,... 
                  mean_all_imagescDat_ind_c3_c4_beta_healthy_stim_i05_reac],0.2)
errorbar([2,5,8],[mean_all_imagescDat_ind_c3_c4_beta_healthy_stim_i05_hold,...  
                  mean_all_imagescDat_ind_c3_c4_beta_healthy_stim_i05_prep,... 
                  mean_all_imagescDat_ind_c3_c4_beta_healthy_stim_i05_reac],...
                   [se_all_imagescDat_ind_c3_c4_beta_healthy_stim_i05_hold,...  
                    se_all_imagescDat_ind_c3_c4_beta_healthy_stim_i05_prep,... 
                    se_all_imagescDat_ind_c3_c4_beta_healthy_stim_i05_reac],'.k')
%legend('Sham','','Stim','')
set(gca,'XTick',[1 4 7],'XTickLabel',{'hold';'prep';'reac'},'YLim',[0.5 0.9])
ylabel('beta c3-c4 icoh')
title('Healthy - I05')
if p_rank_all_imagescDat_ind_c3_c4_beta_healthy_i05_hold<0.05
    text(1.5,0.7,'*','Color','r')
end
if p_rank_all_imagescDat_ind_c3_c4_beta_healthy_i05_prep<0.05
    text(4.5,0.7,'*','Color','r')
end
if p_rank_all_imagescDat_ind_c3_c4_beta_healthy_i05_reac<0.05
    text(7.5,0.7,'*','Color','r')
end

subplot(7,4,22); hold on
     bar([1,4,7],[mean_all_imagescDat_ind_c3_c4_beta_healthy_sham_i15_hold,...  
                  mean_all_imagescDat_ind_c3_c4_beta_healthy_sham_i15_prep,... 
                  mean_all_imagescDat_ind_c3_c4_beta_healthy_sham_i15_reac],0.2)
errorbar([1,4,7],[mean_all_imagescDat_ind_c3_c4_beta_healthy_sham_i15_hold,...  
                  mean_all_imagescDat_ind_c3_c4_beta_healthy_sham_i15_prep,... 
                  mean_all_imagescDat_ind_c3_c4_beta_healthy_sham_i15_reac],...
                   [se_all_imagescDat_ind_c3_c4_beta_healthy_sham_i15_hold,...  
                    se_all_imagescDat_ind_c3_c4_beta_healthy_sham_i15_prep,... 
                    se_all_imagescDat_ind_c3_c4_beta_healthy_sham_i15_reac],'.k')
     bar([2,5,8],[mean_all_imagescDat_ind_c3_c4_beta_healthy_stim_i15_hold,...  
                  mean_all_imagescDat_ind_c3_c4_beta_healthy_stim_i15_prep,... 
                  mean_all_imagescDat_ind_c3_c4_beta_healthy_stim_i15_reac],0.2)
errorbar([2,5,8],[mean_all_imagescDat_ind_c3_c4_beta_healthy_stim_i15_hold,...  
                  mean_all_imagescDat_ind_c3_c4_beta_healthy_stim_i15_prep,... 
                  mean_all_imagescDat_ind_c3_c4_beta_healthy_stim_i15_reac],...
                   [se_all_imagescDat_ind_c3_c4_beta_healthy_stim_i15_hold,...  
                    se_all_imagescDat_ind_c3_c4_beta_healthy_stim_i15_prep,... 
                    se_all_imagescDat_ind_c3_c4_beta_healthy_stim_i15_reac],'.k')
%legend('Sham','','Stim','')
set(gca,'XTick',[1 4 7],'XTickLabel',{'hold';'prep';'reac'},'YLim',[0.5 0.9])
ylabel('beta c3-c4 icoh')
title('Healthy - I15')
if p_rank_all_imagescDat_ind_c3_c4_beta_healthy_i15_hold<0.05
    text(1.5,0.7,'*','Color','r')
end
if p_rank_all_imagescDat_ind_c3_c4_beta_healthy_i15_prep<0.05
    text(4.5,0.7,'*','Color','r')
end
if p_rank_all_imagescDat_ind_c3_c4_beta_healthy_i15_reac<0.05
    text(7.5,0.7,'*','Color','r')
end

subplot(7,4,26); hold on
     bar([1,4,7],[mean_all_imagescDat_ind_c3_c4_beta_healthy_sham_pos_hold,...  
                  mean_all_imagescDat_ind_c3_c4_beta_healthy_sham_pos_prep,... 
                  mean_all_imagescDat_ind_c3_c4_beta_healthy_sham_pos_reac],0.2)
errorbar([1,4,7],[mean_all_imagescDat_ind_c3_c4_beta_healthy_sham_pos_hold,...  
                  mean_all_imagescDat_ind_c3_c4_beta_healthy_sham_pos_prep,... 
                  mean_all_imagescDat_ind_c3_c4_beta_healthy_sham_pos_reac],...
                   [se_all_imagescDat_ind_c3_c4_beta_healthy_sham_pos_hold,...  
                    se_all_imagescDat_ind_c3_c4_beta_healthy_sham_pos_prep,... 
                    se_all_imagescDat_ind_c3_c4_beta_healthy_sham_pos_reac],'.k')
     bar([2,5,8],[mean_all_imagescDat_ind_c3_c4_beta_healthy_stim_pos_hold,...  
                  mean_all_imagescDat_ind_c3_c4_beta_healthy_stim_pos_prep,... 
                  mean_all_imagescDat_ind_c3_c4_beta_healthy_stim_pos_reac],0.2)
errorbar([2,5,8],[mean_all_imagescDat_ind_c3_c4_beta_healthy_stim_pos_hold,...  
                  mean_all_imagescDat_ind_c3_c4_beta_healthy_stim_pos_prep,... 
                  mean_all_imagescDat_ind_c3_c4_beta_healthy_stim_pos_reac],...
                   [se_all_imagescDat_ind_c3_c4_beta_healthy_stim_pos_hold,...  
                    se_all_imagescDat_ind_c3_c4_beta_healthy_stim_pos_prep,... 
                    se_all_imagescDat_ind_c3_c4_beta_healthy_stim_pos_reac],'.k')
%legend('Sham','','Stim','')
set(gca,'XTick',[1 4 7],'XTickLabel',{'hold';'prep';'reac'},'YLim',[0.5 0.9])
ylabel('beta c3-c4 icoh')
title('Healthy - Pos')
if p_rank_all_imagescDat_ind_c3_c4_beta_healthy_pos_hold<0.05
    text(1.5,0.7,'*','Color','r')
end
if p_rank_all_imagescDat_ind_c3_c4_beta_healthy_pos_prep<0.05
    text(4.5,0.7,'*','Color','r')
end
if p_rank_all_imagescDat_ind_c3_c4_beta_healthy_pos_reac<0.05
    text(7.5,0.7,'*','Color','r')
end

%sham 
subplot(7,4,3); hold on
     bar([1,4,7,10],[mean_all_imagescDat_ind_c3_c4_beta_stroke_sham_pre_hold,...  
                     mean_all_imagescDat_ind_c3_c4_beta_stroke_sham_i05_hold,... 
                     mean_all_imagescDat_ind_c3_c4_beta_stroke_sham_i15_hold,... 
                     mean_all_imagescDat_ind_c3_c4_beta_stroke_sham_pos_hold],0.2)
errorbar([1,4,7,10],[mean_all_imagescDat_ind_c3_c4_beta_stroke_sham_pre_hold,...  
                     mean_all_imagescDat_ind_c3_c4_beta_stroke_sham_i05_hold,... 
                     mean_all_imagescDat_ind_c3_c4_beta_stroke_sham_i15_hold,... 
                     mean_all_imagescDat_ind_c3_c4_beta_stroke_sham_pos_hold],...
                      [se_all_imagescDat_ind_c3_c4_beta_stroke_sham_pre_hold,...  
                       se_all_imagescDat_ind_c3_c4_beta_stroke_sham_i05_hold,... 
                       se_all_imagescDat_ind_c3_c4_beta_stroke_sham_i15_hold,... 
                       se_all_imagescDat_ind_c3_c4_beta_stroke_sham_pos_hold],'.k')
     bar([2,5,8,11],[mean_all_imagescDat_ind_c3_c4_beta_healthy_sham_pre_hold,...  
                     mean_all_imagescDat_ind_c3_c4_beta_healthy_sham_i05_hold,... 
                     mean_all_imagescDat_ind_c3_c4_beta_healthy_sham_i15_hold,... 
                     mean_all_imagescDat_ind_c3_c4_beta_healthy_sham_pos_hold],0.2)
errorbar([2,5,8,11],[mean_all_imagescDat_ind_c3_c4_beta_healthy_sham_pre_hold,...  
                     mean_all_imagescDat_ind_c3_c4_beta_healthy_sham_i05_hold,... 
                     mean_all_imagescDat_ind_c3_c4_beta_healthy_sham_i15_hold,... 
                     mean_all_imagescDat_ind_c3_c4_beta_healthy_sham_pos_hold],...
                      [se_all_imagescDat_ind_c3_c4_beta_healthy_sham_pre_hold,...  
                       se_all_imagescDat_ind_c3_c4_beta_healthy_sham_i05_hold,... 
                       se_all_imagescDat_ind_c3_c4_beta_healthy_sham_i15_hold,... 
                       se_all_imagescDat_ind_c3_c4_beta_healthy_sham_pos_hold],'.k')
legend('Stroke','','Healthy','')
set(gca,'XTick',[1 4 7 10],'XTickLabel',{'pre';'i05';'i15';'pos'},'YLim',[0.5 0.9])
ylabel('beta c3-c4 icoh')
title('Sham - Hold')
if p_rank_all_imagescDat_ind_c3_c4_beta_sham_pre_hold<0.05
    text(1.5,0.7,'*','Color','r')
end
if p_rank_all_imagescDat_ind_c3_c4_beta_sham_i05_hold<0.05
    text(4.5,0.7,'*','Color','r')
end
if p_rank_all_imagescDat_ind_c3_c4_beta_sham_i15_hold<0.05
    text(7.5,0.7,'*','Color','r')
end
if p_rank_all_imagescDat_ind_c3_c4_beta_sham_pos_hold<0.05
    text(10.5,0.7,'*','Color','r')
end

subplot(7,4,7); hold on
     bar([1,4,7,10],[mean_all_imagescDat_ind_c3_c4_beta_stroke_sham_pre_prep,...  
                     mean_all_imagescDat_ind_c3_c4_beta_stroke_sham_i05_prep,... 
                     mean_all_imagescDat_ind_c3_c4_beta_stroke_sham_i15_prep,... 
                     mean_all_imagescDat_ind_c3_c4_beta_stroke_sham_pos_prep],0.2)
errorbar([1,4,7,10],[mean_all_imagescDat_ind_c3_c4_beta_stroke_sham_pre_prep,...  
                     mean_all_imagescDat_ind_c3_c4_beta_stroke_sham_i05_prep,... 
                     mean_all_imagescDat_ind_c3_c4_beta_stroke_sham_i15_prep,... 
                     mean_all_imagescDat_ind_c3_c4_beta_stroke_sham_pos_prep],...
                      [se_all_imagescDat_ind_c3_c4_beta_stroke_sham_pre_prep,...  
                       se_all_imagescDat_ind_c3_c4_beta_stroke_sham_i05_prep,... 
                       se_all_imagescDat_ind_c3_c4_beta_stroke_sham_i15_prep,... 
                       se_all_imagescDat_ind_c3_c4_beta_stroke_sham_pos_prep],'.k')
     bar([2,5,8,11],[mean_all_imagescDat_ind_c3_c4_beta_healthy_sham_pre_prep,...  
                     mean_all_imagescDat_ind_c3_c4_beta_healthy_sham_i05_prep,... 
                     mean_all_imagescDat_ind_c3_c4_beta_healthy_sham_i15_prep,... 
                     mean_all_imagescDat_ind_c3_c4_beta_healthy_sham_pos_prep],0.2)
errorbar([2,5,8,11],[mean_all_imagescDat_ind_c3_c4_beta_healthy_sham_pre_prep,...  
                     mean_all_imagescDat_ind_c3_c4_beta_healthy_sham_i05_prep,... 
                     mean_all_imagescDat_ind_c3_c4_beta_healthy_sham_i15_prep,... 
                     mean_all_imagescDat_ind_c3_c4_beta_healthy_sham_pos_prep],...
                      [se_all_imagescDat_ind_c3_c4_beta_healthy_sham_pre_prep,...  
                       se_all_imagescDat_ind_c3_c4_beta_healthy_sham_i05_prep,... 
                       se_all_imagescDat_ind_c3_c4_beta_healthy_sham_i15_prep,... 
                       se_all_imagescDat_ind_c3_c4_beta_healthy_sham_pos_prep],'.k')
%legend('Stroke','','Healthy','')
set(gca,'XTick',[1 4 7 10],'XTickLabel',{'pre';'i05';'i15';'pos'},'YLim',[0.5 0.9])
ylabel('beta c3-c4 icoh')
title('Sham - Prep')
if p_rank_all_imagescDat_ind_c3_c4_beta_sham_pre_prep<0.05
    text(1.5,0.7,'*','Color','r')
end
if p_rank_all_imagescDat_ind_c3_c4_beta_sham_i05_prep<0.05
    text(4.5,0.7,'*','Color','r')
end
if p_rank_all_imagescDat_ind_c3_c4_beta_sham_i15_prep<0.05
    text(7.5,0.7,'*','Color','r')
end
if p_rank_all_imagescDat_ind_c3_c4_beta_sham_pos_prep<0.05
    text(10.5,0.7,'*','Color','r')
end

subplot(7,4,11); hold on
     bar([1,4,7,10],[mean_all_imagescDat_ind_c3_c4_beta_stroke_sham_pre_reac,...  
                     mean_all_imagescDat_ind_c3_c4_beta_stroke_sham_i05_reac,... 
                     mean_all_imagescDat_ind_c3_c4_beta_stroke_sham_i15_reac,... 
                     mean_all_imagescDat_ind_c3_c4_beta_stroke_sham_pos_reac],0.2)
errorbar([1,4,7,10],[mean_all_imagescDat_ind_c3_c4_beta_stroke_sham_pre_reac,...  
                     mean_all_imagescDat_ind_c3_c4_beta_stroke_sham_i05_reac,... 
                     mean_all_imagescDat_ind_c3_c4_beta_stroke_sham_i15_reac,... 
                     mean_all_imagescDat_ind_c3_c4_beta_stroke_sham_pos_reac],...
                      [se_all_imagescDat_ind_c3_c4_beta_stroke_sham_pre_reac,...  
                       se_all_imagescDat_ind_c3_c4_beta_stroke_sham_i05_reac,... 
                       se_all_imagescDat_ind_c3_c4_beta_stroke_sham_i15_reac,... 
                       se_all_imagescDat_ind_c3_c4_beta_stroke_sham_pos_reac],'.k')
     bar([2,5,8,11],[mean_all_imagescDat_ind_c3_c4_beta_healthy_sham_pre_reac,...  
                     mean_all_imagescDat_ind_c3_c4_beta_healthy_sham_i05_reac,... 
                     mean_all_imagescDat_ind_c3_c4_beta_healthy_sham_i15_reac,... 
                     mean_all_imagescDat_ind_c3_c4_beta_healthy_sham_pos_reac],0.2)
errorbar([2,5,8,11],[mean_all_imagescDat_ind_c3_c4_beta_healthy_sham_pre_reac,...  
                     mean_all_imagescDat_ind_c3_c4_beta_healthy_sham_i05_reac,... 
                     mean_all_imagescDat_ind_c3_c4_beta_healthy_sham_i15_reac,... 
                     mean_all_imagescDat_ind_c3_c4_beta_healthy_sham_pos_reac],...
                      [se_all_imagescDat_ind_c3_c4_beta_healthy_sham_pre_reac,...  
                       se_all_imagescDat_ind_c3_c4_beta_healthy_sham_i05_reac,... 
                       se_all_imagescDat_ind_c3_c4_beta_healthy_sham_i15_reac,... 
                       se_all_imagescDat_ind_c3_c4_beta_healthy_sham_pos_reac],'.k')
%legend('Stroke','','Healthy','')
set(gca,'XTick',[1 4 7 10],'XTickLabel',{'pre';'i05';'i15';'pos'},'YLim',[0.5 0.9])
ylabel('beta c3-c4 icoh')
title('Sham - Reach')
if p_rank_all_imagescDat_ind_c3_c4_beta_sham_pre_reac<0.05
    text(1.5,0.7,'*','Color','r')
end
if p_rank_all_imagescDat_ind_c3_c4_beta_sham_i05_reac<0.05
    text(4.5,0.7,'*','Color','r')
end
if p_rank_all_imagescDat_ind_c3_c4_beta_sham_i15_reac<0.05
    text(7.5,0.7,'*','Color','r')
end
if p_rank_all_imagescDat_ind_c3_c4_beta_sham_pos_reac<0.05
    text(10.5,0.7,'*','Color','r')
end
 
subplot(7,4,15); hold on
     bar([1,4,7],[mean_all_imagescDat_ind_c3_c4_beta_stroke_sham_pre_hold,...  
                  mean_all_imagescDat_ind_c3_c4_beta_stroke_sham_pre_prep,... 
                  mean_all_imagescDat_ind_c3_c4_beta_stroke_sham_pre_reac],0.2)
errorbar([1,4,7],[mean_all_imagescDat_ind_c3_c4_beta_stroke_sham_pre_hold,...  
                  mean_all_imagescDat_ind_c3_c4_beta_stroke_sham_pre_prep,... 
                  mean_all_imagescDat_ind_c3_c4_beta_stroke_sham_pre_reac],...
                   [se_all_imagescDat_ind_c3_c4_beta_stroke_sham_pre_hold,...  
                    se_all_imagescDat_ind_c3_c4_beta_stroke_sham_pre_prep,... 
                    se_all_imagescDat_ind_c3_c4_beta_stroke_sham_pre_reac],'.k')
     bar([2,5,8],[mean_all_imagescDat_ind_c3_c4_beta_healthy_sham_pre_hold,...  
                  mean_all_imagescDat_ind_c3_c4_beta_healthy_sham_pre_prep,... 
                  mean_all_imagescDat_ind_c3_c4_beta_healthy_sham_pre_reac],0.2)
errorbar([2,5,8],[mean_all_imagescDat_ind_c3_c4_beta_healthy_sham_pre_hold,...  
                  mean_all_imagescDat_ind_c3_c4_beta_healthy_sham_pre_prep,... 
                  mean_all_imagescDat_ind_c3_c4_beta_healthy_sham_pre_reac],...
                   [se_all_imagescDat_ind_c3_c4_beta_healthy_sham_pre_hold,...  
                    se_all_imagescDat_ind_c3_c4_beta_healthy_sham_pre_prep,... 
                    se_all_imagescDat_ind_c3_c4_beta_healthy_sham_pre_reac],'.k')
%legend('Stroke','','Healthy','')
set(gca,'XTick',[1 4 7],'XTickLabel',{'hold';'prep';'reac'},'YLim',[0.5 0.9])
ylabel('beta c3-c4 icoh')
title('Sham - Pre')
if p_rank_all_imagescDat_ind_c3_c4_beta_sham_pre_hold<0.05
    text(1.5,0.7,'*','Color','r')
end
if p_rank_all_imagescDat_ind_c3_c4_beta_sham_pre_prep<0.05
    text(4.5,0.7,'*','Color','r')
end
if p_rank_all_imagescDat_ind_c3_c4_beta_sham_pre_reac<0.05
    text(7.5,0.7,'*','Color','r')
end

subplot(7,4,19); hold on
     bar([1,4,7],[mean_all_imagescDat_ind_c3_c4_beta_stroke_sham_i05_hold,...  
                  mean_all_imagescDat_ind_c3_c4_beta_stroke_sham_i05_prep,... 
                  mean_all_imagescDat_ind_c3_c4_beta_stroke_sham_i05_reac],0.2)
errorbar([1,4,7],[mean_all_imagescDat_ind_c3_c4_beta_stroke_sham_i05_hold,...  
                  mean_all_imagescDat_ind_c3_c4_beta_stroke_sham_i05_prep,... 
                  mean_all_imagescDat_ind_c3_c4_beta_stroke_sham_i05_reac],...
                   [se_all_imagescDat_ind_c3_c4_beta_stroke_sham_i05_hold,...  
                    se_all_imagescDat_ind_c3_c4_beta_stroke_sham_i05_prep,... 
                    se_all_imagescDat_ind_c3_c4_beta_stroke_sham_i05_reac],'.k')
     bar([2,5,8],[mean_all_imagescDat_ind_c3_c4_beta_healthy_sham_i05_hold,...  
                  mean_all_imagescDat_ind_c3_c4_beta_healthy_sham_i05_prep,... 
                  mean_all_imagescDat_ind_c3_c4_beta_healthy_sham_i05_reac],0.2)
errorbar([2,5,8],[mean_all_imagescDat_ind_c3_c4_beta_healthy_sham_i05_hold,...  
                  mean_all_imagescDat_ind_c3_c4_beta_healthy_sham_i05_prep,... 
                  mean_all_imagescDat_ind_c3_c4_beta_healthy_sham_i05_reac],...
                   [se_all_imagescDat_ind_c3_c4_beta_healthy_sham_i05_hold,...  
                    se_all_imagescDat_ind_c3_c4_beta_healthy_sham_i05_prep,... 
                    se_all_imagescDat_ind_c3_c4_beta_healthy_sham_i05_reac],'.k')
%legend('Stroke','','Healthy','')
set(gca,'XTick',[1 4 7],'XTickLabel',{'hold';'prep';'reac'},'YLim',[0.5 0.9])
ylabel('beta c3-c4 icoh')
title('Sham - I05')
if p_rank_all_imagescDat_ind_c3_c4_beta_sham_i05_hold<0.05
    text(1.5,0.7,'*','Color','r')
end
if p_rank_all_imagescDat_ind_c3_c4_beta_sham_i05_prep<0.05
    text(4.5,0.7,'*','Color','r')
end
if p_rank_all_imagescDat_ind_c3_c4_beta_sham_i05_reac<0.05
    text(7.5,0.7,'*','Color','r')
end


subplot(7,4,23); hold on
     bar([1,4,7],[mean_all_imagescDat_ind_c3_c4_beta_stroke_sham_i15_hold,...  
                  mean_all_imagescDat_ind_c3_c4_beta_stroke_sham_i15_prep,... 
                  mean_all_imagescDat_ind_c3_c4_beta_stroke_sham_i15_reac],0.2)
errorbar([1,4,7],[mean_all_imagescDat_ind_c3_c4_beta_stroke_sham_i15_hold,...  
                  mean_all_imagescDat_ind_c3_c4_beta_stroke_sham_i15_prep,... 
                  mean_all_imagescDat_ind_c3_c4_beta_stroke_sham_i15_reac],...
                   [se_all_imagescDat_ind_c3_c4_beta_stroke_sham_i15_hold,...  
                    se_all_imagescDat_ind_c3_c4_beta_stroke_sham_i15_prep,... 
                    se_all_imagescDat_ind_c3_c4_beta_stroke_sham_i15_reac],'.k')
     bar([2,5,8],[mean_all_imagescDat_ind_c3_c4_beta_healthy_sham_i15_hold,...  
                  mean_all_imagescDat_ind_c3_c4_beta_healthy_sham_i15_prep,... 
                  mean_all_imagescDat_ind_c3_c4_beta_healthy_sham_i15_reac],0.2)
errorbar([2,5,8],[mean_all_imagescDat_ind_c3_c4_beta_healthy_sham_i15_hold,...  
                  mean_all_imagescDat_ind_c3_c4_beta_healthy_sham_i15_prep,... 
                  mean_all_imagescDat_ind_c3_c4_beta_healthy_sham_i15_reac],...
                   [se_all_imagescDat_ind_c3_c4_beta_healthy_sham_i15_hold,...  
                    se_all_imagescDat_ind_c3_c4_beta_healthy_sham_i15_prep,... 
                    se_all_imagescDat_ind_c3_c4_beta_healthy_sham_i15_reac],'.k')
%legend('Stroke','','Healthy','')
set(gca,'XTick',[1 4 7],'XTickLabel',{'hold';'prep';'reac'},'YLim',[0.5 0.9])
ylabel('beta c3-c4 icoh')
title('Sham - I15')
if p_rank_all_imagescDat_ind_c3_c4_beta_sham_i15_hold<0.05
    text(1.5,0.7,'*','Color','r')
end
if p_rank_all_imagescDat_ind_c3_c4_beta_sham_i15_prep<0.05
    text(4.5,0.7,'*','Color','r')
end
if p_rank_all_imagescDat_ind_c3_c4_beta_sham_i15_reac<0.05
    text(7.5,0.7,'*','Color','r')
end

subplot(7,4,27); hold on
     bar([1,4,7],[mean_all_imagescDat_ind_c3_c4_beta_stroke_sham_pos_hold,...  
                  mean_all_imagescDat_ind_c3_c4_beta_stroke_sham_pos_prep,... 
                  mean_all_imagescDat_ind_c3_c4_beta_stroke_sham_pos_reac],0.2)
errorbar([1,4,7],[mean_all_imagescDat_ind_c3_c4_beta_stroke_sham_pos_hold,...  
                  mean_all_imagescDat_ind_c3_c4_beta_stroke_sham_pos_prep,... 
                  mean_all_imagescDat_ind_c3_c4_beta_stroke_sham_pos_reac],...
                   [se_all_imagescDat_ind_c3_c4_beta_stroke_sham_pos_hold,...  
                    se_all_imagescDat_ind_c3_c4_beta_stroke_sham_pos_prep,... 
                    se_all_imagescDat_ind_c3_c4_beta_stroke_sham_pos_reac],'.k')
     bar([2,5,8],[mean_all_imagescDat_ind_c3_c4_beta_healthy_sham_pos_hold,...  
                  mean_all_imagescDat_ind_c3_c4_beta_healthy_sham_pos_prep,... 
                  mean_all_imagescDat_ind_c3_c4_beta_healthy_sham_pos_reac],0.2)
errorbar([2,5,8],[mean_all_imagescDat_ind_c3_c4_beta_healthy_sham_pos_hold,...  
                  mean_all_imagescDat_ind_c3_c4_beta_healthy_sham_pos_prep,... 
                  mean_all_imagescDat_ind_c3_c4_beta_healthy_sham_pos_reac],...
                   [se_all_imagescDat_ind_c3_c4_beta_healthy_sham_pos_hold,...  
                    se_all_imagescDat_ind_c3_c4_beta_healthy_sham_pos_prep,... 
                    se_all_imagescDat_ind_c3_c4_beta_healthy_sham_pos_reac],'.k')
%legend('Stroke','','Healthy','')
set(gca,'XTick',[1 4 7],'XTickLabel',{'hold';'prep';'reac'},'YLim',[0.5 0.9])
ylabel('beta c3-c4 icoh')
title('Sham - Pos')
if p_rank_all_imagescDat_ind_c3_c4_beta_sham_pos_hold<0.05
    text(1.5,0.7,'*','Color','r')
end
if p_rank_all_imagescDat_ind_c3_c4_beta_sham_pos_prep<0.05
    text(4.5,0.7,'*','Color','r')
end
if p_rank_all_imagescDat_ind_c3_c4_beta_sham_pos_reac<0.05
    text(7.5,0.7,'*','Color','r')
end

%stim 
subplot(7,4,4); hold on
     bar([1,4,7,10],[mean_all_imagescDat_ind_c3_c4_beta_stroke_stim_pre_hold,...  
                     mean_all_imagescDat_ind_c3_c4_beta_stroke_stim_i05_hold,... 
                     mean_all_imagescDat_ind_c3_c4_beta_stroke_stim_i15_hold,... 
                     mean_all_imagescDat_ind_c3_c4_beta_stroke_stim_pos_hold],0.2)
errorbar([1,4,7,10],[mean_all_imagescDat_ind_c3_c4_beta_stroke_stim_pre_hold,...  
                     mean_all_imagescDat_ind_c3_c4_beta_stroke_stim_i05_hold,... 
                     mean_all_imagescDat_ind_c3_c4_beta_stroke_stim_i15_hold,... 
                     mean_all_imagescDat_ind_c3_c4_beta_stroke_stim_pos_hold],...
                      [se_all_imagescDat_ind_c3_c4_beta_stroke_stim_pre_hold,...  
                       se_all_imagescDat_ind_c3_c4_beta_stroke_stim_i05_hold,... 
                       se_all_imagescDat_ind_c3_c4_beta_stroke_stim_i15_hold,... 
                       se_all_imagescDat_ind_c3_c4_beta_stroke_stim_pos_hold],'.k')
     bar([2,5,8,11],[mean_all_imagescDat_ind_c3_c4_beta_healthy_stim_pre_hold,...  
                     mean_all_imagescDat_ind_c3_c4_beta_healthy_stim_i05_hold,... 
                     mean_all_imagescDat_ind_c3_c4_beta_healthy_stim_i15_hold,... 
                     mean_all_imagescDat_ind_c3_c4_beta_healthy_stim_pos_hold],0.2)
errorbar([2,5,8,11],[mean_all_imagescDat_ind_c3_c4_beta_healthy_stim_pre_hold,...  
                     mean_all_imagescDat_ind_c3_c4_beta_healthy_stim_i05_hold,... 
                     mean_all_imagescDat_ind_c3_c4_beta_healthy_stim_i15_hold,... 
                     mean_all_imagescDat_ind_c3_c4_beta_healthy_stim_pos_hold],...
                      [se_all_imagescDat_ind_c3_c4_beta_healthy_stim_pre_hold,...  
                       se_all_imagescDat_ind_c3_c4_beta_healthy_stim_i05_hold,... 
                       se_all_imagescDat_ind_c3_c4_beta_healthy_stim_i15_hold,... 
                       se_all_imagescDat_ind_c3_c4_beta_healthy_stim_pos_hold],'.k')
legend('Stroke','','Healthy','')
set(gca,'XTick',[1 4 7 10],'XTickLabel',{'pre';'i05';'i15';'pos'},'YLim',[0.5 0.9])
ylabel('beta c3-c4 icoh')
title('Stim - Hold')
if p_rank_all_imagescDat_ind_c3_c4_beta_stim_pre_hold<0.05
    text(1.5,0.7,'*','Color','r')
end
if p_rank_all_imagescDat_ind_c3_c4_beta_stim_i05_hold<0.05
    text(4.5,0.7,'*','Color','r')
end
if p_rank_all_imagescDat_ind_c3_c4_beta_stim_i15_hold<0.05
    text(7.5,0.7,'*','Color','r')
end
if p_rank_all_imagescDat_ind_c3_c4_beta_stim_pos_hold<0.05
    text(10.5,0.7,'*','Color','r')
end


subplot(7,4,8); hold on
     bar([1,4,7,10],[mean_all_imagescDat_ind_c3_c4_beta_stroke_stim_pre_prep,...  
                     mean_all_imagescDat_ind_c3_c4_beta_stroke_stim_i05_prep,... 
                     mean_all_imagescDat_ind_c3_c4_beta_stroke_stim_i15_prep,... 
                     mean_all_imagescDat_ind_c3_c4_beta_stroke_stim_pos_prep],0.2)
errorbar([1,4,7,10],[mean_all_imagescDat_ind_c3_c4_beta_stroke_stim_pre_prep,...  
                     mean_all_imagescDat_ind_c3_c4_beta_stroke_stim_i05_prep,... 
                     mean_all_imagescDat_ind_c3_c4_beta_stroke_stim_i15_prep,... 
                     mean_all_imagescDat_ind_c3_c4_beta_stroke_stim_pos_prep],...
                      [se_all_imagescDat_ind_c3_c4_beta_stroke_stim_pre_prep,...  
                       se_all_imagescDat_ind_c3_c4_beta_stroke_stim_i05_prep,... 
                       se_all_imagescDat_ind_c3_c4_beta_stroke_stim_i15_prep,... 
                       se_all_imagescDat_ind_c3_c4_beta_stroke_stim_pos_prep],'.k')
     bar([2,5,8,11],[mean_all_imagescDat_ind_c3_c4_beta_healthy_stim_pre_prep,...  
                     mean_all_imagescDat_ind_c3_c4_beta_healthy_stim_i05_prep,... 
                     mean_all_imagescDat_ind_c3_c4_beta_healthy_stim_i15_prep,... 
                     mean_all_imagescDat_ind_c3_c4_beta_healthy_stim_pos_prep],0.2)
errorbar([2,5,8,11],[mean_all_imagescDat_ind_c3_c4_beta_healthy_stim_pre_prep,...  
                     mean_all_imagescDat_ind_c3_c4_beta_healthy_stim_i05_prep,... 
                     mean_all_imagescDat_ind_c3_c4_beta_healthy_stim_i15_prep,... 
                     mean_all_imagescDat_ind_c3_c4_beta_healthy_stim_pos_prep],...
                      [se_all_imagescDat_ind_c3_c4_beta_healthy_stim_pre_prep,...  
                       se_all_imagescDat_ind_c3_c4_beta_healthy_stim_i05_prep,... 
                       se_all_imagescDat_ind_c3_c4_beta_healthy_stim_i15_prep,... 
                       se_all_imagescDat_ind_c3_c4_beta_healthy_stim_pos_prep],'.k')
%legend('Stroke','','Healthy','')
set(gca,'XTick',[1 4 7 10],'XTickLabel',{'pre';'i05';'i15';'pos'},'YLim',[0.5 0.9])
ylabel('beta c3-c4 icoh')
title('Stim - Prep')
if p_rank_all_imagescDat_ind_c3_c4_beta_stim_pre_prep<0.05
    text(1.5,0.7,'*','Color','r')
end
if p_rank_all_imagescDat_ind_c3_c4_beta_stim_i05_prep<0.05
    text(4.5,0.7,'*','Color','r')
end
if p_rank_all_imagescDat_ind_c3_c4_beta_stim_i15_prep<0.05
    text(7.5,0.7,'*','Color','r')
end
if p_rank_all_imagescDat_ind_c3_c4_beta_stim_pos_prep<0.05
    text(10.5,0.7,'*','Color','r')
end

subplot(7,4,12); hold on
     bar([1,4,7,10],[mean_all_imagescDat_ind_c3_c4_beta_stroke_stim_pre_reac,...  
                     mean_all_imagescDat_ind_c3_c4_beta_stroke_stim_i05_reac,... 
                     mean_all_imagescDat_ind_c3_c4_beta_stroke_stim_i15_reac,... 
                     mean_all_imagescDat_ind_c3_c4_beta_stroke_stim_pos_reac],0.2)
errorbar([1,4,7,10],[mean_all_imagescDat_ind_c3_c4_beta_stroke_stim_pre_reac,...  
                     mean_all_imagescDat_ind_c3_c4_beta_stroke_stim_i05_reac,... 
                     mean_all_imagescDat_ind_c3_c4_beta_stroke_stim_i15_reac,... 
                     mean_all_imagescDat_ind_c3_c4_beta_stroke_stim_pos_reac],...
                      [se_all_imagescDat_ind_c3_c4_beta_stroke_stim_pre_reac,...  
                       se_all_imagescDat_ind_c3_c4_beta_stroke_stim_i05_reac,... 
                       se_all_imagescDat_ind_c3_c4_beta_stroke_stim_i15_reac,... 
                       se_all_imagescDat_ind_c3_c4_beta_stroke_stim_pos_reac],'.k')
     bar([2,5,8,11],[mean_all_imagescDat_ind_c3_c4_beta_healthy_stim_pre_reac,...  
                     mean_all_imagescDat_ind_c3_c4_beta_healthy_stim_i05_reac,... 
                     mean_all_imagescDat_ind_c3_c4_beta_healthy_stim_i15_reac,... 
                     mean_all_imagescDat_ind_c3_c4_beta_healthy_stim_pos_reac],0.2)
errorbar([2,5,8,11],[mean_all_imagescDat_ind_c3_c4_beta_healthy_stim_pre_reac,...  
                     mean_all_imagescDat_ind_c3_c4_beta_healthy_stim_i05_reac,... 
                     mean_all_imagescDat_ind_c3_c4_beta_healthy_stim_i15_reac,... 
                     mean_all_imagescDat_ind_c3_c4_beta_healthy_stim_pos_reac],...
                      [se_all_imagescDat_ind_c3_c4_beta_healthy_stim_pre_reac,...  
                       se_all_imagescDat_ind_c3_c4_beta_healthy_stim_i05_reac,... 
                       se_all_imagescDat_ind_c3_c4_beta_healthy_stim_i15_reac,... 
                       se_all_imagescDat_ind_c3_c4_beta_healthy_stim_pos_reac],'.k')
%legend('Stroke','','Healthy','')
set(gca,'XTick',[1 4 7 10],'XTickLabel',{'pre';'i05';'i15';'pos'},'YLim',[0.5 0.9])
ylabel('beta c3-c4 icoh')
title('Stim - Reach')
if p_rank_all_imagescDat_ind_c3_c4_beta_stim_pre_reac<0.05
    text(1.5,0.7,'*','Color','r')
end
if p_rank_all_imagescDat_ind_c3_c4_beta_stim_i05_reac<0.05
    text(4.5,0.7,'*','Color','r')
end
if p_rank_all_imagescDat_ind_c3_c4_beta_stim_i15_reac<0.05
    text(7.5,0.7,'*','Color','r')
end
if p_rank_all_imagescDat_ind_c3_c4_beta_stim_pos_reac<0.05
    text(10.5,0.7,'*','Color','r')
end
 
subplot(7,4,16); hold on
     bar([1,4,7],[mean_all_imagescDat_ind_c3_c4_beta_stroke_stim_pre_hold,...  
                  mean_all_imagescDat_ind_c3_c4_beta_stroke_stim_pre_prep,... 
                  mean_all_imagescDat_ind_c3_c4_beta_stroke_stim_pre_reac],0.2)
errorbar([1,4,7],[mean_all_imagescDat_ind_c3_c4_beta_stroke_stim_pre_hold,...  
                  mean_all_imagescDat_ind_c3_c4_beta_stroke_stim_pre_prep,... 
                  mean_all_imagescDat_ind_c3_c4_beta_stroke_stim_pre_reac],...
                   [se_all_imagescDat_ind_c3_c4_beta_stroke_stim_pre_hold,...  
                    se_all_imagescDat_ind_c3_c4_beta_stroke_stim_pre_prep,... 
                    se_all_imagescDat_ind_c3_c4_beta_stroke_stim_pre_reac],'.k')
     bar([2,5,8],[mean_all_imagescDat_ind_c3_c4_beta_healthy_stim_pre_hold,...  
                  mean_all_imagescDat_ind_c3_c4_beta_healthy_stim_pre_prep,... 
                  mean_all_imagescDat_ind_c3_c4_beta_healthy_stim_pre_reac],0.2)
errorbar([2,5,8],[mean_all_imagescDat_ind_c3_c4_beta_healthy_stim_pre_hold,...  
                  mean_all_imagescDat_ind_c3_c4_beta_healthy_stim_pre_prep,... 
                  mean_all_imagescDat_ind_c3_c4_beta_healthy_stim_pre_reac],...
                   [se_all_imagescDat_ind_c3_c4_beta_healthy_stim_pre_hold,...  
                    se_all_imagescDat_ind_c3_c4_beta_healthy_stim_pre_prep,... 
                    se_all_imagescDat_ind_c3_c4_beta_healthy_stim_pre_reac],'.k')
%legend('Stroke','','Healthy','')
set(gca,'XTick',[1 4 7],'XTickLabel',{'hold';'prep';'reac'},'YLim',[0.5 0.9])
ylabel('beta c3-c4 icoh')
title('Stim - Pre')
if p_rank_all_imagescDat_ind_c3_c4_beta_stim_pre_hold<0.05
    text(1.5,0.7,'*','Color','r')
end
if p_rank_all_imagescDat_ind_c3_c4_beta_stim_pre_prep<0.05
    text(4.5,0.7,'*','Color','r')
end
if p_rank_all_imagescDat_ind_c3_c4_beta_stim_pre_reac<0.05
    text(7.5,0.7,'*','Color','r')
end

subplot(7,4,20); hold on
     bar([1,4,7],[mean_all_imagescDat_ind_c3_c4_beta_stroke_stim_i05_hold,...  
                  mean_all_imagescDat_ind_c3_c4_beta_stroke_stim_i05_prep,... 
                  mean_all_imagescDat_ind_c3_c4_beta_stroke_stim_i05_reac],0.2)
errorbar([1,4,7],[mean_all_imagescDat_ind_c3_c4_beta_stroke_stim_i05_hold,...  
                  mean_all_imagescDat_ind_c3_c4_beta_stroke_stim_i05_prep,... 
                  mean_all_imagescDat_ind_c3_c4_beta_stroke_stim_i05_reac],...
                   [se_all_imagescDat_ind_c3_c4_beta_stroke_stim_i05_hold,...  
                    se_all_imagescDat_ind_c3_c4_beta_stroke_stim_i05_prep,... 
                    se_all_imagescDat_ind_c3_c4_beta_stroke_stim_i05_reac],'.k')
     bar([2,5,8],[mean_all_imagescDat_ind_c3_c4_beta_healthy_stim_i05_hold,...  
                  mean_all_imagescDat_ind_c3_c4_beta_healthy_stim_i05_prep,... 
                  mean_all_imagescDat_ind_c3_c4_beta_healthy_stim_i05_reac],0.2)
errorbar([2,5,8],[mean_all_imagescDat_ind_c3_c4_beta_healthy_stim_i05_hold,...  
                  mean_all_imagescDat_ind_c3_c4_beta_healthy_stim_i05_prep,... 
                  mean_all_imagescDat_ind_c3_c4_beta_healthy_stim_i05_reac],...
                   [se_all_imagescDat_ind_c3_c4_beta_healthy_stim_i05_hold,...  
                    se_all_imagescDat_ind_c3_c4_beta_healthy_stim_i05_prep,... 
                    se_all_imagescDat_ind_c3_c4_beta_healthy_stim_i05_reac],'.k')
%legend('Stroke','','Healthy','')
set(gca,'XTick',[1 4 7],'XTickLabel',{'hold';'prep';'reac'},'YLim',[0.5 0.9])
ylabel('beta c3-c4 icoh')
title('Stim - I05')
if p_rank_all_imagescDat_ind_c3_c4_beta_stim_i05_hold<0.05
    text(1.5,0.7,'*','Color','r')
end
if p_rank_all_imagescDat_ind_c3_c4_beta_stim_i05_prep<0.05
    text(4.5,0.7,'*','Color','r')
end
if p_rank_all_imagescDat_ind_c3_c4_beta_stim_i05_reac<0.05
    text(7.5,0.7,'*','Color','r')
end

subplot(7,4,24); hold on
     bar([1,4,7],[mean_all_imagescDat_ind_c3_c4_beta_stroke_stim_i15_hold,...  
                  mean_all_imagescDat_ind_c3_c4_beta_stroke_stim_i15_prep,... 
                  mean_all_imagescDat_ind_c3_c4_beta_stroke_stim_i15_reac],0.2)
errorbar([1,4,7],[mean_all_imagescDat_ind_c3_c4_beta_stroke_stim_i15_hold,...  
                  mean_all_imagescDat_ind_c3_c4_beta_stroke_stim_i15_prep,... 
                  mean_all_imagescDat_ind_c3_c4_beta_stroke_stim_i15_reac],...
                   [se_all_imagescDat_ind_c3_c4_beta_stroke_stim_i15_hold,...  
                    se_all_imagescDat_ind_c3_c4_beta_stroke_stim_i15_prep,... 
                    se_all_imagescDat_ind_c3_c4_beta_stroke_stim_i15_reac],'.k')
     bar([2,5,8],[mean_all_imagescDat_ind_c3_c4_beta_healthy_stim_i15_hold,...  
                  mean_all_imagescDat_ind_c3_c4_beta_healthy_stim_i15_prep,... 
                  mean_all_imagescDat_ind_c3_c4_beta_healthy_stim_i15_reac],0.2)
errorbar([2,5,8],[mean_all_imagescDat_ind_c3_c4_beta_healthy_stim_i15_hold,...  
                  mean_all_imagescDat_ind_c3_c4_beta_healthy_stim_i15_prep,... 
                  mean_all_imagescDat_ind_c3_c4_beta_healthy_stim_i15_reac],...
                   [se_all_imagescDat_ind_c3_c4_beta_healthy_stim_i15_hold,...  
                    se_all_imagescDat_ind_c3_c4_beta_healthy_stim_i15_prep,... 
                    se_all_imagescDat_ind_c3_c4_beta_healthy_stim_i15_reac],'.k')
%legend('Stroke','','Healthy','')
set(gca,'XTick',[1 4 7],'XTickLabel',{'hold';'prep';'reac'},'YLim',[0.5 0.9])
ylabel('beta c3-c4 icoh')
title('Stim - I15')
if p_rank_all_imagescDat_ind_c3_c4_beta_stim_i15_hold<0.05
    text(1.5,0.7,'*','Color','r')
end
if p_rank_all_imagescDat_ind_c3_c4_beta_stim_i15_prep<0.05
    text(4.5,0.7,'*','Color','r')
end
if p_rank_all_imagescDat_ind_c3_c4_beta_stim_i15_reac<0.05
    text(7.5,0.7,'*','Color','r')
end

subplot(7,4,28); hold on
     bar([1,4,7],[mean_all_imagescDat_ind_c3_c4_beta_stroke_stim_pos_hold,...  
                  mean_all_imagescDat_ind_c3_c4_beta_stroke_stim_pos_prep,... 
                  mean_all_imagescDat_ind_c3_c4_beta_stroke_stim_pos_reac],0.2)
errorbar([1,4,7],[mean_all_imagescDat_ind_c3_c4_beta_stroke_stim_pos_hold,...  
                  mean_all_imagescDat_ind_c3_c4_beta_stroke_stim_pos_prep,... 
                  mean_all_imagescDat_ind_c3_c4_beta_stroke_stim_pos_reac],...
                   [se_all_imagescDat_ind_c3_c4_beta_stroke_stim_pos_hold,...  
                    se_all_imagescDat_ind_c3_c4_beta_stroke_stim_pos_prep,... 
                    se_all_imagescDat_ind_c3_c4_beta_stroke_stim_pos_reac],'.k')
     bar([2,5,8],[mean_all_imagescDat_ind_c3_c4_beta_healthy_stim_pos_hold,...  
                  mean_all_imagescDat_ind_c3_c4_beta_healthy_stim_pos_prep,... 
                  mean_all_imagescDat_ind_c3_c4_beta_healthy_stim_pos_reac],0.2)
errorbar([2,5,8],[mean_all_imagescDat_ind_c3_c4_beta_healthy_stim_pos_hold,...  
                  mean_all_imagescDat_ind_c3_c4_beta_healthy_stim_pos_prep,... 
                  mean_all_imagescDat_ind_c3_c4_beta_healthy_stim_pos_reac],...
                   [se_all_imagescDat_ind_c3_c4_beta_healthy_stim_pos_hold,...  
                    se_all_imagescDat_ind_c3_c4_beta_healthy_stim_pos_prep,... 
                    se_all_imagescDat_ind_c3_c4_beta_healthy_stim_pos_reac],'.k')
%legend('Stroke','','Healthy','')
set(gca,'XTick',[1 4 7],'XTickLabel',{'hold';'prep';'reac'},'YLim',[0.5 0.9])
ylabel('beta c3-c4 icoh')
title('Stim - Pos')
if p_rank_all_imagescDat_ind_c3_c4_beta_stim_pos_hold<0.05
    text(1.5,0.7,'*','Color','r')
end
if p_rank_all_imagescDat_ind_c3_c4_beta_stim_pos_prep<0.05
    text(4.5,0.7,'*','Color','r')
end
if p_rank_all_imagescDat_ind_c3_c4_beta_stim_pos_reac<0.05
    text(7.5,0.7,'*','Color','r')
end



% all_sum_c3_c4_beta_stroke_stim_reac=[all_imagescDat_ind_c3_c4_beta_stroke_stim_pre_reac',...
%     all_imagescDat_ind_c3_c4_beta_stroke_stim_i05_reac',all_imagescDat_ind_c3_c4_beta_stroke_stim_i15_reac',...
%     all_imagescDat_ind_c3_c4_beta_stroke_stim_pos_reac']
% 
% 
% data_grp_icohmat_Beta_stroke_prestim_Reach_Stim(8,20,1)
% data_grp_icohmat_Beta_stroke_prestim_Reach_Stim(8,20,2)
% data_grp_icohmat_Beta_stroke_prestim_Reach_Stim(8,20,3)
% data_grp_icohmat_Beta_stroke_prestim_Reach_Stim(8,20,4)
% data_grp_icohmat_Beta_stroke_prestim_Reach_Stim(8,20,5)
% 
% data_grp_icohmat_Beta_stroke_intra5_Reach_Stim(8,20,1)
% data_grp_icohmat_Beta_stroke_intra5_Reach_Stim(8,20,2)
% data_grp_icohmat_Beta_stroke_intra5_Reach_Stim(8,20,3)
% data_grp_icohmat_Beta_stroke_intra5_Reach_Stim(8,20,4)
% data_grp_icohmat_Beta_stroke_intra5_Reach_Stim(8,20,5)
% 
% data_grp_icohmat_Beta_stroke_intra15_Reach_Stim(8,20,1)
% data_grp_icohmat_Beta_stroke_intra15_Reach_Stim(8,20,2)
% data_grp_icohmat_Beta_stroke_intra15_Reach_Stim(8,20,3)
% data_grp_icohmat_Beta_stroke_intra15_Reach_Stim(8,20,4)
% data_grp_icohmat_Beta_stroke_intra15_Reach_Stim(8,20,5)
% 
% data_grp_icohmat_Beta_stroke_poststim5_Reach_Stim(8,20,1)
% data_grp_icohmat_Beta_stroke_poststim5_Reach_Stim(8,20,2)
% data_grp_icohmat_Beta_stroke_poststim5_Reach_Stim(8,20,3)
% data_grp_icohmat_Beta_stroke_poststim5_Reach_Stim(8,20,4)
% data_grp_icohmat_Beta_stroke_poststim5_Reach_Stim(8,20,5)
% 
% [f_p_all_c3_c4_beta_stroke_stim_reac,f_tab_all_c3_c4_beta_stroke_stim_reac,f_stats_all_c3_c4_beta_stroke_stim_reac]=...
%     friedman(all_c3_c4_beta_stroke_stim_reac)

%% Coherence diff

TOI={'pre-stim (baseline)','intrastim (5 min)','intrastim (15 min)','post-stim (5 min)'};
phases={'Hold','Prep','Reach'};
DOI={'stroke','healthy'};
stimtypes=[0,2];
stimname={'Sham','Stim'};
electrodes={'F7','T3','T5','O1','F3','C3','P3','A1','Fz','Cz','Fp2','F8','T4','T6','O2','F4','C4','P4','A2','Pz','Fp1'};
FOI_label={'Alpha','Beta','Gamma'};
FOI_freq={{8,12},{13,30},{30,50}};
savefigures=true;
outpath='/home/rowlandn/nr_data_analysis/data_analyzed/eeg/gen_03/Analysis';
iCohdiffFolder=fullfile(outpath,'iCohdiff');
mkdir(iCohdiffFolder);
%outpath='C:\Users\allen\Desktop\RowlandFigs_11_22_21\Coh';

for f=1:numel(FOI_freq)
    for d=1:numel(DOI)
        %figure('WindowState','maximized')
        figure; set(gcf,'Position',[2371 385 593 430])
        ax_count=1;
        clear h
        cmin=[];
        cmax=[];
        for t=1:numel(TOI)
            for p=1:numel(phases)-1
                
                tempdisease=[];
                tempstim=[];
                matcoh1=[];
                matcoh2=[];
                
                for s=1:numel(sbj)
                    
                    % Calculate coherence 1
                    sbjicoh=subjectData(s).iCoh;
                    FOI_idx=sbjicoh.freq>=FOI_freq{f}{1} & sbjicoh.freq<=FOI_freq{f}{2};
                    TOI_idx=strcmp(subjectData(s).sessioninfo.trialnames,TOI{t});
                    tempdat=mean(mean(sbjicoh.data(:,FOI_idx,:,p,TOI_idx),2,'omitnan'),3,'omitnan');
                    tempmatcoh=nan(numel(electrodes));
                    for i=1:numel(tempdat)
                        templabel=sbjicoh.label(i,:);
                        tempmatcoh(strcmp(templabel{1},electrodes),strcmp(templabel{2},electrodes))=tempdat(i);
                        tempmatcoh(strcmp(templabel{2},electrodes),strcmp(templabel{1},electrodes))=tempdat(i);
                        
                        % Make diag nan
                        tempmatcoh(logical(diag(ones(size(tempmatcoh,1),1))))=nan;
                    end
                    matcoh1(:,:,s)=tempmatcoh;
                    
                    % Calculate coherence 2
                    sbjicoh=subjectData(s).iCoh;
                    FOI_idx=sbjicoh.freq>=FOI_freq{f}{1} & sbjicoh.freq<=FOI_freq{f}{2};
                    TOI_idx=strcmp(subjectData(s).sessioninfo.trialnames,TOI{t});
                    tempdat=mean(mean(sbjicoh.data(:,FOI_idx,:,p+1,TOI_idx),2,'omitnan'),3,'omitnan');
                    tempmatcoh=nan(numel(electrodes));
                    for i=1:numel(tempdat)
                        templabel=sbjicoh.label(i,:);
                        tempmatcoh(strcmp(templabel{1},electrodes),strcmp(templabel{2},electrodes))=tempdat(i);
                        tempmatcoh(strcmp(templabel{2},electrodes),strcmp(templabel{1},electrodes))=tempdat(i);
                        
                        % Make diag nan
                        tempmatcoh(logical(diag(ones(size(tempmatcoh,1),1))))=nan;
                    end
                    matcoh2(:,:,s)=tempmatcoh;
                    
                    % Organize disease
                    tempdisease{s,1}=subjectData(s).sessioninfo.dx;
                    
                    % Organize stim
                    tempstim(s,1)=subjectData(s).sessioninfo.stimamp;
                end
                
                % Find diff
                matcoh=(matcoh2-matcoh1)./matcoh1*100;
                
                for s=1:numel(stimtypes)
                    h(ax_count)=subplot(numel(TOI),(numel(phases)-1)*numel(stimtypes),p+((s-1)*(numel(phases)-1))+((t-1)*(numel(phases)-1)*numel(stimtypes)));
                    ax_count=ax_count+1;
                    idx=tempstim==stimtypes(s)&strcmp(tempdisease,DOI{d});
                    imagescDat=mean(matcoh(:,:,idx),3);
                    imagesc(imagescDat)
                    
                    % Find caxis
                    cmin=min([cmin; imagescDat(:)]);
                    cmax=max([cmax; imagescDat(:)]);
                    
                    colormap jet
                    xticks([1:numel(electrodes)])
                    xticklabels(electrodes)
                    yticks([1:numel(electrodes)])
                    yticklabels(electrodes)
                    title([phases{p},' - ',phases{p+1}])
                    subtitle(stimname{s})
                    ylabel(TOI{t})
                end
            end
        end
        
        % link axis
        for i=1:numel(h)
            caxis(h(i),[cmin cmax])
        end
        
        % Colorbar
        cbh = colorbar(h(end));
        cbh.Location='layout';
        cbh.Position=[.9314 .11 .0281 .8150];
        ylabel(cbh,['% Diff Coherence ',FOI_label{f}],'FontSize',12)
        figtitle=sprintf('%s Percent Diff Coherence - %s',FOI_label{f},DOI{d});
        
        
        % Title
        sgtitle(DOI{d})
        
        % Save figure
        if savefigures
            savefig(gcf,fullfile(iCohdiffFolder,figtitle));
        end
        
        
        % % %         % Load cap
        % % %         ec=load('easycapM1.mat');
        % % %
        % % %         %%%%% Run Topoplot function
        % % %         figure('WindowState','maximized')
        % % %         ax_count=1;
        % % %         clear h
        % % %         cmin=[];
        % % %         cmax=[];
        % % %         for t=1:numel(TOI)
        % % %             for p=1:numel(phases)-1
        % % %
        % % %                 tempdisease=[];
        % % %                 tempstim=[];
        % % %                 matcoh1=[];
        % % %                 matcoh2=[];
        % % %
        % % %                 for s=1:numel(sbj)
        % % %
        % % %                     % Calculate coherence 1
        % % %                     sbjicoh=subjectData(s).iCoh;
        % % %                     FOI_idx=sbjicoh.freq>=FOI_freq{f}{1} & sbjicoh.freq<=FOI_freq{f}{2};
        % % %                     TOI_idx=strcmp(subjectData(s).sessioninfo.trialnames,TOI{t});
        % % %                     tempdat=mean(mean(sbjicoh.data(:,FOI_idx,:,p,TOI_idx),2,'omitnan'),3,'omitnan');
        % % %                     tempmatcoh=nan(numel(electrodes));
        % % %                     for i=1:numel(tempdat)
        % % %                         templabel=sbjicoh.label(i,:);
        % % %                         tempmatcoh(strcmp(templabel{1},electrodes),strcmp(templabel{2},electrodes))=tempdat(i);
        % % %                         tempmatcoh(strcmp(templabel{2},electrodes),strcmp(templabel{1},electrodes))=tempdat(i);
        % % %
        % % %                         % Make diag nan
        % % %                         tempmatcoh(logical(diag(ones(size(tempmatcoh,1),1))))=nan;
        % % %                     end
        % % %                     matcoh1(:,:,s)=tempmatcoh;
        % % %
        % % %                     % Calculate coherence 2
        % % %                     sbjicoh=subjectData(s).iCoh;
        % % %                     FOI_idx=sbjicoh.freq>=FOI_freq{f}{1} & sbjicoh.freq<=FOI_freq{f}{2};
        % % %                     TOI_idx=strcmp(subjectData(s).sessioninfo.trialnames,TOI{t});
        % % %                     tempdat=mean(mean(sbjicoh.data(:,FOI_idx,:,p+1,TOI_idx),2,'omitnan'),3,'omitnan');
        % % %                     tempmatcoh=nan(numel(electrodes));
        % % %                     for i=1:numel(tempdat)
        % % %                         templabel=sbjicoh.label(i,:);
        % % %                         tempmatcoh(strcmp(templabel{1},electrodes),strcmp(templabel{2},electrodes))=tempdat(i);
        % % %                         tempmatcoh(strcmp(templabel{2},electrodes),strcmp(templabel{1},electrodes))=tempdat(i);
        % % %
        % % %                         % Make diag nan
        % % %                         tempmatcoh(logical(diag(ones(size(tempmatcoh,1),1))))=nan;
        % % %                     end
        % % %                     matcoh2(:,:,s)=tempmatcoh;
        % % %
        % % %                     % Organize disease
        % % %                     tempdisease{s,1}=subjectData(s).sessioninfo.dx;
        % % %
        % % %                     % Organize stim
        % % %                     tempstim(s,1)=subjectData(s).sessioninfo.stimamp;
        % % %                 end
        % % %
        % % %                 % Find diff
        % % %                 matcoh=(matcoh2-matcoh1)./matcoh1*100;
        % % %
        % % %                 for s=1:numel(stimtypes)
        % % %                     h(ax_count)=subplot(numel(TOI),(numel(phases)-1)*numel(stimtypes),p+((s-1)*(numel(phases)-1))+((t-1)*(numel(phases)-1)*numel(stimtypes)));
        % % %                     ax_count=ax_count+1;
        % % %                     idx=tempstim==stimtypes(s)&strcmp(tempdisease,DOI{d});
        % % %                     imagescDat=mean(matcoh(:,:,idx),3);
        % % %
        % % %
        % % %                      % Setup cfg structure
        % % %                     cfg                 = [];
        % % %                     cfg.parameter       = 'powspctrm';
        % % %                     cfg.colorbar        = 'yes';
        % % %                     cfg.marker          = 'labels';
        % % %                     cfg.fontsize        = 12;
        % % %                     cfg.comment         = 'no';
        % % %                     cfg.gridscale       = 200;
        % % %                     cfg.layout          = 'easycapM1';
        % % %
        % % %
        % % %
        % % %                     % Setup data
        % % %                     electroderank.label=electrodes;
        % % %                     electroderank.freq=5;
        % % %                     electroderank.powspctrm=ones(numel(ec.lay.label),1)*28;
        % % %                     electroderank.dimord='rpt_chan_freq';
        % % %
        % % %                     % Run topoplot
        % % %                     figure('WindowState','maximized')
        % % %                     ft_topoplotTFR(cfg,electroderank);
        % % %                     sgtitle(['Patient ',num2str(iter)])
        % % %                     h = colorbar;
        % % %                     colormap(flipud(jet))
        % % %                     set( h, 'YDir', 'reverse' )
        % % %                     h.Label.String='Rank of Electrode';
        % % %
        % % %                 end
        % % %             end
        % % %         end
        
        close all
    end
end
%cd(outpath)

%Let's try to use the data_grp variables to do this
distype={'stroke';'healthy'};
stimtype={'Sham';'Stim'};
timetype={'prestim';'intra5';'intra15';'poststim5'};
phasedifftype={'Hold';'Prep';'Reach'};
electrodes={'A1','Fp1','F7','T3','T5','O1','F3','C3','P3','Fz','Cz','Pz','A2','Fp2','F8','T4','T6','O2','F4','C4','P4'};
load('~/nr_data_analysis/data_analyzed/eeg/gen_03/Analysis/iCohMatrix/data_grp_icohmatrices_2022_04_10_acdata.mat')


%THIS IS WHERE YOU NEED TO REVERSE DIFF CALC!!!!!!! DO IT CAREFULLY!!!!
for i=1:size(distype,1)
    for j=1:size(timetype,1)
        for k=1:size(phasedifftype,1)-1
            for l=1:size(stimtype,1)
                eval(['data_grp_diff_icohmat_Beta_',distype{i},'_',timetype{j},'_',phasedifftype{k},'_',phasedifftype{k+1},'_',stimtype{l},...
                    '=(data_grp_icohmat_Beta_',distype{i},'_',timetype{j},'_',phasedifftype{k},'_',stimtype{l},...
                    '-data_grp_icohmat_Beta_',distype{i},'_',timetype{j},'_',phasedifftype{k+1},'_',stimtype{l},')',...
                    './data_grp_icohmat_Beta_',distype{i},'_',timetype{j},'_',phasedifftype{k},'_',stimtype{l},'*100;'])
            end
        end
    end
end

%THIS IS WHERE YOU NEED TO REVERSE DIFF CALC!!!!!!! DO IT CAREFULLY!!!!
for i=1:size(distype,1)
    for j=1:size(timetype,1)
        for k=1:size(phasedifftype,1)-1
            for l=1:size(stimtype,1)
                eval(['data_grp_diffa_icohmat_Beta_',distype{i},'_',timetype{j},'_',phasedifftype{k},'_',phasedifftype{k+1},'_',stimtype{l},...
                    '=(data_grp_icohmat_Beta_',distype{i},'_',timetype{j},'_',phasedifftype{k+1},'_',stimtype{l},...
                    '-data_grp_icohmat_Beta_',distype{i},'_',timetype{j},'_',phasedifftype{k},'_',stimtype{l},')',...
                    './data_grp_icohmat_Beta_',distype{i},'_',timetype{j},'_',phasedifftype{k},'_',stimtype{l},'*100;'])
            end
        end
    end
end
clear data_grp_icohmat*

c=clock;
y=sprintf('%0.5g',[c(1)]);
m=sprintf('%0.5g',[c(2)]);
d=sprintf('%0.5g',[c(3)]);
if str2num(m)<10
    m=['0',m];
end
if str2num(d)<10
    d=['0',d];
end
date=[y,'_',m,'_',d];

% eval([['data_grp_icohmatrices_',date],'=data_grp_icoh_barmat']);
save([iCohdiffFolder,'/',['data_grp_icohdiffamatrices_',date]],['data_grp_diffa_icohmat*'])



% 
% 
% load ~/nr_data_analysis/data_analyzed/eeg/gen_03/Analysis/subjectname.mat
%    
% distype={'stroke';'healthy'};
% timetype={'prestim';'intra5';'intra15';'poststim5'};
% stimtype={'Sham';'Stim'};
% phasedifftype={'Hold';'Prep';'Reach'};
% sp1=[1,5,9,13];
% sp2=[2,6,10,14];
% sp3=[3,7,11,15];
% sp4=[4,8,12,16];
% 
% 
% figure; set(gcf,'Position',[2133 109 1214 834])
% for i=1%:size(distype,1)
%     for j=1:size(timetype,1)
%         for k=1%:size(phasedifftype,1)-1
%             for l=1%:size(stimtype,1)
%                 
%                 if k==1 & l==1
%                     subplot(4,4,sp1(j))
%                 elseif k==2 & l==1
%                     subplot(4,4,sp2(j))
%                 elseif k==1 & l==2
%                     subplot(4,4,sp3(j))
%                 elseif k==2 & l==2
%                     subplot(4,4,sp4(j))
%                 end
%     
%                 eval(['imagesc(data_grp_diff_icohmat_Beta_',distype{i},'_',timetype{j},'_',phasedifftype{k},...
%                     '_',phasedifftype{k+1},'_',stimtype{l},'(:,:,1))'])
%                 colormap('jet');
%                 xticks([1:numel(electrodes)])
%                 xticklabels(electrodes)
%                 yticks([1:numel(electrodes)])
%                 yticklabels(electrodes)
%                 title([phasedifftype{k},'-',phasedifftype{k+1}])
%                 subtitle(stimtype{l})
%                 ylabel(timetype{j})
%             end
%         end
%     end
% end

%Individual diff plots for BETA!!
load('~/nr_data_analysis/data_analyzed/eeg/gen_03/Analysis/subjectname.mat')
for sbj=1:numel(sbj_name)
    
    if isempty(sbj_name{sbj})
    else
        figure; set(gcf,'Position',[2248 247 751 606])

        if sbj>=1 & sbj<=6
            distype='stroke';
            stimtype='Sham';
        elseif sbj>=7 & sbj<=12
            distype='stroke';
            stimtype='Stim';
        elseif sbj>=13 & sbj<=18
            distype='healthy';
            stimtype='Sham';
        elseif sbj>=19 & sbj<=24
            distype='healthy';
            stimtype='Stim';
        end

        %extract subject row
        [sbj_r,sbj_c]=ind2sub(size(sbj_name),sbj);

        for t=1:numel(TOI)
            subplot(4,2,2*t-1)
            if t==1
                eval(['imagescDat=data_grp_diffa_icohmat_Beta_',distype,'_prestim_Hold_Prep_',stimtype,'(:,:,sbj_r);']);
                eval(['imagescDat_p1_t1_diff=data_grp_diffa_icohmat_Beta_',distype,'_prestim_Hold_Prep_',stimtype,'(20,8,sbj_r);']);
                %imagescDat=data_grp_diffa_icohmat_Beta_stroke_prestim_Hold_PrepStim(:,:,sbj);
            elseif t==2
                eval(['imagescDat=data_grp_diffa_icohmat_Beta_',distype,'_intra5_Hold_Prep_',stimtype,'(:,:,sbj_r);']);
                eval(['imagescDat_p1_t2_diff=data_grp_diffa_icohmat_Beta_',distype,'_intra5_Hold_Prep_',stimtype,'(20,8,sbj_r);']);
                %imagescDat=data_grp_diffa_icohmat_Beta_stroke_intra5_Hold_PrepStim(:,:,sbj);
            elseif t==3
                eval(['imagescDat=data_grp_diffa_icohmat_Beta_',distype,'_intra15_Hold_Prep_',stimtype,'(:,:,sbj_r);']);
                eval(['imagescDat_p1_t3_diff=data_grp_diffa_icohmat_Beta_',distype,'_intra15_Hold_Prep_',stimtype,'(20,8,sbj_r);']);
                %imagescDat=data_grp_diffa_icohmat_Beta_stroke_intra15_Hold_PrepStim(:,:,sbj);
            elseif t==4
                eval(['imagescDat=data_grp_diffa_icohmat_Beta_',distype,'_poststim5_Hold_Prep_',stimtype,'(:,:,sbj_r);']);
                eval(['imagescDat_p1_t4_diff=data_grp_diffa_icohmat_Beta_',distype,'_poststim5_Hold_Prep_',stimtype,'(20,8,sbj_r);']);
                %imagescDat=data_grp_diffa_icohmat_Beta_stroke_poststim5_Hold_PrepStim(:,:,sbj);
            end

        %             if norm
        %                 imagescDat1(logical(diag(ones(size(imagescDat1,1),1))))=mean(imagescDat1,'all');
        %                 imagescDat1=mat2gray(imagescDat1);
        %                 imagescDat1(logical(diag(ones(size(imagescDat1,1),1))))=nan;
        %             end
            imagesc(imagescDat)
            %axis square

            colormap('jet');
            xticks([1:numel(electrodes)])
            xticklabels(electrodes)
            yticks([1:numel(electrodes)])
            yticklabels(electrodes)
            title(['Hold-Prep'])
            %subtitle(stimname{2})%s
            subtitle(stimtype)
            ylabel(TOI{t})

        end

        for t=1:numel(TOI)
            subplot(4,2,2*t)
            if t==1
                eval(['imagescDat=data_grp_diffa_icohmat_Beta_',distype,'_prestim_Prep_Reach_',stimtype,'(:,:,sbj_r);']);
                eval(['imagescDat_p2_t1_diff=data_grp_diffa_icohmat_Beta_',distype,'_prestim_Prep_Reach_',stimtype,'(20,8,sbj_r);']);
                %imagescDat=data_grp_diffa_icohmat_Beta_stroke_prestim_Prep_ReachStim(:,:,sbj);
            elseif t==2
                eval(['imagescDat=data_grp_diffa_icohmat_Beta_',distype,'_intra5_Prep_Reach_',stimtype,'(:,:,sbj_r);']);
                eval(['imagescDat_p2_t2_diff=data_grp_diffa_icohmat_Beta_',distype,'_intra5_Prep_Reach_',stimtype,'(20,8,sbj_r);']);
                %imagescDat=data_grp_diffa_icohmat_Beta_stroke_intra5_Prep_ReachStim(:,:,sbj);
            elseif t==3
                eval(['imagescDat=data_grp_diffa_icohmat_Beta_',distype,'_intra15_Prep_Reach_',stimtype,'(:,:,sbj_r);']);
                eval(['imagescDat_p2_t3_diff=data_grp_diffa_icohmat_Beta_',distype,'_intra15_Prep_Reach_',stimtype,'(20,8,sbj_r);']);
                %imagescDat=data_grp_diffa_icohmat_Beta_stroke_intra15_Prep_ReachStim(:,:,sbj);
            elseif t==4
                eval(['imagescDat=data_grp_diffa_icohmat_Beta_',distype,'_poststim5_Prep_Reach_',stimtype,'(:,:,sbj_r);']);
                eval(['imagescDat_p2_t4_diff=data_grp_diffa_icohmat_Beta_',distype,'_poststim5_Prep_Reach_',stimtype,'(20,8,sbj_r);']);
                %imagescDat=data_grp_diffa_icohmat_Beta_stroke_poststim5_Prep_ReachStim(:,:,sbj);
            end

    %             if norm
    %                 imagescDat1(logical(diag(ones(size(imagescDat1,1),1))))=mean(imagescDat1,'all');
    %                 imagescDat1=mat2gray(imagescDat1);
    %                 imagescDat1(logical(diag(ones(size(imagescDat1,1),1))))=nan;
    %             end
            imagesc(imagescDat)
            %axis square

            colormap('jet');
            xticks([1:numel(electrodes)])
            xticklabels(electrodes)
            yticks([1:numel(electrodes)])
            yticklabels(electrodes)
            title(['Prep-Reach'])
            %subtitle(stimname{2})%s
            subtitle(stimtype)
            ylabel(TOI{t})

        end


        %sbj
        sgtitle([sbj_name{sbj},' ',distype,' ',stimtype])
        %[sbj_name{sbj},' ',distype,' ',stimtype]

        %Colorbar
        %cbh = colorbar(h(end));
        cbh = colorbar;
        cbh.Location='layout';
        cbh.Position=[.9314 .11 .0281 .8150];
        ylabel(cbh,'Coherence','FontSize',12)
        
%         if norm
%             ylabel(cbh,['Normalized ',FOI_label{f},' Coherence'],'FontSize',12)
%             figtitle=sprintf('%s Coherence Matrix - %s Normalized',FOI_label{f},DOI{d});
%         else
%             ylabel(cbh,['Coherence ',FOI_label{f}],'FontSize',12)
%             figtitle=sprintf('%s Coherence Matrix - %s',FOI_label{f},DOI{d});
%         end
        
        imagescDat_ind_diff_c3_c4{sbj_r,sbj_c}(1,1)=imagescDat_p1_t1_diff;
        imagescDat_ind_diff_c3_c4{sbj_r,sbj_c}(2,1)=imagescDat_p1_t2_diff;
        imagescDat_ind_diff_c3_c4{sbj_r,sbj_c}(3,1)=imagescDat_p1_t3_diff;
        imagescDat_ind_diff_c3_c4{sbj_r,sbj_c}(4,1)=imagescDat_p1_t4_diff;

        imagescDat_ind_diff_c3_c4{sbj_r,sbj_c}(1,2)=imagescDat_p2_t1_diff;
        imagescDat_ind_diff_c3_c4{sbj_r,sbj_c}(2,2)=imagescDat_p2_t2_diff;
        imagescDat_ind_diff_c3_c4{sbj_r,sbj_c}(3,2)=imagescDat_p2_t3_diff;
        imagescDat_ind_diff_c3_c4{sbj_r,sbj_c}(4,2)=imagescDat_p2_t4_diff;
 

    end
end

%This is for ind c3-4 plots
figure; set(gcf,'Position',[2133 109 1214 834])
sp_vec=[1,7,13,19,2,8,14,20,3,9,15,21,4,10,16,22,5,11,17,23,NaN,NaN,NaN,24];
for sbj=1:numel(sbj_name)
    %if isempty(sbj_name{sbj})
    if isnan(sp_vec(sbj))
    else
        subplot(6,4,sbj)
        imagesc(imagescDat_ind_diff_c3_c4{sp_vec(sbj)})
        ylabel(sbj_name{sp_vec(sbj)},'Fontweight','bold')
        colormap('jet');
        set(gca,'YTick',[1:4],'YTickLabel',['pre';'i05';'i15';'pos'],'XTick',[1:2],'XTickLabel',['HP';'PR'])
        if sbj==1
            title('stroke')
            subtitle ('sham')
        elseif sbj==2
            title('stroke')
            subtitle ('stim')
        elseif sbj==3
            title('healthy')
            subtitle ('sham')
        elseif sbj==4
            title('healthy')
            subtitle ('stim')
        end
            
        %Colorbar
        cbh = colorbar;
        cbh.Location='layout';
        cbh.Position=[.9314 .11 .0281 .8150];
        ylabel(cbh,'Coherence','FontSize',12)
        f=2;
%         if norm
%             ylabel(cbh,['Normalized ',FOI_label{f},' C3-4 Coherence'],'FontSize',12)
%             figtitle=sprintf('%s Coherence Matrix - %s Normalized',FOI_label{f},DOI{d});
%         else
%             ylabel(cbh,['C3-4 Coherence ',FOI_label{f}],'FontSize',12)
%             figtitle=sprintf('%s Coherence Matrix - %s',FOI_label{f},DOI{d});
%         end
    end
end


for sbj=1:numel(imagescDat_ind_diff_c3_c4)
    if isempty(sbj_name{sbj})
    else
        %for 
            
            if sbj>=1 & sbj<=6
                distype='stroke';
                stimtype='sham';
                [sbj_r,sbj_c]=ind2sub(size(sbj_name),sbj);
                eval(['all_imagescDat_ind_diff_c3_c4_beta_',distype,'_',stimtype,'_pre_hold_prep(sbj_r)=imagescDat_ind_diff_c3_c4{sbj_r,1}(1,1);']);
                eval(['all_imagescDat_ind_diff_c3_c4_beta_',distype,'_',stimtype,'_i05_hold_prep(sbj_r)=imagescDat_ind_diff_c3_c4{sbj_r,1}(2,1);']);
                eval(['all_imagescDat_ind_diff_c3_c4_beta_',distype,'_',stimtype,'_i15_hold_prep(sbj_r)=imagescDat_ind_diff_c3_c4{sbj_r,1}(3,1);']);
                eval(['all_imagescDat_ind_diff_c3_c4_beta_',distype,'_',stimtype,'_pos_hold_prep(sbj_r)=imagescDat_ind_diff_c3_c4{sbj_r,1}(4,1);']);
                
                eval(['all_imagescDat_ind_diff_c3_c4_beta_',distype,'_',stimtype,'_pre_prep_reac(sbj_r)=imagescDat_ind_diff_c3_c4{sbj_r,1}(1,2);']);
                eval(['all_imagescDat_ind_diff_c3_c4_beta_',distype,'_',stimtype,'_i05_prep_reac(sbj_r)=imagescDat_ind_diff_c3_c4{sbj_r,1}(2,2);']);
                eval(['all_imagescDat_ind_diff_c3_c4_beta_',distype,'_',stimtype,'_i15_prep_reac(sbj_r)=imagescDat_ind_diff_c3_c4{sbj_r,1}(3,2);']);
                eval(['all_imagescDat_ind_diff_c3_c4_beta_',distype,'_',stimtype,'_pos_prep_reac(sbj_r)=imagescDat_ind_diff_c3_c4{sbj_r,1}(4,2);']);
                                              
            elseif sbj>=7 & sbj<=12
                distype='stroke';
                stimtype='stim';
                [sbj_r,sbj_c]=ind2sub(size(sbj_name),sbj);
                eval(['all_imagescDat_ind_diff_c3_c4_beta_',distype,'_',stimtype,'_pre_hold_prep(sbj_r)=imagescDat_ind_diff_c3_c4{sbj_r,2}(1,1);']);
                eval(['all_imagescDat_ind_diff_c3_c4_beta_',distype,'_',stimtype,'_i05_hold_prep(sbj_r)=imagescDat_ind_diff_c3_c4{sbj_r,2}(2,1);']);
                eval(['all_imagescDat_ind_diff_c3_c4_beta_',distype,'_',stimtype,'_i15_hold_prep(sbj_r)=imagescDat_ind_diff_c3_c4{sbj_r,2}(3,1);']);
                eval(['all_imagescDat_ind_diff_c3_c4_beta_',distype,'_',stimtype,'_pos_hold_prep(sbj_r)=imagescDat_ind_diff_c3_c4{sbj_r,2}(4,1);']);
                
                eval(['all_imagescDat_ind_diff_c3_c4_beta_',distype,'_',stimtype,'_pre_prep_reac(sbj_r)=imagescDat_ind_diff_c3_c4{sbj_r,2}(1,2);']);
                eval(['all_imagescDat_ind_diff_c3_c4_beta_',distype,'_',stimtype,'_i05_prep_reac(sbj_r)=imagescDat_ind_diff_c3_c4{sbj_r,2}(2,2);']);
                eval(['all_imagescDat_ind_diff_c3_c4_beta_',distype,'_',stimtype,'_i15_prep_reac(sbj_r)=imagescDat_ind_diff_c3_c4{sbj_r,2}(3,2);']);
                eval(['all_imagescDat_ind_diff_c3_c4_beta_',distype,'_',stimtype,'_pos_prep_reac(sbj_r)=imagescDat_ind_diff_c3_c4{sbj_r,2}(4,2);']);
                
          elseif sbj>=13 & sbj<=18
                distype='healthy';
                stimtype='sham';
                [sbj_r,sbj_c]=ind2sub(size(sbj_name),sbj);
                eval(['all_imagescDat_ind_diff_c3_c4_beta_',distype,'_',stimtype,'_pre_hold_prep(sbj_r)=imagescDat_ind_diff_c3_c4{sbj_r,3}(1,1);']);
                eval(['all_imagescDat_ind_diff_c3_c4_beta_',distype,'_',stimtype,'_i05_hold_prep(sbj_r)=imagescDat_ind_diff_c3_c4{sbj_r,3}(2,1);']);
                eval(['all_imagescDat_ind_diff_c3_c4_beta_',distype,'_',stimtype,'_i15_hold_prep(sbj_r)=imagescDat_ind_diff_c3_c4{sbj_r,3}(3,1);']);
                eval(['all_imagescDat_ind_diff_c3_c4_beta_',distype,'_',stimtype,'_pos_hold_prep(sbj_r)=imagescDat_ind_diff_c3_c4{sbj_r,3}(4,1);']);
                
                eval(['all_imagescDat_ind_diff_c3_c4_beta_',distype,'_',stimtype,'_pre_prep_reac(sbj_r)=imagescDat_ind_diff_c3_c4{sbj_r,3}(1,2);']);
                eval(['all_imagescDat_ind_diff_c3_c4_beta_',distype,'_',stimtype,'_i05_prep_reac(sbj_r)=imagescDat_ind_diff_c3_c4{sbj_r,3}(2,2);']);
                eval(['all_imagescDat_ind_diff_c3_c4_beta_',distype,'_',stimtype,'_i15_prep_reac(sbj_r)=imagescDat_ind_diff_c3_c4{sbj_r,3}(3,2);']);
                eval(['all_imagescDat_ind_diff_c3_c4_beta_',distype,'_',stimtype,'_pos_prep_reac(sbj_r)=imagescDat_ind_diff_c3_c4{sbj_r,3}(4,2);']);
                
        elseif sbj>=19 & sbj<=24
                distype='healthy';
                stimtype='stim';
                [sbj_r,sbj_c]=ind2sub(size(sbj_name),sbj);
                eval(['all_imagescDat_ind_diff_c3_c4_beta_',distype,'_',stimtype,'_pre_hold_prep(sbj_r)=imagescDat_ind_diff_c3_c4{sbj_r,4}(1,1);']);
                eval(['all_imagescDat_ind_diff_c3_c4_beta_',distype,'_',stimtype,'_i05_hold_prep(sbj_r)=imagescDat_ind_diff_c3_c4{sbj_r,4}(2,1);']);
                eval(['all_imagescDat_ind_diff_c3_c4_beta_',distype,'_',stimtype,'_i15_hold_prep(sbj_r)=imagescDat_ind_diff_c3_c4{sbj_r,4}(3,1);']);
                eval(['all_imagescDat_ind_diff_c3_c4_beta_',distype,'_',stimtype,'_pos_hold_prep(sbj_r)=imagescDat_ind_diff_c3_c4{sbj_r,4}(4,1);']);
                
                eval(['all_imagescDat_ind_diff_c3_c4_beta_',distype,'_',stimtype,'_pre_prep_reac(sbj_r)=imagescDat_ind_diff_c3_c4{sbj_r,4}(1,2);']);
                eval(['all_imagescDat_ind_diff_c3_c4_beta_',distype,'_',stimtype,'_i05_prep_reac(sbj_r)=imagescDat_ind_diff_c3_c4{sbj_r,4}(2,2);']);
                eval(['all_imagescDat_ind_diff_c3_c4_beta_',distype,'_',stimtype,'_i15_prep_reac(sbj_r)=imagescDat_ind_diff_c3_c4{sbj_r,4}(3,2);']);
                eval(['all_imagescDat_ind_diff_c3_c4_beta_',distype,'_',stimtype,'_pos_prep_reac(sbj_r)=imagescDat_ind_diff_c3_c4{sbj_r,4}(4,2);']);
                
         end
    end
end

distype={'stroke';'healthy'};
stimtype={'sham';'stim'};
timetype={'pre';'i05';'i15';'pos'};
phasetype={'hold_prep';'prep_reac'};

for i=1:size(distype,1)
    for j=1:size(stimtype,1)
        for k=1:size(timetype,1)
            for l=1:size(phasetype,1)
                eval(['mean_all_imagescDat_ind_diff_c3_c4_beta_',distype{i},'_',stimtype{j},'_',timetype{k},'_',phasetype{l},...
                    '=mean(all_imagescDat_ind_diff_c3_c4_beta_',distype{i},'_',stimtype{j},'_',timetype{k},'_',phasetype{l},');'])
                eval(['se_all_imagescDat_ind_diff_c3_c4_beta_',distype{i},'_',stimtype{j},'_',timetype{k},'_',phasetype{l},...
                    '=std(all_imagescDat_ind_diff_c3_c4_beta_',distype{i},'_',stimtype{j},'_',timetype{k},'_',phasetype{l},')',...
                    '/sqrt(size(all_imagescDat_ind_diff_c3_c4_beta_',distype{i},'_',stimtype{j},'_',timetype{k},'_',phasetype{l},',2));'])
            end
        end
    end
end



%stats - friedman
%across timetype
for i=1:size(distype,1)
    for j=1:size(stimtype,1)
        %for k=1:size(timetype,1)
            for l=1:size(phasetype,1)
                eval(['[p_friedman_all_imagescDat_ind_diff_c3_c4_beta_',distype{i},'_',stimtype{j},'_',phasetype{l},',',...
                    'tab_friedman_all_imagescDat_ind_diff_c3_c4_beta_',distype{i},'_',stimtype{j},'_',phasetype{l},',',...
                    'stats_friedman_all_imagescDat_ind_diff_c3_c4_beta_',distype{i},'_',stimtype{j},'_',phasetype{l},']',...
                    '=friedman([all_imagescDat_ind_diff_c3_c4_beta_',distype{i},'_',stimtype{j},'_pre_',phasetype{l},';',...
                              'all_imagescDat_ind_diff_c3_c4_beta_',distype{i},'_',stimtype{j},'_i05_',phasetype{l},';',...
                              'all_imagescDat_ind_diff_c3_c4_beta_',distype{i},'_',stimtype{j},'_i15_',phasetype{l},';',...
                              'all_imagescDat_ind_diff_c3_c4_beta_',distype{i},'_',stimtype{j},'_pos_',phasetype{l},']'')'])
                eval(['mc_friedman_all_imagescDat_ind_diff_c3_c4_beta_',distype{i},'_',stimtype{j},'_',phasetype{l},...
                      '=multcompare(stats_friedman_all_imagescDat_ind_diff_c3_c4_beta_',distype{i},'_',stimtype{j},'_',phasetype{l},');'])
                          
%                 eval(['se_all_imagescDat_ind_diff_c3_c4_beta_',distype{i},'_',stimtype{j},'_',timetype{k},'_',phasetype{l},...
%                     '=std(all_imagescDat_ind_diff_c3_c4_beta_',distype{i},'_',stimtype{j},'_',timetype{k},'_',phasetype{l},')',...
%                     '/sqrt(size(all_imagescDat_ind_diff_c3_c4_beta_',distype{i},'_',stimtype{j},'_',timetype{k},'_',phasetype{l},',2))'])
            end
        %end
    end
end


%stats - ranksum
%across stimtype
for i=1:size(distype,1)
    for j=1:size(stimtype,1)
        for k=1:size(timetype,1)
            %for l=1:size(phasetype,1)
                eval(['[p_rank_all_imagescDat_ind_diff_c3_c4_beta_',distype{i},'_',stimtype{j},'_',timetype{k},',',...
                    'tab_rank_all_imagescDat_ind_diff_c3_c4_beta_',distype{i},'_',stimtype{j},'_',timetype{k},',',...
                    'stats_rank_all_imagescDat_ind_diff_c3_c4_beta_',distype{i},'_',stimtype{j},'_',timetype{k},']',...
                    '=ranksum(all_imagescDat_ind_diff_c3_c4_beta_',distype{i},'_',stimtype{j},'_',timetype{k},'_hold_prep,',...
                              'all_imagescDat_ind_diff_c3_c4_beta_',distype{i},'_',stimtype{j},'_',timetype{k},'_prep_reac);'])
%                 eval(['mc_rank_all_imagescDat_ind_diff_c3_c4_beta_',distype{i},'_',timetype{k},'_',phasetype{l},...
%                       '=multcompare(stats_rank_all_imagescDat_ind_diff_c3_c4_beta_',distype{i},'_',timetype{k},'_',phasetype{l},')'])
%                           
%                 eval(['se_all_imagescDat_ind_diff_c3_c4_beta_',distype{i},'_',stimtype{j},'_',timetype{k},'_',phasetype{l},...
%                     '=std(all_imagescDat_ind_diff_c3_c4_beta_',distype{i},'_',stimtype{j},'_',timetype{k},'_',phasetype{l},')',...
%                     '/sqrt(size(all_imagescDat_ind_diff_c3_c4_beta_',distype{i},'_',stimtype{j},'_',timetype{k},'_',phasetype{l},',2))'])
            %end
        end
    end
end

for i=1:size(distype,1)
    %for j=1:size(stimtype,1)
        for k=1:size(timetype,1)
            for l=1:size(phasetype,1)
                eval(['[p_rank_all_imagescDat_ind_diff_c3_c4_beta_',distype{i},'_',timetype{k},'_',phasetype{l},...
                    ',tab_rank_all_imagescDat_ind_diff_c3_c4_beta_',distype{i},'_',timetype{k},'_',phasetype{l},...
                    ',stats_rank_all_imagescDat_ind_diff_c3_c4_beta_',distype{i},'_',timetype{k},'_',phasetype{l},']',...
                    '=ranksum(all_imagescDat_ind_diff_c3_c4_beta_',distype{i},'_sham_',timetype{k},'_',phasetype{l},...
                              ',all_imagescDat_ind_diff_c3_c4_beta_',distype{i},'_stim_',timetype{k},'_',phasetype{l},');'])
%                 eval(['mc_rank_all_imagescDat_ind_diff_c3_c4_beta_',distype{i},'_',timetype{k},'_',phasetype{l},...
%                       '=multcompare(stats_rank_all_imagescDat_ind_diff_c3_c4_beta_',distype{i},'_',timetype{k},'_',phasetype{l},')'])
%                           
%                 eval(['se_all_imagescDat_ind_diff_c3_c4_beta_',distype{i},'_',stimtype{j},'_',timetype{k},'_',phasetype{l},...
%                     '=std(all_imagescDat_ind_diff_c3_c4_beta_',distype{i},'_',stimtype{j},'_',timetype{k},'_',phasetype{l},')',...
%                     '/sqrt(size(all_imagescDat_ind_diff_c3_c4_beta_',distype{i},'_',stimtype{j},'_',timetype{k},'_',phasetype{l},',2))'])
            end
        end
    %end
end

%for i=1:size(distype,1)
    for j=1:size(stimtype,1)
        for k=1:size(timetype,1)
            for l=1:size(phasetype,1)
                eval(['[p_rank_all_imagescDat_ind_diff_c3_c4_beta_',stimtype{j},'_',timetype{k},'_',phasetype{l},...
                    ',tab_rank_all_imagescDat_ind_diff_c3_c4_beta_',stimtype{j},'_',timetype{k},'_',phasetype{l},...
                    ',stats_rank_all_imagescDat_ind_diff_c3_c4_beta_',stimtype{j},'_',timetype{k},'_',phasetype{l},']',...
                    '=ranksum(all_imagescDat_ind_diff_c3_c4_beta_stroke_',stimtype{j},'_',timetype{k},'_',phasetype{l},...
                              ',all_imagescDat_ind_diff_c3_c4_beta_healthy_',stimtype{j},'_',timetype{k},'_',phasetype{l},');'])
%                 eval(['mc_rank_all_imagescDat_ind_diff_c3_c4_beta_',distype{i},'_',timetype{k},'_',phasetype{l},...
%                       '=multcompare(stats_rank_all_imagescDat_ind_diff_c3_c4_beta_',distype{i},'_',timetype{k},'_',phasetype{l},')'])
%                           
%                 eval(['se_all_imagescDat_ind_diff_c3_c4_beta_',distype{i},'_',stimtype{j},'_',timetype{k},'_',phasetype{l},...
%                     '=std(all_imagescDat_ind_diff_c3_c4_beta_',distype{i},'_',stimtype{j},'_',timetype{k},'_',phasetype{l},')',...
%                     '/sqrt(size(all_imagescDat_ind_diff_c3_c4_beta_',distype{i},'_',stimtype{j},'_',timetype{k},'_',phasetype{l},',2))'])
            end
        end
    end
%end




% %
% for i=1:size(distype,1)
%     for j=1:size(stimtype,1)
%         for k=1:size(timetype,1)
%             %for l=1:size(phasetype,1)
%                 eval(['[p_friedman_all_imagescDat_ind_diff_c3_c4_beta_',distype{i},'_',stimtype{j},'_',timetype{k},',',...
%                     'tab_friedman_all_imagescDat_ind_diff_c3_c4_beta_',distype{i},'_',stimtype{j},'_',timetype{k},',',...
%                     'stats_friedman_all_imagescDat_ind_diff_c3_c4_beta_',distype{i},'_',stimtype{j},'_',timetype{k},']',...
%                     '=friedman([all_imagescDat_ind_diff_c3_c4_beta_',distype{i},'_',stimtype{j},'_',timetype{k},'_hold;',...
%                               'all_imagescDat_ind_diff_c3_c4_beta_',distype{i},'_',stimtype{j},'_',timetype{k},'_prep;',...
%                               'all_imagescDat_ind_diff_c3_c4_beta_',distype{i},'_',stimtype{j},'_',timetype{k},'_reac]'')'])
%                 eval(['mc_friedman_all_imagescDat_ind_diff_c3_c4_beta_',distype{i},'_',stimtype{j},'_',timetype{k},...
%                       '=multcompare(stats_friedman_all_imagescDat_ind_diff_c3_c4_beta_',distype{i},'_',stimtype{j},'_',timetype{k},',''display'',''off'')'])
%                           
% %                 eval(['se_all_imagescDat_ind_diff_c3_c4_beta_',distype{i},'_',stimtype{j},'_',timetype{k},'_',phasetype{l},...
% %                     '=std(all_imagescDat_ind_diff_c3_c4_beta_',distype{i},'_',stimtype{j},'_',timetype{k},'_',phasetype{l},')',...
% %                     '/sqrt(size(all_imagescDat_ind_diff_c3_c4_beta_',distype{i},'_',stimtype{j},'_',timetype{k},'_',phasetype{l},',2))'])
%             %end
%         end
%     end
% end


% %trying out a few things
% [fanova2p,fanova2table,fanova2stats]=friedman([all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_pre_prep_reac;all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_i05_prep_reac;
%     all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_i15_prep_reac;all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_pos_prep_reac]')
% fanova2amc=multcompare(fanova2stats)
% 
% [fanova2ap,fanova2atable,fanova2astats]=anova2([all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_pre_prep_reac,all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_pre_prep_reac;all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_i05_prep_reac,all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_i05_prep_reac;
%     all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_i15_prep_reac,all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_i15_prep_reac;all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_pos_prep_reac,all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_pos_prep_reac]',5)
% 
% 
% [all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_pre_prep_reac;all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_i05_prep_reac;
%     all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_i15_prep_reac;all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_pos_prep_reac]'
% 





figure; set(gcf,'Position',[2133 109 1214 834])
%Stroke sham
subplot(6,4,1); hold on
bar([mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_pre_hold_prep mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_i05_hold_prep ,...
    mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_i15_hold_prep mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_pos_hold_prep])
errorbar([mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_pre_hold_prep mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_i05_hold_prep ,...
    mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_i15_hold_prep mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_pos_hold_prep],...
    [se_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_pre_hold_prep se_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_i05_hold_prep ,...
    se_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_i15_hold_prep se_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_pos_hold_prep],'.k')
set(gca,'XTick',[1:4],'XTickLabel',{'pre';'i05';'i15';'pos'},'YLim',[-20 20])
ylabel('beta c3-c4 icoh')
title('Stroke Sham Hold Prep')
if p_friedman_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_hold_prep < 0.05
    text(5,10,num2str(p_friedman_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_hold_prep),'Color','r','Rotation',270)
else
    text(5,10,num2str(p_friedman_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_hold_prep),'Rotation',270)
end

subplot(6,4,5); hold on
bar([mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_pre_prep_reac mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_i05_prep_reac ,...
    mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_i15_prep_reac mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_pos_prep_reac])
errorbar([mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_pre_prep_reac mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_i05_prep_reac ,...
    mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_i15_prep_reac mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_pos_prep_reac],...
    [se_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_pre_prep_reac se_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_i05_prep_reac ,...
    se_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_i15_prep_reac se_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_pos_prep_reac],'.k')
set(gca,'XTick',[1:4],'XTickLabel',{'pre';'i05';'i15';'pos'},'YLim',[-20 20])
ylabel('beta c3-c4 icoh')
title('Stroke Sham Prep Reach')
if p_friedman_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_prep_reac < 0.05
    text(5,10,num2str(p_friedman_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_prep_reac),'Color','r','Rotation',270)
else
    text(5,10,num2str(p_friedman_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_prep_reac),'Rotation',270)
end

% subplot(6,4,9); hold on
% bar([mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_pre_reac mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_i05_reac ,...
%     mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_i15_reac mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_pos_reac])
% errorbar([mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_pre_reac mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_i05_reac ,...
%     mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_i15_reac mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_pos_reac],...
%     [se_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_pre_reac se_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_i05_reac ,...
%     se_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_i15_reac se_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_pos_reac],'.k')
% set(gca,'XTick',[1:4],'XTickLabel',{'pre';'i05';'i15';'pos'},'YLim',[0.5 0.7])
% ylabel('beta c3-c4 icoh')
% title('Stroke Sham Reach')

subplot(6,4,9); hold on
bar([mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_pre_hold_prep mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_pre_prep_reac]) 
errorbar([mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_pre_hold_prep mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_pre_prep_reac],...
    [se_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_pre_hold_prep se_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_pre_prep_reac],'.k')
set(gca,'XTick',[1:2],'XTickLabel',{'hp';'pr'},'YLim',[-20 20]) 
ylabel('beta c3-c4 icoh')
title('Stroke Sham Pre')
if p_rank_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_pre < 0.05
    text(3,10,num2str(p_rank_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_pre),'Color','r','Rotation',270)
else
    text(3,10,num2str(p_rank_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_pre),'Rotation',270)
end

subplot(6,4,13); hold on
bar([mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_i05_hold_prep mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_i05_prep_reac]) 
errorbar([mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_i05_hold_prep mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_i05_prep_reac],...
    [se_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_i05_hold_prep se_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_i05_prep_reac],'.k')
set(gca,'XTick',[1:2],'XTickLabel',{'hp';'pr'},'YLim',[-20 20]) 
ylabel('beta c3-c4 icoh')
title('Stroke Sham i05')
if p_rank_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_i05 < 0.05
    text(3,10,num2str(p_rank_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_i05),'Color','r','Rotation',270)
else
    text(3,10,num2str(p_rank_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_i05),'Rotation',270)
end

subplot(6,4,17); hold on
bar([mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_i15_hold_prep mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_i15_prep_reac])
errorbar([mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_i15_hold_prep mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_i15_prep_reac],...
   [se_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_i15_hold_prep se_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_i15_prep_reac],'.k')
set(gca,'XTick',[1:2],'XTickLabel',{'hp';'pr'},'YLim',[-20 20]) 
ylabel('beta c3-c4 icoh')
title('Stroke Sham i15')
if p_rank_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_i15 < 0.05
    text(3,10,num2str(p_rank_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_i15),'Color','r','Rotation',270)
else
    text(3,10,num2str(p_rank_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_i15),'Rotation',270)
end

subplot(6,4,21); hold on
bar([mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_pos_hold_prep mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_pos_prep_reac])
errorbar([mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_pos_hold_prep mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_pos_prep_reac],...
   [se_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_pos_hold_prep se_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_pos_prep_reac],'.k')
set(gca,'XTick',[1:2],'XTickLabel',{'hp';'pr'},'YLim',[-20 20]) 
ylabel('beta c3-c4 icoh')
title('Stroke Sham pos')
if p_rank_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_pos < 0.05
    text(3,10,num2str(p_rank_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_pos),'Color','r','Rotation',270)
else
    text(3,10,num2str(p_rank_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_pos),'Rotation',270)
end

%stroke stim
subplot(6,4,2); hold on
bar([mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_pre_hold_prep mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_i05_hold_prep,...
    mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_i15_hold_prep mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_pos_hold_prep])
errorbar([mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_pre_hold_prep mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_i05_hold_prep,...
    mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_i15_hold_prep mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_pos_hold_prep],...
    [se_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_pre_hold_prep se_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_i05_hold_prep,...
    se_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_i15_hold_prep se_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_pos_hold_prep],'.k')
set(gca,'XTick',[1:4],'XTickLabel',{'pre';'i05';'i15';'pos'},'YLim',[-20 20])
ylabel('beta c3-c4 icoh')
title('Stroke Stim Hold Prep')
if p_friedman_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_hold_prep < 0.05
    text(5,10,num2str(p_friedman_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_hold_prep),'Color','r','Rotation',270)
else
    text(5,10,num2str(p_friedman_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_hold_prep),'Rotation',270)
end

subplot(6,4,6); hold on
bar([mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_pre_prep_reac mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_i05_prep_reac,...
    mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_i15_prep_reac mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_pos_prep_reac])
errorbar([mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_pre_prep_reac mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_i05_prep_reac,...
    mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_i15_prep_reac mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_pos_prep_reac],...
    [se_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_pre_prep_reac se_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_i05_prep_reac,...
    se_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_i15_prep_reac se_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_pos_prep_reac],'.k')
set(gca,'XTick',[1:4],'XTickLabel',{'pre';'i05';'i15';'pos'},'YLim',[-20 20])
ylabel('beta c3-c4 icoh')
title('Stroke Stim Prep Reach')
if p_friedman_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_prep_reac < 0.05
    text(5,10,num2str(p_friedman_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_prep_reac),'Color','r','Rotation',270)
else
    text(5,10,num2str(p_friedman_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_prep_reac),'Rotation',270)
end

% subplot(6,4,10); hold on
% bar([mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_pre_reac mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_i05_reac ,...
%     mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_i15_reac mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_pos_reac])
% errorbar([mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_pre_reac mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_i05_reac ,...
%     mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_i15_reac mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_pos_reac],...
%     [se_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_pre_reac se_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_i05_reac ,...
%     se_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_i15_reac se_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_pos_reac],'.k')
% set(gca,'XTick',[1:4],'XTickLabel',{'pre';'i05';'i15';'pos'},'YLim',[0.5 0.7])
% ylabel('beta c3-c4 icoh')
% title('Stroke Stim Reach')

subplot(6,4,10); hold on
bar([mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_pre_hold_prep mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_pre_prep_reac])
errorbar([mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_pre_hold_prep mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_pre_prep_reac],...
    [se_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_pre_hold_prep se_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_pre_prep_reac],'.k')
set(gca,'XTick',[1:2],'XTickLabel',{'hp';'pr'},'YLim',[-20 20]) 
ylabel('beta c3-c4 icoh')
title('Stroke Stim Pre')
if p_rank_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_pre < 0.05
    text(3,10,num2str(p_rank_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_pre),'Color','r','Rotation',270)
else
    text(3,10,num2str(p_rank_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_pre),'Rotation',270)
end

subplot(6,4,14); hold on
bar([mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_i05_hold_prep mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_i05_prep_reac])
errorbar([mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_i05_hold_prep mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_i05_prep_reac],...
    [se_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_i05_hold_prep se_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_i05_prep_reac],'.k')
set(gca,'XTick',[1:2],'XTickLabel',{'hp';'pr'},'YLim',[-20 20]) 
ylabel('beta c3-c4 icoh')
title('Stroke Stim i05')
if p_rank_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_i05 < 0.05
    text(3,10,num2str(p_rank_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_i05),'Color','r','Rotation',270)
else
    text(3,10,num2str(p_rank_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_i05),'Rotation',270)
end

subplot(6,4,18); hold on
bar([mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_i15_hold_prep mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_i15_prep_reac])
errorbar([mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_i15_hold_prep mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_i15_prep_reac],...
    [se_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_i15_hold_prep se_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_i15_prep_reac],'.k')
set(gca,'XTick',[1:2],'XTickLabel',{'hp';'pr'},'YLim',[-20 20]) 
ylabel('beta c3-c4 icoh')
title('Stroke Stim i15')
if p_rank_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_i15 < 0.05
    text(3,10,num2str(p_rank_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_i15),'Color','r','Rotation',270)
else
    text(3,10,num2str(p_rank_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_i15),'Rotation',270)
end

subplot(6,4,22); hold on
bar([mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_pos_hold_prep mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_pos_prep_reac])
errorbar([mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_pos_hold_prep mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_pos_prep_reac],...
    [se_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_pos_hold_prep se_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_pos_prep_reac],'.k')
set(gca,'XTick',[1:2],'XTickLabel',{'hp';'pr'},'YLim',[-20 20]) 
ylabel('beta c3-c4 icoh')
title('Stroke Stim pos')
if p_rank_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_pos < 0.05
    text(3,10,num2str(p_rank_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_pos),'Color','r','Rotation',270)
else
    text(3,10,num2str(p_rank_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_pos),'Rotation',270)
end


%healthy sham
subplot(6,4,3); hold on
bar([mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_pre_hold_prep mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_i05_hold_prep ,...
    mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_i15_hold_prep mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_pos_hold_prep])
errorbar([mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_pre_hold_prep mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_i05_hold_prep ,...
    mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_i15_hold_prep mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_pos_hold_prep],...
    [se_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_pre_hold_prep se_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_i05_hold_prep ,...
    se_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_i15_hold_prep se_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_pos_hold_prep],'.k')
set(gca,'XTick',[1:4],'XTickLabel',{'pre';'i05';'i15';'pos'},'YLim',[-20 20])
ylabel('beta c3-c4 icoh')
title('Healthy Sham Hold Prep')
if p_friedman_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_hold_prep < 0.05
    text(5,10,num2str(p_friedman_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_hold_prep),'Color','r','Rotation',270)
else
    text(5,10,num2str(p_friedman_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_hold_prep),'Rotation',270)
end

subplot(6,4,7); hold on
bar([mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_pre_prep_reac mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_i05_prep_reac ,...
    mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_i15_prep_reac mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_pos_prep_reac])
errorbar([mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_pre_prep_reac mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_i05_prep_reac ,...
    mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_i15_prep_reac mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_pos_prep_reac],...
    [se_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_pre_prep_reac se_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_i05_prep_reac ,...
    se_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_i15_prep_reac se_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_pos_prep_reac],'.k')
set(gca,'XTick',[1:4],'XTickLabel',{'pre';'i05';'i15';'pos'},'YLim',[-20 20])
ylabel('beta c3-c4 icoh')
title('Healthy Sham Prep Reach')
if p_friedman_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_prep_reac < 0.05
    text(5,10,num2str(p_friedman_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_prep_reac),'Color','r','Rotation',270)
else
    text(5,10,num2str(p_friedman_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_prep_reac),'Rotation',270)
end


% subplot(6,4,11); hold on
% bar([mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_pre_reac mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_i05_reac ,...
%     mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_i15_reac mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_pos_reac])
% errorbar([mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_pre_reac mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_i05_reac ,...
%     mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_i15_reac mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_pos_reac],...
%     [se_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_pre_reac se_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_i05_reac ,...
%     se_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_i15_reac se_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_pos_reac],'.k')
% set(gca,'XTick',[1:4],'XTickLabel',{'pre';'i05';'i15';'pos'},'YLim',[-20 20])
% ylabel('beta c3-c4 icoh')
% title('Healthy Sham Reach')

subplot(6,4,11); hold on
bar([mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_pre_hold_prep mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_pre_prep_reac])
errorbar([mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_pre_hold_prep mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_pre_prep_reac],...
    [se_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_pre_hold_prep se_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_pre_prep_reac],'.k')
set(gca,'XTick',[1:2],'XTickLabel',{'hp';'pr'},'YLim',[-20 20]) 
ylabel('beta c3-c4 icoh')
title('Healthy Sham Pre')
if p_rank_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_pre < 0.05
    text(3,10,num2str(p_rank_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_pre),'Color','r','Rotation',270)
else
    text(3,10,num2str(p_rank_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_pre),'Rotation',270)
end

subplot(6,4,15); hold on
bar([mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_i05_hold_prep mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_i05_prep_reac])
errorbar([mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_i05_hold_prep mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_i05_prep_reac],...
    [se_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_i05_hold_prep se_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_i05_prep_reac],'.k')
set(gca,'XTick',[1:2],'XTickLabel',{'hp';'pr'},'YLim',[-20 20]) 
ylabel('beta c3-c4 icoh')
title('Healthy Sham i05')
if p_rank_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_i05 < 0.05
    text(3,10,num2str(p_rank_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_i05),'Color','r','Rotation',270)
else
    text(3,10,num2str(p_rank_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_i05),'Rotation',270)
end

subplot(6,4,19); hold on
bar([mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_i15_hold_prep mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_i15_prep_reac])
errorbar([mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_i15_hold_prep mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_i15_prep_reac],...
    [se_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_i15_hold_prep se_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_i15_prep_reac],'.k')
set(gca,'XTick',[1:2],'XTickLabel',{'hp';'pr'},'YLim',[-20 20]) 
ylabel('beta c3-c4 icoh')
title('Healthy Sham i15')
if p_rank_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_i15 < 0.05
    text(3,10,num2str(p_rank_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_i15),'Color','r','Rotation',270)
else
    text(3,10,num2str(p_rank_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_i15),'Rotation',270)
end

subplot(6,4,23); hold on
bar([mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_pos_hold_prep mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_pos_prep_reac])
errorbar([mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_pos_hold_prep mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_pos_prep_reac],...
    [se_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_pos_hold_prep se_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_pos_prep_reac],'.k')
set(gca,'XTick',[1:2],'XTickLabel',{'hp';'pr'},'YLim',[-20 20]) 
ylabel('beta c3-c4 icoh')
title('Healthy Sham pos')
if p_rank_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_pos < 0.05
    text(3,10,num2str(p_rank_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_pos),'Color','r','Rotation',270)
else
    text(3,10,num2str(p_rank_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_pos),'Rotation',270)
end

%healthy stim
subplot(6,4,4); hold on
bar([mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_pre_hold_prep mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_i05_hold_prep ,...
    mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_i15_hold_prep mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_pos_hold_prep])
errorbar([mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_pre_hold_prep mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_i05_hold_prep ,...
    mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_i15_hold_prep mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_pos_hold_prep],...
    [se_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_pre_hold_prep se_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_i05_hold_prep ,...
    se_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_i15_hold_prep se_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_pos_hold_prep],'.k')
set(gca,'XTick',[1:4],'XTickLabel',{'pre';'i05';'i15';'pos'},'YLim',[-20 20])
ylabel('beta c3-c4 icoh')
title('Healthy Stim Hold Prep')
if p_friedman_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_hold_prep < 0.05
    text(5,10,num2str(p_friedman_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_hold_prep),'Color','r','Rotation',270)
else
    text(5,10,num2str(p_friedman_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_hold_prep),'Rotation',270)
end

subplot(6,4,8); hold on
bar([mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_pre_prep_reac mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_i05_prep_reac ,...
    mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_i15_prep_reac mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_pos_prep_reac])
errorbar([mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_pre_prep_reac mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_i05_prep_reac ,...
    mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_i15_prep_reac mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_pos_prep_reac],...
    [se_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_pre_prep_reac se_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_i05_prep_reac ,...
    se_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_i15_prep_reac se_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_pos_prep_reac],'.k')
set(gca,'XTick',[1:4],'XTickLabel',{'pre';'i05';'i15';'pos'},'YLim',[-20 20])
ylabel('beta c3-c4 icoh')
title('Healthy Stim Prep Reach')
if p_friedman_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_prep_reac < 0.05
    text(5,10,num2str(p_friedman_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_prep_reac),'Color','r','Rotation',270)
else
    text(5,10,num2str(p_friedman_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_prep_reac),'Rotation',270)
end

% subplot(6,4,12); hold on
% bar([mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_pre_reac mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_i05_reac ,...
%     mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_i15_reac mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_pos_reac])
% errorbar([mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_pre_reac mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_i05_reac ,...
%     mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_i15_reac mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_pos_reac],...
%     [se_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_pre_reac se_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_i05_reac ,...
%     se_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_i15_reac se_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_pos_reac],'.k')
% set(gca,'XTick',[1:4],'XTickLabel',{'pre';'i05';'i15';'pos'},'YLim',[-20 20])
% ylabel('beta c3-c4 icoh')
% title('Healthy Stim Reach')

subplot(6,4,12); hold on
bar([mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_pre_hold_prep mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_pre_prep_reac])
errorbar([mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_pre_hold_prep mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_pre_prep_reac],...
    [se_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_pre_hold_prep se_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_pre_prep_reac],'.k')
set(gca,'XTick',[1:2],'XTickLabel',{'hp';'pr'},'YLim',[-20 20]) 
ylabel('beta c3-c4 icoh')
title('Healthy Stim Pre')
if p_rank_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_pre < 0.05
    text(3,10,num2str(p_rank_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_pre),'Color','r','Rotation',270)
else
    text(3,10,num2str(p_rank_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_pre),'Rotation',270)
end

subplot(6,4,16); hold on
bar([mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_i05_hold_prep mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_i05_prep_reac])
errorbar([mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_i05_hold_prep mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_i05_prep_reac],...
    [se_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_i05_hold_prep se_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_i05_prep_reac],'.k')
set(gca,'XTick',[1:2],'XTickLabel',{'hp';'pr'},'YLim',[-20 20]) 
ylabel('beta c3-c4 icoh')
title('Healthy Stim i05')
if p_rank_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_i05 < 0.05
    text(3,10,num2str(p_rank_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_i05),'Color','r','Rotation',270)
else
    text(3,10,num2str(p_rank_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_i05),'Rotation',270)
end

subplot(6,4,20); hold on
bar([mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_i15_hold_prep mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_i15_prep_reac])
errorbar([mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_i15_hold_prep mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_i15_prep_reac],...
    [se_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_i15_hold_prep se_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_i15_prep_reac],'.k')
set(gca,'XTick',[1:2],'XTickLabel',{'hp';'pr'},'YLim',[-20 20]) 
ylabel('beta c3-c4 icoh')
title('Healthy Stim i15')
if p_rank_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_i15 < 0.05
    text(3,10,num2str(p_rank_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_i15),'Color','r','Rotation',270)
else
    text(3,10,num2str(p_rank_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_i15),'Rotation',270)
end

subplot(6,4,24); hold on
bar([mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_pos_hold_prep mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_pos_prep_reac])
errorbar([mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_pos_hold_prep mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_pos_prep_reac],...
    [se_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_pos_hold_prep se_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_pos_prep_reac],'.k')
set(gca,'XTick',[1:2],'XTickLabel',{'hp';'pr'},'YLim',[-20 20]) 
ylabel('beta c3-c4 icoh')
title('Healthy Stim pos')
if p_rank_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_pos < 0.05
    text(3,10,num2str(p_rank_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_pos),'Color','r','Rotation',270)
else
    text(3,10,num2str(p_rank_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_pos),'Rotation',270)
end

 
figure; set(gcf,'Position',[2133 109 1214 834])
%stroke
subplot(6,4,1); hold on
     bar([1,4,7,10],[mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_pre_hold_prep,...  
                     mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_i05_hold_prep,... 
                     mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_i15_hold_prep,... 
                     mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_pos_hold_prep],0.2)
errorbar([1,4,7,10],[mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_pre_hold_prep,...  
                     mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_i05_hold_prep,... 
                     mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_i15_hold_prep,... 
                     mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_pos_hold_prep],...
                      [se_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_pre_hold_prep,...  
                       se_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_i05_hold_prep,... 
                       se_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_i15_hold_prep,... 
                       se_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_pos_hold_prep],'.k')
     bar([2,5,8,11],[mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_pre_hold_prep,...  
                     mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_i05_hold_prep,... 
                     mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_i15_hold_prep,... 
                     mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_pos_hold_prep],0.2)
errorbar([2,5,8,11],[mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_pre_hold_prep,...  
                     mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_i05_hold_prep,... 
                     mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_i15_hold_prep,... 
                     mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_pos_hold_prep],...
                      [se_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_pre_hold_prep,...  
                       se_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_i05_hold_prep,... 
                       se_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_i15_hold_prep,... 
                       se_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_pos_hold_prep],'.k')
legend('Sham','','Stim','','Location','SouthEast')
set(gca,'XTick',[1 4 7 10],'XTickLabel',{'pre';'i05';'i15';'pos'},'YLim',[-20 20])
ylabel('beta c3-c4 icoh')
title('Stroke - Hold Prep')
if p_rank_all_imagescDat_ind_diff_c3_c4_beta_stroke_pre_hold_prep<0.05
    text(1.5,10,'*','Color','r')
end
if p_rank_all_imagescDat_ind_diff_c3_c4_beta_stroke_i05_hold_prep<0.05
    text(4.5,10,'*','Color','r')
end
if p_rank_all_imagescDat_ind_diff_c3_c4_beta_stroke_i15_hold_prep<0.05
    text(7.5,10,'*','Color','r')
end
if p_rank_all_imagescDat_ind_diff_c3_c4_beta_stroke_pos_hold_prep<0.05
    text(10.5,10,'*','Color','r')
end

subplot(6,4,5); hold on
     bar([1,4,7,10],[mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_pre_prep_reac,...  
                     mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_i05_prep_reac,... 
                     mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_i15_prep_reac,... 
                     mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_pos_prep_reac],0.2)
errorbar([1,4,7,10],[mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_pre_prep_reac,...  
                     mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_i05_prep_reac,... 
                     mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_i15_prep_reac,... 
                     mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_pos_prep_reac],...
                      [se_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_pre_prep_reac,...  
                       se_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_i05_prep_reac,... 
                       se_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_i15_prep_reac,... 
                       se_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_pos_prep_reac],'.k')
     bar([2,5,8,11],[mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_pre_prep_reac,...  
                     mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_i05_prep_reac,... 
                     mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_i15_prep_reac,... 
                     mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_pos_prep_reac],0.2)
errorbar([2,5,8,11],[mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_pre_prep_reac,...  
                     mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_i05_prep_reac,... 
                     mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_i15_prep_reac,... 
                     mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_pos_prep_reac],...
                      [se_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_pre_prep_reac,...  
                       se_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_i05_prep_reac,... 
                       se_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_i15_prep_reac,... 
                       se_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_pos_prep_reac],'.k')
%legend('Sham','','Stim','','Location','SouthEast')
set(gca,'XTick',[1 4 7 10],'XTickLabel',{'pre';'i05';'i15';'pos'},'YLim',[-20 20])
ylabel('beta c3-c4 icoh')
title('Stroke - Prep Reach')
if p_rank_all_imagescDat_ind_diff_c3_c4_beta_stroke_pre_prep_reac<0.05
    text(1.5,10,'*','Color','r')
end
if p_rank_all_imagescDat_ind_diff_c3_c4_beta_stroke_i05_prep_reac<0.05
    text(4.5,10,'*','Color','r')
end
if p_rank_all_imagescDat_ind_diff_c3_c4_beta_stroke_i15_prep_reac<0.05
    text(7.5,10,'*','Color','r')
end
if p_rank_all_imagescDat_ind_diff_c3_c4_beta_stroke_pos_prep_reac<0.05
    text(10.5,10,'*','Color','r')
end

% subplot(6,4,9); hold on
%      bar([1,4,7,10],[mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_pre_reac,...  
%                      mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_i05_reac,... 
%                      mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_i15_reac,... 
%                      mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_pos_reac],0.2)
% errorbar([1,4,7,10],[mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_pre_reac,...  
%                      mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_i05_reac,... 
%                      mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_i15_reac,... 
%                      mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_pos_reac],...
%                       [se_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_pre_reac,...  
%                        se_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_i05_reac,... 
%                        se_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_i15_reac,... 
%                        se_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_pos_reac],'.k')
%      bar([2,5,8,11],[mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_pre_reac,...  
%                      mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_i05_reac,... 
%                      mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_i15_reac,... 
%                      mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_pos_reac],0.2)
% errorbar([2,5,8,11],[mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_pre_reac,...  
%                      mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_i05_reac,... 
%                      mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_i15_reac,... 
%                      mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_pos_reac],...
%                       [se_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_pre_reac,...  
%                        se_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_i05_reac,... 
%                        se_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_i15_reac,... 
%                        se_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_pos_reac],'.k')
% legend('Sham','','Stim','')
% set(gca,'XTick',[1 4 7 10],'XTickLabel',{'pre';'i05';'i15';'pos'},'YLim',[0.5 0.8])
% ylabel('beta c3-c4 icoh')
% title('Stroke - Reach')

subplot(6,4,9); hold on
     bar([1,4],[mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_pre_hold_prep,...  
                  mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_pre_prep_reac],0.2)
errorbar([1,4],[mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_pre_hold_prep,...  
                  mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_pre_prep_reac],...
                   [se_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_pre_hold_prep,...  
                    se_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_pre_prep_reac],'.k')
     bar([2,5],[mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_pre_hold_prep,...  
                  mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_pre_prep_reac],0.2)
errorbar([2,5],[mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_pre_hold_prep,...  
                  mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_pre_prep_reac],...
                   [se_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_pre_hold_prep,...  
                    se_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_pre_prep_reac],'.k')
%legend('Sham','','Stim','','Location','SouthEast')
set(gca,'XTick',[1 4],'XTickLabel',{'hp';'pr'},'YLim',[-20 20])
ylabel('beta c3-c4 icoh')
title('Stroke - Pre')
if p_rank_all_imagescDat_ind_diff_c3_c4_beta_stroke_pre_hold_prep<0.05
    text(1.5,10,'*','Color','r')
end
if p_rank_all_imagescDat_ind_diff_c3_c4_beta_stroke_pre_prep_reac<0.05
    text(4.5,10,'*','Color','r')
end

subplot(6,4,13); hold on
     bar([1,4],[mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_i05_hold_prep,...  
                  mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_i05_prep_reac],0.2)
errorbar([1,4],[mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_i05_hold_prep,...  
                  mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_i05_prep_reac],...
                   [se_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_i05_hold_prep,...  
                    se_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_i05_prep_reac],'.k')
     bar([2,5],[mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_i05_hold_prep,...  
                  mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_i05_prep_reac],0.2)
errorbar([2,5],[mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_i05_hold_prep,...  
                  mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_i05_prep_reac],...
                   [se_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_i05_hold_prep,...  
                    se_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_i05_prep_reac],'.k')
%legend('Sham','','Stim','','Location','SouthEast')
set(gca,'XTick',[1 4],'XTickLabel',{'hp';'pr'},'YLim',[-20 20])
ylabel('beta c3-c4 icoh')
title('Stroke - I05')
if p_rank_all_imagescDat_ind_diff_c3_c4_beta_stroke_i05_hold_prep<0.05
    text(1.5,10,'*','Color','r')
end
if p_rank_all_imagescDat_ind_diff_c3_c4_beta_stroke_i05_prep_reac<0.05
    text(4.5,10,'*','Color','r')
end

subplot(6,4,17); hold on
     bar([1,4],[mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_i15_hold_prep,...  
                  mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_i15_prep_reac],0.2)
errorbar([1,4],[mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_i15_hold_prep,...  
                  mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_i15_prep_reac],...
                   [se_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_i15_hold_prep,...  
                    se_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_i15_prep_reac],'.k')
     bar([2,5],[mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_i15_hold_prep,...  
                  mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_i15_prep_reac],0.2)
errorbar([2,5],[mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_i15_hold_prep,...  
                  mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_i15_prep_reac],...
                   [se_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_i15_hold_prep,...  
                    se_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_i15_prep_reac],'.k')
%legend('Sham','','Stim','','Location','SouthEast')
set(gca,'XTick',[1 4],'XTickLabel',{'hp';'pr'},'YLim',[-20 20])
ylabel('beta c3-c4 icoh')
title('Stroke - I15')
if p_rank_all_imagescDat_ind_diff_c3_c4_beta_stroke_i15_hold_prep<0.05
    text(1.5,10,'*','Color','r')
end
if p_rank_all_imagescDat_ind_diff_c3_c4_beta_stroke_i15_prep_reac<0.05
    text(4.5,10,'*','Color','r')
end

subplot(6,4,21); hold on
     bar([1,4],[mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_pos_hold_prep,...  
                  mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_pos_prep_reac],0.2)
errorbar([1,4],[mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_pos_hold_prep,...  
                  mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_pos_prep_reac],...
                   [se_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_pos_hold_prep,...  
                    se_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_pos_prep_reac],'.k')
     bar([2,5],[mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_pos_hold_prep,...  
                  mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_pos_prep_reac],0.2)
errorbar([2,5],[mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_pos_hold_prep,...  
                  mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_pos_prep_reac],...
                   [se_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_pos_hold_prep,...  
                    se_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_pos_prep_reac],'.k')
%legend('Sham','','Stim','','Location','SouthEast')
set(gca,'XTick',[1 4],'XTickLabel',{'hold';'prep';'reac'},'YLim',[-20 20])
ylabel('beta c3-c4 icoh')
title('Stroke - Pos')
if p_rank_all_imagescDat_ind_diff_c3_c4_beta_stroke_pos_hold_prep<0.05
    text(1.5,10,'*','Color','r')
end
if p_rank_all_imagescDat_ind_diff_c3_c4_beta_stroke_pos_prep_reac<0.05
    text(4.5,10,'*','Color','r')
end

%healthy
subplot(6,4,2); hold on
     bar([1,4,7,10],[mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_pre_hold_prep,...  
                     mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_i05_hold_prep,... 
                     mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_i15_hold_prep,... 
                     mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_pos_hold_prep],0.2)
errorbar([1,4,7,10],[mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_pre_hold_prep,...  
                     mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_i05_hold_prep,... 
                     mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_i15_hold_prep,... 
                     mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_pos_hold_prep],...
                      [se_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_pre_hold_prep,...  
                       se_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_i05_hold_prep,... 
                       se_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_i15_hold_prep,... 
                       se_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_pos_hold_prep],'.k')
     bar([2,5,8,11],[mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_pre_hold_prep,...  
                     mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_i05_hold_prep,... 
                     mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_i15_hold_prep,... 
                     mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_pos_hold_prep],0.2)
errorbar([2,5,8,11],[mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_pre_hold_prep,...  
                     mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_i05_hold_prep,... 
                     mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_i15_hold_prep,... 
                     mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_pos_hold_prep],...
                      [se_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_pre_hold_prep,...  
                       se_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_i05_hold_prep,... 
                       se_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_i15_hold_prep,... 
                       se_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_pos_hold_prep],'.k')
legend('Sham','','Stim','','Location','SouthEast')
set(gca,'XTick',[1 4 7 10],'XTickLabel',{'pre';'i05';'i15';'pos'},'YLim',[-20 20])
ylabel('beta c3-c4 icoh')
title('Healthy - Hold Prep')
if p_rank_all_imagescDat_ind_diff_c3_c4_beta_healthy_pre_hold_prep<0.05
    text(1.5,10,'*','Color','r')
end
if p_rank_all_imagescDat_ind_diff_c3_c4_beta_healthy_i05_hold_prep<0.05
    text(4.5,10,'*','Color','r')
end
if p_rank_all_imagescDat_ind_diff_c3_c4_beta_healthy_i15_hold_prep<0.05
    text(7.5,10,'*','Color','r')
end
if p_rank_all_imagescDat_ind_diff_c3_c4_beta_healthy_pos_hold_prep<0.05
    text(10.5,10,'*','Color','r')
end

subplot(6,4,6); hold on
     bar([1,4,7,10],[mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_pre_prep_reac,...  
                     mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_i05_prep_reac,... 
                     mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_i15_prep_reac,... 
                     mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_pos_prep_reac],0.2)
errorbar([1,4,7,10],[mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_pre_prep_reac,...  
                     mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_i05_prep_reac,... 
                     mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_i15_prep_reac,... 
                     mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_pos_prep_reac],...
                      [se_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_pre_prep_reac,...  
                       se_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_i05_prep_reac,... 
                       se_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_i15_prep_reac,... 
                       se_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_pos_prep_reac],'.k')
     bar([2,5,8,11],[mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_pre_prep_reac,...  
                     mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_i05_prep_reac,... 
                     mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_i15_prep_reac,... 
                     mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_pos_prep_reac],0.2)
errorbar([2,5,8,11],[mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_pre_prep_reac,...  
                     mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_i05_prep_reac,... 
                     mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_i15_prep_reac,... 
                     mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_pos_prep_reac],...
                      [se_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_pre_prep_reac,...  
                       se_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_i05_prep_reac,... 
                       se_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_i15_prep_reac,... 
                       se_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_pos_prep_reac],'.k')
%legend('Sham','','Stim','','Location','SouthEast')
set(gca,'XTick',[1 4 7 10],'XTickLabel',{'pre';'i05';'i15';'pos'},'YLim',[-20 20])
ylabel('beta c3-c4 icoh')
title('Healthy - Prep Reach')
if p_rank_all_imagescDat_ind_diff_c3_c4_beta_healthy_pre_prep_reac<0.05
    text(1.5,10,'*','Color','r')
end
if p_rank_all_imagescDat_ind_diff_c3_c4_beta_healthy_i05_prep_reac<0.05
    text(4.5,10,'*','Color','r')
end
if p_rank_all_imagescDat_ind_diff_c3_c4_beta_healthy_i15_prep_reac<0.05
    text(7.5,10,'*','Color','r')
end
if p_rank_all_imagescDat_ind_diff_c3_c4_beta_healthy_pos_prep_reac<0.05
    text(10.5,10,'*','Color','r')
end

% subplot(6,4,10); hold on
%      bar([1,4,7,10],[mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_pre_reac,...  
%                      mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_i05_reac,... 
%                      mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_i15_reac,... 
%                      mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_pos_reac],0.2)
% errorbar([1,4,7,10],[mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_pre_reac,...  
%                      mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_i05_reac,... 
%                      mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_i15_reac,... 
%                      mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_pos_reac],...
%                       [se_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_pre_reac,...  
%                        se_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_i05_reac,... 
%                        se_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_i15_reac,... 
%                        se_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_pos_reac],'.k')
%      bar([2,5,8,11],[mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_pre_reac,...  
%                      mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_i05_reac,... 
%                      mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_i15_reac,... 
%                      mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_pos_reac],0.2)
% errorbar([2,5,8,11],[mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_pre_reac,...  
%                      mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_i05_reac,... 
%                      mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_i15_reac,... 
%                      mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_pos_reac],...
%                       [se_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_pre_reac,...  
%                        se_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_i05_reac,... 
%                        se_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_i15_reac,... 
%                        se_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_pos_reac],'.k')
% legend('Sham','','Stim','')
% set(gca,'XTick',[1 4 7 10],'XTickLabel',{'pre';'i05';'i15';'pos'},'YLim',[0.5 0.8])
% ylabel('beta c3-c4 icoh')
% title('Healthy - Reach')

subplot(6,4,10); hold on
     bar([1,4],[mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_pre_hold_prep,...  
                  mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_pre_prep_reac],0.2)
errorbar([1,4],[mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_pre_hold_prep,...  
                  mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_pre_prep_reac],...
                   [se_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_pre_hold_prep,...  
                    se_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_pre_prep_reac],'.k')
     bar([2,5],[mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_pre_hold_prep,...  
                  mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_pre_prep_reac],0.2)
errorbar([2,5],[mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_pre_hold_prep,...  
                  mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_pre_prep_reac],...
                   [se_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_pre_hold_prep,...  
                    se_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_pre_prep_reac],'.k')
%legend('Sham','','Stim','','Location','SouthEast')
set(gca,'XTick',[1 4],'XTickLabel',{'hp';'pr'},'YLim',[-20 20])
ylabel('beta c3-c4 icoh')
title('Healthy - Pre')
if p_rank_all_imagescDat_ind_diff_c3_c4_beta_healthy_pre_hold_prep<0.05
    text(1.5,10,'*','Color','r')
end
if p_rank_all_imagescDat_ind_diff_c3_c4_beta_healthy_pre_prep_reac<0.05
    text(4.5,10,'*','Color','r')
end

subplot(6,4,14); hold on
     bar([1,4],[mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_i05_hold_prep,...  
                  mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_i05_prep_reac],0.2)
errorbar([1,4],[mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_i05_hold_prep,...  
                  mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_i05_prep_reac],...
                   [se_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_i05_hold_prep,...  
                    se_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_i05_prep_reac],'.k')
     bar([2,5],[mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_i05_hold_prep,...  
                  mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_i05_prep_reac],0.2)
errorbar([2,5],[mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_i05_hold_prep,...  
                  mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_i05_prep_reac],...
                   [se_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_i05_hold_prep,...  
                    se_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_i05_prep_reac],'.k')
%legend('Sham','','Stim','','Location','SouthEast')
set(gca,'XTick',[1 4],'XTickLabel',{'hp';'pr'},'YLim',[-20 20])
ylabel('beta c3-c4 icoh')
title('Healthy - I05')
if p_rank_all_imagescDat_ind_diff_c3_c4_beta_healthy_i05_hold_prep<0.05
    text(1.5,10,'*','Color','r')
end
if p_rank_all_imagescDat_ind_diff_c3_c4_beta_healthy_i05_prep_reac<0.05
    text(4.5,10,'*','Color','r')
end

subplot(6,4,18); hold on
     bar([1,4],[mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_i15_hold_prep,...  
                  mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_i15_prep_reac],0.2)
errorbar([1,4],[mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_i15_hold_prep,...  
                  mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_i15_prep_reac],...
                   [se_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_i15_hold_prep,...  
                    se_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_i15_prep_reac],'.k')
     bar([2,5],[mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_i15_hold_prep,...  
                  mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_i15_prep_reac],0.2)
errorbar([2,5],[mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_i15_hold_prep,...  
                  mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_i15_prep_reac],...
                   [se_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_i15_hold_prep,...  
                    se_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_i15_prep_reac],'.k')
%legend('Sham','','Stim','','Location','SouthEast')
set(gca,'XTick',[1 4],'XTickLabel',{'hp';'pr'},'YLim',[-20 20])
ylabel('beta c3-c4 icoh')
title('Healthy - I15')
if p_rank_all_imagescDat_ind_diff_c3_c4_beta_healthy_i15_hold_prep<0.05
    text(1.5,10,'*','Color','r')
end
if p_rank_all_imagescDat_ind_diff_c3_c4_beta_healthy_i15_prep_reac<0.05
    text(4.5,10,'*','Color','r')
end

subplot(6,4,22); hold on
     bar([1,4],[mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_pos_hold_prep,...  
                  mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_pos_prep_reac],0.2)
errorbar([1,4],[mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_pos_hold_prep,...  
                  mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_pos_prep_reac],...
                   [se_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_pos_hold_prep,...  
                    se_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_pos_prep_reac],'.k')
     bar([2,5],[mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_pos_hold_prep,...  
                  mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_pos_prep_reac],0.2)
errorbar([2,5],[mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_pos_hold_prep,...  
                  mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_pos_prep_reac],...
                   [se_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_pos_hold_prep,...  
                    se_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_pos_prep_reac],'.k')
%legend('Sham','','Stim','','Location','SouthEast')
set(gca,'XTick',[1 4],'XTickLabel',{'hp';'pr'},'YLim',[-20 20])
ylabel('beta c3-c4 icoh')
title('Healthy - Pos')
if p_rank_all_imagescDat_ind_diff_c3_c4_beta_healthy_pos_hold_prep<0.05
    text(1.5,10,'*','Color','r')
end
if p_rank_all_imagescDat_ind_diff_c3_c4_beta_healthy_pos_prep_reac<0.05
    text(4.5,10,'*','Color','r')
end

%sham 
subplot(6,4,3); hold on
     bar([1,4,7,10],[mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_pre_hold_prep,...  
                     mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_i05_hold_prep,... 
                     mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_i15_hold_prep,... 
                     mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_pos_hold_prep],0.2)
errorbar([1,4,7,10],[mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_pre_hold_prep,...  
                     mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_i05_hold_prep,... 
                     mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_i15_hold_prep,... 
                     mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_pos_hold_prep],...
                      [se_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_pre_hold_prep,...  
                       se_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_i05_hold_prep,... 
                       se_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_i15_hold_prep,... 
                       se_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_pos_hold_prep],'.k')
     bar([2,5,8,11],[mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_pre_hold_prep,...  
                     mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_i05_hold_prep,... 
                     mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_i15_hold_prep,... 
                     mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_pos_hold_prep],0.2)
errorbar([2,5,8,11],[mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_pre_hold_prep,...  
                     mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_i05_hold_prep,... 
                     mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_i15_hold_prep,... 
                     mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_pos_hold_prep],...
                      [se_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_pre_hold_prep,...  
                       se_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_i05_hold_prep,... 
                       se_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_i15_hold_prep,... 
                       se_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_pos_hold_prep],'.k')
legend('Stroke','','Healthy','','Location','SouthEast')
set(gca,'XTick',[1 4 7 10],'XTickLabel',{'pre';'i05';'i15';'pos'},'YLim',[-20 20])
ylabel('beta c3-c4 icoh')
title('Sham - Hold Prep')
if p_rank_all_imagescDat_ind_diff_c3_c4_beta_sham_pre_hold_prep<0.05
    text(1.5,10,'*','Color','r')
end
if p_rank_all_imagescDat_ind_diff_c3_c4_beta_sham_i05_hold_prep<0.05
    text(4.5,10,'*','Color','r')
end
if p_rank_all_imagescDat_ind_diff_c3_c4_beta_sham_i15_hold_prep<0.05
    text(7.5,10,'*','Color','r')
end
if p_rank_all_imagescDat_ind_diff_c3_c4_beta_sham_pos_hold_prep<0.05
    text(10.5,10,'*','Color','r')
end

subplot(6,4,7); hold on
     bar([1,4,7,10],[mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_pre_prep_reac,...  
                     mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_i05_prep_reac,... 
                     mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_i15_prep_reac,... 
                     mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_pos_prep_reac],0.2)
errorbar([1,4,7,10],[mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_pre_prep_reac,...  
                     mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_i05_prep_reac,... 
                     mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_i15_prep_reac,... 
                     mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_pos_prep_reac],...
                      [se_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_pre_prep_reac,...  
                       se_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_i05_prep_reac,... 
                       se_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_i15_prep_reac,... 
                       se_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_pos_prep_reac],'.k')
     bar([2,5,8,11],[mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_pre_prep_reac,...  
                     mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_i05_prep_reac,... 
                     mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_i15_prep_reac,... 
                     mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_pos_prep_reac],0.2)
errorbar([2,5,8,11],[mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_pre_prep_reac,...  
                     mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_i05_prep_reac,... 
                     mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_i15_prep_reac,... 
                     mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_pos_prep_reac],...
                      [se_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_pre_prep_reac,...  
                       se_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_i05_prep_reac,... 
                       se_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_i15_prep_reac,... 
                       se_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_pos_prep_reac],'.k')
%legend('Stroke','','Healthy','','Location','SouthEast')
set(gca,'XTick',[1 4 7 10],'XTickLabel',{'pre';'i05';'i15';'pos'},'YLim',[-20 20])
ylabel('beta c3-c4 icoh')
title('Sham - Prep Reach')
if p_rank_all_imagescDat_ind_diff_c3_c4_beta_sham_pre_prep_reac<0.05
    text(1.5,10,'*','Color','r')
end
if p_rank_all_imagescDat_ind_diff_c3_c4_beta_sham_i05_prep_reac<0.05
    text(4.5,10,'*','Color','r')
end
if p_rank_all_imagescDat_ind_diff_c3_c4_beta_sham_i15_prep_reac<0.05
    text(7.5,10,'*','Color','r')
end
if p_rank_all_imagescDat_ind_diff_c3_c4_beta_sham_pos_prep_reac<0.05
    text(10.5,10,'*','Color','r')
end

% subplot(6,4,11); hold on
%      bar([1,4,7,10],[mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_pre_reac,...  
%                      mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_i05_reac,... 
%                      mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_i15_reac,... 
%                      mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_pos_reac],0.2)
% errorbar([1,4,7,10],[mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_pre_reac,...  
%                      mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_i05_reac,... 
%                      mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_i15_reac,... 
%                      mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_pos_reac],...
%                       [se_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_pre_reac,...  
%                        se_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_i05_reac,... 
%                        se_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_i15_reac,... 
%                        se_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_pos_reac],'.k')
%      bar([2,5,8,11],[mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_pre_reac,...  
%                      mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_i05_reac,... 
%                      mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_i15_reac,... 
%                      mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_pos_reac],0.2)
% errorbar([2,5,8,11],[mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_pre_reac,...  
%                      mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_i05_reac,... 
%                      mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_i15_reac,... 
%                      mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_pos_reac],...
%                       [se_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_pre_reac,...  
%                        se_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_i05_reac,... 
%                        se_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_i15_reac,... 
%                        se_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_pos_reac],'.k')
% legend('Stroke','','Healthy','')
% set(gca,'XTick',[1 4 7 10],'XTickLabel',{'pre';'i05';'i15';'pos'},'YLim',[-20 20])
% ylabel('beta c3-c4 icoh')
% title('Sham - Reach')
 
subplot(6,4,11); hold on
     bar([1,4],[mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_pre_hold_prep,...  
                  mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_pre_prep_reac],0.2)
errorbar([1,4],[mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_pre_hold_prep,...  
                  mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_pre_prep_reac],...
                   [se_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_pre_hold_prep,...  
                    se_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_pre_prep_reac],'.k')
     bar([2,5],[mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_pre_hold_prep,...  
                  mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_pre_prep_reac],0.2)
errorbar([2,5],[mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_pre_hold_prep,...  
                  mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_pre_prep_reac],...
                   [se_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_pre_hold_prep,...  
                    se_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_pre_prep_reac],'.k')
%legend('Stroke','','Healthy','','Location','SouthEast')
set(gca,'XTick',[1 4],'XTickLabel',{'hp';'pr'},'YLim',[-20 20])
ylabel('beta c3-c4 icoh')
title('Sham - Pre')
if p_rank_all_imagescDat_ind_diff_c3_c4_beta_sham_pre_hold_prep<0.05
    text(1.5,10,'*','Color','r')
end
if p_rank_all_imagescDat_ind_diff_c3_c4_beta_sham_pre_prep_reac<0.05
    text(4.5,10,'*','Color','r')
end

subplot(6,4,15); hold on
     bar([1,4],[mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_i05_hold_prep,...  
                  mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_i05_prep_reac],0.2)
errorbar([1,4],[mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_i05_hold_prep,...  
                  mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_i05_prep_reac],...
                   [se_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_i05_hold_prep,...  
                    se_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_i05_prep_reac],'.k')
     bar([2,5],[mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_i05_hold_prep,...  
                  mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_i05_prep_reac],0.2)
errorbar([2,5],[mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_i05_hold_prep,...  
                  mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_i05_prep_reac],...
                   [se_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_i05_hold_prep,...  
                    se_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_i05_prep_reac],'.k')
%legend('Stroke','','Healthy','','Location','SouthEast')
set(gca,'XTick',[1 4],'XTickLabel',{'hp';'pr'},'YLim',[-20 20])
ylabel('beta c3-c4 icoh')
title('Sham - I05')
if p_rank_all_imagescDat_ind_diff_c3_c4_beta_sham_i05_hold_prep<0.05
    text(1.5,10,'*','Color','r')
end
if p_rank_all_imagescDat_ind_diff_c3_c4_beta_sham_i05_prep_reac<0.05
    text(4.5,10,'*','Color','r')
end

subplot(6,4,19); hold on
     bar([1,4],[mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_i15_hold_prep,...  
                  mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_i15_prep_reac],0.2)
errorbar([1,4],[mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_i15_hold_prep,...  
                  mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_i15_prep_reac],...
                   [se_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_i15_hold_prep,...  
                    se_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_i15_prep_reac],'.k')
     bar([2,5],[mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_i15_hold_prep,...  
                  mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_i15_prep_reac],0.2)
errorbar([2,5],[mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_i15_hold_prep,...  
                  mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_i15_prep_reac],...
                   [se_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_i15_hold_prep,...  
                    se_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_i15_prep_reac],'.k')
%legend('Stroke','','Healthy','','Location','SouthEast')
set(gca,'XTick',[1 4],'XTickLabel',{'hp';'pr'},'YLim',[-20 20])
ylabel('beta c3-c4 icoh')
title('Sham - I15')
if p_rank_all_imagescDat_ind_diff_c3_c4_beta_sham_i15_hold_prep<0.05
    text(1.5,10,'*','Color','r')
end
if p_rank_all_imagescDat_ind_diff_c3_c4_beta_sham_i15_prep_reac<0.05
    text(4.5,10,'*','Color','r')
end

subplot(6,4,23); hold on
     bar([1,4],[mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_pos_hold_prep,...  
                  mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_pos_prep_reac],0.2)
errorbar([1,4],[mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_pos_hold_prep,...  
                  mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_pos_prep_reac],...
                   [se_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_pos_hold_prep,...  
                    se_all_imagescDat_ind_diff_c3_c4_beta_stroke_sham_pos_prep_reac],'.k')
     bar([2,5],[mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_pos_hold_prep,...  
                  mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_pos_prep_reac],0.2)
errorbar([2,5],[mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_pos_hold_prep,...  
                  mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_pos_prep_reac],...
                   [se_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_pos_hold_prep,...  
                    se_all_imagescDat_ind_diff_c3_c4_beta_healthy_sham_pos_prep_reac],'.k')
%legend('Stroke','','Healthy','','Location','SouthEast')
set(gca,'XTick',[1 4],'XTickLabel',{'hp';'pr'},'YLim',[-20 20])
ylabel('beta c3-c4 icoh')
title('Sham - Pos')
if p_rank_all_imagescDat_ind_diff_c3_c4_beta_sham_pos_hold_prep<0.05
    text(1.5,10,'*','Color','r')
end
if p_rank_all_imagescDat_ind_diff_c3_c4_beta_sham_pos_prep_reac<0.05
    text(4.5,10,'*','Color','r')
end

%stim 
subplot(6,4,4); hold on
     bar([1,4,7,10],[mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_pre_hold_prep,...  
                     mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_i05_hold_prep,... 
                     mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_i15_hold_prep,... 
                     mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_pos_hold_prep],0.2)
errorbar([1,4,7,10],[mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_pre_hold_prep,...  
                     mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_i05_hold_prep,... 
                     mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_i15_hold_prep,... 
                     mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_pos_hold_prep],...
                      [se_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_pre_hold_prep,...  
                       se_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_i05_hold_prep,... 
                       se_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_i15_hold_prep,... 
                       se_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_pos_hold_prep],'.k')
     bar([2,5,8,11],[mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_pre_hold_prep,...  
                     mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_i05_hold_prep,... 
                     mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_i15_hold_prep,... 
                     mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_pos_hold_prep],0.2)
errorbar([2,5,8,11],[mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_pre_hold_prep,...  
                     mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_i05_hold_prep,... 
                     mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_i15_hold_prep,... 
                     mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_pos_hold_prep],...
                      [se_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_pre_hold_prep,...  
                       se_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_i05_hold_prep,... 
                       se_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_i15_hold_prep,... 
                       se_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_pos_hold_prep],'.k')
legend('Stroke','','Healthy','','Location','SouthEast')
set(gca,'XTick',[1 4 7 10],'XTickLabel',{'pre';'i05';'i15';'pos'},'YLim',[-20 20])
ylabel('beta c3-c4 icoh')
title('Stim - Hold Prep')
if p_rank_all_imagescDat_ind_diff_c3_c4_beta_stim_pre_hold_prep<0.05
    text(1.5,10,'*','Color','r')
end
if p_rank_all_imagescDat_ind_diff_c3_c4_beta_stim_i05_hold_prep<0.05
    text(4.5,10,'*','Color','r')
end
if p_rank_all_imagescDat_ind_diff_c3_c4_beta_stim_i15_hold_prep<0.05
    text(7.5,10,'*','Color','r')
end
if p_rank_all_imagescDat_ind_diff_c3_c4_beta_stim_pos_hold_prep<0.05
    text(10.5,10,'*','Color','r')
end

subplot(6,4,8); hold on
     bar([1,4,7,10],[mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_pre_prep_reac,...  
                     mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_i05_prep_reac,... 
                     mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_i15_prep_reac,... 
                     mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_pos_prep_reac],0.2)
errorbar([1,4,7,10],[mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_pre_prep_reac,...  
                     mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_i05_prep_reac,... 
                     mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_i15_prep_reac,... 
                     mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_pos_prep_reac],...
                      [se_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_pre_prep_reac,...  
                       se_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_i05_prep_reac,... 
                       se_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_i15_prep_reac,... 
                       se_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_pos_prep_reac],'.k')
     bar([2,5,8,11],[mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_pre_prep_reac,...  
                     mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_i05_prep_reac,... 
                     mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_i15_prep_reac,... 
                     mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_pos_prep_reac],0.2)
errorbar([2,5,8,11],[mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_pre_prep_reac,...  
                     mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_i05_prep_reac,... 
                     mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_i15_prep_reac,... 
                     mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_pos_prep_reac],...
                      [se_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_pre_prep_reac,...  
                       se_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_i05_prep_reac,... 
                       se_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_i15_prep_reac,... 
                       se_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_pos_prep_reac],'.k')
%legend('Stroke','','Healthy','','Location','SouthEast')
set(gca,'XTick',[1 4 7 10],'XTickLabel',{'pre';'i05';'i15';'pos'},'YLim',[-20 20])
ylabel('beta c3-c4 icoh')
title('Stim - Prep Reach')
if p_rank_all_imagescDat_ind_diff_c3_c4_beta_stim_pre_prep_reac<0.05
    text(1.5,10,'*','Color','r')
end
if p_rank_all_imagescDat_ind_diff_c3_c4_beta_stim_i05_prep_reac<0.05
    text(4.5,10,'*','Color','r')
end
if p_rank_all_imagescDat_ind_diff_c3_c4_beta_stim_i15_prep_reac<0.05
    text(7.5,10,'*','Color','r')
end
if p_rank_all_imagescDat_ind_diff_c3_c4_beta_stim_pos_prep_reac<0.05
    text(10.5,10,'*','Color','r')
end

% subplot(6,4,12); hold on
%      bar([1,4,7,10],[mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_pre_reac,...  
%                      mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_i05_reac,... 
%                      mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_i15_reac,... 
%                      mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_pos_reac],0.2)
% errorbar([1,4,7,10],[mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_pre_reac,...  
%                      mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_i05_reac,... 
%                      mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_i15_reac,... 
%                      mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_pos_reac],...
%                       [se_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_pre_reac,...  
%                        se_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_i05_reac,... 
%                        se_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_i15_reac,... 
%                        se_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_pos_reac],'.k')
%      bar([2,5,8,11],[mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_pre_reac,...  
%                      mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_i05_reac,... 
%                      mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_i15_reac,... 
%                      mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_pos_reac],0.2)
% errorbar([2,5,8,11],[mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_pre_reac,...  
%                      mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_i05_reac,... 
%                      mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_i15_reac,... 
%                      mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_pos_reac],...
%                       [se_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_pre_reac,...  
%                        se_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_i05_reac,... 
%                        se_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_i15_reac,... 
%                        se_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_pos_reac],'.k')
% legend('Stroke','','Healthy','')
% set(gca,'XTick',[1 4 7 10],'XTickLabel',{'pre';'i05';'i15';'pos'},'YLim',[-20 20])
% ylabel('beta c3-c4 icoh')
% title('Stim - Reach')
 
subplot(6,4,12); hold on
     bar([1,4],[mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_pre_hold_prep,...  
                  mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_pre_prep_reac],0.2)
errorbar([1,4],[mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_pre_hold_prep,...  
                  mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_pre_prep_reac],...
                   [se_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_pre_hold_prep,...  
                    se_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_pre_prep_reac],'.k')
     bar([2,5],[mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_pre_hold_prep,...  
                  mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_pre_prep_reac],0.2)
errorbar([2,5],[mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_pre_hold_prep,...  
                  mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_pre_prep_reac],...
                   [se_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_pre_hold_prep,...  
                    se_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_pre_prep_reac],'.k')
%legend('Stroke','','Healthy','','Location','SouthEast')
set(gca,'XTick',[1 4],'XTickLabel',{'hp';'pr'},'YLim',[-20 20])
ylabel('beta c3-c4 icoh')
title('Stim - Pre')
if p_rank_all_imagescDat_ind_diff_c3_c4_beta_stim_pre_hold_prep<0.05
    text(1.5,10,'*','Color','r')
end
if p_rank_all_imagescDat_ind_diff_c3_c4_beta_stim_pre_prep_reac<0.05
    text(4.5,10,'*','Color','r')
end

subplot(6,4,16); hold on
     bar([1,4],[mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_i05_hold_prep,...  
                  mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_i05_prep_reac],0.2)
errorbar([1,4],[mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_i05_hold_prep,...  
                  mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_i05_prep_reac],...
                   [se_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_i05_hold_prep,...  
                    se_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_i05_prep_reac],'.k')
     bar([2,5],[mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_i05_hold_prep,...  
                  mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_i05_prep_reac],0.2)
errorbar([2,5],[mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_i05_hold_prep,...  
                  mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_i05_prep_reac],...
                   [se_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_i05_hold_prep,...  
                    se_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_i05_prep_reac],'.k')
%legend('Stroke','','Healthy','','Location','SouthEast')
set(gca,'XTick',[1 4],'XTickLabel',{'hp';'pr'},'YLim',[-20 20])
ylabel('beta c3-c4 icoh')
title('Stim - I05')
if p_rank_all_imagescDat_ind_diff_c3_c4_beta_stim_i05_hold_prep<0.05
    text(1.5,10,'*','Color','r')
end
if p_rank_all_imagescDat_ind_diff_c3_c4_beta_stim_i05_prep_reac<0.05
    text(4.5,10,'*','Color','r')
end

subplot(6,4,20); hold on
     bar([1,4],[mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_i15_hold_prep,...  
                  mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_i15_prep_reac],0.2)
errorbar([1,4],[mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_i15_hold_prep,...  
                  mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_i15_prep_reac],...
                   [se_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_i15_hold_prep,...  
                    se_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_i15_prep_reac],'.k')
     bar([2,5],[mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_i15_hold_prep,...  
                  mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_i15_prep_reac],0.2)
errorbar([2,5],[mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_i15_hold_prep,...  
                  mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_i15_prep_reac],...
                   [se_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_i15_hold_prep,...  
                    se_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_i15_prep_reac],'.k')
%legend('Stroke','','Healthy','','Location','SouthEast')
set(gca,'XTick',[1 4],'XTickLabel',{'hp';'pr'},'YLim',[-20 20])
ylabel('beta c3-c4 icoh')
title('Stim - I15')
if p_rank_all_imagescDat_ind_diff_c3_c4_beta_stim_i15_hold_prep<0.05
    text(1.5,10,'*','Color','r')
end
if p_rank_all_imagescDat_ind_diff_c3_c4_beta_stim_i15_prep_reac<0.05
    text(4.5,10,'*','Color','r')
end

subplot(6,4,24); hold on
     bar([1,4],[mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_pos_hold_prep,...  
                  mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_pos_prep_reac],0.2)
errorbar([1,4],[mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_pos_hold_prep,...  
                  mean_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_pos_prep_reac],...
                   [se_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_pos_hold_prep,...  
                    se_all_imagescDat_ind_diff_c3_c4_beta_stroke_stim_pos_prep_reac],'.k')
     bar([2,5],[mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_pos_hold_prep,...  
                  mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_pos_prep_reac],0.2)
errorbar([2,5],[mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_pos_hold_prep,...  
                  mean_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_pos_prep_reac],...
                   [se_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_pos_hold_prep,...  
                    se_all_imagescDat_ind_diff_c3_c4_beta_healthy_stim_pos_prep_reac],'.k')
%legend('Stroke','','Healthy','','Location','SouthEast')
set(gca,'XTick',[1 4],'XTickLabel',{'hp';'pr'},'YLim',[-20 20])
ylabel('beta c3-c4 icoh')
title('Stim - Pos')
if p_rank_all_imagescDat_ind_diff_c3_c4_beta_stim_pos_hold_prep<0.05
    text(1.5,10,'*','Color','r')
end
if p_rank_all_imagescDat_ind_diff_c3_c4_beta_stim_pos_prep_reac<0.05
    text(4.5,10,'*','Color','r')
end

% 
% 
% subplot(6,4,sbj)
%         imagesc(imagescDat_ind_c3_c4{sp_vec(sbj)},[0.4 0.7])
% matcoh=(matcoh2-matcoh1)./matcoh1*100;

%% iCoh C3-C4 phase diff (I think you can safely skip this one as you've 
%already generated the same plots

%I think in the end we didn't need this one(?)
TOI={'pre-stim (baseline)','intrastim (5 min)','intrastim (15 min)','post-stim (5 min)'};
phases={'Hold','Prep','Reach'};
DOI={'stroke','healthy'};
stimtypes=[0,2];
stimname={'Sham','Stim'};
electrodes={'F7','T3','T5','O1','F3','C3','P3','A1','Fz','Cz','Fp2','F8','T4','T6','O2','F4','C4','P4','A2','Pz','Fp1'};
FOI_label={'Alpha','Beta','Gamma-L','Gamma-B'};
FOI_freq={{8,12},{13,30},{30,70},{70,120}};
savefigures=true;
%outpath='C:\Users\allen\Desktop\RowlandFigs_11_22_21\Coh';
outpath='/home/rowlandn/nr_data_analysis/data_analyzed/eeg/gen_03/Analysis';
iCohdiffc3_4Folder=fullfile(outpath,'iCohdiffc3_4');
mkdir(iCohdiffc3_4Folder);
exportdata=true;

eData=[];
for f=1:numel(FOI_freq)
    for d=1:numel(DOI)
        %figure('WindowState','maximized')
        figure; set(gcf,'Position',[2371 385 593 430])
        ax_count=1;
        subplot_count=1;
        clear h
        cmin=[];
        cmax=[];
        for t=1:numel(TOI)
            for p=1:numel(phases)-1
                
                tempdisease=[];
                tempstim=[];
                matcoh1=[];
                matcoh2=[];
                
                for s=1:numel(sbj)
                    
                    % Calculate coherence 1
                    sbjicoh=subjectData(s).iCoh;
                    FOI_idx=sbjicoh.freq>=FOI_freq{f}{1} & sbjicoh.freq<=FOI_freq{f}{2};
                    TOI_idx=strcmp(subjectData(s).sessioninfo.trialnames,TOI{t});
                    c3c4idx=all(strcmp(sbjicoh.label,'C3')+strcmp(sbjicoh.label,'C4'),2);
                    tempdat=mean(mean(sbjicoh.data(c3c4idx,FOI_idx,:,p,TOI_idx),2,'omitnan'),3,'omitnan');
                    matcoh1(s)=tempdat;
                    
                    % Calculate coherence 2
                    sbjicoh=subjectData(s).iCoh;
                    FOI_idx=sbjicoh.freq>=FOI_freq{f}{1} & sbjicoh.freq<=FOI_freq{f}{2};
                    TOI_idx=strcmp(subjectData(s).sessioninfo.trialnames,TOI{t});
                    c3c4idx=all(strcmp(sbjicoh.label,'C3')+strcmp(sbjicoh.label,'C4'),2);
                    tempdat=mean(mean(sbjicoh.data(c3c4idx,FOI_idx,:,p+1,TOI_idx),2,'omitnan'),3,'omitnan');
                    matcoh2(s)=tempdat;
                    
                    % Organize disease
                    tempdisease{s,1}=subjectData(s).sessioninfo.dx;
                    
                    % Organize stim
                    tempstim(s,1)=subjectData(s).sessioninfo.stimamp;
                end
                
                % Find diff
                matcoh=(matcoh2-matcoh1)./matcoh1*100;
                
                sbjname=[];
                plotdat=nan(10,2);
                for s=1:numel(stimtypes)
                    idx=tempstim==stimtypes(s)&strcmp(tempdisease,DOI{d});
                    plotdat(1:sum(idx),s)=matcoh(idx);
                    sbjname=[sbjname;sbj(idx)];
                end
                plotdat=plotdat(any(~isnan(plotdat),2),:);
                
                h(ax_count)=subplot(numel(TOI),(numel(phases)-1),subplot_count);
                subplot_count=subplot_count+1;
                ax_count=ax_count+1;
                bar(mean(plotdat,1))
                title([phases{p},' - ',phases{p+1}])
                subtitle(TOI{t})
                xticklabels({'Sham','Stim'})
                %[pass,pval]=ttest(plotdat(:),[ones(sum(idx),1);ones(sum(idx),1)*2]);
                
%                 if exportdata
%                     eData.(FOI_label{f}).(DOI{d}).([phases{p},phases{p+1}]){t}=plotdat;
%                 end
            end
        end
        
        % link axis
        linkaxes(h)
        
        % Title
        sgtitle([DOI{d},' - ',FOI_label{f}])
        
        % Save figure
        figtitle=sprintf('%s Percent C3-4 Diff Coherence - %s',FOI_label{f},DOI{d});
        if savefigures
            savefig(gcf,fullfile(iCohdiffc3_4Folder,figtitle));
        end
    end
end
%cd(iCohdiffc3_4Folder)

%% Functions
% function exportData=columnscatter(subjectData,datlabel,TOI,FOI_label,FOI_freq,phases,DOI,stimtypes,stimname,savefolder)
% 
% count_ax=1;
% ax=[];
% for f=1:numel(FOI_freq)
%     figname=[datlabel,' Column Scatter plot - ',FOI_label{f}];
%     figure('Name',figname,'WindowState','Maximized')
%     for t=1:numel(TOI)
%         for p=1:numel(phases)
%             ax(count_ax)=subplot(numel(TOI),numel(phases),p+(t-1)*numel(phases));
%             count_ax=count_ax+1;
%             hold on
%             
%             tempdat=[];
%             tempdisease=[];
%             tempstim=[];
%             tempacc=[];
%             for s=1:size(subjectData,2)
%                 
%                 if strcmp(datlabel,'iCoh')
%                     % Calculate coherence
%                     sbjicoh=subjectData(s).(datlabel);
%                     label_idx=all(strcmp(sbjicoh.label,'C3')+strcmp(sbjicoh.label,'C4'),2);
%                     FOI_idx=sbjicoh.freq>=FOI_freq{f}{1} & sbjicoh.freq<=FOI_freq{f}{2};
%                     TOI_idx=strcmp(subjectData(s).sessioninfo.trialnames,TOI{t});
%                     tempdat(s,1)=mean(mean(sbjicoh.data(label_idx,FOI_idx,:,p,TOI_idx),2,'omitnan'),3,'omitnan');
%                 end
%                 
%                 
%                 % Organize disease
%                 tempdisease{s,1}=subjectData(s).sessioninfo.dx;
%                 
%                 % Organize stim
%                 tempstim(s,1)=subjectData(s).sessioninfo.stimamp;
%             end
%             
%             clear l r pval
%             count=1;
%             axislabel=[];
%             kwdat=nan(10,numel(DOI)*numel(stimtypes));
%             sbj_name=cell(10,numel(DOI)*numel(stimtypes));
%             sbjcount=1;
%             for d=1:numel(DOI)
%                 for s=1:numel(stimtypes)
%                     idx=strcmp(tempdisease,DOI{d})&tempstim==stimtypes(s);
%                     
%                     % organize data
%                     hold on
%                     ydat=tempdat(idx);
%                     sbjs=extractAfter({subjectData(idx).SubjectName},'pro00087153_00');
%                     sbj_name(1:numel(sbjs),sbjcount)=sbjs;
%                     sbjcount=sbjcount+1;
%                     
%                     % Column Scatter plot
%                     xshift=-.2;
%                     for i=1:numel(sbjs)
%                         xshift=xshift+0.05;
%                         text((s+(d-1)*numel(stimtypes))+xshift,ydat(i),sbjs{i});
%                     end
%                     line([(s+(d-1)*numel(stimtypes))-0.1 (s+(d-1)*numel(stimtypes))+0.1],[mean(ydat) mean(ydat)],'LineWidth',2)
%                     errorbar(s+(d-1)*numel(stimtypes),mean(ydat),std(ydat)/sqrt(numel(ydat)),'LineStyle','none','Color','k')
%                     
%                     % Group axis labels
%                     axislabel=[axislabel {sprintf('%s - %s',DOI{d},stimname{s})}];
%                     
%                     % Group data for KW test
%                     kwdat(1:numel(ydat),s+(d-1)*numel(stimtypes))=ydat;
%                 end
%             end
%             xticks([1:4])
%             xticklabels(axislabel)
%             ylim([0 1])
%             ylabel([FOI_label{f},' iCoh'])
%             
%             title([TOI{t},'--',phases{p}]);
%             
%             % KW test
%             kwdat(all(isnan(kwdat),2),:)=[];
%             [pval,~,stat]=kruskalwallis(kwdat,[],'off');
%             if pval<=0.05
%                 c = multcompare(stat,'Display','off');
%                 sigIdx=find(c(:,6)<=0.05& c(:,6)>0);
%                 maxy=max(kwdat,[],'all');
%                 for si=1:numel(sigIdx)
%                     maxy=maxy+0.05;
%                     line([c(sigIdx(si),1) c(sigIdx(si),2)],[maxy maxy])
%                     text(mean([c(sigIdx(si),1) c(sigIdx(si),2)]),maxy,num2str(c(sigIdx(si),6)),'HorizontalAlignment','center')
%                 end
%             end
%             
%             % Export data
%             exportData.(FOI_label{f}).(phases{p}).data{t,1}=kwdat;
%             exportData.(FOI_label{f}).(phases{p}).columnLabel=axislabel;
%             exportData.(FOI_label{f}).(phases{p}).SubjectNames=sbj_name(any(~cellfun(@isempty,(sbj_name)),2),:);
%             %here you can export p-values
%         end
%     end
%     linkaxes(ax)
%     sgtitle(FOI_label{f})
%     savefig(gcf,fullfile(savefolder,figname))
%     saveas(gcf,fullfile(savefolder,[figname,'.jpeg']))
% end
% end


% function export=linreg(subjectData,cmpdata,TOI,FOI_label,FOI_freq,phases,DOI,stimtypes,stimname,savefolder)
% kinlabel={'movementDuration','reactionTime','handpathlength','avgVelocity','maxVelocity','velocityPeaks','timeToMaxVelocity','timeToMaxVelocity_n','avgAcceleration','maxAcceleration','accuracy','normalizedJerk','IOC'};
% 
% colors={'g','b','c','m'};
% 
% 
% ax=[];
% for f=2%1:numel(FOI_freq)
%     figure; set(gcf,'Position',[2380 99 1224 827])
%     %('WindowState','Maximized')
%     count_ax=1;
%     for t=1:numel(TOI)
%         for p=1:numel(phases)
%             ax(count_ax)=subplot(numel(TOI),numel(phases),p+(t-1)*numel(phases));
%             count_ax=count_ax+1;
%             hold on
%             
%             tempdat=[];
%             tempdisease=[];
%             tempstim=[];
%             for s=1:size(subjectData,2)
%                 
%                 for d=1:numel(cmpdata)
%                     if any(strcmp(cmpdata{d},'iCoh'))
%                         tempcmp=cmpdata{d};
%                         
%                         % Calculate coherence
%                         sbjicoh=subjectData(s).(tempcmp);
%                         label_idx=all(strcmp(sbjicoh.label,'C3')+strcmp(sbjicoh.label,'C4'),2);
%                         FOI_idx=sbjicoh.freq>=FOI_freq{f}{1} & sbjicoh.freq<=FOI_freq{f}{2};
%                         TOI_idx=strcmp(subjectData(s).sessioninfo.trialnames,TOI{t});
%                         tempdat(s,1)=mean(mean(sbjicoh.data(label_idx,FOI_idx,:,p,TOI_idx),2,'omitnan'),3,'omitnan');
%                         axislabel{d}=[FOI_label{f},' - iCoh'];
%                     elseif any(strcmp(cmpdata{d},kinlabel))
%                         tempcmp=cmpdata{d};
%                         
%                         % Calculate kinematics
%                         templabel=strcmp(subjectData(s).kinematics.label,tempcmp);
%                         tempdat(s,2)=mean(subjectData(s).kinematics.data{templabel}(:,TOI_idx),'omitnan');
%                         axislabel{d}=tempcmp;
%                     end
%                 end
%                 
%                 % Organize disease
%                 tempdisease{s,1}=subjectData(s).sessioninfo.dx;
%                 
%                 % Organize stim
%                 tempstim(s,1)=subjectData(s).sessioninfo.stimamp;
%             end
%             
%             clear l r pval
%             count=1;
%             legendlabels=[];
%             countcolor=1;
%             for d=1:numel(DOI)
%                 for s=1:numel(stimtypes)
%                     idx=strcmp(tempdisease,DOI{d})&tempstim==stimtypes(s);
%                     sbjs=extractAfter({subjectData(idx).SubjectName},'pro00087153_00');
%                     
%                     % organize data
%                     hold on
%                     xdat=tempdat(idx,1);
%                     ydat=tempdat(idx,2);
%                     
%                     export.(FOI_label{f}).(phases{p}).(DOI{d}){t,s}=[xdat;ydat];
%                     
%                     
%                     
%                     
%                     % Scatter plot
%                     for i=1:numel(xdat)
%                         txt=text(xdat(i),ydat(i),sbjs{i});
%                         if stimtypes(s)==0
%                             txt.Color=colors{countcolor};
%                             linestyle='--';
%                         else
%                             txt.Color=colors{countcolor};
%                             linestyle='-';
%                         end
%                     end
%                     countcolor=countcolor+1;
%                     
%                     % Plot trendline
%                     pv = polyfit(xdat, ydat, 1);
%                     px = [min(xdat) max(xdat)];
%                     py = polyval(pv, px);
%                     l(count)=plot(px, py, 'LineWidth', 2,'Color',txt.Color,'LineStyle',linestyle);
%                     
%                     
%                     % Calculate p and r
%                     [r,pval]=corrcoef(xdat, ydat);
%                     
%                     % Save p and r value
%                     rval=r(2,1);
%                     pval=pval(2,1);
%                     
%                     % Change line if pval <=0.5
%                     if pval<=0.05
%                         if stimtypes(s)==0
%                             l(count).Color=[0.8500 0.3250 0.0980];
%                         else
%                             l(count).Color=[0.6350 0.0780 0.1840];
%                         end
%                     end
%                     
%                     % Organize legend label
%                     legendlabels{count}=sprintf('%s %s [p(%g),r(%g)]',DOI{d},stimname{s},pval,rval);
%                     count=count+1;
%                 end
%             end
%             legend(l,legendlabels,'Location','best')
%             ylabel(axislabel{2})
%             xlabel(axislabel{1})
%             title([TOI{t},'--',phases{p}]);
%         end
%     end
%     linkaxes(ax)
%     savefig(gcf,fullfile(savefolder,[axislabel{1},' vs ',axislabel{2}]))
%     saveas(gcf,fullfile(savefolder,[axislabel{1},' vs ',axislabel{2},'.jpeg']))
% end
% end



% function export=linreg2(subjectData,cmpdata,TOI,FOI_label,FOI_freq,phases,DOI,stimtypes,stimname,savefolder)
% kinlabel={'movementDuration','reactionTime','handpathlength','avgVelocity','maxVelocity','velocityPeaks','timeToMaxVelocity','timeToMaxVelocity_n','avgAcceleration','maxAcceleration','accuracy','normalizedJerk','IOC'};
% 
% colors={'g','b','c','m'};
% 
% %cmpdata={'iCoh','IOC'}
% %linreg_dat=linreg2(subjectData,{'iCoh','IOC'},TOI,FOI_label,FOI_freq,phases,DOI,stimtypes,stimname,linReg_folder);
% 
% 
% 
% 
% ax=[];
% for f=2%1:numel(FOI_freq)
%     figure; set(gcf,'Position',[2380 99 1224 827])
%     %('WindowState','Maximized')
%     subplot_count=1;
%     count_ax=1;
%     for t=1:numel(TOI)
%         for p=1:numel(phases)-1
%             h(count_ax)=subplot(numel(TOI),(numel(phases)-1),subplot_count);
%             subplot_count=subplot_count+1;
%             count_ax=count_ax+1;
%             %ax(count_ax)=subplot(numel(TOI),numel(phases),p+(t-1)*numel(phases));
%             %count_ax=count_ax+1;
%             hold on
%             
%             tempdat=[];
%             tempdat1=[];
%             tempdat2=[];
%             tempdisease=[];
%             tempstim=[];
%             for s=1:size(subjectData,2)
%                 
%                 for d=1:numel(cmpdata)
%                     if any(strcmp(cmpdata{d},'iCoh'))
%                         tempcmp=cmpdata{d};
%                         
%                         % Calculate coherence1
%                         sbjicoh=subjectData(s).(tempcmp);
%                         label_idx=all(strcmp(sbjicoh.label,'C3')+strcmp(sbjicoh.label,'C4'),2);
%                         FOI_idx=sbjicoh.freq>=FOI_freq{f}{1} & sbjicoh.freq<=FOI_freq{f}{2};
%                         TOI_idx=strcmp(subjectData(s).sessioninfo.trialnames,TOI{t});
%                         tempdat1(s,1)=mean(mean(sbjicoh.data(label_idx,FOI_idx,:,p,TOI_idx),2,'omitnan'),3,'omitnan');
%                         axislabel{d}=[FOI_label{f},' - iCoh'];
%                         
%                         % Calculate coherence2
%                         sbjicoh=subjectData(s).(tempcmp);
%                         label_idx=all(strcmp(sbjicoh.label,'C3')+strcmp(sbjicoh.label,'C4'),2);
%                         FOI_idx=sbjicoh.freq>=FOI_freq{f}{1} & sbjicoh.freq<=FOI_freq{f}{2};
%                         TOI_idx=strcmp(subjectData(s).sessioninfo.trialnames,TOI{t});
%                         tempdat2(s,1)=mean(mean(sbjicoh.data(label_idx,FOI_idx,:,p+1,TOI_idx),2,'omitnan'),3,'omitnan');
%                         axislabel{d}=[FOI_label{f},' - iCoh'];
%                         
% %                         %Find diff
% %                         tempdat(s,1)=(tempdat2-tempdat1)./tempdat1*100;
%                     elseif any(strcmp(cmpdata{d},kinlabel))
%                         tempcmp=cmpdata{d};
%                         
%                         % Calculate kinematics
%                         templabel=strcmp(subjectData(s).kinematics.label,tempcmp);
%                         tempdat(s,2)=mean(subjectData(s).kinematics.data{templabel}(:,TOI_idx),'omitnan');
%                         axislabel{d}=tempcmp;
%                     end
%                 end
%                 
%                 % Organize disease
%                 tempdisease{s,1}=subjectData(s).sessioninfo.dx;
%                 
%                 % Organize stim
%                 tempstim(s,1)=subjectData(s).sessioninfo.stimamp;
%             end
%             %Find diff
%                 tempdat(:,1)=(tempdat2-tempdat1)./tempdat1*100;
%             
%                 clear l r pval
%             count=1;
%             legendlabels=[];
%             countcolor=1;
%             for d=1:numel(DOI)
%                 for s=1:numel(stimtypes)
%                     idx=strcmp(tempdisease,DOI{d})&tempstim==stimtypes(s);
%                     sbjs=extractAfter({subjectData(idx).SubjectName},'pro00087153_00');
%                     
%                     % organize data
%                     hold on
%                     xdat=tempdat(idx,1);
%                     ydat=tempdat(idx,2);
%                     
%                     export.(FOI_label{f}).(phases{p}).(DOI{d}){t,s}=[xdat;ydat];
%                     
%                     % Scatter plot
%                     for i=1:numel(xdat)
%                         txt=text(xdat(i),ydat(i),sbjs{i});
%                         if stimtypes(s)==0
%                             txt.Color=colors{countcolor};
%                             linestyle='--';
%                         else
%                             txt.Color=colors{countcolor};
%                             linestyle='-';
%                         end
%                     end
%                     countcolor=countcolor+1;
%                     
%                     % Plot trendline
%                     pv = polyfit(xdat, ydat, 1);
%                     px = [min(xdat) max(xdat)];
%                     py = polyval(pv, px);
%                     l(count)=plot(px, py, 'LineWidth', 2,'Color',txt.Color,'LineStyle',linestyle);
%                     
%                     
%                     % Calculate p and r
%                     [r,pval]=corrcoef(xdat, ydat);
%                     
%                     % Save p and r value
%                     rval=r(2,1);
%                     pval=pval(2,1);
%                     
%                     % Change line if pval <=0.5
%                     if pval<=0.05
%                         if stimtypes(s)==0
%                             l(count).Color=[0.8500 0.3250 0.0980];
%                         else
%                             l(count).Color=[0.6350 0.0780 0.1840];
%                         end
%                     end
%                     
%                     % Organize legend label
%                     legendlabels{count}=sprintf('%s %s [p(%g),r(%g)]',DOI{d},stimname{s},pval,rval);
%                     count=count+1;
%                 end
%             end
%             legend(l,legendlabels,'Location','best')
%             ylabel(axislabel{2})
%             xlabel(axislabel{1})
%             %title([TOI{t},'--',phases{p}]);
%             title([TOI{t},'--',phases{p},' - ',phases{p+1}])
%             
% %                 bar(mean(plotdat,1))
% %                 
% %                 subtitle(TOI{t})
% %                 xticklabels({'Sham','Stim'})
%         end
%     end
% %     linkaxes(ax)
% %     savefig(gcf,fullfile(savefolder,[axislabel{1},' vs ',axislabel{2}]))
% %     saveas(gcf,fullfile(savefolder,[axislabel{1},' vs ',axislabel{2},'.jpeg']))
% end
% end

% function mixANOVA(input,b)
% 
% % Run Mixed Anova for contra
% [~,rm]=simple_mixed_anova(vertcat(input{:}),vertcat(ones(size(input{1},1),1)*0,ones(size(input{2},1),1)*2),{'Trial'},{'Stim'});
% 
% % Compare stim vs sham
% Mrm1 = multcompare(rm,'Stim','By','Trial','ComparisonType','tukey-kramer');
% 
% if any(Mrm1.pValue<=0.05)
%     sigidx=double(unique(Mrm1.Trial(find(Mrm1.pValue<=0.05))));
%     Ylimits=get(gca,'YLim');
%     for i=1:numel(sigidx)
%         text(sigidx(i),Ylimits(2)*0.8,num2str(unique(Mrm1.pValue(double(Mrm1.Trial)==sigidx(i)))),'FontSize',20,'HorizontalAlignment','center')
%     end
% end
% 
% barpos(:,1)=b(1).XData;
% barpos(:,2)=b(2).XData;
% 
% % Compare time points
% Mrm2 = multcompare(rm,'Trial','By','Stim','ComparisonType','bonferroni');
% if any(Mrm2.pValue<=0.05)
%     idx=find(Mrm2.pValue<=0.05);
%     for i=1:numel(idx)
%         t1=double(Mrm2.Trial_1(idx(i)));
%         t2=double(Mrm2.Trial_2(idx(i)));
%         pval=Mrm2.pValue(idx(i));
%         if t1<t2
%             if double(Mrm2.Stim(idx(i)))==1
%                 sigpos=barpos(:,1);
%             else
%                 sigpos=barpos(:,2);
%             end
%             Ylimits=get(gca,'YLim');
%             nYlimits=[Ylimits(1) Ylimits(2)+0.1*Ylimits(2)];
%             set(gca,'YLim',nYlimits)
%             l=line(gca,[sigpos(t1) sigpos(t2)],[1 1]*Ylimits(2));
%             text(gca,mean([sigpos(t1) sigpos(t2)]),Ylimits(2),num2str(pval),'HorizontalAlignment','center');
%             if double(Mrm2.Stim(idx(i)))==1
%                 set(l,'linewidth',2,'Color','b')
%             else
%                 set(l,'linewidth',2,'Color',[0.8500 0.3250 0.0980])
%             end
%         end
%     end
% end
% 
% end
