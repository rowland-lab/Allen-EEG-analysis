close all
clc
clear all

Rowland_start

% Enter in protocol folder
protocolfolder='C:\Users\allen\Box Sync\Desktop\Allen_Rowland_EEG\protocol_00087153';

% Detect subjects
sbj=dir(fullfile(protocolfolder,'pro000*.'));
sbj={sbj.name}';

sbj_label=extractAfter(sbj,'pro00087153_00');

% Create fig folder
figfolder=fullfile('C:\Users\allen\Box Sync\Desktop\Allen_Rowland_EEG\protocol_00087153','groupanalysis','ICA-power');;
figpowerfolder=fullfile(figfolder,'power');
figphasedifffolder=fullfile(figfolder,'phasediff');
figtopofolder=fullfile(figfolder,'topo');

% Make group power folder
mkdir(figfolder);
mkdir(figpowerfolder);
mkdir(figphasedifffolder);
mkdir(figtopofolder);
%% Calculate group analysis (power)
fig_pwr=[];
for subject=1:numel(sbj)
    
    % Define folders
    analysisfolder=fullfile(protocolfolder,sbj{subject},'analysis');
    
    % Load EEG power analysis file
    eegpwrfile=fullfile(analysisfolder,'EEGlab','EEGlab_power.mat');
    if ~exist(eegpwrfile)
        continue
    end
    
    load(eegpwrfile);
    
    % Skip subject if missing files
    if ~exist(eegpwrfile)
        disp([sbj{subject},' missing EEGlab freq/power analysis file'])
        continue
    end

    if ~isfield(eegevents.t1,'power')
        continue
    end
    
    % Organize power
    trials=fieldnames(eegevents);
    for trl=1:numel(trials)
        EEG=eegevents.(trials{trl});
        for phas=1:size(EEG,1)
            phaseEEG=EEG(phas);
            
            % Power vars
            temppower=phaseEEG.power;
            if isempty(temppower)
                continue
            end
            
            % Define session info
            sessioninfo=phaseEEG.sessioninfo;

            switch sessioninfo.stimlat
                case 'L'
                    stim_cn=7;
                    contra_cn=14;
                case 'R'
                    stim_cn=14;
                    contra_cn=7;
            end

            % Save Subject Info
            dx=sessioninfo.dx;

            fig_pwr.subjmodal(subject,1)=sessioninfo.stimamp;
            fig_pwr.dx{subject,1}=dx;
            
            % Find positive times
            pos_time_idx=temppower.times(1,:,1)>0;
            
            % Find Alpha and Beta freq idxs
            alphafreq=temppower.freqs(:,:,1)>=8 & temppower.freqs(:,:,1)<13;
            betafreq=temppower.freqs(:,:,1)>=13 & temppower.freqs(:,:,1)<30;
            
            % Find Trial Idx
            trl_idx=find(strcmp(sessioninfo.trialnames{trl},sessioninfo.trialidx));

            % Organize raw power
            fig_pwr.raw.alpha.stim.(dx){phas}{subject,trl_idx}=mean(temppower.ersp(alphafreq,pos_time_idx,stim_cn),'all');
            fig_pwr.raw.beta.stim.(dx){phas}{subject,trl_idx}=mean(temppower.ersp(betafreq,pos_time_idx,stim_cn),'all');
            
            fig_pwr.raw.beta.contra.(dx){phas}{subject,trl_idx}=mean(temppower.ersp(betafreq,pos_time_idx,contra_cn),'all');
            fig_pwr.raw.alpha.contra.(dx){phas}{subject,trl_idx}=mean(temppower.ersp(alphafreq,pos_time_idx,contra_cn),'all');

            fig_pwr.raw.beta.topo.(dx){phas}{subject,trl_idx}=permute(mean(temppower.ersp(betafreq,pos_time_idx,:),[1 2]),[3 1 2]);
            fig_pwr.raw.alpha.topo.(dx){phas}{subject,trl_idx}=permute(mean(temppower.ersp(alphafreq,pos_time_idx,:),[1 2]),[3 1 2]);

            
            
            % Organize diff power
            fig_pwr.diff.alpha.stim.(dx){phas}{subject,trl_idx}=mean(temppower.ersp_diff(alphafreq,pos_time_idx,stim_cn),'all');
            fig_pwr.diff.beta.stim.(dx){phas}{subject,trl_idx}=mean(temppower.ersp_diff(betafreq,pos_time_idx,stim_cn),'all');
            
            fig_pwr.diff.alpha.contra.(dx){phas}{subject,trl_idx}=mean(temppower.ersp_diff(alphafreq,pos_time_idx,contra_cn),'all');
            fig_pwr.diff.beta.contra.(dx){phas}{subject,trl_idx}=mean(temppower.ersp_diff(betafreq,pos_time_idx,contra_cn),'all');
            
            fig_pwr.diff.beta.topo.(dx){phas}{subject,trl_idx}=permute(mean(temppower.ersp_diff(betafreq,pos_time_idx,:),[1 2]),[3 1 2]);
            fig_pwr.diff.alpha.topo.(dx){phas}{subject,trl_idx}=permute(mean(temppower.ersp_diff(alphafreq,pos_time_idx,:),[1 2]),[3 1 2]);
        end
    end
