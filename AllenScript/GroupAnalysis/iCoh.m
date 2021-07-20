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

% Create Figures folder
grpanalysisfolder=fullfile(protocolfolder,'groupanalysis');
figfolder=fullfile(grpanalysisfolder,'ft_iCoh');

mkdir(figfolder)
%% Calculate iCoh (FieldTrip)
LH_elec={'Fp1','F3','F7','A1','T3','C3','T5','P3','O1'};
RH_elec={'Fp2','F4','F8','C4','T4','A2','P4','T6','O2'};
bands={'alpha','beta','gammal'};
phases={'Hold','Prep','Move'};

for subject=1:numel(sbj)
    
    % Load files
    analysisfolder=fullfile(protocolfolder,sbj{subject},'analysis');
    cohfile=fullfile(analysisfolder,'EEGlab','EEGlab_ftimagcoh.mat');
    
    if ~exist(cohfile)
        disp([sbj{subject},' missing EEGlab iCoh file'])
        continue
    end
    
    load(cohfile);
    load(fullfile(analysisfolder,'S1-VR_preproc',[sbj{subject},'_S1-VRdata_preprocessed.mat']));
        
    trials=fieldnames(eegepochs);
    for trl=1:numel(trials)
        
        wkdat=eegepochs.(trials{trl});
        
        for phas=1:size(wkdat,1)
            
            phasdat=wkdat(phas,:);

            % Save patient data
            phasdat.sessioninfo=sessioninfo;
            dx=sessioninfo.dx;

            fig_coh.subjmodal(subject)=sessioninfo.stimamp;
            fig_coh.stimside(subject,1)=sessioninfo.stimlat;
            fig_coh.dx{subject,1}=dx;

            ft_iCoh=phasdat.ft_iCoh;
            wk_conn=ft_iCoh.cohspctrm;
            labels=ft_iCoh.labelcmb;
            freq=ft_iCoh.freq;

            % Find Trial Idx
            trl_idx=find(strcmp(sessioninfo.trialnames{trl},sessioninfo.trialidx));

            % Find motor cortex idx
            lmc_idx=strcmp(labels(:,1),'C3') | strcmp(labels(:,2),'C3');
            rmc_idx=strcmp(labels(:,1),'C4') | strcmp(labels(:,2),'C4');

            % Find Hemispheric electrode idx
            lhe_idx=cellfun(@(x) any(strcmp(LH_elec,x)),labels(:,1)) | cellfun(@(x) any(strcmp(LH_elec,x)),labels(:,2));
            rhe_idx=cellfun(@(x) any(strcmp(RH_elec,x)),labels(:,1)) | cellfun(@(x) any(strcmp(RH_elec,x)),labels(:,2));


            % Find Intrahemispheric idx (Global)
            lhintra_idx=lhe_idx&~rhe_idx;
            rhintra_idx=rhe_idx&~lhe_idx;

            % Find Interhemishperic idx (Global)
            inter_idx=lhe_idx&rhe_idx;

            % Find Intrahemispheric idx (Motor)
            lhintra_mc_idx=lmc_idx&lhe_idx;
            rhintra_mc_idx=rmc_idx&rhe_idx;

            % Find Interhemishperic idx (Motor)
            lhinter_mc_idx=lmc_idx&rhe_idx;
            rhinter_mc_idx=rmc_idx&lhe_idx;

            for b=1:numel(bands)
                switch bands{b}
                    case 'alpha'
                        freqidx=freq>=8 & freq<13;
                    case 'beta'
                        freqidx=freq>=13 & freq<30;
                    case 'gammal'
                        freqidx=freq>=30 & freq<50;
                end

                % Save Connectivity for each phase
                fig_coh.mc.(dx).(bands{b}){phas}{subject,trl_idx}=mean(wk_conn(lmc_idx&rmc_idx,freqidx),'all');

                fig_coh.lhintra.(dx).(bands{b}){phas}{subject,trl_idx}=mean(wk_conn(lhintra_idx,freqidx),'all');
                fig_coh.rhintra.(dx).(bands{b}){phas}{subject,trl_idx}=mean(wk_conn(rhintra_idx,freqidx),'all');

                fig_coh.inter.(dx).(bands{b}){phas}{subject,trl_idx}=mean(wk_conn(inter_idx,freqidx),'all');

                fig_coh.lhmcintra.(dx).(bands{b}){phas}{subject,trl_idx}=mean(wk_conn(lhintra_mc_idx,freqidx),'all');
                fig_coh.rhmcintra.(dx).(bands{b}){phas}{subject,trl_idx}=mean(wk_conn(rhintra_mc_idx,freqidx),'all');

                fig_coh.lhmcinter.(dx).(bands{b}){phas}{subject,trl_idx}=mean(wk_conn(lhinter_mc_idx,freqidx),'all');
                fig_coh.rhmcinter.(dx).(bands{b}){phas}{subject,trl_idx}=mean(wk_conn(rhinter_mc_idx,freqidx),'all');

                fig_coh.freq=freq;
            end
        end
    end
