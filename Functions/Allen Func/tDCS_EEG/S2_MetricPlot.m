
function S2_MetricPlot (sbjnum,protocolfolder,threshold)

%% Assigned Variables
sbjname=['Subject-',extractAfter(sbjnum,'pro00087153_00')];

% Import S1 preprocessed data
try
    importdata = load(fullfile(protocolfolder,sbjnum,'analysis','S1-VR_preproc',[sbjnum,'_S1-VRdata_preprocessed.mat']));
catch
    error('Step 1 Preprocessing files NOT FOUND')
end
trialData.vr = importdata.trialData.vr;
trialData.sessioninfo=importdata.sessioninfo;

% initialize data folders
subjectfolder=trialData.sessioninfo.path.sbjfolder;
vrDataFolder=trialData.sessioninfo.path.vrfolder;

% Make analysis folder
metricsfolder=fullfile(subjectfolder,'analysis','S2-metrics');
mkdir(metricsfolder);

% Detect trials types
prestimtrials.label=[];
prestimtrials.num=[];
stimtrials.label=[];
stimtrials.num=[];
poststimtrials.label=[];
poststimtrials.num=[];
for i=1:length(trialData.vr)
    switch trialData.vr(i).information.stimulation
        case 1
            prestimtrials.label=[prestimtrials.label; {trialData.vr(i).information.trialName}];
            prestimtrials.num=[prestimtrials.num; i];
        case 2
            stimtrials.label=[stimtrials.label; {trialData.vr(i).information.trialName}];
            stimtrials.num=[stimtrials.num; i];
        case 3
            poststimtrials.label=[poststimtrials.label;{trialData.vr(i).information.trialName}];
            poststimtrials.num=[poststimtrials.num; i];
    end
end


% Bar graph vars
metricNames = {'movementDuration' 'reactionTime' 'handpathlength' 'avgVelocity' 'maxVelocity' 'velocityPeaks' 'timeToMaxVelocity' 'timeToMaxVelocity_n' 'avgAcceleration' 'maxAcceleration' 'accuracy' 'normalizedJerk' 'IOC'};
metricDescriptions = {'Reach Duration' 'Reaction Time' 'Hand Path Length' 'Average Velocity' 'Maximum Hand Velocity' 'Velocity Peaks' 'Time to Max Velocity' 'Time to Max Velocity - Normalized' 'Average Acceleration' 'Max Acceleration' 'Accuracy' 'Normalized Jerk' 'Index of Curvature'};
metricYlabel = {'time [s]' 'time [s]' 'hand path length[m]' 'Average Velocity [m/s]' '|V| [m/s]' 'peaks []' 'time [s]' '% movement []' 'Average Acceleration [m/s^2]' 'Max Acceleration [m/s^2]' 'accuracy score [1/mm]' 'normalized jerk []' 'IOC []' 'straight line distance[m]'};

%% Calculate data 

fh(1) = figure; % position
fh(2) = figure; % velocity magnitude

colorsnr.sham={'g'};
colorsnr.pre = {'k'};
colorsnr.stim = {'r'};
colorsnr.post = {'b'};
linestyle={'-','--',':','-.','-','--',':','-.'};

% Pre
for i=1:numel(prestimtrials.num)
    % load environment settings
    environmentFiles = dir(fullfile(vrDataFolder,prestimtrials.label{i},'environment *.xml'));
    if isempty(environmentFiles)
        return;
    end
    environmentFile = fullfile(vrDataFolder,prestimtrials.label{i},environmentFiles(1).name);
    environmentSettings = parseXML(environmentFile);
    environmentSettings = environmentSettings.Settings;

    % calculate vr metrics
    eval(['[vrMetrics_pre.t',num2str(prestimtrials.num(i)),',rejecttrials.pre{i},movementstart.pre{i}]= calculateVRMetrics(trialData.vr(prestimtrials.num(i)),environmentSettings,fh,string(colorsnr.pre),linestyle{i},1);'])
end


