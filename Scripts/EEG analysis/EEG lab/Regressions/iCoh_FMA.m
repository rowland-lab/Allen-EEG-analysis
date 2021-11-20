clc
close all
clear all

% Enter in protocol folder
protocolfolder='C:\Users\allen\Box Sync\Desktop\Allen_Rowland_EEG\protocol_00087153';

% Detect subjects
sbj=dir(fullfile(protocolfolder,'pro000*.'));
sbj={sbj.name}';

%% Define Variables

% Import UPDRS
updrs_table_all=readtable(fullfile(protocolfolder,'UPDRS.xlsx'),'Sheet',1);
updrs_table_com=readtable(fullfile(protocolfolder,'UPDRS.xlsx'),'Sheet',2);

% Import FMA
fmaTable=readtable(fullfile(protocolfolder,'FMA-UE.xlsx'));
fma.Subjects=fmaTable.Properties.VariableNames(3:end);
fma.Score=fmaTable(1:33,3:end);

% Make Analysis folder
analysisfolder=fullfile(protocolfolder,'groupanalysis','PowerLinReg');
mkdir(analysisfolder);

%% Organize Data

iCoh=[];
for s=1:length(sbj)
    subjectfolder=fullfile(protocolfolder,sbj{s},'analysis','EEGlab');
    
    % import preprocessed data
    fprintf('Loading ftimagcoh mat file for %s ...',sbj{s})
    temp_iCoh=load(fullfile(subjectfolder,'EEGlab_ftimagcoh.mat'));
    
    iCoh{s}=nan(18,12,3,4);
    trials=fieldnames(temp_iCoh.eegepochs);
    for t=1:numel(trials)
        for p=1:3
            beta_freq=temp_iCoh.eegepochs.(trials{t})(p).ft_iCoh.freq>=13 & temp_iCoh.eegepochs.(trials{t})(p).ft_iCoh.freq<=30;
            c3c4idx=sum(strcmp(temp_iCoh.eegepochs.(trials{t})(p).ft_iCoh.labelcmb,'C3'),2) & sum(strcmp(temp_iCoh.eegepochs.(trials{t})(p).ft_iCoh.labelcmb,'C4'),2);
            iCoh{s}(:,1:size(temp_iCoh.eegepochs.(trials{t})(p).ft_iCoh.cohspctrm,3),p,t)=permute(temp_iCoh.eegepochs.(trials{t})(p).ft_iCoh.cohspctrm(c3c4idx,beta_freq,:),[2 3 1]);
        end
    end
end

%%
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