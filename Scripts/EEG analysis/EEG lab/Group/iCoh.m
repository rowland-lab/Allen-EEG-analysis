clear

% Enter gitpath
gitpath='C:\Users\allen\Documents\GitHub\Allen-EEG-analysis';
cd(gitpath)

% Enter in protocol folder
protocolfolder='C:\Users\allen\Box Sync\Desktop\Allen_Rowland_EEG\protocol_00087153';

% Add EEG related paths
allengit_genpaths(gitpath,'EEG')

% Detect subjects
sbj=dir(fullfile(protocolfolder,'pro000*.'));
sbj={sbj.name}';
%% Organize iCoh
clear coh diseases stimamp subject

for s=1:numel(sbj)
    try
        tempdata=load(fullfile(protocolfolder,sbj{s},'analysis','EEGlab','EEGlab_Total.mat'));
        temptrials=tempdata.eegevents_ft.trials;
    catch
        disp(['Unable to load EEGlab_ft for subject',sbj{s}])
        continue
    end
    
    tempinfo=load(fullfile(protocolfolder,sbj{s},'analysis','S1-VR_preproc',[sbj{s},'_S1-VRdata_preprocessed.mat']));
    sessioninfo=tempinfo.sessioninfo;
    trials_idx=find(~cellfun(@isempty,sessioninfo.trialidx));
    
    disease{s,1}=sessioninfo.dx;
    stimamp{s,1}=sessioninfo.stimamp;
    subject{s,1}=sbj{s};
    
    trial_names=fieldnames(tempdata.eegevents_ft.trials);
    tempdata=[];
    for t=1:numel(trial_names)
        temptrialData=temptrials.(trial_names{t});
        tempcoh=[];
        for p=1:size(temptrialData,1)
            phasedat=temptrialData(p);
            
            % Calculate iCoh
            labelcmb=phasedat.ft_iCoh.labelcmb;
            m1_idx=find(sum(strcmp(phasedat.ft_iCoh.labelcmb,'C3')+strcmp(phasedat.ft_iCoh.labelcmb,'C4'),2)==2);
            tempval=permute(phasedat.ft_iCoh.cohspctrm(m1_idx,:,:),[2 3 1]);
            tempcoh{p}=tempval;
            
%             % Calculate GC
%             C3Idx=find(strcmp(phasedat.ft_GC.label,'C3'));
%             C4Idx=find(strcmp(phasedat.ft_GC.label,'C4'));
%             
%             betafreq=phasedat.ft_GC.freq>=13&phasedat.ft_GC.freq<=30;
%             
%             C3C4GC=permute(mean(phasedat.ft_GC.grangerspctrm(C3Idx,C4Idx,betafreq,:),3),[1 2 4 3]);
%             C4C3GC=permute(mean(phasedat.ft_GC.grangerspctrm(C4Idx,C3Idx,betafreq,:),3),[1 2 4 3]);
        end
        coh{s,trials_idx(t)}=tempcoh;
    end
end

%% Calculated iCoh
phase={'hold','prep','move'};
DOI={'stroke','healthy'};
stimtype={0,2};
FOI={{8 12};{13 30};{31 70}};
FOI_names={'alpha','beta','gamma'};

% Remove empty cells
rm_idx=all(cellfun(@isempty,coh),2);
coh(rm_idx,:)=[];
disease(rm_idx,:)=[];
stimamp(rm_idx,:)=[];
subject(rm_idx,:)=[];

for f=1:numel(FOI_names)
    figure
    for d=1:numel(DOI)
        for ph=1:numel(phase)
            ax=subplot(numel(phase),numel(DOI),d+(ph-1)*numel(DOI));
            hold on

            anovaInput=[];
            for s=1:numel(stimtype)
                sbj_idx=cellfun(@(x) strcmp(x,DOI{d}),disease) & cellfun(@(x) x==stimtype{s},stimamp);
                tempcoh=coh(sbj_idx,[1 2 3 5]);
                tempcoh=cellfun(@(x) mean(x{1,ph}(FOI{f}{1}:FOI{f}{2},:),'all','omitnan'),tempcoh);

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

            title(sprintf('%s - %s',DOI{d},phase{ph}))
            xticks([1:4])
            xticklabels({'Pre','Intra-5','Intra-15','Post-5'});
            ylabel('Beta iCoh')
            ylim([0 1])
            mixANOVA(anovaInput,b);

            legend(b,{['Sham n=',num2str(n(1))],['Stim n=',num2str(n(2))]})
        end
    end
    sgtitle(FOI_names{f})