end

%% Create Power Graphs
bands={'alpha','beta'};
dx_labels={'stroke','pd','healthy'};
phases={'Hold','Prep','Move'};

norm=true;

for b=2
    for dx=2
        % Find subject info
        subject_idx=find(strcmp(fig_pwr.dx,dx_labels{dx}));
        stimmod=fig_pwr.subjmodal(subject_idx);
        stim_idx=stimmod==2;
        sham_idx=stimmod==0;
        
        subjects_w_mod=[];
        for i=1:numel(subject_idx)
            subjects_w_mod{i}=[sbj_label{subject_idx(i)} ' (' num2str(stimmod(i)) ')'];
        end
        
        %%%%%%%% Plot Stim side
        % Organize data
        wkdat=fig_pwr.raw.(bands{b}).stim.(dx_labels{dx});
        for i=1:length(wkdat)
            tempdat=wkdat{i};
            tempdat=tempdat(subject_idx,:);
            for z=1:size(tempdat,1)
                ttempdat=tempdat(z,:);
                ttempdat(cellfun(@isempty ,ttempdat))={nan};
                tempdat(z,:)=ttempdat;
            end
            tempdat=cellfun(@double,tempdat);
            wkdat{i}=tempdat;
        end
        
        
        % Plot phases power individually
        f=figure('units','normalized','outerposition',[0 0 1 1]);
        for ph=1:numel(phases)
            
            % Isolate phase data
            phasedat=wkdat{ph};
            
            if norm
                % normalize to baseline
                for r=1:size(phasedat,1)
                    tempbl=phasedat(r,1);
                    for c=1:size(phasedat,2)
                        phasedat(r,c)=phasedat(r,c)-tempbl;
                    end
                end
            end
                        
            % Plot data (Only pre,intra5,intra15,post5)
            subplot(3,1,ph)
            hold on
            
            for s=1:size(phasedat,1)
                tempdat=phasedat(s,[1 2 3 5]);
                tempxdat=1:numel(tempdat);
                templine=plot(tempxdat,tempdat);
                templine.LineWidth=2;

                if stimmod(s)==2
                    templine.LineStyle='-';
                    templine.Marker='+';
                else
                    templine.LineStyle=':';
                    templine.Marker='o';
                end
            end
            
            subjects_w_mod=[];
            for i=1:numel(subject_idx)
                subjects_w_mod{i}=[sbj_label{subject_idx(i)} ' (' num2str(stimmod(i)) ')'];
            end
            
            legend(subjects_w_mod,'NumColumns',2,'Location','northeast')
            xlabel('Trials')
            if norm
                ylabel(['Log ',bands{b},' Power (noramlized)'])
                ylim([-10 10])
            else
                ylabel(['Log ',bands{b},' Power'])
                ylim([0 30])
            end
            set(gca,'XTick',[1 2 3 4],'XTickLabel',{'Pre-stim','Intra-5','Intra-15','Post-5'})
            xlim([0 5])            
            title(phases{ph})
        end
        if norm
            temptitle=[dx_labels{dx},' - Stim Side (normalized)'];
        else
            temptitle=[dx_labels{dx},' - Stim Side'];
        end
        sgtitle(temptitle)
