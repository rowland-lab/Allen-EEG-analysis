clc
close all
clear all

%%
% Enter in protocol folder
protocolfolder='C:\Users\allen\Box Sync\Allen_Rowland_EEG\protocol_00087153';

% Detect subjects
sbj=dir(fullfile(protocolfolder,'pro000*.'));
sbj={sbj.name}';

%% Define Variables

% Import UPDRS
updrs_table_all=readtable(fullfile(protocolfolder,'UPDRS.xlsx'),'Sheet',1);
updrs_table_com=readtable(fullfile(protocolfolder,'UPDRS.xlsx'),'Sheet',2);


analysisfolder=fullfile(protocolfolder,'groupanalysis','MetricLinReg');
mkdir(analysisfolder);

trialnames={'baseline (pre-stim)','intrastim (5 min)','intrastim (15 min)','post-stim (0 min)','post-stim (5 min)','post-stim (10 min)','post-stim (15 min)'};
trialnames_diff={'intrastim (5 min)','intrastim (15 min)','post-stim (0 min)','post-stim (5 min)','post-stim (10 min)','post-stim (15 min)'};
updrsnames={'Speech';'Facial Expression';'Rigidity-Neck';'Rigidity upper right';'Rigidity upper left';'Rigidity lower right';'Rigidity lower left';'Finger Tapping right';'Finger Tapping left';...
'Hand movement/grip right';'Hand movement/grip left';'Leg agility left';'Leg agility right';...
'Arising from chair';'Gait';'Posture';'Posture Stability';'Body bradykinesia';'Postural tremor hand right';'Postural tremor hand left';'Postural tremor leg left';'Postural tremor leg right';'Kinetic Tremor of hand right';'Kinetic tremor of hand left';'Lip/Jaw rest tremor';'Pron/Sup right';'Pron/Sup left'};
updrsnames_com={'Speech';'Facial Expression';'Rigidity- Neck';'Rigidity upper RL';'Rigidity lower RL';'Finger Tapping RL';'Hand movement/grip RL';'Leg agility RL';'Arising from chair';'Gait';'Posture';'Posture Stability';'Body bradykinesia';'Postural tremor Hand RL';'Postural tremor Leg RL';'Kinetic tremor Hand RL';'Lip/Jaw rest tremor';'Pron/Sup RL'};
metricnames={'reactiontime','handpathlength','avgVelocity','maxVelocity','velocityPeaks','timeToMaxVelocity','timeToMaxVelocity_n','avgAcceleration','maxAcceleration','accuracy','normalizedJerk','IOC'};
linvars={'rawscore','combinedscore'};
updrsvars={'raw','percentage'};
    
%% Calculate

