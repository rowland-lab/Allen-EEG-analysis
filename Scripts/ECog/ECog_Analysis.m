clear all
close all
clc

% Enter gitpath
gitpath='C:\Users\allen\Documents\GitHub\Allen-EEG-analysis';
cd(gitpath)
allengit_genpaths(gitpath,'ECoG')

data = TDTbin2mat('C:\Users\allen\Documents\ECoG_Data\pro00073545_0005\ecog\VR_POST_ALL');
