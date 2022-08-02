function nr_eeg_anal_09_recalc_supermeans(data_file)

%io
load(data_file)

data_file=data_eeg_anal_rest_pro00087153_0003;

data=data_file;

%params
frq_band_ind=data.cfg.info.frq_band_ind;
frq_band_txt=data.cfg.info.frq_band_txt;
mat_trial_epoch=data.cfg.info.mat_trial_epoch;

%calculate psd of sai epoch_new
for i=1:size(mat_trial_epoch,1)
    for j=1:mat_trial_epoch(i,3)
        for k=1:eval(['(data.trials.t',num2str(i),'.epochs_new.e',num2str(j),'_7(2)-data.trials.t',...
                num2str(i),'.epochs_new.e',num2str(j),'_7(1))/1000'])
            eval(['data.trials.t',num2str(i),'.psd.e',num2str(j),'.sai_new_7.vals(',num2str(k),',:,:)=pwelch(data.trials.t',...
                num2str(i),'.sig.eeg([(',num2str(k),'-1)*1000+1+data.trials.t',num2str(i),'.epochs_new.e',num2str(j),...
                '_7(1):',num2str(k),'*1000+data.trials.t',num2str(i),'.epochs_new.e',num2str(j),'_7(1)],:),512,0.5,512,1000);']);
        end
        
        for k=1:eval(['(data.trials.t',num2str(i),'.epochs_new.e',num2str(j),'_18(2)-data.trials.t',...
                num2str(i),'.epochs_new.e',num2str(j),'_18(1))/1000'])
            eval(['data.trials.t',num2str(i),'.psd.e',num2str(j),'.sai_new_18.vals(',num2str(k),',:,:)=pwelch(data.trials.t',...
                num2str(i),'.sig.eeg([(',num2str(k),'-1)*1000+1+data.trials.t',num2str(i),'.epochs_new.e',num2str(j),...
                '_18(1):',num2str(k),'*1000+data.trials.t',num2str(i),'.epochs_new.e',num2str(j),'_18(1)],:),512,0.5,512,1000);']);
        end
    end
end

% calculate epoch_new mean psd of each freq band for each segment
for i=1:size(mat_trial_epoch,1)
    for j=1:mat_trial_epoch(i,3)
        for k=1:size(frq_band_ind,2)
            for m=1:eval(['size(data.trials.t',num2str(i),'.psd.e',num2str(j),'.sai_new_7.vals,1)'])
                eval(['data.trials.t',num2str(i),'.psd.e',num2str(j),'.sai_new_7.means.',frq_band_txt{k},'(',num2str(m),',:)=mean(data.trials.t',num2str(i),'.psd.e',num2str(j),'.sai_new_7.vals(',...
                    num2str(m),',',frq_band_ind{k},',:));']);
            end 
            
            for m=1:eval(['size(data.trials.t',num2str(i),'.psd.e',num2str(j),'.sai_new_18.vals,1)'])
                eval(['data.trials.t',num2str(i),'.psd.e',num2str(j),'.sai_new_18.means.',frq_band_txt{k},'(',num2str(m),',:)=mean(data.trials.t',num2str(i),'.psd.e',num2str(j),'.sai_new_18.vals(',...
                    num2str(m),',',frq_band_ind{k},',:));']);
            end 
        end
    end
end

%calculate epoch_new supermeans and ses
for i=1:size(mat_trial_epoch,1)
    for j=1:mat_trial_epoch(i,3)
        for k=1:size(frq_band_ind,2)
            eval(['data.trials.t',num2str(i),'.psd.e',num2str(j),'.sai_new_7.supermeans.',frq_band_txt{k},'=mean(data.trials.t',num2str(i),'.psd.e',num2str(j),'.sai_new_7.means.',...
                frq_band_txt{k},');']);
            eval(['data.trials.t',num2str(i),'.psd.e',num2str(j),'.sai_new_7.ses.',frq_band_txt{k},'=std(data.trials.t',num2str(i),'.psd.e',num2str(j),'.sai_new_7.means.',...
                frq_band_txt{k},')/sqrt(size(data.trials.t',num2str(i),'.psd.e',num2str(j),'.sai_new_7.means.',frq_band_txt{k},',1))']);
            
            eval(['data.trials.t',num2str(i),'.psd.e',num2str(j),'.sai_new_18.supermeans.',frq_band_txt{k},'=mean(data.trials.t',num2str(i),'.psd.e',num2str(j),'.sai_new_18.means.',...
                frq_band_txt{k},');']);
            eval(['data.trials.t',num2str(i),'.psd.e',num2str(j),'.sai_new_18.ses.',frq_band_txt{k},'=std(data.trials.t',num2str(i),'.psd.e',num2str(j),'.sai_new_18.means.',...
                frq_band_txt{k},')/sqrt(size(data.trials.t',num2str(i),'.psd.e',num2str(j),'.sai_new_18.means.',frq_band_txt{k},',1))']);
        end
    end
end

%plot epoch_new sai means
figure
set(gcf,'Position',[2308 69 1295 1393])
subplot(4,4,1); hold on
bar(data.trials.t1.psd.e1.sai_new_7.means.beta(:,7))
mean_sai_means_e1_7_new=mean(data.trials.t1.psd.e1.sai_new_7.means.beta(:,7));
std_sai_means_e1_7_new=std(data.trials.t1.psd.e1.sai_new_7.means.beta(:,7));
plot([0 size(data.trials.t1.psd.e1.sai_new_7.means.beta(:,7),1)],...
    [mean_sai_means_e1_7_new mean_sai_means_e1_7_new],'r','LineWidth',2)
plot([0 size(data.trials.t1.psd.e1.sai_new_7.means.beta(:,7),1)],...
    [mean_sai_means_e1_7_new+3*std_sai_means_e1_7_new mean_sai_means_e1_7_new+3*std_sai_means_e1_7_new],'--r','LineWidth',2)
title('e1 7 new')
y_lim_01_1=get(gca,'ylim');

subplot(4,4,5); hold on
bar(data.trials.t1.psd.e2.sai_new_7.means.beta(:,7))
mean_sai_means_e2_7_new=mean(data.trials.t1.psd.e2.sai_new_7.means.beta(:,7));
std_sai_means_e2_7_new=std(data.trials.t1.psd.e2.sai_new_7.means.beta(:,7));
plot([0 size(data.trials.t1.psd.e2.sai_new_7.means.beta(:,7),1)],...
    [mean_sai_means_e2_7_new mean_sai_means_e2_7_new],'r','LineWidth',2)
