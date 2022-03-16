function digitalData = loadVrDigitalData(digitalFile)

digitalData = [];

% check existence of file
if ~exist(digitalFile,'file')
    return
end

% import data
d = importdata(digitalFile);

if ~isfield(d,'colheaders')
    d.colheaders = strsplit(d.textdata{1},',');
end

% store data
digitalData.time = d.data(:,strcmp(d.colheaders,'Time'));

digitalData.TTLsync = d.data(:,strcmp(d.colheaders,' TTLsyncOut'));
digitalData.DBStrigger = d.data(:,strcmp(d.colheaders,' DBStriggerOut'));