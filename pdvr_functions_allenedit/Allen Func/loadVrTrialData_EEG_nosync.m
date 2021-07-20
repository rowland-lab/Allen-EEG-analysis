function [trialData,VR_chan_auto] = loadVrTrialData_EEG_nosync(vrDataFolder,eegDataFile,eegSyncChannels,manualSyncReview,VR_chan)

% initialize output structure
trialData = [];
trialData.vr = [];
trialData.eeg = [];

% initialize flags
vrLoaded = false;
eegLoaded = false;

% default eeg folder (if not specified)
if nargin<2
    eegDataFile = [];
end

% default sync channels
if nargin<3
    eegSyncChannels = {[] []};
end

% default sync review flag
if nargin<4
    manualSyncReview = false;
    VR_chan=[];
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
        environmentFile = fullfile(vrDataFolder{it},dir(fullfile(vrDataFolder{it},'environment*')).name);
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
            
            % load environment
            environment.settings = parseXML(environmentFile);
            environment.type = extractBefore(dir(fullfile(vrDataFolder{it},'environment*')).name,'.xml');
            
            % save data to structure
            trialData.vr(it).information = trialInformation;
            trialData.vr(it).tracker = trackerData;
            trialData.vr(it).analog = analogData;
            trialData.vr(it).digital = digitalData;
            trialData.vr(it).events = events;
            trialData.vr(it).environment = environment;
        else
            [~, trialName] = fileparts(vrDataFolder{it});
            disp([trialName ': Invalid VR data folder or incomplete folder contents.'])
        end
        
    end
end

%% b) load EEG data

% skip if not specified
if ~isempty(eegDataFile)
    
    % make sure vr data folder is valid
    if exist(eegDataFile,'file')
        [eegData, edfHdr] = lab_read_edf(eegDataFile);
        eegData = eegData';
        
        % add time vector(s) to ecog data
        eegTime = (0:(size(eegData,1)-1)) * (1/edfHdr.samplingrate);
        eegTime = eegTime';
        
        % add event times
        if isfield(edfHdr,'events')
            edfHdr.events.TIME = double(edfHdr.events.POS) * (1/edfHdr.samplingrate);
        end
        
        % create list of data channels
        channels = cell(1,size(edfHdr.channels,1));
        for i=1:length(channels)
            channels{i} = strtrim(edfHdr.channels(i,:));
        end
        
        % update flag
        eegLoaded = true;
        
        % save data to structure
        trialData.eeg.header = edfHdr;
        trialData.eeg.time = eegTime;
        trialData.eeg.data = eegData;
        trialData.eeg.channels = channels;
    else
        disp('Invalid EEG data file.')
    end
    
end

%% c) sync data sets
if (vrLoaded && eegLoaded)
    
    eegHeader=trialData.eeg.header;
    sessionStartSync=(eegHeader.hour*60+eegHeader.minute)*60+eegHeader.second;
    
    for tr = 1:length(trialData.vr)
        tStart=extractAfter(trialData.vr(tr).information.collectionStartTime,' ');
        tStartHour=str2double(extractBefore(tStart,':'));
        tStartMinute=str2double(extractBetween(tStart,':',':'));
        tStartSecond=str2double(extractAfter(tStart,6));
        tStartSync=(tStartHour*60+tStartMinute)*60+tStartSecond;      
        
        tEnd=extractAfter(trialData.vr(tr).information.collectionEndTime,' ');
        tEndHour=str2double(extractBefore(tEnd,':'));
        tEndMinute=str2double(extractBetween(tEnd,':',':'));
        tEndSecond=str2double(extractAfter(tEnd,6));
        tEndSync=(tEndHour*60+tEndMinute)*60+tEndSecond;
        
        trialData.vr(tr).events.sync=(tStartSync-sessionStartSync)*trialData.eeg.header.samplingrate;
    end
    
end
