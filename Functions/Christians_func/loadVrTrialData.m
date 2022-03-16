function trialData = loadVrTrialData(vrDataFolder,ecogDataFolder)

% initialize output structure
trialData = [];
trialData.vr = [];
trialData.ecog = [];

% initialize flags
vrLoaded = false;
ecogLoaded = false;

% default ecog folder (if not specified)
if nargin<2
    ecogDataFolder = [];
end

%% a) load VR data

% skip if not specified
if ~isempty(vrDataFolder)
    
    if ~iscell(vrDataFolder)
        vrDataFolder = {vrDataFolder};
    end
    
    for it = 1:length(vrDataFolder)
        
        % make sure vr data folder is valid and contains all data files
        trialInformationFile = fullfile(vrDataFolder{it},'trial information.xml');
        trackerDataFile = fullfile(vrDataFolder{it},'Data.csv');
        analogDataFile = fullfile(vrDataFolder{it},'AnalogIn.csv');
        digitalDataFile = fullfile(vrDataFolder{it},'DigitalOut.csv');
        eventDataFile = fullfile(vrDataFolder{it},'Events.csv');
        if exist(vrDataFolder{it},'dir') && exist(trialInformationFile,'file') && exist(trackerDataFile,'file') && exist(analogDataFile,'file') && exist(digitalDataFile,'file') && exist(eventDataFile,'file')
            
            % load trial information
            xmlStruct = parseXML(trialInformationFile);
            trialInformation = xmlStruct.TrialInformation;
            
            % load data
            trackerData = loadVrTrackerData(trackerDataFile);
            analogData = loadVrAnalogData(analogDataFile);
            digitalData = loadVrDigitalData(digitalDataFile);
            
            % load events
            events = loadVrEvents(eventDataFile);
            
            % update flag
            vrLoaded = true;
            
            % save data to structure
            trialData.vr(it).information = trialInformation;
            trialData.vr(it).tracker = trackerData;
            trialData.vr(it).analog = analogData;
            trialData.vr(it).digital = digitalData;
            trialData.vr(it).events = events;
        else
            disp('Invalid VR data folder or incomplete folder contents.')
        end
        
    end
end

%% b) load ECoG data

% skip if not specified
if ~isempty(ecogDataFolder)
    
    % make sure vr data folder is valid
    if exist(ecogDataFolder,'dir')
        ecogData = TDTbin2mat(ecogDataFolder);
        
        % add time vector(s) to ecog data
        streamNames = fieldnames(ecogData.streams);
        for i = 1:length(streamNames)
            fs = ecogData.streams.(streamNames{i}).fs; % sampling rate
            t0 = ecogData.streams.(streamNames{i}).startTime; % start time
            n = size(ecogData.streams.(streamNames{i}).data,2); % number of samples
            
            t = t0 + (0:(n-1)) * (1/fs);
            ecogData.streams.(streamNames{i}).time = t;
        end
        
        % update flag
        ecogLoaded = true;
        
        % save data to structure
        trialData.ecog = ecogData;
    else
        disp('Invalid ECoG data folder.')
    end
    
end

%% c) sync data sets
if (vrLoaded && ecogLoaded)
    
    % extract sync signal and timestamps
    ecog_time = trialData.ecog.streams.Sync.time';
    ecog_TTLsync = double(trialData.ecog.streams.Sync.data');
    
    % threshold sync signal
    ecog_TTLsync(ecog_TTLsync<0.5) = 0; % ecog sync signal goes from 0 to 1
    ecog_TTLsync(ecog_TTLsync>0.5) = 1;
    
    % get sync signal onset and offset
    ecog_sync_onset = ecog_time(diff([0; ecog_TTLsync])>0);
    ecog_sync_offset = ecog_time(diff([ecog_TTLsync; 0])<0);
    
    % check timestamps
    if length(ecog_sync_onset) ~= length(ecog_sync_offset)
        error('Something looks wrong with the ECoG sync signal. Could not syncronize ECoG and VR data.')
    end
    
    for it = 1:length(trialData.vr)
        
        % check if trial data was loaded
        if isempty(trialData.vr(it).information)
            trialData.vr(it).sync.success = false;
            trialData.vr(it).sync.deltaT = [];
            continue
        end
        
        % check if the trial can be synched
        if it>length(ecog_sync_onset)
            trialData.vr(it).sync.success = false;
            trialData.vr(it).sync.deltaT = [];
            continue
        end
        
        % get sync signal onset and offset
        vr_analogTime = trialData.vr(it).analog.time;
        vr_TTLsync = trialData.vr(it).analog.TTLsync;
        
        vr_TTLsync(vr_TTLsync<2.5) = 0; % vr sync signal goes from 0 to 5
        vr_TTLsync(vr_TTLsync>2.5) = 1;
        
        vr_sync_onset = vr_analogTime(find(vr_TTLsync==1,1,'first')); % find onset of sync signal in vr time
        vr_sync_offset = vr_analogTime(find(vr_TTLsync==1,1,'last')); % find offset of sync signal in vr time
        
        % calculate delta T in seconds
        sync_deltaT = mean([ecog_sync_offset(it)-vr_sync_offset ecog_sync_onset(it)-vr_sync_onset]); % this deltaT will need to be added to the VR time
        
        % add offset to VR timestamps
        trialData.vr(it).tracker.time = trialData.vr(it).tracker.time + sync_deltaT;
        trialData.vr(it).analog.time = trialData.vr(it).analog.time + sync_deltaT;
        trialData.vr(it).digital.time = trialData.vr(it).digital.time + sync_deltaT;
        
        eventFields = fieldnames(trialData.vr(it).events);
        for i = 1:length(eventFields)
            trialData.vr(it).events.(eventFields{i}).time = trialData.vr(it).events.(eventFields{i}).time + sync_deltaT;
        end
        
        trialData.vr(it).sync.success = true;
        trialData.vr(it).sync.deltaT = sync_deltaT;
        
    end
    
end