end

%% Plot MC coherence

% Normalized option
norm=false;

% Make folder
mc_cohfolder=fullfile(figfolder,'mc');
mkdir(mc_cohfolder);

% Calculate
dx_labels={'stroke','pd','healthy'};
for dx=[1 3]
    for b=2
        
        % Find subject info
        subject_idx=find(strcmp(fig_coh.dx,dx_labels{dx}));
        stimmod=fig_coh.subjmodal(subject_idx);
        stim_idx=stimmod==2;
        sham_idx=stimmod==0;
        
        subjects_w_mod=[];
        for i=1:numel(subject_idx)
           subjects_w_mod{i}=[sbj_label{i} ' (' num2str(stimmod(i)) ')'];
        end
                
        % Organize data
        wkdat=fig_coh.mc.(dx_labels{dx}).(bands{b});
        
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
        
        % Calculate per phase
        figure('units','normalized','outerposition',[0 0 1 1])
        for phas=1:length(wkdat)
            phasdat=wkdat{phas};
            
            % Normalize data
            if norm
                for i=1:size(phasdat)
                    phasdat(i,:)=phasdat(i,:)-phasdat(i,1);
                end
            end
            
            % Plot only (pre,intra5,intra15,post5)
            subplot(3,1,phas)
            hold on
            
            title(phases{phas});

            modidx=[];
            for i=1:size(phasdat,1)
    %             tempdat=wkdat(i,:);
    %             tempxdat=[1:length(tempdat)];
                tempdat=phasdat(i,[1 2 3 5]);
                tempxdat=[1:length(tempdat)];

                templine=plot(tempxdat,tempdat);
                templine.LineWidth=2;

                if stimmod(i)==2
                    templine.LineStyle='-';
                    templine.Marker='+';
                    modidx=[modidx;true];
                else
                    templine.LineStyle=':';
                    templine.Marker='o';
                    modidx=[modidx;false];
                end
            end
            modidx=logical(modidx);



            legend(subjects_w_mod,'NumColumns',2,'Location','northwest')
            xlabel('Trials')
            xlim([0 5])
            
            set(gca,'XTick',tempxdat,'XTickLabel',{'Pre-stim','Intra-5','Intra-15','Post-5'})
%             set(gca,'XTick',tempxdat,'XTickLabel',{'Pre-stim','Intra-5','Intra-15','Post-0','Post-5','Post-10','Post-15'})
            
            if norm
                ylabel(['Change in ',bands{b},' Imaginary Coherence normalized to baseline'])
                ylim([-0.2 0.3])
            else
                ylabel(['Change in ',bands{b},' Imaginary Coherence'])
                ylim([0 0.5])
            end
        end
        
        if norm
            title_label=[dx_labels{dx},'-',bands{b},' Coherence between C3-C4 (normalized)'];
        else
            title_label=[dx_labels{dx},'-',bands{b},' Coherence between C3-C4'];
        end
        
        sgtitle(title_label)
        saveas(gcf,fullfile(mc_cohfolder,title_label),'jpeg')
        
        

        
        % Calculate phase diff
        figure('units','normalized','outerposition',[0 0 1 1])
        for phas=1:length(wkdat)
            switch phas
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
            
            % Normalize data
            if norm
                for i=1:size(diffdat)
                    diffdat(i,:)=diffdat(i,:)-diffdat(i,1);
                end
            end

            % Plot only (pre,intra5,intra15,post5)
            subplot(3,1,phas)
            hold on
            
            title(comp_label);

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

            legend(subjects_w_mod,'NumColumns',2,'Location','northwest')
            xlabel('Trials')
            xlim([0 5])
            
            set(gca,'XTick',tempxdat,'XTickLabel',{'Pre-stim','Intra-5','Intra-15','Post-5'})
