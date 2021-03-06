function [tdcs_detect,Session_times,VR_sig] = nr_tdcsdetect_02(trialData,VR_chan,tDCS_chan,vrfolder,Session_positions)
%TDCSDETECT detects when 
% tdcs_chan = entire EEG data from tDCS channel
% start = the starting sample number of the experiment (start of analysis)
% finish = the ending sample number of the experiment (end of analysis)
% tdcs_start = tDCS ramp up (begining, end)
% tdcs_end = tDCS ramp down(begining, end)


% % Define session position using session_detect function
% Session_positions=session_detect(trialData,VR_chan,tDCS_chan);

% Detect VR
Session_data=trialData.eeg.data(Session_positions{1}:Session_positions{2},VR_chan);
if mean(Session_data)<0
    Session_data=Session_data*-1;
end
[RowNrs,~]=find(Session_data>mean([min(Session_data(Session_data>=0)),max(Session_data)]));
[Row,~]=find(diff(RowNrs)>1000);

VR_sig(1,1)=RowNrs(1);
for i=1:numel(Row)
    VR_sig(i,2)=RowNrs(Row(i));
    VR_sig(i+1,1)=RowNrs(Row(i)+1);
end
VR_sig(end)=RowNrs(end);
VR_sig=VR_sig+Session_positions{1};


% Find which VR signal match trials
times=[];
for vr=1:numel(vrfolder)
    tempxml=readtable(fullfile(vrfolder{vr},'Events.csv'));
    times(vr,1)=tempxml.Time(end)*trialData.eeg.header.samplingrate;
end
vrsiglength=num2cell(diff(VR_sig,1,2));

tolerance=0.01; % default tolerance
step=0.001; % default step
x=1;
while x==1
vrsiglog= cellfun(@(x) ismembertol(x,times,tolerance),vrsiglength,'UniformOutput',false);
vrsiglog=cell2mat(vrsiglog);
if numel(vrfolder)==sum(vrsiglog)
x=2;
elseif tolerance>100
figure;
plot(trialData.eeg.data(:,VR_chan))
hold on
scatter(VR_sig(:),ones(numel(VR_sig),1)*mean(Session_data))
error('error')
elseif numel(vrfolder)<sum(vrsiglog)
tolerance=tolerance-step
elseif numel(vrfolder)>sum(vrsiglog)
tolerance=tolerance+step
end
end

VR_sig=VR_sig(vrsiglog,:);

% Detect tDCS times
if var(trialData.eeg.data(Session_positions{1}:Session_positions{2},tDCS_chan))>50000
    tdcsdata=trialData.eeg.data(Session_positions{1}:Session_positions{2},tDCS_chan)*-1;
    thres=0.10*max(tdcsdata);
    tdcson=find(tdcsdata>thres);
    tdcs_times=[tdcson(1) tdcson(end)];
    tdcs_times=tdcs_times+Session_positions{1};
else
    tdcs_times=nan;
    disp('tDCS signal within channel NOT detected, change channel or session does not contain tDCS sync')
end

% Save as output vars
tdcs_detect=tdcs_times;
Session_times=Session_positions;
end