plot([0 size(data.trials.t1.psd.e2.sai_new_7.means.beta(:,7),1)],...
    [mean_sai_means_e2_7_new+3*std_sai_means_e2_7_new mean_sai_means_e2_7_new+3*std_sai_means_e2_7_new],'--r','LineWidth',2)
title('e2 7 new')
y_lim_01_2=get(gca,'ylim');

subplot(4,4,9); hold on
bar(data.trials.t1.psd.e3.sai_new_7.means.beta(:,7))
mean_sai_means_e3_7_new=mean(data.trials.t1.psd.e3.sai_new_7.means.beta(:,7));
std_sai_means_e3_7_new=std(data.trials.t1.psd.e3.sai_new_7.means.beta(:,7));
plot([0 size(data.trials.t1.psd.e3.sai_new_7.means.beta(:,7),1)],...
    [mean_sai_means_e3_7_new mean_sai_means_e3_7_new],'r','LineWidth',2)
plot([0 size(data.trials.t1.psd.e3.sai_new_7.means.beta(:,7),1)],...
    [mean_sai_means_e3_7_new+3*std_sai_means_e3_7_new mean_sai_means_e3_7_new+3*std_sai_means_e3_7_new],'--r','LineWidth',2)
title('e3 7 new')
y_lim_01_3=get(gca,'ylim');

subplot(4,4,13); hold on
bar(data.trials.t1.psd.e4.sai_new_7.means.beta(:,7))
mean_sai_means_e4_7_new=mean(data.trials.t1.psd.e4.sai_new_7.means.beta(:,7));
std_sai_means_e4_7_new=std(data.trials.t1.psd.e4.sai_new_7.means.beta(:,7));
plot([0 size(data.trials.t1.psd.e4.sai_new_7.means.beta(:,7),1)],...
    [mean_sai_means_e4_7_new mean_sai_means_e4_7_new],'r','LineWidth',2)
plot([0 size(data.trials.t1.psd.e4.sai_new_7.means.beta(:,7),1)],...
    [mean_sai_means_e4_7_new+3*std_sai_means_e4_7_new mean_sai_means_e4_7_new+3*std_sai_means_e4_7_new],'--r','LineWidth',2)
title('e4 7 new')
y_lim_01_4=get(gca,'ylim');

subplot(4,4,2); hold on
bar(data.trials.t1.psd.e1.sai_new_18.means.beta(:,18))
mean_sai_means_e1_18_new=mean(data.trials.t1.psd.e1.sai_new_18.means.beta(:,18));
std_sai_means_e1_18_new=std(data.trials.t1.psd.e1.sai_new_18.means.beta(:,18));
plot([0 size(data.trials.t1.psd.e1.sai_new_18.means.beta(:,18),1)],...
    [mean_sai_means_e1_18_new mean_sai_means_e1_18_new],'r','LineWidth',2)
plot([0 size(data.trials.t1.psd.e1.sai_new_18.means.beta(:,18),1)],...
    [mean_sai_means_e1_18_new+3*std_sai_means_e1_18_new mean_sai_means_e1_18_new+3*std_sai_means_e1_18_new],'--r','LineWidth',2)
title('e1 18 new')
y_lim_01_5=get(gca,'ylim');

subplot(4,4,6); hold on
bar(data.trials.t1.psd.e2.sai_new_18.means.beta(:,18))
mean_sai_means_e2_18_new=mean(data.trials.t1.psd.e2.sai_new_18.means.beta(:,18));
std_sai_means_e2_18_new=std(data.trials.t1.psd.e2.sai_new_18.means.beta(:,18));
plot([0 size(data.trials.t1.psd.e2.sai_new_18.means.beta(:,18),1)],...
    [mean_sai_means_e2_18_new mean_sai_means_e2_18_new],'r','LineWidth',2)
plot([0 size(data.trials.t1.psd.e2.sai_new_18.means.beta(:,18),1)],...
    [mean_sai_means_e2_18_new+3*std_sai_means_e2_18_new mean_sai_means_e2_18_new+3*std_sai_means_e2_18_new],'--r','LineWidth',2)
title('e2 18 new')
y_lim_01_6=get(gca,'ylim');

subplot(4,4,10); hold on
bar(data.trials.t1.psd.e3.sai_new_18.means.beta(:,18))
mean_sai_means_e3_18_new=mean(data.trials.t1.psd.e3.sai_new_18.means.beta(:,18));
std_sai_means_e3_18_new=std(data.trials.t1.psd.e3.sai_new_18.means.beta(:,18));
plot([0 size(data.trials.t1.psd.e3.sai_new_18.means.beta(:,18),1)],...
    [mean_sai_means_e3_18_new mean_sai_means_e3_18_new],'r','LineWidth',2)
plot([0 size(data.trials.t1.psd.e3.sai_new_18.means.beta(:,18),1)],...
    [mean_sai_means_e3_18_new+3*std_sai_means_e3_18_new mean_sai_means_e3_18_new+3*std_sai_means_e3_18_new],'--r','LineWidth',2)
title('e3 18 new')
y_lim_01_7=get(gca,'ylim');

subplot(4,4,14); hold on
bar(data.trials.t1.psd.e4.sai_new_18.means.beta(:,18))
mean_sai_means_e4_18_new=mean(data.trials.t1.psd.e4.sai_new_18.means.beta(:,18));
std_sai_means_e4_18_new=std(data.trials.t1.psd.e4.sai_new_18.means.beta(:,18));
plot([0 size(data.trials.t1.psd.e4.sai_new_18.means.beta(:,18),1)],...
    [mean_sai_means_e4_18_new mean_sai_means_e4_18_new],'r','LineWidth',2)
plot([0 size(data.trials.t1.psd.e4.sai_new_18.means.beta(:,18),1)],...
    [mean_sai_means_e4_18_new+3*std_sai_means_e4_18_new mean_sai_means_e4_18_new+3*std_sai_means_e4_18_new],'--r','LineWidth',2)
title('e4 18 new')
y_lim_01_8=get(gca,'ylim');

