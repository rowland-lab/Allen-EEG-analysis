%function nr_eeg_anal_sum_07_ac(sbjfolder)

sbjfolder='~/nr_data_analysis/data_analyzed/eeg/gen_02/data/pro00087153_0003'
%sbjfolder='Z:\pro00087153_0003'
sbjfind=strfind(sbjfolder,'pro')
sbjname=sbjfolder(sbjfind:sbjfind+15)

%cd(sbjfolder)
load([sbjfolder,'/analysis/S1-VR_preproc/',sbjname,'_S1-VRdata_preprocessed.mat'])
%load([sbjfolder,'\analysis\S1-VR_preproc\',sbjname,'_S1-VRdata_preprocessed.mat'])

load([sbjfolder,'/analysis/S3-EEGanalysis/s3_dat.mat'])
%load([sbjfolder,'\analysis\S3-EEGanalysis\s3_dat.mat'])
phase={'atStartPosition';'cueEvent';'targetUp'}
colors={'m','c','r','g','y','k','m','c','r','g','m','k'}
linestyle={'-','-','-','-','-','-','--','--','--','--','.','--'}
sp=[2,3,4,6,7,8,10,11,12,14,15,16]
sp11=[2,3,4,6,7,8,10,11,12,14,15,16]


for l=[7]%i=1:3
    for j=4:-1:1
        for i=3:-1:1%l=[7 18]%i=1:3
%             figure; set(gcf,'Position',[335 20 754 891])
%             figure; set(gcf,'Position',[1119 25 744 898])
            figure; set(gcf,'Position',[3041 40 754 891])%1948
            eval(['find_psd_freq_t',num2str(j),'=find(epochs.epochsWhole.t',num2str(j),'.',phase{i},'.psd.freq<=100)'])
            subplot(4,4,1); hold on
            for k=1:eval(['size(epochs.epochsWhole.t',num2str(j),'.',phase{i},'.val,1)'])%12
                eval(['plot(epochs.epochsWhole.t',num2str(j),'.',phase{i},'.psd.freq(find_psd_freq_t',num2str(j),...
                    '),log10(epochs.epochsWhole.t',num2str(j),'.',phase{i},'.psd.saw(find_psd_freq_t',num2str(j),...
                    ',',num2str(l),',k)),[colors{k},linestyle{k}])'])
            end
            ylim1=get(gca,'ylim')
            set(gca,'ylim',[-3 ylim1(2)])
            eval(['title([''sbj',sbjname(15:16),':ch',num2str(l),':t',num2str(j),':p',num2str(i),'''])'])
            l1=legend('Position',[0.1368 0.5281 0.1197 0.1857],'String',{'reach 1','reach 2','reach 3','reach 4','reach 5','reach 6',...
                'reach 7','reach 8','reach 9','reach 10','reach 11','reach 12'})
            
            
            for m=1:eval(['size(epochs.epochsWhole.t',num2str(j),'.',phase{i},'.val,1)'])%12
                subplot(4,4,sp(m))
                eval(['plot(trialData.eeg.data(epochs.epochsWhole.t',num2str(j),'.',phase{i},'.val(m,1):epochs.epochsWhole.t',...
                    num2str(j),'.',phase{i},'.val(m,2),',num2str(l),'))'])
                title(['r',num2str(m)])
                eval(['find_freq_beta_t',num2str(j),'_p',num2str(i),'=find(epochs.epochsWhole.t',num2str(j),'.',phase{i},...
                    '.psd.freq>12 & epochs.epochsWhole.t',num2str(j),'.',phase{i},'.psd.freq<31)'])
                eval(['mean_beta_t',num2str(j),'_p',num2str(i),'_c',num2str(l),'(',num2str(m),')=mean(log10(epochs.epochsWhole.t',num2str(j),...
                    '.',phase{i},'.psd.saw(find_freq_beta_t',num2str(j),'_p',num2str(i),',',num2str(l),',',num2str(m),')))'])
                eval(['[gen_var,out_mean_beta_c',num2str(l),'_t',num2str(j),'_p',num2str(i),']=find(isoutlier(mean_beta_t',num2str(j),'_p',...
                    num2str(i),'_c',num2str(l),',''quartiles'',''ThresholdFactor'',1.5))'])
            end
            
            subplot(4,4,[9 13]); hold on
            eval(['boxplot(mean_beta_t',num2str(j),'_p',num2str(i),'_c',num2str(l),')'])
            for n=1:eval(['size(epochs.epochsWhole.t',num2str(j),'.',phase{i},'.val,1)'])%12
                eval(['text(1.1,mean_beta_t',num2str(j),'_p',num2str(i),'_c',num2str(l),'(',num2str(n),'),''',num2str(n),''')'])
            end
        end
    end
end

%%%%%%%%%%%%%%%%%% plotting outlier epochs %%%%%%%%%%%%%%%%%%
f1=figure('Position',[5 87 1131 852]); %[15 24 1618 923]
title(sbjname)
hold on
plot((trialData.eeg.data(:,7)-mean(trialData.eeg.data(:,7)))/std(trialData.eeg.data(:,7)))
plot((trialData.eeg.data(:,18)-mean(trialData.eeg.data(:,18)))/std(trialData.eeg.data(:,18))-20)
plot((trialData.eeg.data(:,23)-mean(trialData.eeg.data(:,18)))/std(trialData.eeg.data(:,23))-40)
plot((trialData.eeg.data(:,sessioninfo.vrchan)-mean(trialData.eeg.data(:,sessioninfo.vrchan)))/std(trialData.eeg.data(:,sessioninfo.vrchan))-60)
plot(((trialData.eeg.data(:,sessioninfo.tdcschan)-mean(trialData.eeg.data(:,sessioninfo.tdcschan)))/std(trialData.eeg.data(:,sessioninfo.tdcschan))*-1)-80,'LineWidth',2)
Session_times= sessioninfo.sessionperiod;
xlim([Session_times{1} Session_times{2}]);
yplotlim=get(gca,'ylim');

% Add rest epochs
for i=1:length(epochs.rest.val)
    h1=plot([epochs.rest.val(i,1) epochs.rest.val(i,1)],yplotlim,'-g','LineWidth',2);
    plot([epochs.rest.val(i,2) epochs.rest.val(i,2)],yplotlim,'-r','LineWidth',2);
    text(mean([epochs.rest.val(i,1) epochs.rest.val(i,2)]),yplotlim(2)*0.9,["Rest Epoch",num2str(i)],'HorizontalAlign','Center')
end

% Add VR whole epochs
for i=1:length(epochs.vrwhole.val)
    h2=plot([epochs.vrwhole.val(i,1) epochs.vrwhole.val(i,1)],yplotlim,'-.g','LineWidth',1);
    plot([epochs.vrwhole.val(i,2) epochs.vrwhole.val(i,2)],yplotlim,'-.r','LineWidth',1);
    text(mean([epochs.vrwhole.val(i,1) epochs.vrwhole.val(i,2)]),yplotlim(2)*0.9,["VR Epoch",num2str(i)],'HorizontalAlign','Center')
end

% Epoch VR events
epocheventtypes={'atStartPosition','cueEvent','targetUp'};
epocheventlabels={'Hold','Prep','Move'};

% min_epochlength=[];
% for i=1:length(trialData.vr)
%     for t=1:length(epocheventtypes)
%         switch epocheventtypes{t}
%             case 'atStartPosition'
%                 eval(['epochs.epochsWhole.t',num2str(i),'.atStartPosition.val=trialData.vr(i).events.',epocheventtypes{t},'.time(:)*trialData.eeg.header.samplingrate;'])
%             case 'cueEvent'
%                 eval(['epochs.epochsWhole.t',num2str(i),'.cueEvent.val=trialData.vr(i).events.',epocheventtypes{t},'.time(:)*trialData.eeg.header.samplingrate;'])
%                 min_epochlength=[min_epochlength; eval(['epochs.epochsWhole.t',num2str(i),'.cueEvent.val'])];
%             case 'targetUp'
%                 eval(['epochs.epochsWhole.t',num2str(i),'.targetUp.val=trialData.vr(i).events.',epocheventtypes{t},'.time(:)*trialData.eeg.header.samplingrate;'])
%                 min_epochlength=[min_epochlength; eval(['epochs.epochsWhole.t',num2str(i),'.targetUp.val'])];
%         end
%     end
% end
% min_epochlength=min(diff(sort(min_epochlength)));
% 
% for i=1:length(fieldnames(epochs.epochsWhole))
%     fn=fieldnames(epochs.epochsWhole);
%     for z=1:length(epocheventtypes)
%         epochs.epochsWhole.(fn{i}).(epocheventtypes{z}).val(:,2)=epochs.epochsWhole.(fn{i}).(epocheventtypes{z}).val(:,1)+min_epochlength;
%     end
% end
   
% Add VR event epochs
for i=1:length(fieldnames(epochs.epochsWhole))
    for z=1:length(epocheventtypes)
        temp_val=eval(['epochs.epochsWhole.t',num2str(i),'.',epocheventtypes{z},'.val']);
        for q=1:length(temp_val)
            h3=plot([temp_val(q) temp_val(q)],yplotlim,'-b','LineWidth',0.5);
        end
    end
end

clearvars eventtimelist
fs=trialData.eeg.header.samplingrate;
for i=1:length(trialData.vr)
    fieldnamesevents=fieldnames(trialData.vr(i).events);
    eventtimelist=0;
    for t=1:length(fieldnamesevents)-1
        eval(['eventtimes=trialData.vr(i).events.',fieldnamesevents{t+1},'.time;'])
        for q=1:length(eventtimes)
            if any(eventtimelist==eventtimes(q))
                text(eventtimes(q)*fs,0,['\leftarrow',fieldnamesevents{t+1},' ',num2str(q),'(',num2str(i),')'],'FontSize',11,'Rotation',-90,'FontWeight','bold')
                text(eventtimes(q)*fs,-20,['\leftarrow',fieldnamesevents{t+1},' ',num2str(q),'(',num2str(i),')'],'FontSize',11,'Rotation',-90,'FontWeight','bold')
            else
                text(eventtimes(q)*fs,0,['\leftarrow',fieldnamesevents{t+1},' ',num2str(q),'(',num2str(i),')'],'FontSize',11,'Rotation',90,'FontWeight','bold')
                text(eventtimes(q)*fs,-20,['\leftarrow',fieldnamesevents{t+1},' ',num2str(q),'(',num2str(i),')'],'FontSize',11,'Rotation',90,'FontWeight','bold')
            end
            eventtimelist=[eventtimelist eventtimes(q)];
        end
    end   
end
legend('C3','C4','EKG','VR','tDCS')

for l=[18 7]%i=1:3
    for j=1:4
        for i=1:3
            if eval(['isempty(out_mean_beta_c',num2str(l),'_t',num2str(j),'_p',num2str(i),')'])==1
            else
                for k=1:eval(['size(out_mean_beta_c',num2str(l),'_t',num2str(j),'_p',num2str(i),',2)'])
                    eval(['epoch_st_out_mean_beta_c',num2str(l),'_t',num2str(j),'_p',num2str(i),...
                        '_',num2str(eval(['out_mean_beta_c',num2str(l),'_t',num2str(j),'_p',num2str(i),'(',num2str(k),')'])),...
                        '=epochs.epochsWhole.t',num2str(j),'.',phase{i},'.val(',num2str(eval(['out_mean_beta_c',num2str(l),'_t',num2str(j),'_p',num2str(i),'(',num2str(k),')'])),',1)'])
                    eval(['epoch_ed_out_mean_beta_c',num2str(l),'_t',num2str(j),'_p',num2str(i),...
                        '_',num2str(eval(['out_mean_beta_c',num2str(l),'_t',num2str(j),'_p',num2str(i),'(',num2str(k),')'])),...
                        '=epochs.epochsWhole.t',num2str(j),'.',phase{i},'.val(',num2str(eval(['out_mean_beta_c',num2str(l),'_t',num2str(j),'_p',num2str(i),'(',num2str(k),')'])),',2)'])
                    
                end
            end
        end
    end
end
           
for l=[18 7]%i=1:3
    for j=1:4
        for i=1:3
            if eval(['isempty(out_mean_beta_c',num2str(l),'_t',num2str(j),'_p',num2str(i),')'])==1
            else
                for k=1:eval(['size(out_mean_beta_c',num2str(l),'_t',num2str(j),'_p',num2str(i),',2)'])
                    if l==18
                        if i==1
                            eval(['plot(epoch_st_out_mean_beta_c',num2str(l),'_t',num2str(j),'_p',num2str(i),...
                                    '_',num2str(eval(['out_mean_beta_c',num2str(l),'_t',num2str(j),'_p',num2str(i),'(',num2str(k),')'])),...
                                    ':epoch_ed_out_mean_beta_c',num2str(l),'_t',num2str(j),'_p',num2str(i),...
                                    '_',num2str(eval(['out_mean_beta_c',num2str(l),'_t',num2str(j),'_p',num2str(i),'(',num2str(k),')'])),...
                                    ',(trialData.eeg.data(epoch_st_out_mean_beta_c',num2str(l),'_t',num2str(j),'_p',num2str(i),...
                                    '_',num2str(eval(['out_mean_beta_c',num2str(l),'_t',num2str(j),'_p',num2str(i),'(',num2str(k),')'])),...
                                    ':epoch_ed_out_mean_beta_c',num2str(l),'_t',num2str(j),'_p',num2str(i),...
                                    '_',num2str(eval(['out_mean_beta_c',num2str(l),'_t',num2str(j),'_p',num2str(i),'(',num2str(k),')'])),...
                                    ',',num2str(l),')-mean(trialData.eeg.data(:,',num2str(l),')))/std(trialData.eeg.data(:,',num2str(l),'))-20,''r'')'])
                        elseif i==2
                            eval(['plot(epoch_st_out_mean_beta_c',num2str(l),'_t',num2str(j),'_p',num2str(i),...
                                    '_',num2str(eval(['out_mean_beta_c',num2str(l),'_t',num2str(j),'_p',num2str(i),'(',num2str(k),')'])),...
                                    ':epoch_ed_out_mean_beta_c',num2str(l),'_t',num2str(j),'_p',num2str(i),...
                                    '_',num2str(eval(['out_mean_beta_c',num2str(l),'_t',num2str(j),'_p',num2str(i),'(',num2str(k),')'])),...
                                    ',(trialData.eeg.data(epoch_st_out_mean_beta_c',num2str(l),'_t',num2str(j),'_p',num2str(i),...
                                    '_',num2str(eval(['out_mean_beta_c',num2str(l),'_t',num2str(j),'_p',num2str(i),'(',num2str(k),')'])),...
                                    ':epoch_ed_out_mean_beta_c',num2str(l),'_t',num2str(j),'_p',num2str(i),...
                                    '_',num2str(eval(['out_mean_beta_c',num2str(l),'_t',num2str(j),'_p',num2str(i),'(',num2str(k),')'])),...
                                    ',',num2str(l),')-mean(trialData.eeg.data(:,',num2str(l),')))/std(trialData.eeg.data(:,',num2str(l),'))-20,''m'')'])
                        elseif i==3
                            eval(['plot(epoch_st_out_mean_beta_c',num2str(l),'_t',num2str(j),'_p',num2str(i),...
                                    '_',num2str(eval(['out_mean_beta_c',num2str(l),'_t',num2str(j),'_p',num2str(i),'(',num2str(k),')'])),...
                                    ':epoch_ed_out_mean_beta_c',num2str(l),'_t',num2str(j),'_p',num2str(i),...
                                    '_',num2str(eval(['out_mean_beta_c',num2str(l),'_t',num2str(j),'_p',num2str(i),'(',num2str(k),')'])),...
                                    ',(trialData.eeg.data(epoch_st_out_mean_beta_c',num2str(l),'_t',num2str(j),'_p',num2str(i),...
                                    '_',num2str(eval(['out_mean_beta_c',num2str(l),'_t',num2str(j),'_p',num2str(i),'(',num2str(k),')'])),...
                                    ':epoch_ed_out_mean_beta_c',num2str(l),'_t',num2str(j),'_p',num2str(i),...
                                    '_',num2str(eval(['out_mean_beta_c',num2str(l),'_t',num2str(j),'_p',num2str(i),'(',num2str(k),')'])),...
                                    ',',num2str(l),')-mean(trialData.eeg.data(:,',num2str(l),')))/std(trialData.eeg.data(:,',num2str(l),'))-20,''g'')'])
                        end
                    elseif l==7
                        if i==1
                            eval(['plot(epoch_st_out_mean_beta_c',num2str(l),'_t',num2str(j),'_p',num2str(i),...
                                    '_',num2str(eval(['out_mean_beta_c',num2str(l),'_t',num2str(j),'_p',num2str(i),'(',num2str(k),')'])),...
                                    ':epoch_ed_out_mean_beta_c',num2str(l),'_t',num2str(j),'_p',num2str(i),...
                                    '_',num2str(eval(['out_mean_beta_c',num2str(l),'_t',num2str(j),'_p',num2str(i),'(',num2str(k),')'])),...
                                    ',(trialData.eeg.data(epoch_st_out_mean_beta_c',num2str(l),'_t',num2str(j),'_p',num2str(i),...
                                    '_',num2str(eval(['out_mean_beta_c',num2str(l),'_t',num2str(j),'_p',num2str(i),'(',num2str(k),')'])),...
                                    ':epoch_ed_out_mean_beta_c',num2str(l),'_t',num2str(j),'_p',num2str(i),...
                                    '_',num2str(eval(['out_mean_beta_c',num2str(l),'_t',num2str(j),'_p',num2str(i),'(',num2str(k),')'])),...
                                    ',',num2str(l),')-mean(trialData.eeg.data(:,',num2str(l),')))/std(trialData.eeg.data(:,',num2str(l),')),''r'')'])
                        elseif i==2
                            eval(['plot(epoch_st_out_mean_beta_c',num2str(l),'_t',num2str(j),'_p',num2str(i),...
                                    '_',num2str(eval(['out_mean_beta_c',num2str(l),'_t',num2str(j),'_p',num2str(i),'(',num2str(k),')'])),...
                                    ':epoch_ed_out_mean_beta_c',num2str(l),'_t',num2str(j),'_p',num2str(i),...
                                    '_',num2str(eval(['out_mean_beta_c',num2str(l),'_t',num2str(j),'_p',num2str(i),'(',num2str(k),')'])),...
                                    ',(trialData.eeg.data(epoch_st_out_mean_beta_c',num2str(l),'_t',num2str(j),'_p',num2str(i),...
                                    '_',num2str(eval(['out_mean_beta_c',num2str(l),'_t',num2str(j),'_p',num2str(i),'(',num2str(k),')'])),...
                                    ':epoch_ed_out_mean_beta_c',num2str(l),'_t',num2str(j),'_p',num2str(i),...
                                    '_',num2str(eval(['out_mean_beta_c',num2str(l),'_t',num2str(j),'_p',num2str(i),'(',num2str(k),')'])),...
                                    ',',num2str(l),')-mean(trialData.eeg.data(:,',num2str(l),')))/std(trialData.eeg.data(:,',num2str(l),')),''m'')'])
                        elseif i==3
                                eval(['plot(epoch_st_out_mean_beta_c',num2str(l),'_t',num2str(j),'_p',num2str(i),...
                                '_',num2str(eval(['out_mean_beta_c',num2str(l),'_t',num2str(j),'_p',num2str(i),'(',num2str(k),')'])),...
                                ':epoch_ed_out_mean_beta_c',num2str(l),'_t',num2str(j),'_p',num2str(i),...
                                '_',num2str(eval(['out_mean_beta_c',num2str(l),'_t',num2str(j),'_p',num2str(i),'(',num2str(k),')'])),...
                                ',(trialData.eeg.data(epoch_st_out_mean_beta_c',num2str(l),'_t',num2str(j),'_p',num2str(i),...
                                '_',num2str(eval(['out_mean_beta_c',num2str(l),'_t',num2str(j),'_p',num2str(i),'(',num2str(k),')'])),...
                                ':epoch_ed_out_mean_beta_c',num2str(l),'_t',num2str(j),'_p',num2str(i),...
                                '_',num2str(eval(['out_mean_beta_c',num2str(l),'_t',num2str(j),'_p',num2str(i),'(',num2str(k),')'])),...
                                ',',num2str(l),')-mean(trialData.eeg.data(:,',num2str(l),')))/std(trialData.eeg.data(:,',num2str(l),')),''g'')'])
                        end
                    end
                end
            end
        end
    end
end

%scroll through outliers 
for l=[18 7]%i=1:3
    for j=1:4
        for i=1:3
            if eval(['isempty(out_mean_beta_c',num2str(l),'_t',num2str(j),'_p',num2str(i),')'])==1
            else
                for k=1:eval(['size(out_mean_beta_c',num2str(l),'_t',num2str(j),'_p',num2str(i),',2)'])
                    if l==18
                        input('press enter for next outlier')
                        eval(['set(gca(f1),''ylim'',[-25 -16],''xlim'',[epoch_st_out_mean_beta_c',num2str(l),'_t',num2str(j),'_p',num2str(i),...
                                '_',num2str(eval(['out_mean_beta_c',num2str(l),'_t',num2str(j),'_p',num2str(i),'(',num2str(k),')'])),...
                                '-20000 epoch_st_out_mean_beta_c',num2str(l),'_t',num2str(j),'_p',num2str(i),...
                                '_',num2str(eval(['out_mean_beta_c',num2str(l),'_t',num2str(j),'_p',num2str(i),'(',num2str(k),')'])),...
                                '+20000])'])
                    elseif l==7
                        input('press enter for next outlier')
                         eval(['set(gca(f1),''ylim'',[-6 6],''xlim'',[epoch_st_out_mean_beta_c',num2str(l),'_t',num2str(j),'_p',num2str(i),...
                                '_',num2str(eval(['out_mean_beta_c',num2str(l),'_t',num2str(j),'_p',num2str(i),'(',num2str(k),')'])),...
                                '-20000 epoch_st_out_mean_beta_c',num2str(l),'_t',num2str(j),'_p',num2str(i),...
                                '_',num2str(eval(['out_mean_beta_c',num2str(l),'_t',num2str(j),'_p',num2str(i),'(',num2str(k),')'])),...
                                '+20000])'])
                    end
                end
            end
        end
    end
end

count=0
for l=[18 7]%i=1:3
    for j=1:4
        
        for i=1:3
            count=count+1
            if eval(['isempty(out_mean_beta_c',num2str(l),'_t',num2str(j),'_p',num2str(i),')'])==1
                eval([sbjname,'_reaches_wo_outliers{count}=[1:',num2str(eval(['size(epochs.epochsWhole.t',num2str(j),'.',phase{i},'.val,1)'])),']'])
            else
                eval([sbjname,'_reaches_wo_outliers{count}=setdiff([1:',num2str(eval(['size(epochs.epochsWhole.t',num2str(j),'.',phase{i},'.val,1)'])),...
                    '],out_mean_beta_c',num2str(l),'_t',num2str(j),'_p',num2str(i),')'])
            end
        end
    end
end

save(['~/nr_data_analysis/data_analyzed/eeg/gen_02//data/',sbjname,'/analysis/S3-EEGanalysis/s3_dat.mat'],[sbjname,'_reaches_wo_outliers1'],'-append')

%could make the background black perhaps to see the yellow outliers
%better(?)
%put subject number as title
%things to do - make figure an object
%make description bold

                            
                         

zoom_str_listbox = uicontrol(gcf,'Style','listbox','Position', [900 75 300 100],'BackgroundColor',[1 1 1]);

%     plot(epochs.epochsWhole.t1.atStartPosition.val(11,1):epochs.epochsWhole.t1.atStartPosition.val(11,2),...
%         figure
%     epoch_st=epochs.epochsWhole.t1.atStartPosition.val(11,1)
%     epoch_ed=epochs.epochsWhole.t1.atStartPosition.val(11,2)
%     figure
%     plot(epoch_st:epoch_ed,(trialData.eeg.data(epoch_st:epoch_ed,18)-mean(trialData.eeg.data(:,18)))/std(trialData.eeg.data(:,18))-20,'g')
%     :trialData.eeg.data(epoch_ed,18)]-mean(trialData.eeg.data(:,18)))/std(trialData.eeg.data(:,18))-20,'r')
%       figure; hold on
%     plot((trialData.eeg.data(4e6:5e6,18)-mean(trialData.eeg.data(:,18)))/std(trialData.eeg.data(:,18))-16,'k')
%     plot((trialData.eeg.data(1:4.6e6,18)-mean(trialData.eeg.data(:,18)))/std(trialData.eeg.data(:,18))-16,'m')
%     plot((trialData.eeg.data(epoch_st:0.1e6:epoch_ed,18)-mean(trialData.eeg.data(:,18)))/std(trialData.eeg.data(:,18))-10,'go')
%     plot(4.35e6,-8,'go')
%     plot(trialData.eeg.data(epochs.epochsWhole.t1.atStartPosition.val(11,1):epochs.epochsWhole.t1.atStartPosition.val(11,2),18),'r')
%     


%[a,b]=find(isoutlier(mean_beta_t2_p1_c18,'quartiles','ThresholdFactor',1.5))
% 
% (epochs.epochsWhole.t',num2str(j),'.',phase{i},'.val(m,1):epochs.epochsWhole.t',...
%                     num2str(j),'.',phase{i},'.val(m,2)
%                 for i=[1 2 4 5 8 12]
% eval(['reaches1(',num2str(i),',:)=trialData.eeg.data(epochs.epochsWhole.t2.atStartPosition.val(',num2str(i),...
%     ',1):epochs.epochsWhole.t2.atStartPosition.val(',num2str(i),',2),18);'])
%                 end
% mean_reaches1=mean(reaches1)
% figure; plot(mean_reaches1)
%         
%  mean(x,1)
        
%title('t1 atStartPosition')






% subplot(4,4,6)
% plot(trialData.eeg.data(epochs.epochsWhole.t1.atStartPosition.val(1,1):epochs.epochsWhole.t1.atStartPosition.val(1,2),7))




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

%the number of rejected trials did not differ between groups


