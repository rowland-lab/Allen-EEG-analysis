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
















           






    