subplot(4,4,1)
set(gca,'ylim',[min([y_lim_01_1(1) y_lim_01_2(1) y_lim_01_3(1) y_lim_01_4(1) y_lim_01_5(1) y_lim_01_6(1) y_lim_01_7(1) y_lim_01_8(1)]),...
    max([y_lim_01_1(2) y_lim_01_2(2) y_lim_01_3(2) y_lim_01_4(2) y_lim_01_5(2) y_lim_01_6(2) y_lim_01_7(2) y_lim_01_8(2)])])

subplot(4,4,5)
set(gca,'ylim',[min([y_lim_01_1(1) y_lim_01_2(1) y_lim_01_3(1) y_lim_01_4(1) y_lim_01_5(1) y_lim_01_6(1) y_lim_01_7(1) y_lim_01_8(1)]),...
    max([y_lim_01_1(2) y_lim_01_2(2) y_lim_01_3(2) y_lim_01_4(2) y_lim_01_5(2) y_lim_01_6(2) y_lim_01_7(2) y_lim_01_8(2)])])

subplot(4,4,9)
set(gca,'ylim',[min([y_lim_01_1(1) y_lim_01_2(1) y_lim_01_3(1) y_lim_01_4(1) y_lim_01_5(1) y_lim_01_6(1) y_lim_01_7(1) y_lim_01_8(1)]),...
    max([y_lim_01_1(2) y_lim_01_2(2) y_lim_01_3(2) y_lim_01_4(2) y_lim_01_5(2) y_lim_01_6(2) y_lim_01_7(2) y_lim_01_8(2)])])

subplot(4,4,13)
set(gca,'ylim',[min([y_lim_01_1(1) y_lim_01_2(1) y_lim_01_3(1) y_lim_01_4(1) y_lim_01_5(1) y_lim_01_6(1) y_lim_01_7(1) y_lim_01_8(1)]),...
    max([y_lim_01_1(2) y_lim_01_2(2) y_lim_01_3(2) y_lim_01_4(2) y_lim_01_5(2) y_lim_01_6(2) y_lim_01_7(2) y_lim_01_8(2)])])

subplot(4,4,2)
set(gca,'ylim',[min([y_lim_01_1(1) y_lim_01_2(1) y_lim_01_3(1) y_lim_01_4(1) y_lim_01_5(1) y_lim_01_6(1) y_lim_01_7(1) y_lim_01_8(1)]),...
    max([y_lim_01_1(2) y_lim_01_2(2) y_lim_01_3(2) y_lim_01_4(2) y_lim_01_5(2) y_lim_01_6(2) y_lim_01_7(2) y_lim_01_8(2)])])

subplot(4,4,6)
set(gca,'ylim',[min([y_lim_01_1(1) y_lim_01_2(1) y_lim_01_3(1) y_lim_01_4(1) y_lim_01_5(1) y_lim_01_6(1) y_lim_01_7(1) y_lim_01_8(1)]),...
    max([y_lim_01_1(2) y_lim_01_2(2) y_lim_01_3(2) y_lim_01_4(2) y_lim_01_5(2) y_lim_01_6(2) y_lim_01_7(2) y_lim_01_8(2)])])

subplot(4,4,10)
set(gca,'ylim',[min([y_lim_01_1(1) y_lim_01_2(1) y_lim_01_3(1) y_lim_01_4(1) y_lim_01_5(1) y_lim_01_6(1) y_lim_01_7(1) y_lim_01_8(1)]),...
    max([y_lim_01_1(2) y_lim_01_2(2) y_lim_01_3(2) y_lim_01_4(2) y_lim_01_5(2) y_lim_01_6(2) y_lim_01_7(2) y_lim_01_8(2)])])

subplot(4,4,14)
set(gca,'ylim',[min([y_lim_01_1(1) y_lim_01_2(1) y_lim_01_3(1) y_lim_01_4(1) y_lim_01_5(1) y_lim_01_6(1) y_lim_01_7(1) y_lim_01_8(1)]),...
    max([y_lim_01_1(2) y_lim_01_2(2) y_lim_01_3(2) y_lim_01_4(2) y_lim_01_5(2) y_lim_01_6(2) y_lim_01_7(2) y_lim_01_8(2)])])

%calculate psd of saw epoch_new
for i=1:size(mat_trial_epoch,1)
    for j=1:mat_trial_epoch(i,3)
        eval(['[data.trials.t',num2str(i),'.psd.e',num2str(j),'.saw_new,data.trials.t',num2str(i),'.psd.freq]=pwelch(data.trials.t',num2str(i),...
        '.sig.eeg([data.trials.t',num2str(i),'.epochs_new.e',num2str(j),'_7(1):data.trials.t',num2str(i),'.epochs_new.e',num2str(j),'_7(2)],7),512,0.5,512,1024);']);
    end
    %can incorporate this into for loop later, for now just add 18 by brute
%force
    for j=1:mat_trial_epoch(i,3)
        eval(['[data.trials.t',num2str(i),'.psd.e',num2str(j),'.saw_new(:,2),data.trials.t',num2str(i),'.psd.freq]=pwelch(data.trials.t',num2str(i),...
        '.sig.eeg([data.trials.t',num2str(i),'.epochs_new.e',num2str(j),'_18(1):data.trials.t',num2str(i),'.epochs_new.e',num2str(j),'_18(2)],18),512,0.5,512,1024);']);
    end
    
end

%overlay channels separated by epochs
subplot(4,4,3); hold on
plot(data.trials.t1.psd.freq(1:31),log10(data.trials.t1.psd.e1.saw(1:31,[7])),'LineWidth',2)
plot(data.trials.t1.psd.freq(1:31),log10(data.trials.t1.psd.e1.saw_new(1:31,[1])),'LineWidth',2)%this is 7
plot(data.trials.t1.psd.freq(1:31),log10(data.trials.t1.psd.e1.saw(1:31,[18])),'--','LineWidth',2)
plot(data.trials.t1.psd.freq(1:31),log10(data.trials.t1.psd.e1.saw_new(1:31,[2])),'--','LineWidth',2)%this is 18
legend('7 orig','7 new','18 orig','18 new')
title(['pro00087153 00',data.cfg.info.n_sbj,' ',data.cfg.trial_data.t1.cond,' e1'])
y_lim_02_1=get(gca,'ylim');