%         saveas(f,fullfile(figpowerfolder,temptitle),'jpeg')
%         saveas(f,fullfile(figpowerfolder,temptitle),'eps')
        
        
        % Plot change in power compared to previous phase
        figure('units','normalized','outerposition',[0 0 1 1])
        % Plot phases power individually
        for ph=1:numel(phases)
            
            % Isolate first phase vs second phase
            switch ph
                case 1 % Hold -> Cue
                    phdat1=wkdat{1};
                    phdat2=wkdat{2};
                    comp_label='Hold vs Cue';
                case 2 % Cue-> Move
                    phdat1=wkdat{2};
                    phdat2=wkdat{3};
                    comp_label='Cue vs Move';
                case 3 % Move -> Hold
                    phdat1=wkdat{3};
                    phdat2=wkdat{1};
                    comp_label='Move vs Hold';
            end
            
            % Calculate diff
            diffdat=(phdat2-phdat1)./phdat1*100;
            
            if norm
                % normalize to baseline
                for r=1:size(diffdat,1)
                    tempbl=diffdat(r,1);
                    for c=1:size(diffdat,2)
                        diffdat(r,c)=diffdat(r,c)-tempbl;
                    end
                end
            end
            
%             % Run Mixed Anova
%             inputmat=diffdat(:,[1 2 3 5]);
%             between_factors=stim_idx;
%             [tbl,rm]=simple_mixed_anova(inputmat,between_factors,{'Time'},{'Modality'})
%             Mrm1 = multcompare(rm,'Time','By','Modality','ComparisonType','bonferroni');
                        
            % Plot data (Only pre,intra5,intra15,post5)
            subplot(3,1,ph)
            hold on
            
            for s=1:size(diffdat,1)
                tempdat=diffdat(s,[1 2 3 5]);
                tempxdat=1:numel(tempdat);
                templine=plot(tempxdat,tempdat);
                templine.LineWidth=2;

                if stimmod(s)==2
                    templine.LineStyle='-';
                    templine.Marker='+';
                else
                    templine.LineStyle=':';
                    templine.Marker='o';
                end
            end
            

            legend(subjects_w_mod,'NumColumns',2,'Location','northeast')
            xlabel('Trials')
            
            set(gca,'XTick',[1 2 3 4],'XTickLabel',{'Pre-stim','Intra-5','Intra-15','Post-5'})
            xlim([0 5])
            title(comp_label)
            
            if norm
                ylabel(['Percent change in Log ',bands{b},' Power (normalized)'])
                ylim([-75 50])
            else
                ylabel(['Percent change in Log ',bands{b},' Power'])
                ylim([-60 60])
            end
        end
        
        if norm
            temptitle=([dx_labels{dx},' - Stim Side (normalized)']);
        else
            temptitle=([dx_labels{dx},' - Stim Side']);
        end
        
        sgtitle(temptitle)
