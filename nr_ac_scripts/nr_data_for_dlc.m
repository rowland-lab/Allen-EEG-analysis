sbjs_all=['03';'04';'05';'42';'43';'13';'15';'17';'18';'21';'22';'24';'25';'26';'29';'30';'20';'23';'27';'28';'36']

for i=1:21
    i
    load(['~/nr_data_analysis/data_analyzed/eeg/gen_03/',...
    'data/pro00087153_00',sbjs_all(i,:),'/analysis/S1-VR_preproc/',...
    'pro00087153_00',sbjs_all(i,:),'_S1-VRdata_preprocessed.mat'],'sessioninfo')
    save(['pro00087153_00',sbjs_all(i,:),'_sessioninfo'],'sessioninfo')
    cd ~/nr_data_analysis/data_analyzed/data_for_dlc
    clear sessioninfo
end