subplot(4,4,7); hold on
plot(data.trials.t1.psd.freq(1:31),log10(data.trials.t1.psd.e2.saw(1:31,[7])),'LineWidth',2)
plot(data.trials.t1.psd.freq(1:31),log10(data.trials.t1.psd.e2.saw_new(1:31,[1])),'LineWidth',2)%this is 7
plot(data.trials.t1.psd.freq(1:31),log10(data.trials.t1.psd.e2.saw(1:31,[18])),'--','LineWidth',2)
plot(data.trials.t1.psd.freq(1:31),log10(data.trials.t1.psd.e2.saw_new(1:31,[2])),'--','LineWidth',2)%this is 18
title('e2')
y_lim_02_2=get(gca,'ylim');

subplot(4,4,11); hold on
plot(data.trials.t1.psd.freq(1:31),log10(data.trials.t1.psd.e3.saw(1:31,[7])),'LineWidth',2)
plot(data.trials.t1.psd.freq(1:31),log10(data.trials.t1.psd.e3.saw_new(1:31,[1])),'LineWidth',2)%this is 7
plot(data.trials.t1.psd.freq(1:31),log10(data.trials.t1.psd.e3.saw(1:31,[18])),'--','LineWidth',2)
plot(data.trials.t1.psd.freq(1:31),log10(data.trials.t1.psd.e3.saw_new(1:31,[2])),'--','LineWidth',2)%this is 18
title('e3')
y_lim_02_3=get(gca,'ylim');

subplot(4,4,15); hold on
plot(data.trials.t1.psd.freq(1:31),log10(data.trials.t1.psd.e4.saw(1:31,[7])),'LineWidth',2)
plot(data.trials.t1.psd.freq(1:31),log10(data.trials.t1.psd.e4.saw_new(1:31,[1])),'LineWidth',2)%this is 7
plot(data.trials.t1.psd.freq(1:31),log10(data.trials.t1.psd.e4.saw(1:31,[18])),'--','LineWidth',2)
plot(data.trials.t1.psd.freq(1:31),log10(data.trials.t1.psd.e4.saw_new(1:31,[2])),'--','LineWidth',2)%this is 18
title('e4')
y_lim_02_4=get(gca,'ylim');

subplot(4,4,3)
set(gca,'ylim',[min([y_lim_02_1(1) y_lim_02_2(1) y_lim_02_3(1) y_lim_02_4(1)]),...
    max([y_lim_02_1(2) y_lim_02_2(2) y_lim_02_3(2) y_lim_02_4(2)])])
plot([13 13],[min([y_lim_02_1(1) y_lim_02_2(1) y_lim_02_3(1) y_lim_02_4(1)]),...
    max([y_lim_02_1(2) y_lim_02_2(2) y_lim_02_3(2) y_lim_02_4(2)])],'r','LineWidth',2)
plot([30 30],[min([y_lim_02_1(1) y_lim_02_2(1) y_lim_02_3(1) y_lim_02_4(1)]),...
    max([y_lim_02_1(2) y_lim_02_2(2) y_lim_02_3(2) y_lim_02_4(2)])],'r','LineWidth',2)

subplot(4,4,7)
set(gca,'ylim',[min([y_lim_02_1(1) y_lim_02_2(1) y_lim_02_3(1) y_lim_02_4(1)]),...
    max([y_lim_02_1(2) y_lim_02_2(2) y_lim_02_3(2) y_lim_02_4(2)])])
plot([13 13],[min([y_lim_02_1(1) y_lim_02_2(1) y_lim_02_3(1) y_lim_02_4(1)]),...
    max([y_lim_02_1(2) y_lim_02_2(2) y_lim_02_3(2) y_lim_02_4(2)])],'r','LineWidth',2)
plot([30 30],[min([y_lim_02_1(1) y_lim_02_2(1) y_lim_02_3(1) y_lim_02_4(1)]),...
    max([y_lim_02_1(2) y_lim_02_2(2) y_lim_02_3(2) y_lim_02_4(2)])],'r','LineWidth',2)

subplot(4,4,11)
set(gca,'ylim',[min([y_lim_02_1(1) y_lim_02_2(1) y_lim_02_3(1) y_lim_02_4(1)]),...
    max([y_lim_02_1(2) y_lim_02_2(2) y_lim_02_3(2) y_lim_02_4(2)])])
plot([13 13],[min([y_lim_02_1(1) y_lim_02_2(1) y_lim_02_3(1) y_lim_02_4(1)]),...
    max([y_lim_02_1(2) y_lim_02_2(2) y_lim_02_3(2) y_lim_02_4(2)])],'r','LineWidth',2)
plot([30 30],[min([y_lim_02_1(1) y_lim_02_2(1) y_lim_02_3(1) y_lim_02_4(1)]),...
    max([y_lim_02_1(2) y_lim_02_2(2) y_lim_02_3(2) y_lim_02_4(2)])],'r','LineWidth',2)

subplot(4,4,15)
set(gca,'ylim',[min([y_lim_02_1(1) y_lim_02_2(1) y_lim_02_3(1) y_lim_02_4(1)]),...
    max([y_lim_02_1(2) y_lim_02_2(2) y_lim_02_3(2) y_lim_02_4(2)])])
plot([13 13],[min([y_lim_02_1(1) y_lim_02_2(1) y_lim_02_3(1) y_lim_02_4(1)]),...
    max([y_lim_02_1(2) y_lim_02_2(2) y_lim_02_3(2) y_lim_02_4(2)])],'r','LineWidth',2)
plot([30 30],[min([y_lim_02_1(1) y_lim_02_2(1) y_lim_02_3(1) y_lim_02_4(1)]),...
    max([y_lim_02_1(2) y_lim_02_2(2) y_lim_02_3(2) y_lim_02_4(2)])],'r','LineWidth',2)

%now overlay epochs separated by channel
subplot(4,4,4); hold on
plot(data.trials.t1.psd.freq(1:31),log10(data.trials.t1.psd.e1.saw_new(1:31,[1])),'LineWidth',2)
plot(data.trials.t1.psd.freq(1:31),log10(data.trials.t1.psd.e2.saw_new(1:31,[1])),'--','LineWidth',2)
plot(data.trials.t1.psd.freq(1:31),log10(data.trials.t1.psd.e3.saw_new(1:31,[1])),'LineWidth',2)
plot(data.trials.t1.psd.freq(1:31),log10(data.trials.t1.psd.e4.saw_new(1:31,[1])),'--','LineWidth',2)
legend('e1','e2','e3','e4')
title('e1-e4 7 new')
y_lim_03_1=get(gca,'ylim');