%         saveas(gcf,fullfile(figphasedifffolder,temptitle),'jpeg')
%         saveas(gcf,fullfile(figphasedifffolder,temptitle),'epsc')


        % Plot phases power individually (mean power)
        f=figure('units','normalized','outerposition',[0 0 1 1]);
        
        for ph=1:numel(phases)
            
            % Isolate phase data
            phasedat=wkdat{ph};
            
            if norm
                for i=1:size(phasedat,1)
                    bl=phasedat(i,1);
                    phasedat(i,:)=phasedat(i,:)-bl;
                end
            end
            
            % Seperate stimulation data (Only pre,intra5,intra15,post5)
            stimdat=phasedat(stim_idx,[1 2 3 5]);
            shamdat=phasedat(sham_idx,[1 2 3 5]);
            
            % Calculate Error
            stimdat_err=std(stimdat,1,'omitnan')./sqrt(sum(~isnan(stimdat)));
            shamdat_err=std(shamdat,1,'omitnan')./sqrt(sum(~isnan(shamdat)));
                        
            % Plot data 
            subplot(3,1,ph)            
            hold on
            stimline=errorbar(mean(stimdat,1,'omitnan'),stimdat_err);
            stimline.LineStyle=':';
            stimline.Marker='o';
            stimline.Color='g';
            stimline.LineWidth=2;
            
            shamline=errorbar(mean(shamdat,1,'omitnan'),shamdat_err);
            shamline.LineStyle='-';
            shamline.Marker='+';
            shamline.Color='r';
            shamline.LineWidth=2;


            legend({['Stim (n=',num2str(size(stimdat,1)),')'],['Sham (n=',num2str(size(shamdat,1)),')']},'NumColumns',2,'Location','northeast')
            xlabel('Trials')
            if norm
                ylabel(['Log ',bands{b},' Power (noramlized)'])
            else
                ylabel(['Log ',bands{b},' Power'])
            end
            set(gca,'XTick',[1 2 3 4],'XTickLabel',{'Pre-stim','Intra-5','Intra-15','Post-5'})
            
            xlim([0 5])
            title(phases{ph})
            
            if norm
                temptitle=[dx_labels{dx},' - Stim Side (normalized)'];
                ylim([-4 4])
            else
                temptitle=[dx_labels{dx},' - Stim Side'];
                ylim([0 15])
            end
            sgtitle(temptitle)
            
            % Run Mixed Anova
            [tbl,rm]=simple_mixed_anova([stimdat;shamdat],[ones(size(stimdat,1),1);ones(size(stimdat,1),1)*2],{'Time'},{'Modality'});
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
        
              
        
        






