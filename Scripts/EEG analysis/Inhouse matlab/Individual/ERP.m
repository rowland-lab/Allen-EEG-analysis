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
disp('loading S1');load(fullfile(sbjfolder,'analysis','S1-VR_preproc',[sbjname,'_S1-VRdata_preprocessed.mat']));
disp('loading S3');load(fullfile(sbjfolder,'analysis','S3-EEGanalysis','s3_dat.mat'));
fs=trialData.eeg.header.samplingrate;

phase={'atStartPosition';'cueEvent';'targetUp'};
colors={'m','c','r','g','y','k','m','c','r','g','y','k'};
linestyle={'-','-','-','-','-','-','--','--','--','--','--','--'};
sp=[2,3,4,6,7,8,10,11,12,14,15,16];

for p=3
    for t=1:4
        for cn=7%[7 18]
            figure; set(gcf,'WindowState','maximized')
            sgtitle(sprintf('%s trial %u (%s), Channel %u',sbjname,t,phase{p},cn),'Interpreter','none')
            eval(['find_psd_freq_t',num2str(t),'=find(epochs.vrevents.t',num2str(t),'.',phase{p},'.psd.freq<=100)'])
            
            temp_mean=[];
            for m=1:12
                subplot(4,4,sp(m))
                temp=trialData.eeg.data(epochs.vrevents.(['t',num2str(t)]).(phase{p}).val(m,1):epochs.vrevents.(['t',num2str(t)]).(phase{p}).val(m,2),cn);
                plot(temp)
                title(['r',num2str(m)])
                eval(['find_freq_beta_t',num2str(t),'_p',num2str(p),'=find(epochs.vrevents.t',num2str(t),'.',phase{p},...
                    '.psd.freq>12 & epochs.vrevents.t',num2str(t),'.',phase{p},'.psd.freq<31)'])
                eval(['mean_beta_t',num2str(t),'_p',num2str(p),'_c',num2str(cn),'(',num2str(m),')=mean(log10(epochs.vrevents.t',num2str(t),...
                    '.',phase{p},'.psd.saw(find_freq_beta_t',num2str(t),'_p',num2str(p),',',num2str(cn),',',num2str(m),')))'])
                temp_mean(m,:)=temp';
            end
            subplot(4,4,1);
            temp=[epochs.vrevents.(['t',num2str(t)]).atStartPosition.val(1,1),epochs.vrevents.(['t',num2str(t)]).targetUp.val(end,1)];
            plot(trialData.eeg.data(temp(1):temp(2),cn))
            title('Trial EEG')
            
            subplot(4,4,5);
            plot(mean(temp_mean,1))
            title('Mean')
            
            subplot(4,4,9);
            plot(movmean(mean(temp_mean,1),100))
            title('Moving Mean')

        end
    end
end

%%
erpLength=2;
for p=3
    for t=1:4
        for cn=7%[7 18]
            figure; set(gcf,'WindowState','maximized')
            sgtitle(sprintf('%s trial %u (%s), Channel %u',sbjname,t,phase{p},cn),'Interpreter','none')
            eval(['find_psd_freq_t',num2str(t),'=find(epochs.vrevents.t',num2str(t),'.',phase{p},'.psd.freq<=100)'])
            
            temp_mean=[];
            for m=1:12
                subplot(4,4,sp(m))
                event_time=epochs.vrevents.(['t',num2str(t)]).(phase{p}).val(m,1);
                temp=trialData.eeg.data(event_time-erpLength*fs:event_time+erpLength*fs,cn);
                plot(-2:4/numel(temp):2-4/numel(temp),temp)
                hold on
                xline(0,'r--');
                title(['r',num2str(m)])
                eval(['find_freq_beta_t',num2str(t),'_p',num2str(p),'=find(epochs.vrevents.t',num2str(t),'.',phase{p},...
                    '.psd.freq>12 & epochs.vrevents.t',num2str(t),'.',phase{p},'.psd.freq<31)'])
                eval(['mean_beta_t',num2str(t),'_p',num2str(p),'_c',num2str(cn),'(',num2str(m),')=mean(log10(epochs.vrevents.t',num2str(t),...
                    '.',phase{p},'.psd.saw(find_freq_beta_t',num2str(t),'_p',num2str(p),',',num2str(cn),',',num2str(m),')))'])
                temp_mean(m,:)=temp';
            end
            subplot(4,4,1);
            temp_time=[epochs.vrevents.(['t',num2str(t)]).atStartPosition.val(1,1),epochs.vrevents.(['t',num2str(t)]).targetUp.val(end,1)];
            plot(trialData.eeg.data(temp_time(1):temp_time(2),cn))
            hold on
            xline(0,'r--');
            title('Trial EEG')
            
            subplot(4,4,5);
            plot(-2:4/numel(temp):2-4/numel(temp),mean(temp_mean,1))
            hold on
            xline(0,'r--');
            title('Mean')
            
            subplot(4,4,9);
            plot(-2:4/numel(temp):2-4/numel(temp),movmean(mean(temp_mean,1),100))
            hold on
            xline(0,'r--');
            title('Moving Mean')

        end
    end
end