subplot(4,4,8); hold on
plot(data.trials.t1.psd.freq(1:31),log10(data.trials.t1.psd.e1.saw_new(1:31,[2])),'LineWidth',2)
plot(data.trials.t1.psd.freq(1:31),log10(data.trials.t1.psd.e2.saw_new(1:31,[2])),'--','LineWidth',2)
plot(data.trials.t1.psd.freq(1:31),log10(data.trials.t1.psd.e3.saw_new(1:31,[2])),'LineWidth',2)
plot(data.trials.t1.psd.freq(1:31),log10(data.trials.t1.psd.e4.saw_new(1:31,[2])),'--','LineWidth',2)
title('e1-e4 18 new')
y_lim_03_2=get(gca,'ylim');

subplot(4,4,4)
set(gca,'ylim',[min([y_lim_03_1(1) y_lim_03_2(1)]) max([y_lim_03_1(2) y_lim_03_2(2)])])
plot([13 13],[min([y_lim_02_1(1) y_lim_02_2(1)]),...
    max([y_lim_02_1(2) y_lim_02_2(2)])],'r','LineWidth',2)
plot([30 30],[min([y_lim_02_1(1) y_lim_02_2(1)]),...
    max([y_lim_02_1(2) y_lim_02_2(2)])],'r','LineWidth',2)

subplot(4,4,8)
set(gca,'ylim',[min([y_lim_03_1(1) y_lim_03_2(1)]) max([y_lim_03_1(2) y_lim_03_2(2)])])
plot([13 13],[min([y_lim_02_1(1) y_lim_02_2(1)]),...
    max([y_lim_02_1(2) y_lim_02_2(2)])],'r','LineWidth',2)
plot([30 30],[min([y_lim_02_1(1) y_lim_02_2(1)]),...
    max([y_lim_02_1(2) y_lim_02_2(2)])],'r','LineWidth',2)

%hold off for now on resizing the yaxes but may be necessary later on,
%could even add a 1 or 2 choice in function above for resizing










%% stats
%keep in mind that from here on out you will run the stats code on ALL
%channels and will need to go back later and separately plot/choose channels 7 and 18

% calculate groups
for i=1% here i is serving just for the counter
    count=0
    for j=mat_trial_epoch(:,1)'
        for k=1:mat_trial_epoch(j,3)
            count=count+1
            eval(['mat_sz_epoch_7{',num2str(count),'}=linspace(',num2str(count),',',num2str(count),...
                ',size(data.trials.t',num2str(mat_trial_epoch(j,2)),'.psd.e',num2str(k),'.sai_new_7.vals,1));'])
            eval(['mat_sz_epoch_18{',num2str(count),'}=linspace(',num2str(count),',',num2str(count),...
                ',size(data.trials.t',num2str(mat_trial_epoch(j,2)),'.psd.e',num2str(k),'.sai_new_18.vals,1));'])  
        end
    end
end
grp_epochs_7=cat(2,mat_sz_epoch_7{:});
grp_epochs_18=cat(2,mat_sz_epoch_18{:});

% rearrange means by frq band and channel
for i=1:size(mat_trial_epoch,1)
    for j=1:mat_trial_epoch(i,3)
        for k=1:size(frq_band_ind,2)
            for l=1:size(data.cfg.info.i_chan,2)                
                eval(['mat_stat_means_7.t',num2str(i),'.e',num2str(j),'.',frq_band_txt{k},'.c',num2str(l),'=data.trials.t',num2str(i),'.psd.e',num2str(j),'.sai_new_7.means.',frq_band_txt{k},'(:,',num2str(l),');']);
                eval(['mat_stat_means_18.t',num2str(i),'.e',num2str(j),'.',frq_band_txt{k},'.c',num2str(l),'=data.trials.t',num2str(i),'.psd.e',num2str(j),'.sai_new_18.means.',frq_band_txt{k},'(:,',num2str(l),');']);
            end
        end
    end
end

for i=1:size(frq_band_ind,2)
    for j=1:size(data.cfg.info.i_chan,2)   
    count=0;
        for k=1:size(mat_trial_epoch,1)
            for l=1:mat_trial_epoch(k,3)
                count=count+1;
                eval(['mat_stat_means_7.',frq_band_txt{i},'.c',num2str(j),'{count}=data.trials.t',...
                num2str(k),'.psd.e',num2str(l),'.sai_new_7.means.',frq_band_txt{i},'(:,',num2str(j),');']);
                
                eval(['mat_stat_means_18.',frq_band_txt{i},'.c',num2str(j),'{count}=data.trials.t',...
                num2str(k),'.psd.e',num2str(l),'.sai_new_18.means.',frq_band_txt{i},'(:,',num2str(j),');']);
            end
        end
    end
end

for i=1:size(frq_band_ind,2)
    for j=1:size(data.cfg.info.i_chan,2)  
        eval(['data.stats_new_7.psd.means.',frq_band_txt{i},'.c',num2str(j),'=cat(1,mat_stat_means_7.',frq_band_txt{i},'.c',num2str(j),'{:})''']);
        eval(['data.stats_new_18.psd.means.',frq_band_txt{i},'.c',num2str(j),'=cat(1,mat_stat_means_18.',frq_band_txt{i},'.c',num2str(j),'{:})''']);
    end
end
    
%calculate statistic and corrected p-values
for i=1:size(frq_band_txt,2)
    for j=1:size(data.cfg.info.i_chan,2)
        eval(['[data.stats_new_7.psd.test.kw.p.',frq_band_txt{i},'.c',num2str(j),...
            ',data.stats_new_7.psd.test.kw.anovatab.',frq_band_txt{i},'.c',num2str(j),...
            ',data.stats_new_7.psd.test.kw.stats.',frq_band_txt{i},'.c',num2str(j),...
            ']= kruskalwallis(data.stats_new_7.psd.means.',frq_band_txt{i},'.c',num2str(j),...
            ',grp_epochs_7,''off'')'])
        
        eval(['[data.stats_new_18.psd.test.kw.p.',frq_band_txt{i},'.c',num2str(j),...
            ',data.stats_new_18.psd.test.kw.anovatab.',frq_band_txt{i},'.c',num2str(j),...
            ',data.stats_new_18.psd.test.kw.stats.',frq_band_txt{i},'.c',num2str(j),...
            ']= kruskalwallis(data.stats_new_18.psd.means.',frq_band_txt{i},'.c',num2str(j),...
            ',grp_epochs_18,''off'')'])
    end
