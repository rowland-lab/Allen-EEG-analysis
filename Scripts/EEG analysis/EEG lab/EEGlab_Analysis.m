clc
close all
clear all

% Enter in protocol folder
protocolfolder='C:\Users\allen\Box Sync\Desktop\Allen_Rowland_EEG\protocol_00087153';

% Detect subjects
sbj=dir(fullfile(protocolfolder,'pro000*.'));
sbj={sbj.name}';

% Gitpath
gitpath='C:\Users\allen\Documents\GitHub\Allen-EEG-analysis';
cd(gitpath)
allengit_genpaths(gitpath,'EEG')

%% Import data

calc_icoh=true;
calc_kin=true;
calc_labpower=false;

subjectData=[];
parfor s=1:numel(sbj)
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


%% Analysis

TOI={'pre-stim (baseline)','intrastim (5 min)','intrastim (15 min)','post-stim (5 min)'};
FOI_label={'Alpha','Beta'};
FOI_freq={{8,12},{13,30}};
phases={'Hold','Prep','Reach'};
DOI={'stroke','healthy'};
stimtypes=[0,2];
stimname={'Sham','Stim'};
analysisFolder='C:\Users\allen\Box Sync\Desktop\Allen_Rowland_EEG\protocol_00087153\Analysis';

% columnscatter(subjectData,datlabel,TOI,FOI_label,FOI_freq,phases,DOI,stimtypes,stimname,savefolder)
iCohFolder=fullfile(analysisFolder,'iCoh');
mkdir(iCohFolder);
exportData=columnscatter(subjectData,'iCoh',TOI,FOI_label,FOI_freq,phases,DOI,stimtypes,stimname,iCohFolder);

%%
% linreg(subjectData,datlabel,TOI,FOI_label,FOI_freq,phases,DOI,stimtypes,stimname,savefolder)
linReg_folder=fullfile(analysisFolder,'linReg');
mkdir(linReg_folder);
linreg_dat=linreg(subjectData,{'iCoh','avgAcceleration'},TOI,FOI_label,FOI_freq,phases,DOI,stimtypes,stimname,linReg_folder);


%% iCoh Bar 
TOI={'pre-stim (baseline)','intrastim (5 min)','intrastim (15 min)','post-stim (5 min)'};
FOI_label={'Alpha','Beta'};
FOI_freq={{8,12},{13,30}};
phases={'Hold','Prep','Reach'};
DOI={'stroke','healthy'};
stimtypes=[0,2];
stimname={'Sham','Stim'};
analysisFolder='C:\Users\allen\Box Sync\Desktop\Allen_Rowland_EEG\protocol_00087153\Analysis';

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
end

%% Coherence matrix

TOI={'pre-stim (baseline)','intrastim (5 min)','intrastim (15 min)','post-stim (5 min)'};
phases={'Hold','Prep','Reach'};
DOI={'stroke','healthy'};
stimtypes=[0,2];
stimname={'Sham','Stim'};
electrodes={'A1','Fp1','F7','T3','T5','O1','F3','C3','P3','Fz','Cz','Pz','A2','Fp2','F8','T4','T6','O2','F4','C4','P4'};
norm=false;
FOI_label={'Alpha','Beta'};
FOI_freq={{8,12},{13,30}};
savefigures=true;
outpath='C:\Users\allen\Desktop\RowlandFigs_11_22_21\Coh';

for f=1:numel(FOI_freq)
    for d=1:numel(DOI)
        figure('WindowState','Maximized');
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
                    
                    % Organize disease
                    tempdisease{s,1}=subjectData(s).sessioninfo.dx;
                    
                    % Organize stim
                    tempstim(s,1)=subjectData(s).sessioninfo.stimamp;
                end
                
                for s=1:numel(stimtypes)
                    h(ax_count)=subplot(numel(TOI),numel(phases)*numel(stimtypes),p+((s-1)*numel(phases))+((t-1)*numel(phases)*numel(stimtypes)));
                    ax_count=ax_count+1;
                    idx=tempstim==stimtypes(s)&strcmp(tempdisease,DOI{d});
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
            figtitle=sprintf('%s Coherence - %s Normalized',FOI_label{f},DOI{d});
        else
            ylabel(cbh,['Coherence ',FOI_label{f}],'FontSize',12)
            figtitle=sprintf('%s Coherence - %s',FOI_label{f},DOI{d});
        end
        
        % Title
        sgtitle(DOI{d})
        
        % Save figure
        if savefigures
            savefig(gcf,fullfile(outpath,figtitle));
        end
        
        close all
    end
