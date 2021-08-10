close all
clc
clear all


% Enter in protocol folder
protocolfolder='C:\Users\allen\Box Sync\Desktop\Allen_Rowland_EEG\protocol_00087153';

% Detect subjects
sbj=dir(fullfile(protocolfolder,'pro000*.'));
sbj={sbj.name}';

sbj_label=extractAfter(sbj,'pro00087153_00');
%% Group VR data

for sub=1:numel(sbj)
    
    wk_sbjfolder=fullfile(protocolfolder,sbj{sub});
    
    % Load S1 Data
    s1_file=fullfile(wk_sbjfolder,'analysis','S1-VR_preproc',[sbj{sub},'_S1-VRdata_preprocessed.mat']);
    if exist(s1_file)==0
        disp(['Preprocessing file is missing on ',sbj{sub}]);
        continue
    end
    s1_dat=load(fullfile(wk_sbjfolder,'analysis','S1-VR_preproc',[sbj{sub},'_S1-VRdata_preprocessed.mat']));
    sessioninfo=s1_dat.sessioninfo;
    
    % Load S3 data
    s3_dat=load(fullfile(wk_sbjfolder,'analysis','S3-EEGanalysis','s3_dat.mat'));
    temp_vrevents=s3_dat.epochs.vrevents;
    
    % Save VR data
    powerdat.data{sub,:}=temp_vrevents;
    powerdat.dx{sub,1}=sessioninfo.dx;
    powerdat.lat{sub,1}=sessioninfo.stimlat;
    powerdat.trial(sub,:)=sessioninfo.trialidx;
    powerdat.stim(sub,:)=sessioninfo.stimamp;
    if isfield(s3_dat,'badtrials')
        powerdat.reject{sub,:}=s3_dat.badtrials;
    end
end

for sub=1:length(powerdat.data)
    
    % Skip if empty
    if isempty(powerdat.data{sub})
        continue
    end
    
    % Find trial index
    trialidx=find(~cellfun(@isempty,(powerdat.trial(sub,:))));
    
    % Check for rejected trials
    try
        if ~isempty(powerdat.reject{sub})
            trialidx(powerdat.reject{sub}(:,1))=[];
        end
    catch
    end
    
    % assign laterality
    lat=powerdat.lat{sub};
    if strcmp(lat,'R')
        contra_cn=18;
        ip_cn=7;
    else
        contra_cn=7;
        ip_cn=18;
    end
    
    % assign stimulation parameter
    stim=powerdat.stim(sub);
    
    % assign fieldnames
    fn=fieldnames(powerdat.data{sub});
    
    % Calculate beta power for (hold,prep,move) [1,2,3]
    for trial=1:length(fn)
        % Find frequency
        betafreq=powerdat.data{sub}.(fn{trial}).atStartPosition.psd.freq>=13 &powerdat.data{sub}.(fn{trial}).atStartPosition.psd.freq<=30;

        % Beta power contra (stim)
        powerdat.beta.contra{sub,1}(trialidx(trial),1)=log10(sum(mean(powerdat.data{sub}.(fn{trial}).atStartPosition.psd.saw(betafreq,contra_cn,:),3,'omitnan')));
        powerdat.beta.contra{sub,2}(trialidx(trial),1)=log10(sum(mean(powerdat.data{sub}.(fn{trial}).cueEvent.psd.saw(betafreq,contra_cn,:),'all','omitnan')));
        powerdat.beta.contra{sub,3}(trialidx(trial),1)=log10(sum(mean(powerdat.data{sub}.(fn{trial}).targetUp.psd.saw(betafreq,contra_cn,:),'all','omitnan')));

        % Beta power ip (non-stim)
        powerdat.beta.ip{sub,1}(trialidx(trial),1)=log10(sum(mean(powerdat.data{sub}.(fn{trial}).atStartPosition.psd.saw(betafreq,ip_cn,:),'all','omitnan')));
        powerdat.beta.ip{sub,2}(trialidx(trial),1)=log10(sum(mean(powerdat.data{sub}.(fn{trial}).cueEvent.psd.saw(betafreq,ip_cn,:),'all','omitnan')));
        powerdat.beta.ip{sub,3}(trialidx(trial),1)=log10(sum(mean(powerdat.data{sub}.(fn{trial}).targetUp.psd.saw(betafreq,ip_cn,:),'all','omitnan')));
    end
end
%% Plot Beta Power data (average)

