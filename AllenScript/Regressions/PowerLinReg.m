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

analysisfolder=fullfile(protocolfolder,'groupanalysis','PowerLinReg');
mkdir(analysisfolder);

UOIanalysisfolder=fullfile(protocolfolder,'groupanalysis','UOI');
mkdir(UOIanalysisfolder);

trialnames={'baseline (pre-stim)','intrastim (5 min)','intrastim (15 min)','post-stim (0 min)','post-stim (5 min)','post-stim (10 min)','post-stim (15 min)'};
trialnames_diff={'intrastim (5 min)','intrastim (15 min)','post-stim (0 min)','post-stim (5 min)','post-stim (10 min)','post-stim (15 min)'};
updrsnames={'Speech';'Facial Expression';'Rigidity Neck';'Rigidity upper right';'Rigidity upper left';'Rigidity lower right';'Rigidity lower left';'Finger tapping right';'Finger tapping left';'Hand movement/grip right';'Hand movement/grip left';'Leg agility left';'Leg agility right';'Arising from chair';'Gait';'Posture';'Posture stability';'Body bradykinesia';'Postural tremor hand right';'Postural tremor hand left';'Postural tremor leg left';'Postural tremor leg right';'Kinetic tremor of hand right';'Kinetic tremor of hand left';'Lip/Jaw rest tremor';'Pron/Sup Right';'Pron/Sup Left'};
updrsnames_com={'Speech';'Facial Expression';'Rigidity- Neck';'Rigidity upper RL';'Rigidity lower RL';'Finger Tapping RL';'Hand movement/grip RL';'Leg agility RL';'Arising from chair';'Gait';'Posture';'Posture Stability';'Body bradykinesia';'Postural tremor Hand RL';'Postural tremor Leg RL';'Kinetic tremor Hand RL';'Lip/Jaw rest tremor';'Pron/Sup RL'};
linvars={'rawscore','combinedscore'};
phases={'Rest','Hold','Prep','Move'};
%% Calculate


for lv=1:length(linvars)
    clearvars templinreg

    if lv==1
        updrslength=length(updrsnames);
        updrs_table=updrs_table_all;
    else
        updrslength=length(updrsnames_com);
        updrs_table=updrs_table_com;
    end
    for trials=1:length(trialnames)
        clearvars vr rest tempinfo tempdat tempat cndat
        for updrs=1:updrslength

            count=0;
            for subject=1:length(sbj)
                subjectfolder=fullfile(protocolfolder,sbj{subject});

                % import preprocessed data
                s3dat=load(fullfile(subjectfolder,'analysis','S3-EEGanalysis','s3_dat.mat'));
                epochdat=s3dat.epochs;
                
                epochcomp=s3dat.Epochcompare;

                sessioninfo=load(fullfile(subjectfolder,'analysis','S1-VR_preproc',[sbj{subject},'_S1-VRdata_preprocessed.mat']));
                sessioninfo=sessioninfo.sessioninfo;
                
                resttrials=find(contains(sessioninfo.trialidx,sessioninfo.trialnames(epochcomp(:,1))));
                vrtrials=find(contains(sessioninfo.trialidx,sessioninfo.trialnames(epochcomp(:,2))));
                
                % Skip subjects that either don't have UPDRS or doesn't have trial

                if sum(~isnan(updrs_table{:,2*subject}))==0
                    continue
                elseif isempty(sessioninfo.trialidx{trials})
                    continue
                elseif ~any(resttrials==trials)&&~any(vrtrials==trials)
                    continue
                end
                
                restlogic=false;
                if any(resttrials==trials)
                    restlogic=true;
                    restidx=find(strcmp(sessioninfo.trialidx(trials),sessioninfo.trialnames));                    
                end
                
                vrlogic=false;
                if any(vrtrials==trials)
                    vrlogic=true;
                    vridx=find(strcmp(sessioninfo.trialidx(trials),sessioninfo.trialnames));                    
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
                                
                % Find stim channel
                switch sessioninfo.stimlat
                    case 'R'
                        stimcn=18;
                    case 'L'
                        stimcn=7;
                end
                
                % Find rest beta power
                betafreqidx(1,1)=find(epochdat.rest.psd.freq==13);
                betafreqidx(1,2)=find(epochdat.rest.psd.freq==30);
                
                if restlogic
                    temppsd=epochdat.rest.psd.saw(:,:,restidx);
                    rest=mean(temppsd(betafreqidx(1):betafreqidx(2),stimcn));
                else
                    rest=nan;
                end
                
                % Find VR beta power
                temppsd=epochdat.vrevents;
                fn=fieldnames(temppsd);
                trialidx=fn{vridx};
                temppsd=temppsd.(trialidx);
                fn=fieldnames(temppsd);
                vr=nan(1,length(fn));
                if vrlogic
                    for i=1:length(fn)
                        vr(i)=mean(temppsd.(fn{i}).psd.saw(betafreqidx(1):betafreqidx(2),stimcn,vridx));
                    end
                else
                end
                
                tempdat=[updrsscore rest vr];
                

                % Save scores to vars
                count=count+1;
                for i=2:length(tempdat)
                    cndat{updrs,i-1}(count,:)=[tempdat(1) tempdat(i)];
                end
                
                % Save info
                tempinfo{updrs,1}(count,1)=sessioninfo;
            end
        end

        % save to temp structure
        templinreg.dat(:,:,trials)=cndat;
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
    eval(['pwrlinreg.',linvars{lv},'=templinreg;']);
