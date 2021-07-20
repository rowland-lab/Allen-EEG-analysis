function events = loadVrEvents(eventsFile)

events = [];

% check existence of file
if ~exist(eventsFile,'file')
    return
end

% import data
fileContents = {};
fid = fopen(eventsFile,'r');
eof = false;
while ~eof
    str = fgetl(fid);
    if str==-1
        eof = true;
    else
        fileContents = [fileContents; {str}];
    end
end
fclose(fid);

% extract columns
time = zeros(length(fileContents)-1,1);
systemDateNum = zeros(length(fileContents)-1,1);
eventName = cell(length(fileContents)-1,1);
eventDataString = cell(length(fileContents)-1,1);

for i = 1:length(fileContents)-1
    
    % divide string into parts
    stringParts = strsplit(fileContents{i+1},',');
    
    % get time
    time(i) = str2double(stringParts{1});
    
    % get system date number
    systemDateNum(i) = datenum(stringParts{2});
    
    % get event name
    eventName(i) = stringParts(3);
    
    % get event data
    eventDataString(i) = stringParts(4);
end

%% extract event data

eventData = cell(length(eventName),1);
for i = 1:length(eventName)
    
    switch eventName{i}
        
        case 'atStartPosition'
            eventData{i}.hand = eventDataString{i};
            
        case 'waitingForCue'
            eventData{i}.waitTime = str2double(eventDataString{i});
            
        case 'waitingForGo'
            eventData{i}.waitTime = str2double(eventDataString{i});
            
        case 'targetUp'
            stringParts = strsplit(eventDataString{i},'/');
            eventData{i}.cueNumber = str2double(stringParts{1}(2:end));
            eventData{i}.targetNumber = str2double(stringParts{2}(2:end));
            eventData{i}.targetLocation = str2double(stringParts{3});
            
            % extract position or location
            if stringParts{3}(1)=='P'
                positionString = strsplit(stringParts{3}(2:end),'|');
                position = str2double(positionString);
                
                eventData{i}.targetLocation = 1;
                eventData{i}.targetPosition = position;
            else
                eventData{i}.targetLocation = str2double(stringParts{3});
                eventData{i}.targetPosition = [];
            end
            
        case 'targetHit'
            stringParts = strsplit(eventDataString{i},'/');
            eventData{i}.cueNumber = str2double(stringParts{1}(2:end));
            eventData{i}.targetNumber = str2double(stringParts{2}(2:end));
            eventData{i}.targetLocation = str2double(stringParts{3});
            eventData{i}.hand = stringParts{4};
            
        otherwise
            eventData{i} = [];
    end
    
end

%% extract relevant events

% all events
events.all.time = time;
events.all.systemDateNum = systemDateNum;
events.all.name = eventName;
events.all.data = eventData;
events.all.all(:,1)=eventName;
events.all.all(:,2)=num2cell(time);

% separate events
uniqueEventNames = {'start' 'stop' 'waitingForHandAtStartPosition' 'atStartPosition' 'waitingForCue' 'cueEvent' 'waitingForGo' 'goEvent' 'targetUp' 'targetHit' 'taskEnd' 'outsideStartPosition'};
for i = 1:length(uniqueEventNames)
    
    eventInd = find(strcmp(eventName,uniqueEventNames{i}));
    events.(uniqueEventNames{i}).time = time(eventInd);
    events.(uniqueEventNames{i}).systemDateNum = systemDateNum(eventInd);
    
    events.(uniqueEventNames{i}).data = [];
    for j = 1:length(eventInd)
        events.(uniqueEventNames{i}).data = [events.(uniqueEventNames{i}).data; eventData{eventInd(j)}];
    end
    
end


