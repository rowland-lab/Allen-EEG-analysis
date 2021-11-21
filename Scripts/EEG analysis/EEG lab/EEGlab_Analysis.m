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
allengit_genpaths(gitpath)

%% Import data

calc_icoh=true;
calc_kin=true;
calc_power=false;

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
    
    if calc_icoh||calc_power
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
                if calc_power
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
        
        if calc_power
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


%% Linear Regression

TOI={'pre-stim (baseline)','intrastim (5 min)','intrastim (15 min)','post-stim (5 min)'};
FOI_label={'Beta'};
FOI_freq={{13,30}};
phases={'Hold','Prep','Reach'};
DOI={'stroke','healthy'};
stimtypes=[0,2];
stimname={'Sham','Stim'};
mean_calc=false;

% iCoh vs Acceleration
count_ax=1;
ax=[];
for f=1:numel(FOI_freq)
    figure('Name','iCoh vs Acceleration')
    for t=1:numel(TOI)
        for p=1:numel(phases)
            ax(count_ax)=subplot(numel(TOI),numel(phases),p+(t-1)*numel(phases));
            count_ax=count_ax+1;
            hold on
            
            tempcoh=[];
            tempdisease=[];
            tempstim=[];
            tempacc=[];
            for s=1:size(sbj)
                
                % Calculate coherence
                sbjicoh=subjectData(s).iCoh;
                label_idx=all(strcmp(sbjicoh.label,'C3')+strcmp(sbjicoh.label,'C4'),2);
                FOI_idx=sbjicoh.freq>=FOI_freq{f}{1} & sbjicoh.freq<=FOI_freq{f}{2};
                TOI_idx=strcmp(subjectData(s).sessioninfo.trialnames,TOI{t});
                if mean_calc
                    tempcoh(s,1)=mean(mean(sbjicoh.data(label_idx,FOI_idx,:,p,TOI_idx),2,'omitnan'),3,'omitnan');
                else
                    tempcoh{s,1}=permute(mean(sbjicoh.data(label_idx,FOI_idx,:,p,TOI_idx),2,'omitnan'),[3 2 1]);
                end
                
                % Organize disease
                tempdisease{s,1}=subjectData(s).sessioninfo.dx;
                
                % Organize stim
                tempstim(s,1)=subjectData(s).sessioninfo.stimamp;
                
                % Calculate acceleration
                templabel=strcmp(subjectData(s).kinematics.label,'avgAcceleration');
                if mean_calc
                    tempacc(s,1)=mean(subjectData(s).kinematics.data{templabel}(:,TOI_idx),'omitnan');
                else
                    tempacc{s,1}=subjectData(s).kinematics.data{templabel}(:,TOI_idx);
                end
            end
            
            clear l r pval
            count=1;
            legendlabels=[];
            for d=1:numel(DOI)
                for s=1:numel(stimtypes)
                    idx=strcmp(tempdisease,DOI{d})&tempstim==stimtypes(s);
                    
                    % organize data
                    hold on
                    if mean_calc
                        xdat=tempcoh(idx);
                        ydat=tempacc(idx);
                    else
                        xdat=cat(1,tempcoh{idx});
                        ydat=cat(1,tempacc{idx});
                        
                        % Remove Nan
                        rmidx=isnan(xdat)|isnan(ydat);
                        xdat(rmidx)=[];
                        ydat(rmidx)=[];
                    end
                    
                    
                    % Scatter plot
                    h=scatter(xdat,ydat);
                    if stimtypes(s)==0
                        tempcolor=h.CData;
                        h.Marker='+';
                        linestyle='--';
                    else
                        h.CData=tempcolor;
                        h.Marker='o';
                        linestyle='-';
                    end
                    
                    % Plot trendline
                    pv = polyfit(xdat, ydat, 1);
                    px = [min(xdat) max(xdat)];
                    py = polyval(pv, px);
                    l(count)=plot(px, py, 'LineWidth', 2,'Color',h.CData,'LineStyle',linestyle);
                    
                    
                    % Calculate p and r
                    [r,pval]=corrcoef(xdat, ydat);
                    
                    % Save p and r value
                    rval=r(2,1);
                    pval=pval(2,1);
                    
                    legendlabels{count}=sprintf('%s %s [p(%g),r(%g)]',DOI{d},stimname{s},pval,rval);
                    count=count+1;
                end
            end
            legend(l,legendlabels)
            if mean_calc
                ylabel('MEAN Average Acceleration (m/s^2)')
                xlabel([FOI_label{f},' Mean Imaginary Coherence'])
            else
                ylabel('Individual Reach Average Acceleration (m/s^2)')
                xlabel([FOI_label{f},' Individual Reach Imaginary Coherence'])
            end
            title([TOI{t},'--',phases{p}]);
        end
    end
end
linkaxes(ax)

%% Coherence matrix

TOI={'pre-stim (baseline)','intrastim (5 min)','intrastim (15 min)','post-stim (5 min)'};
phases={'Hold','Prep','Reach'};
DOI={'stroke','healthy'};
stimtypes=[0,2];
stimname={'Sham','Stim'};
electrodes={'F7','T3','T5','O1','F3','C3','P3','A1','Fz','Cz','Fp2','F8','T4','T6','O2','F4','C4','P4','A2','Pz','Fp1'};
norm=true;

for d=1:numel(DOI)
    figure
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
                tempcoh=mean(mean(sbjicoh.data(:,FOI_idx,:,p,TOI_idx),2,'omitnan'),3,'omitnan');
                tempmatcoh=nan(numel(electrodes));
                for i=1:numel(tempcoh)
                    templabel=sbjicoh.label(i,:);
                    tempmatcoh(strcmp(templabel{1},electrodes),strcmp(templabel{2},electrodes))=tempcoh(i);
                    tempmatcoh(strcmp(templabel{2},electrodes),strcmp(templabel{1},electrodes))=tempcoh(i);
                    
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
                imagesc(imagescDat,[0 1])
                
                colormap jet
                xticks([1:numel(electrodes)])
                xticklabels(electrodes)
                yticks([1:numel(electrodes)])
                yticklabels(electrodes)
                title(phases{p})
                subtitle(stimname{s})
                ylabel(TOI{t})
            end
        end
        
        
        %             tempax=subplot(numel(TOI)+1,numel(phases)*numel(stimtypes),[numel(TOI)*numel(phases)*numel(stimtypes)+1 (numel(TOI)+1)*numel(phases)*numel(stimtypes)]);
        %             c=colorbar;
    end
    cbh = colorbar(h(end));
    cbh.Location='layout';
    cbh.Position=[.9314 .11 .0281 .8150];
    ylabel(cbh,'Coherence','FontSize',12)
    if norm
        ylabel(cbh,'Normalized Coherence','FontSize',12)
    else
        ylabel(cbh,'Coherence','FontSize',12)
    end
end

