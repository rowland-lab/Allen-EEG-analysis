%function [subjectData,icoh_data_anal,export,a1,a3]=step_05a_nr_ac_icoh_subjectData(datestr,datafolder,gitpath,calc_icoh,calc_kin,calc_labpower,savefile)



% for debugging
datestr='2022_07_16'
datafolder='/home/rowlandn/nr_data_analysis/data_analyzed/eeg/gen_03/data';
gitpath='/home/rowlandn/nr_data_analysis/data_scripts/ac/Allen-EEG-analysis';
calc_icoh=true;
calc_kin=true;
calc_labpower=true;

% Detect subjects
sbj=dir(fullfile(datafolder,'pro000*'));
sbj={sbj.name}';

% % Load Gitpath
cd(gitpath)
allengit_genpaths(gitpath,'EEG')

% Define parameters
TOI={'pre-stim (baseline)','intrastim (5 min)','intrastim (15 min)','post-stim (5 min)'};
FOI_label={'Alpha','Beta','Gamma'};%can add more if you want
FOI_freq={{8,12},{13,30},{30,50}};
phases={'Hold','Prep','Reach'};
DOI={'stroke','healthy'};
stimtypes=[0,2];
stimname={'Sham','Stim'};

subjectData=[];
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
% I am switching from calculating the date to manually inputting it so it
% can be consistent across functions
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
subjectDatafilenm=['subjectData_',datestr]
eval([subjectDatafilenm,'=subjectData'])
cd(['~/nr_data_analysis/data_analyzed/eeg/gen_03/analysis_icoh/',datestr])

% if strcmp(savefile,'true')
%     save([subjectDatafilenm,'.mat'],subjectDatafilenm)
% elseif strcmp(savefile,'false')
% end

%% Column Scatter

icoh_data_anal.col_scatter=nr_ac_columnscatter_v01(datestr,subjectData,'iCoh',TOI,FOI_label,FOI_freq,phases,DOI,stimtypes,stimname,datafolder);
icoh_data_analfilenm=['icoh_data_anal_',datestr]
eval([icoh_data_analfilenm,'=icoh_data_anal'])
cd(['~/nr_data_analysis/data_analyzed/eeg/gen_03/analysis_icoh/',datestr])
save([icoh_data_analfilenm,'.mat'],icoh_data_analfilenm)

% I don't see why this couldn't be copied from above here and just save
% both at the same time
% if strcmp(savefile,'true')
%     save([subjectDatafilenm,'.mat'],subjectDatafilenm)
% elseif strcmp(savefile,'false')
% end

%% iCoh Bar 

%these are allen's bars - see below for mine
%the problems as always is that you have no output of the bar data and you
%don't know what is significant relative to what
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
    assignin('base','b',b)
    sgtitle(FOI_label{f})
    %figname=['iCoh Bar ',FOI_label{f}];
    figname=['ac_icoh_bar_',FOI_label{f}];
    savefig(gcf,figname)
    %close
end

% figname=['icoh_bar_',FOI_label{f},'_',datestr];
% sgtitle(FOI_label{f})
%     cd(['~/nr_data_analysis/data_analyzed/eeg/gen_03/analysis_icoh/',datestr])
%     %savefig(gcf,fullfile(savefolder,figname))
%     savefig(gcf,figname)
%     close

% here's mine - we will reformat and save the barplot data
for f=1:numel(FOI_label)
    for d=1:numel(DOI)
        for p=1:numel(phases)
            for t=1:numel(TOI)
                if d==1
                    eval(['icoh_data_anal.bar.',FOI_label{f},'.',DOI{d},'.',phases{p},...
                        '{1,1}(:,',num2str(t),')=icoh_data_anal.col_scatter.',FOI_label{f},...
                        '.',phases{p},'.data{',num2str(t),',1}(~isnan(icoh_data_anal.col_scatter.',FOI_label{f},...
                        '.',phases{p},'.data{',num2str(t),',1}(:,1)),1)'])
                    eval(['icoh_data_anal.bar.',FOI_label{f},'.',DOI{d},'.',phases{p},...
                        '{1,2}(:,',num2str(t),')=icoh_data_anal.col_scatter.',FOI_label{f},...
                        '.',phases{p},'.data{',num2str(t),',1}(~isnan(icoh_data_anal.col_scatter.',FOI_label{f},...
                        '.',phases{p},'.data{',num2str(t),',1}(:,2)),2)'])
                elseif d==2
                    eval(['icoh_data_anal.bar.',FOI_label{f},'.',DOI{d},'.',phases{p},...
                        '{1,1}(:,',num2str(t),')=icoh_data_anal.col_scatter.',FOI_label{f},...
                        '.',phases{p},'.data{',num2str(t),',1}(~isnan(icoh_data_anal.col_scatter.',FOI_label{f},...
                        '.',phases{p},'.data{',num2str(t),',1}(:,3)),3)'])
                    eval(['icoh_data_anal.bar.',FOI_label{f},'.',DOI{d},'.',phases{p},...
                        '{1,2}(:,',num2str(t),')=icoh_data_anal.col_scatter.',FOI_label{f},...
                        '.',phases{p},'.data{',num2str(t),',1}(~isnan(icoh_data_anal.col_scatter.',FOI_label{f},...
                        '.',phases{p},'.data{',num2str(t),',1}(:,4)),4)'])
                end
            end
        end
    end
end

%plot + stats
sp_vec=[1 3 5 2 4 6]
for f=1:numel(FOI_label)
    count=0
    figure
    for d=1:numel(DOI)
        for p=1:numel(phases)
            count=count+1
            set(gcf,'Position',[2346 633 583 437])
            subplot(3,2,sp_vec(count)); hold on
            eval(['b(1)=bar([0.8,1.8,2.8,3.8],mean(icoh_data_anal.bar.',FOI_label{f},'.',DOI{d},'.',phases{p},'{1,1}),0.2)'])
            eval(['errorbar([0.8,1.8,2.8,3.8],mean(icoh_data_anal.bar.',FOI_label{f},'.',DOI{d},'.',phases{p},'{1,1}),',...
                'std(icoh_data_anal.bar.',FOI_label{f},'.',DOI{d},'.',phases{p},'{1,1})/sqrt(size(icoh_data_anal.bar.',FOI_label{f},'.',DOI{d},'.',phases{p},'{1,1},1)),''.k'')'])

            eval(['b(2)=bar([1.2 2.2 3.2 4.2],mean(icoh_data_anal.bar.',FOI_label{f},'.',DOI{d},'.',phases{p},'{1,2}),0.2)'])
            eval(['errorbar([1.2 2.2 3.2 4.2],mean(icoh_data_anal.bar.',FOI_label{f},'.',DOI{d},'.',phases{p},'{1,2}),',...
                'std(icoh_data_anal.bar.',FOI_label{f},'.',DOI{d},'.Hold{1,2})/sqrt(size(icoh_data_anal.bar.',FOI_label{f},'.',DOI{d},'.',phases{p},'{1,2},1)),''.k'')'])
            ylabel('Beta iCoh')
            title([DOI{d},' - ',phases{p}])
            set(gca,'ylim',[0 1],'XTick',[1 2 3 4],'XTickLabel',['pre';'i5 ';'i15';'pos'])
            sgtitle(FOI_label{f})
            eval(['anovaInputa{1,1}=icoh_data_anal.bar.',FOI_label{f},'.',DOI{d},'.',phases{p},'{1,1}'])
            eval(['anovaInputa{1,2}=icoh_data_anal.bar.',FOI_label{f},'.',DOI{d},'.',phases{p},'{1,2}'])
            eval(['stats_mix_tbl_',FOI_label{f},'_',DOI{d},'_',phases{p},'=mixANOVA(anovaInputa,b)'])
        end
    end
    figname=['nr_icoh_bar_',FOI_label{f}];
    %savefig(gcf,figname)%%%%%Have to add date here!!!
end
 
%% Linear regressions
kinlabel={'movementDuration','reactionTime','handpathlength','avgVelocity','maxVelocity','velocityPeaks','timeToMaxVelocity','timeToMaxVelocity_n','avgAcceleration','maxAcceleration','accuracy','normalizedJerk','IOC'};
for i=1:numel(kinlabel)
    eval(['icoh_data_anal.linreg.',kinlabel{i},'=nr_ac_linreg_v01(''2022_07_16'',subjectData,{''iCoh'',kinlabel{i}},TOI,FOI_label,FOI_freq,phases,DOI,stimtypes,stimname,datafolder)'])
end

%% icoh matrix
%TOI={'pre-stim (baseline)','intrastim (5 min)','intrastim (15 min)','post-stim (5 min)'};
TOI={'pre','i05','i15','pos'};
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
% analysisfolder='/home/rowlandn/nr_data_analysis/data_analyzed/eeg/gen_03/Analysis';
% iCohMatrixFolder=fullfile(analysisfolder,'iCohMatrix');
% mkdir(iCohMatrixFolder);
% outpath=iCohMatrixFolder


for f=1:numel(FOI_freq)
    for d=1:numel(DOI)
        figure; set(gcf,'Position',[469 686 593 430])
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
                    eval(['icoh_data_anal.mat.all.',FOI_label{f},'.',DOI{d},'.',phases{p},'.',stimname{s},'.',TOI{t},'=matcoh(:,:,idx);'])
                    %keep this is icoh_data_anal above is too large to save
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
        ylabel(cbh,['Coherence ',FOI_label{f}],'FontSize',12)
        %%%%%%I wonder if for the normalized ones you have to open the
        %%%%%%scale to 0 to 1??? No tried it, it didn't work
        
        %I will move this to the main figure label
%         if norm
%             ylabel(cbh,['Normalized ',FOI_label{f},' Coherence'],'FontSize',12)
%             figtitle=sprintf('%s Coherence Matrix - %s Normalized',FOI_label{f},DOI{d});
%         else
%             ylabel(cbh,['Coherence ',FOI_label{f}],'FontSize',12)
%             figtitle=sprintf('%s Coherence Matrix - %s',FOI_label{f},DOI{d});
%         end
        
        % Title
        if norm
            sgtitle([DOI{d},' - ',FOI_label{f},' - all subjects (norm)'])
            figname=['nr_icoh_mat.all_',FOI_label{f},'_',DOI{d},'_norm_',datestr];
        else
            sgtitle([DOI{d},' - ',FOI_label{f},' - all subjects (%)'])
            figname=['nr_icoh_mat_sbj_all_elec_all_',FOI_label{f},'_',DOI{d},'_nonnorm_',datestr];
        end
        
        
%         % Save figure
        %if savefigures
            cd(['~/nr_data_analysis/data_analyzed/eeg/gen_03/analysis_icoh/',datestr])
            %savefig(gcf,figname)
           %saveas(gcf,fullfile(iCohMatrixFolder,[figtitle,'.jpeg']))
        %end
        
        %close all
    end
