allengit_genpaths('C:\Users\allen\Documents\GitHub\Allen-EEG-analysis','tDCS')


% Enter in protocol folder
protocolfolder='C:\Users\allen\Box Sync\Desktop\Allen_Rowland_EEG\protocol_00087153';

% Detect subjects
sbj=dir(fullfile(protocolfolder,'pro000*.'));
sbj={sbj.name}';

sbj_label=extractAfter(sbj,'pro00087153_00');

% Create fig folder
figfolder=fullfile('C:\Users\allen\Box Sync\Desktop\Allen_Rowland_EEG\protocol_00087153','groupanalysis','VR');;

% Make group power folder
mkdir(figfolder);
%% Group VR data

for sub=1:numel(sbj)
    
    wk_sbjfolder=fullfile(protocolfolder,sbj{sub});
    
    % Load S1 Data
    s1_file=fullfile(wk_sbjfolder,'analysis','S1-VR_preproc',[sbj{sub},'_S1-VRdata_preprocessed.mat']);
    if exist(s1_file)==0
        disp(['Preprocessing file is missing on ',sbj{sub}]);
        continue
    end
    disp(['Loading s1 data...',sbj{sub}]);
    s1_dat=load(fullfile(wk_sbjfolder,'analysis','S1-VR_preproc',[sbj{sub},'_S1-VRdata_preprocessed.mat']));
    sessioninfo=s1_dat.sessioninfo;
    
    % Load S2 data
    disp(['Loading s2 data...',sbj{sub}]);
    s2_dat=load(fullfile(wk_sbjfolder,'analysis','S2-metrics',[sbj{sub},'_S2-Metrics.mat']));
    temp_metric=s2_dat.metricdat;
    
    % Save VR data
    disp(['Calculating VR metrics...',sbj{sub}]);

    metricdat.data(sub,:)=temp_metric.data;
    metricdat.label=temp_metric.label;
    metricdat.dx{sub,1}=sessioninfo.dx;
    metricdat.trial(sub,:)=sessioninfo.trialidx;
    metricdat.stim(sub,:)=sessioninfo.stimamp;
    metricdat.units={'time [s]' 'hand path length[m]' 'Average Velocity [m/s]' '|V| [m/s]' 'peaks []' 'time [s]' '% movement []' 'Average Acceleration [m/s^2]' 'Max Acceleration [m/s^2]' 'accuracy score [1/mm]' 'normalized jerk []' 'IOC []' 'straight line distance[m]'};
end

%% Plot Metric data (average)

dx_type={'stroke','pd','healthy'};
stim_type={0,2};
metric_measures=metricdat.label;
norm=false;

clear vars shamdat stimdat

for d=1
    
    % Create figure
    figure;
    
    for measure=1:numel(metric_measures)
        bardat=nan(10,2);
        inputmat=[];
        between_factors=[];
        for stim=1:numel(stim_type)

            % Obtain dx idx
            dx_idx=strcmp(metricdat.dx,dx_type{d});

            % Obtain stim idx
            stim_idx=metricdat.stim==stim_type{stim};

            % Subject Idx
            subj_idx=dx_idx&stim_idx;
            
            % Subject names
            subjectnames=sbj_label(subj_idx);

            % Obtain measure data
            tempmetricdat=metricdat.data(subj_idx,measure);

            if norm
                for i=1:size(tempmetricdat,1)
                    tempmetricdat{i}=(tempmetricdat{i}-tempmetricdat{i}(1))./tempmetricdat{i}(1)*100;
                end
            end


            % Obtain trial data
            temptrial=metricdat.trial(subj_idx,:);

            % Allocate tempdat
            tempdat=nan(sum(subj_idx),7);

            % Reorganize based on trial times
            for s=1:size(tempmetricdat,1)

                % Trial idx
                temptrialidx=~cellfun(@isempty,temptrial(s,:));

                % Save tempdat
                tempdat(s,temptrialidx)=tempmetricdat{s};
            end
            
            % only take base, intra 5, intra 15, post 5,
            tempdat=tempdat(:,[1:3 5]);
            
            % Find mean
            tempmean=mean(tempdat,1);
            
            % Find SEM
            sem=std(tempdat,[],1)./sqrt(sum(~isnan(tempdat)));
            
            % Plot line
            subplot(2,6,measure)
            hold on
            x=ones(size(tempdat)).*(1:size(tempdat,2));
            y=tempdat;
            sc=scatter(x(:),y(:));
            
            % Change base on color
            if stim==1
                sc.Marker='x';
                sc.MarkerEdgeColor='r';
                ersham=errorbar(tempmean,sem);
                ersham.Color='r';
                ersham.LineWidth=1;
                shamnum=size(tempdat,1);
                inputmat=[inputmat;tempdat];
                between_factors=[between_factors;ones(size(tempdat,1),1)];
            else
                sc.Marker='o';
                sc.MarkerEdgeColor='g';
                erstim=errorbar(tempmean,sem);
                erstim.Color='g';
                erstim.LineWidth=1;
                stimnum=size(tempdat,1);
                inputmat=[inputmat;tempdat];
                between_factors=[between_factors;2*ones(size(tempdat,1),1)];
            end
        end
                
        % Run Mixed Anova
        [tbl,rm]=simple_mixed_anova(inputmat,between_factors,{'Time'},{'Modality'});
