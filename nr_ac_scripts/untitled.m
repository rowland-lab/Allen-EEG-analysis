nr_ac_eeg_anal_ser_outlier_analysis_v01b(sbjfolder,plot_ind,scroll,save_outliers,freq_band,version)

%sbjfolder='~/nr_data_analysis/data_analyzed/eeg/gen_03/data/pro00087153_0003'
sbjfind=strfind(sbjfolder,'pro');
sbjname=sbjfolder(sbjfind:sbjfind+15);
% plot_ind='yes'
% scroll='yes'
% save_outliers='yes'
% freq_band='gamma'

nr_ac_eeg_anal_ser_outlier_analysis_v01b('~/nr_data_analysis/data_analyzed/eeg/gen_03/data/pro00087153_0003',...
'no','yes','no','beta','e')