%% HC STIM
%24
%rest
nr_eeg_anal_02_cfg('~/nr_data_analysis/data_raw/eeg/pro00087153_0024.edf','hc','stim','rest')
nr_eeg_anal_03_epochs(data,1.65e6,1.8e6,2.68e6,2.72e6,3.2e6,3.28e6,3.8e6,3.9e6)
nr_eeg_anal_04_psd_stats(data,'rest')

%move
nr_eeg_anal_02_cfg('~/nr_data_analysis/data_raw/eeg/pro00087153_0024.edf','hc','stim')
nr_eeg_anal_03_epochs(data,2.19e6,2.24e6,2.91e6,2.95e6,3.48e6,3.53e6,4.16e6,4.26e6)
nr_eeg_anal_04_psd_stats(data,'move')

%25
%rest
nr_eeg_anal_02_cfg('~/nr_data_analysis/data_raw/eeg/pro00087153_0025.edf','hc','stim')
nr_eeg_anal_03_epochs(data,1.8e6,1.86e6,2.68e6,2.72e6,3.26e6,3.27e6,3.91e6,3.98e6)
nr_eeg_anal_04_psd_stats(data,'rest')

%move
nr_eeg_anal_02_cfg('~/nr_data_analysis/data_raw/eeg/pro00087153_0025.edf','hc','stim')
nr_eeg_anal_03_epochs(data,2.26e6,2.3e6,2.88e6,2.94e6,3.5e6,3.55e6,4.14e6,4.19e6)
nr_eeg_anal_04_psd_stats(data,'move')

%26
%rest
nr_eeg_anal_02_cfg('~/nr_data_analysis/data_raw/eeg/pro00087153_0026.edf','hc','stim','rest')
nr_eeg_anal_03_epochs(data,1.8e6,1.9e6,2.56e6,2.59e6,3.07e6,3.09e6,4.0e6,4.1e6)
nr_eeg_anal_04_psd_stats(data,'rest')

%move
nr_eeg_anal_02_cfg('~/nr_data_analysis/data_raw/eeg/pro00087153_0026.edf','hc','stim')
nr_eeg_anal_03_epochs(data,2.35e6,2.41e6,2.98e6,3.02e6,3.6e6,3.65e6,4.28e6,4.33e6)
nr_eeg_anal_04_psd_stats(data,'move')

%29
%rest
nr_eeg_anal_02_cfg('~/nr_data_analysis/data_raw/eeg/pro00087153_0029.edf','hc','stim')
nr_eeg_anal_03_epochs(data,2.05e6,2.15e6,3.15e6,3.25e6,3.80e6,3.90e6,4.48e6,4.58e6)
nr_eeg_anal_04_psd_stats(data,'rest')

%move
nr_eeg_anal_02_cfg('~/nr_data_analysis/data_raw/eeg/pro00087153_0029.edf','hc','stim')
nr_eeg_anal_03_epochs(data,2.34e6,2.52e6,3.32e6,3.5e6,3.95e6,4.1e6,4.60e6,4.75e6)
nr_eeg_anal_04_psd_stats(data,'move')

%% HC SHAM
%20
%rest
nr_eeg_anal_02_cfg('~/nr_data_analysis/data_raw/eeg/pro00087153_0020.edf','hc','sham','rest')
nr_eeg_anal_03_epochs(data,1.75e6,1.85e6,2.6e6,2.7e6,3.2e6,3.3e6,3.85e6,3.95e6)
nr_eeg_anal_04_psd_stats(data,'rest')

%move
nr_eeg_anal_02_cfg('~/nr_data_analysis/data_raw/eeg/pro00087153_0020.edf','hc','sham')
nr_eeg_anal_03_epochs(data,2.19e6,2.24e6,2.85e6,2.93e6,3.47e6,3.54e6,4.17e6,4.22e6)
nr_eeg_anal_04_psd_stats(data,'move')

%22
%rest
nr_eeg_anal_02_cfg('~/nr_data_analysis/data_raw/eeg/pro00087153_0022.edf','hc','sham')
nr_eeg_anal_03_epochs(data,1.84e6,1.94e6,2.7e6,2.8e6,3.25e6,3.35e6,3.95e6,4.05e6)
nr_eeg_anal_04_psd_stats(data,'rest')

%move
nr_eeg_anal_02_cfg('~/nr_data_analysis/data_raw/eeg/pro00087153_0022.edf','hc','sham')
nr_eeg_anal_03_epochs(data,2.32e6,2.38e6,2.82e6,2.92e6,3.4e6,3.48e6,4.08e6,4.16e6)
nr_eeg_anal_04_psd_stats(data,'move')

%23
%rest
nr_eeg_anal_02_cfg('~/nr_data_analysis/data_raw/eeg/pro00087153_0023.edf','hc','sham')
nr_eeg_anal_03_epochs(data,2.0e6,2.1e6,2.85e6,2.95e6,3.45e6,3.55e6,4.05e6,4.15e6)
nr_eeg_anal_04_psd_stats(data,'rest')

%move
nr_eeg_anal_02_cfg('~/nr_data_analysis/data_raw/eeg/pro00087153_0023.edf','hc','sham')
nr_eeg_anal_03_epochs(data,2.44e6,2.49e6,3.1e6,3.16e6,3.72e6,3.77e6,4.35e6,4.41e6)
nr_eeg_anal_04_psd_stats(data,'move')

%27
%rest
nr_eeg_anal_02_cfg('~/nr_data_analysis/data_raw/eeg/pro00087153_0027.edf','hc','sham')
nr_eeg_anal_03_epochs(data,2.75e6,2.85e6,3.6e6,3.7e6,4.2e6,4.3e6,4.8e6,4.9e6)
nr_eeg_anal_04_psd_stats(data,'rest')

%move
nr_eeg_anal_02_cfg('~/nr_data_analysis/data_raw/eeg/pro00087153_0027.edf','hc','sham','move')
nr_eeg_anal_03_epochs(data,3.22e6,3.27e6,3.89e6,3.94e6,4.45e6,4.5e6,5.16e6,5.21e6)
nr_eeg_anal_04_psd_stats(data,'move')

%28
%rest
nr_eeg_anal_02_cfg('~/nr_data_analysis/data_raw/eeg/pro00087153_0028.edf','hc','sham','rest')
nr_eeg_anal_03_epochs(data,3.0e6,3.1e6,3.85e6,3.95e6,4.45e6,4.55e6,5.15e6,5.25e6)
nr_eeg_anal_04_psd_stats(data)

%move
nr_eeg_anal_02_cfg('~/nr_data_analysis/data_raw/eeg/pro00087153_0028.edf','hc','sham','move')
nr_eeg_anal_03_epochs(data,3.47e6,3.52e6,4.11e6,4.16e6,4.71e6,4.76e6,5.41e6,5.46e6)
nr_eeg_anal_04_psd_stats(data)

%36
%rest
nr_eeg_anal_02_cfg('~/nr_data_analysis/data_raw/eeg/pro00087153_0036.edf','hc','sham','rest')
nr_eeg_anal_03_epochs(data,2.0e6,2.1e6,2.9e6,3.0e6,3.55e6,3.65e6,4.2e6,4.3e6)
nr_eeg_anal_04_psd_stats(data)

