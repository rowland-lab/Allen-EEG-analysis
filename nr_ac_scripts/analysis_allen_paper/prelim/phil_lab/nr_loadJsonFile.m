function data = loadJsonFile(filename)

% initialize data
data = [];

if nargin<1 || isempty(filename)
    % ask user to select file
    [filename, filepath] = uigetfile('*.json','Select JSON file to import');
    if filename == 0
        return
    end
    
    filename = fullfile(filepath,filename);
end

% check if file exists
if ~exist(filename,'file')
    return
end

% open file
fid = fopen(filename,'r');

% read file
contents = fread(fid);

% close file
fclose(fid);

% convert to string
contents = char(contents');

% decode json file
data = jsondecode(contents);