end
%% Calculated Granger Causality
phase={'hold','prep','move'};
DOI={'stroke','healthy'};
stimtype={0,2};
figure
sgtitle('Beta GC (C3-C4)');
for d=1:numel(DOI)
    for ph=1:numel(phase)
        subplot(numel(phase),numel(DOI),d+(ph-1)*numel(DOI))
        hold on
        
        for s=1:numel(stimtype)
            sbj_idx=cellfun(@(x) strcmp(x,DOI{d}),disease) & cellfun(@(x) x==stimtype{s},stimamp);
            tempcoh=coh(sbj_idx,[1 2 3 5]);
            tempcoh=cellfun(@(x) mean(x(:,ph),'omitnan'),tempcoh);
            
            bardat=mean(tempcoh,1);
            sem=std(tempcoh,1,'omitnan')./sqrt(sum(~isnan(tempcoh),1));
            
            if s==1
                xdat=(1:size(bardat,2))-0.2;
            else
                xdat=(1:size(bardat,2))+0.2;
            end
            errorbar(xdat,bardat,sem,'LineStyle','none')
            
            b(s)=bar(xdat,bardat,0.2);
            
            n=sum(~isnan(tempcoh),1);
        end
        
        title(sprintf('%s - %s',DOI{d},phase{ph}))
        xticks([1:4])
        xticklabels({['Pre (n=',num2str(n(1)),')'],['Intra-5 (n=',num2str(n(2)),')'],['Intra-15 (n=',num2str(n(3)),')'],['Post-5 (n=',num2str(n(4)),')']})
        ylabel('Beta iCoh')
        legend(b,cellfun(@num2str,stimtype,'UniformOutput',false))
    end
end


%%
function mixANOVA(input,b)

% Run Mixed Anova for contra
[~,rm]=simple_mixed_anova(vertcat(input{:}),vertcat(ones(size(input{1},1),1)*0,ones(size(input{2},1),1)*2),{'Trial'},{'Stim'});

% Compare stim vs sham
Mrm1 = multcompare(rm,'Stim','By','Trial','ComparisonType','tukey-kramer');

if any(Mrm1.pValue<=0.05)
    sigidx=double(unique(Mrm1.Trial(find(Mrm1.pValue<=0.05))));
    Ylimits=get(gca,'YLim');
    for i=1:numel(sigidx)
        text(sigidx(i),Ylimits(2)*0.8,num2str(unique(Mrm1.pValue(double(Mrm1.Trial)==sigidx(i)))),'FontSize',20,'HorizontalAlignment','center')
    end
end

barpos(:,1)=b(1).XData;
barpos(:,2)=b(2).XData;

% Compare time points
Mrm2 = multcompare(rm,'Trial','By','Stim','ComparisonType','bonferroni');
if any(Mrm2.pValue<=0.05)
    idx=find(Mrm2.pValue<=0.05);
    for i=1:numel(idx)
        t1=double(Mrm2.Trial_1(idx(i)));
        t2=double(Mrm2.Trial_2(idx(i)));
        pval=Mrm2.pValue(idx(i));
        if t1<t2
            if double(Mrm2.Stim(idx(i)))==1
                sigpos=barpos(:,1);
            else
                sigpos=barpos(:,2);
            end
            Ylimits=get(gca,'YLim');
            nYlimits=[Ylimits(1) Ylimits(2)+0.1*Ylimits(2)];
            set(gca,'YLim',nYlimits)
            l=line(gca,[sigpos(t1) sigpos(t2)],[1 1]*Ylimits(2));
            text(gca,mean([sigpos(t1) sigpos(t2)]),Ylimits(2),num2str(pval),'HorizontalAlignment','center');
            if double(Mrm2.Stim(idx(i)))==1
                set(l,'linewidth',2,'Color','b')
            else
                set(l,'linewidth',2,'Color',[0.8500 0.3250 0.0980])
            end
        end
    end
end

end
    