%         tbl = mauchly(rm)
        
        % Save structure
        shamdat{measure}=[inputmat(between_factors==1,:) nan(sum(between_factors==1),1)];
        stimdat{measure}=[inputmat(between_factors==2,:) nan(sum(between_factors==2),1)];
        
        % Compare stim vs sham
        Mrm1 = multcompare(rm,'Modality','By','Time','ComparisonType','bonferroni');
        
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
        
        set(gca,'XLim',[0 5],'XTick',[1 2 3 4],'XTickLabel',{'BL','ES','LS','PT'})
        title([metricdat.label{measure}])
        if norm
            ylabel('Percent Change from Baseline')
        else
            ylabel(metricdat.units{measure})
        end
    end
    
    legend([ersham erstim],{['Sham (n=',num2str(shamnum),')'],['Stim (n=',num2str(stimnum),')']},'Orientation','vertical')
    
    % Title figure
    sgtitle(dx_type{d})
end

stimdat_con=[stimdat{:}];
shamdat_con=[shamdat{:}];

%% Plot Metric data (individual)

dx_type={'stroke','pd','healthy'};
stim_type={0,2};
metric_measures=metricdat.label;
norm=false;

for d=1:numel(dx_type)
    
    
    % Create figure
    figure;
    
    for measure=1:numel(metric_measures)
        bardat=nan(10,2);
        sbjlegendnames=[];
        for stim=1:numel(stim_type)

            % Obtain dx idx
            dx_idx=strcmp(metricdat.dx,dx_type{d});

            % Obtain stim idx
            stim_idx=metricdat.stim==stim_type{stim};

            % Subject Idx
            subj_idx=dx_idx&stim_idx;

            % Obtain measure data
            tempmetricdat=metricdat.data(subj_idx,measure);

            if norm
                for i=1:size(tempmetricdat,1)
                    tempmetricdat{i}=(tempmetricdat{i}-tempmetricdat{i}(1))./tempmetricdat{i}(1)*100;
                end
            end

            % Obtain trial data
            temptrial=metricdat.trial(subj_idx,:);

            % Allocate tempdat
            tempdat=nan(sum(subj_idx),7);

            % Reorganize based on trial times
            for s=1:size(tempmetricdat,1)

                % Trial idx
                temptrialidx=~cellfun(@isempty,temptrial(s,:));

                % Save tempdat
                tempdat(s,temptrialidx)=tempmetricdat{s};
            end
            
            % only take base, intra 5, intra 15, post 5,
            tempdat=tempdat(:,[1:3 5]);
            
            % Plot line
            subplot(2,6,measure)
            hold on
            x=ones(size(tempdat)).*(1:size(tempdat,2));
            y=tempdat;
            
            % Change base on color
            if stim==1
                plot(x',y','--x','LineWidth',2)
                sbjlegendnames=[sbjlegendnames;sbj_label(subj_idx)];
            else
                plot(x',y','-o','LineWidth',2)
                sbjlegendnames=[sbjlegendnames;sbj_label(subj_idx)];
            end  
        end
        set(gca,'XLim',[0 5],'XTick',[1 2 3 4],'XTickLabel',{'BL','ES','LS','PT'})
        title([metricdat.label{measure}])
        if norm
            ylabel('Percent Change from Baseline')
        else
            ylabel(metricdat.units{measure})
        end
    end
    
    legend(sbjlegendnames,'Orientation','vertical')
    
    % Title figure
    sgtitle(dx_type{d})
end

%% Linear regress

dx_type={'stroke','pd','healthy'};
stim_type={0,2};
metric_measures=metricdat.label;
comparisons=[6 10;3 10];
timepoints={'Baseline','Early-Stim','Late-Stim','Post-Stim'};