for lv=1:length(linvars)
    for uvar=1:length(updrsvars)
        
        clearvars templinreg
        
        if lv==1
            updrslength=length(updrsnames);
            updrs_table=updrs_table_all;
        else
            updrslength=length(updrsnames_com);
            updrs_table=updrs_table_com;
        end
        for trials=1:length(trialnames)
            tempdata=cell(updrslength,length(metricnames));
            tempinfo=cell(updrslength,1);
            for updrs=1:updrslength

                count=0;
                for subject=1:length(sbj)
                    subjectfolder=fullfile(protocolfolder,sbj{subject});

                    % import preprocessed data
                    metricdata=load(fullfile(subjectfolder,'analysis','S2-metrics',[sbj{subject},'_S2-Metrics.mat']));
                    metricdata=metricdata.metricdat;

                    sessioninfo=load(fullfile(subjectfolder,'analysis','S1-VR_preproc',[sbj{subject},'_S1-VRdata_preprocessed.mat']));
                    sessioninfo=sessioninfo.sessioninfo;

                    % Skip subjects that either don't have UPDRS or doesn't have trial
                    if sum(~isnan(updrs_table{:,2*subject}))==0
                        continue
                    elseif isempty(sessioninfo.trialidx{trials})
                        continue
                    end

                    % detect if late reading exists
                    late=false;
                    if sum(~isnan(updrs_table{:,2*subject+1}))~= 0
                        late=true;
                    end

                    % Pulls scores
                    if late==true
                        updrsscore=updrs_table{updrs+2,subject*2+1};
                        updrsscore_tot=updrs_table{end,subject*2+1};
                    else
                        updrsscore=updrs_table{updrs+2,subject*2};
                        updrsscore_tot=updrs_table{end,subject*2};
                    end
                    
                    if uvar==2
                        updrsscore=updrsscore/updrsscore_tot;
                    end

                    % Save scores to temp vars
                    count=count+1;
                    metricidx=find(strcmp(sessioninfo.trialidx{trials},sessioninfo.trialnames));
                    for metric=1:length(metricnames)
                        tempdata{updrs,metric}(count,1)=updrsscore;
                        metricscore=metricdata.data{metric}(metricidx);
                        tempdata{updrs,metric}(count,2)=metricscore;
                    end
                    tempinfo{updrs,1}(count,1)=sessioninfo;
                end
            end

            % save to temp structure
            templinreg.dat(:,:,trials)=tempdata;
            templinreg.info(:,:,trials)=tempinfo;
            
            % Calculate n
            templinreg.nval(:,:,trials)=cellfun(@(x) size(x,1),templinreg.dat(:,:,trials));
            
            % Calculate p and r
            [r,p]=cellfun(@corrcoef,templinreg.dat(:,:,trials),'UniformOutput',false);
            
            if numel(r{1,1})>1
                templinreg.rval(:,:,trials)=cellfun(@(x) x(1,2),r);
                templinreg.pval(:,:,trials)=cellfun(@(x) x(1,2),p);
            else
                templinreg.rval(:,:,trials)=nan(size(r,1),size(r,2));
                templinreg.pval(:,:,trials)=nan(size(r,1),size(r,2));
            end

            temp=templinreg.pval(:,:,trials);
            pvalidx=find(~isnan(temp));
            [~, ~, ~, adj_p]=fdr_bh(temp(pvalidx));
            temp(pvalidx)=adj_p;
            templinreg.fdrval(:,:,trials)=temp;
        end
        eval(['linreg.',linvars{lv},'.',updrsvars{uvar},'=templinreg;']);
    end
end

% Calculate stimside UPDRS score for both raw and percentage
linreg.combinedscore.raw.stimside=stimside_linreg(linreg.combinedscore.raw,linreg.rawscore.raw,trialnames,updrsnames_com,updrsnames);
linreg.combinedscore.percentage.stimside=stimside_linreg(linreg.combinedscore.percentage,linreg.rawscore.percentage,trialnames,updrsnames_com,updrsnames);

% Calculate difference
linreg.rawscore.raw.diff=linreg_diffcalc(linreg.rawscore.raw);
linreg.rawscore.percentage.diff=linreg_diffcalc(linreg.rawscore.percentage);

linreg.combinedscore.raw.diff=linreg_diffcalc(linreg.combinedscore.raw);
linreg.combinedscore.raw.stimside.diff=linreg_diffcalc(linreg.combinedscore.raw.stimside);

linreg.combinedscore.percentage.diff=linreg_diffcalc(linreg.combinedscore.percentage);
linreg.combinedscore.percentage.stimside.diff=linreg_diffcalc(linreg.combinedscore.percentage.stimside);

% Seperate Sham vs Anodal
linreg.rawscore.raw.stimmodal=linreg_stimmodal(linreg.rawscore.raw);
linreg.rawscore.raw.diff.stimmodal=linreg_stimmodal(linreg.rawscore.raw.diff);

linreg.rawscore.percentage.stimmodal=linreg_stimmodal(linreg.rawscore.percentage);
linreg.rawscore.percentage.diff.stimmodal=linreg_stimmodal(linreg.rawscore.percentage.diff);