% Stim
for i=1:numel(stimtrials.num)
    % load environment settings
    environmentFiles = dir(fullfile(vrDataFolder,stimtrials.label{i},'environment *.xml'));
    if isempty(environmentFiles)
        return;
    end
    environmentFile = fullfile(vrDataFolder,stimtrials.label{i},environmentFiles(1).name);
    environmentSettings = parseXML(environmentFile);
    environmentSettings = environmentSettings.Settings;

    % calculate vr metrics
    if i==1
        eval(['[vrMetrics_stim.t',num2str(stimtrials.num(i)),',rejecttrials.stim{i},movementstart.stim{i}]= calculateVRMetrics(trialData.vr(stimtrials.num(i)),environmentSettings,fh,string(colorsnr.stim),linestyle{i},1);'])
    else
        eval(['[vrMetrics_stim.t',num2str(stimtrials.num(i)),',rejecttrials.stim{i},movementstart.stim{i}]= calculateVRMetrics(trialData.vr(stimtrials.num(i)),environmentSettings,fh,string(colorsnr.stim),linestyle{i},0);'])
    end
end

% Post
for i=1:numel(poststimtrials.num)
    % load environment settings
    environmentFiles = dir(fullfile(vrDataFolder,poststimtrials.label{i},'environment *.xml'));
    if isempty(environmentFiles)
        return;
    end
    environmentFile = fullfile(vrDataFolder,poststimtrials.label{i},environmentFiles(1).name);
    environmentSettings = parseXML(environmentFile);
    environmentSettings = environmentSettings.Settings;

    % calculate vr metrics
    if i==1
        eval(['[vrMetrics_post.t',num2str(poststimtrials.num(i)),',rejecttrials.post{i},movementstart.post{i}]= calculateVRMetrics(trialData.vr(poststimtrials.num(i)),environmentSettings,fh,string(colorsnr.post),linestyle{i},1);'])
    else
        eval(['[vrMetrics_post.t',num2str(poststimtrials.num(i)),',rejecttrials.post{i},movementstart.post{i}]= calculateVRMetrics(trialData.vr(poststimtrials.num(i)),environmentSettings,fh,string(colorsnr.post),linestyle{i},0);'])
    end
end
%%
figure(fh(1))
subplot(3,1,1)
h1 = plot(-1,0,'color',string(colorsnr.pre(1)));
h2 = plot(-1,0,'color',string(colorsnr.stim(1)));
h3 = plot(-1,0,'color',string(colorsnr.post(1)));
h1.LineWidth=1;
h2.LineWidth=1;
h3.LineWidth=1;
xlim([0 100])
legend([h1 h2 h3],{'Pre-stim','Stim','Post-stim'});
title('coordinates')
saveas(fh(2),fullfile(metricsfolder,'coordinates.jpeg'))


figure(fh(2))
h1 = plot(-1,0,'color',string(colorsnr.pre(1)));
h2 = plot(-1,0,'color',string(colorsnr.stim(1)));
h3 = plot(-1,0,'color',string(colorsnr.post(1)));
h1.LineWidth=1;
h2.LineWidth=1;
h3.LineWidth=1;
xlim([0 100])
legend([h1 h2 h3],{'Pre-stim','Stim','Post-stim'});
title('velocity')
saveas(fh(2),fullfile(metricsfolder,'velocity.jpeg'))