end

for i=1:size(frq_band_txt,2)
    for j=1:size(data.cfg.info.i_chan,2)
        eval(['data.stats_new_7.psd.test.kw.mc.',frq_band_txt{i},'.c',num2str(j),'= multcompare(data.stats_new_7.psd.test.kw.stats.',frq_band_txt{i},'.c',num2str(j),',''ctype'',''bonferroni'',''display'',''off'')'])
        eval(['data.stats_new_18.psd.test.kw.mc.',frq_band_txt{i},'.c',num2str(j),'= multcompare(data.stats_new_18.psd.test.kw.stats.',frq_band_txt{i},'.c',num2str(j),',''ctype'',''bonferroni'',''display'',''off'')'])
    end
end

for i=1:size(frq_band_txt,2)
    for j=1:size(data.cfg.info.i_chan,2)
        eval(['mc_find_7.',frq_band_txt{i},'.p_corr{',num2str(j),'}=find(data.stats_new_7.psd.test.kw.mc.',frq_band_txt{i},'.c',num2str(j),'(:,6)<0.05)'])
        eval(['mc_find_18.',frq_band_txt{i},'.p_corr{',num2str(j),'}=find(data.stats_new_18.psd.test.kw.mc.',frq_band_txt{i},'.c',num2str(j),'(:,6)<0.05)'])
    end
end

data.stats_new_7.psd.test.kw.p_corr=[];
data.stats_new_18.psd.test.kw.p_corr=[];
for i=1:size(frq_band_txt,2)
    for j=1:size(data.cfg.info.i_chan,2)
        if isempty(data.stats_new_7.psd.test.kw.p_corr)==1
            eval(['data.stats_new_7.psd.test.kw.p_corr=linspace(',num2str(i),',',num2str(i),...
                ',length(mc_find_7.',frq_band_txt{i},'.p_corr{',num2str(j),'}))'';']);
            eval(['data.stats_new_7.psd.test.kw.p_corr(:,2)=linspace(',num2str(j),',',num2str(j),...
                ',length(mc_find_7.',frq_band_txt{i},'.p_corr{',num2str(j),'}))'';']);
            eval(['data.stats_new_7.psd.test.kw.p_corr(:,3)=data.stats_new_7.psd.test.kw.mc.',...
                frq_band_txt{i},'.c',num2str(j),'(mc_find_7.',frq_band_txt{i},'.p_corr{j},1);'])
            eval(['data.stats_new_7.psd.test.kw.p_corr(:,4)=data.stats_new_7.psd.test.kw.mc.',...
                frq_band_txt{i},'.c',num2str(j),'(mc_find_7.',frq_band_txt{i},'.p_corr{j},2);'])
            eval(['data.stats_new_7.psd.test.kw.p_corr(:,5)=data.stats_new_7.psd.test.kw.mc.',...
                frq_band_txt{i},'.c',num2str(j),'(mc_find_7.',frq_band_txt{i},'.p_corr{j},6);'])
        else
            size_p_corr=size(data.stats_new_7.psd.test.kw.p_corr,1); 
            eval(['data.stats_new_7.psd.test.kw.p_corr(size_p_corr+1:size_p_corr+length(mc_find_7.',frq_band_txt{i},'.p_corr{',num2str(j),'}),1)=linspace(',num2str(i),',',num2str(i),...
                ',length(mc_find_7.',frq_band_txt{i},'.p_corr{',num2str(j),'}))'';']);
            eval(['data.stats_new_7.psd.test.kw.p_corr(size_p_corr+1:size_p_corr+length(mc_find_7.',frq_band_txt{i},'.p_corr{',num2str(j),'}),2)=linspace(',num2str(j),',',num2str(j),...
                ',length(mc_find_7.',frq_band_txt{i},'.p_corr{',num2str(j),'}))'';']);
            eval(['data.stats_new_7.psd.test.kw.p_corr(size_p_corr+1:size_p_corr+length(mc_find_7.',frq_band_txt{i},'.p_corr{',num2str(j),'}),3)=data.stats_new_7.psd.test.kw.mc.',...
                frq_band_txt{i},'.c',num2str(j),'(mc_find_7.',frq_band_txt{i},'.p_corr{j},1);'])
            eval(['data.stats_new_7.psd.test.kw.p_corr(size_p_corr+1:size_p_corr+length(mc_find_7.',frq_band_txt{i},'.p_corr{',num2str(j),'}),4)=data.stats_new_7.psd.test.kw.mc.',...
                frq_band_txt{i},'.c',num2str(j),'(mc_find_7.',frq_band_txt{i},'.p_corr{j},2);'])
            eval(['data.stats_new_7.psd.test.kw.p_corr(size_p_corr+1:size_p_corr+length(mc_find_7.',frq_band_txt{i},'.p_corr{',num2str(j),'}),5)=data.stats_new_7.psd.test.kw.mc.',...
                frq_band_txt{i},'.c',num2str(j),'(mc_find_7.',frq_band_txt{i},'.p_corr{j},6);'])
        end
        
        if isempty(data.stats_new_18.psd.test.kw.p_corr)==1
            eval(['data.stats_new_18.psd.test.kw.p_corr=linspace(',num2str(i),',',num2str(i),...
                ',length(mc_find_18.',frq_band_txt{i},'.p_corr{',num2str(j),'}))'';']);
            eval(['data.stats_new_18.psd.test.kw.p_corr(:,2)=linspace(',num2str(j),',',num2str(j),...
                ',length(mc_find_18.',frq_band_txt{i},'.p_corr{',num2str(j),'}))'';']);
            eval(['data.stats_new_18.psd.test.kw.p_corr(:,3)=data.stats_new_18.psd.test.kw.mc.',...
                frq_band_txt{i},'.c',num2str(j),'(mc_find_18.',frq_band_txt{i},'.p_corr{j},1);'])
            eval(['data.stats_new_18.psd.test.kw.p_corr(:,4)=data.stats_new_18.psd.test.kw.mc.',...
                frq_band_txt{i},'.c',num2str(j),'(mc_find_18.',frq_band_txt{i},'.p_corr{j},2);'])
            eval(['data.stats_new_18.psd.test.kw.p_corr(:,5)=data.stats_new_18.psd.test.kw.mc.',...
                frq_band_txt{i},'.c',num2str(j),'(mc_find_18.',frq_band_txt{i},'.p_corr{j},6);'])
        else
            size_p_corr=size(data.stats_new_18.psd.test.kw.p_corr,1); 
            eval(['data.stats_new_18.psd.test.kw.p_corr(size_p_corr+1:size_p_corr+length(mc_find_18.',frq_band_txt{i},'.p_corr{',num2str(j),'}),1)=linspace(',num2str(i),',',num2str(i),...
                ',length(mc_find_18.',frq_band_txt{i},'.p_corr{',num2str(j),'}))'';']);
            eval(['data.stats_new_18.psd.test.kw.p_corr(size_p_corr+1:size_p_corr+length(mc_find_18.',frq_band_txt{i},'.p_corr{',num2str(j),'}),2)=linspace(',num2str(j),',',num2str(j),...
                ',length(mc_find_18.',frq_band_txt{i},'.p_corr{',num2str(j),'}))'';']);
            eval(['data.stats_new_18.psd.test.kw.p_corr(size_p_corr+1:size_p_corr+length(mc_find_18.',frq_band_txt{i},'.p_corr{',num2str(j),'}),3)=data.stats_new_18.psd.test.kw.mc.',...
                frq_band_txt{i},'.c',num2str(j),'(mc_find_18.',frq_band_txt{i},'.p_corr{j},1);'])
            eval(['data.stats_new_18.psd.test.kw.p_corr(size_p_corr+1:size_p_corr+length(mc_find_18.',frq_band_txt{i},'.p_corr{',num2str(j),'}),4)=data.stats_new_18.psd.test.kw.mc.',...
                frq_band_txt{i},'.c',num2str(j),'(mc_find_18.',frq_band_txt{i},'.p_corr{j},2);'])
            eval(['data.stats_new_18.psd.test.kw.p_corr(size_p_corr+1:size_p_corr+length(mc_find_18.',frq_band_txt{i},'.p_corr{',num2str(j),'}),5)=data.stats_new_18.psd.test.kw.mc.',...
                frq_band_txt{i},'.c',num2str(j),'(mc_find_18.',frq_band_txt{i},'.p_corr{j},6);'])
        end
     end