linreg.combinedscore.raw.stimmodal=linreg_stimmodal(linreg.combinedscore.raw);
linreg.combinedscore.raw.diff.stimmodal=linreg_stimmodal(linreg.combinedscore.raw.diff);
linreg.combinedscore.raw.stimside.stimmodal=linreg_stimmodal(linreg.combinedscore.raw.stimside);
linreg.combinedscore.raw.stimside.diff.stimmodal=linreg_stimmodal(linreg.combinedscore.raw.stimside.diff);

linreg.combinedscore.percentage.stimmodal=linreg_stimmodal(linreg.combinedscore.percentage);
linreg.combinedscore.percentage.diff.stimmodal=linreg_stimmodal(linreg.combinedscore.percentage.diff);
linreg.combinedscore.percentage.stimside.stimmodal=linreg_stimmodal(linreg.combinedscore.percentage.stimside);
linreg.combinedscore.percentage.stimside.diff.stimmodal=linreg_stimmodal(linreg.combinedscore.percentage.stimside.diff);

% Save variable
save(fullfile(analysisfolder,'linreg'),'linreg')                    
%% Generate graphs

% Raw UPDRS vs Metric
inputfile='linreg.rawscore.raw';
title='UPDRS vs Metric';
savefolder=fullfile(analysisfolder,'figures',title);
mkdir(savefolder);
[figdat{1},fighandle{1},figinfo{1}]=linreg_fig(eval(inputfile),[2 4],title,trialnames,updrsnames,metricnames);
[figdat{2},fighandle{2},figinfo{2}]=linreg_fig(eval(inputfile).stimmodal.anodal,[2 4],[title,' (anodal)'],trialnames,updrsnames,metricnames);
[figdat{3},fighandle{3},figinfo{3}]=linreg_fig(eval(inputfile).stimmodal.sham,[2 4],[title,' (sham)'],trialnames,updrsnames,metricnames);

[figdat{4},fighandle{4},figinfo{4}]=linreg_fig(eval(inputfile).diff,[2 3],[title,' Difference'],trialnames_diff,updrsnames,metricnames);
[figdat{5},fighandle{5},figinfo{5}]=linreg_fig(eval(inputfile).diff.stimmodal.anodal,[2 3],[title,' Difference (anodal)'],trialnames_diff,updrsnames,metricnames);
[figdat{6},fighandle{6},figinfo{6}]=linreg_fig(eval(inputfile).diff.stimmodal.sham,[2 3],[title,' Difference (sham)'],trialnames_diff,updrsnames,metricnames);
save(fullfile(savefolder,'figdat'),'figdat','fighandle','figinfo');

% Raw UPDRS% vs Metric
inputfile='linreg.rawscore.percentage';
title='UPDRS(%) vs Metric';
savefolder=fullfile(analysisfolder,'figures',title);
mkdir(savefolder);
[figdat{1},fighandle{1},figinfo{1}]=linreg_fig(eval(inputfile),[2 4],title,trialnames,updrsnames,metricnames);
[figdat{2},fighandle{2},figinfo{2}]=linreg_fig(eval(inputfile).stimmodal.anodal,[2 4],[title,' (anodal)'],trialnames,updrsnames,metricnames);
[figdat{3},fighandle{3},figinfo{3}]=linreg_fig(eval(inputfile).stimmodal.sham,[2 4],[title,' (sham)'],trialnames,updrsnames,metricnames);

[figdat{4},fighandle{4},figinfo{4}]=linreg_fig(eval(inputfile).diff,[2 3],[title,' Difference'],trialnames_diff,updrsnames,metricnames);
[figdat{5},fighandle{5},figinfo{5}]=linreg_fig(eval(inputfile).diff.stimmodal.anodal,[2 3],[title,' Difference (anodal)'],trialnames_diff,updrsnames,metricnames);
[figdat{6},fighandle{6},figinfo{6}]=linreg_fig(eval(inputfile).diff.stimmodal.sham,[2 3],[title,' Difference (sham)'],trialnames_diff,updrsnames,metricnames);
save(fullfile(savefolder,'figdat'),'figdat','fighandle','figinfo');