end

%% Individual icoh matrices

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
for f=1:numel(FOI_label)
for sbj=1:numel(sbj_name)
    if isempty(sbj_name{sbj})
    else
        figure; set(gcf,'Position',[137 602 1128 608])

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
                eval(['imagescDat=data_grp_icohmat_',FOI_label{f},'_',distype,'_prestim_Hold_',stimtype,'(:,:,sbj_r);']);
                eval(['imagescDat_p1_t1=data_grp_icohmat_',FOI_label{f},'_',distype,'_prestim_Hold_',stimtype,'(20,8,sbj_r);']);
                %imagescDat=data_grp_icohmat_',FOI_label{f},'_stroke_prestim_Hold_Stim(:,:,sbj);
            elseif t==2
                eval(['imagescDat=data_grp_icohmat_',FOI_label{f},'_',distype,'_intra5_Hold_',stimtype,'(:,:,sbj_r);']);
                eval(['imagescDat_p1_t2=data_grp_icohmat_',FOI_label{f},'_',distype,'_intra5_Hold_',stimtype,'(20,8,sbj_r);']);
                %imagescDat=data_grp_icohmat_',FOI_label{f},'_stroke_intra5_Hold_Stim(:,:,sbj);
            elseif t==3
                eval(['imagescDat=data_grp_icohmat_',FOI_label{f},'_',distype,'_intra15_Hold_',stimtype,'(:,:,sbj_r);']);
                eval(['imagescDat_p1_t3=data_grp_icohmat_',FOI_label{f},'_',distype,'_intra15_Hold_',stimtype,'(20,8,sbj_r);']);
                %imagescDat=data_grp_icohmat_',FOI_label{f},'_stroke_intra15_Hold_Stim(:,:,sbj);
            elseif t==4
                eval(['imagescDat=data_grp_icohmat_',FOI_label{f},'_',distype,'_poststim5_Hold_',stimtype,'(:,:,sbj_r);']);
                eval(['imagescDat_p1_t4=data_grp_icohmat_',FOI_label{f},'_',distype,'_poststim5_Hold_',stimtype,'(20,8,sbj_r);']);
                %imagescDat=data_grp_icohmat_',FOI_label{f},'_stroke_poststim5_Hold_Stim(:,:,sbj);
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
                eval(['imagescDat=data_grp_icohmat_',FOI_label{f},'_',distype,'_prestim_Prep_',stimtype,'(:,:,sbj_r);']);
                eval(['imagescDat_p2_t1=data_grp_icohmat_',FOI_label{f},'_',distype,'_prestim_Prep_',stimtype,'(20,8,sbj_r);']);
                %imagescDat=data_grp_icohmat_',FOI_label{f},'_stroke_prestim_Prep_Stim(:,:,sbj);
            elseif t==2
                eval(['imagescDat=data_grp_icohmat_',FOI_label{f},'_',distype,'_intra5_Prep_',stimtype,'(:,:,sbj_r);']);
                eval(['imagescDat_p2_t2=data_grp_icohmat_',FOI_label{f},'_',distype,'_intra5_Prep_',stimtype,'(20,8,sbj_r);']);
                %imagescDat=data_grp_icohmat_',FOI_label{f},'_stroke_intra5_Prep_Stim(:,:,sbj);
            elseif t==3
                eval(['imagescDat=data_grp_icohmat_',FOI_label{f},'_',distype,'_intra15_Prep_',stimtype,'(:,:,sbj_r);']);
                eval(['imagescDat_p2_t3=data_grp_icohmat_',FOI_label{f},'_',distype,'_intra15_Prep_',stimtype,'(20,8,sbj_r);']);
                %imagescDat=data_grp_icohmat_',FOI_label{f},'_stroke_intra15_Prep_Stim(:,:,sbj);
            elseif t==4
                eval(['imagescDat=data_grp_icohmat_',FOI_label{f},'_',distype,'_poststim5_Prep_',stimtype,'(:,:,sbj_r);']);
                eval(['imagescDat_p2_t4=data_grp_icohmat_',FOI_label{f},'_',distype,'_poststim5_Prep_',stimtype,'(20,8,sbj_r);']);
                %imagescDat=data_grp_icohmat_',FOI_label{f},'_stroke_poststim5_Prep_Stim(:,:,sbj);
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
                eval(['imagescDat=data_grp_icohmat_',FOI_label{f},'_',distype,'_prestim_Reach_',stimtype,'(:,:,sbj_r);']);
                eval(['imagescDat_p3_t1=data_grp_icohmat_',FOI_label{f},'_',distype,'_prestim_Reach_',stimtype,'(20,8,sbj_r);']);
                %imagescDat=data_grp_icohmat_',FOI_label{f},'_stroke_prestim_Reach_Stim(:,:,sbj);
            elseif t==2
                eval(['imagescDat=data_grp_icohmat_',FOI_label{f},'_',distype,'_intra5_Reach_',stimtype,'(:,:,sbj_r);']);
                eval(['imagescDat_p3_t2=data_grp_icohmat_',FOI_label{f},'_',distype,'_intra5_Reach_',stimtype,'(20,8,sbj_r);']);
                %imagescDat=data_grp_icohmat_',FOI_label{f},'_stroke_intra5_Reach_Stim(:,:,sbj);
            elseif t==3
                eval(['imagescDat=data_grp_icohmat_',FOI_label{f},'_',distype,'_intra15_Reach_',stimtype,'(:,:,sbj_r);']);
                eval(['imagescDat_p3_t3=data_grp_icohmat_',FOI_label{f},'_',distype,'_intra15_Reach_',stimtype,'(20,8,sbj_r);']);
                %imagescDat=data_grp_icohmat_',FOI_label{f},'_stroke_intra15_Reach_Stim(:,:,sbj);
            elseif t==4
                eval(['imagescDat=data_grp_icohmat_',FOI_label{f},'_',distype,'_poststim5_Reach_',stimtype,'(:,:,sbj_r);']);
                eval(['imagescDat_p3_t4=data_grp_icohmat_',FOI_label{f},'_',distype,'_poststim5_Reach_',stimtype,'(20,8,sbj_r);']);
                %imagescDat=data_grp_icohmat_',FOI_label{f},'_stroke_poststim5_Reach_Stim(:,:,sbj);
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
        sgtitle([sbj_name{sbj},' ',distype,' ',stimtype,' - ',FOI_label{f}])
        %[sbj_name{sbj},' ',distype,' ',stimtype]

        %Colorbar
        %cbh = colorbar(h(end));
        cbh = colorbar;
        cbh.Location='layout';
        cbh.Position=[.9314 .11 .0281 .8150];
        ylabel(cbh,'Coherence','FontSize',12)
        %f=2;
        if norm
            ylabel(cbh,['Normalized ',FOI_label{f},' Coherence'],'FontSize',12)
            figtitle=sprintf('%s Coherence Matrix - %s Normalized',FOI_label{f},DOI{d});
        else
            ylabel(cbh,['Coherence ',FOI_label{f}],'FontSize',12)
            figtitle=sprintf('%s Coherence Matrix - %s',FOI_label{f},DOI{d});
        end
        
        eval(['imagescDat_ind_',FOI_label{f},'_c3_c4{sbj_r,sbj_c}(1,1)=imagescDat_p1_t1;'])
        eval(['imagescDat_ind_',FOI_label{f},'_c3_c4{sbj_r,sbj_c}(2,1)=imagescDat_p1_t2;'])
        eval(['imagescDat_ind_',FOI_label{f},'_c3_c4{sbj_r,sbj_c}(3,1)=imagescDat_p1_t3;'])
        eval(['imagescDat_ind_',FOI_label{f},'_c3_c4{sbj_r,sbj_c}(4,1)=imagescDat_p1_t4;'])

        eval(['imagescDat_ind_',FOI_label{f},'_c3_c4{sbj_r,sbj_c}(1,2)=imagescDat_p2_t1;'])
        eval(['imagescDat_ind_',FOI_label{f},'_c3_c4{sbj_r,sbj_c}(2,2)=imagescDat_p2_t2;'])
        eval(['imagescDat_ind_',FOI_label{f},'_c3_c4{sbj_r,sbj_c}(3,2)=imagescDat_p2_t3;'])
        eval(['imagescDat_ind_',FOI_label{f},'_c3_c4{sbj_r,sbj_c}(4,2)=imagescDat_p2_t4;'])

        eval(['imagescDat_ind_',FOI_label{f},'_c3_c4{sbj_r,sbj_c}(1,3)=imagescDat_p3_t1;'])
        eval(['imagescDat_ind_',FOI_label{f},'_c3_c4{sbj_r,sbj_c}(2,3)=imagescDat_p3_t2;'])
        eval(['imagescDat_ind_',FOI_label{f},'_c3_c4{sbj_r,sbj_c}(3,3)=imagescDat_p3_t3;'])
        eval(['imagescDat_ind_',FOI_label{f},'_c3_c4{sbj_r,sbj_c}(4,3)=imagescDat_p3_t4;'])
    
        figname=['nr_icoh_mat_sbj_',sbj_name{sbj},'_elec_all_',FOI_label{f},'_',DOI{d},'_',stimtype,'_nonnorm_',datestr];
        cd(['~/nr_data_analysis/data_analyzed/eeg/gen_03/analysis_icoh/',datestr])
        %savefig(gcf,figname)
   end
end
end

%This is for ind c3-4 plots
for f=1:numel(FOI_label)
    figure; set(gcf,'Position',[2133 109 1214 834])
    sp_vec=[1,7,13,19,2,8,14,20,3,9,15,21,4,10,16,22,5,11,17,23,NaN,NaN,NaN,24]
    for sbj=1:numel(sbj_name)
        %if isempty(sbj_name{sbj})
        if isnan(sp_vec(sbj))
        else
            subplot(6,4,sbj)
            eval(['imagesc(imagescDat_ind_',FOI_label{f},'_c3_c4{sp_vec(sbj)},[0.4 0.7])'])
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
            sgtitle(FOI_label{f})

            %Colorbar
            cbh = colorbar;
            cbh.Location='layout';
            cbh.Position=[.9314 .11 .0281 .8150];
            ylabel(cbh,'Coherence','FontSize',12)
            %f=2;
            if norm
                ylabel(cbh,['Normalized ',FOI_label{f},' C3-4 Coherence'],'FontSize',12)
                figtitle=sprintf('%s Coherence Matrix - %s Normalized',FOI_label{f},DOI{d});
            else
                ylabel(cbh,['C3-4 Coherence ',FOI_label{f}],'FontSize',12)
                figtitle=sprintf('%s Coherence Matrix - %s',FOI_label{f},DOI{d});
            end
        end
        cd(['~/nr_data_analysis/data_analyzed/eeg/gen_03/analysis_icoh/',datestr])
        figname=['nr_icoh_mat_sbj_all_elec_c3c4_',FOI_label{f},'_nonnorm_',datestr];
        %savefig(gcf,figname)
    end
