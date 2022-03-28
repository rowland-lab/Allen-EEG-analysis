nr_ac_eeg_anal_ser_outlier_analysis_v01a('~/nr_data_analysis/data_analyzed/eeg/gen_02/data/pro00087153_0003')

nr_ac_eeg_anal_ser_outlier_analysis_v01b('~/nr_data_analysis/data_analyzed/eeg/gen_02/data/pro00087153_0020','no','yes','no')

nr_ac_eeg_anal_ser_outlier_analysis_v01b('~/nr_data_analysis/data_analyzed/eeg/gen_02/data/pro00087153_0043','no','yes','no')

nr_ac_eeg_anal_ser_ind_freq_plots_v01a('cs')

nr_ac_eeg_anal_ser_ind_freq_plots_v01a('cs','beta','no','yes')

nr_ac_eeg_anal_ser_ind_freq_plots_v01b('hc','beta','yes','yes')

nr_ac_eeg_anal_ser_sum_freq_plots_v01b('hc','beta','~/nr_data_analysis/data_analyzed/eeg/gen_02/data/hc_mean_mean_beta_all.mat','yes','yes')

nr_ac_eeg_anal_ser_lin_reg_v01c('hc_non','beta','~/nr_data_analysis/data_analyzed/eeg/gen_02/data/hc_mean_mean_sum_beta_all.mat','yes','yes')
%for this function, just load the appropriate variable based on the group
%or you stand a chance of loading the wrong one, also later you will want
%to plot either uncorrected or corrected

% sum fig using epochsWhole

%%%THIS CAN OBVIOUSLY BE OPTIMIZED BY MAKING A FOR LOOP FOR STM VS NON
%%%(AND IPSI VS CONTRA WITHIN EACH


%questions for allen
%in the metricdat variable, are these the averages of all 12 reaches? what
%if some reaches were excluded?

%tomorrow



if all that checks out then you are ready to move on to the sum script
    
    it occurs to me that there are at least 6 patterns
    
    starts low, goes up diuring both then back down
    opposite, starts high goes down during both then back up (28)
    can start low, go high during 1st then down for both
    opposite
    many others, maybe you can count these up and give impression as to what the dominant pattern is
    
   
%% whats needed to finish the analysis

perhaps the very first thing to do is to have a normalized option on your script before trying a bunch
of diff freq bands bc you will have less to check - right now will just check beta


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
don't forget to analyze control experiments
1) person at rest no blinking
2) person blinking at regular interval
3) move cords, stand up
4) imaginary movement




go over rest of one notes for allen


%questions for allen
%we should maybe plot the acceleration curves next to the line plot and
%show how the two groups differ

questions for paper
do responses differ by individual? YES!!
can there be diff freq bands for diff phases - hold,aplha - prep, theta - move,beta
does tdcs preferentially affects only beta in cs
does beta have a special role in cs or does it act same as in hc (can look at rest and t1 epochs)
can beta predict kinematic performance?

to be able to look at individual reach metrics, have to use latest version of s2metric plot

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













           






    