%                
%         % Mean phases
%         wkdat=cat(3,wkdat{1},wkdat{2},wkdat{3});
%         wkdat=mean(wkdat,3,'omitnan');
%         
%         % Only plot (baseline, intra5, intra15, post5)
%         wkdat=wkdat(:,[1 2 3 5]);
%         
%         subplot(2,2,1)        
%         hold on
%         for i=1:size(wkdat,1)
%             tempdat=wkdat(i,:);
%             tempxdat=1:size(wkdat,2);
%             
%             templine=plot(tempxdat,tempdat);
%             templine.LineWidth=2;
%             
%             if stimmod(i)==2
%                 templine.LineStyle='-';
%                 templine.Marker='+';
%             else
%                 templine.LineStyle=':';
%                 templine.Marker='o';
%             end
%         end
%         
%         subjects_w_mod=[];
%         for i=1:numel(subject_idx)
%             subjects_w_mod{i}=[sbj_label{subject_idx(i)} ' (' num2str(stimmod(i)) ')'];
%         end
%         
%         legend(subjects_w_mod,'NumColumns',2,'Location','northeast')
%         xlabel('Trials')
% %         ylabel(['Change in Log ',bands{b},' Power normalized to baseline'])
%         ylabel(['Log ',bands{b},' Power'])
%         set(gca,'XTick',[1 2 3 4],'XTickLabel',{'Pre-stim','Intra-5','Intra-15','Post-5'})
%         xlim([0 5])
%         title('Stim Side')
%         
% %         % Run Mixed ANOVA
% %         inputmat=[poweravg.stim;poweravg.sham];
% %         between_factors=double(cell2mat(cellfun(@(x) strcmp(extractAfter(extractBefore(x,')'),'('),'0'),subjects_w_mod,'UniformOutput',false)))';
% %         [tbl,rm]=simple_mixed_anova(inputmat,between_factors,{'Time'},{'Modality'});
% %         Mrm1 = multcompare(rm,'Time','By','Modality','ComparisonType','bonferroni');
% %         
%         % Bar plots
%         stimdat=wkdat(stim_idx,:);
%         shamdat=wkdat(sham_idx,:);
%         
%         subplot(2,2,2)
%         hold on
%         inputdata={stimdat;shamdat};
%         bar_err_sig(inputdata,gca,1)
%         legend({'Stim','Sham'},'Location','northwest')
%         xlabel('Trials')
% %         ylabel(['Change in Log ',bands{b},' Power normalized to baseline'])
%         ylabel(['Log ',bands{b},' Power'])
%         set(gca,'XTick',[1 2 3 4],'XTickLabel',{'Pre-stim','Intra-5','Intra-15','Post-5'})
%         xlim([0 5])
%         
%         
%         
%         %%%%%%%% Plot Contra side
%         wkdat=fig_pwr.raw.(bands{b}).contra.(dx_labels{dx});
%         
%        
%        % Organize data
%         wkdat=fig_pwr.raw.(bands{b}).contra.(dx_labels{dx});
%         for i=1:length(wkdat)
%             tempdat=wkdat{i};
%             tempdat=tempdat(subject_idx,:);
%             for z=1:size(tempdat,1)
%                 ttempdat=tempdat(z,:);
% %                 ttempdat=cellfun(@(x) (x-ttempdat{1}),ttempdat,'UniformOutput',false);
%                 ttempdat(cellfun(@isempty ,ttempdat))={nan};
%                 tempdat(z,:)=ttempdat;
%             end
%             tempdat=cellfun(@double,tempdat);
%             wkdat{i}=tempdat;
%         end
%                
%         % Mean phases
%         wkdat=cat(3,wkdat{1},wkdat{2},wkdat{3});
%         wkdat=mean(wkdat,3,'omitnan');
%         
%         % Only plot (baseline, intra5, intra15, post5)
%         wkdat=wkdat(:,[1 2 3 5]);
%         
%         subplot(2,2,3)        
%         hold on
%         for i=1:size(wkdat,1)
%             tempdat=wkdat(i,:);
%             tempxdat=1:size(wkdat,2);
%             
%             templine=plot(tempxdat,tempdat);
%             templine.LineWidth=2;
%             
%             if stimmod(i)==2
%                 templine.LineStyle='-';
%                 templine.Marker='+';
%             else
%                 templine.LineStyle=':';
%                 templine.Marker='o';
%             end
%         end
%         
%         legend(subjects_w_mod,'NumColumns',2,'Location','northwest')
%         xlabel('Trials')
% %         ylabel(['Change in Log ',bands{b},' Power normalized to baseline'])
%         ylabel(['Log ',bands{b},' Power'])
%         set(gca,'XTick',[1 2 3 4],'XTickLabel',{'Pre-stim','Intra-5','Intra-15','Post-5'})
%         title('Contra Side')
%         xlim([0 5])
%         
%         
%         % Bar plots
%         stimdat=wkdat(stim_idx,:);
%         shamdat=wkdat(sham_idx,:);
%         
%         subplot(2,2,4)
%         hold on
%         inputdata={stimdat;shamdat};
%         bar_err_sig(inputdata,gca,1)
%         legend({'Stim','Sham'},'Location','northwest')
%         xlabel('Trials')
% %         ylabel(['Change in Log ',bands{b},' Power normalized to baseline'])
%         ylabel(['Log ',bands{b},' Power'])
%         set(gca,'XTick',[1 2 3 4],'XTickLabel',{'Pre-stim','Intra-5','Intra-15','Post-5'})
%         xlim([0 5])
%         
%         
%                 
%         sgtitle(dx_labels{dx})
    end
end
%% Topo Plots

% Start EEGlab
addpath('C:\Users\allen\Box Sync\Desktop\Functions\EEG_toolboxes\Matlab\eeglab-develop');
eeglab
close all