%% bar graphs
figure('units','normalized','outerposition',[0 0 1 1])
for i = 1:length(metricNames)
    
    % Organize Information
    v_pre=[];
    for z=1:numel(fieldnames(vrMetrics_pre))        
        fieldnames_pre=fieldnames(vrMetrics_pre);
        eval(['v_pre = [v_pre vrMetrics_pre.',fieldnames_pre{z},'.(metricNames{i})''];']);
    end

    v_stim=[];
    for z=1:numel(fieldnames(vrMetrics_stim))
        fieldnames_stim=fieldnames(vrMetrics_stim);
        eval(['v_stim = [v_stim vrMetrics_stim.',fieldnames_stim{z},'.(metricNames{i})''];']);
    end

    v_post=[];
    for z=1:numel(fieldnames(vrMetrics_post))
        fieldnames_post=fieldnames(vrMetrics_post);
        eval(['v_post = [v_post vrMetrics_post.',fieldnames_post{z},'.(metricNames{i})''];']);
    end
    
    temp_data={v_pre,v_stim,v_post};
    max_numel=max(cellfun(@(x) length(x),temp_data));
    bardata=nan(max_numel,size(v_pre,2)+size(v_stim,2)+size(v_post,2));
    for b=1:3
        switch b
            case 1
                for q=1:size(v_pre,2)
                    bardata(1:length(v_pre(:,q)),q)=v_pre(:,q);
                end
            case 2
                for q=1:size(v_stim,2)
                    bardata(1:length(v_stim(:,q)),q+size(v_pre,2))=v_stim(:,q);
                end
            case 3
                for q=1:size(v_post,2)
                    bardata(1:length(v_post(:,q)),q+size(v_pre,2)+size(v_stim,2))=v_post(:,q);
                end
        end
    end
    
    % Create bar graph
    subplot(2,7,i)
    bar([mean(v_pre,'omitnan') mean(v_stim,'omitnan') mean(v_post,'omitnan')],'FaceColor',[0.8 0.8 0.8]);
    hold on
    
    % Create error bars
    for z=1:size(bardata,2)
        err(:,z)=std(bardata(:,z),'omitnan')/sqrt(size(bardata(:,z),1));
    end

    er=errorbar(1:size(bardata,2),[mean(v_pre,'omitnan') mean(v_stim,'omitnan') mean(v_post,'omitnan')],err,err);
    er.Color = 'r';                          
    er.LineStyle = 'none';      
    
    % Test for normality
    normality=kstest(bardata(:));
    
    % Perform statistics
    if normality ==0
        [~,~,stats]=anova1(bardata,[],'off');
        pvalues=multcompare(stats,'Display','off');

        if any(le(pvalues(:,6),0.05))
           idx=find(le(pvalues(:,6),0.05));
           max_data=max(er.YData,[],'all');
           spacer=max_data*0.1;
           for m=1:numel(idx)
               l=line(pvalues(idx(m),1):pvalues(idx(m),2),(ones(size(pvalues(idx(m),1):pvalues(idx(m),2)))*max_data+m*spacer));
               set(l,'linewidth',2)
               text(mean([pvalues(idx(m),1) pvalues(idx(m),2)]),max_data+(m+.5)*spacer,string(pvalues(idx(m),6)))
               set(gca,'ylim',[0 max_data+(m+.5)*2*spacer])
           end
        end
    else
        [~,~,stats]=kruskalwallis(bardata,[],'off');
        pvalues=multcompare(stats,'Display','off');

        if any(le(pvalues(:,6),0.05))
           idx=find(le(pvalues(:,6),0.05));
           max_data=max(er.YData,[],'all');
           spacer=max_data*0.1;
           for m=1:numel(idx)
               l=line(pvalues(idx(m),1):pvalues(idx(m),2),ones(size(pvalues(idx(m),1):pvalues(idx(m),2)))*max_data+m*spacer);
               set(l,'linewidth',2)
               text(mean([pvalues(idx(m),1) pvalues(idx(m),2)]),max_data+(m+.5)*spacer,string(pvalues(idx(m),6)))
               set(gca,'ylim',[0 max_data+(m+.5)*2*spacer])
           end
        end
    end

    set(gca,'XTickLabel',importdata.sessioninfo.trialnames)
    xtickangle(-65)
    ylabel(metricYlabel{i})
    if normality == 0
        title([metricDescriptions{i},"one-way unpaired ANOVA test"])
    else
        title([metricDescriptions{i}," one-way Kruskal-Wallis test"])
    end
end
saveas(gcf,fullfile(metricsfolder,'metric bar graph.jpeg'))