%move
nr_eeg_anal_02_cfg('~/nr_data_analysis/data_raw/eeg/pro00087153_0036.edf','hc','sham','move')
nr_eeg_anal_03_epochs(data,2.45e6,2.5e6,3.24e6,3.29e6,3.83e6,3.89e6,4.51e6,4.56e6)
nr_eeg_anal_04_psd_stats(data)

%% CS STIM (remember that these are different in that they are during the reaches but that's all you have)

%3
%rest
nr_eeg_anal_02_cfg('~/nr_data_analysis/data_raw/eeg/pro00087153_0003.edf','cs','stim','rest')
nr_eeg_anal_03_epochs(data,2.5e6,2.6e6,3.15e6,3.25e6,3.8e6,3.9e6,4.45e6,4.55e6)
nr_eeg_anal_04_psd_stats(data)
load('/home/rowlandn/nr_data_analysis/data_analyzed/eeg/data_eeg_anal_rest_pro00087153_0003.mat')
clear cond n_sbj
data_eeg_anal_rest_pro00087153_0003.cfg.info.ue_tested='right';
data_eeg_anal_rest_pro00087153_0003.cfg.info.stim_lat='left';
data_eeg_anal_rest_pro00087153_0003.cfg.info.stim_elc='c3';
save('/home/rowlandn/nr_data_analysis/data_analyzed/eeg/data_eeg_anal_rest_pro00087153_0003.mat')
clear
nr_eeg_anal_05_replot_data_orig('~/nr_data_analysis/data_analyzed/eeg/data_eeg_anal_rest_pro00087153_0003.mat')
nr_eeg_anal_06_epochs_new('~/nr_data_analysis/data_analyzed/eeg/data_eeg_anal_rest_pro00087153_0003.mat')
nr_eeg_anal_07_psd_stats_new('~/nr_data_analysis/data_analyzed/eeg/data_eeg_anal_rest_pro00087153_0003.mat')

%move
nr_eeg_anal_02_cfg('~/nr_data_analysis/data_raw/eeg/pro00087153_0003.edf','cs','stim','move')
nr_eeg_anal_03_epochs(data,2.66e6,2.76e6,3.32e6,3.42e6,3.94e6,4.04e6,4.6e6,4.7e6)
nr_eeg_anal_04_psd_stats(data)
load('/home/rowlandn/nr_data_analysis/data_analyzed/eeg/data_eeg_anal_move_pro00087153_0003.mat')
clear cond n_sbj
data_eeg_anal_move_pro00087153_0003.cfg.info.ue_tested='right';
data_eeg_anal_move_pro00087153_0003.cfg.info.stim_lat='left';
data_eeg_anal_move_pro00087153_0003.cfg.info.stim_elc='c3';
save('/home/rowlandn/nr_data_analysis/data_analyzed/eeg/data_eeg_anal_move_pro00087153_0003.mat')
clear
nr_eeg_anal_05_replot_data_orig('~/nr_data_analysis/data_analyzed/eeg/data_eeg_anal_move_pro00087153_0003.mat')
nr_eeg_anal_06_epochs_new('~/nr_data_analysis/data_analyzed/eeg/data_eeg_anal_move_pro00087153_0003.mat')
nr_eeg_anal_07_psd_stats_new('~/nr_data_analysis/data_analyzed/eeg/data_eeg_anal_move_pro00087153_0003.mat')

%4
%rest
nr_eeg_anal_02_cfg('~/nr_data_analysis/data_raw/eeg/pro00087153_0004.edf','cs','stim','rest')
nr_eeg_anal_03_epochs(data,2.45e6,2.55e6,2.9e6,3.0e6,3.55e6,3.65e6,4.15e6,4.25e6)
nr_eeg_anal_04_psd_stats(data)
load('/home/rowlandn/nr_data_analysis/data_analyzed/eeg/data_eeg_anal_rest_pro00087153_0004.mat')
clear cond n_sbj
data_eeg_anal_rest_pro00087153_0004.cfg.info.ue_tested='right';
data_eeg_anal_rest_pro00087153_0004.cfg.info.stim_lat='left';
data_eeg_anal_rest_pro00087153_0004.cfg.info.stim_elc='c3';
save('/home/rowlandn/nr_data_analysis/data_analyzed/eeg/data_eeg_anal_rest_pro00087153_0004.mat')
clear
nr_eeg_anal_05_replot_data_orig('~/nr_data_analysis/data_analyzed/eeg/data_eeg_anal_rest_pro00087153_0004.mat')
nr_eeg_anal_06_epochs_new('~/nr_data_analysis/data_analyzed/eeg/data_eeg_anal_rest_pro00087153_0004.mat')
nr_eeg_anal_07_psd_stats_new('~/nr_data_analysis/data_analyzed/eeg/data_eeg_anal_rest_pro00087153_0004.mat')

%move
nr_eeg_anal_02_cfg('~/nr_data_analysis/data_raw/eeg/pro00087153_0004.edf','cs','stim','move')
nr_eeg_anal_03_epochs(data,2.57e6,2.67e6,3.05e6,3.15e6,3.67e6,3.77e6,4.27e6,4.37e6)
nr_eeg_anal_04_psd_stats(data)

%5
%rest
nr_eeg_anal_02_cfg('~/nr_data_analysis/data_raw/eeg/pro00087153_0005.edf','cs','stim','rest')
nr_eeg_anal_03_epochs(data,2.1e6,2.2e6,2.6e6,2.7e6,3.2e6,3.3e6,3.85e6,3.95e6)
nr_eeg_anal_04_psd_stats(data)

%move
nr_eeg_anal_02_cfg('~/nr_data_analysis/data_raw/eeg/pro00087153_0005.edf','cs','stim','move')
nr_eeg_anal_03_epochs(data,2.25e6,2.35e6,2.74e6,2.84e6,3.35e6,3.45e6,4.0e6,4.1e6)
nr_eeg_anal_04_psd_stats(data)

%42
%rest
nr_eeg_anal_02_cfg('~/nr_data_analysis/data_raw/eeg/pro00087153_0042.edf','cs','stim','rest')
nr_eeg_anal_03_epochs(data,0.8e6,0.85e6,1.08e6,1.117e6,1.22e6,1.27e6,1.38e6,1.44e6)
nr_eeg_anal_04_psd_stats(data)

%move
nr_eeg_anal_02_cfg('~/nr_data_analysis/data_raw/eeg/pro00087153_0042.edf','cs','stim','move')
nr_eeg_anal_03_epochs(data,0.945e6,0.955e6,1.16e6,1.17e6,1.31e6,1.32e6,1.5e6,1.51e6)
nr_eeg_anal_04_psd_stats(data)

%43
%rest
nr_eeg_anal_02_cfg('~/nr_data_analysis/data_raw/eeg/pro00087153_0043.edf','cs','stim','rest')
nr_eeg_anal_03_epochs(data,0.44e6,0.47e6,0.68e6,0.71e6,0.84e6,0.87e6,1.01e6,1.04e6)
nr_eeg_anal_04_psd_stats(data)

%move
nr_eeg_anal_02_cfg('~/nr_data_analysis/data_raw/eeg/pro00087153_0043.edf','cs','stim','move')
nr_eeg_anal_03_epochs(data,0.565e6,0.575e6,0.77e6,0.78e6,0.92e6,0.93e6,1.09e6,1.1e6)
nr_eeg_anal_04_psd_stats(data)


%% CS SHAM (these have flex-ex)

%13
%rest
nr_eeg_anal_02_cfg('~/nr_data_analysis/data_raw/eeg/pro00087153_0013.edf','cs','sham','rest')
nr_eeg_anal_03_epochs(data,2.85e6,2.95e6,3.55e6,3.65e6,4.15e6,4.25e6,4.8e6,4.9e6)
nr_eeg_anal_04_psd_stats(data)

%move
nr_eeg_anal_02_cfg('~/nr_data_analysis/data_raw/eeg/pro00087153_0013.edf','cs','sham','move')
nr_eeg_anal_03_epochs(data,3.16e6,3.22e6,3.84e6,3.89e6,4.46e6,4.52e6,5.08e6,5.13e6)
nr_eeg_anal_04_psd_stats(data)

%15
%rest
nr_eeg_anal_02_cfg('~/nr_data_analysis/data_raw/eeg/pro00087153_0015.edf','cs','sham','rest')
nr_eeg_anal_03_epochs(data,1.55e6,1.65e6,2.25e6,2.35e6,2.9e6,3.0e6,3.5e6,3.6e6)
nr_eeg_anal_04_psd_stats(data)

%move
nr_eeg_anal_02_cfg('~/nr_data_analysis/data_raw/eeg/pro00087153_0015.edf','cs','sham','move')
nr_eeg_anal_03_epochs(data,1.9e6,1.95e6,2.57e6,2.62e6,3.19e6,3.24e6,3.78e6,3.84e6)
nr_eeg_anal_04_psd_stats(data)

%17
%rest
nr_eeg_anal_02_cfg('~/nr_data_analysis/data_raw/eeg/pro00087153_0017.edf','cs','sham','rest')
nr_eeg_anal_03_epochs(data,1.3e6,1.4e6,2.15e6,2.25e6,2.75e6,2.85e6,3.4e6,3.5e6)
nr_eeg_anal_04_psd_stats(data)

%move
nr_eeg_anal_02_cfg('~/nr_data_analysis/data_raw/eeg/pro00087153_0017.edf','cs','sham','move')
nr_eeg_anal_03_epochs(data,1.76e6,1.81e6,2.46e6,2.52e6,3.05e6,3.11e6,3.74e6,3.775e6)
nr_eeg_anal_04_psd_stats(data)

%18
%rest
nr_eeg_anal_02_cfg('~/nr_data_analysis/data_raw/eeg/pro00087153_0018.edf','cs','sham','rest')
nr_eeg_anal_03_epochs(data,2.25e6,2.35e6,2.95e6,3.05e6,3.55e6,3.65e6,4.2e6,4.3e6)
nr_eeg_anal_04_psd_stats(data)

%movenr_eeg_anal_03_epochs(data,1.35e6,1.45e6,2.2e6,2.3e6,2.8e6,2.9e6,3.5e6,3.6e6)
nr_eeg_anal_02_cfg('~/nr_data_analysis/data_raw/eeg/pro00087153_0018.edf','cs','sham','move')
nr_eeg_anal_03_epochs(data,2.55e6,2.61e6,3.24e6,3.29e6,3.87e6,3.92e6,4.51e6,4.56e6)
nr_eeg_anal_04_psd_stats(data)

%21
%rest
nr_eeg_anal_02_cfg('~/nr_data_analysis/data_raw/eeg/pro00087153_0021.edf','cs','sham','rest')
nr_eeg_anal_03_epochs(data,1.35e6,1.45e6,2.2e6,2.3e6,2.8e6,2.9e6,3.5e6,3.6e6)
nr_eeg_anal_04_psd_stats(data)

%move
nr_eeg_anal_02_cfg('~/nr_data_analysis/data_raw/eeg/pro00087153_0021.edf','cs','sham','move')
nr_eeg_anal_03_epochs(data,1.85e6,1.9e6,2.47e6,2.52e6,3.1e6,3.15e6,3.76e6,3.84e6)
nr_eeg_anal_04_psd_stats(data)




%% now I will go back and add the stim lat after looking at the videos

%03
%move
load('/home/rowlandn/nr_data_analysis/data_analyzed/eeg/data_eeg_anal_move_pro00087153_0003.mat')
clear ans data f* g* i j k l m* s*
data_eeg_anal_move_pro00087153_0003.cfg.info.ue_tested='right';
data_eeg_anal_move_pro00087153_0003.cfg.info.stim_lat='left';
data_eeg_anal_move_pro00087153_0003.cfg.info.stim_elc='c3';
save('/home/rowlandn/nr_data_analysis/data_analyzed/eeg/data_eeg_anal_move_pro00087153_0003.mat')
clear

%rest
load('/home/rowlandn/nr_data_analysis/data_analyzed/eeg/data_eeg_anal_rest_pro00087153_0003.mat')
clear ans data f* g* i j k l m* s*
data_eeg_anal_rest_pro00087153_0003.cfg.info.ue_tested='right';
data_eeg_anal_rest_pro00087153_0003.cfg.info.stim_lat='left';
data_eeg_anal_rest_pro00087153_0003.cfg.info.stim_elc='c3';
save('/home/rowlandn/nr_data_analysis/data_analyzed/eeg/data_eeg_anal_rest_pro00087153_0003.mat')
clear

%04
%move
load('/home/rowlandn/nr_data_analysis/data_analyzed/eeg/data_eeg_anal_move_pro00087153_0004.mat')
clear ans data f* g* i j k l m* s*
data_eeg_anal_move_pro00087153_0004.cfg.info.ue_tested='right';
data_eeg_anal_move_pro00087153_0004.cfg.info.stim_lat='left';
data_eeg_anal_move_pro00087153_0004.cfg.info.stim_elc='c3';
save('/home/rowlandn/nr_data_analysis/data_analyzed/eeg/data_eeg_anal_move_pro00087153_0004.mat')
clear

%rest
load('/home/rowlandn/nr_data_analysis/data_analyzed/eeg/data_eeg_anal_rest_pro00087153_0004.mat')
clear ans data f* g* i j k l m* s*
data_eeg_anal_rest_pro00087153_0004.cfg.info.ue_tested='right';
data_eeg_anal_rest_pro00087153_0004.cfg.info.stim_lat='left';
data_eeg_anal_rest_pro00087153_0004.cfg.info.stim_elc='c3';
save('/home/rowlandn/nr_data_analysis/data_analyzed/eeg/data_eeg_anal_rest_pro00087153_0004.mat')
clear

%05
%move
load('/home/rowlandn/nr_data_analysis/data_analyzed/eeg/data_eeg_anal_move_pro00087153_0005.mat')
clear ans data f* g* i j k l m* s*
data_eeg_anal_move_pro00087153_0005.cfg.info.ue_tested='left';
data_eeg_anal_move_pro00087153_0005.cfg.info.stim_lat='right';
data_eeg_anal_move_pro00087153_0005.cfg.info.stim_elc='c4';
save('/home/rowlandn/nr_data_analysis/data_analyzed/eeg/data_eeg_anal_move_pro00087153_0005.mat')
clear

%rest
load('/home/rowlandn/nr_data_analysis/data_analyzed/eeg/data_eeg_anal_rest_pro00087153_0005.mat')
clear ans data f* g* i j k l m* s*
data_eeg_anal_rest_pro00087153_0005.cfg.info.ue_tested='left';
data_eeg_anal_rest_pro00087153_0005.cfg.info.stim_lat='right';
data_eeg_anal_rest_pro00087153_0005.cfg.info.stim_elc='c4';
save('/home/rowlandn/nr_data_analysis/data_analyzed/eeg/data_eeg_anal_rest_pro00087153_0005.mat')
clear

%42
%move
load('/home/rowlandn/nr_data_analysis/data_analyzed/eeg/data_eeg_anal_move_pro00087153_0042.mat')
clear ans data f* g* i j k l m* s*
data_eeg_anal_move_pro00087153_0042.cfg.info.ue_tested='left';
data_eeg_anal_move_pro00087153_0042.cfg.info.stim_lat='right';
data_eeg_anal_move_pro00087153_0042.cfg.info.stim_elc='c4';
save('/home/rowlandn/nr_data_analysis/data_analyzed/eeg/data_eeg_anal_move_pro00087153_0042.mat')
clear

%rest
load('/home/rowlandn/nr_data_analysis/data_analyzed/eeg/data_eeg_anal_rest_pro00087153_0042.mat')
clear ans data f* g* i j k l m* s*
data_eeg_anal_rest_pro00087153_0042.cfg.info.ue_tested='left';
data_eeg_anal_rest_pro00087153_0042.cfg.info.stim_lat='right';
data_eeg_anal_rest_pro00087153_0042.cfg.info.stim_elc='c4';
save('/home/rowlandn/nr_data_analysis/data_analyzed/eeg/data_eeg_anal_rest_pro00087153_0042.mat')
clear

%43
%move
load('/home/rowlandn/nr_data_analysis/data_analyzed/eeg/data_eeg_anal_move_pro00087153_0043.mat')
clear ans data f* g* i j k l m* s*
data_eeg_anal_move_pro00087153_0043.cfg.info.ue_tested='right';
data_eeg_anal_move_pro00087153_0043.cfg.info.stim_lat='left';
data_eeg_anal_move_pro00087153_0043.cfg.info.stim_elc='c3';
save('/home/rowlandn/nr_data_analysis/data_analyzed/eeg/data_eeg_anal_move_pro00087153_0043.mat')
clear

%rest
load('/home/rowlandn/nr_data_analysis/data_analyzed/eeg/data_eeg_anal_rest_pro00087153_0043.mat')
clear ans data f* g* i j k l m* s*
data_eeg_anal_rest_pro00087153_0043.cfg.info.ue_tested='right';
data_eeg_anal_rest_pro00087153_0043.cfg.info.stim_lat='left';
data_eeg_anal_rest_pro00087153_0043.cfg.info.stim_elc='c3';
save('/home/rowlandn/nr_data_analysis/data_analyzed/eeg/data_eeg_anal_rest_pro00087153_0043.mat')
clear



%13
%move
load('/home/rowlandn/nr_data_analysis/data_analyzed/eeg/data_eeg_anal_move_pro00087153_0013.mat')
clear ans data f* g* i j k l m* s*
data_eeg_anal_move_pro00087153_0013.cfg.info.ue_tested='left';
data_eeg_anal_move_pro00087153_0013.cfg.info.stim_lat='right';
data_eeg_anal_move_pro00087153_0013.cfg.info.stim_elc='c4';
save('/home/rowlandn/nr_data_analysis/data_analyzed/eeg/data_eeg_anal_move_pro00087153_0013.mat')
clear

%rest
load('/home/rowlandn/nr_data_analysis/data_analyzed/eeg/data_eeg_anal_rest_pro00087153_0013.mat')
clear ans data f* g* i j k l m* s*
data_eeg_anal_rest_pro00087153_0013.cfg.info.ue_tested='left';
data_eeg_anal_rest_pro00087153_0013.cfg.info.stim_lat='right';
data_eeg_anal_rest_pro00087153_0013.cfg.info.stim_elc='c4';
save('/home/rowlandn/nr_data_analysis/data_analyzed/eeg/data_eeg_anal_rest_pro00087153_0013.mat')
clear

%15
%move
load('/home/rowlandn/nr_data_analysis/data_analyzed/eeg/data_eeg_anal_move_pro00087153_0015.mat')
clear ans data f* g* i j k l m* s*
data_eeg_anal_move_pro00087153_0015.cfg.info.ue_tested='right';
data_eeg_anal_move_pro00087153_0015.cfg.info.stim_lat='left';
data_eeg_anal_move_pro00087153_0015.cfg.info.stim_elc='c3';
save('/home/rowlandn/nr_data_analysis/data_analyzed/eeg/data_eeg_anal_move_pro00087153_0015.mat')
clear

%rest
load('/home/rowlandn/nr_data_analysis/data_analyzed/eeg/data_eeg_anal_rest_pro00087153_0015.mat')
clear ans data f* g* i j k l m* s*
data_eeg_anal_rest_pro00087153_0015.cfg.info.ue_tested='right';
data_eeg_anal_rest_pro00087153_0015.cfg.info.stim_lat='left';
data_eeg_anal_rest_pro00087153_0015.cfg.info.stim_elc='c3';
save('/home/rowlandn/nr_data_analysis/data_analyzed/eeg/data_eeg_anal_rest_pro00087153_0015.mat')
clear

%17
%move
load('/home/rowlandn/nr_data_analysis/data_analyzed/eeg/data_eeg_anal_move_pro00087153_0017.mat')
clear ans data f* g* i j k l m* s*
data_eeg_anal_move_pro00087153_0017.cfg.info.ue_tested='left';
data_eeg_anal_move_pro00087153_0017.cfg.info.stim_lat='right';
data_eeg_anal_move_pro00087153_0017.cfg.info.stim_elc='c4';
save('/home/rowlandn/nr_data_analysis/data_analyzed/eeg/data_eeg_anal_move_pro00087153_0017.mat')
clear

%rest
load('/home/rowlandn/nr_data_analysis/data_analyzed/eeg/data_eeg_anal_rest_pro00087153_0017.mat')
clear ans data f* g* i j k l m* s*
data_eeg_anal_rest_pro00087153_0017.cfg.info.ue_tested='left';
data_eeg_anal_rest_pro00087153_0017.cfg.info.stim_lat='right';
data_eeg_anal_rest_pro00087153_0017.cfg.info.stim_elc='c4';
save('/home/rowlandn/nr_data_analysis/data_analyzed/eeg/data_eeg_anal_rest_pro00087153_0017.mat')
clear

%18
%move
load('/home/rowlandn/nr_data_analysis/data_analyzed/eeg/data_eeg_anal_move_pro00087153_0018.mat')
clear ans data f* g* i j k l m* s*
data_eeg_anal_move_pro00087153_0018.cfg.info.ue_tested='left';
data_eeg_anal_move_pro00087153_0018.cfg.info.stim_lat='right';
data_eeg_anal_move_pro00087153_0018.cfg.info.stim_elc='c4';
save('/home/rowlandn/nr_data_analysis/data_analyzed/eeg/data_eeg_anal_move_pro00087153_0018.mat')
clear

%rest
load('/home/rowlandn/nr_data_analysis/data_analyzed/eeg/data_eeg_anal_rest_pro00087153_0018.mat')
clear ans data f* g* i j k l m* s*
data_eeg_anal_rest_pro00087153_0018.cfg.info.ue_tested='left';
data_eeg_anal_rest_pro00087153_0018.cfg.info.stim_lat='right';
data_eeg_anal_rest_pro00087153_0018.cfg.info.stim_elc='c4';
save('/home/rowlandn/nr_data_analysis/data_analyzed/eeg/data_eeg_anal_rest_pro00087153_0018.mat')
clear

%21
%move
load('/home/rowlandn/nr_data_analysis/data_analyzed/eeg/data_eeg_anal_move_pro00087153_0021.mat')
clear ans data f* g* i j k l m* s*
data_eeg_anal_move_pro00087153_0021.cfg.info.ue_tested='left';
data_eeg_anal_move_pro00087153_0021.cfg.info.stim_lat='right';
data_eeg_anal_move_pro00087153_0021.cfg.info.stim_elc='c4';
save('/home/rowlandn/nr_data_analysis/data_analyzed/eeg/data_eeg_anal_move_pro00087153_0021.mat')
clear

%rest
load('/home/rowlandn/nr_data_analysis/data_analyzed/eeg/data_eeg_anal_rest_pro00087153_0021.mat')
clear ans data f* g* i j k l m* s*
data_eeg_anal_rest_pro00087153_0021.cfg.info.ue_tested='left';
data_eeg_anal_rest_pro00087153_0021.cfg.info.stim_lat='right';
data_eeg_anal_rest_pro00087153_0021.cfg.info.stim_elc='c4';
save('/home/rowlandn/nr_data_analysis/data_analyzed/eeg/data_eeg_anal_rest_pro00087153_0021.mat')
clear

%% let's calc some beta values

sbjs_stm=['03';'04';'05'];
elec_stm_ipsi=[7,7,18];
elec_stm_cont=[18,18,7];
sbjs_non=['13';'15';'17';'18';'21'];
elec_non_ipsi=[18,7,18,18,18];
elec_non_cont=[7,18,7,7,7];

%stim ipsi rest beta
for i=1:size(sbjs_stm,1)
    load(['/home/rowlandn/nr_data_analysis/data_analyzed/eeg/data_eeg_anal_rest_pro00087153_00',sbjs_stm(i,:),'.mat'])
    eval(['data_sum_cs_stm_ipsi_rest_beta(',num2str(i),',:)=data_eeg_anal_rest_pro00087153_00',sbjs_stm(i,:),'.plots.beta.c',num2str(elec_stm_ipsi(i)),'.supermeans'])
    clear data_eeg*
end

%stim cont rest beta
for i=1:size(sbjs_stm,1)
    load(['/home/rowlandn/nr_data_analysis/data_analyzed/eeg/data_eeg_anal_rest_pro00087153_00',sbjs_stm(i,:),'.mat'])
    eval(['data_sum_cs_stm_cont_rest_beta(',num2str(i),',:)=data_eeg_anal_rest_pro00087153_00',sbjs_stm(i,:),'.plots.beta.c',num2str(elec_stm_cont(i)),'.supermeans'])
    clear data_eeg*
end

%stim ipsi move beta
for i=1:size(sbjs_stm,1)
    load(['/home/rowlandn/nr_data_analysis/data_analyzed/eeg/data_eeg_anal_move_pro00087153_00',sbjs_stm(i,:),'.mat'])
    eval(['data_sum_cs_stm_ipsi_move_beta(',num2str(i),',:)=data_eeg_anal_move_pro00087153_00',sbjs_stm(i,:),'.plots.beta.c',num2str(elec_stm_ipsi(i)),'.supermeans'])
    clear data_eeg*
end

%stim cont move beta
for i=1:size(sbjs_stm,1)
    load(['/home/rowlandn/nr_data_analysis/data_analyzed/eeg/data_eeg_anal_move_pro00087153_00',sbjs_stm(i,:),'.mat'])
    eval(['data_sum_cs_stm_cont_move_beta(',num2str(i),',:)=data_eeg_anal_move_pro00087153_00',sbjs_stm(i,:),'.plots.beta.c',num2str(elec_stm_cont(i)),'.supermeans'])
    clear data_eeg*
end

%nonstim ipsi rest beta
for i=1:size(sbjs_non,1)
    load(['/home/rowlandn/nr_data_analysis/data_analyzed/eeg/data_eeg_anal_rest_pro00087153_00',sbjs_non(i,:),'.mat'])
    eval(['data_sum_cs_non_ipsi_rest_beta(',num2str(i),',:)=data_eeg_anal_rest_pro00087153_00',sbjs_non(i,:),'.plots.beta.c',num2str(elec_non_ipsi(i)),'.supermeans'])
    clear data_eeg*
end

%nonstim cont rest beta
for i=1:size(sbjs_non,1)
    load(['/home/rowlandn/nr_data_analysis/data_analyzed/eeg/data_eeg_anal_rest_pro00087153_00',sbjs_non(i,:),'.mat'])
    eval(['data_sum_cs_non_cont_rest_beta(',num2str(i),',:)=data_eeg_anal_rest_pro00087153_00',sbjs_non(i,:),'.plots.beta.c',num2str(elec_non_cont(i)),'.supermeans'])
    clear data_eeg*
end

%nonstim ipsi move beta
for i=1:size(sbjs_non,1)
    load(['/home/rowlandn/nr_data_analysis/data_analyzed/eeg/data_eeg_anal_move_pro00087153_00',sbjs_non(i,:),'.mat'])
    eval(['data_sum_cs_non_ipsi_move_beta(',num2str(i),',:)=data_eeg_anal_move_pro00087153_00',sbjs_non(i,:),'.plots.beta.c',num2str(elec_non_ipsi(i)),'.supermeans'])
    clear data_eeg*
end

%nonstim cont move beta
for i=1:size(sbjs_non,1)
    load(['/home/rowlandn/nr_data_analysis/data_analyzed/eeg/data_eeg_anal_move_pro00087153_00',sbjs_non(i,:),'.mat'])
    eval(['data_sum_cs_non_cont_move_beta(',num2str(i),',:)=data_eeg_anal_move_pro00087153_00',sbjs_non(i,:),'.plots.beta.c',num2str(elec_non_cont(i)),'.supermeans'])
    clear data_eeg*
end

mean_data_sum_cs_stm_ipsi_rest_beta=mean(data_sum_cs_stm_ipsi_rest_beta)
se_data_sum_cs_stm_ipsi_rest_beta=std(data_sum_cs_stm_ipsi_rest_beta)/sqrt(size(data_sum_cs_stm_ipsi_rest_beta,1))

mean_data_sum_cs_stm_ipsi_move_beta=mean(data_sum_cs_stm_ipsi_move_beta)
se_data_sum_cs_stm_ipsi_move_beta=std(data_sum_cs_stm_ipsi_move_beta)/sqrt(size(data_sum_cs_stm_ipsi_move_beta,1))

mean_data_sum_cs_stm_cont_rest_beta=mean(data_sum_cs_stm_cont_rest_beta)
se_data_sum_cs_stm_cont_rest_beta=std(data_sum_cs_stm_cont_rest_beta)/sqrt(size(data_sum_cs_stm_cont_rest_beta,1))

mean_data_sum_cs_stm_cont_move_beta=mean(data_sum_cs_stm_cont_move_beta)
se_data_sum_cs_stm_cont_move_beta=std(data_sum_cs_stm_cont_move_beta)/sqrt(size(data_sum_cs_stm_cont_move_beta,1))

mean_data_sum_cs_non_ipsi_rest_beta=mean(data_sum_cs_non_ipsi_rest_beta)
se_data_sum_cs_non_ipsi_rest_beta=std(data_sum_cs_non_ipsi_rest_beta)/sqrt(size(data_sum_cs_non_ipsi_rest_beta,1))

mean_data_sum_cs_non_ipsi_move_beta=mean(data_sum_cs_non_ipsi_move_beta)
se_data_sum_cs_non_ipsi_move_beta=std(data_sum_cs_non_ipsi_move_beta)/sqrt(size(data_sum_cs_non_ipsi_move_beta,1))

mean_data_sum_cs_non_cont_rest_beta=mean(data_sum_cs_non_cont_rest_beta)
se_data_sum_cs_non_cont_rest_beta=std(data_sum_cs_non_cont_rest_beta)/sqrt(size(data_sum_cs_non_cont_rest_beta,1))

mean_data_sum_cs_non_cont_move_beta=mean(data_sum_cs_non_cont_move_beta)
se_data_sum_cs_non_cont_move_beta=std(data_sum_cs_non_cont_move_beta)/sqrt(size(data_sum_cs_non_cont_move_beta,1))

figure
set(gcf,'Position',[178 196 802 1285])
subplot(6,2,1)
hold
bar([mean_data_sum_cs_stm_ipsi_rest_beta(1) mean_data_sum_cs_stm_ipsi_move_beta(1) 0,...
     mean_data_sum_cs_stm_ipsi_rest_beta(2) mean_data_sum_cs_stm_ipsi_move_beta(2) 0,...
     mean_data_sum_cs_stm_ipsi_rest_beta(3) mean_data_sum_cs_stm_ipsi_move_beta(3) 0,...
     mean_data_sum_cs_stm_ipsi_rest_beta(4) mean_data_sum_cs_stm_ipsi_move_beta(4)])
errorbar([mean_data_sum_cs_stm_ipsi_rest_beta(1) mean_data_sum_cs_stm_ipsi_move_beta(1) 0,...
          mean_data_sum_cs_stm_ipsi_rest_beta(2) mean_data_sum_cs_stm_ipsi_move_beta(2) 0,...
          mean_data_sum_cs_stm_ipsi_rest_beta(3) mean_data_sum_cs_stm_ipsi_move_beta(3) 0,...
          mean_data_sum_cs_stm_ipsi_rest_beta(4) mean_data_sum_cs_stm_ipsi_move_beta(4)],...
         [se_data_sum_cs_stm_ipsi_rest_beta(1) se_data_sum_cs_stm_ipsi_move_beta(1) 0,...
          se_data_sum_cs_stm_ipsi_rest_beta(2) se_data_sum_cs_stm_ipsi_move_beta(2) 0,...
          se_data_sum_cs_stm_ipsi_rest_beta(3) se_data_sum_cs_stm_ipsi_move_beta(3) 0,...
          se_data_sum_cs_stm_ipsi_rest_beta(4) se_data_sum_cs_stm_ipsi_move_beta(4)],'.k')
title('cs stim ipsi beta whole (n=3)')

subplot(6,2,2)
hold
bar([mean_data_sum_cs_stm_cont_rest_beta(1) mean_data_sum_cs_stm_cont_move_beta(1) 0,...
     mean_data_sum_cs_stm_cont_rest_beta(2) mean_data_sum_cs_stm_cont_move_beta(2) 0,...
     mean_data_sum_cs_stm_cont_rest_beta(3) mean_data_sum_cs_stm_cont_move_beta(3) 0,...
     mean_data_sum_cs_stm_cont_rest_beta(4) mean_data_sum_cs_stm_cont_move_beta(4)])
errorbar([mean_data_sum_cs_stm_cont_rest_beta(1) mean_data_sum_cs_stm_cont_move_beta(1) 0,...
          mean_data_sum_cs_stm_cont_rest_beta(2) mean_data_sum_cs_stm_cont_move_beta(2) 0,...
          mean_data_sum_cs_stm_cont_rest_beta(3) mean_data_sum_cs_stm_cont_move_beta(3) 0,...
          mean_data_sum_cs_stm_cont_rest_beta(4) mean_data_sum_cs_stm_cont_move_beta(4)],...
         [se_data_sum_cs_stm_cont_rest_beta(1) se_data_sum_cs_stm_cont_move_beta(1) 0,...
          se_data_sum_cs_stm_cont_rest_beta(2) se_data_sum_cs_stm_cont_move_beta(2) 0,...
          se_data_sum_cs_stm_cont_rest_beta(3) se_data_sum_cs_stm_cont_move_beta(3) 0,...
          se_data_sum_cs_stm_cont_rest_beta(4) se_data_sum_cs_stm_cont_move_beta(4)],'.k')
title('cs stim cont beta whole (n=3)')

subplot(6,2,3)
hold
bar([mean_data_sum_cs_non_ipsi_rest_beta(1) mean_data_sum_cs_non_ipsi_move_beta(1) 0,...
     mean_data_sum_cs_non_ipsi_rest_beta(2) mean_data_sum_cs_non_ipsi_move_beta(2) 0,...
     mean_data_sum_cs_non_ipsi_rest_beta(3) mean_data_sum_cs_non_ipsi_move_beta(3) 0,...
     mean_data_sum_cs_non_ipsi_rest_beta(4) mean_data_sum_cs_non_ipsi_move_beta(4)])
errorbar([mean_data_sum_cs_non_ipsi_rest_beta(1) mean_data_sum_cs_non_ipsi_move_beta(1) 0,...
          mean_data_sum_cs_non_ipsi_rest_beta(2) mean_data_sum_cs_non_ipsi_move_beta(2) 0,...
          mean_data_sum_cs_non_ipsi_rest_beta(3) mean_data_sum_cs_non_ipsi_move_beta(3) 0,...
          mean_data_sum_cs_non_ipsi_rest_beta(4) mean_data_sum_cs_non_ipsi_move_beta(4)],...
         [se_data_sum_cs_non_ipsi_rest_beta(1) se_data_sum_cs_non_ipsi_move_beta(1) 0,...
          se_data_sum_cs_non_ipsi_rest_beta(2) se_data_sum_cs_non_ipsi_move_beta(2) 0,...
          se_data_sum_cs_non_ipsi_rest_beta(3) se_data_sum_cs_non_ipsi_move_beta(3) 0,...
          se_data_sum_cs_non_ipsi_rest_beta(4) se_data_sum_cs_non_ipsi_move_beta(4)],'.k')
title('cs non ipsi beta whole (n=5)')

subplot(6,2,4)
hold
bar([mean_data_sum_cs_non_cont_rest_beta(1) mean_data_sum_cs_non_cont_move_beta(1) 0,...
     mean_data_sum_cs_non_cont_rest_beta(2) mean_data_sum_cs_non_cont_move_beta(2) 0,...
     mean_data_sum_cs_non_cont_rest_beta(3) mean_data_sum_cs_non_cont_move_beta(3) 0,...
     mean_data_sum_cs_non_cont_rest_beta(4) mean_data_sum_cs_non_cont_move_beta(4)])
errorbar([mean_data_sum_cs_non_cont_rest_beta(1) mean_data_sum_cs_non_cont_move_beta(1) 0,...
          mean_data_sum_cs_non_cont_rest_beta(2) mean_data_sum_cs_non_cont_move_beta(2) 0,...
          mean_data_sum_cs_non_cont_rest_beta(3) mean_data_sum_cs_non_cont_move_beta(3) 0,...
          mean_data_sum_cs_non_cont_rest_beta(4) mean_data_sum_cs_non_cont_move_beta(4)],...
         [se_data_sum_cs_non_cont_rest_beta(1) se_data_sum_cs_non_cont_move_beta(1) 0,...
          se_data_sum_cs_non_cont_rest_beta(2) se_data_sum_cs_non_cont_move_beta(2) 0,...
          se_data_sum_cs_non_cont_rest_beta(3) se_data_sum_cs_non_cont_move_beta(3) 0,...
          se_data_sum_cs_non_cont_rest_beta(4) se_data_sum_cs_non_cont_move_beta(4)],'.k')
title('cs non cont beta whole (n=5)')

subplot(6,2,5)
box_var_sum_stm_ipsi_beta(:,1)=data_sum_cs_stm_ipsi_rest_beta(:,1)
box_var_sum_stm_ipsi_beta(:,2)=data_sum_cs_stm_ipsi_move_beta(:,1)
box_var_sum_stm_ipsi_beta(:,3)=linspace(0,0,3)'
box_var_sum_stm_ipsi_beta(:,4)=data_sum_cs_stm_ipsi_rest_beta(:,2)
box_var_sum_stm_ipsi_beta(:,5)=data_sum_cs_stm_ipsi_move_beta(:,2)
box_var_sum_stm_ipsi_beta(:,6)=linspace(0,0,3)'
box_var_sum_stm_ipsi_beta(:,7)=data_sum_cs_stm_ipsi_rest_beta(:,3)
box_var_sum_stm_ipsi_beta(:,8)=data_sum_cs_stm_ipsi_move_beta(:,3)
box_var_sum_stm_ipsi_beta(:,9)=linspace(0,0,3)'
box_var_sum_stm_ipsi_beta(:,10)=data_sum_cs_stm_ipsi_rest_beta(:,4)
box_var_sum_stm_ipsi_beta(:,11)=data_sum_cs_stm_ipsi_move_beta(:,4)
boxplot(box_var_sum_stm_ipsi_beta)
title('cs stim ipsi beta whole (n=3)')

subplot(6,2,6)
box_var_sum_stm_cont_beta(:,1)=data_sum_cs_stm_cont_rest_beta(:,1)
box_var_sum_stm_cont_beta(:,2)=data_sum_cs_stm_cont_move_beta(:,1)
box_var_sum_stm_cont_beta(:,3)=linspace(0,0,3)'
box_var_sum_stm_cont_beta(:,4)=data_sum_cs_stm_cont_rest_beta(:,2)
box_var_sum_stm_cont_beta(:,5)=data_sum_cs_stm_cont_move_beta(:,2)
box_var_sum_stm_cont_beta(:,6)=linspace(0,0,3)'
box_var_sum_stm_cont_beta(:,7)=data_sum_cs_stm_cont_rest_beta(:,3)
box_var_sum_stm_cont_beta(:,8)=data_sum_cs_stm_cont_move_beta(:,3)
box_var_sum_stm_cont_beta(:,9)=linspace(0,0,3)'
box_var_sum_stm_cont_beta(:,10)=data_sum_cs_stm_cont_rest_beta(:,4)
box_var_sum_stm_cont_beta(:,11)=data_sum_cs_stm_cont_move_beta(:,4)
boxplot(box_var_sum_stm_cont_beta)
title('cs stim cont beta whole (n=3)')

subplot(6,2,7)
box_var_sum_non_ipsi_beta(:,1)=data_sum_cs_non_ipsi_rest_beta(:,1)
box_var_sum_non_ipsi_beta(:,2)=data_sum_cs_non_ipsi_move_beta(:,1)
box_var_sum_non_ipsi_beta(:,3)=linspace(0,0,5)'
box_var_sum_non_ipsi_beta(:,4)=data_sum_cs_non_ipsi_rest_beta(:,2)
box_var_sum_non_ipsi_beta(:,5)=data_sum_cs_non_ipsi_move_beta(:,2)
box_var_sum_non_ipsi_beta(:,6)=linspace(0,0,5)'
box_var_sum_non_ipsi_beta(:,7)=data_sum_cs_non_ipsi_rest_beta(:,3)
box_var_sum_non_ipsi_beta(:,8)=data_sum_cs_non_ipsi_move_beta(:,3)
box_var_sum_non_ipsi_beta(:,9)=linspace(0,0,5)'
box_var_sum_non_ipsi_beta(:,10)=data_sum_cs_non_ipsi_rest_beta(:,4)
box_var_sum_non_ipsi_beta(:,11)=data_sum_cs_non_ipsi_move_beta(:,4)
boxplot(box_var_sum_non_ipsi_beta)
title('cs non ipsi beta whole (n=5)')

subplot(6,2,8)
box_var_sum_non_cont_beta(:,1)=data_sum_cs_non_cont_rest_beta(:,1)
box_var_sum_non_cont_beta(:,2)=data_sum_cs_non_cont_move_beta(:,1)
box_var_sum_non_cont_beta(:,3)=linspace(0,0,5)'
box_var_sum_non_cont_beta(:,4)=data_sum_cs_non_cont_rest_beta(:,2)
box_var_sum_non_cont_beta(:,5)=data_sum_cs_non_cont_move_beta(:,2)
box_var_sum_non_cont_beta(:,6)=linspace(0,0,5)'
box_var_sum_non_cont_beta(:,7)=data_sum_cs_non_cont_rest_beta(:,3)
box_var_sum_non_cont_beta(:,8)=data_sum_cs_non_cont_move_beta(:,3)
box_var_sum_non_cont_beta(:,9)=linspace(0,0,5)'
box_var_sum_non_cont_beta(:,10)=data_sum_cs_non_cont_rest_beta(:,4)
box_var_sum_non_cont_beta(:,11)=data_sum_cs_non_cont_move_beta(:,4)
boxplot(box_var_sum_non_cont_beta)
title('cs non cont beta whole (n=5)')

subplot(6,2,9)
hold on
scatter([1 1 1],data_sum_cs_stm_ipsi_rest_beta(:,1),'k','filled')
scatter([2 2 2],data_sum_cs_stm_ipsi_move_beta(:,1),'r','filled')
scatter([4 4 4],data_sum_cs_stm_ipsi_rest_beta(:,2),'k','filled')
scatter([5 5 5],data_sum_cs_stm_ipsi_move_beta(:,2),'r','filled')
scatter([7 7 7],data_sum_cs_stm_ipsi_rest_beta(:,3),'k','filled')
scatter([8 8 8],data_sum_cs_stm_ipsi_move_beta(:,3),'r','filled')
scatter([10 10 10],data_sum_cs_stm_ipsi_rest_beta(:,4),'k','filled')
scatter([11 11 11],data_sum_cs_stm_ipsi_move_beta(:,4),'r','filled')
title('cs stim ipsi beta whole (n=3)')
set(gca,'xlim',[0 12])

subplot(6,2,10)
hold on
scatter([1 1 1],data_sum_cs_stm_cont_rest_beta(:,1),'k','filled')
scatter([2 2 2],data_sum_cs_stm_cont_move_beta(:,1),'r','filled')
scatter([4 4 4],data_sum_cs_stm_cont_rest_beta(:,2),'k','filled')
scatter([5 5 5],data_sum_cs_stm_cont_move_beta(:,2),'r','filled')
scatter([7 7 7],data_sum_cs_stm_cont_rest_beta(:,3),'k','filled')
scatter([8 8 8],data_sum_cs_stm_cont_move_beta(:,3),'r','filled')
scatter([10 10 10],data_sum_cs_stm_cont_rest_beta(:,4),'k','filled')
scatter([11 11 11],data_sum_cs_stm_cont_move_beta(:,4),'r','filled')
title('cs stim cont beta whole (n=3)')
set(gca,'xlim',[0 12])

subplot(6,2,11)
hold on
scatter([1 1 1 1 1],data_sum_cs_non_ipsi_rest_beta(:,1),'k','filled')
scatter([2 2 2 2 2],data_sum_cs_non_ipsi_move_beta(:,1),'r','filled')
scatter([4 4 4 4 4],data_sum_cs_non_ipsi_rest_beta(:,2),'k','filled')
scatter([5 5 5 5 5],data_sum_cs_non_ipsi_move_beta(:,2),'r','filled')
scatter([7 7 7 7 7],data_sum_cs_non_ipsi_rest_beta(:,3),'k','filled')
scatter([8 8 8 8 8],data_sum_cs_non_ipsi_move_beta(:,3),'r','filled')
scatter([10 10 10 10 10],data_sum_cs_non_ipsi_rest_beta(:,4),'k','filled')
scatter([11 11 11 11 11],data_sum_cs_non_ipsi_move_beta(:,4),'r','filled')
title('cs non ipsi beta whole (n=5)')
set(gca,'xlim',[0 12])

subplot(6,2,12)
hold on
scatter([1 1 1 1 1],data_sum_cs_non_cont_rest_beta(:,1),'k','filled')
scatter([2 2 2 2 2],data_sum_cs_non_cont_move_beta(:,1),'r','filled')
scatter([4 4 4 4 4],data_sum_cs_non_cont_rest_beta(:,2),'k','filled')
scatter([5 5 5 5 5],data_sum_cs_non_cont_move_beta(:,2),'r','filled')
scatter([7 7 7 7 7],data_sum_cs_non_cont_rest_beta(:,3),'k','filled')
scatter([8 8 8 8 8],data_sum_cs_non_cont_move_beta(:,3),'r','filled')
scatter([10 10 10 10 10],data_sum_cs_non_cont_rest_beta(:,4),'k','filled')
scatter([11 11 11 11 11],data_sum_cs_non_cont_move_beta(:,4),'r','filled')
title('cs non cont beta whole (n=5)')
set(gca,'xlim',[0 12])


%figure #2
figure
subplot(2,2,1)
hold on
for i=1:size(data_sum_cs_stm_ipsi_rest_beta,1)
    plot(data_sum_cs_stm_ipsi_rest_beta(i,:),'-o','LineWidth',2,'MarkerSize',10)
end

for i=1:size(data_sum_cs_non_ipsi_rest_beta,1)
    plot(data_sum_cs_non_ipsi_rest_beta(i,:),'-x','LineWidth',2,'MarkerSize',10)
end
set(gca,'xlim',[0 5],'XTick',[1:4],'XTickLabel',['BL';'ES';'LS';'PS'])
title('cs rest ipsi beta')

subplot(2,2,2)
hold on
for i=1:size(data_sum_cs_stm_cont_rest_beta,1)
    plot(data_sum_cs_stm_cont_rest_beta(i,:),'-o','LineWidth',2,'MarkerSize',10)
end

for i=1:size(data_sum_cs_non_cont_rest_beta,1)
    plot(data_sum_cs_non_cont_rest_beta(i,:),'-x','LineWidth',2,'MarkerSize',10)
end
set(gca,'xlim',[0 5],'XTick',[1:4],'XTickLabel',['BL';'ES';'LS';'PS'])
title('cs rest cont beta')

subplot(2,2,3)
hold on
for i=1:size(data_sum_cs_stm_ipsi_move_beta,1)
    plot(data_sum_cs_stm_ipsi_move_beta(i,:),'-o','LineWidth',2,'MarkerSize',10)
end

for i=1:size(data_sum_cs_non_ipsi_move_beta,1)
    plot(data_sum_cs_non_ipsi_move_beta(i,:),'-x','LineWidth',2,'MarkerSize',10)
end
set(gca,'xlim',[0 5],'XTick',[1:4],'XTickLabel',['BL';'ES';'LS';'PS'])
title('cs move ipsi beta')

subplot(2,2,4)
hold on
for i=1:size(data_sum_cs_stm_cont_move_beta,1)
    plot(data_sum_cs_stm_cont_move_beta(i,:),'-o','LineWidth',2,'MarkerSize',10)
end

for i=1:size(data_sum_cs_non_cont_move_beta,1)
    plot(data_sum_cs_non_cont_move_beta(i,:),'-x','LineWidth',2,'MarkerSize',10)
end
set(gca,'xlim',[0 5],'XTick',[1:4],'XTickLabel',['BL';'ES';'LS';'PS'])
title('cs move cont beta')