%             set(gca,'XTick',tempxdat,'XTickLabel',{'Pre-stim','Intra-5','Intra-15','Post-0','Post-5','Post-10','Post-15'})
            
            if norm
                ylabel(['Percent Change in ',bands{b},' Imaginary Coherence normalized to baseline'])
                ylim([-200 200])
            else
                ylabel(['Percent Change in ',bands{b},' Imaginary Coherence'])
                ylim([-200 200])
            end
        end
        
        if norm
            title_label=[dx_labels{dx},'-',bands{b},' Coherence between C3-C4, Phase Difference (normalized)'];
        else
            title_label=[dx_labels{dx},'-',bands{b},' Coherence between C3-C4, Phase Difference'];
        end
        
        sgtitle(title_label)
        saveas(gcf,fullfile(mc_cohfolder,title_label),'jpeg')
    end
end

close all
%% Plot Interhemispheric coherence (global)
dx_labels={'stroke','pd','healthy'};
for dx=1:2
    for b=1:numel(bands)
        
        
        % Find modality of sbjs
        stimmod=fig_coh.subjmodal;

        
        % Organize data
        wkdat=fig_coh.inter.(dx_labels{dx}).(bands{b});
        
        subjects_idx=~sum(~cellfun(@isempty,wkdat),2)==0;
        subjects=sbj_label(subjects_idx);
        wkdat=wkdat(subjects_idx,:);
        
        for i=1:size(wkdat,1)
            tempdat=wkdat(i,:);
            tempdat=cellfun(@(x) x-tempdat{1},tempdat,'UniformOutput',false);
            tempdat(cellfun(@isempty ,tempdat))={nan};
            wkdat(i,:)=tempdat;
        end    
        wkdat=cell2mat(wkdat);
        
        % Find stimulation lat
        sl=fig_coh.stimside(subjects_idx);
        
        

        % Plot
        figure
        subplot(2,1,1)
        hold on
        
        modidx=[];
        for i=1:size(wkdat,1)
            
            tempdat=wkdat(i,:);
            tempxdat=[1:length(tempdat)];

            templine=plot(tempxdat,tempdat);
            templine.LineWidth=2;

            if stimmod(strcmp(sbj_label,subjects{i}))==2
                templine.LineStyle='-';
                templine.Marker='+';
                modidx=[modidx;true];
            else
                templine.LineStyle=':';
                templine.Marker='o';
                modidx=[modidx;false];
            end
        end
        modidx=logical(modidx);
        
        subjects_w_mod=[];
        for i=1:numel(subjects)
            subjects_w_mod{i}=[subjects{i} ' (' num2str(stimmod(strcmp(sbj_label,subjects{i}))) ')'];
        end
        
        legend(subjects_w_mod,'NumColumns',2,'Location','northwest')
        xlabel('Trials')
        ylabel(['Change in ',bands{b},' Imaginary Coherence normalized to baseline'])
        set(gca,'XTick',[1 2 3 4 5 6 7],'XTickLabel',{'Pre-stim','Intra-5','Intra-15','Post-0','Post-5','Post-10','Post-15'})

        % Bar plot average
        subplot(2,1,2)
        hold on

        inputdata={wkdat(modidx',:);wkdat(modidx',:)};
        bar_err_sig(inputdata,gca,1)
        legend({'Stim','Sham'},'Location','northwest')
        xlabel('Trials')
        ylabel(['Change in ',bands{b},' Imaginary Coherence normalized to baseline'])
        set(gca,'XTick',[1 2 3 4 5 6 7],'XTickLabel',{'Pre-stim','Intra-5','Intra-15','Post-0','Post-5','Post-10','Post-15'})
        
        sgtitle([dx_labels{dx},'-',bands{b},' Interhemispheric Coherence (Global)'])
    end
end