end

%also I would calculate the most frequently seen epoch pairing within the
%corrected p-values as well as the most frequently seen frequency range and
%channel
data.stats_new_7.psd.test.kw.p_corr_mets.frq(1,1)=1;
data.stats_new_7.psd.test.kw.p_corr_mets.frq(1,2)=size(find(data.stats_new_7.psd.test.kw.p_corr(:,1)==1),1);
data.stats_new_7.psd.test.kw.p_corr_mets.frq(2,1)=2;
data.stats_new_7.psd.test.kw.p_corr_mets.frq(2,2)=size(find(data.stats_new_7.psd.test.kw.p_corr(:,1)==2),1);
data.stats_new_7.psd.test.kw.p_corr_mets.frq(3,1)=3;
data.stats_new_7.psd.test.kw.p_corr_mets.frq(3,2)=size(find(data.stats_new_7.psd.test.kw.p_corr(:,1)==3),1);
data.stats_new_7.psd.test.kw.p_corr_mets.frq(4,1)=4;
data.stats_new_7.psd.test.kw.p_corr_mets.frq(4,2)=size(find(data.stats_new_7.psd.test.kw.p_corr(:,1)==4),1);
data.stats_new_7.psd.test.kw.p_corr_mets.frq(5,1)=5;
data.stats_new_7.psd.test.kw.p_corr_mets.frq(5,2)=size(find(data.stats_new_7.psd.test.kw.p_corr(:,1)==5),1);
data.stats_new_7.psd.test.kw.p_corr_mets.frq(6,1)=6;
data.stats_new_7.psd.test.kw.p_corr_mets.frq(6,2)=size(find(data.stats_new_7.psd.test.kw.p_corr(:,1)==6),1);

data.stats_new_7.psd.test.kw.p_corr_mets.ch(1,1)=1;
data.stats_new_7.psd.test.kw.p_corr_mets.ch(1,2)=size(find(data.stats_new_7.psd.test.kw.p_corr(:,2)==1),1);
data.stats_new_7.psd.test.kw.p_corr_mets.ch(2,1)=2;
data.stats_new_7.psd.test.kw.p_corr_mets.ch(2,2)=size(find(data.stats_new_7.psd.test.kw.p_corr(:,2)==2),1);
data.stats_new_7.psd.test.kw.p_corr_mets.ch(3,1)=3;
data.stats_new_7.psd.test.kw.p_corr_mets.ch(3,2)=size(find(data.stats_new_7.psd.test.kw.p_corr(:,2)==3),1);
data.stats_new_7.psd.test.kw.p_corr_mets.ch(4,1)=4;
data.stats_new_7.psd.test.kw.p_corr_mets.ch(4,2)=size(find(data.stats_new_7.psd.test.kw.p_corr(:,2)==4),1);
data.stats_new_7.psd.test.kw.p_corr_mets.ch(5,1)=5;
data.stats_new_7.psd.test.kw.p_corr_mets.ch(5,2)=size(find(data.stats_new_7.psd.test.kw.p_corr(:,2)==5),1);
data.stats_new_7.psd.test.kw.p_corr_mets.ch(6,1)=6;
data.stats_new_7.psd.test.kw.p_corr_mets.ch(6,2)=size(find(data.stats_new_7.psd.test.kw.p_corr(:,2)==6),1);

