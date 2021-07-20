clc
clear all
close all

Rowland_start

% Enter in protocol folder
% protocolfolder='C:\Box Sync\Allen_Rowland_EEG\protocol_00087153';
protocolfolder='C:\Users\allen\Box Sync\Desktop\Allen_Rowland_EEG\protocol_00087153';

% Detect subjects
sbj=dir(fullfile(protocolfolder,'pro000*.'));
sbj={sbj.name}';

%% Run code

% Preprocessing --> S1_VR_trial_preproc(sbjnum,protocolfolder,vr_chan,tdcs_chan)
for i=1:numel(sbj)
    S1_VR_trial_preproc(sbj{i},protocolfolder)
end

% Metric Plots --> S2_MetricPlot (sbjnum,protocolfolder)
for i=31:numel(sbj)
    S2_MetricPlot(sbj{i},protocolfolder)
end

% Reconstruction --> S2B_Reconstruction(sbjnum,protocolfolder,positionalplot,eegplot,tfplot,trial_num)
for i=26:numel(sbj)
    S2B_Reconstruction(sbj{i},protocolfolder,false,false,false,[4])
end

% EEG Analysis --> S3_EEGanalysis(sbjnum,protocolfolder)
for i=1:numel(sbj)
    S3_EEGanalysis(sbj{i},protocolfolder)
end

%% Extra Code
% EEG Analysis --> S4_FieldTripPreProc(sbj,protocolfolder)
% for i=20:numel(sbj)
for i=29:numel(sbj)
    S4_FieldTripPreProc(sbj{i},protocolfolder)
end

% EEG Analysis --> S5_Coherence(subject,protocolfolder)
for i=29:numel(sbj)
    S5_Coherence(sbj{i},protocolfolder)
end