end

%% Coherence diff


TOI={'pre-stim (baseline)','intrastim (5 min)','intrastim (15 min)','post-stim (5 min)'};
phases={'Hold','Prep','Reach'};
DOI={'stroke','healthy'};
stimtypes=[0,2];
stimname={'Sham','Stim'};
electrodes={'F7','T3','T5','O1','F3','C3','P3','A1','Fz','Cz','Fp2','F8','T4','T6','O2','F4','C4','P4','A2','Pz','Fp1'};
FOI_label={'Alpha','Beta'};
FOI_freq={{8,12},{13,30}};
savefigures=true;
outpath='C:\Users\allen\Desktop\RowlandFigs_11_22_21\Coh';

for f=1:numel(FOI_freq)
    for d=1:numel(DOI)
        figure('WindowState','maximized')
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
            savefig(gcf,fullfile(outpath,figtitle));
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
cd(outpath)

%% iCoh C3-C4 phase diff


TOI={'pre-stim (baseline)','intrastim (5 min)','intrastim (15 min)','post-stim (5 min)'};
phases={'Hold','Prep','Reach'};
DOI={'stroke','healthy'};
stimtypes=[0,2];
stimname={'Sham','Stim'};
electrodes={'F7','T3','T5','O1','F3','C3','P3','A1','Fz','Cz','Fp2','F8','T4','T6','O2','F4','C4','P4','A2','Pz','Fp1'};
FOI_label={'Alpha','Beta','Gamma-L','Gamma-B'};
FOI_freq={{8,12},{13,30},{30,70},{70,120}};
savefigures=false;
outpath='C:\Users\allen\Desktop\RowlandFigs_11_22_21\Coh';
exportdata=true;

eData=[];
for f=1:numel(FOI_freq)
    for d=1:numel(DOI)
        figure('WindowState','maximized')
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
                [pass,pval]=ttest(plotdat(:),[ones(sum(idx),1);ones(sum(idx),1)*2]);
                
                if exportdata
                    eData.(FOI_label{f}).(DOI{d}).([phases{p},phases{p+1}]){t}=plotdat;
                end
            end
        end
        
        % link axis
        linkaxes(h)
        
        % Title
        sgtitle(DOI{d})
        
        % Save figure
        if savefigures
            savefig(gcf,fullfile(outpath,figtitle));
        end
    end
end
cd(outpath)
%% Functions

function exportData=columnscatter(subjectData,datlabel,TOI,FOI_label,FOI_freq,phases,DOI,stimtypes,stimname,savefolder)