for d=1:numel(dx_type)
    for comp=1:size(comparisons,1)
        % Create figure
        figure;
        
        % Obtain dx idx
        dx_idx=strcmp(metricdat.dx,dx_type{d});

        % Obtain stim parameters
        stim_para=metricdat.stim(dx_idx);

        % Obtain measure data
        m1=metricdat.data(dx_idx,comparisons(comp,1));
        m2=metricdat.data(dx_idx,comparisons(comp,2));

        % Obtain trial data
        temptrial=metricdat.trial(dx_idx,:);

        % Allocate tempdat
        tempdat1=nan(sum(dx_idx),7);
        tempdat2=nan(sum(dx_idx),7);

        % Reorganize based on trial times
        for s=1:size(m1,1)

            % Trial idx
            temptrialidx=~cellfun(@isempty,temptrial(s,:));

            % Save tempdat
            tempdat1(s,temptrialidx)=m1{s};
            tempdat2(s,temptrialidx)=m2{s};
        end

        % only take base, intra 5, intra 15, post 5,
        tempdat1=tempdat1(:,[1:3 5]);
        tempdat2=tempdat2(:,[1:3 5]);

        % Lin reg times
        for t=1:size(tempdat1,2)
            subplot(1,size(tempdat1,2),t)
            hold on
            for stim=1:numel(stim_type)
                stim_idx=stim_para==stim_type{stim};                
                sc=scatter(tempdat1(stim_idx,t),tempdat2(stim_idx,t));
                p=polyfit(tempdat1(stim_idx,t),tempdat2(stim_idx,t),1);
                f=polyval(p,tempdat1(stim_idx,t));
                [rval,pval]=corrcoef(tempdat1(stim_idx,t),tempdat2(stim_idx,t));
                if stim==1
                    sc.Marker='x';
                    sc.MarkerEdgeColor='r';
                    shamp=plot(tempdat1(stim_idx,t),f,'r');
                    rsham=rval(1,2);
                    psham=pval(1,2);
                else
                    sc.Marker='o';
                    sc.MarkerEdgeColor='g';
                    stimp=plot(tempdat1(stim_idx,t),f,'g');
                    rstim=rval(1,2);
                    pstim=pval(1,2);
                end
                ylabel(metric_measures{comparisons(comp,2)})
                xlabel(metric_measures{comparisons(comp,1)})
            end
            title(timepoints{t})
            p=polyfit(tempdat1(:,t),tempdat2(:,t),1);
            f=polyval(p,tempdat1(:,t));
            [rval,pval]=corrcoef(tempdat1(:,t),tempdat2(:,t));
            rtot=rval(1,2);
            ptot=pval(1,2);
            totp=plot(tempdat1(:,t),f,'b');
            legend([shamp stimp totp],{['Sham (p=',num2str(psham),',r=',num2str(rsham),')'],['Stim (p=',num2str(pstim),',r=',num2str(rstim),')'],['Combined (p=',num2str(ptot),',r=',num2str(rtot),')']})
        end
    end
end



%%
dx_type={'stroke','pd','healthy'};
stim_type={0,2};
metric_measures=metricdat.label;
norm='true';

for d=1:numel(dx_type)
    
    % Create figure
    figure;

    % Title figure
    sgtitle(dx_type{d})
    
    for measure=1:numel(metric_measures)
        bardat=nan(10,2);
        for stim=1:numel(stim_type)

            % Obtain dx idx
            dx_idx=strcmp(metricdat.dx,dx_type{d});

            % Obtain stim idx
            stim_idx=metricdat.stim==stim_type{stim};

            % Subject Idx
            subj_idx=dx_idx&stim_idx;

            % Obtain measure data
            tempmetricdat=metricdat.data(subj_idx,measure);

            if norm
                for i=1:size(tempmetricdat,1)
                    tempmetricdat{i}=(tempmetricdat{i}-tempmetricdat{i}(1))./tempmetricdat{i}(1)*100;
                end
            end


            % Obtain trial data
            temptrial=metricdat.trial(subj_idx,:);

            % Allocate tempdat
            tempdat=nan(sum(subj_idx),7);

            % Reorganize based on trial times
            for s=1:size(tempmetricdat,1)

                % Trial idx
                temptrialidx=~cellfun(@isempty,temptrial(s,:));

                % Save tempdat
                tempdat(s,temptrialidx)=tempmetricdat{s};
            end
            
            % only take post 5
            bardat(1:numel(tempdat(:,5)),stim)=tempdat(:,5);
        end
        
        % Prep Bar data
        tempmean=mean(bardat,1,'omitnan');
        sem=[];
        for i=1:size(bardat,2)
            sem(i)=std(bardat(:,i),[],1,'omitnan')./sqrt(sum(~isnan(bardat(:,i))));
        end
        
        % Bar plot
        subplot(2,6,measure)
        hold on
        b=bar(tempmean);
        erstim=errorbar(b.XData,tempmean,sem,'LineStyle','none');
        
        % t-test
        [h,p,ci,stats] = ttest2(bardat(:,1),bardat(:,2));
        
        
        title([metricdat.label{measure},' (p=',num2str(p),')'])
    end
end