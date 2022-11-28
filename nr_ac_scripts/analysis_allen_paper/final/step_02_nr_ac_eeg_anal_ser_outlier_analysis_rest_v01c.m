function step_02_nr_ac_eeg_anal_ser_outlier_analysis_rest_v01c(sbjfolder,filt,plot_ind,scroll,save_outliers,freq_band,version)

%uses epochsWhole

% sbjfolder='~/nr_data_analysis/data_analyzed/eeg/gen_03/data/pro00087153_0003'
% plot_ind='yes'
% scroll='yes'
% save_outliers='no'
% freq_band='alpha'
% version='f'

sbjfind=strfind(sbjfolder,'pro');
sbjname=sbjfolder(sbjfind:sbjfind+15);

cd(sbjfolder)
load([sbjfolder,'/analysis/S1-VR_preproc/',sbjname,'_S1-VRdata_preprocessed.mat'])
if strcmp(filt,'no')
    load([sbjfolder,'/analysis/S3-EEGanalysis/s3_dat.mat'])
    load([sbjfolder,'/analysis/S3-EEGanalysis/s3_dat_rest.mat'])
elseif strcmp(filt,'yes')
    load([sbjfolder,'/analysis/S3-EEGanalysis/s3_dat_filt.mat'])
    load([sbjfolder,'/analysis/S3-EEGanalysis/s3_dat_filt_rest.mat'])
end
phase={'atStartPosition';'cueEvent';'targetUp'};
colors={'m','c','r','g','y','k','m','c','r','g'};
linestyle={'-','-','-','-','-','-','--','--','--','--'};
sp=[2,3,4,6,7,8,10,11,12,14,15,16];
sp11=[2,3,4,6,7,8,10,11,12,14,15,16];

if strcmp(freq_band,'alpha')
    frq_rng_st=8;
    frq_rng_ed=12;
elseif strcmp(freq_band,'beta')
    frq_rng_st=13;
    frq_rng_ed=31;
elseif strcmp(freq_band,'gamma')
    frq_rng_st=30;
    frq_rng_ed=50;
end

num_epochs=4;%size(structfun(@numel,epochs_rest.rest2),1);


