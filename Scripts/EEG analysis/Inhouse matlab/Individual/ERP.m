% Enter gitpath
gitpath='C:\Users\allen\Documents\GitHub\Allen-EEG-analysis';
cd(gitpath)

% Enter in protocol folder
protocolfolder='C:\Users\allen\Box Sync\Desktop\Allen_Rowland_EEG\protocol_00087153';

% Add EEG related paths
allengit_genpaths(gitpath,'EEG')

% Detect subjects
sbj=dir(fullfile(protocolfolder,'pro000*'));
sbj={sbj.name}';


%%

sbjname=sbj{1}
sbjfolder=fullfile(protocolfolder,sbjname);
load(fullfile(sbjfolder,'analysis','S1-VR_preproc',[sbjname,'_S1-VRdata_preprocessed.mat']));
load(fullfile(sbjfolder,'analysis','S3-EEGanalysis','s3_dat.mat'));

phase={'atStartPosition';'cueEvent';'targetUp'}
colors={'m','c','r','g','y','k','m','c','r','g','y','k'}
linestyle={'-','-','-','-','-','-','--','--','--','--','--','--'}
sp=[2,3,4,6,7,8,10,11,12,14,15,16]

for i=1:3
    for j=1:4
        for l=18%[7 18]
            figure; set(gcf,'WindowState','maximized')
            sgtitle(sprintf('%s trial %u (%s), Channel %u',sbjname,j,phase{i},l),'Interpreter','none')
            eval(['find_psd_freq_t',num2str(j),'=find(epochs.vrevents.t',num2str(j),'.',phase{i},'.psd.freq<=100)'])
            
            temp_mean=[];
            for m=1:12
                subplot(4,4,sp(m))
                temp=trialData.eeg.data(epochs.vrevents.(['t',num2str(j)]).(phase{i}).val(m,1):epochs.vrevents.(['t',num2str(j)]).(phase{i}).val(m,2),l);
                plot(temp)
                title(['r',num2str(m)])
                eval(['find_freq_beta_t',num2str(j),'_p',num2str(i),'=find(epochs.vrevents.t',num2str(j),'.',phase{i},...
                    '.psd.freq>12 & epochs.vrevents.t',num2str(j),'.',phase{i},'.psd.freq<31)'])
                eval(['mean_beta_t',num2str(j),'_p',num2str(i),'_c',num2str(l),'(',num2str(m),')=mean(log10(epochs.vrevents.t',num2str(j),...
                    '.',phase{i},'.psd.saw(find_freq_beta_t',num2str(j),'_p',num2str(i),',',num2str(l),',',num2str(m),')))'])
                temp_mean(m,:)=temp';
            end
            
            subplot(4,4,1);
            plot(mean(temp_mean,1))
            title('Mean')
            
            subplot(4,4,5);
            plot(movmean(mean(temp_mean,1),100))
            title('Moving Mean')

            
            subplot(4,4,[9 13]); hold on
            eval(['boxplot(mean_beta_t',num2str(j),'_p',num2str(i),'_c',num2str(l),')'])
            for n=1:12
                eval(['text(1.1,mean_beta_t',num2str(j),'_p',num2str(i),'_c',num2str(l),'(',num2str(n),'),''',num2str(n),''')'])
            end
        end
    end
end