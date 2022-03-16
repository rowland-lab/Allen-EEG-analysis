function analogData = loadVrAnalogData(analogFile)

analogData = [];

% check existence of file
if ~exist(analogFile,'file')
    return
end

% import data
d = importdata(analogFile);

if ~isfield(d,'colheaders')
    d.colheaders = strsplit(d.textdata{1},',');
end

% store data
analogData.time = d.data(:,strcmp(d.colheaders,'Time'));

analogData.samplingRate = mean(1./diff(analogData.time));
analogData.nSamples = size(d.data,1);

analogData.TTLsync = d.data(:,strcmp(d.colheaders,' TTLsyncIn'));
analogData.DBStrigger = d.data(:,strcmp(d.colheaders,' DBStriggerIn'));