end

save(fullfile(analysisfolder,'pwrlinreg'),'pwrlinreg');

%% Calculate UPDRS items of interest [UOI]

UOIname={'Rigidity upper','Finger tapping','Hand movement/grip','Pron/Sup','Postural tremor hand','Kinetic tremor of hand'};
UOIstruc={'Rigidity_upper','Finger_tapping','Hand_movement_grip','Pron_Sup','Postural_tremor_hand','Kinetic_tremor_hand'};

% Calculate UOI
for uoin=1:numel(UOIname)
    for trial=1:numel(trialnames)
        tempdat=pwrlinreg.rawscore.dat(:,:,trial);
        tempinfo=pwrlinreg.rawscore.info{:,:,trial};
        tempstimlat={tempinfo.stimlat}';
        
        UOI=UOIname{uoin};
        UOIidx_R=find(~cellfun(@isempty,(regexp(updrs_table_all{:,1},[UOI,'.*right']))))-2;
        UOIidx_L=find(~cellfun(@isempty,(regexp(updrs_table_all{:,1},[UOI,'.*left']))))-2;

        UOIdat=tempdat(1,:);
        for i=1:size(tempstimlat,1)
            switch tempstimlat{i}
                case 'R'
                    updrsscore=tempdat{UOIidx_R,1}(i,1);
                case 'L'
                    updrsscore=tempdat{UOIidx_L,1}(i,1);
            end
            for z=1:size(UOIdat,2)
                UOIdat{1,z}(i,1)=updrsscore;
            end
        end
        pwrlinreg.UOI.dat(uoin,:,trial)=UOIdat;
        pwrlinreg.UOI.info{uoin,:,trial}=tempinfo;
    end
end
% Save UOI labels
pwrlinreg.UOI.label=UOIname;

% Calculate nvales
pwrlinreg.UOI.nval=cellfun(@(x) size(x,1),pwrlinreg.UOI.dat);

% Calculate pvalues
for trials=1:numel(trialnames)
    [r,p]=cellfun(@corrcoef,pwrlinreg.UOI.dat(:,:,trials),'UniformOutput',false);

    if numel(r{1,1})>1
        pwrlinreg.UOI.rval(:,:,trials)=cellfun(@(x) x(1,2),r);
        pwrlinreg.UOI.pval(:,:,trials)=cellfun(@(x) x(1,2),p);
    else
        pwrlinreg.UOI.rval(:,:,trials)=nan(size(r,1),size(r,2));
        pwrlinreg.UOI.pval(:,:,trials)=nan(size(r,1),size(r,2));
    end

    temp=pwrlinreg.UOI.pval(:,:,trials);
    pvalidx=find(~isnan(temp));
    [~, ~, ~, adj_p]=fdr_bh(temp(pvalidx));
    temp(pvalidx)=adj_p;
    pwrlinreg.UOI.fdrval(:,:,trials)=temp;
end

%% Calculate Rigidity and Tremor
rigidityUOI={'Rigidity upper','Finger tapping','Hand movement/grip','Pron/Sup'};
tremorUOI={'Postural tremor hand','Kinetic tremor of hand'};
rigidityidx=(1:4);
tremoridx=(5:6);