% Combined UPDRS vs Metric
inputfile='linreg.combinedscore.raw';
title='Combined UPDRS vs Metric';
savefolder=fullfile(analysisfolder,'figures',title);
mkdir(savefolder);
[figdat{1},fighandle{1},figinfo{1}]=linreg_fig(eval(inputfile),[2 4],title,trialnames,updrsnames_com,metricnames);
[figdat{2},fighandle{2},figinfo{2}]=linreg_fig(eval(inputfile).stimmodal.anodal,[2 4],[title,' (anodal)'],trialnames,updrsnames_com,metricnames);
[figdat{3},fighandle{3},figinfo{3}]=linreg_fig(eval(inputfile).stimmodal.sham,[2 4],[title,' (sham)'],trialnames,updrsnames_com,metricnames);

[figdat{4},fighandle{4},figinfo{4}]=linreg_fig(eval(inputfile).diff,[2 3],[title,' Difference'],trialnames_diff,updrsnames_com,metricnames);
[figdat{5},fighandle{5},figinfo{5}]=linreg_fig(eval(inputfile).diff.stimmodal.anodal,[2 3],[title,' Difference (anodal)'],trialnames_diff,updrsnames_com,metricnames);
[figdat{6},fighandle{6},figinfo{6}]=linreg_fig(eval(inputfile).diff.stimmodal.sham,[2 3],[title,' Difference (sham)'],trialnames_diff,updrsnames_com,metricnames);
save(fullfile(savefolder,'figdat'),'figdat','fighandle','figinfo');

% Combined UPDRS% vs Metric
inputfile='linreg.combinedscore.percentage';
title='Combined UPDRS(%) vs Metric';
savefolder=fullfile(analysisfolder,'figures',title);
mkdir(savefolder);
[figdat{1},fighandle{1},figinfo{1}]=linreg_fig(eval(inputfile),[2 4],title,trialnames,updrsnames_com,metricnames);
[figdat{2},fighandle{2},figinfo{2}]=linreg_fig(eval(inputfile).stimmodal.anodal,[2 4],[title,' (anodal)'],trialnames,updrsnames_com,metricnames);
[figdat{3},fighandle{3},figinfo{3}]=linreg_fig(eval(inputfile).stimmodal.sham,[2 4],[title,' (sham)'],trialnames,updrsnames_com,metricnames);

[figdat{4},fighandle{4},figinfo{4}]=linreg_fig(eval(inputfile).diff,[2 3],[title,' Difference'],trialnames_diff,updrsnames_com,metricnames);
[figdat{5},fighandle{5},figinfo{5}]=linreg_fig(eval(inputfile).diff.stimmodal.anodal,[2 3],[title,' Difference (anodal)'],trialnames_diff,updrsnames_com,metricnames);
[figdat{6},fighandle{6},figinfo{6}]=linreg_fig(eval(inputfile).diff.stimmodal.sham,[2 3],[title,' Difference (sham)'],trialnames_diff,updrsnames_com,metricnames);
save(fullfile(savefolder,'figdat'),'figdat','fighandle','figinfo');

% Combined UPDRS (stimside) vs Metric
inputfile='linreg.combinedscore.raw.stimside';
title='Combined UPDRS (stimside) vs Metric';
savefolder=fullfile(analysisfolder,'figures',title);
mkdir(savefolder);
[figdat{1},fighandle{1},figinfo{1}]=linreg_fig(eval(inputfile),[2 4],title,trialnames,updrsnames_com,metricnames);
[figdat{2},fighandle{2},figinfo{2}]=linreg_fig(eval(inputfile).stimmodal.anodal,[2 4],[title,' (anodal)'],trialnames,updrsnames_com,metricnames);
[figdat{3},fighandle{3},figinfo{3}]=linreg_fig(eval(inputfile).stimmodal.sham,[2 4],[title,' (sham)'],trialnames,updrsnames_com,metricnames);