% Plot Topoplot
bands={'alpha','beta'};
dx_labels={'stroke','pd','healthy'};
phases={'Hold','Prep','Move'};
trial_labels={'Pre-Stim','Intra-5','Intra-15','Post-0','Post-5','Post-10','Post-15'};
for b=2
    for dx=[1 3]
        % Find subject info
        subject_idx=find(strcmp(fig_pwr.dx,dx_labels{dx}));
        stimmod=fig_pwr.subjmodal(subject_idx);
        stim_idx=stimmod==2;
        sham_idx=stimmod==0;
        
        subject_nums=sbj_label(subject_idx);
        
        % Organize data
        wkdat=fig_pwr.raw.(bands{b}).topo.(dx_labels{dx});
        wkdat=cellfun(@(x) x(subject_idx,:),wkdat,'UniformOutput',false);        
        
        % Topoplot change in power compared to previous phase
        for s=1:size(wkdat{1},1)            
            f=figure('units','normalized','outerposition',[0 0 1 1]);
            temptitle=['Subject ',subject_nums{s},' - ',bands{b},' band - ',dx_labels{dx}];
            
            count=0;
            for ph=1:numel(phases)
                % Isolate first phase vs second phase
                switch ph
                    case 1 % Hold -> Cue
                        phdat1=wkdat{1}(s,:);
                        phdat2=wkdat{2}(s,:);
                        comp_label='Hold vs Cue';
                        annotation('textbox','Position',[0 0.5 0.3 0.3],'String',comp_label,'HorizontalAlignment','left','EdgeColor','none','FontSize',18)
                    case 2 % Cue-> Move
                        phdat1=wkdat{2}(s,:);
                        phdat2=wkdat{3}(s,:);
                        comp_label='Cue vs Move';
                        annotation('textbox','Position',[0 0.25 0.3 0.3],'String',comp_label,'HorizontalAlignment','left','EdgeColor','none','FontSize',18)
                    case 3 % Move -> Hold
                        phdat1=wkdat{3}(s,:);
                        phdat2=wkdat{1}(s,:);
                        comp_label='Move vs Hold';
                        annotation('textbox','Position',[0 0 0.3 0.3],'String',comp_label,'HorizontalAlignment','left','EdgeColor','none','FontSize',18)
                end
                for trl=[1 2 3 5]
                    count=count+1;
                    
                    % Calculate diff
                    try
                        diffdat=(phdat2{trl}-phdat1{trl})./phdat1{trl}*100;
                    catch
                        diffdat=nan(max([numel(phdat2{trl}) numel(phdat1{trl})]),1);
                    end
                    
                    % Topoplot
                    sp(count)=subplot(3,4,count);
                    try
                        topoplot(diffdat,'C:\Users\allen\Box Sync\Desktop\Allen_Rowland_EEG\EEGLab\topo_elec_loc.ced','electrodes','labels');
                        title(trial_labels{trl})
                    catch
                        continue
                    end
                end
            end
            
            % Add Subplot title
            sgtitle(temptitle)
            
            % Add colorbar
            set(sp,'Colormap',jet,'CLim',[-30 30])
            cb=colorbar(sp(count));
            cb.FontSize=11;
            cb.Position(1) = .95;
            cb.Position(2) = 0.15;
            cb.Position(3)= 0.01;
            cb.Position(4)= 0.75;
            
            ylabel(cb,'Change in beta power','FontSize',14)
            
            

            saveas(gcf,fullfile(figtopofolder,temptitle),'epsc')
%             saveas(gcf,fullfile(figtopofolder,temptitle),'jpeg')
            close all
        end   
    end
end

