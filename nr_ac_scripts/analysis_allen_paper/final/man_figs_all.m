% DONE next check every single subject for gen_02
% DONE then check again with gen_03
% DONE then check your outlier scripts
% DONE then do summary scripts
% then linear regressions for both epochsWhole and vrevents
% for lr you should consider:
% using change in beta between transitions
% putting all corrected p values in a single matrix so they can be sorted
% REMEMBER TO REMOVE ALLEN'S REJECTED TRIALS!!
% then repeat for alpha and gamma
% then coherenece with beta, alpha, gamma
%then go all the way back and repeat for flex-ex and imaginary movement
%need to look at post10 and post15
%then you are done
% you will need topoplots (eeglab) and spectrograms (fieldtrip)
%you will need claudia's figure of mri's and she needs to make a table

%if the question comes up about how to filter the eeg based on beta power
%you should look at the functions nr_eeg_anal_05_replot_data_orig,
%nr_eeg_anal_06_epochs_new and nr_eeg_anal_07_psd_stats_new. I am going to
%put them in the prelim folder for now but they look like pretty powerful
%functions and might even provide a methods figure if you need it

%try using a highpass filter for your data to see if you get same results
%but without having to re-epoch
%also try bandpass filtering for just beta - you should do this and look at
%raw data 

%%%%Just thought of a great idea, just simply plot the accelerometer
%%%%signals during flexion and extension!!!!!!

%you will HAVE to repeat all this for delta through gamma bc you have to
%prove that the tdcs effect is SPECIFIC to beta and no other freq band
%UNLESS each individual has a specific frequency band

% 7) try z-scoring, common average referencing

%then can do reactivity % do reactivity - beta desync and beta resync

% don't forget to analyze control experiments
% 1) person at rest no blinking
% 2) person blinking at regular interval
% 3) move cords, stand up
% 4) imaginary movement

% questions for paper
% do responses differ by individual? YES!!
% can there be diff freq bands for diff phases - hold,aplha - prep, theta - move,beta
% does tdcs preferentially affects only beta in cs
% does beta have a special role in cs or does it act same as in hc (can look at rest and t1 epochs)
% can beta predict kinematic performance?

things to include in paper
tractography
ROAST
CONN
FMA 
MRI structural
reconstructions



questions for future study
5 things that could potentially get changed by tdcs
accuracy
speed
path
strength (grip?)
fine motor skills

include oculogram next time?

%don;t forget to analyze 10 and 15 minute epochs for those that have them
% see if velocity curves correlate with FMA scores
%make sure the number of rejected trials did not differ between groups


%1) spot check a couple of the lin reg plots - just look up the metrics as well as the beta power values
%2) spot check a couple of the lin reg plot p-values with spss
%3) double check the fdr code
consider subtracting the trials to generate reactivity data - look at beta desync and resync
DUDE you totally forgot to check REST epochs!!! could mahybe just look at these vs move epochs
could in fact compare rest vs cued move vs rest vs flex/ext (non-cued move)
DUDE you totally forgot to look at flexion/extension
you also forgot to check imagined movement epochs!!!
%4) finish analysis above with delta, theta, alpha and low gamma (this is
%with the minimally processed eeg)
think about how this ca     n be used with Irene's pca code, perhaps try kmeans
%2) repeat #1 with beta-filtered eeg (and if that shows something then will
%have to filter the others as well)
%3) repeat #1 above with gsvd filtered
%4 at some point, will need to check all these with at least two
%normalization schemes - % and z-scoring
should you try common average referencing
you never tried the sum figures with repeated measures anova
consider whether testing for normality is needed
%don;t forget to analyze 10 and 15 minute epochs for those that have them
in terms of rejected trials, make sure they did not differ between groups
also make sure each phase h,p,m have same number of rejections





go over rest of one notes for allen


%questions for allen
%we should maybe plot the acceleration curves next to the line plot and
%show how the two groups differ



to be able to look at individual reach metrics, have to use latest version of s2metric plot