% Calculate Rigidity UOI
for trial=1:numel(trialnames)
    rigiditydat=pwrlinreg.UOI.dat(rigidityidx,:,trial);
    tempinfo=pwrlinreg.UOI.info(rigidityidx,:,trial);
    
    rigiditytemp=rigiditydat(1,:);
    for i=1:size(rigiditytemp,2)
        rigiditytemp{1,i}(:,1)=sum(cell2mat(cellfun(@(x) x(:,1),rigiditydat(:,i)','UniformOutput',false)),2);
    end
    
    tempnval=cellfun(@(x) size(x,1),rigiditytemp);        
    
    [r,p]=cellfun(@corrcoef,rigiditytemp,'UniformOutput',false);

    if numel(r{1,1})>1
        temprval=cellfun(@(x) x(1,2),r);
        temppval=cellfun(@(x) x(1,2),p);
    else
        temprval=nan(size(r,1),size(r,2));
        temppval=nan(size(r,1),size(r,2));
    end

    temp=temppval;
    pvalidx=find(~isnan(temp));
    [~, ~, ~, adj_p]=fdr_bh(temp(pvalidx));
    temp(pvalidx)=adj_p;
    tempfdr=temp;
    
    % Save data
    pwrlinreg.UOI.rigidity.dat(:,:,trial)=rigiditytemp;    
    pwrlinreg.UOI.rigidity.nval(:,:,trial)=tempnval;    
    pwrlinreg.UOI.rigidity.rval(:,:,trial)=temprval;    
    pwrlinreg.UOI.rigidity.pval(:,:,trial)=temppval;    
    pwrlinreg.UOI.rigidity.fdrval(:,:,trial)=temp;
    pwrlinreg.UOI.rigidity.info(:,:,trial)=tempinfo;    
end

% Calculate tremor
for trial=1:numel(trialnames)
    tremordat=pwrlinreg.UOI.dat(tremoridx,:,trial);
    tempinfo=pwrlinreg.UOI.info(tremoridx,:,trial);
    
    tremortemp=tremordat(1,:);
    for i=1:size(tremortemp,2)
        tremortemp{1,i}(:,1)=sum(cell2mat(cellfun(@(x) x(:,1),tremortemp(:,i)','UniformOutput',false)),2);
    end
    
    tempnval=cellfun(@(x) size(x,1),tremortemp);        
    
    [r,p]=cellfun(@corrcoef,tremortemp,'UniformOutput',false);

    if numel(r{1,1})>1
        temprval=cellfun(@(x) x(1,2),r);
        temppval=cellfun(@(x) x(1,2),p);
    else
        temprval=nan(size(r,1),size(r,2));
        temppval=nan(size(r,1),size(r,2));
    end

    temp=temppval;
    pvalidx=find(~isnan(temp));
    [~, ~, ~, adj_p]=fdr_bh(temp(pvalidx));
    temp(pvalidx)=adj_p;
    tempfdr=temp;
    
    % Save data
    pwrlinreg.UOI.tremor.dat(:,:,trial)=tremortemp;    
    pwrlinreg.UOI.tremor.nval(:,:,trial)=tempnval;    
    pwrlinreg.UOI.tremor.rval(:,:,trial)=temprval;    
    pwrlinreg.UOI.tremor.pval(:,:,trial)=temppval;    
    pwrlinreg.UOI.tremor.fdrval(:,:,trial)=temp;
    pwrlinreg.UOI.tremor.info(:,:,trial)=tempinfo;  
end

%% Generate graphs

% Raw UPDRS vs beta power
inputfile='pwrlinreg.UOI';
inputtitle='UPDRS of Interest vs Beta Power';
savefolder=fullfile(analysisfolder,'figures',inputtitle);
mkdir(savefolder);
[figdat{1},fighandle{1},figinfo{1}]=linreg_fig(eval(inputfile),[2 4],inputtitle,trialnames,eval([inputfile,'.label']),phases);
save(fullfile(savefolder,'figdat'),'figdat','fighandle','figinfo');

% Rigidity UPDRS vs beta power
inputfile='pwrlinreg.UOI.rigidity';
inputtitle='UPDRS of rigidity vs Beta Power';
savefolder=fullfile(analysisfolder,'figures',inputtitle);
mkdir(savefolder);
[figdat{1},fighandle{1},figinfo{1}]=linreg_fig(eval(inputfile),[2 4],inputtitle,trialnames,'Rigidity Combined Score',phases);
save(fullfile(savefolder,'figdat'),'figdat','fighandle','figinfo');

% Tremor UPDRS vs beta power
inputfile='pwrlinreg.UOI.tremor';
inputtitle='UPDRS of tremor vs Beta Power';
savefolder=fullfile(analysisfolder,'figures',inputtitle);
mkdir(savefolder);
[figdat{1},fighandle{1},figinfo{1}]=linreg_fig(eval(inputfile),[2 4],inputtitle,trialnames,'Tremor Combined Score',phases);
save(fullfile(savefolder,'figdat'),'figdat','fighandle','figinfo');
%


%% Create Scatter

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