%% Power Analysis (Personalized Freq)
fig_pwr=[];
sbjfreq=[];
for subject=1:numel(sbj)
    
    % Load Files
    analysisfolder=fullfile(protocolfolder,sbj{subject},'analysis');
    eegpwrfile=fullfile(analysisfolder,'EEGlab','EEGlab_power.mat');
    
    if ~exist(eegpwrfile)
        disp([sbj{subject},' missing EEGlab freq/power analysis file'])
        continue
    end
    
    load(eegpwrfile);
    load(fullfile(analysisfolder,'S1-VR_preproc',[sbj{subject},'_S1-VRdata_preprocessed.mat']));
    
    % Find Session Info
    switch sessioninfo.stimlat
        case 'L'
            stim_cn=7;
            contra_cn=14;
        case 'R'
            stim_cn=14;
            contra_cn=7;
    end
    fig_pwr.subjmodal(subject)=sessioninfo.stimamp;
    dx=sessioninfo.dx;
    
    % Find most variable freqency
    test_dat=power.t1;
    pos_time_idx=test_dat.alltimes.phases{1}(1,:,1)>0;
    pwr_dat=test_dat.allersp.phases;

    cal_dat=std([mean(pwr_dat{1}(:,:,stim_cn),2) mean(pwr_dat{2}(:,:,stim_cn),2) mean(pwr_dat{3}(:,:,stim_cn),2)],[],2);
    
    freq_list=test_dat.allfreqs.phases{1,1}(:,:,1);
    freqs={'delta','theta','alpha','betal','betah','gammal'};
    
    % delta      1-4 Hz
    % theta      4-8 Hz
    % alpha      8-12 Hz
    % beta       13-30 Hz
    % gamma_low  30-50 Hz
    % gamma_bb   70-200 Hz
    
    delta=freq_list>=1 & freq_list<=4;
    theta=freq_list>=4 & freq_list<=8;
    alpha=freq_list>=8 & freq_list<=12;
    betal=freq_list>=12 & freq_list<=21;
    betah=freq_list>=21 & freq_list<=30;
    gammal=freq_list>=30 & freq_list<=50;
    
    [M,I]=max([sum(cal_dat(delta)) sum(cal_dat(theta)) sum(cal_dat(alpha)) sum(cal_dat(betal)) sum(cal_dat(betah)) sum(cal_dat(gammal))]);
    
    % Assign ideal freq band
    freqband=eval(freqs{I});
    sbjfreq{subject,1}=freqs{I};
    
    % Calculate Power for ideal frequency band
    trials=fieldnames(power);
    for trl=1:numel(trials)
        wk_dat=power.(trials{trl});
        trl_idx=find(strcmp(sessioninfo.trialnames{trl},sessioninfo.trialidx));
        
        for phas=1:3
            fig_pwr.raw.stim.(dx){phas}{subject,trl_idx}=mean(temppower.ersp.phases{phas}(freqband,pos_time_idx,stim_cn),'all');
            fig_pwr.raw.contra.(dx){phas}{subject,trl_idx}=mean(temppower.ersp.phases{phas}(freqband,pos_time_idx,contra_cn),'all');
        end
    end
end