count_ax=1;
ax=[];
for f=1:numel(FOI_freq)
    figname=[datlabel,' Column Scatter plot - ',FOI_label{f}];
    figure('Name',figname,'WindowState','Maximized')
    for t=1:numel(TOI)
        for p=1:numel(phases)
            ax(count_ax)=subplot(numel(TOI),numel(phases),p+(t-1)*numel(phases));
            count_ax=count_ax+1;
            hold on
            
            tempdat=[];
            tempdisease=[];
            tempstim=[];
            tempacc=[];
            for s=1:size(subjectData,2)
                
                if strcmp(datlabel,'iCoh')
                    % Calculate coherence
                    sbjicoh=subjectData(s).(datlabel);
                    label_idx=all(strcmp(sbjicoh.label,'C3')+strcmp(sbjicoh.label,'C4'),2);
                    FOI_idx=sbjicoh.freq>=FOI_freq{f}{1} & sbjicoh.freq<=FOI_freq{f}{2};
                    TOI_idx=strcmp(subjectData(s).sessioninfo.trialnames,TOI{t});
                    tempdat(s,1)=mean(mean(sbjicoh.data(label_idx,FOI_idx,:,p,TOI_idx),2,'omitnan'),3,'omitnan');
                end
                
                
                % Organize disease
                tempdisease{s,1}=subjectData(s).sessioninfo.dx;
                
                % Organize stim
                tempstim(s,1)=subjectData(s).sessioninfo.stimamp;
            end
            
            clear l r pval
            count=1;
            axislabel=[];
            kwdat=nan(10,numel(DOI)*numel(stimtypes));
            sbj_name=cell(10,numel(DOI)*numel(stimtypes));
            sbjcount=1;
            for d=1:numel(DOI)
                for s=1:numel(stimtypes)
                    idx=strcmp(tempdisease,DOI{d})&tempstim==stimtypes(s);
                    
                    % organize data
                    hold on
                    ydat=tempdat(idx);
                    sbjs=extractAfter({subjectData(idx).SubjectName},'pro00087153_00');
                    sbj_name(1:numel(sbjs),sbjcount)=sbjs;
                    sbjcount=sbjcount+1;
                    
                    % Column Scatter plot
                    xshift=-.2;
                    for i=1:numel(sbjs)
                        xshift=xshift+0.05;
                        text((s+(d-1)*numel(stimtypes))+xshift,ydat(i),sbjs{i});
                    end
                    line([(s+(d-1)*numel(stimtypes))-0.1 (s+(d-1)*numel(stimtypes))+0.1],[mean(ydat) mean(ydat)],'LineWidth',2)
                    errorbar(s+(d-1)*numel(stimtypes),mean(ydat),std(ydat)/sqrt(numel(ydat)),'LineStyle','none','Color','k')
                    
                    % Group axis labels
                    axislabel=[axislabel {sprintf('%s - %s',DOI{d},stimname{s})}];
                    
                    % Group data for KW test
                    kwdat(1:numel(ydat),s+(d-1)*numel(stimtypes))=ydat;
                end
            end
            xticks([1:4])
            xticklabels(axislabel)
            ylim([0 1])
            ylabel([FOI_label{f},' iCoh'])
            
            title([TOI{t},'--',phases{p}]);
            
            % KW test
            kwdat(all(isnan(kwdat),2),:)=[];
            [pval,~,stat]=kruskalwallis(kwdat,[],'off');
            if pval<=0.05
                c = multcompare(stat,'Display','off');
                sigIdx=find(c(:,6)<=0.05& c(:,6)>0);
                maxy=max(kwdat,[],'all');
                for si=1:numel(sigIdx)
                    maxy=maxy+0.05;
                    line([c(sigIdx(si),1) c(sigIdx(si),2)],[maxy maxy])
                    text(mean([c(sigIdx(si),1) c(sigIdx(si),2)]),maxy,num2str(c(sigIdx(si),6)),'HorizontalAlignment','center')
                end
            end
            
            % Export data
            exportData.(FOI_label{f}).(phases{p}).data{t,1}=kwdat;
            exportData.(FOI_label{f}).(phases{p}).columnLabel=axislabel;
            exportData.(FOI_label{f}).(phases{p}).SubjectNames=sbj_name(any(~cellfun(@isempty,(sbj_name)),2),:);
        end
    end
    linkaxes(ax)
    sgtitle(FOI_label{f})
    savefig(gcf,fullfile(savefolder,figname))
end
end


function export=linreg(subjectData,cmpdata,TOI,FOI_label,FOI_freq,phases,DOI,stimtypes,stimname,savefolder)
kinlabel={'movementDuration','reactionTime','handpathlength','avgVelocity','maxVelocity','velocityPeaks','timeToMaxVelocity','timeToMaxVelocity_n','avgAcceleration','maxAcceleration','accuracy','normalizedJerk','IOC'};

colors={'g','b','c','m'};