end

%% icoh matrix bar plots


for f=1:numel(FOI_label)
    for sbj=1:numel(sbj_name)
        if isempty(sbj_name{sbj})
        else
            %for 

                if sbj>=1 & sbj<=6
                    distype='stroke';
                    stimtype='sham';
                    [sbj_r,sbj_c]=ind2sub(size(sbj_name),sbj);
                    eval(['icoh_data_anal.mat.c3c4.grps.ind.',FOI_label{f},'.',distype,'.',stimtype,'.pre_hold(sbj_r)=imagescDat_ind_',FOI_label{f},'_c3_c4{sbj_r,1}(1,1);']);
                    eval(['icoh_data_anal.mat.c3c4.grps.ind.',FOI_label{f},'.',distype,'.',stimtype,'.i05_hold(sbj_r)=imagescDat_ind_',FOI_label{f},'_c3_c4{sbj_r,1}(2,1);']);
                    eval(['icoh_data_anal.mat.c3c4.grps.ind.',FOI_label{f},'.',distype,'.',stimtype,'.i15_hold(sbj_r)=imagescDat_ind_',FOI_label{f},'_c3_c4{sbj_r,1}(3,1);']);
                    eval(['icoh_data_anal.mat.c3c4.grps.ind.',FOI_label{f},'.',distype,'.',stimtype,'.pos_hold(sbj_r)=imagescDat_ind_',FOI_label{f},'_c3_c4{sbj_r,1}(4,1);']);

                    eval(['icoh_data_anal.mat.c3c4.grps.ind.',FOI_label{f},'.',distype,'.',stimtype,'.pre_prep(sbj_r)=imagescDat_ind_',FOI_label{f},'_c3_c4{sbj_r,1}(1,2);']);
                    eval(['icoh_data_anal.mat.c3c4.grps.ind.',FOI_label{f},'.',distype,'.',stimtype,'.i05_prep(sbj_r)=imagescDat_ind_',FOI_label{f},'_c3_c4{sbj_r,1}(2,2);']);
                    eval(['icoh_data_anal.mat.c3c4.grps.ind.',FOI_label{f},'.',distype,'.',stimtype,'.i15_prep(sbj_r)=imagescDat_ind_',FOI_label{f},'_c3_c4{sbj_r,1}(3,2);']);
                    eval(['icoh_data_anal.mat.c3c4.grps.ind.',FOI_label{f},'.',distype,'.',stimtype,'.pos_prep(sbj_r)=imagescDat_ind_',FOI_label{f},'_c3_c4{sbj_r,1}(4,2);']);
                    
                    eval(['icoh_data_anal.mat.c3c4.grps.ind.',FOI_label{f},'.',distype,'.',stimtype,'.pre_reac(sbj_r)=imagescDat_ind_',FOI_label{f},'_c3_c4{sbj_r,1}(1,3);']);
                    eval(['icoh_data_anal.mat.c3c4.grps.ind.',FOI_label{f},'.',distype,'.',stimtype,'.i05_reac(sbj_r)=imagescDat_ind_',FOI_label{f},'_c3_c4{sbj_r,1}(2,3);']);
                    eval(['icoh_data_anal.mat.c3c4.grps.ind.',FOI_label{f},'.',distype,'.',stimtype,'.i15_reac(sbj_r)=imagescDat_ind_',FOI_label{f},'_c3_c4{sbj_r,1}(3,3);']);
                    eval(['icoh_data_anal.mat.c3c4.grps.ind.',FOI_label{f},'.',distype,'.',stimtype,'.pos_reac(sbj_r)=imagescDat_ind_',FOI_label{f},'_c3_c4{sbj_r,1}(4,3);']);
                    
                elseif sbj>=7 & sbj<=12
                    distype='stroke';
                    stimtype='stim';
                    [sbj_r,sbj_c]=ind2sub(size(sbj_name),sbj);
                    eval(['icoh_data_anal.mat.c3c4.grps.ind.',FOI_label{f},'.',distype,'.',stimtype,'.pre_hold(sbj_r)=imagescDat_ind_',FOI_label{f},'_c3_c4{sbj_r,2}(1,1);']);
                    eval(['icoh_data_anal.mat.c3c4.grps.ind.',FOI_label{f},'.',distype,'.',stimtype,'.i05_hold(sbj_r)=imagescDat_ind_',FOI_label{f},'_c3_c4{sbj_r,2}(2,1);']);
                    eval(['icoh_data_anal.mat.c3c4.grps.ind.',FOI_label{f},'.',distype,'.',stimtype,'.i15_hold(sbj_r)=imagescDat_ind_',FOI_label{f},'_c3_c4{sbj_r,2}(3,1);']);
                    eval(['icoh_data_anal.mat.c3c4.grps.ind.',FOI_label{f},'.',distype,'.',stimtype,'.pos_hold(sbj_r)=imagescDat_ind_',FOI_label{f},'_c3_c4{sbj_r,2}(4,1);']);
                    
                    eval(['icoh_data_anal.mat.c3c4.grps.ind.',FOI_label{f},'.',distype,'.',stimtype,'.pre_prep(sbj_r)=imagescDat_ind_',FOI_label{f},'_c3_c4{sbj_r,2}(1,2);']);
                    eval(['icoh_data_anal.mat.c3c4.grps.ind.',FOI_label{f},'.',distype,'.',stimtype,'.i05_prep(sbj_r)=imagescDat_ind_',FOI_label{f},'_c3_c4{sbj_r,2}(2,2);']);
                    eval(['icoh_data_anal.mat.c3c4.grps.ind.',FOI_label{f},'.',distype,'.',stimtype,'.i15_prep(sbj_r)=imagescDat_ind_',FOI_label{f},'_c3_c4{sbj_r,2}(3,2);']);
                    eval(['icoh_data_anal.mat.c3c4.grps.ind.',FOI_label{f},'.',distype,'.',stimtype,'.pos_prep(sbj_r)=imagescDat_ind_',FOI_label{f},'_c3_c4{sbj_r,2}(4,2);']);

                    eval(['icoh_data_anal.mat.c3c4.grps.ind.',FOI_label{f},'.',distype,'.',stimtype,'.pre_reac(sbj_r)=imagescDat_ind_',FOI_label{f},'_c3_c4{sbj_r,2}(1,3);']);
                    eval(['icoh_data_anal.mat.c3c4.grps.ind.',FOI_label{f},'.',distype,'.',stimtype,'.i05_reac(sbj_r)=imagescDat_ind_',FOI_label{f},'_c3_c4{sbj_r,2}(2,3);']);
                    eval(['icoh_data_anal.mat.c3c4.grps.ind.',FOI_label{f},'.',distype,'.',stimtype,'.i15_reac(sbj_r)=imagescDat_ind_',FOI_label{f},'_c3_c4{sbj_r,2}(3,3);']);
                    eval(['icoh_data_anal.mat.c3c4.grps.ind.',FOI_label{f},'.',distype,'.',stimtype,'.pos_reac(sbj_r)=imagescDat_ind_',FOI_label{f},'_c3_c4{sbj_r,2}(4,3);']);

                elseif sbj>=13 & sbj<=18
                    distype='healthy';
                    stimtype='sham';
                    [sbj_r,sbj_c]=ind2sub(size(sbj_name),sbj);
                    eval(['icoh_data_anal.mat.c3c4.grps.ind.',FOI_label{f},'.',distype,'.',stimtype,'.pre_hold(sbj_r)=imagescDat_ind_',FOI_label{f},'_c3_c4{sbj_r,3}(1,1);']);
                    eval(['icoh_data_anal.mat.c3c4.grps.ind.',FOI_label{f},'.',distype,'.',stimtype,'.i05_hold(sbj_r)=imagescDat_ind_',FOI_label{f},'_c3_c4{sbj_r,3}(2,1);']);
                    eval(['icoh_data_anal.mat.c3c4.grps.ind.',FOI_label{f},'.',distype,'.',stimtype,'.i15_hold(sbj_r)=imagescDat_ind_',FOI_label{f},'_c3_c4{sbj_r,3}(3,1);']);
                    eval(['icoh_data_anal.mat.c3c4.grps.ind.',FOI_label{f},'.',distype,'.',stimtype,'.pos_hold(sbj_r)=imagescDat_ind_',FOI_label{f},'_c3_c4{sbj_r,3}(4,1);']);
                    
                    eval(['icoh_data_anal.mat.c3c4.grps.ind.',FOI_label{f},'.',distype,'.',stimtype,'.pre_prep(sbj_r)=imagescDat_ind_',FOI_label{f},'_c3_c4{sbj_r,3}(1,2);']);
                    eval(['icoh_data_anal.mat.c3c4.grps.ind.',FOI_label{f},'.',distype,'.',stimtype,'.i05_prep(sbj_r)=imagescDat_ind_',FOI_label{f},'_c3_c4{sbj_r,3}(2,2);']);
                    eval(['icoh_data_anal.mat.c3c4.grps.ind.',FOI_label{f},'.',distype,'.',stimtype,'.i15_prep(sbj_r)=imagescDat_ind_',FOI_label{f},'_c3_c4{sbj_r,3}(3,2);']);
                    eval(['icoh_data_anal.mat.c3c4.grps.ind.',FOI_label{f},'.',distype,'.',stimtype,'.pos_prep(sbj_r)=imagescDat_ind_',FOI_label{f},'_c3_c4{sbj_r,3}(4,2);']);

                    eval(['icoh_data_anal.mat.c3c4.grps.ind.',FOI_label{f},'.',distype,'.',stimtype,'.pre_reac(sbj_r)=imagescDat_ind_',FOI_label{f},'_c3_c4{sbj_r,3}(1,3);']);
                    eval(['icoh_data_anal.mat.c3c4.grps.ind.',FOI_label{f},'.',distype,'.',stimtype,'.i05_reac(sbj_r)=imagescDat_ind_',FOI_label{f},'_c3_c4{sbj_r,3}(2,3);']);
                    eval(['icoh_data_anal.mat.c3c4.grps.ind.',FOI_label{f},'.',distype,'.',stimtype,'.i15_reac(sbj_r)=imagescDat_ind_',FOI_label{f},'_c3_c4{sbj_r,3}(3,3);']);
                    eval(['icoh_data_anal.mat.c3c4.grps.ind.',FOI_label{f},'.',distype,'.',stimtype,'.pos_reac(sbj_r)=imagescDat_ind_',FOI_label{f},'_c3_c4{sbj_r,3}(4,3);']);

                elseif sbj>=19 & sbj<=24
                    distype='healthy';
                    stimtype='stim';
                    [sbj_r,sbj_c]=ind2sub(size(sbj_name),sbj);
                    eval(['icoh_data_anal.mat.c3c4.grps.ind.',FOI_label{f},'.',distype,'.',stimtype,'.pre_hold(sbj_r)=imagescDat_ind_',FOI_label{f},'_c3_c4{sbj_r,4}(1,1);']);
                    eval(['icoh_data_anal.mat.c3c4.grps.ind.',FOI_label{f},'.',distype,'.',stimtype,'.i05_hold(sbj_r)=imagescDat_ind_',FOI_label{f},'_c3_c4{sbj_r,4}(2,1);']);
                    eval(['icoh_data_anal.mat.c3c4.grps.ind.',FOI_label{f},'.',distype,'.',stimtype,'.i15_hold(sbj_r)=imagescDat_ind_',FOI_label{f},'_c3_c4{sbj_r,4}(3,1);']);
                    eval(['icoh_data_anal.mat.c3c4.grps.ind.',FOI_label{f},'.',distype,'.',stimtype,'.pos_hold(sbj_r)=imagescDat_ind_',FOI_label{f},'_c3_c4{sbj_r,4}(4,1);']);
                    
                    eval(['icoh_data_anal.mat.c3c4.grps.ind.',FOI_label{f},'.',distype,'.',stimtype,'.pre_prep(sbj_r)=imagescDat_ind_',FOI_label{f},'_c3_c4{sbj_r,4}(1,2);']);
                    eval(['icoh_data_anal.mat.c3c4.grps.ind.',FOI_label{f},'.',distype,'.',stimtype,'.i05_prep(sbj_r)=imagescDat_ind_',FOI_label{f},'_c3_c4{sbj_r,4}(2,2);']);
                    eval(['icoh_data_anal.mat.c3c4.grps.ind.',FOI_label{f},'.',distype,'.',stimtype,'.i15_prep(sbj_r)=imagescDat_ind_',FOI_label{f},'_c3_c4{sbj_r,4}(3,2);']);
                    eval(['icoh_data_anal.mat.c3c4.grps.ind.',FOI_label{f},'.',distype,'.',stimtype,'.pos_prep(sbj_r)=imagescDat_ind_',FOI_label{f},'_c3_c4{sbj_r,4}(4,2);']);

                    eval(['icoh_data_anal.mat.c3c4.grps.ind.',FOI_label{f},'.',distype,'.',stimtype,'.pre_reac(sbj_r)=imagescDat_ind_',FOI_label{f},'_c3_c4{sbj_r,4}(1,3);']);
                    eval(['icoh_data_anal.mat.c3c4.grps.ind.',FOI_label{f},'.',distype,'.',stimtype,'.i05_reac(sbj_r)=imagescDat_ind_',FOI_label{f},'_c3_c4{sbj_r,4}(2,3);']);
                    eval(['icoh_data_anal.mat.c3c4.grps.ind.',FOI_label{f},'.',distype,'.',stimtype,'.i15_reac(sbj_r)=imagescDat_ind_',FOI_label{f},'_c3_c4{sbj_r,4}(3,3);']);
                    eval(['icoh_data_anal.mat.c3c4.grps.ind.',FOI_label{f},'.',distype,'.',stimtype,'.pos_reac(sbj_r)=imagescDat_ind_',FOI_label{f},'_c3_c4{sbj_r,4}(4,3);']);

                end
        end
    end
