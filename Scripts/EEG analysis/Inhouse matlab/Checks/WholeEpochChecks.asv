% Enter gitpath
gitpath='C:\Users\allen\Documents\GitHub\Allen-EEG-analysis';
cd(gitpath)

% Add EEG related paths
allengit_genpaths(gitpath,'EEG')
%%
subjectFolder='C:\Users\allen\Box Sync\Desktop\Allen_Rowland_EEG\protocol_00087153\pro00087153_0005';
subjectNumber='pro00087153_0005';

% Load S1 data
s1=load(fullfile(subjectFolder,'analysis','S1-VR_preproc',[subjectNumber,'_S1-VRdata_preprocessed.mat']));

% Load S3 data
s3=load(fullfile(subjectFolder,'analysis','S3-EEGanalysis','s3_dat.mat'));

% Designate epoch data
epochs=s3.epochs.epochsWhole;

% Define trials
trials=fieldnames(epochs);

% Phase labels
phase_label={'Hold','Prep','Move'};

% Create each trial w/ epochs
figure('WindowState','Maximized');
for t=1:numel(trials)
    nexttile
        
    % Sampling Frequency
    fs=s1.trialData.eeg.header.samplingrate;
    
    % Trial Start and End
    tStart=s1.trialData.vr(t).events.start.time*fs;
    tEnd=s1.trialData.vr(t).events.stop.time*fs;
    
    % Plot EEG
    plot(s1.trialData.eeg.data(:,7))
    xlim([tStart tEnd])
    hold on
    
    
    tempepoch=epochs.(trials{t});
    
    events=fieldnames(tempepoch);
    
    for p=1:numel(events)
        timeValues=tempepoch.(events{p}).val;
        for e=1:size(timeValues,1)
            yMax=max(s1.trialData.eeg.data(tStart:tEnd,7));
            yMin=min(s1.trialData.eeg.data(tStart:tEnd,7));
            l=line([timeValues(e,1) timeValues(e,2)],[yMax yMax]);
            sec=diff([timeValues(e,1) timeValues(e,2)])./fs;
            switch events{p}
                case 'atStartPosition'
                    txt=text(mean(l.XData),l.YData(1),sprintf('%uH %.1f(s)',e,round(sec,1)),'rotation',80);
                    l.Color='r';
                case 'cueEvent'
                    txt=text(mean(l.XData),l.YData(1),sprintf('%uP %.1f(s)',e,round(sec,1)),'rotation',80);
                    l.Color='b';
                case 'targetUp'
                    txt=text(mean(l.XData),l.YData(1),sprintf('%uM %.1f(s)',e,round(sec,1)),'rotation',80);
                    l.Color='g';
            end
        end
    end
    ylim([yMin txt.Position(2)*1.5])
    title(['Trial ',num2str(t),' [Total time=',num2str((tEnd-tStart)/fs),' seconds]']);
    ylabel('EEG signal')
    xlabel('Samples')
end
sgtitle(subjectNumber)
            