dx_labels={'stroke','pd','healthy'};
for dx=1:numel(dx_labels)
    figure

    stimmod=fig_pwr.subjmodal;

    % Plot Stim side
    wkdat=fig_pwr.raw.stim.(dx_labels{dx});

    subplot(2,2,1)
    wkdat=[wkdat{:}];
    subjects_idx=~sum(~cellfun(@isempty,wkdat),2)==0;
    subjects=sbj_label(subjects_idx);
    wkdat=wkdat(subjects_idx,:);

    subjects_w_mod=[];
    for i=1:numel(subjects)
        subjects_w_mod{i}=[subjects{i} ' (' num2str(stimmod(strcmp(sbj_label,subjects{i}))) ')'];
    end

    hold on


    poweravg=[];
    shamcount=1;
    stimcount=1;
    for i=1:size(wkdat,1)
        tempdat=wkdat(i,:);

        tempydat=cellfun(@(x) x-tempdat{1},tempdat,'UniformOutput',false);
        tempydat(cellfun(@isempty ,tempdat))={nan};
        tempydat=double([tempydat{:}]);

        tempxdat=[0.75+(0:6) 1+(0:6) 1.25+(0:6)];

        tempplot=[tempydat;tempxdat];
        tempplot=sortrows(tempplot',2);

        templine=plot(tempplot(:,2),tempplot(:,1),'Marker','*');
        templine.LineWidth=2;

        count=1;
        temppwravg=[];
        for z=1:3:size(tempplot,1)
            temppwravg(count)=mean(tempplot(z:z+2,1));
            count=count+1;
        end

        if stimmod(strcmp(sbj_label,subjects{i}))==2
            templine.LineStyle='-';
            poweravg.stim(stimcount,:)=temppwravg;
            stimcount=stimcount+1;
        else
            templine.LineStyle=':';
            poweravg.sham(shamcount,:)=temppwravg;
            shamcount=shamcount+1;
        end
    end

    legend(subjects_w_mod,'NumColumns',2,'Location','northwest')
    xlabel('Trials')
    ylabel(['Change in Log Personalized Freq Power normalized to baseline'])
    set(gca,'XTick',[1 2 3 4 5 6 7],'XTickLabel',{'Pre-stim','Intra-5','Intra-15','Post-0','Post-5','Post-10','Post-15'})
    title('Stim Side')


    % Bar plot average
    subplot(2,2,2)
    hold on

    inputdata={poweravg.stim;poweravg.sham};
    bar_err_sig(inputdata,gca,1)
    legend({'Stim','Sham'},'Location','northwest')
    xlabel('Trials')
    ylabel(['Change in Log Personal Freq Power normalized to baseline'])
    set(gca,'XTick',[1 2 3 4 5 6 7],'XTickLabel',{'Pre-stim','Intra-5','Intra-15','Post-0','Post-5','Post-10','Post-15'})




    % Plot Contra side
    wkdat=fig_pwr.raw.contra.(dx_labels{dx});

    subplot(2,2,3)
    wkdat=[wkdat{:}];
    subjects_idx=~sum(~cellfun(@isempty,wkdat),2)==0;
    subjects=sbj_label(subjects_idx);
    wkdat=wkdat(subjects_idx,:);

    subjects_w_mod=[];
    for i=1:numel(subjects)
        subjects_w_mod{i}=[subjects{i} ' (' num2str(stimmod(strcmp(sbj_label,subjects{i}))) ')'];
    end

    hold on


    poweravg=[];
    shamcount=1;
    stimcount=1;
    for i=1:size(wkdat,1)
        tempdat=wkdat(i,:);

        tempydat=cellfun(@(x) x-tempdat{1},tempdat,'UniformOutput',false);
        tempydat(cellfun(@isempty ,tempdat))={nan};
        tempydat=double([tempydat{:}]);

        tempxdat=[0.75+(0:6) 1+(0:6) 1.25+(0:6)];

        tempplot=[tempydat;tempxdat];
        tempplot=sortrows(tempplot',2);

        templine=plot(tempplot(:,2),tempplot(:,1),'Marker','*');
        templine.LineWidth=2;

        count=1;
        temppwravg=[];
        for z=1:3:size(tempplot,1)
            temppwravg(count)=mean(tempplot(z:z+2,1));
            count=count+1;
        end

        if stimmod(strcmp(sbj_label,subjects{i}))==2
            templine.LineStyle='-';
            poweravg.stim(stimcount,:)=temppwravg;
            stimcount=stimcount+1;
        else
            templine.LineStyle=':';
            poweravg.sham(shamcount,:)=temppwravg;
            shamcount=shamcount+1;
        end
    end

    legend(subjects_w_mod,'NumColumns',2,'Location','northwest')
    xlabel('Trials')
    ylabel(['Change in Log Personalized Freq Power normalized to baseline'])
    set(gca,'XTick',[1 2 3 4 5 6 7],'XTickLabel',{'Pre-stim','Intra-5','Intra-15','Post-0','Post-5','Post-10','Post-15'})
    title('Contra Side')


    % Bar plot average
    subplot(2,2,4)
    hold on

    inputdata={poweravg.stim;poweravg.sham};
    bar_err_sig(inputdata,gca,1)
    legend({'Stim','Sham'},'Location','northwest')
    xlabel('Trials')
    ylabel(['Change in Log Personalized Freq Power normalized to baseline'])
    set(gca,'XTick',[1 2 3 4 5 6 7],'XTickLabel',{'Pre-stim','Intra-5','Intra-15','Post-0','Post-5','Post-10','Post-15'})


    sgtitle(dx_labels{dx})
end
