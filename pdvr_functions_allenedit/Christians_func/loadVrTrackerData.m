function trackerData = loadVrTrackerData(dataFile)

trackerData = [];

% check existence of file
if ~exist(dataFile,'file')
    return
end

% import data
d = importdata(dataFile);

if ~isfield(d,'colheaders')
    d.colheaders = strsplit(d.textdata{1},',');
end

if size(d.data,2)<length(d.colheaders)
   n =  length(d.colheaders)-size(d.data,2);
   d.data = [d.data NaN(size(d.data,1),n)];
end

% store data
trackerData.time = d.data(:,strcmp(d.colheaders,'Time'));

trackerData.samplingRate = mean(1./diff(trackerData.time));
trackerData.nSamples = size(d.data,1);

trackerData.p.left = [d.data(:,strcmp(d.colheaders,'LeftHandX')) d.data(:,strcmp(d.colheaders,'LeftHandY')) d.data(:,strcmp(d.colheaders,'LeftHandZ'))];
trackerData.p.right = [d.data(:,strcmp(d.colheaders,'RightHandX')) d.data(:,strcmp(d.colheaders,'RightHandY')) d.data(:,strcmp(d.colheaders,'RightHandZ'))];

trackerData.v.left = [d.data(:,strcmp(d.colheaders,'LeftHandVX')) d.data(:,strcmp(d.colheaders,'LeftHandVY')) d.data(:,strcmp(d.colheaders,'LeftHandVZ'))];
trackerData.v.right = [d.data(:,strcmp(d.colheaders,'RightHandVX')) d.data(:,strcmp(d.colheaders,'RightHandVY')) d.data(:,strcmp(d.colheaders,'RightHandVZ'))];

trackerData.a.left = [d.data(:,strcmp(d.colheaders,'LeftHandAX')) d.data(:,strcmp(d.colheaders,'LeftHandAY')) d.data(:,strcmp(d.colheaders,'LeftHandAZ'))];
trackerData.a.right = [d.data(:,strcmp(d.colheaders,'RightHandAX')) d.data(:,strcmp(d.colheaders,'RightHandAY')) d.data(:,strcmp(d.colheaders,'RightHandAZ'))];

trackerData.q.left = [d.data(:,strcmp(d.colheaders,'LeftHandQX')) d.data(:,strcmp(d.colheaders,'LeftHandQY')) d.data(:,strcmp(d.colheaders,'LeftHandQZ')) d.data(:,strcmp(d.colheaders,'LeftHandQW'))];
trackerData.q.right = [d.data(:,strcmp(d.colheaders,'RightHandQX')) d.data(:,strcmp(d.colheaders,'RightHandQY')) d.data(:,strcmp(d.colheaders,'RightHandQZ')) d.data(:,strcmp(d.colheaders,'RightHandQW'))];

trackerData.omega.left = [d.data(:,strcmp(d.colheaders,'LeftHandOmegaX')) d.data(:,strcmp(d.colheaders,'LeftHandOmegaY')) d.data(:,strcmp(d.colheaders,'LeftHandOmegaZ'))];
trackerData.omega.right = [d.data(:,strcmp(d.colheaders,'RightHandOmegaX')) d.data(:,strcmp(d.colheaders,'RightHandOmegaY')) d.data(:,strcmp(d.colheaders,'RightHandOmegaZ'))];

trackerData.alpha.left = [d.data(:,strcmp(d.colheaders,'LeftHandAlphaX')) d.data(:,strcmp(d.colheaders,'LeftHandAlphaY')) d.data(:,strcmp(d.colheaders,'LeftHandAlphaZ'))];
trackerData.alpha.right = [d.data(:,strcmp(d.colheaders,'RightHandAlphaX')) d.data(:,strcmp(d.colheaders,'RightHandAlphaY')) d.data(:,strcmp(d.colheaders,'RightHandAlphaZ'))];

% head position
trackerData.p.head = [d.data(:,strcmp(d.colheaders,'HeadX')) d.data(:,strcmp(d.colheaders,'HeadY')) d.data(:,strcmp(d.colheaders,'HeadZ'))];
trackerData.q.head = [d.data(:,strcmp(d.colheaders,'HeadQX')) d.data(:,strcmp(d.colheaders,'HeadQY')) d.data(:,strcmp(d.colheaders,'HeadQZ')) d.data(:,strcmp(d.colheaders,'HeadQW'))];