%% Plot Intrahemispheric coherence (global)
dx_labels={'stroke','pd','healthy'};
for dx=1:2
    for b=1:numel(bands)
        
        
        % Find info of sbjs
        subjects_idx=find(strcmp(fig_coh.dx,dx_labels{dx}));
        stimlat=fig_coh.stimside(subjects_idx);
        stimmod=fig_coh.subjmodal(subjects_idx);
        
        figure
        % Plot data
        for i=1:numel(subjects_idx)
            switch stimlat(i)
                case 'L'
                    ips='lhintra';
                    contra='rhintra';
                case 'R'
                    ips='rhintra';
                    contra='lhintra';
            end
            tempsbjidx=subjects_idx(i);
            
            % Plot Ips side
            tempipsdat=fig_coh.(ips).(dx_labels{dx}).(bands{b})(tempsbjidx,:);
            tempipsdat=cellfun(@(x) x-tempipsdat{1},tempipsdat,'UniformOutput',false);
            tempipsdat(cellfun(@isempty ,tempipsdat))={nan};
            tempipsdat=cell2mat(tempipsdat);
            
            tempxdat=[1:length(tempipsdat)];
            
            subplot(2,1,1)
            hold on
            templine=plot(tempxdat,tempipsdat);
            templine.LineWidth=2;

            if stimmod(i)==2
                templine.LineStyle='-';
                templine.Marker='+';
            else
                templine.LineStyle=':';
                templine.Marker='o';
            end
            xlabel('Trials')
            ylabel(['Change in ',bands{b},' Imaginary Coherence normalized to baseline'])
            title('Ipsilateral')
            set(gca,'XTick',[1 2 3 4 5 6 7],'XTickLabel',{'Pre-stim','Intra-5','Intra-15','Post-0','Post-5','Post-10','Post-15'})
            
            
            % Plot Contra side
            tempcontradat=fig_coh.(contra).(dx_labels{dx}).(bands{b})(tempsbjidx,:);
            tempcontradat=cellfun(@(x) x-tempcontradat{1},tempcontradat,'UniformOutput',false);
            tempcontradat(cellfun(@isempty ,tempcontradat))={nan};
            tempcontradat=cell2mat(tempcontradat);
            
            tempxdat=[1:length(tempcontradat)];
            
            subplot(2,1,2)
            hold on
            templine=plot(tempxdat,tempcontradat);
            templine.LineWidth=2;

            if stimmod(i)==2
                templine.LineStyle='-';
                templine.Marker='+';
            else
                templine.LineStyle=':';
                templine.Marker='o';
            end
            xlabel('Trials')
            ylabel(['Change in ',bands{b},' Imaginary Coherence normalized to baseline'])
            title('Contralateral')
            set(gca,'XTick',[1 2 3 4 5 6 7],'XTickLabel',{'Pre-stim','Intra-5','Intra-15','Post-0','Post-5','Post-10','Post-15'})
            
        end    
        
        % Add legend
        subjects_w_mod=[];
        for i=1:numel(subjects_idx)
            subjects_w_mod{i}=[sbj_label{subjects_idx(i)} ' (' num2str(stimmod(i)) ')'];
        end
        subplot(2,1,1)
        legend(subjects_w_mod,'NumColumns',2,'Location','northwest')
        

        % Add sgtitle
        sgtitle([dx_labels{dx},'-',bands{b},' Intrahemispheric Coherence (Global)'])
    end
end

%% Plot Intrahemispheric coherence (MC)
dx_labels={'stroke','pd','healthy'};
for dx=1:2
    for b=1:numel(bands)
        
        
        % Find info of sbjs
        subjects_idx=find(strcmp(fig_coh.dx,dx_labels{dx}));
        stimlat=fig_coh.stimside(subjects_idx);
        stimmod=fig_coh.subjmodal(subjects_idx);
        
        figure
        % Plot data
        for i=1:numel(subjects_idx)
            switch stimlat(i)
                case 'L'
                    ips='lhmcintra';
                    contra='rhmcintra';
                case 'R'
                    ips='rhmcintra';
                    contra='lhmcintra';
            end
            tempsbjidx=subjects_idx(i);
            
            % Plot Ips side
            tempipsdat=fig_coh.(ips).(dx_labels{dx}).(bands{b})(tempsbjidx,:);
            tempipsdat=cellfun(@(x) x-tempipsdat{1},tempipsdat,'UniformOutput',false);
            tempipsdat(cellfun(@isempty ,tempipsdat))={nan};
            tempipsdat=cell2mat(tempipsdat);
            
            tempxdat=[1:length(tempipsdat)];
            
            subplot(2,1,1)
            hold on
            templine=plot(tempxdat,tempipsdat);
            templine.LineWidth=2;

            if stimmod(i)==2
                templine.LineStyle='-';
                templine.Marker='+';
            else
                templine.LineStyle=':';
                templine.Marker='o';
            end
            xlabel('Trials')
            ylabel(['Change in ',bands{b},' Imaginary Coherence normalized to baseline'])
            title('Ipsilateral')
            set(gca,'XTick',[1 2 3 4 5 6 7],'XTickLabel',{'Pre-stim','Intra-5','Intra-15','Post-0','Post-5','Post-10','Post-15'})
            
            
            % Plot Contra side
            tempcontradat=fig_coh.(contra).(dx_labels{dx}).(bands{b})(tempsbjidx,:);
            tempcontradat=cellfun(@(x) x-tempcontradat{1},tempcontradat,'UniformOutput',false);
            tempcontradat(cellfun(@isempty ,tempcontradat))={nan};
            tempcontradat=cell2mat(tempcontradat);
            
            tempxdat=[1:length(tempcontradat)];
            
            subplot(2,1,2)
            hold on
            templine=plot(tempxdat,tempcontradat);
            templine.LineWidth=2;

            if stimmod(i)==2
                templine.LineStyle='-';
                templine.Marker='+';
            else
                templine.LineStyle=':';
                templine.Marker='o';
            end
            xlabel('Trials')
            ylabel(['Change in ',bands{b},' Imaginary Coherence normalized to baseline'])
            title('Contralateral')
            set(gca,'XTick',[1 2 3 4 5 6 7],'XTickLabel',{'Pre-stim','Intra-5','Intra-15','Post-0','Post-5','Post-10','Post-15'})
            
        end    
        
        % Add legend
        subjects_w_mod=[];
        for i=1:numel(subjects_idx)
            subjects_w_mod{i}=[sbj_label{subjects_idx(i)} ' (' num2str(stimmod(i)) ')'];
        end
        subplot(2,1,1)
        legend(subjects_w_mod,'NumColumns',2,'Location','northwest')
        

        % Add sgtitle
        sgtitle([dx_labels{dx},'-',bands{b},' Intrahemispheric Coherence (MC)'])
    end
