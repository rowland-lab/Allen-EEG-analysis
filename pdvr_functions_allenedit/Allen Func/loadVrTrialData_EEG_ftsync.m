function [trialData,VR_chan_auto] = loadVrTrialData_EEG_ftsync(vrDataFolder,eegDataFile,eegSyncChannels,manualSyncReview,VR_chan,FieldTripDir)

% Add FieldTrip
addpath(FieldTripDir);
ft_defaults

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
        
        % Read Data with FieldTrip
        cfg = [];
        cfg.continuous  = 'yes';
        cfg.dataset     = eegDataFile;
        data            = ft_preprocessing(cfg);

        
        eegData = data.trial{1, 1};
        eegData = eegData';
        
        % add time vector(s) to ecog data
        eegTime = (0:(size(eegData,1)-1)) * (1/data.hdr.Fs);
        eegTime = eegTime';
               
        % update flag
        eegLoaded = true;
        
        % save data to structure
        trialData.eeg.header = data.hdr;
        trialData.eeg.time = eegTime;
        trialData.eeg.data = eegData;
        trialData.eeg.channels = data.hdr.label;
    else
        disp('Invalid EEG data file.')
    end
    
end

%% c) sync data sets
if (vrLoaded && eegLoaded)
    
    % extract sync signal and timestamps
    eeg_time = trialData.eeg.time;
    
    eegSync1 = zeros(size(eeg_time));
    eegSync2 = zeros(size(eeg_time));
    snr1 = 0;
    snr2 = 0;
    
    sync_start = 1;
    if manualSyncReview
        if ~isempty(eegSyncChannels{1})
            eegSync1 = trialData.eeg.data(:,strcmpi(trialData.eeg.channels,eegSyncChannels{1}));
        end
        if ~isempty(eegSyncChannels{2})
            eegSync2 = trialData.eeg.data(:,strcmpi(trialData.eeg.channels,eegSyncChannels{2}));
        end
        
        fig = figure;
        plot(eeg_time,eegSync1,eeg_time,eegSync2)
        xlabel('time [s]')
        ylabel('EEG sync signals')
        title('Select correct sync signal start time')
        
        [t_start, ~] = ginput(1);
        sync_start = find(eeg_time>=t_start,1,'first');
        close(fig);
        
        if ~isempty(eegSyncChannels{1})
            eegSync1 = trialData.eeg.data(:,strcmpi(trialData.eeg.channels,eegSyncChannels{1}));
            [eegSync1, snr1] = processSyncSignal(eegSync1,trialData.eeg.header.Fs,sync_start);
            eegSync1 = movmean(eegSync1,round(trialData.eeg.header.Fs * 0.1));
        end
        if ~isempty(eegSyncChannels{2})
            eegSync2 = trialData.eeg.data(:,strcmpi(trialData.eeg.channels,eegSyncChannels{2}));
            [eegSync2, snr2] = processSyncSignal(eegSync2,trialData.eeg.header.Fs,sync_start);
            eegSync2 = movmean(eegSync2,round(trialData.eeg.header.Fs * 0.1));
        end

        if snr1>snr2
            eeg_TTLsync = eegSync1;
            VR_chan_auto=find(strcmpi(trialData.eeg.channels,eegSyncChannels{1}));
        else
            eeg_TTLsync = eegSync2;
            VR_chan_auto=find(strcmpi(trialData.eeg.channels,eegSyncChannels{2}));
        end
    else
        eegSync = trialData.eeg.data(:,VR_chan);
        [eegSync, ~] = processSyncSignal(eegSync,trialData.eeg.header.Fs);
        eegSync = movmean(eegSync,round(trialData.eeg.header.Fs * 0.1));
        eeg_TTLsync = eegSync;
    end
    
    
    trialData.eeg.sync = eeg_TTLsync;
    
    % threshold sync signal
    eeg_TTLsync(eeg_TTLsync<0.8) = 0; % sync signal goes from 0 to 1
    eeg_TTLsync(eeg_TTLsync>=0.8) = 1;
    
    % get sync signal onset and offset
    eeg_sync_onset = eeg_time(diff([0; eeg_TTLsync])>0);
    eeg_sync_offset = eeg_time(diff([eeg_TTLsync; 0])<0);
    
    % check timestamps
    if length(eeg_sync_onset) ~= length(eeg_sync_offset)
        error('Something looks wrong with the EEG sync signal. Could not syncronize EEG and VR data.')
    end
    
    eeg_available_ttl_pulses = 1:length(eeg_sync_onset);
    eeg_ttl_pulse_duration = eeg_sync_offset-eeg_sync_onset;
    
    for it = 1:length(trialData.vr)
               
        if isempty(trialData.vr(it).information)
            trialData.vr(it).sync.success = false;
            trialData.vr(it).sync.deltaT = [];
            continue
        end
        
        % get sync signal onset and offset
        vr_analogTime = trialData.vr(it).analog.time;
        vr_TTLsync = trialData.vr(it).analog.TTLsync;
        
        vr_digitalTime = trialData.vr(it).digital.time;
        vr_digitalSyncEvents = trialData.vr(it).digital.TTLsync;
        vr_digitalSync = zeros(size(vr_analogTime));
        for i = 1:length(vr_digitalTime)
            vr_digitalSync(vr_analogTime>=vr_digitalTime(i)) = vr_digitalSyncEvents(i);
        end
        
        analogOn = median(vr_TTLsync(vr_digitalSync>0));
        analogOff = median(vr_TTLsync(vr_digitalSync==0));
        vr_TTLsync = (vr_TTLsync-analogOff)/(analogOn-analogOff) * 5.0; % looks like the EEG amplifier has very low impedance on DC inputs, so the signal does not range from 0 to 5 anymore and needs to be adjusted
        
        vr_TTLsync(vr_TTLsync<2.5) = 0; % vr sync signal goes from 0 to 5
        vr_TTLsync(vr_TTLsync>2.5) = 1;
        
        vr_sync_onset = vr_analogTime(find(vr_TTLsync==1,1,'first')); % find onset of sync signal in vr time
        vr_sync_offset = vr_analogTime(find(vr_TTLsync==1,1,'last')); % find offset of sync signal in vr time
        
        % find matching pulse in eeg recording
        eeg_available_ttl_pulse_duration = eeg_ttl_pulse_duration(eeg_available_ttl_pulses);
        vr_ttl_pulse_duration = vr_sync_offset-vr_sync_onset;
        ind_candidates = find((abs(vr_ttl_pulse_duration-eeg_available_ttl_pulse_duration)<0.5));

        if ~isempty(ind_candidates)
            
            % get best eeg ttl pulse candidate