%% Box plots
figure('units','normalized','outerposition',[0 0 1 1])
for i = 1:length(metricNames)
    
    % Organize Data
    v_pre=[];
    for z=1:numel(fieldnames(vrMetrics_pre))        
        fieldnames_pre=fieldnames(vrMetrics_pre);
        eval(['v_pre = [v_pre vrMetrics_pre.',fieldnames_pre{z},'.(metricNames{i})''];']);
    end

    v_stim=[];
    for z=1:numel(fieldnames(vrMetrics_stim))
        fieldnames_stim=fieldnames(vrMetrics_stim);
        eval(['v_stim = [v_stim vrMetrics_stim.',fieldnames_stim{z},'.(metricNames{i})''];']);
    end

    v_post=[];
    for z=1:numel(fieldnames(vrMetrics_post))
        fieldnames_post=fieldnames(vrMetrics_post);
        eval(['v_post = [v_post vrMetrics_post.',fieldnames_post{z},'.(metricNames{i})''];']);
    end

    temp_data={v_pre,v_stim,v_post};
    max_numel=max(cellfun(@(x) length(x),temp_data));
    boxdata=nan(max_numel,size(v_pre,2)+size(v_stim,2)+size(v_post,2));
    for b=1:3
        switch b
            case 1
                for q=1:size(v_pre,2)
                    boxdata(1:length(v_pre(:,q)),q)=v_pre(:,q);
                end
            case 2
                for q=1:size(v_stim,2)
                    boxdata(1:length(v_stim(:,q)),q+size(v_pre,2))=v_stim(:,q);
                end
            case 3
                for q=1:size(v_post,2)
                    boxdata(1:length(v_post(:,q)),q+size(v_pre,2)+size(v_stim,2))=v_post(:,q);
                end
        end
    end
    
    % Create box plot
    subplot(2,7,i)
    boxplot(boxdata);
    hold on
    for z=1:size(boxdata,2)
    plot(z*ones(size(boxdata,1)),boxdata(:,z),'ko');
        for k=1:size(boxdata,1)
            text(z+.05,boxdata(k,z), sprintf('%d',k));
        end
    end
    set(gca,'XTickLabel',importdata.sessioninfo.trialnames)
    xtickangle(-65)
    ylabel(metricYlabel{i})
    title(metricDescriptions{i})    
end

saveas(gcf,fullfile(metricsfolder,'metric box graph.jpeg'))

%% Detect bad trials based on outlier reaction time

% Organize data
v_pre=[];
for z=1:numel(fieldnames(vrMetrics_pre))        
    fieldnames_pre=fieldnames(vrMetrics_pre);
    eval(['v_pre = [v_pre vrMetrics_pre.',fieldnames_pre{z},'.reactionTime''];']);
end

v_stim=[];
for z=1:numel(fieldnames(vrMetrics_stim))
    fieldnames_stim=fieldnames(vrMetrics_stim);
    eval(['v_stim = [v_stim vrMetrics_stim.',fieldnames_stim{z},'.reactionTime''];']);
end

v_post=[];
for z=1:numel(fieldnames(vrMetrics_post))
    fieldnames_post=fieldnames(vrMetrics_post);
    eval(['v_post = [v_post vrMetrics_post.',fieldnames_post{z},'.reactionTime''];']);
end

temp_data={v_pre,v_stim,v_post};
max_numel=max(cellfun(@(x) length(x),temp_data));
reactiontimes=nan(max_numel,size(v_pre,2)+size(v_stim,2)+size(v_post,2));
for b=1:3
    switch b
        case 1
            for q=1:size(v_pre,2)
                reactiontimes(1:length(v_pre(:,q)),q)=v_pre(:,q);
            end
        case 2
            for q=1:size(v_stim,2)
                reactiontimes(1:length(v_stim(:,q)),q+size(v_pre,2))=v_stim(:,q);
            end
        case 3
            for q=1:size(v_post,2)
                reactiontimes(1:length(v_post(:,q)),q+size(v_pre,2)+size(v_stim,2))=v_post(:,q);
            end
    end
end
reactiontimes_rearrange=reactiontimes(:);


% Find outliers >threshold sec
rej_row_2=[];
rej_col_2=[];
[rej_row_2,rej_col_2]=find(reactiontimes>threshold);

% plot reaction time threshold
figure('units','normalized','outerposition',[0 0 1 1]);
boxplot(reactiontimes);
hold on
for z=1:size(reactiontimes,2)
plot(z*ones(size(reactiontimes,1)),reactiontimes(:,z),'ko');
    for k=1:size(reactiontimes,1)
        text(z+.05,reactiontimes(k,z), sprintf('%d',k));
    end
