function nr_eeg_anal_sum_07_ac(sbjfolder)

sbjfolder='~/nr_data_analysis/data_analyzed/eeg/gen_02/data/pro00087153_0003'
sbjfind=strfind(sbjfolder,'pro')
sbjname=sbjfolder(sbjfind:sbjfind+15)

%cd(sbjfolder)
load([sbjfolder,'/analysis/S1-VR_preproc/',sbjname,'_S1-VRdata_preprocessed.mat'])
load([sbjfolder,'/analysis/S3-EEGanalysis/s3_dat.mat'])
phase={'atStartPosition';'cueEvent';'targetUp'}
colors={'m','c','r','g','y','k','m','c','r','g','y','k'}
linestyle={'-','-','-','-','-','-','--','--','--','--','--','--'}
sp=[2,3,4,6,7,8,10,11,12,14,15,16]


for i=1:3
    for j=2%1:4
        for l=18%[7 18]
            figure; set(gcf,'Position',[1119 25 744 898])
            eval(['find_psd_freq_t',num2str(j),'=find(epochs.vrevents.t',num2str(j),'.',phase{i},'.psd.freq<=100)'])
            subplot(4,4,1); hold on
            for k=1:12
                eval(['plot(epochs.vrevents.t',num2str(j),'.',phase{i},'.psd.freq(find_psd_freq_t',num2str(j),...
                    '),log10(epochs.vrevents.t',num2str(j),'.',phase{i},'.psd.saw(find_psd_freq_t',num2str(j),...
                    ',',num2str(l),',k)),[colors{k},linestyle{k}])'])
            end
            eval(['title([''sbj',sbjname(15:16),':ch',num2str(l),':t',num2str(j),':p',num2str(i),'''])'])
            l1=legend('Position',[0.1368 0.5281 0.1197 0.1857],'String',{'reach 1','reach 2','reach 3','reach 4','reach 5','reach 6',...
                'reach 7','reach 8','reach 9','reach 10','reach 11','reach 12'})
            
            for m=1:12
                subplot(4,4,sp(m))
                eval(['plot(trialData.eeg.data(epochs.vrevents.t',num2str(j),'.',phase{i},'.val(m,1):epochs.vrevents.t',...
                    num2str(j),'.',phase{i},'.val(m,2),',num2str(l),'))'])
                title(['r',num2str(m)])
                eval(['find_freq_beta_t',num2str(j),'_p',num2str(i),'=find(epochs.vrevents.t',num2str(j),'.',phase{i},...
                    '.psd.freq>12 & epochs.vrevents.t',num2str(j),'.',phase{i},'.psd.freq<31)'])
                eval(['mean_beta_t',num2str(j),'_p',num2str(i),'_c',num2str(l),'(',num2str(m),')=mean(log10(epochs.vrevents.t',num2str(j),...
                    '.',phase{i},'.psd.saw(find_freq_beta_t',num2str(j),'_p',num2str(i),',',num2str(l),',',num2str(m),')))'])
            end
            
            subplot(4,4,[9 13]); hold on
            eval(['boxplot(mean_beta_t',num2str(j),'_p',num2str(i),'_c',num2str(l),')'])
            for n=1:12
                eval(['text(1.1,mean_beta_t',num2str(j),'_p',num2str(i),'_c',num2str(l),'(',num2str(n),'),''',num2str(n),''')'])
            end
        end
    end
end
        
        
        
%title('t1 atStartPosition')






% subplot(4,4,6)
% plot(trialData.eeg.data(epochs.vrevents.t1.atStartPosition.val(1,1):epochs.vrevents.t1.atStartPosition.val(1,2),7))




%first go through and note on database which subjects had rejected trials
%to begin with and then note whether delays and such also resulted in weird
%looking psd's
%so you will need to do for all phases and reaches for both channels, plot
%out all 12 epochs for each of those conditions
%then you should compare with original epoch plo but you should plot with
%'.' so you can get specific epoch values
%at some point you need to be able to view video at that same epoch time

%once you've figured all that out, need to try different methods, ica, car,
%bandpass filtering on beta to see which works best