data.stats_new_18.psd.test.kw.p_corr_mets.frq(1,1)=1;
data.stats_new_18.psd.test.kw.p_corr_mets.frq(1,2)=size(find(data.stats_new_18.psd.test.kw.p_corr(:,1)==1),1);
data.stats_new_18.psd.test.kw.p_corr_mets.frq(2,1)=2;
data.stats_new_18.psd.test.kw.p_corr_mets.frq(2,2)=size(find(data.stats_new_18.psd.test.kw.p_corr(:,1)==2),1);
data.stats_new_18.psd.test.kw.p_corr_mets.frq(3,1)=3;
data.stats_new_18.psd.test.kw.p_corr_mets.frq(3,2)=size(find(data.stats_new_18.psd.test.kw.p_corr(:,1)==3),1);
data.stats_new_18.psd.test.kw.p_corr_mets.frq(4,1)=4;
data.stats_new_18.psd.test.kw.p_corr_mets.frq(4,2)=size(find(data.stats_new_18.psd.test.kw.p_corr(:,1)==4),1);
data.stats_new_18.psd.test.kw.p_corr_mets.frq(5,1)=5;
data.stats_new_18.psd.test.kw.p_corr_mets.frq(5,2)=size(find(data.stats_new_18.psd.test.kw.p_corr(:,1)==5),1);
data.stats_new_18.psd.test.kw.p_corr_mets.frq(6,1)=6;
data.stats_new_18.psd.test.kw.p_corr_mets.frq(6,2)=size(find(data.stats_new_18.psd.test.kw.p_corr(:,1)==6),1);

data.stats_new_18.psd.test.kw.p_corr_mets.ch(1,1)=1;
data.stats_new_18.psd.test.kw.p_corr_mets.ch(1,2)=size(find(data.stats_new_18.psd.test.kw.p_corr(:,2)==1),1);
data.stats_new_18.psd.test.kw.p_corr_mets.ch(2,1)=2;
data.stats_new_18.psd.test.kw.p_corr_mets.ch(2,2)=size(find(data.stats_new_18.psd.test.kw.p_corr(:,2)==2),1);
data.stats_new_18.psd.test.kw.p_corr_mets.ch(3,1)=3;
data.stats_new_18.psd.test.kw.p_corr_mets.ch(3,2)=size(find(data.stats_new_18.psd.test.kw.p_corr(:,2)==3),1);
data.stats_new_18.psd.test.kw.p_corr_mets.ch(4,1)=4;
data.stats_new_18.psd.test.kw.p_corr_mets.ch(4,2)=size(find(data.stats_new_18.psd.test.kw.p_corr(:,2)==4),1);
data.stats_new_18.psd.test.kw.p_corr_mets.ch(5,1)=5;
data.stats_new_18.psd.test.kw.p_corr_mets.ch(5,2)=size(find(data.stats_new_18.psd.test.kw.p_corr(:,2)==5),1);
data.stats_new_18.psd.test.kw.p_corr_mets.ch(6,1)=6;
data.stats_new_18.psd.test.kw.p_corr_mets.ch(6,2)=size(find(data.stats_new_18.psd.test.kw.p_corr(:,2)==6),1);
%% plots

%prepare supermeans and errorbars for plotting - arranged by epoch and
%channel
for i=1:size(frq_band_txt,2)
    for j=1:size(data.cfg.info.i_chan,2)
    count=0
        for k=mat_trial_epoch(:,1)'
            for l=1:mat_trial_epoch(k,3)
                count=count+1;
                eval(['data.plots_new_7.',frq_band_txt{i},'.c',num2str(j),...
                    '.supermeans(',num2str(count),')=data.trials.t',...
                    num2str(mat_trial_epoch(k,2)),'.psd.e',num2str(l),...
                    '.sai_new_7.supermeans.',frq_band_txt{i},'(',num2str(j),')'])
                eval(['data.plots_new_7.',frq_band_txt{i},'.c',num2str(j),...
                    '.ses(',num2str(count),')=data.trials.t',...
                    num2str(mat_trial_epoch(k,2)),'.psd.e',num2str(l),...
                    '.sai_new_7.ses.',frq_band_txt{i},'(',num2str(j),')'])
            
                eval(['data.plots_new_18.',frq_band_txt{i},'.c',num2str(j),...
                    '.supermeans(',num2str(count),')=data.trials.t',...
                    num2str(mat_trial_epoch(k,2)),'.psd.e',num2str(l),...
                    '.sai_new_18.supermeans.',frq_band_txt{i},'(',num2str(j),')'])
                eval(['data.plots_new_18.',frq_band_txt{i},'.c',num2str(j),...
                    '.ses(',num2str(count),')=data.trials.t',...
                    num2str(mat_trial_epoch(k,2)),'.psd.e',num2str(l),...
                    '.sai_new_18.ses.',frq_band_txt{i},'(',num2str(j),')'])
            end    
       end
    clear count
    end
end

subplot(4,4,12); hold on
bar(data.plots_new_7.beta.c7.supermeans)
errorbar(data.plots_new_7.beta.c7.supermeans,...
    data.plots_new_7.beta.c7.ses,'.k')
set(gca,'XTick',[1:4],'XTickLabel',{'e1','e2','e3','e4'})
if data.cfg.info.stim_elc=='c3'
    title('7 stm')
else
    title('7 non')
end
y_lim_04_1=get(gca,'ylim');

subplot(4,4,16); hold on
bar(data.plots_new_18.beta.c18.supermeans)
errorbar(data.plots_new_18.beta.c18.supermeans,...
    data.plots_new_18.beta.c18.ses,'.k')
set(gca,'XTick',[1:4],'XTickLabel',{'e1','e2','e3','e4'})
if data.cfg.info.stim_elc=='c4'
    title('18 stm')
else
    title('18 non')
end
y_lim_04_2=get(gca,'ylim');

subplot(4,4,12)
set(gca,'ylim',[min([y_lim_04_1(1) y_lim_04_2(1)]) max([y_lim_04_1(2) y_lim_04_2(2)])])

subplot(4,4,16)
set(gca,'ylim',[min([y_lim_04_1(1) y_lim_04_2(1)]) max([y_lim_04_1(2) y_lim_04_2(2)])])


cd('~/nr_data_analysis/data_analyzed/eeg')
eval(['data_eeg_anal_',data.cfg.trial_data.t1.cond,'_pro00087153_00',data.cfg.info.n_sbj,'=data;'])
eval(['save(''data_eeg_anal_',data.cfg.trial_data.t1.cond,'_pro00087153_00',data.cfg.info.n_sbj,''')'])
clear