end

h1=plot([1 size(reactiontimes,2)],[2 2],'--');
legend([h1],{[num2str(threshold),' second']})
set(gca,'XTickLabel',importdata.sessioninfo.trialnames)
title('Rejected Trials')
saveas(gcf,fullfile(metricsfolder,'Rejected Trials Plot.jpeg'))

%% Remove bad trials and rerun stats

figure('units','normalized','outerposition',[0 0 1 1])
for i = 1:length(metricNames)
    subplot(2,7,i)

    v_pre=[];
    for z=1:numel(fieldnames(vrMetrics_pre))        
        fieldnames_pre=fieldnames(vrMetrics_pre);
        eval(['v_pre = [v_pre vrMetrics_pre.',fieldnames_pre{z},'.(metricNames{i})''];']);
    end

    v_stim=[];
    for z=1:numel(fieldnames(vrMetrics_stim))
        fieldnames_stim=fieldnames(vrMetrics_stim);
        eval(['v_stim = [v_stim vrMetrics_stim.',fieldnames_stim{z},'.(metricNames{i})''];']);
    end

    v_post=[];
    for z=1:numel(fieldnames(vrMetrics_post))
        fieldnames_post=fieldnames(vrMetrics_post);
        eval(['v_post = [v_post vrMetrics_post.',fieldnames_post{z},'.(metricNames{i})''];']);
    end
    

    if ~isempty(rej_col_2)
        for q=1:numel(rej_col_2)
            if ismember(rej_col_2(q),prestimtrials.num)
                precount=rej_col_2(q)==prestimtrials.num;
                v_pre(rej_row_2(q),precount)=nan;
            elseif ismember(rej_col_2(q),stimtrials.num)
                stimcount=rej_col_2(q)==stimtrials.num;
                v_stim(rej_row_2(q),stimcount)=nan;
            elseif ismember(rej_col_2(q),poststimtrials.num)
                poststimcount=rej_col_2(q)==poststimtrials.num;
                v_post(rej_row_2(q),poststimcount)=nan;
            end
        end
    end
    
    temp_data={v_pre,v_stim,v_post};
    max_numel=max(cellfun(@(x) length(x),temp_data));
    bardata=nan(max_numel,size(v_pre,2)+size(v_stim,2)+size(v_post,2));
    for b=1:3
        switch b
            case 1
                for q=1:size(v_pre,2)
                    bardata(1:length(v_pre(:,q)),q)=v_pre(:,q);
                end
            case 2
                for q=1:size(v_stim,2)
                    bardata(1:length(v_stim(:,q)),q+size(v_pre,2))=v_stim(:,q);
                end
            case 3
                for q=1:size(v_post,2)
                    bardata(1:length(v_post(:,q)),q+size(v_pre,2)+size(v_stim,2))=v_post(:,q);
                end
        end
    end

    normality=kstest(bardata(:));
    bar(mean(bardata,'omitnan'),'FaceColor',[0.8 0.8 0.8]);
    metricdat.data{i}=mean(bardata,'omitnan');
    metricdat.label{i}=metricNames{i};
    
    metricdatraw.data{i}=bardata;
    metricdatraw.label{i}=metricNames{i};
    
    hold on

    for z=1:size(bardata,2)
        err(:,z)=std(bardata(:,z),'omitnan')/sqrt(size(bardata(:,z),1)-sum(isnan(bardata(:,z))));
    end

    er=errorbar(1:size(bardata,2),mean(bardata,'omitnan'),err,err);
    er.Color = 'r';                          
    er.LineStyle = 'none';      

    if normality==0
        [~,~,stats]=anova1(bardata,[],'off');
        pvalues=multcompare(stats,'Display','off');

        if any(le(pvalues(:,6),0.05))
           idx=find(le(pvalues(:,6),0.05));
           max_data=max(er.YData,[],'all');
           spacer=max_data*0.1;
           for m=1:numel(idx)
               l=line(pvalues(idx(m),1):pvalues(idx(m),2),(ones(size(pvalues(idx(m),1):pvalues(idx(m),2)))*max_data+m*spacer));
               set(l,'linewidth',2)
               text(mean([pvalues(idx(m),1) pvalues(idx(m),2)]),max_data+(m+.5)*spacer,string(pvalues(idx(m),6)))
               set(gca,'ylim',[0 max_data+(m+.5)*2*spacer])
           end
        end
    else
        [~,~,stats]=kruskalwallis(bardata,[],'off');
        pvalues=multcompare(stats,'Display','off');

        if any(le(pvalues(:,6),0.05))
           idx=find(le(pvalues(:,6),0.05));
           max_data=max(er.YData,[],'all');
           spacer=max_data*0.1;
           for m=1:numel(idx)
               l=line(pvalues(idx(m),1):pvalues(idx(m),2),ones(size(pvalues(idx(m),1):pvalues(idx(m),2)))*max_data+m*spacer);
               set(l,'linewidth',2)
               text(mean([pvalues(idx(m),1) pvalues(idx(m),2)]),max_data+(m+.5)*spacer,string(pvalues(idx(m),6)))
               set(gca,'ylim',[0 max_data+(m+.5)*2*spacer])
           end
        end
    end

    set(gca,'XTickLabel',importdata.sessioninfo.trialnames)
    xtickangle(-65)
    ylabel(metricYlabel{i})
    if normality == 0
        title([metricDescriptions{i},"one-way unpaired ANOVA test"])
    else
        title([metricDescriptions{i}," one-way Kruskal-Wallis test"])
    end

    sgtitle([sbjname,' (Reject trials,>2 sec)'])