[figdat{4},fighandle{4},figinfo{4}]=linreg_fig(eval(inputfile).diff,[2 3],[title,' Difference'],trialnames_diff,updrsnames_com,metricnames);
[figdat{5},fighandle{5},figinfo{5}]=linreg_fig(eval(inputfile).diff.stimmodal.anodal,[2 3],[title,' Difference (anodal)'],trialnames_diff,updrsnames_com,metricnames);
[figdat{6},fighandle{6},figinfo{6}]=linreg_fig(eval(inputfile).diff.stimmodal.sham,[2 3],[title,' Difference (sham)'],trialnames_diff,updrsnames_com,metricnames);
save(fullfile(savefolder,'figdat'),'figdat','fighandle','figinfo');

% Combined UPDRS% (stimside) vs Metric
inputfile='linreg.combinedscore.percentage.stimside';
title='Combined UPDRS(%) (stimside) vs Metric';
savefolder=fullfile(analysisfolder,'figures',title);
mkdir(savefolder);
[figdat{1},fighandle{1},figinfo{1}]=linreg_fig(eval(inputfile),[2 4],title,trialnames,updrsnames_com,metricnames);
[figdat{2},fighandle{2},figinfo{2}]=linreg_fig(eval(inputfile).stimmodal.anodal,[2 4],[title,' (anodal)'],trialnames,updrsnames_com,metricnames);
[figdat{3},fighandle{3},figinfo{3}]=linreg_fig(eval(inputfile).stimmodal.sham,[2 4],[title,' (sham)'],trialnames,updrsnames_com,metricnames);

[figdat{4},fighandle{4},figinfo{4}]=linreg_fig(eval(inputfile).diff,[2 3],[title,' Difference'],trialnames_diff,updrsnames_com,metricnames);
[figdat{5},fighandle{5},figinfo{5}]=linreg_fig(eval(inputfile).diff.stimmodal.anodal,[2 3],[title,' Difference (anodal)'],trialnames_diff,updrsnames_com,metricnames);
[figdat{6},fighandle{6},figinfo{6}]=linreg_fig(eval(inputfile).diff.stimmodal.sham,[2 3],[title,' Difference (sham)'],trialnames_diff,updrsnames_com,metricnames);
save(fullfile(savefolder,'figdat'),'figdat','fighandle','figinfo');
%%

figurenum=get(gcf,'Number');

t=input('enter trial=');
[x, y] = ginput(1);
x=round(x);
y=round(y);

figure
scatdat=figdat{figurenum}{y,x,t};
scatinfo=figinfo{figurenum}{y,:,t};
rightidx=strcmp({scatinfo.stimlat}','R');
leftidx=strcmp({scatinfo.stimlat}','L');
stimidx=[scatinfo.stimamp]'==2;
shamidx=[scatinfo.stimamp]'==0;

rg=sum([rightidx stimidx],2)==2;
lg=sum([leftidx stimidx],2)==2;
rr=sum([rightidx shamidx],2)==2;
lr=sum([leftidx shamidx],2)==2;

hold on
scatter(scatdat(rg,1),scatdat(rg,2),200,'>g');
scatter(scatdat(lg,1),scatdat(lg,2),200,'<g');
scatter(scatdat(rr,1),scatdat(rr,2),200,'>r');
scatter(scatdat(lr,1),scatdat(lr,2),200,'<r');
xlabel(fighandle{figurenum}.CurrentAxes.YTickLabel(y))
ylabel(fighandle{figurenum}.CurrentAxes.XTickLabel(x))
legend({'Stim (R)','Stim (L)','Sham (R)','Sham (L)'})