% Disease types
dx_type={'stroke','pd','healthy'};

% Timepoints of interest (Baseline, Intra-5, Intra-15, Post-5)
toi=[1 2 3 5];
toi_label={'BL','ES','LS','PT'};

% Stimulation mA
stim_type={0,2};

% Phases
phases={'Hold','Prep','Move'};

% Optional inputs
norm=false;
percent=false;
remove=true;
rm_sbj=[2 11];

clear vars sham_contra sham_ip stim_contra stim_ip
for d=3
    
    % Disease index
    dx_idx=strcmp(powerdat.dx,dx_type{d});
    
    % Subject index
    temp_sbj=sbj_label(dx_idx);
    
    % Remove subjects
    if remove
        dx_idx(logical(sum(str2num(vertcat(sbj_label{:}))==rm_sbj,2)))=false;
    end
    
    % Create figure
    figure;
    sgtitle(dx_type{d})
    
    for ph=1:numel(phases)
        inputmat_ip=[];
        inputmat_contra=[];
        between_factors=[];

        bardat_contra=[];
        bardat_ip=[];
        barsem_contra=[];
        barsem_ip=[];
        for stim=1:numel(stim_type)
            
            % Stim index
            stim_idx=powerdat.stim==stim_type{stim};
            
            % Dedicate contra and ips data
            contradat=powerdat.beta.contra(dx_idx&stim_idx,ph);
            ipdat=powerdat.beta.ip(dx_idx&stim_idx,ph);
            
            % Select trials of interest
            contradat_toi=[];
            ipdat_toi=[];
            for i=1:length(contradat)
                contradat_toi(i,:)=contradat{i}(toi);
                ipdat_toi(i,:)=ipdat{i}(toi);
            end
            
            % Change zeros to nan
            contradat_toi(contradat_toi==0)=nan;
            ipdat_toi(ipdat_toi==0)=nan;
            
            if norm
                for i=1:size(contradat_toi,1)
                    if percent
                        contradat_toi(i,:)=(contradat_toi(i,:)-contradat_toi(i,1))./contradat_toi(i,1)*100;
                        ipdat_toi(i,:)=(ipdat_toi(i,:)-ipdat_toi(i,1))./ipdat_toi(i,1)*100;
                    else
                        contradat_toi(i,:)=(contradat_toi(i,:)-contradat_toi(i,1));
                        ipdat_toi(i,:)=(ipdat_toi(i,:)-ipdat_toi(i,1));
                    end
                end
            end
            
            % Set up bardata
            bardat_contra(stim,:)=mean(contradat_toi,1,'omitnan');
            bardat_ip(stim,:)=mean(ipdat_toi,1,'omitnan');
            
            % Calculate SEM
            barsem_contra(stim,:)=std(contradat_toi,1,'omitnan')./sqrt(sum(~isnan(contradat_toi),1));
            barsem_ip(stim,:)=std(ipdat_toi,1,'omitnan')./sqrt(sum(~isnan(ipdat_toi)));
            
            % Create input ANOVA matrix
            inputmat_contra=[inputmat_contra;contradat_toi];
            inputmat_ip=[inputmat_ip;ipdat_toi];
            
            between_factors=[between_factors;ones(size(contradat_toi,1),1)*stim];
        end
        
        % Save structure
        sham_contra{ph}=inputmat_contra(between_factors==1,:);
        sham_ip{ph}=inputmat_ip(between_factors==1,:);
        
        stim_contra{ph}=inputmat_contra(between_factors==2,:);
        stim_ip{ph}=inputmat_ip(between_factors==2,:);
        
        % Create contra plot
        subplot(3,2,1+(2*(ph-1)))
        b=bar(bardat_contra');
        hold on
        errorbar([b(1).XEndPoints;b(2).XEndPoints],[b(1).YEndPoints;b(2).YEndPoints],barsem_contra,'Color',[0 0 0],'LineStyle','none');
        legend({['Sham n=',num2str(sum(between_factors==1))],['Stim n=',num2str(sum(between_factors==2))]})
        title(['Contralateral ',phases{ph}])
        if norm
            if percent
                ylabel('% change in Log Beta Power normalized to baseline')
                ylim([-100 100])
            else
                ylabel(sprintf('Change in Log Beta Power \n normalized to baseline'))
                ylim([-2 2])
            end
        else
            ylabel('Log Beta Power')
            ylim([-1 4])
        end
        xticklabels(toi_label);
        
        % Run Mixed Anova for contra
        [tbl,rm]=simple_mixed_anova(inputmat_contra,between_factors,{'Time'},{'Modality'});
        
        % Compare stim vs sham
        Mrm1 = multcompare(rm,'Modality','By','Time','ComparisonType','tukey-kramer');
        
        if any(Mrm1.pValue<=0.05)
            sigidx=double(unique(Mrm1.Time(find(Mrm1.pValue<=0.05))));
            Ylimits=get(gca,'YLim');
            for i=1:numel(sigidx)
                text(sigidx(i),Ylimits(2)*0.8,'*','FontSize',20,'HorizontalAlignment','center')
            end
        end
        
        % Compare time points
        Mrm2 = multcompare(rm,'Time','By','Modality','ComparisonType','bonferroni');
        if any(Mrm2.pValue<=0.05)
            idx=find(Mrm2.pValue<=0.05);
            for i=1:numel(idx)
                t1=double(Mrm2.Time_1(idx(i)));
                t2=double(Mrm2.Time_2(idx(i)));
                pval=Mrm2.pValue(idx(i));
                if t1<t2
                 	Ylimits=get(gca,'YLim');
                    nYlimits=[Ylimits(1) Ylimits(2)+0.1*Ylimits(2)];
                    set(gca,'YLim',nYlimits)
                    l=line(gca,[t1 t2],[1 1]*Ylimits(2));
                    t=text(gca,mean([t1 t2]),Ylimits(2),num2str(pval),'HorizontalAlignment','center');
                    if double(Mrm2.Modality(idx(i)))==1
                        set(l,'linewidth',2,'Color','r')
                    else
                        set(l,'linewidth',2,'Color','g')
                    end
                end
            end
        end
        
        % Create ip plot
        subplot(3,2,2+(2*(ph-1)))
        b=bar(bardat_ip');
        hold on
        errorbar([b(1).XEndPoints;b(2).XEndPoints],[b(1).YEndPoints;b(2).YEndPoints],barsem_ip,'Color',[0 0 0],'LineStyle','none');
        legend({['Sham n=',num2str(sum(between_factors==1))],['Stim n=',num2str(sum(between_factors==2))]})
        title(['Ipsilateral ',phases{ph}])
        if norm
            if percent
                ylabel('% change in Log Beta Power normalized to baseline')
                ylim([-100 100])
            else
                ylabel(sprintf('Change in Log Beta Power \n normalized to baseline'))
                ylim([-2 2])
            end
        else
            ylabel('Log Beta Power')
            ylim([-1 2])
        end
        xticklabels(toi_label);
        
        % Run Mixed Anova for ip
        [tbl,rm]=simple_mixed_anova(inputmat_ip,between_factors,{'Time'},{'Modality'});
        
        % Compare stim vs sham
        Mrm1 = multcompare(rm,'Modality','By','Time','ComparisonType','tukey-kramer');
        
        if any(Mrm1.pValue<=0.05)
            sigidx=double(unique(Mrm1.Time(find(Mrm1.pValue<=0.05))));
            Ylimits=get(gca,'YLim');
            nYlimits=[Ylimits(1) Ylimits(2)+0.1*Ylimits(2)];
            set(gca,'YLim',nYlimits)
            for i=1:numel(sigidx)
                text(sigidx(i),Ylimits(2),'*','FontSize',20,'HorizontalAlignment','center')
            end
        end
        
        % Compare time points
        Mrm2 = multcompare(rm,'Time','By','Modality','ComparisonType','bonferroni');
        if any(Mrm2.pValue<=0.05)
            idx=find(Mrm2.pValue<=0.05);
            for i=1:numel(idx)
                t1=double(Mrm2.Time_1(idx(i)));
                t2=double(Mrm2.Time_2(idx(i)));
                pval=Mrm2.pValue(idx(i));
                if t1<t2
                 	Ylimits=get(gca,'YLim');
                    nYlimits=[Ylimits(1) Ylimits(2)+0.1*Ylimits(2)];
                    set(gca,'YLim',nYlimits)
                    l=line(gca,[t1 t2],[1 1]*Ylimits(2));
                    t=text(gca,mean([t1 t2]),Ylimits(2),num2str(pval),'HorizontalAlignment','center');
                    if double(Mrm2.Modality(idx(i)))==1
                        set(l,'linewidth',2,'Color','r')
                    else
                        set(l,'linewidth',2,'Color','g')
                    end
                end
            end
        end
    end           
end