end

distype={'stroke';'healthy'};
stimtype={'sham';'stim'};
timetype={'pre';'i05';'i15';'pos'};
phasetype={'hold';'prep';'reac'};

for f=1:numel(FOI_label)
    for i=1:size(distype,1)
        for j=1:size(stimtype,1)
            for k=1:size(timetype,1)
                for l=1:size(phasetype,1)
                    eval(['icoh_data_anal.mat.c3c4.mean.',FOI_label{f},'.',distype{i},'.',stimtype{j},'.',timetype{k},'_',phasetype{l},...
                        '=mean(icoh_data_anal.mat.c3c4.grps.ind.',FOI_label{f},'.',distype{i},'.',stimtype{j},'.',timetype{k},'_',phasetype{l},')'])
                    eval(['icoh_data_anal.mat.c3c4.se.',FOI_label{f},'.',distype{i},'.',stimtype{j},'.',timetype{k},'_',phasetype{l},...
                        '=std(icoh_data_anal.mat.c3c4.grps.ind.',FOI_label{f},'.',distype{i},'.',stimtype{j},'.',timetype{k},'_',phasetype{l},')',...
                        '/sqrt(size(icoh_data_anal.mat.c3c4.grps.ind.',FOI_label{f},'.',distype{i},'.',stimtype{j},'.',timetype{k},'_',phasetype{l},',2))'])
                end
            end
        end
    end
end