%             eeg_ttl_pulse_candidates = eeg_available_ttl_pulses(ind_candidates);
%             ttl_pulse_duration_difference = abs(vr_ttl_pulse_duration-eeg_available_ttl_pulse_duration(ind_candidates));
%             [~, imin] = min(ttl_pulse_duration_difference);
%             ind_selected_eeg_pulse = eeg_ttl_pulse_candidates(imin);

            ind_selected_eeg_pulse = eeg_available_ttl_pulses(ind_candidates(1));
            eeg_available_ttl_pulses(eeg_available_ttl_pulses == ind_selected_eeg_pulse) = [];
            
            
            % calculate delta T in seconds
            sync_deltaT = mean([eeg_sync_offset(ind_selected_eeg_pulse)-vr_sync_offset eeg_sync_onset(ind_selected_eeg_pulse)-vr_sync_onset]); % this deltaT will need to be added to the VR time
            
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
        else
            trialData.vr(it).sync.success = false;
            trialData.vr(it).sync.deltaT = [];
        end
    end
    
end

% auxiliary function to process sync signal
function [eegSync, snr] = processSyncSignal(eegSync,Fs,syncStart)

% When the sync signal is not included in the montage, it is set to zero.
% These data points need to be removed for proper synchronization

if nargin>=3
    eegSync(1:syncStart-1) = 0;
end

% remove spikes
s0 = abs(eegSync);
ns = round(Fs * 0.1);
sb = movmean(s0,[ns-1 0]);
sa = (movmean(s0,[0 ns])*(ns+1)-s0)/ns;
stb = movstd(s0,[ns-1 0]);

risingCandidate = sa-sb > 5 * stb;
fallingCandidate = sb-sa > 5 * stb;

risingCandidate(1:ns) = 0;
fallingCandidate(1:ns) = 0;

risingCandidateStart = find([0; diff(risingCandidate)]>0);
risingCandidateEnd = find(diff(risingCandidate)<0);
fallingCandidateStart = find([0; diff(fallingCandidate)]>0);
fallingCandidateEnd = find(diff(fallingCandidate)<0);

rising = NaN(1,length(risingCandidateStart));
falling = NaN(1,length(fallingCandidateStart));

for i = 1:length(risingCandidateStart)
    ind = risingCandidateStart(i):risingCandidateEnd(i);
    si = sa(ind)-sb(ind);
    [~, imax] = max(si);
    rising(i) = imax-1+ind(1);
end

for i = 1:length(fallingCandidateStart)
    ind = fallingCandidateStart(i):fallingCandidateEnd(i);
    si = sb(ind)-sa(ind);
    [~, imax] = max(si);
    falling(i) = imax-1+ind(1);
end

for i = 1:length(rising)
    
    r = rising(i);
    f = falling(find(falling>r,1,'first'));
    
    if (f-r)<Fs*10
        
        indDel = max(1,r-10):min(f+10,length(eegSync));
        indMed = max(1,r-ns):max(1,r-5);
        
        eegSync(indDel) = median(eegSync(indMed));
    end
    
end

% remove zeros (wrong montage)
eegSync(eegSync == 0) = NaN;

% cluster again, now with two clusters to find baseline and TTL pulse
% levels
w = warning ('off','all');
[idx,c] = kmeans(eegSync,2);
warning(w)

% find cluster centroid closest to median of signal - this will be a
% good approximation of the baseline
delta = abs(c-median(eegSync(~isnan(eegSync))));
[~, indBaseline] = min(delta);

% the other cluster is a good approximation of the TTL level
[~, indTTL] = max(delta);

% subtract baseline
eegSync = eegSync-c(indBaseline);
c = c - c(indBaseline);
eegSync(isnan(eegSync)) = 0;

% calculate signal to noise ratio
noise = std([eegSync(idx==indBaseline)-c(indBaseline); eegSync(idx==indTTL)-c(indTTL)]);
signal = abs(c(indTTL)-c(indBaseline));
snr = signal/noise;

% normalize by TTL level
eegSync = eegSync / c(indTTL);