ax=[];
for f=1:numel(FOI_freq)
    figure('WindowState','Maximized')
    count_ax=1;
    for t=1:numel(TOI)
        for p=1:numel(phases)
            ax(count_ax)=subplot(numel(TOI),numel(phases),p+(t-1)*numel(phases));
            count_ax=count_ax+1;
            hold on
            
            tempdat=[];
            tempdisease=[];
            tempstim=[];
            for s=1:size(subjectData,2)
                
                for d=1:numel(cmpdata)
                    if any(strcmp(cmpdata{d},'iCoh'))
                        tempcmp=cmpdata{d};
                        
                        % Calculate coherence
                        sbjicoh=subjectData(s).(tempcmp);
                        label_idx=all(strcmp(sbjicoh.label,'C3')+strcmp(sbjicoh.label,'C4'),2);
                        FOI_idx=sbjicoh.freq>=FOI_freq{f}{1} & sbjicoh.freq<=FOI_freq{f}{2};
                        TOI_idx=strcmp(subjectData(s).sessioninfo.trialnames,TOI{t});
                        tempdat(s,1)=mean(mean(sbjicoh.data(label_idx,FOI_idx,:,p,TOI_idx),2,'omitnan'),3,'omitnan');
                        axislabel{d}=[FOI_label{f},' - iCoh'];
                    elseif any(strcmp(cmpdata{d},kinlabel))
                        tempcmp=cmpdata{d};
                        
                        % Calculate kinematics
                        templabel=strcmp(subjectData(s).kinematics.label,tempcmp);
                        tempdat(s,2)=mean(subjectData(s).kinematics.data{templabel}(:,TOI_idx),'omitnan');
                        axislabel{d}=tempcmp;
                    end
                end
                
                % Organize disease
                tempdisease{s,1}=subjectData(s).sessioninfo.dx;
                
                % Organize stim
                tempstim(s,1)=subjectData(s).sessioninfo.stimamp;
            end
            
            clear l r pval
            count=1;
            legendlabels=[];
            countcolor=1;
            for d=1:numel(DOI)
                for s=1:numel(stimtypes)
                    idx=strcmp(tempdisease,DOI{d})&tempstim==stimtypes(s);
                    sbjs=extractAfter({subjectData(idx).SubjectName},'pro00087153_00');
                    
                    % organize data
                    hold on
                    xdat=tempdat(idx,1);
                    ydat=tempdat(idx,2);
                    
                    export.(FOI_label{f}).(phases{p}).(DOI{d}){t,s}=[xdat;ydat];
                    
                    
                    
                    
                    % Scatter plot
                    for i=1:numel(xdat)
                        txt=text(xdat(i),ydat(i),sbjs{i});
                        if stimtypes(s)==0
                            txt.Color=colors{countcolor};
                            linestyle='--';
                        else
                            txt.Color=colors{countcolor};
                            linestyle='-';
                        end
                    end
                    countcolor=countcolor+1;
                    
                    % Plot trendline
                    pv = polyfit(xdat, ydat, 1);
                    px = [min(xdat) max(xdat)];
                    py = polyval(pv, px);
                    l(count)=plot(px, py, 'LineWidth', 2,'Color',txt.Color,'LineStyle',linestyle);
                    
                    
                    % Calculate p and r
                    [r,pval]=corrcoef(xdat, ydat);
                    
                    % Save p and r value
                    rval=r(2,1);
                    pval=pval(2,1);
                    
                    % Change line if pval <=0.5
                    if pval<=0.05
                        if stimtypes(s)==0
                            l(count).Color=[0.8500 0.3250 0.0980];
                        else
                            l(count).Color=[0.6350 0.0780 0.1840];
                        end
                    end
                    
                    % Organize legend label
                    legendlabels{count}=sprintf('%s %s [p(%g),r(%g)]',DOI{d},stimname{s},pval,rval);
                    count=count+1;
                end
            end
            legend(l,legendlabels,'Location','best')
            ylabel(axislabel{2})
            xlabel(axislabel{1})
            title([TOI{t},'--',phases{p}]);
        end
    end
    linkaxes(ax)
    savefig(gcf,fullfile(savefolder,[axislabel{1},' vs ',axislabel{2}]))
end
end


function mixANOVA(input,b)

% Run Mixed Anova for contra
[stat,rm]=simple_mixed_anova(vertcat(input{:}),vertcat(ones(size(input{1},1),1)*0,ones(size(input{2},1),1)*2),{'Trial'},{'Stim'});

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