end
saveas(gcf,fullfile(metricsfolder,'metric bar graph reject, 2 sec.jpeg'))
saveas(gcf,fullfile(metricsfolder,'metric bar graph reject, 2 sec'),'epsc')


%% Remove rejected trials and save var

% Pre
for i=1:size(v_pre,2)
    reject_idx.pre{i}=find(isnan(v_pre(:,i)));
    t=prestimtrials.num(i);
    trialData.vr(t).events.atStartPosition.time(reject_idx.pre{i})=[];
    trialData.vr(t).events.cueEvent.time(reject_idx.pre{i})=[];
    trialData.vr(t).events.targetUp.time(reject_idx.pre{i})=[];
    trialData.vr(t).events.targetHit.time(reject_idx.pre{i})=[];
end

% Stim
for i=1:size(v_stim,2)
    reject_idx.stim{i}=find(isnan(v_stim(:,i)));
    t=stimtrials.num(i);
    trialData.vr(t).events.atStartPosition.time(reject_idx.stim{i})=[];
    trialData.vr(t).events.cueEvent.time(reject_idx.stim{i})=[];
    trialData.vr(t).events.targetUp.time(reject_idx.stim{i})=[];
    trialData.vr(t).events.targetHit.time(reject_idx.stim{i})=[];
end

% During
for i=1:size(v_post,2)
    reject_idx.post{i}=find(isnan(v_post(:,i)));
    t=poststimtrials.num(i);
    trialData.vr(t).events.atStartPosition.time(reject_idx.post{i})=[];
    trialData.vr(t).events.cueEvent.time(reject_idx.post{i})=[];
    trialData.vr(t).events.targetUp.time(reject_idx.post{i})=[];
    trialData.vr(t).events.targetHit.time(reject_idx.post{i})=[];
end


% Save Rejected trials
temp=struct2cell(reject_idx);
temp=[temp{:}];

temp2=struct2cell(rejecttrials);
temp2=[temp2{:}];

rej_temp=[temp;temp2];

lgx=cellfun(@any,rej_temp);
[y,trials]=find(lgx);

s2rejecttrials=[];
for i=1:numel(trials)
    temp=rej_temp{y(i),trials(i)};
    s2rejecttrials=[s2rejecttrials; [repmat(trials(i),size(temp,1),1),temp]];
end

save(fullfile(metricsfolder,[sbjnum,'_S2-Metrics']),'trialData','metricdat','s2rejecttrials','movementstart','metricdatraw');
close all
end