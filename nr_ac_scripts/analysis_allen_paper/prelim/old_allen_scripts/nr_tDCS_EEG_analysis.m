clc
clear all
close all

Rowland_start

% Enter in protocol folder
% protocolfolder='C:\Box Sync\Allen_Rowland_EEG\protocol_00087153';
% protocolfolder='C:\Users\allen\Box Sync\Desktop\Allen_Rowland_EEG\protocol_00087153';
%protocolfolder='~/Downloads';
protocolfolder='~/nr_data_analysis/data_analyzed/eeg/gen_02/data';
% Detect subjects
sbj=dir(fullfile(protocolfolder,'pro000*'));
sbj={sbj.name}';

%% Run code

% Preprocessing --> S1_VR_trial_preproc(sbjnum,protocolfolder,vr_chan,tdcs_chan)
for i=[1]
    nr_S1_VR_trial_preproc_02(sbj{i},protocolfolder)
end   

% Metric Plots --> S2_MetricPlot (sbjnum,protocolfolder)
for i=[1]       %31:numel(sbj)
    nr_S2_MetricPlot_02(sbj{i},protocolfolder,2)
end

% % Reconstruction --> S2B_Reconstruction(sbjnum,protocolfolder,positionalplot,eegplot,tfplot,trial_num)
% for i=26:numel(sbj)
%     nr_S2B_Reconstruction(sbj{i},protocolfolder,false,false,false,[4])
% end

% EEG Analysis --> S3_EEGanalysis(sbjnum,protocolfolder)%depends on parts 1
% and 2
for i=[1]        %31:numel(sbj)
    nr_S3_EEGanalysis_02(sbj{i},protocolfolder)
end

%use this instead
for i=[20]        %31:numel(sbj)
    nr_S3_EEGanalysis_03(sbj{i},protocolfolder,128,0.5,128,false)%will look different for 42 and 43 bc sampled at diff freq
    %tried to correct for this but defaults to 2Hz resolution so just left
    %it
end
%,window,nooverlap,nfft,manual

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

