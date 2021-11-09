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
%% Organize data
heartdat=[];
heart=[];
rcmp=[];
badchannels=[];
ASRrmvIdx=[];
for s=1:numel(sbj)
    try
        tempdata=load(fullfile(protocolfolder,sbj{s},'analysis','EEGlab','EEGlab_Total.mat'));
        temptrials=tempdata.eegevents_icarem.trials  ;
    catch
        disp(['Unable to load EEGlab_icarem for subject',sbj{s}])
        continue
    end
    
    sessioninfo=tempdata.eegevents_icarem.trials.t1.sessioninfo;    
    trials_idx=find(~cellfun(@isempty,sessioninfo.trialidx));

    trial_names=fieldnames(tempdata.eegevents_ft.trials);
    for t=1:numel(trial_names)
        temptrialData=temptrials.(trial_names{t});
        
        heart{s}{trials_idx(t)}=temptrialData.heart;
        rcmp{s}{trials_idx(t)}=temptrialData.rcmp;
        badchannels{s}{trials_idx(t)}=temptrialData.badChannels;
        ASRrmvIdx{s}{trials_idx(t)}=temptrialData.ASRrmvIdx;
    end
end

%% Analyze Heart

% Remove empty cells
heart(cellfun(@isempty,heart))=[];
rcmp(cellfun(@isempty,rcmp))=[];
for i=1:numel(heart)
    heart{i}(cellfun(@isempty,heart{i}))=[];
    rcmp{i}(cellfun(@isempty,rcmp{i}))=[];
    if any(~cellfun(@isstruct,rcmp{i}))
        rmidx=~cellfun(@isstruct,rcmp{i});
        heart{i}(rmidx)=[];
        rcmp{i}(rmidx)=[];
    end
end



% Extract Heart data
data=[];
zScore=[];
idx=[];
coh=[];
rcmp_dat=[];
for i=1:numel(heart)
    data=[data cellfun(@(x) x.heart_data,heart{i},'UniformOutput',false)];
    coh=[coh cellfun(@(x) x.coh,heart{i},'UniformOutput',false)];
    idx=[idx cellfun(@(x) x.idx,heart{i},'UniformOutput',false)];
    zScore=[zScore cellfun(@(x) x.zScore,heart{i},'UniformOutput',false)];
    rcmp_dat=[rcmp_dat cellfun(@(x) x.data(:),rcmp{i},'UniformOutput',false)];
end

figure
for i=1:numel(data)
    nexttile
    hold on
    plot(zscore(data{i}),'-r')
    plot(zscore(rcmp_dat{i}),'-g')
    title(sprintf('Coh (%f)',coh{i}))
    subtitle(sprintf('Idx (%d) - Zscore(%f)',idx{i},zScore{i}))
    xlim([0 1000])
end
    
%% Analyze Bad Channels

% Remove empty cells
badchannels(cellfun(@isempty,badchannels))=[];
for i=1:numel(badchannels)
    badchannels{i}(cellfun(@isempty,badchannels{i}))=[];
end

% Extract Bad channels
badcn=[];
orgcndata=[];
intercndata=[];

for i=1:numel(heart)
    badcn=[badcn cellfun(@(x) x.channels,badchannels{i},'UniformOutput',false)];
end
badcn=vertcat(badcn{:});
histogram(badcn,'BinWidth',1)
xticks([1:22])