for f=1:numel(FOI_label)
    for i=1:size(distype,1)
        for j=1:size(stimtype,1)
            for l=1:size(phasetype,1)
                eval(['icoh_data_anal.mat.c3c4.grps.all_times.',FOI_label{f},'.',distype{i},'.',stimtype{j},'_',phasetype{l},'=[',...
                    'icoh_data_anal.mat.c3c4.grps.ind.',FOI_label{f},'.',distype{i},'.',stimtype{j},'.pre','_',phasetype{l},''','...
                    'icoh_data_anal.mat.c3c4.grps.ind.',FOI_label{f},'.',distype{i},'.',stimtype{j},'.i05','_',phasetype{l},''','...
                    'icoh_data_anal.mat.c3c4.grps.ind.',FOI_label{f},'.',distype{i},'.',stimtype{j},'.i15','_',phasetype{l},''','...
                    'icoh_data_anal.mat.c3c4.grps.ind.',FOI_label{f},'.',distype{i},'.',stimtype{j},'.pos','_',phasetype{l},''']'])

                eval(['[icoh_data_anal.stats.icoh_mat.c3c4.friedman.all_times.p.',FOI_label{f},'.',distype{i},'.',stimtype{j},'_',phasetype{l},...
                    ',icoh_data_anal.stats.icoh_mat.c3c4.friedman.all_times.tab.',FOI_label{f},'.',distype{i},'.',stimtype{j},'_',phasetype{l},...
                    ',icoh_data_anal.stats.icoh_mat.c3c4.friedman.all_times.stats.',FOI_label{f},'.',distype{i},'.',stimtype{j},'_',phasetype{l},']=',...
                    'friedman(icoh_data_anal.mat.c3c4.grps.all_times.',FOI_label{f},'.',distype{i},'.',stimtype{j},'_',phasetype{l},',1,''off'')'])

            end
        end
    end
end

for f=1:numel(FOI_label)
    for i=1:size(distype,1)
        for j=1:size(stimtype,1)
            for t=1:size(timetype,1)
                eval(['icoh_data_anal.mat.c3c4.grps.all_phases.',FOI_label{f},'.',distype{i},'.',stimtype{j},'_',timetype{t},'=[',...
                    'icoh_data_anal.mat.c3c4.grps.ind.',FOI_label{f},'.',distype{i},'.',stimtype{j},'.',timetype{t},'_hold',''','...
                    'icoh_data_anal.mat.c3c4.grps.ind.',FOI_label{f},'.',distype{i},'.',stimtype{j},'.',timetype{t},'_prep',''','...
                    'icoh_data_anal.mat.c3c4.grps.ind.',FOI_label{f},'.',distype{i},'.',stimtype{j},'.',timetype{t},'_reac',''']'])

                eval(['[icoh_data_anal.stats.icoh_mat.c3c4.friedman.all_phases.p.',FOI_label{f},'.',distype{i},'.',stimtype{j},'_',timetype{t},...
                    ',icoh_data_anal.stats.icoh_mat.c3c4.friedman.all_phases.tab.',FOI_label{f},'.',distype{i},'.',stimtype{j},'_',timetype{t},...
                    ',icoh_data_anal.stats.icoh_mat.c3c4.friedman.all_phases.stats.',FOI_label{f},'.',distype{i},'.',stimtype{j},'_',timetype{t},']=',...
                    'friedman(icoh_data_anal.mat.c3c4.grps.all_phases.',FOI_label{f},'.',distype{i},'.',stimtype{j},'_',timetype{t},',1,''off'')'])  

            end
        end
    end
end
 
for f=1:numel(FOI_label)
    figure; set(gcf,'Position',[51 626 1214 571])
    
    count=0
    sp_vec_02=[1 5 9 2 6 10 3 7 11 4 8 12]
    for d=[1 2]
        for s=[1 2]
            for p=[1 2 3]
                count=count+1
                subplot(7,4,sp_vec_02(count)); hold on
                eval(['bar([icoh_data_anal.mat.c3c4.mean.',FOI_label{f},'.',distype{d},'.',stimtype{s},'.pre_',phasetype{p},...
                    ' icoh_data_anal.mat.c3c4.mean.',FOI_label{f},'.',distype{d},'.',stimtype{s},'.i05_',phasetype{p},...
                    ' icoh_data_anal.mat.c3c4.mean.',FOI_label{f},'.',distype{d},'.',stimtype{s},'.i15_',phasetype{p},...
                    ' icoh_data_anal.mat.c3c4.mean.',FOI_label{f},'.',distype{d},'.',stimtype{s},'.pos_',phasetype{p},'])'])
                eval(['errorbar([icoh_data_anal.mat.c3c4.mean.',FOI_label{f},'.',distype{d},'.',stimtype{s},'.pre_',phasetype{p},...
                    ' icoh_data_anal.mat.c3c4.mean.',FOI_label{f},'.',distype{d},'.',stimtype{s},'.i05_',phasetype{p},...
                    ' icoh_data_anal.mat.c3c4.mean.',FOI_label{f},'.',distype{d},'.',stimtype{s},'.i15_',phasetype{p},...
                    ' icoh_data_anal.mat.c3c4.mean.',FOI_label{f},'.',distype{d},'.',stimtype{s},'.pos_',phasetype{p},'],',...
                    '[icoh_data_anal.mat.c3c4.se.',FOI_label{f},'.',distype{d},'.',stimtype{s},'.pre_',phasetype{p},...
                    ' icoh_data_anal.mat.c3c4.se.',FOI_label{f},'.',distype{d},'.',stimtype{s},'.i05_',phasetype{p},...
                    ' icoh_data_anal.mat.c3c4.se.',FOI_label{f},'.',distype{d},'.',stimtype{s},'.i15_',phasetype{p},...
                    ' icoh_data_anal.mat.c3c4.se.',FOI_label{f},'.',distype{d},'.',stimtype{s},'.pos_',phasetype{p},'],''.k'')'])
                set(gca,'XTick',[1:4],'XTickLabel',{'pre';'i05';'i15';'pos'},'YLim',[0.5 0.7])
                ylabel('c3-c4 icoh')
                eval(['title(''',distype{d},' ',stimtype{s},' ',phasetype{p},''')'])
                eval(['icoh_data_anal.stats.icoh_mat.c3c4.friedman.all_times.mc.',FOI_label{f},'.',distype{d},'.',stimtype{s},'_',phasetype{p},'=',...
                    'nr_multcompare_ind_tdcs_plot2(icoh_data_anal.stats.icoh_mat.c3c4.friedman.all_times.stats.',FOI_label{f},'.',distype{d},'.',stimtype{s},'_',phasetype{p},',',...
                    'icoh_data_anal.stats.icoh_mat.c3c4.friedman.all_times.p.',FOI_label{f},'.',distype{d},'.',stimtype{s},'_',phasetype{p},',0.5)'])
            end
        end
    end
    
    count=0
    sp_vec_03=[13 17 21 25 14 18 22 26 15 19 23 27 16 20 24 28]
    for d=[1 2]
        for s=[1 2]
            for t=[1 2 3 4]
                count=count+1
                subplot(7,4,sp_vec_03(count)); hold on
                eval(['bar([icoh_data_anal.mat.c3c4.mean.',FOI_label{f},'.',distype{d},'.',stimtype{s},'.',timetype{t},'_hold',...
                        ' icoh_data_anal.mat.c3c4.mean.',FOI_label{f},'.',distype{d},'.',stimtype{s},'.',timetype{t},'_prep',...
                        ' icoh_data_anal.mat.c3c4.mean.',FOI_label{f},'.',distype{d},'.',stimtype{s},'.',timetype{t},'_reac])'])
                eval(['errorbar([icoh_data_anal.mat.c3c4.mean.',FOI_label{f},'.',distype{d},'.',stimtype{s},'.',timetype{t},'_hold',...
                        ' icoh_data_anal.mat.c3c4.mean.',FOI_label{f},'.',distype{d},'.',stimtype{s},'.',timetype{t},'_prep',...
                        ' icoh_data_anal.mat.c3c4.mean.',FOI_label{f},'.',distype{d},'.',stimtype{s},'.',timetype{t},'_reac],',...
                        '[icoh_data_anal.mat.c3c4.se.',FOI_label{f},'.',distype{d},'.',stimtype{s},'.',timetype{t},'_hold',...
                        ' icoh_data_anal.mat.c3c4.se.',FOI_label{f},'.',distype{d},'.',stimtype{s},'.',timetype{t},'_prep',...
                        ' icoh_data_anal.mat.c3c4.se.',FOI_label{f},'.',distype{d},'.',stimtype{s},'.',timetype{t},'_reac],''.k'')'])
                set(gca,'XTick',[1:3],'XTickLabel',{'hold';'prep';'reac'},'YLim',[0.5 0.7])
                ylabel('c3-c4 icoh')
                eval(['title(''',distype{d},' ',stimtype{s},' ',timetype{t},''')'])
                eval(['icoh_data_anal.stats.icoh_mat.c3c4.friedman.all_phases.mc.',FOI_label{f},'.',distype{d},'.',stimtype{s},'_',timetype{t},'=',...
                    'nr_multcompare_ind_tdcs_plot2(icoh_data_anal.stats.icoh_mat.c3c4.friedman.all_phases.stats.',FOI_label{f},'.',distype{d},'.',stimtype{s},'_',timetype{t},',',...
                    'icoh_data_anal.stats.icoh_mat.c3c4.friedman.all_phases.p.',FOI_label{f},'.',distype{d},'.',stimtype{s},'_',timetype{t},',0.5)'])
            
            end
        end
    end
    sgtitle(FOI_label{f})
    cd(['~/nr_data_analysis/data_analyzed/eeg/gen_03/analysis_icoh/',datestr])
    figname=['nr_icoh_mat_bar_sum_friedman_sbj_all_elec_c3c4_',FOI_label{f},'_',datestr];
    savefig(gcf,figname)
end
    
for f=1:numel(FOI_label)
    figure; set(gcf,'Position',[2291 369 1214 571])
    
    count=0
    sp_vec_04=[1 5 9 2 6 10]
    for d=[1 2]
        %for s=[1 2]% 1 2 1 2 1 2 1 2 1 2]%1:size(stimtype,1)
            for p=[1 2 3]
                count=count+1
                subplot(7,4,sp_vec_04(count)); hold on
                eval(['b(1)=bar([1,4,7,10],[icoh_data_anal.mat.c3c4.mean.',FOI_label{f},'.',distype{d},'.sham.pre_',phasetype{p},...
                    ' icoh_data_anal.mat.c3c4.mean.',FOI_label{f},'.',distype{d},'.sham.i05_',phasetype{p},...
                    ' icoh_data_anal.mat.c3c4.mean.',FOI_label{f},'.',distype{d},'.sham.i15_',phasetype{p},...
                    ' icoh_data_anal.mat.c3c4.mean.',FOI_label{f},'.',distype{d},'.sham.pos_',phasetype{p},'],0.2)'])
                eval(['errorbar([1,4,7,10],[icoh_data_anal.mat.c3c4.mean.',FOI_label{f},'.',distype{d},'.sham.pre_',phasetype{p},...
                    ' icoh_data_anal.mat.c3c4.mean.',FOI_label{f},'.',distype{d},'.sham.i05_',phasetype{p},...
                    ' icoh_data_anal.mat.c3c4.mean.',FOI_label{f},'.',distype{d},'.sham.i15_',phasetype{p},...
                    ' icoh_data_anal.mat.c3c4.mean.',FOI_label{f},'.',distype{d},'.sham.pos_',phasetype{p},'],',...
                    '[icoh_data_anal.mat.c3c4.se.',FOI_label{f},'.',distype{d},'.sham.pre_',phasetype{p},...
                    ' icoh_data_anal.mat.c3c4.se.',FOI_label{f},'.',distype{d},'.sham.i05_',phasetype{p},...
                    ' icoh_data_anal.mat.c3c4.se.',FOI_label{f},'.',distype{d},'.sham.i15_',phasetype{p},...
                    ' icoh_data_anal.mat.c3c4.se.',FOI_label{f},'.',distype{d},'.sham.pos_',phasetype{p},'],''.k'')'])
                eval(['b(2)=bar([2,5,8,11],[icoh_data_anal.mat.c3c4.mean.',FOI_label{f},'.',distype{d},'.stim.pre_',phasetype{p},...
                    ' icoh_data_anal.mat.c3c4.mean.',FOI_label{f},'.',distype{d},'.stim.i05_',phasetype{p},...
                    ' icoh_data_anal.mat.c3c4.mean.',FOI_label{f},'.',distype{d},'.stim.i15_',phasetype{p},...
                    ' icoh_data_anal.mat.c3c4.mean.',FOI_label{f},'.',distype{d},'.stim.pos_',phasetype{p},'],0.2)'])
                eval(['errorbar([2,5,8,11],[icoh_data_anal.mat.c3c4.mean.',FOI_label{f},'.',distype{d},'.stim.pre_',phasetype{p},...
                    ' icoh_data_anal.mat.c3c4.mean.',FOI_label{f},'.',distype{d},'.stim.i05_',phasetype{p},...
                    ' icoh_data_anal.mat.c3c4.mean.',FOI_label{f},'.',distype{d},'.stim.i15_',phasetype{p},...
                    ' icoh_data_anal.mat.c3c4.mean.',FOI_label{f},'.',distype{d},'.stim.pos_',phasetype{p},'],',...
                    '[icoh_data_anal.mat.c3c4.se.',FOI_label{f},'.',distype{d},'.stim.pre_',phasetype{p},...
                    ' icoh_data_anal.mat.c3c4.se.',FOI_label{f},'.',distype{d},'.stim.i05_',phasetype{p},...
                    ' icoh_data_anal.mat.c3c4.se.',FOI_label{f},'.',distype{d},'.stim.i15_',phasetype{p},...
                    ' icoh_data_anal.mat.c3c4.se.',FOI_label{f},'.',distype{d},'.stim.pos_',phasetype{p},'],''.k'')'])
                
                set(gca,'XTick',[1 4 7 10],'XTickLabel',{'pre';'i05';'i15';'pos'},'YLim',[0.5 0.8])
                ylabel('c3-c4 icoh')
                eval(['title(''',distype{d},' - ',phasetype{p},''')'])
                if count==1
                    l1=legend('Sham','','Stim','')
                    set(l1,'Position',[0.2439 0.9036 0.0640 0.0499])
                end
                
                eval(['anovaInput{1,1}=[icoh_data_anal.mat.c3c4.grps.ind.',FOI_label{f},'.',distype{d},'.sham.pre_',phasetype{p},''','...
                    'icoh_data_anal.mat.c3c4.grps.ind.',FOI_label{f},'.',distype{d},'.sham.i05_',phasetype{p},''','...
                    'icoh_data_anal.mat.c3c4.grps.ind.',FOI_label{f},'.',distype{d},'.sham.i15_',phasetype{p},''','...
                    'icoh_data_anal.mat.c3c4.grps.ind.',FOI_label{f},'.',distype{d},'.sham.pos_',phasetype{p},''']'])
                eval(['anovaInput{1,2}=[icoh_data_anal.mat.c3c4.grps.ind.',FOI_label{f},'.',distype{d},'.stim.pre_',phasetype{p},''','...
                    'icoh_data_anal.mat.c3c4.grps.ind.',FOI_label{f},'.',distype{d},'.stim.i05_',phasetype{p},''','...
                    'icoh_data_anal.mat.c3c4.grps.ind.',FOI_label{f},'.',distype{d},'.stim.i15_',phasetype{p},''','...
                    'icoh_data_anal.mat.c3c4.grps.ind.',FOI_label{f},'.',distype{d},'.stim.pos_',phasetype{p},''']'])
                %keep in mind you already have the expressions above saved
                %in icoh_data_anal but to make the for loop run just keep
                %as is
                eval(['[icoh_data_anal.stats.icoh_mat.c3c4.mixanova.',FOI_label{f},'.all_times','.',distype{d},'.',phasetype{p},'.mc1,',...
                    'icoh_data_anal.stats.icoh_mat.c3c4.mixanova.',FOI_label{f},'.all_times','.',distype{d},'.',phasetype{p},'.mc2',...
                    ']=mixANOVA(anovaInput,b)'])
                clear anovaInput b
                        
            end
        %end
    end
    
    count=0
    sp_vec_05=[13 17 21 25 14 18 22 26]
    for d=[1 2]
        %for s=[1 2]
        for t=[1 2 3 4]
            %for p=[1 2 3]
                count=count+1
                subplot(7,4,sp_vec_05(count)); hold on
                eval(['b(1)=bar([1,4,7],[icoh_data_anal.mat.c3c4.mean.',FOI_label{f},'.',distype{d},'.sham.',timetype{t},'_hold',...
                    ' icoh_data_anal.mat.c3c4.mean.',FOI_label{f},'.',distype{d},'.sham.',timetype{t},'_prep',...
                    ' icoh_data_anal.mat.c3c4.mean.',FOI_label{f},'.',distype{d},'.sham.',timetype{t},'_reac],0.2)'])
                eval(['errorbar([1,4,7],[icoh_data_anal.mat.c3c4.mean.',FOI_label{f},'.',distype{d},'.sham.',timetype{t},'_hold',...
                    ' icoh_data_anal.mat.c3c4.mean.',FOI_label{f},'.',distype{d},'.sham.',timetype{t},'_prep',...
                    ' icoh_data_anal.mat.c3c4.mean.',FOI_label{f},'.',distype{d},'.sham.',timetype{t},'_reac],',...
                    '[icoh_data_anal.mat.c3c4.se.',FOI_label{f},'.',distype{d},'.sham.',timetype{t},'_hold',...
                    ' icoh_data_anal.mat.c3c4.se.',FOI_label{f},'.',distype{d},'.sham.',timetype{t},'_prep',...
                    ' icoh_data_anal.mat.c3c4.se.',FOI_label{f},'.',distype{d},'.sham.',timetype{t},'_reac],''.k'')'])
                eval(['b(2)=bar([2,5,8],[icoh_data_anal.mat.c3c4.mean.',FOI_label{f},'.',distype{d},'.stim.',timetype{t},'_hold',...
                    ' icoh_data_anal.mat.c3c4.mean.',FOI_label{f},'.',distype{d},'.stim.',timetype{t},'_prep',...
                    ' icoh_data_anal.mat.c3c4.mean.',FOI_label{f},'.',distype{d},'.stim.',timetype{t},'_reac],0.2)'])
                eval(['errorbar([2,5,8],[icoh_data_anal.mat.c3c4.mean.',FOI_label{f},'.',distype{d},'.stim.',timetype{t},'_hold',...
                    ' icoh_data_anal.mat.c3c4.mean.',FOI_label{f},'.',distype{d},'.stim.',timetype{t},'_prep',...
                    ' icoh_data_anal.mat.c3c4.mean.',FOI_label{f},'.',distype{d},'.stim.',timetype{t},'_reac],',...
                    '[icoh_data_anal.mat.c3c4.se.',FOI_label{f},'.',distype{d},'.stim.',timetype{t},'_hold',...
                    ' icoh_data_anal.mat.c3c4.se.',FOI_label{f},'.',distype{d},'.stim.',timetype{t},'_prep',...
                    ' icoh_data_anal.mat.c3c4.se.',FOI_label{f},'.',distype{d},'.stim.',timetype{t},'_reac],''.k'')'])
                set(gca,'XTick',[1 4 7],'XTickLabel',{'hold';'prep';'reac'},'YLim',[0.5 0.8])
                ylabel('c3-c4 icoh')
                eval(['title(''',distype{d},' - ',timetype{t},''')'])
                                
                eval(['anovaInput{1,1}=[icoh_data_anal.mat.c3c4.grps.ind.',FOI_label{f},'.',distype{d},'.sham.',timetype{t},'_hold'','...
                    'icoh_data_anal.mat.c3c4.grps.ind.',FOI_label{f},'.',distype{d},'.sham.',timetype{t},'_prep'','...
                    'icoh_data_anal.mat.c3c4.grps.ind.',FOI_label{f},'.',distype{d},'.sham.',timetype{t},'_reac'']'])
                eval(['anovaInput{1,2}=[icoh_data_anal.mat.c3c4.grps.ind.',FOI_label{f},'.',distype{d},'.stim.',timetype{t},'_hold'','...
                    'icoh_data_anal.mat.c3c4.grps.ind.',FOI_label{f},'.',distype{d},'.stim.',timetype{t},'_prep'','...
                    'icoh_data_anal.mat.c3c4.grps.ind.',FOI_label{f},'.',distype{d},'.stim.',timetype{t},'_reac'']'])
                eval(['[icoh_data_anal.stats.icoh_mat.c3c4.mixanova.',FOI_label{f},'.all_phases','.',distype{d},'.',timetype{t},'.mc1,'...
                    'icoh_data_anal.stats.icoh_mat.c3c4.mixanova.',FOI_label{f},'.all_phases','.',distype{d},'.',timetype{t},'.mc2',...
                    ']=mixANOVA(anovaInput,b)'])
                clear anovaInput b
                        
            end
        %end
    end

    count=0
    sp_vec_06=[3 7 11 4 8 12]
    %for d=[1 2]
        for s=[1 2]
            for p=[1 2 3]
                count=count+1
                subplot(7,4,sp_vec_06(count)); hold on
                eval(['b(1)=bar([1,4,7,10],[icoh_data_anal.mat.c3c4.mean.',FOI_label{f},'.stroke.',stimtype{s},'.pre_',phasetype{p},...
                    ' icoh_data_anal.mat.c3c4.mean.',FOI_label{f},'.stroke.',stimtype{s},'.i05_',phasetype{p},...
                    ' icoh_data_anal.mat.c3c4.mean.',FOI_label{f},'.stroke.',stimtype{s},'.i15_',phasetype{p},...
                    ' icoh_data_anal.mat.c3c4.mean.',FOI_label{f},'.stroke.',stimtype{s},'.pos_',phasetype{p},'],0.2)'])
                eval(['errorbar([1,4,7,10],[icoh_data_anal.mat.c3c4.mean.',FOI_label{f},'.stroke.',stimtype{s},'.pre_',phasetype{p},...
                    ' icoh_data_anal.mat.c3c4.mean.',FOI_label{f},'.stroke.',stimtype{s},'.i05_',phasetype{p},...
                    ' icoh_data_anal.mat.c3c4.mean.',FOI_label{f},'.stroke.',stimtype{s},'.i15_',phasetype{p},...
                    ' icoh_data_anal.mat.c3c4.mean.',FOI_label{f},'.stroke.',stimtype{s},'.pos_',phasetype{p},'],',...
                    '[icoh_data_anal.mat.c3c4.se.',FOI_label{f},'.stroke.',stimtype{s},'.pre_',phasetype{p},...
                    ' icoh_data_anal.mat.c3c4.se.',FOI_label{f},'.stroke.',stimtype{s},'.i05_',phasetype{p},...
                    ' icoh_data_anal.mat.c3c4.se.',FOI_label{f},'.stroke.',stimtype{s},'.i15_',phasetype{p},...
                    ' icoh_data_anal.mat.c3c4.se.',FOI_label{f},'.stroke.',stimtype{s},'.pos_',phasetype{p},'],''.k'')'])
                eval(['b(2)=bar([2,5,8,11],[icoh_data_anal.mat.c3c4.mean.',FOI_label{f},'.healthy.',stimtype{s},'.pre_',phasetype{p},...
                    ' icoh_data_anal.mat.c3c4.mean.',FOI_label{f},'.healthy.',stimtype{s},'.i05_',phasetype{p},...
                    ' icoh_data_anal.mat.c3c4.mean.',FOI_label{f},'.healthy.',stimtype{s},'.i15_',phasetype{p},...
                    ' icoh_data_anal.mat.c3c4.mean.',FOI_label{f},'.healthy.',stimtype{s},'.pos_',phasetype{p},'],0.2)'])
                eval(['errorbar([2,5,8,11],[icoh_data_anal.mat.c3c4.mean.',FOI_label{f},'.healthy.',stimtype{s},'.pre_',phasetype{p},...
                    ' icoh_data_anal.mat.c3c4.mean.',FOI_label{f},'.healthy.',stimtype{s},'.i05_',phasetype{p},...
                    ' icoh_data_anal.mat.c3c4.mean.',FOI_label{f},'.healthy.',stimtype{s},'.i15_',phasetype{p},...
                    ' icoh_data_anal.mat.c3c4.mean.',FOI_label{f},'.healthy.',stimtype{s},'.pos_',phasetype{p},'],',...
                    '[icoh_data_anal.mat.c3c4.se.',FOI_label{f},'.healthy.',stimtype{s},'.pre_',phasetype{p},...
                    ' icoh_data_anal.mat.c3c4.se.',FOI_label{f},'.healthy.',stimtype{s},'.i05_',phasetype{p},...
                    ' icoh_data_anal.mat.c3c4.se.',FOI_label{f},'.healthy.',stimtype{s},'.i15_',phasetype{p},...
                    ' icoh_data_anal.mat.c3c4.se.',FOI_label{f},'.healthy.',stimtype{s},'.pos_',phasetype{p},'],''.k'')'])
                
                set(gca,'XTick',[1 4 7 10],'XTickLabel',{'pre';'i05';'i15';'pos'},'YLim',[0.5 0.8])
                ylabel('c3-c4 icoh')
                eval(['title(''',stimtype{s},' - ',phasetype{p},''')'])
                if count==1
                    l2=legend('Stroke','','Healthy','')
                    set(l2,'Position',[0.6549 0.9001 0.0640 0.0499])
                end
                
                eval(['anovaInput{1,1}=[icoh_data_anal.mat.c3c4.grps.ind.',FOI_label{f},'.stroke.',stimtype{s},'.pre_',phasetype{p},''','...
                    'icoh_data_anal.mat.c3c4.grps.ind.',FOI_label{f},'.stroke.',stimtype{s},'.i05_',phasetype{p},''','...
                    'icoh_data_anal.mat.c3c4.grps.ind.',FOI_label{f},'.stroke.',stimtype{s},'.i15_',phasetype{p},''','...
                    'icoh_data_anal.mat.c3c4.grps.ind.',FOI_label{f},'.stroke.',stimtype{s},'.pos_',phasetype{p},''']'])
                eval(['anovaInput{1,2}=[icoh_data_anal.mat.c3c4.grps.ind.',FOI_label{f},'.healthy.',stimtype{s},'.pre_',phasetype{p},''','...
                    'icoh_data_anal.mat.c3c4.grps.ind.',FOI_label{f},'.healthy.',stimtype{s},'.i05_',phasetype{p},''','...
                    'icoh_data_anal.mat.c3c4.grps.ind.',FOI_label{f},'.healthy.',stimtype{s},'.i15_',phasetype{p},''','...
                    'icoh_data_anal.mat.c3c4.grps.ind.',FOI_label{f},'.healthy.',stimtype{s},'.pos_',phasetype{p},''']'])
                eval(['[icoh_data_anal.stats.icoh_mat.c3c4.mixanova.',FOI_label{f},'.all_times','.',stimtype{s},'.',phasetype{p},'.mc1,',...
                    'icoh_data_anal.stats.icoh_mat.c3c4.mixanova.',FOI_label{f},'.all_times','.',stimtype{s},'.',phasetype{p},'.mc2',...
                    ']=mixANOVA(anovaInput,b)'])
                clear anovaInput b
                        
            end
        %end
    end
    
    count=0
    sp_vec_07=[15 19 23 27 16 20 24 28]
    %for d=[1 2]
        for s=[1 2]
        for t=[1 2 3 4]
            %for p=[1 2 3]
                count=count+1
                subplot(7,4,sp_vec_07(count)); hold on
                eval(['b(1)=bar([1,4,7],[icoh_data_anal.mat.c3c4.mean.',FOI_label{f},'.stroke.',stimtype{s},'.',timetype{t},'_hold',...
                    ' icoh_data_anal.mat.c3c4.mean.',FOI_label{f},'.stroke.',stimtype{s},'.',timetype{t},'_prep',...
                    ' icoh_data_anal.mat.c3c4.mean.',FOI_label{f},'.stroke.',stimtype{s},'.',timetype{t},'_reac],0.2)'])
                eval(['errorbar([1,4,7],[icoh_data_anal.mat.c3c4.mean.',FOI_label{f},'.stroke.',stimtype{s},'.',timetype{t},'_hold',...
                    ' icoh_data_anal.mat.c3c4.mean.',FOI_label{f},'.stroke.',stimtype{s},'.',timetype{t},'_prep',...
                    ' icoh_data_anal.mat.c3c4.mean.',FOI_label{f},'.stroke.',stimtype{s},'.',timetype{t},'_reac],',...
                    '[icoh_data_anal.mat.c3c4.se.',FOI_label{f},'.stroke.',stimtype{s},'.',timetype{t},'_hold',...
                    ' icoh_data_anal.mat.c3c4.se.',FOI_label{f},'.stroke.',stimtype{s},'.',timetype{t},'_prep',...
                    ' icoh_data_anal.mat.c3c4.se.',FOI_label{f},'.stroke.',stimtype{s},'.',timetype{t},'_reac],''.k'')'])
                eval(['b(2)=bar([2,5,8],[icoh_data_anal.mat.c3c4.mean.',FOI_label{f},'.healthy.',stimtype{s},'.',timetype{t},'_hold',...
                    ' icoh_data_anal.mat.c3c4.mean.',FOI_label{f},'.healthy.',stimtype{s},'.',timetype{t},'_prep',...
                    ' icoh_data_anal.mat.c3c4.mean.',FOI_label{f},'.healthy.',stimtype{s},'.',timetype{t},'_reac],0.2)'])
                eval(['errorbar([2,5,8],[icoh_data_anal.mat.c3c4.mean.',FOI_label{f},'.healthy.',stimtype{s},'.',timetype{t},'_hold',...
                    ' icoh_data_anal.mat.c3c4.mean.',FOI_label{f},'.healthy.',stimtype{s},'.',timetype{t},'_prep',...
                    ' icoh_data_anal.mat.c3c4.mean.',FOI_label{f},'.healthy.',stimtype{s},'.',timetype{t},'_reac],',...
                    '[icoh_data_anal.mat.c3c4.se.',FOI_label{f},'.healthy.',stimtype{s},'.',timetype{t},'_hold',...
                    ' icoh_data_anal.mat.c3c4.se.',FOI_label{f},'.healthy.',stimtype{s},'.',timetype{t},'_prep',...
                    ' icoh_data_anal.mat.c3c4.se.',FOI_label{f},'.healthy.',stimtype{s},'.',timetype{t},'_reac],''.k'')'])
                set(gca,'XTick',[1 4 7],'XTickLabel',{'hold';'prep';'reac'},'YLim',[0.5 0.8])
                ylabel('c3-c4 icoh')
                eval(['title(''',stimtype{s},' - ',timetype{t},''')'])
                                
                eval(['anovaInput{1,1}=[icoh_data_anal.mat.c3c4.grps.ind.',FOI_label{f},'.stroke.',stimtype{s},'.',timetype{t},'_hold'','...
                    'icoh_data_anal.mat.c3c4.grps.ind.',FOI_label{f},'.stroke.',stimtype{s},'.',timetype{t},'_prep'','...
                    'icoh_data_anal.mat.c3c4.grps.ind.',FOI_label{f},'.stroke.',stimtype{s},'.',timetype{t},'_reac'']'])
                eval(['anovaInput{1,2}=[icoh_data_anal.mat.c3c4.grps.ind.',FOI_label{f},'.healthy.',stimtype{s},'.',timetype{t},'_hold'','...
                    'icoh_data_anal.mat.c3c4.grps.ind.',FOI_label{f},'.healthy.',stimtype{s},'.',timetype{t},'_prep'','...
                    'icoh_data_anal.mat.c3c4.grps.ind.',FOI_label{f},'.healthy.',stimtype{s},'.',timetype{t},'_reac'']'])
                eval(['[icoh_data_anal.stats.icoh_mat.c3c4.mixanova.',FOI_label{f},'.all_phases','.',stimtype{s},'.',timetype{t},'.mc1,',...
                    'icoh_data_anal.stats.icoh_mat.c3c4.mixanova.',FOI_label{f},'.all_phases','.',stimtype{s},'.',timetype{t},'.mc2',...
                    ']=mixANOVA(anovaInput,b)'])
                clear anovaInput b
                        
            end
        %end
    end
   
    sgtitle(FOI_label{f})
    cd(['~/nr_data_analysis/data_analyzed/eeg/gen_03/analysis_icoh/',datestr])
    figname=['nr_icoh_mat_bar_sum_mixanova_sbj_all_elec_c3c4_',FOI_label{f},'_',datestr];
    savefig(gcf,figname)
end    





%% Coherence diff
% steps
% next you need individual matrices
% next on one big plot you will do all sbj with just c3c4
% then the bar plots (I think)


%TOI={'pre-stim (baseline)','intrastim (5 min)','intrastim (15 min)','post-stim (5 min)'};
TOI={'pre','i05','i15','pos'};
TOI_mod={'prestim','intra5','intra15','poststim5'};
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
                    eval(['icoh_data_anal.mat_diff.all.',FOI_label{f},'.',DOI{d},'.',phases{p},'_',phases{p+1},'.',stimname{s},'.',TOI{t},'=matcoh(:,:,idx);'])
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
        
%         % link axis
%         for i=1:numel(h)
%             caxis(h(i),[cmin cmax])
%         end
%         
%         % Colorbar
%         cbh = colorbar(h(end));
%         cbh.Location='layout';
%         cbh.Position=[.9314 .11 .0281 .8150];
%         ylabel(cbh,['% Diff Coherence ',FOI_label{f}],'FontSize',12)
%         figtitle=sprintf('%s Percent Diff Coherence - %s',FOI_label{f},DOI{d});
%         
        % Title
            sgtitle([FOI_label{f},' - ',DOI{d},' - all subjects (%)'])
            figname=['nr_icoh_matdiff_sbj_all_elec_all_',FOI_label{f},'_',DOI{d},'_nonnorm_',datestr];
        %end
        
        
%         % Save figure
        %if savefigures
            cd(['~/nr_data_analysis/data_analyzed/eeg/gen_03/analysis_icoh/',datestr])
            %savefig(gcf,figname)
        %end
        
        
        
        
        %close all
    end
end

%tomorrow
% clear everything (btw make sure to uncomment caxes on previous section
%run all eelectrode mattdiff plots then try to run plots for each subject
%do some spot checking bc you won't know whether they are correct or not

%% Individual icoh diff matrices

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
for f=2%1:numel(FOI_label)
    for sbj=1%:numel(sbj_name)
        if isempty(sbj_name{sbj})
        else
            figure; set(gcf,'Position',[2052 610 743 515])

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
             
            count=0
            sp_vec_08=[1 3 5 7 2 4 6 8]
            for p=[1 2]
                for t=1:numel(TOI)
                    count=count+1
                    subplot(4,2,sp_vec_08(count))
                   % if t==1
                        eval(['imagescDatall=icoh_data_anal.mat_diff.all.',FOI_label{f},'.',DOI{d},'.',phases{p},'_',phases{p+1},'.',stimname{s},'.',TOI{t},'(:,:,sbj_r);']);
        %                eval(['imagescDatall=icoh_data_anal.mat_diff.all.',FOI_label{f},'.',distype,'.',phases{p},'_',phases{p+1},'.',stimtype,'.',TOI{t},'(:,:,sbj_r);']);
        % 
        %                 eval(['icoh_data_anal.mat_diff.all.',FOI_label{f},'.',DOI{d},'.',phases{p},'_',phases{p+1},'.',stimname{s},'.',TOI{t},'=matcoh(:,:,idx);'])
        %                 eval(['imagescDatall=icoh_data_anal.mat_diff.all.',FOI_label{f},'.',DOI{d},'.',phases{p},'_',phases{p+1},'.',stimname{s},'.',TOI{t},'(:,:,sbj_r);']);
        %                     data_grp_icohmat_',FOI_label{f},'_',distype,'_prestim_Hold_',stimtype,'(:,:,sbj_r);']);
        % 
        %                 eval(['imagescDat=data_grp_icohmat_',FOI_label{f},'_',distype,'_prestim_Hold_',stimtype,'(:,:,sbj_r);']);
        %                 eval(['imagescDat_p1_t1=data_grp_icohmat_',FOI_label{f},'_',distype,'_prestim_Hold_',stimtype,'(20,8,sbj_r);']);
        %             elseif t==2
        %                 eval(['imagescDat=data_grp_icohmat_',FOI_label{f},'_',distype,'_intra5_Hold_',stimtype,'(:,:,sbj_r);']);
        %                 eval(['imagescDat_p1_t2=data_grp_icohmat_',FOI_label{f},'_',distype,'_intra5_Hold_',stimtype,'(20,8,sbj_r);']);
        %             elseif t==3
        %                 eval(['imagescDat=data_grp_icohmat_',FOI_label{f},'_',distype,'_intra15_Hold_',stimtype,'(:,:,sbj_r);']);
        %                 eval(['imagescDat_p1_t3=data_grp_icohmat_',FOI_label{f},'_',distype,'_intra15_Hold_',stimtype,'(20,8,sbj_r);']);
        %             elseif t==4
        %                 eval(['imagescDat=data_grp_icohmat_',FOI_label{f},'_',distype,'_poststim5_Hold_',stimtype,'(:,:,sbj_r);']);
        %                 eval(['imagescDat_p1_t4=data_grp_icohmat_',FOI_label{f},'_',distype,'_poststim5_Hold_',stimtype,'(20,8,sbj_r);']);
        %             end

                %             if norm
                %                 imagescDat1(logical(diag(ones(size(imagescDat1,1),1))))=mean(imagescDat1,'all');
                %                 imagescDat1=mat2gray(imagescDat1);
                %                 imagescDat1(logical(diag(ones(size(imagescDat1,1),1))))=nan;
                %             end
                    imagesc(imagescDatall,[0.4 0.7])
                    %axis square

                    colormap('jet');
                    xticks([1:numel(electrodes)])
                    xticklabels(electrodes)
                    yticks([1:numel(electrodes)])
                    yticklabels(electrodes)
                    title([phases{p},' - ',phases{p+1}])
                    %subtitle(stimname{2})%s
                    subtitle(stimtype)
                    ylabel(TOI{t})

                end
            end
            sgtitle([FOI_label{f},' - ',sbj_name{sbj},' ',distype,' ',stimtype])

    % 
    %         for t=1:numel(TOI)
    %             subplot(4,3,3*t-1)
    %             if t==1
    %                 eval(['imagescDat=data_grp_icohmat_',FOI_label{f},'_',distype,'_prestim_Prep_',stimtype,'(:,:,sbj_r);']);
    %                 eval(['imagescDat_p2_t1=data_grp_icohmat_',FOI_label{f},'_',distype,'_prestim_Prep_',stimtype,'(20,8,sbj_r);']);
    %             elseif t==2
    %                 eval(['imagescDat=data_grp_icohmat_',FOI_label{f},'_',distype,'_intra5_Prep_',stimtype,'(:,:,sbj_r);']);
    %                 eval(['imagescDat_p2_t2=data_grp_icohmat_',FOI_label{f},'_',distype,'_intra5_Prep_',stimtype,'(20,8,sbj_r);']);
    %             elseif t==3
    %                 eval(['imagescDat=data_grp_icohmat_',FOI_label{f},'_',distype,'_intra15_Prep_',stimtype,'(:,:,sbj_r);']);
    %                 eval(['imagescDat_p2_t3=data_grp_icohmat_',FOI_label{f},'_',distype,'_intra15_Prep_',stimtype,'(20,8,sbj_r);']);
    %             elseif t==4
    %                 eval(['imagescDat=data_grp_icohmat_',FOI_label{f},'_',distype,'_poststim5_Prep_',stimtype,'(:,:,sbj_r);']);
    %                 eval(['imagescDat_p2_t4=data_grp_icohmat_',FOI_label{f},'_',distype,'_poststim5_Prep_',stimtype,'(20,8,sbj_r);']);
    %             end
    % 
    %     %             if norm
    %     %                 imagescDat1(logical(diag(ones(size(imagescDat1,1),1))))=mean(imagescDat1,'all');
    %     %                 imagescDat1=mat2gray(imagescDat1);
    %     %                 imagescDat1(logical(diag(ones(size(imagescDat1,1),1))))=nan;
    %     %             end
    %             imagesc(imagescDat,[0.4 0.7])
    %             %axis square
    % 
    %             colormap('jet');
    %             xticks([1:numel(electrodes)])
    %             xticklabels(electrodes)
    %             yticks([1:numel(electrodes)])
    %             yticklabels(electrodes)
    %             title(phases{2})%p
    %             %subtitle(stimname{2})%s
    %             subtitle(stimtype)
    %             ylabel(TOI{t})
    % 
    %         end
    % 
    %         for t=1:numel(TOI)
    %             subplot(4,3,3*t)
    %             if t==1
    %                 eval(['imagescDat=data_grp_icohmat_',FOI_label{f},'_',distype,'_prestim_Reach_',stimtype,'(:,:,sbj_r);']);
    %                 eval(['imagescDat_p3_t1=data_grp_icohmat_',FOI_label{f},'_',distype,'_prestim_Reach_',stimtype,'(20,8,sbj_r);']);
    %             elseif t==2
    %                 eval(['imagescDat=data_grp_icohmat_',FOI_label{f},'_',distype,'_intra5_Reach_',stimtype,'(:,:,sbj_r);']);
    %                 eval(['imagescDat_p3_t2=data_grp_icohmat_',FOI_label{f},'_',distype,'_intra5_Reach_',stimtype,'(20,8,sbj_r);']);
    %             elseif t==3
    %                 eval(['imagescDat=data_grp_icohmat_',FOI_label{f},'_',distype,'_intra15_Reach_',stimtype,'(:,:,sbj_r);']);
    %                 eval(['imagescDat_p3_t3=data_grp_icohmat_',FOI_label{f},'_',distype,'_intra15_Reach_',stimtype,'(20,8,sbj_r);']);
    %             elseif t==4
    %                 eval(['imagescDat=data_grp_icohmat_',FOI_label{f},'_',distype,'_poststim5_Reach_',stimtype,'(:,:,sbj_r);']);
    %                 eval(['imagescDat_p3_t4=data_grp_icohmat_',FOI_label{f},'_',distype,'_poststim5_Reach_',stimtype,'(20,8,sbj_r);']);
    %             end
    % 
    %     %             if norm
    %     %                 imagescDat1(logical(diag(ones(size(imagescDat1,1),1))))=mean(imagescDat1,'all');
    %     %                 imagescDat1=mat2gray(imagescDat1);
    %     %                 imagescDat1(logical(diag(ones(size(imagescDat1,1),1))))=nan;
    %     %             end
    %             imagesc(imagescDat,[0.4 0.7])
    %             %axis square
    % 
    %             colormap('jet');
    %             xticks([1:numel(electrodes)])
    %             xticklabels(electrodes)
    %             yticks([1:numel(electrodes)])
    %             yticklabels(electrodes)
    %             title(phases{3})%p
    %             %subtitle(stimname{2})%s
    %             subtitle(stimtype)
    %             ylabel(TOI{t})
    % 
    %         end
    %         %sbj
    %         sgtitle([sbj_name{sbj},' ',distype,' ',stimtype,' - ',FOI_label{f}])
    %         %[sbj_name{sbj},' ',distype,' ',stimtype]
    % 
    %         %Colorbar
    %         %cbh = colorbar(h(end));
    %         cbh = colorbar;
    %         cbh.Location='layout';
    %         cbh.Position=[.9314 .11 .0281 .8150];
    %         ylabel(cbh,'Coherence','FontSize',12)
    %         %f=2;
    %         if norm
    %             ylabel(cbh,['Normalized ',FOI_label{f},' Coherence'],'FontSize',12)
    %             figtitle=sprintf('%s Coherence Matrix - %s Normalized',FOI_label{f},DOI{d});
    %         else
    %             ylabel(cbh,['Coherence ',FOI_label{f}],'FontSize',12)
    %             figtitle=sprintf('%s Coherence Matrix - %s',FOI_label{f},DOI{d});
    %         end
    %         
    %         eval(['imagescDat_ind_',FOI_label{f},'_c3_c4{sbj_r,sbj_c}(1,1)=imagescDat_p1_t1;'])
    %         eval(['imagescDat_ind_',FOI_label{f},'_c3_c4{sbj_r,sbj_c}(2,1)=imagescDat_p1_t2;'])
    %         eval(['imagescDat_ind_',FOI_label{f},'_c3_c4{sbj_r,sbj_c}(3,1)=imagescDat_p1_t3;'])
    %         eval(['imagescDat_ind_',FOI_label{f},'_c3_c4{sbj_r,sbj_c}(4,1)=imagescDat_p1_t4;'])
    % 
    %         eval(['imagescDat_ind_',FOI_label{f},'_c3_c4{sbj_r,sbj_c}(1,2)=imagescDat_p2_t1;'])
    %         eval(['imagescDat_ind_',FOI_label{f},'_c3_c4{sbj_r,sbj_c}(2,2)=imagescDat_p2_t2;'])
    %         eval(['imagescDat_ind_',FOI_label{f},'_c3_c4{sbj_r,sbj_c}(3,2)=imagescDat_p2_t3;'])
    %         eval(['imagescDat_ind_',FOI_label{f},'_c3_c4{sbj_r,sbj_c}(4,2)=imagescDat_p2_t4;'])
    % 
    %         eval(['imagescDat_ind_',FOI_label{f},'_c3_c4{sbj_r,sbj_c}(1,3)=imagescDat_p3_t1;'])
    %         eval(['imagescDat_ind_',FOI_label{f},'_c3_c4{sbj_r,sbj_c}(2,3)=imagescDat_p3_t2;'])
    %         eval(['imagescDat_ind_',FOI_label{f},'_c3_c4{sbj_r,sbj_c}(3,3)=imagescDat_p3_t3;'])
    %         eval(['imagescDat_ind_',FOI_label{f},'_c3_c4{sbj_r,sbj_c}(4,3)=imagescDat_p3_t4;'])
    %     
    %         figname=['nr_icoh_mat_sbj_',sbj_name{sbj},'_elec_all_',FOI_label{f},'_',DOI{d},'_',stimtype,'_nonnorm_',datestr];
    %         cd(['~/nr_data_analysis/data_analyzed/eeg/gen_03/analysis_icoh/',datestr])
    %         %savefig(gcf,figname)
       end
    end
end

%This is for ind c3-4 plots
for f=1:numel(FOI_label)
    figure; set(gcf,'Position',[2133 109 1214 834])
    sp_vec=[1,7,13,19,2,8,14,20,3,9,15,21,4,10,16,22,5,11,17,23,NaN,NaN,NaN,24]
    for sbj=1:numel(sbj_name)
        %if isempty(sbj_name{sbj})
        if isnan(sp_vec(sbj))
        else
            subplot(6,4,sbj)
            eval(['imagesc(imagescDat_ind_',FOI_label{f},'_c3_c4{sp_vec(sbj)},[0.4 0.7])'])
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
            sgtitle(FOI_label{f})

            %Colorbar
            cbh = colorbar;
            cbh.Location='layout';
            cbh.Position=[.9314 .11 .0281 .8150];
            ylabel(cbh,'Coherence','FontSize',12)
            %f=2;
            if norm
                ylabel(cbh,['Normalized ',FOI_label{f},' C3-4 Coherence'],'FontSize',12)
                figtitle=sprintf('%s Coherence Matrix - %s Normalized',FOI_label{f},DOI{d});
            else
                ylabel(cbh,['C3-4 Coherence ',FOI_label{f}],'FontSize',12)
                figtitle=sprintf('%s Coherence Matrix - %s',FOI_label{f},DOI{d});
            end
        end
        cd(['~/nr_data_analysis/data_analyzed/eeg/gen_03/analysis_icoh/',datestr])
        figname=['nr_icoh_mat_sbj_all_elec_c3c4_',FOI_label{f},'_nonnorm_',datestr];
        %savefig(gcf,figname)
    end
end

%% iCoh C3-C4 phase diff

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
for f=2%1:numel(FOI_freq)
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
                [pass,pval]=ttest(plotdat(:),[ones(sum(idx),1);ones(sum(idx),1)*2]);
                
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
%         if savefigures
%             savefig(gcf,fullfile(iCohdiffc3_4Folder,figtitle));
%         end
    end
end
%cd(iCohdiffc3_4Folder)
           