if strcmp(plot_ind,'yes')
    for l=[7 18]%i=1:3
        for i=num_epochs:-1:1
            %for i=3:-1:1%l=[7 18]%i=1:3
    %             figure; set(gcf,'Position',[335 20 754 891])
    %             figure; set(gcf,'Position',[1119 25 744 898])
                %figure; set(gcf,'Position',[1755 40 754 891])%1948
                figure; set(gcf,'Position',[2240 401 754 881])%1948
                eval(['find_freq_plot_ch7_atRest=find(epochs_rest.rest2.t',num2str(i),'.psd.freq<=100);'])
                subplot(4,4,1); hold on 
                for j=1:10
                    eval(['plot(epochs_rest.rest2.t',num2str(i),'.psd.freq(find_freq_plot_ch7_atRest),log10(epochs_rest.rest2.t',num2str(i),...
                        '.psd.saw(find_freq_plot_ch7_atRest,l,j)),[colors{j},linestyle{j}])'])
                end
                %ylim1=get(gca,'ylim')
                %set(gca,'ylim',[-3 ylim1(2)])
                eval(['title([''sbj',sbjname(15:16),':ch',num2str(l),':t',num2str(i),':p0:',freq_band,'''])'])
                l1=legend('Position',[0.1368 0.5281 0.1197 0.1857],'String',{'epoch 1','epoch 2','epoch 3','epoch 4','epoch 5','epoch 6',...
                    'epoch 7','epoch 8','epoch 9','epoch 10'})

                for m=1:eval(['size(epochs_rest.rest2.t',num2str(i),'.val,1)'])%12 %plotting eeg signal for each epoch
                    subplot(4,4,sp(m))
                    eval(['plot(trialData.eeg.data(epochs_rest.rest2.t',num2str(i),'.val(m,1):epochs_rest.rest2.t',...
                        num2str(i),'.val(m,2),',num2str(l),'))'])
                    title(['e',num2str(m)])
                    eval(['find_freq_',freq_band,'_t',num2str(i),'_p0','=find(epochs_rest.rest2.t',num2str(i),...
                        '.psd.freq>=',num2str(frq_rng_st),' & epochs_rest.rest2.t',num2str(i),'.psd.freq<=',num2str(frq_rng_ed),');'])
                    eval(['mean_',freq_band,'_t',num2str(i),'_p0','_c',num2str(l),'(',num2str(m),')=mean(log10(epochs_rest.rest2.t',num2str(i),...
                        '.psd.saw(find_freq_',freq_band,'_t',num2str(i),'_p0',',',num2str(l),',',num2str(m),')));'])
                    eval(['[gen_var,out_mean_',freq_band,'_c',num2str(l),'_t',num2str(i),'_p0',']=find(isoutlier(mean_',freq_band,'_t',num2str(i),'_p0',...
                        '_c',num2str(l),',''quartiles'',''ThresholdFactor'',1.5));'])
                end

                subplot(4,4,[9 13]); hold on %plotting box plot
                eval(['boxplot(mean_',freq_band,'_t',num2str(i),'_p0','_c',num2str(l),')'])
                for n=1:eval(['size(epochs_rest.rest2.t',num2str(i),'.val,1)'])%10
                    eval(['text(1.1,mean_',freq_band,'_t',num2str(i),'_p0','_c',num2str(l),'(',num2str(n),'),''',num2str(n),''')'])
                end
            %end
        end
    end
elseif strcmp(plot_ind,'no')
    for l=[7 18]%i=1:3
        for i=num_epochs:-1:1
            %for i=3:-1:1%l=[7 18]%i=1:3
                for m=1:eval(['size(epochs_rest.rest2.t',num2str(i),'.val,1)'])%10 %plotting eeg signal for each epoch
                    eval(['find_freq_',freq_band,'_t',num2str(i),'_p0','=find(epochs_rest.rest2.t',num2str(i),...
                        '.psd.freq>=',num2str(frq_rng_st),' & epochs_rest.rest2.t',num2str(i),'.psd.freq<=',num2str(frq_rng_ed),');'])
                    eval(['mean_',freq_band,'_t',num2str(i),'_p0','_c',num2str(l),'(',num2str(m),')=mean(log10(epochs_rest.rest2.t',num2str(i),...
                        '.psd.saw(find_freq_',freq_band,'_t',num2str(i),'_p0',',',num2str(l),',',num2str(m),')))'])
                    eval(['[gen_var,out_mean_',freq_band,'_c',num2str(l),'_t',num2str(i),'_p0',']=find(isoutlier(mean_',freq_band,'_t',num2str(i),'_p0',...
                        '_c',num2str(l),',''quartiles'',''ThresholdFactor'',1.5))'])
                end
            %end
        end
    end
end

count=0;
for l=[18 7]
    for i=1:num_epochs
        %for i=1:3
            count=count+1;
            eval(['chk_outlier_var(',num2str(count),',1)=',num2str(l)])
            eval(['chk_outlier_var(',num2str(count),',2)=',num2str(i)])
            eval(['chk_outlier_var(',num2str(count),',3)=0'])
            eval(['chk_outlier_var(',num2str(count),',4)=size(out_mean_',freq_band,'_c',num2str(l),'_t',num2str(i),'_p0',',2);'])
        %end
    end
end

count=0;
for i=1:num_epochs
    %for i=1:3
        count=count+1;
            eval(['chk_epoch_count(',num2str(count),',1)=size(epochs_rest.rest2.t',num2str(i),'.val,1);'])
    %end
end

assignin('base','chk_outlier_var',chk_outlier_var)
assignin('base','chk_epoch_count',chk_epoch_count)

if strcmp(scroll,'yes')
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

    % Add VR event epochs
    for i=1:num_epochs
        for j=1:eval(['size(epochs_rest.rest2.t',num2str(i),'.val,1)'])
            temp_val=eval(['epochs_rest.rest2.t',num2str(i),'.val(',num2str(j),',1)'])
            h3=plot([temp_val temp_val],yplotlim,'-b','LineWidth',0.5);
            text(temp_val,0,['epoch ',num2str(j),':t',num2str(i),':ch7'],'FontSize',11,'Rotation',-90,'FontWeight','bold')
            text(temp_val,-20,['epoch ',num2str(j),':t',num2str(i),':ch18'],'FontSize',11,'Rotation',-90,'FontWeight','bold')
        end
    end
    
%     % Add VR whole epochs
%     for i=1:length(epochs.vrwhole.val)
%         h2=plot([epochs.vrwhole.val(i,1) epochs.vrwhole.val(i,1)],yplotlim,'-.g','LineWidth',1);
%         plot([epochs.vrwhole.val(i,2) epochs.vrwhole.val(i,2)],yplotlim,'-.r','LineWidth',1);
%         text(mean([epochs.vrwhole.val(i,1) epochs.vrwhole.val(i,2)]),yplotlim(2)*0.9,["VR Epoch",num2str(i)],'HorizontalAlign','Center')
%     end

%     % Epoch VR events
%     epocheventtypes={'atStartPosition','cueEvent','targetUp'};
%     epocheventlabels={'Hold','Prep','Move'};

%     % Add VR event epochs
%     for i=1:length(fieldnames(epochs.epochsWhole))
%         for z=1:length(epocheventtypes)
%             temp_val=eval(['epochs.epochsWhole.t',num2str(i),'.',epocheventtypes{z},'.val']);
%             for q=1:length(temp_val)
%                 h3=plot([temp_val(q) temp_val(q)],yplotlim,'-b','LineWidth',0.5);
%             end
%         end
%     end
% 
%     clearvars eventtimelist
%     fs=trialData.eeg.header.samplingrate;
%     for i=1:length(trialData.vr)
%         fieldnamesevents=fieldnames(trialData.vr(i).events);
%         eventtimelist=0;
%         for t=1:length(fieldnamesevents)-1
%             eval(['eventtimes=trialData.vr(i).events.',fieldnamesevents{t+1},'.time;'])
%             for q=1:length(eventtimes)
%                 if any(eventtimelist==eventtimes(q))
%                     text(eventtimes(q)*fs,0,['\leftarrow',fieldnamesevents{t+1},' ',num2str(q),'(',num2str(i),')'],'FontSize',11,'Rotation',-90,'FontWeight','bold')
%                     text(eventtimes(q)*fs,-20,['\leftarrow',fieldnamesevents{t+1},' ',num2str(q),'(',num2str(i),')'],'FontSize',11,'Rotation',-90,'FontWeight','bold')
%                 else
%                     text(eventtimes(q)*fs,0,['\leftarrow',fieldnamesevents{t+1},' ',num2str(q),'(',num2str(i),')'],'FontSize',11,'Rotation',90,'FontWeight','bold')
%                     text(eventtimes(q)*fs,-20,['\leftarrow',fieldnamesevents{t+1},' ',num2str(q),'(',num2str(i),')'],'FontSize',11,'Rotation',90,'FontWeight','bold')
%                 end
%                 eventtimelist=[eventtimelist eventtimes(q)];
%             end
%         end   
%     end
%     legend('C3','C4','EKG','VR','tDCS')

    for l=[18 7]%i=1:3
        for i=1:num_epochs
            %for i=1:3
                if eval(['isempty(out_mean_',freq_band,'_c',num2str(l),'_t',num2str(i),'_p0',')'])==1
                else
                    for k=1:eval(['size(out_mean_',freq_band,'_c',num2str(l),'_t',num2str(i),'_p0',',2)'])
                        eval(['epoch_st_out_mean_',freq_band,'_c',num2str(l),'_t',num2str(i),'_p0',...
                            '_',num2str(eval(['out_mean_',freq_band,'_c',num2str(l),'_t',num2str(i),'_p0','(',num2str(k),')'])),...
                            '=epochs_rest.rest2.t',num2str(i),'.val(',num2str(eval(['out_mean_',freq_band,'_c',num2str(l),'_t',num2str(i),'_p0','(',num2str(k),')'])),',1)'])
                        eval(['epoch_ed_out_mean_',freq_band,'_c',num2str(l),'_t',num2str(i),'_p0',...
                            '_',num2str(eval(['out_mean_',freq_band,'_c',num2str(l),'_t',num2str(i),'_p0','(',num2str(k),')'])),...
                            '=epochs_rest.rest2.t',num2str(i),'.val(',num2str(eval(['out_mean_',freq_band,'_c',num2str(l),'_t',num2str(i),'_p0','(',num2str(k),')'])),',2)'])

                    end
                end
            %end
        end
    end

    for l=[18 7]%not exactly sure why this is coded this way!!!!!
        for i=1:num_epochs
            %for i=1:3
                if eval(['isempty(out_mean_',freq_band,'_c',num2str(l),'_t',num2str(i),'_p0',')'])==1
                else
                    for k=1:eval(['size(out_mean_',freq_band,'_c',num2str(l),'_t',num2str(i),'_p0',',2)'])
                        if l==18
                            if i==1
                                eval(['plot(epoch_st_out_mean_',freq_band,'_c',num2str(l),'_t',num2str(i),'_p0',...
                                        '_',num2str(eval(['out_mean_',freq_band,'_c',num2str(l),'_t',num2str(i),'_p0','(',num2str(k),')'])),...
                                        ':epoch_ed_out_mean_',freq_band,'_c',num2str(l),'_t',num2str(i),'_p0',...
                                        '_',num2str(eval(['out_mean_',freq_band,'_c',num2str(l),'_t',num2str(i),'_p0','(',num2str(k),')'])),...
                                        ',(trialData.eeg.data(epoch_st_out_mean_',freq_band,'_c',num2str(l),'_t',num2str(i),'_p0',...
                                        '_',num2str(eval(['out_mean_',freq_band,'_c',num2str(l),'_t',num2str(i),'_p0','(',num2str(k),')'])),...
                                        ':epoch_ed_out_mean_',freq_band,'_c',num2str(l),'_t',num2str(i),'_p0',...
                                        '_',num2str(eval(['out_mean_',freq_band,'_c',num2str(l),'_t',num2str(i),'_p0','(',num2str(k),')'])),...
                                        ',',num2str(l),')-mean(trialData.eeg.data(:,',num2str(l),')))/std(trialData.eeg.data(:,',num2str(l),'))-20,''r'')'])
                            elseif i==2
                                eval(['plot(epoch_st_out_mean_',freq_band,'_c',num2str(l),'_t',num2str(i),'_p0',...
                                        '_',num2str(eval(['out_mean_',freq_band,'_c',num2str(l),'_t',num2str(i),'_p0','(',num2str(k),')'])),...
                                        ':epoch_ed_out_mean_',freq_band,'_c',num2str(l),'_t',num2str(i),'_p0',...
                                        '_',num2str(eval(['out_mean_',freq_band,'_c',num2str(l),'_t',num2str(i),'_p0','(',num2str(k),')'])),...
                                        ',(trialData.eeg.data(epoch_st_out_mean_',freq_band,'_c',num2str(l),'_t',num2str(i),'_p0',...
                                        '_',num2str(eval(['out_mean_',freq_band,'_c',num2str(l),'_t',num2str(i),'_p0','(',num2str(k),')'])),...
                                        ':epoch_ed_out_mean_',freq_band,'_c',num2str(l),'_t',num2str(i),'_p0',...
                                        '_',num2str(eval(['out_mean_',freq_band,'_c',num2str(l),'_t',num2str(i),'_p0','(',num2str(k),')'])),...
                                        ',',num2str(l),')-mean(trialData.eeg.data(:,',num2str(l),')))/std(trialData.eeg.data(:,',num2str(l),'))-20,''m'')'])
                            elseif i==3
                                eval(['plot(epoch_st_out_mean_',freq_band,'_c',num2str(l),'_t',num2str(i),'_p0',...
                                        '_',num2str(eval(['out_mean_',freq_band,'_c',num2str(l),'_t',num2str(i),'_p0','(',num2str(k),')'])),...
                                        ':epoch_ed_out_mean_',freq_band,'_c',num2str(l),'_t',num2str(i),'_p0',...
                                        '_',num2str(eval(['out_mean_',freq_band,'_c',num2str(l),'_t',num2str(i),'_p0','(',num2str(k),')'])),...
                                        ',(trialData.eeg.data(epoch_st_out_mean_',freq_band,'_c',num2str(l),'_t',num2str(i),'_p0',...
                                        '_',num2str(eval(['out_mean_',freq_band,'_c',num2str(l),'_t',num2str(i),'_p0','(',num2str(k),')'])),...
                                        ':epoch_ed_out_mean_',freq_band,'_c',num2str(l),'_t',num2str(i),'_p0',...
                                        '_',num2str(eval(['out_mean_',freq_band,'_c',num2str(l),'_t',num2str(i),'_p0','(',num2str(k),')'])),...
                                        ',',num2str(l),')-mean(trialData.eeg.data(:,',num2str(l),')))/std(trialData.eeg.data(:,',num2str(l),'))-20,''g'')'])
                            elseif i==4
                                eval(['plot(epoch_st_out_mean_',freq_band,'_c',num2str(l),'_t',num2str(i),'_p0',...
                                        '_',num2str(eval(['out_mean_',freq_band,'_c',num2str(l),'_t',num2str(i),'_p0','(',num2str(k),')'])),...
                                        ':epoch_ed_out_mean_',freq_band,'_c',num2str(l),'_t',num2str(i),'_p0',...
                                        '_',num2str(eval(['out_mean_',freq_band,'_c',num2str(l),'_t',num2str(i),'_p0','(',num2str(k),')'])),...
                                        ',(trialData.eeg.data(epoch_st_out_mean_',freq_band,'_c',num2str(l),'_t',num2str(i),'_p0',...
                                        '_',num2str(eval(['out_mean_',freq_band,'_c',num2str(l),'_t',num2str(i),'_p0','(',num2str(k),')'])),...
                                        ':epoch_ed_out_mean_',freq_band,'_c',num2str(l),'_t',num2str(i),'_p0',...
                                        '_',num2str(eval(['out_mean_',freq_band,'_c',num2str(l),'_t',num2str(i),'_p0','(',num2str(k),')'])),...
                                        ',',num2str(l),')-mean(trialData.eeg.data(:,',num2str(l),')))/std(trialData.eeg.data(:,',num2str(l),'))-20,''c'')'])
                            end
                        elseif l==7
                            if i==1
                                eval(['plot(epoch_st_out_mean_',freq_band,'_c',num2str(l),'_t',num2str(i),'_p0',...
                                        '_',num2str(eval(['out_mean_',freq_band,'_c',num2str(l),'_t',num2str(i),'_p0','(',num2str(k),')'])),...
                                        ':epoch_ed_out_mean_',freq_band,'_c',num2str(l),'_t',num2str(i),'_p0',...
                                        '_',num2str(eval(['out_mean_',freq_band,'_c',num2str(l),'_t',num2str(i),'_p0','(',num2str(k),')'])),...
                                        ',(trialData.eeg.data(epoch_st_out_mean_',freq_band,'_c',num2str(l),'_t',num2str(i),'_p0',...
                                        '_',num2str(eval(['out_mean_',freq_band,'_c',num2str(l),'_t',num2str(i),'_p0','(',num2str(k),')'])),...
                                        ':epoch_ed_out_mean_',freq_band,'_c',num2str(l),'_t',num2str(i),'_p0',...
                                        '_',num2str(eval(['out_mean_',freq_band,'_c',num2str(l),'_t',num2str(i),'_p0','(',num2str(k),')'])),...
                                        ',',num2str(l),')-mean(trialData.eeg.data(:,',num2str(l),')))/std(trialData.eeg.data(:,',num2str(l),')),''r'')'])
                            elseif i==2
                                eval(['plot(epoch_st_out_mean_',freq_band,'_c',num2str(l),'_t',num2str(i),'_p0',...
                                        '_',num2str(eval(['out_mean_',freq_band,'_c',num2str(l),'_t',num2str(i),'_p0','(',num2str(k),')'])),...
                                        ':epoch_ed_out_mean_',freq_band,'_c',num2str(l),'_t',num2str(i),'_p0',...
                                        '_',num2str(eval(['out_mean_',freq_band,'_c',num2str(l),'_t',num2str(i),'_p0','(',num2str(k),')'])),...
                                        ',(trialData.eeg.data(epoch_st_out_mean_',freq_band,'_c',num2str(l),'_t',num2str(i),'_p0',...
                                        '_',num2str(eval(['out_mean_',freq_band,'_c',num2str(l),'_t',num2str(i),'_p0','(',num2str(k),')'])),...
                                        ':epoch_ed_out_mean_',freq_band,'_c',num2str(l),'_t',num2str(i),'_p0',...
                                        '_',num2str(eval(['out_mean_',freq_band,'_c',num2str(l),'_t',num2str(i),'_p0','(',num2str(k),')'])),...
                                        ',',num2str(l),')-mean(trialData.eeg.data(:,',num2str(l),')))/std(trialData.eeg.data(:,',num2str(l),')),''m'')'])
                            elseif i==3
                                    eval(['plot(epoch_st_out_mean_',freq_band,'_c',num2str(l),'_t',num2str(i),'_p0',...
                                    '_',num2str(eval(['out_mean_',freq_band,'_c',num2str(l),'_t',num2str(i),'_p0','(',num2str(k),')'])),...
                                    ':epoch_ed_out_mean_',freq_band,'_c',num2str(l),'_t',num2str(i),'_p0',...
                                    '_',num2str(eval(['out_mean_',freq_band,'_c',num2str(l),'_t',num2str(i),'_p0','(',num2str(k),')'])),...
                                    ',(trialData.eeg.data(epoch_st_out_mean_',freq_band,'_c',num2str(l),'_t',num2str(i),'_p0',...
                                    '_',num2str(eval(['out_mean_',freq_band,'_c',num2str(l),'_t',num2str(i),'_p0','(',num2str(k),')'])),...
                                    ':epoch_ed_out_mean_',freq_band,'_c',num2str(l),'_t',num2str(i),'_p0',...
                                    '_',num2str(eval(['out_mean_',freq_band,'_c',num2str(l),'_t',num2str(i),'_p0','(',num2str(k),')'])),...
                                    ',',num2str(l),')-mean(trialData.eeg.data(:,',num2str(l),')))/std(trialData.eeg.data(:,',num2str(l),')),''g'')'])
                            elseif i==4
                                    eval(['plot(epoch_st_out_mean_',freq_band,'_c',num2str(l),'_t',num2str(i),'_p0',...
                                    '_',num2str(eval(['out_mean_',freq_band,'_c',num2str(l),'_t',num2str(i),'_p0','(',num2str(k),')'])),...
                                    ':epoch_ed_out_mean_',freq_band,'_c',num2str(l),'_t',num2str(i),'_p0',...
                                    '_',num2str(eval(['out_mean_',freq_band,'_c',num2str(l),'_t',num2str(i),'_p0','(',num2str(k),')'])),...
                                    ',(trialData.eeg.data(epoch_st_out_mean_',freq_band,'_c',num2str(l),'_t',num2str(i),'_p0',...
                                    '_',num2str(eval(['out_mean_',freq_band,'_c',num2str(l),'_t',num2str(i),'_p0','(',num2str(k),')'])),...
                                    ':epoch_ed_out_mean_',freq_band,'_c',num2str(l),'_t',num2str(i),'_p0',...
                                    '_',num2str(eval(['out_mean_',freq_band,'_c',num2str(l),'_t',num2str(i),'_p0','(',num2str(k),')'])),...
                                    ',',num2str(l),')-mean(trialData.eeg.data(:,',num2str(l),')))/std(trialData.eeg.data(:,',num2str(l),')),''c'')'])
                            end
                        end
                    end
                end
            %end
        end
    end


    %scroll through outliers 
    for l=[18 7]%i=1:3
        for i=1:num_epochs
            %for i=1:3
                if eval(['isempty(out_mean_',freq_band,'_c',num2str(l),'_t',num2str(i),'_p0',')'])==1
                else
                    for k=1:eval(['size(out_mean_',freq_band,'_c',num2str(l),'_t',num2str(i),'_p0',',2)'])
                        if l==18
                            input('press enter for next outlier')
                            eval(['set(gca(f1),''ylim'',[-25 -16],''xlim'',[epoch_st_out_mean_',freq_band,'_c',num2str(l),'_t',num2str(i),'_p0',...
                                    '_',num2str(eval(['out_mean_',freq_band,'_c',num2str(l),'_t',num2str(i),'_p0','(',num2str(k),')'])),...
                                    '-20000 epoch_st_out_mean_',freq_band,'_c',num2str(l),'_t',num2str(i),'_p0',...
                                    '_',num2str(eval(['out_mean_',freq_band,'_c',num2str(l),'_t',num2str(i),'_p0','(',num2str(k),')'])),...
                                    '+20000])'])
                        elseif l==7
                            input('press enter for next outlier')
                             eval(['set(gca(f1),''ylim'',[-6 6],''xlim'',[epoch_st_out_mean_',freq_band,'_c',num2str(l),'_t',num2str(i),'_p0',...
                                    '_',num2str(eval(['out_mean_',freq_band,'_c',num2str(l),'_t',num2str(i),'_p0','(',num2str(k),')'])),...
                                    '-20000 epoch_st_out_mean_',freq_band,'_c',num2str(l),'_t',num2str(i),'_p0',...
                                    '_',num2str(eval(['out_mean_',freq_band,'_c',num2str(l),'_t',num2str(i),'_p0','(',num2str(k),')'])),...
                                    '+20000])'])
                        end
                    end
                end
            %end
        end
    end
end

count=0;
for l=[18 7]%i=1:3
    for i=1:num_epochs
        %for i=1:3
            count=count+1;
            if eval(['isempty(out_mean_',freq_band,'_c',num2str(l),'_t',num2str(i),'_p0',')'])==1
                eval([sbjname,'_gen_03_ver_',version,'_rest_epochs_wo_outliers_',freq_band,'{count}=[1:',num2str(eval(['size(epochs_rest.rest2.t',num2str(i),'.val,1)'])),'];'])
            else
                eval([sbjname,'_gen_03_ver_',version,'_rest_epochs_wo_outliers_',freq_band,'{count}=setdiff([1:',num2str(eval(['size(epochs_rest.rest2.t',num2str(i),'.val,1);'])),...
                    '],out_mean_',freq_band,'_c',num2str(l),'_t',num2str(i),'_p0',');'])
            end
        %end
    end
end

if strcmp(filt,'no')
    if strcmp(save_outliers,'yes')
        save(['~/nr_data_analysis/data_analyzed/eeg/gen_03/data/',sbjname,'/analysis/S3-EEGanalysis/s3_dat_rest.mat'],[sbjname,'_gen_03_ver_',version,'_rest_epochs_wo_outliers_',freq_band],'-append')
    end
elseif strcmp(filt,'yes')
    if strcmp(save_outliers,'yes')
        save(['~/nr_data_analysis/data_analyzed/eeg/gen_03/data/',sbjname,'/analysis/S3-EEGanalysis/s3_dat_filt_rest.mat'],[sbjname,'_gen_03_ver_',version,'_rest_epochs_wo_outliers_',freq_band],'-append')
    end
end



                            
                         

 















