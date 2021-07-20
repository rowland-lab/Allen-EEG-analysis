function Session_positions=session_detect(trialData,VR_chan,tDCS_chan)
% Function to define session START and session END



%% Create figure
figure('units','normalized','outerposition',[0 0 1 1]);
hold on
try
    plot((trialData.eeg.data(:,1)-mean(trialData.eeg.data(:,1)))/std(trialData.eeg.data(:,1)))
    plot((trialData.eeg.data(:,VR_chan)-mean(trialData.eeg.data(:,VR_chan)))/std(trialData.eeg.data(:,VR_chan))-20)
    plot(((trialData.eeg.data(:,tDCS_chan)-mean(trialData.eeg.data(:,tDCS_chan)))/std(trialData.eeg.data(:,tDCS_chan))*-1)-40,'LineWidth',2)
    xlabel('Samples')
    ylabel('Z-score')
    legend('Fp1','VR','tDCS')
    title('PRESS START AND THEN END OF SESSION');
catch
    disp('ERROR,incorrect data structure: must use ''loadVrTrialData_EEG'' function to load edf structure')
    return
end

% display EEG notes
try
    for i=1:length(trialData.eeg.header.events.TYP)
        text(double(trialData.eeg.header.events.POS(i)),0,['\leftarrow', trialData.eeg.header.events.TYP{i}],'FontSize',11,'Rotation',90,'Color','blue')
    end
end

shg
clc

%% Define start and end of session
for i = 1:2
    shg
    if i==1
        disp(['Press START of Session '])
    else
        disp(['Press END of Session '])
    end
    [x, ~] = ginput(1);
    Session_info{i} = x;
end

disp('Selections completed')
close all

%% Export the positions obtained by the data cursor to the workspace

for i = 1:size(Session_info,2)
        Session_positions{i} = Session_info{i};
end