end

%% Plot Interhemispheric coherence (MC)
dx_labels={'stroke','pd','healthy'};
for dx=1:numel(dx_labels)
    for b=1:numel(bands)
        
        
        % Find info of sbjs
        subjects_idx=find(strcmp(fig_coh.dx,dx_labels{dx}));
        stimlat=fig_coh.stimside(subjects_idx);
        stimmod=fig_coh.subjmodal(subjects_idx);
        
        figure
        % Plot data
        for i=1:numel(subjects_idx)
            switch stimlat(i)
                case 'L'
                    ips='lhmcinter';
                    contra='rhmcinter';
                case 'R'
                    ips='lhmcinter';
                    contra='rhmcinter';
            end
            tempsbjidx=subjects_idx(i);
            
            % Plot Ips side
            tempipsdat=fig_coh.(ips).(dx_labels{dx}).(bands{b})(tempsbjidx,:);
            tempipsdat=cellfun(@(x) x-tempipsdat{1},tempipsdat,'UniformOutput',false);
            tempipsdat(cellfun(@isempty ,tempipsdat))={nan};
            tempipsdat=cell2mat(tempipsdat);
            
            tempxdat=[1:length(tempipsdat)];
            
            subplot(2,1,1)
            hold on
            templine=plot(tempxdat,tempipsdat);
            templine.LineWidth=2;

            if stimmod(i)==2
                templine.LineStyle='-';
                templine.Marker='+';
            else
                templine.LineStyle=':';
                templine.Marker='o';
            end
            xlabel('Trials')
            ylabel(['Change in ',bands{b},' Imaginary Coherence normalized to baseline'])
            title('Ipsilateral')
            set(gca,'XTick',[1 2 3 4 5 6 7],'XTickLabel',{'Pre-stim','Intra-5','Intra-15','Post-0','Post-5','Post-10','Post-15'})
            
            
            % Plot Contra side
            tempcontradat=fig_coh.(contra).(dx_labels{dx}).(bands{b})(tempsbjidx,:);
            tempcontradat=cellfun(@(x) x-tempcontradat{1},tempcontradat,'UniformOutput',false);
            tempcontradat(cellfun(@isempty ,tempcontradat))={nan};
            tempcontradat=cell2mat(tempcontradat);
            
            tempxdat=[1:length(tempcontradat)];
            
            subplot(2,1,2)
            hold on
            templine=plot(tempxdat,tempcontradat);
            templine.LineWidth=2;

            if stimmod(i)==2
                templine.LineStyle='-';
                templine.Marker='+';
            else
                templine.LineStyle=':';
                templine.Marker='o';
            end
            xlabel('Trials')
            ylabel(['Change in ',bands{b},' Imaginary Coherence normalized to baseline'])
            title('Contralateral')
            set(gca,'XTick',[1 2 3 4 5 6 7],'XTickLabel',{'Pre-stim','Intra-5','Intra-15','Post-0','Post-5','Post-10','Post-15'})
            
        end    
        
        % Add legend
        subjects_w_mod=[];
        for i=1:numel(subjects_idx)
            subjects_w_mod{i}=[sbj_label{subjects_idx(i)} ' (' num2str(stimmod(i)) ')'];
        end
        subplot(2,1,1)
        legend(subjects_w_mod,'NumColumns',2,'Location','northwest')
        

        % Add sgtitle
        sgtitle([dx_labels{dx},'-',bands{b},' Interhemispheric Coherence (MC)'])
    end
end