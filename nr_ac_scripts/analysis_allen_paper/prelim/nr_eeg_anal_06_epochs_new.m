function nr_eeg_anal_06_epochs_new(data_file)

%io
%data_file='~/nr_data_analysis/data_analyzed/eeg/data_eeg_anal_move_pro00087153_0013.mat'
load(data_file)
data=eval(data_file(38:72))
var_name=data_file(38:72)

%params
frq_band_ind=data.cfg.info.frq_band_ind;
frq_band_txt=data.cfg.info.frq_band_txt;
mat_trial_epoch=data.cfg.info.mat_trial_epoch;

%create fig
%plot raw data + psd means
figure
%set(gcf,'Position',[1443 62 855 1398])
set(gcf,'Position',[913 597 867 883])

subplot(8,2,1)
plot(data.trials.t1.sig.eeg(data.trials.t1.epochs.e1(1):data.trials.t1.epochs.e1(2),7))
set(gca,'xlim',[0 size(data.trials.t1.sig.eeg(data.trials.t1.epochs.e1(1):data.trials.t1.epochs.e1(2),7),1)])
title('e1 7 C3')

subplot(8,2,2)
plot(data.trials.t1.sig.eeg(data.trials.t1.epochs.e1(1):data.trials.t1.epochs.e1(2),18))
set(gca,'xlim',[0 size(data.trials.t1.sig.eeg(data.trials.t1.epochs.e1(1):data.trials.t1.epochs.e1(2),18),1)])
title('e1 18 C4')

subplot(8,2,3); hold on
bar(data.trials.t1.psd.e1.sai.means.beta(:,7),'b')

subplot(8,2,4); hold on
bar(data.trials.t1.psd.e1.sai.means.beta(:,18))

subplot(8,2,5)
plot(data.trials.t1.sig.eeg(data.trials.t1.epochs.e2(1):data.trials.t1.epochs.e2(2),7))
set(gca,'xlim',[0 size(data.trials.t1.sig.eeg(data.trials.t1.epochs.e2(1):data.trials.t1.epochs.e2(2),7),1)])
title('e2 7 C3')

subplot(8,2,6)
plot(data.trials.t1.sig.eeg(data.trials.t1.epochs.e2(1):data.trials.t1.epochs.e2(2),18))
set(gca,'xlim',[0 size(data.trials.t1.sig.eeg(data.trials.t1.epochs.e2(1):data.trials.t1.epochs.e2(2),18),1)])
title('e2 18 C4')

subplot(8,2,7); hold on
bar(data.trials.t1.psd.e2.sai.means.beta(:,7))

subplot(8,2,8); hold on
bar(data.trials.t1.psd.e2.sai.means.beta(:,18))

subplot(8,2,9)
plot(data.trials.t1.sig.eeg(data.trials.t1.epochs.e3(1):data.trials.t1.epochs.e3(2),7))
set(gca,'xlim',[0 size(data.trials.t1.sig.eeg(data.trials.t1.epochs.e3(1):data.trials.t1.epochs.e3(2),7),1)])
title('e3 7 C3')

subplot(8,2,10)
plot(data.trials.t1.sig.eeg(data.trials.t1.epochs.e3(1):data.trials.t1.epochs.e3(2),18))
set(gca,'xlim',[0 size(data.trials.t1.sig.eeg(data.trials.t1.epochs.e3(1):data.trials.t1.epochs.e3(2),18),1)])
title('e3 18 C4')

subplot(8,2,11); hold on
bar(data.trials.t1.psd.e3.sai.means.beta(:,7))

subplot(8,2,12); hold on
bar(data.trials.t1.psd.e3.sai.means.beta(:,18))

subplot(8,2,13)
plot(data.trials.t1.sig.eeg(data.trials.t1.epochs.e4(1):data.trials.t1.epochs.e4(2),7))
set(gca,'xlim',[0 size(data.trials.t1.sig.eeg(data.trials.t1.epochs.e4(1):data.trials.t1.epochs.e4(2),7),1)])
title('e4 7 C3')

subplot(8,2,14)
plot(data.trials.t1.sig.eeg(data.trials.t1.epochs.e4(1):data.trials.t1.epochs.e4(2),18))
set(gca,'xlim',[0 size(data.trials.t1.sig.eeg(data.trials.t1.epochs.e4(1):data.trials.t1.epochs.e4(2),18),1)])
title('e4 18 C4')

subplot(8,2,15); hold on
bar(data.trials.t1.psd.e4.sai.means.beta(:,7))

subplot(8,2,16); hold on
bar(data.trials.t1.psd.e4.sai.means.beta(:,18))

%plot lines for mean+3STD
subplot(8,2,3); hold on
std_sai_means_e1_7=std(data.trials.t1.psd.e1.sai.means.beta(:,7));
plot([0 size(data.trials.t1.psd.e1.sai.means.beta,1)],[data.trials.t1.psd.e1.sai.supermeans.beta(7) data.trials.t1.psd.e1.sai.supermeans.beta(7)],'r','LineWidth',2)
plot([0 size(data.trials.t1.psd.e1.sai.means.beta,1)],[data.trials.t1.psd.e1.sai.supermeans.beta(7)+3*std_sai_means_e1_7 data.trials.t1.psd.e1.sai.supermeans.beta(7)+3*std_sai_means_e1_7],'--r')
if data.trials.t1.psd.e1.sai.supermeans.beta(7)-3*std_sai_means_e1_7>0
    plot([0 size(data.trials.t1.psd.e1.sai.means.beta,1)],...
        [data.trials.t1.psd.e1.sai.supermeans.beta(7)-3*std_sai_means_e1_7 data.trials.t1.psd.e1.sai.supermeans.beta(7)-3*std_sai_means_e1_7],'--r')
else
end

subplot(8,2,4); hold on
std_sai_means_e1_18=std(data.trials.t1.psd.e1.sai.means.beta(:,18));
plot([0 size(data.trials.t1.psd.e1.sai.means.beta,1)],[data.trials.t1.psd.e1.sai.supermeans.beta(18) data.trials.t1.psd.e1.sai.supermeans.beta(18)],'r','LineWidth',2)
plot([0 size(data.trials.t1.psd.e1.sai.means.beta,1)],[data.trials.t1.psd.e1.sai.supermeans.beta(18)+3*std_sai_means_e1_18 data.trials.t1.psd.e1.sai.supermeans.beta(18)+3*std_sai_means_e1_18],'--r')
if data.trials.t1.psd.e1.sai.supermeans.beta(18)-3*std_sai_means_e1_18>0
    plot([0 size(data.trials.t1.psd.e1.sai.means.beta,1)],...
        [data.trials.t1.psd.e1.sai.supermeans.beta(18)-3*std_sai_means_e1_18 data.trials.t1.psd.e1.sai.supermeans.beta(18)-3*std_sai_means_e1_18],'--r')
else
end

subplot(8,2,7); hold on
std_sai_means_e2_7=std(data.trials.t1.psd.e2.sai.means.beta(:,7));
plot([0 size(data.trials.t1.psd.e2.sai.means.beta,1)],[data.trials.t1.psd.e2.sai.supermeans.beta(7) data.trials.t1.psd.e2.sai.supermeans.beta(7)],'r','LineWidth',2)
plot([0 size(data.trials.t1.psd.e2.sai.means.beta,1)],[data.trials.t1.psd.e2.sai.supermeans.beta(7)+3*std_sai_means_e2_7 data.trials.t1.psd.e2.sai.supermeans.beta(7)+3*std_sai_means_e2_7],'--r')
if data.trials.t1.psd.e2.sai.supermeans.beta(7)-3*std_sai_means_e2_7>0
    plot([0 size(data.trials.t1.psd.e2.sai.means.beta,1)],...
        [data.trials.t1.psd.e2.sai.supermeans.beta(7)-3*std_sai_means_e2_7 data.trials.t1.psd.e2.sai.supermeans.beta(7)-3*std_sai_means_e2_7],'--r')
else
end

subplot(8,2,8); hold on
std_sai_means_e2_18=std(data.trials.t1.psd.e2.sai.means.beta(:,18));
plot([0 size(data.trials.t1.psd.e2.sai.means.beta,1)],[data.trials.t1.psd.e2.sai.supermeans.beta(18) data.trials.t1.psd.e2.sai.supermeans.beta(18)],'r','LineWidth',2)
plot([0 size(data.trials.t1.psd.e2.sai.means.beta,1)],[data.trials.t1.psd.e2.sai.supermeans.beta(18)+3*std_sai_means_e2_18 data.trials.t1.psd.e2.sai.supermeans.beta(18)+3*std_sai_means_e2_18],'--r')
if data.trials.t1.psd.e2.sai.supermeans.beta(18)-3*std_sai_means_e2_18>0
    plot([0 size(data.trials.t1.psd.e2.sai.means.beta,1)],...
        [data.trials.t1.psd.e2.sai.supermeans.beta(18)-3*std_sai_means_e2_18 data.trials.t1.psd.e2.sai.supermeans.beta(18)-3*std_sai_means_e2_18],'--r')
else
end

subplot(8,2,11); hold on
std_sai_means_e3_7=std(data.trials.t1.psd.e3.sai.means.beta(:,7));
plot([0 size(data.trials.t1.psd.e3.sai.means.beta,1)],[data.trials.t1.psd.e3.sai.supermeans.beta(7) data.trials.t1.psd.e3.sai.supermeans.beta(7)],'r','LineWidth',2)
plot([0 size(data.trials.t1.psd.e3.sai.means.beta,1)],[data.trials.t1.psd.e3.sai.supermeans.beta(7)+3*std_sai_means_e3_7 data.trials.t1.psd.e3.sai.supermeans.beta(7)+3*std_sai_means_e3_7],'--r')
if data.trials.t1.psd.e3.sai.supermeans.beta(7)-3*std_sai_means_e3_7>0
    plot([0 size(data.trials.t1.psd.e3.sai.means.beta,1)],...
        [data.trials.t1.psd.e3.sai.supermeans.beta(7)-3*std_sai_means_e3_7 data.trials.t1.psd.e3.sai.supermeans.beta(7)-3*std_sai_means_e3_7],'--r')
else
end

subplot(8,2,12); hold on
std_sai_means_e3_18=std(data.trials.t1.psd.e3.sai.means.beta(:,18));
plot([0 size(data.trials.t1.psd.e3.sai.means.beta,1)],[data.trials.t1.psd.e3.sai.supermeans.beta(18) data.trials.t1.psd.e3.sai.supermeans.beta(18)],'r','LineWidth',2)
plot([0 size(data.trials.t1.psd.e3.sai.means.beta,1)],[data.trials.t1.psd.e3.sai.supermeans.beta(18)+3*std_sai_means_e3_18 data.trials.t1.psd.e3.sai.supermeans.beta(18)+3*std_sai_means_e3_18],'--r')
if data.trials.t1.psd.e3.sai.supermeans.beta(18)-3*std_sai_means_e3_18>0
    plot([0 size(data.trials.t1.psd.e3.sai.means.beta,1)],...
        [data.trials.t1.psd.e3.sai.supermeans.beta(18)-3*std_sai_means_e3_18 data.trials.t1.psd.e3.sai.supermeans.beta(18)-3*std_sai_means_e3_18],'--r')
else
end

subplot(8,2,15); hold on
std_sai_means_e4_7=std(data.trials.t1.psd.e4.sai.means.beta(:,7));
plot([0 size(data.trials.t1.psd.e4.sai.means.beta,1)],[data.trials.t1.psd.e4.sai.supermeans.beta(7) data.trials.t1.psd.e4.sai.supermeans.beta(7)],'r','LineWidth',2)
plot([0 size(data.trials.t1.psd.e4.sai.means.beta,1)],[data.trials.t1.psd.e4.sai.supermeans.beta(7)+3*std_sai_means_e4_7 data.trials.t1.psd.e4.sai.supermeans.beta(7)+3*std_sai_means_e4_7],'--r')
if data.trials.t1.psd.e4.sai.supermeans.beta(7)-3*std_sai_means_e4_7>0
    plot([0 size(data.trials.t1.psd.e4.sai.means.beta,1)],...
        [data.trials.t1.psd.e4.sai.supermeans.beta(7)-3*std_sai_means_e4_7 data.trials.t1.psd.e4.sai.supermeans.beta(7)-3*std_sai_means_e4_7],'--r')
else
end

subplot(8,2,16); hold on
std_sai_means_e4_18=std(data.trials.t1.psd.e4.sai.means.beta(:,18));
plot([0 size(data.trials.t1.psd.e4.sai.means.beta,1)],[data.trials.t1.psd.e4.sai.supermeans.beta(18) data.trials.t1.psd.e4.sai.supermeans.beta(18)],'r','LineWidth',2)
plot([0 size(data.trials.t1.psd.e4.sai.means.beta,1)],[data.trials.t1.psd.e4.sai.supermeans.beta(18)+3*std_sai_means_e4_18 data.trials.t1.psd.e4.sai.supermeans.beta(18)+3*std_sai_means_e4_18],'--r')
if data.trials.t1.psd.e4.sai.supermeans.beta(18)-3*std_sai_means_e4_18>0
    plot([0 size(data.trials.t1.psd.e4.sai.means.beta,1)],...
        [data.trials.t1.psd.e4.sai.supermeans.beta(18)-3*std_sai_means_e4_18 data.trials.t1.psd.e4.sai.supermeans.beta(18)-3*std_sai_means_e4_18],'--r')
else
end

%find psd means > 3STD and create new epochs
find_means_above_3std_e1_7=find(data.trials.t1.psd.e1.sai.means.beta(:,7)>=data.trials.t1.psd.e1.sai.supermeans.beta(7)+3*std_sai_means_e1_7)
if isempty(find(find_means_above_3std_e1_7==0))==1
    range_find_means_above_3std_e1_7=[0 find_means_above_3std_e1_7']
end

if isempty(find(find_means_above_3std_e1_7==(data.trials.t1.epochs.e1(2)-data.trials.t1.epochs.e1(1))/1e3))==1
    range_find_means_above_3std_e1_7=[range_find_means_above_3std_e1_7 (data.trials.t1.epochs.e1(2)-data.trials.t1.epochs.e1(1))/1e3]
end
[max_diff_range_find_means_above_3std_e1_7,i_max_diff_range_find_means_above_3std_e1_7]=max(diff(range_find_means_above_3std_e1_7))
epoch_new_e1_7=[range_find_means_above_3std_e1_7(i_max_diff_range_find_means_above_3std_e1_7)+1 range_find_means_above_3std_e1_7(i_max_diff_range_find_means_above_3std_e1_7+1)-1]*1e3
data.trials.t1.epochs_new.e1_7=[data.trials.t1.epochs.e1(1)+epoch_new_e1_7(1) data.trials.t1.epochs.e1(1)+epoch_new_e1_7(2)]


find_means_above_3std_e1_18=find(data.trials.t1.psd.e1.sai.means.beta(:,18)>=data.trials.t1.psd.e1.sai.supermeans.beta(18)+3*std_sai_means_e1_18)
if isempty(find(find_means_above_3std_e1_18==0))==1
    range_find_means_above_3std_e1_18=[0 find_means_above_3std_e1_18']
end

if isempty(find(find_means_above_3std_e1_18==(data.trials.t1.epochs.e1(2)-data.trials.t1.epochs.e1(1))/1e3))==1
    range_find_means_above_3std_e1_18=[range_find_means_above_3std_e1_18 (data.trials.t1.epochs.e1(2)-data.trials.t1.epochs.e1(1))/1e3]
end
[max_diff_range_find_means_above_3std_e1_18,i_max_diff_range_find_means_above_3std_e1_18]=max(diff(range_find_means_above_3std_e1_18))
epoch_new_e1_18=[range_find_means_above_3std_e1_18(i_max_diff_range_find_means_above_3std_e1_18)+1 range_find_means_above_3std_e1_18(i_max_diff_range_find_means_above_3std_e1_18+1)-1]*1e3
data.trials.t1.epochs_new.e1_18=[data.trials.t1.epochs.e1(1)+epoch_new_e1_18(1) data.trials.t1.epochs.e1(1)+epoch_new_e1_18(2)]


find_means_above_3std_e2_7=find(data.trials.t1.psd.e2.sai.means.beta(:,7)>=data.trials.t1.psd.e2.sai.supermeans.beta(7)+3*std_sai_means_e2_7)
if isempty(find(find_means_above_3std_e2_7==0))==1
    range_find_means_above_3std_e2_7=[0 find_means_above_3std_e2_7']
end

if isempty(find(find_means_above_3std_e2_7==(data.trials.t1.epochs.e2(2)-data.trials.t1.epochs.e2(1))/1e3))==1
    range_find_means_above_3std_e2_7=[range_find_means_above_3std_e2_7 (data.trials.t1.epochs.e2(2)-data.trials.t1.epochs.e2(1))/1e3]
end
[max_diff_range_find_means_above_3std_e2_7,i_max_diff_range_find_means_above_3std_e2_7]=max(diff(range_find_means_above_3std_e2_7))
epoch_new_e2_7=[range_find_means_above_3std_e2_7(i_max_diff_range_find_means_above_3std_e2_7)+1 range_find_means_above_3std_e2_7(i_max_diff_range_find_means_above_3std_e2_7+1)-1]*1e3
data.trials.t1.epochs_new.e2_7=[data.trials.t1.epochs.e2(1)+epoch_new_e2_7(1) data.trials.t1.epochs.e2(1)+epoch_new_e2_7(2)]


find_means_above_3std_e2_18=find(data.trials.t1.psd.e2.sai.means.beta(:,18)>=data.trials.t1.psd.e2.sai.supermeans.beta(18)+3*std_sai_means_e2_18)
if isempty(find(find_means_above_3std_e2_18==0))==1
    range_find_means_above_3std_e2_18=[0 find_means_above_3std_e2_18']
end

if isempty(find(find_means_above_3std_e2_18==(data.trials.t1.epochs.e2(2)-data.trials.t1.epochs.e2(1))/1e3))==1
    range_find_means_above_3std_e2_18=[range_find_means_above_3std_e2_18 (data.trials.t1.epochs.e2(2)-data.trials.t1.epochs.e2(1))/1e3]
end
[max_diff_range_find_means_above_3std_e2_18,i_max_diff_range_find_means_above_3std_e2_18]=max(diff(range_find_means_above_3std_e2_18))
epoch_new_e2_18=[range_find_means_above_3std_e2_18(i_max_diff_range_find_means_above_3std_e2_18)+1 range_find_means_above_3std_e2_18(i_max_diff_range_find_means_above_3std_e2_18+1)-1]*1e3
data.trials.t1.epochs_new.e2_18=[data.trials.t1.epochs.e2(1)+epoch_new_e2_18(1) data.trials.t1.epochs.e2(1)+epoch_new_e2_18(2)]

find_means_above_3std_e3_7=find(data.trials.t1.psd.e3.sai.means.beta(:,7)>=data.trials.t1.psd.e3.sai.supermeans.beta(7)+3*std_sai_means_e3_7)
if isempty(find(find_means_above_3std_e3_7==0))==1
    range_find_means_above_3std_e3_7=[0 find_means_above_3std_e3_7']
end

if isempty(find(find_means_above_3std_e3_7==(data.trials.t1.epochs.e3(2)-data.trials.t1.epochs.e3(1))/1e3))==1
    range_find_means_above_3std_e3_7=[range_find_means_above_3std_e3_7 (data.trials.t1.epochs.e3(2)-data.trials.t1.epochs.e3(1))/1e3]
end
[max_diff_range_find_means_above_3std_e3_7,i_max_diff_range_find_means_above_3std_e3_7]=max(diff(range_find_means_above_3std_e3_7))
epoch_new_e3_7=[range_find_means_above_3std_e3_7(i_max_diff_range_find_means_above_3std_e3_7)+1 range_find_means_above_3std_e3_7(i_max_diff_range_find_means_above_3std_e3_7+1)-1]*1e3
data.trials.t1.epochs_new.e3_7=[data.trials.t1.epochs.e3(1)+epoch_new_e3_7(1) data.trials.t1.epochs.e3(1)+epoch_new_e3_7(2)]

find_means_above_3std_e3_18=find(data.trials.t1.psd.e3.sai.means.beta(:,18)>=data.trials.t1.psd.e3.sai.supermeans.beta(18)+3*std_sai_means_e3_18)
if isempty(find(find_means_above_3std_e3_18==0))==1
    range_find_means_above_3std_e3_18=[0 find_means_above_3std_e3_18']
end

if isempty(find(find_means_above_3std_e3_18==(data.trials.t1.epochs.e3(2)-data.trials.t1.epochs.e3(1))/1e3))==1
    range_find_means_above_3std_e3_18=[range_find_means_above_3std_e3_18 (data.trials.t1.epochs.e3(2)-data.trials.t1.epochs.e3(1))/1e3]
end
[max_diff_range_find_means_above_3std_e3_18,i_max_diff_range_find_means_above_3std_e3_18]=max(diff(range_find_means_above_3std_e3_18))
epoch_new_e3_18=[range_find_means_above_3std_e3_18(i_max_diff_range_find_means_above_3std_e3_18)+1 range_find_means_above_3std_e3_18(i_max_diff_range_find_means_above_3std_e3_18+1)-1]*1e3
data.trials.t1.epochs_new.e3_18=[data.trials.t1.epochs.e3(1)+epoch_new_e3_18(1) data.trials.t1.epochs.e3(1)+epoch_new_e3_18(2)]

find_means_above_3std_e4_7=find(data.trials.t1.psd.e4.sai.means.beta(:,7)>=data.trials.t1.psd.e4.sai.supermeans.beta(7)+3*std_sai_means_e4_7)
if isempty(find(find_means_above_3std_e4_7==0))==1
    range_find_means_above_3std_e4_7=[0 find_means_above_3std_e4_7']
end

if isempty(find(find_means_above_3std_e4_7==(data.trials.t1.epochs.e4(2)-data.trials.t1.epochs.e4(1))/1e3))==1
    range_find_means_above_3std_e4_7=[range_find_means_above_3std_e4_7 (data.trials.t1.epochs.e4(2)-data.trials.t1.epochs.e4(1))/1e3]
end
[max_diff_range_find_means_above_3std_e4_7,i_max_diff_range_find_means_above_3std_e4_7]=max(diff(range_find_means_above_3std_e4_7))
epoch_new_e4_7=[range_find_means_above_3std_e4_7(i_max_diff_range_find_means_above_3std_e4_7)+1 range_find_means_above_3std_e4_7(i_max_diff_range_find_means_above_3std_e4_7+1)-1]*1e3
data.trials.t1.epochs_new.e4_7=[data.trials.t1.epochs.e4(1)+epoch_new_e4_7(1) data.trials.t1.epochs.e4(1)+epoch_new_e4_7(2)]

find_means_above_3std_e4_18=find(data.trials.t1.psd.e4.sai.means.beta(:,18)>=data.trials.t1.psd.e4.sai.supermeans.beta(18)+3*std_sai_means_e4_18)
if isempty(find(find_means_above_3std_e4_18==0))==1
    range_find_means_above_3std_e4_18=[0 find_means_above_3std_e4_18']
end

if isempty(find(find_means_above_3std_e4_18==(data.trials.t1.epochs.e4(2)-data.trials.t1.epochs.e4(1))/1e3))==1
    range_find_means_above_3std_e4_18=[range_find_means_above_3std_e4_18 (data.trials.t1.epochs.e4(2)-data.trials.t1.epochs.e4(1))/1e3]
end
[max_diff_range_find_means_above_3std_e4_18,i_max_diff_range_find_means_above_3std_e4_18]=max(diff(range_find_means_above_3std_e4_18))
epoch_new_e4_18=[range_find_means_above_3std_e4_18(i_max_diff_range_find_means_above_3std_e4_18)+1 range_find_means_above_3std_e4_18(i_max_diff_range_find_means_above_3std_e4_18+1)-1]*1e3
data.trials.t1.epochs_new.e4_18=[data.trials.t1.epochs.e4(1)+epoch_new_e4_18(1) data.trials.t1.epochs.e4(1)+epoch_new_e4_18(2)]


%plot new epochs
subplot(8,2,3)
ylim_e1_7=get(gca,'ylim')
plot([epoch_new_e1_7(1) epoch_new_e1_7(2)]/1000,[ylim_e1_7(2)-.1*ylim_e1_7(2) ylim_e1_7(2)-.1*ylim_e1_7(2)],'g','LineWidth',2)

subplot(8,2,4)
ylim_e1_18=get(gca,'ylim')
plot([epoch_new_e1_18(1) epoch_new_e1_18(2)]/1000,[ylim_e1_18(2)-.1*ylim_e1_18(2) ylim_e1_18(2)-.1*ylim_e1_18(2)],'g','LineWidth',2)

subplot(8,2,7)
ylim_e2_7=get(gca,'ylim')
plot([epoch_new_e2_7(1) epoch_new_e2_7(2)]/1000,[ylim_e2_7(2)-.1*ylim_e2_7(2) ylim_e2_7(2)-.1*ylim_e2_7(2)],'g','LineWidth',2)

subplot(8,2,8)
ylim_e2_18=get(gca,'ylim')
plot([epoch_new_e2_18(1) epoch_new_e2_18(2)]/1000,[ylim_e2_18(2)-.1*ylim_e2_18(2) ylim_e2_18(2)-.1*ylim_e2_18(2)],'g','LineWidth',2)

subplot(8,2,11)
ylim_e3_7=get(gca,'ylim')
plot([epoch_new_e3_7(1) epoch_new_e3_7(2)]/1000,[ylim_e3_7(2)-.1*ylim_e3_7(2) ylim_e3_7(2)-.1*ylim_e3_7(2)],'g','LineWidth',2)

subplot(8,2,12)
ylim_e3_18=get(gca,'ylim')
plot([epoch_new_e3_18(1) epoch_new_e3_18(2)]/1000,[ylim_e3_18(2)-.1*ylim_e3_18(2) ylim_e3_18(2)-.1*ylim_e3_18(2)],'g','LineWidth',2)

subplot(8,2,15)
ylim_e4_7=get(gca,'ylim')
plot([epoch_new_e4_7(1) epoch_new_e4_7(2)]/1000,[ylim_e4_7(2)-.1*ylim_e4_7(2) ylim_e4_7(2)-.1*ylim_e4_7(2)],'g','LineWidth',2)

subplot(8,2,16)
ylim_e4_18=get(gca,'ylim')
plot([epoch_new_e4_18(1) epoch_new_e4_18(2)]/1000,[ylim_e4_18(2)-.1*ylim_e4_18(2) ylim_e4_18(2)-.1*ylim_e4_18(2)],'g','LineWidth',2)


%plot boxes around new epochs
subplot(8,2,1); hold on
ylim_e1_7=get(gca,'ylim');
plot([data.trials.t1.epochs_new.e1_7(1)-data.trials.t1.epochs.e1(1) data.trials.t1.epochs_new.e1_7(2)-data.trials.t1.epochs.e1(1)],...
    [ylim_e1_7(1)-0.2*ylim_e1_7(1) ylim_e1_7(1)-0.2*ylim_e1_7(1)],'k','LineWidth',2)
plot([data.trials.t1.epochs_new.e1_7(1)-data.trials.t1.epochs.e1(1) data.trials.t1.epochs_new.e1_7(2)-data.trials.t1.epochs.e1(1)],...
    [ylim_e1_7(2)-0.2*ylim_e1_7(2) ylim_e1_7(2)-0.2*ylim_e1_7(2)],'k','LineWidth',2)
plot([data.trials.t1.epochs_new.e1_7(1) data.trials.t1.epochs_new.e1_7(1)],[-400 -200],'k')
plot([data.trials.t1.epochs_new.e1_7(1)-data.trials.t1.epochs.e1(1) data.trials.t1.epochs_new.e1_7(1)-data.trials.t1.epochs.e1(1)],...
    [ylim_e1_7(1)-0.2*ylim_e1_7(1) ylim_e1_7(2)-0.2*ylim_e1_7(2)],'k','LineWidth',2)
plot([data.trials.t1.epochs_new.e1_7(2)-data.trials.t1.epochs.e1(1) data.trials.t1.epochs_new.e1_7(2)-data.trials.t1.epochs.e1(1)],...
    [ylim_e1_7(1)-0.2*ylim_e1_7(1) ylim_e1_7(2)-0.2*ylim_e1_7(2)],'k','LineWidth',2)

subplot(8,2,2); hold on
ylim_e1_18=get(gca,'ylim');
plot([data.trials.t1.epochs_new.e1_18(1)-data.trials.t1.epochs.e1(1) data.trials.t1.epochs_new.e1_18(2)-data.trials.t1.epochs.e1(1)],...
    [ylim_e1_18(1)-0.2*ylim_e1_18(1) ylim_e1_18(1)-0.2*ylim_e1_18(1)],'k','LineWidth',2)
plot([data.trials.t1.epochs_new.e1_18(1)-data.trials.t1.epochs.e1(1) data.trials.t1.epochs_new.e1_18(2)-data.trials.t1.epochs.e1(1)],...
    [ylim_e1_18(2)-0.2*ylim_e1_18(2) ylim_e1_18(2)-0.2*ylim_e1_18(2)],'k','LineWidth',2)
plot([data.trials.t1.epochs_new.e1_18(1) data.trials.t1.epochs_new.e1_18(1)],[-400 -200],'k')
plot([data.trials.t1.epochs_new.e1_18(1)-data.trials.t1.epochs.e1(1) data.trials.t1.epochs_new.e1_18(1)-data.trials.t1.epochs.e1(1)],...
    [ylim_e1_18(1)-0.2*ylim_e1_18(1) ylim_e1_18(2)-0.2*ylim_e1_18(2)],'k','LineWidth',2)
plot([data.trials.t1.epochs_new.e1_18(2)-data.trials.t1.epochs.e1(1) data.trials.t1.epochs_new.e1_18(2)-data.trials.t1.epochs.e1(1)],...
    [ylim_e1_18(1)-0.2*ylim_e1_18(1) ylim_e1_18(2)-0.2*ylim_e1_18(2)],'k','LineWidth',2)

subplot(8,2,5); hold on
ylim_e2_7=get(gca,'ylim');
plot([data.trials.t1.epochs_new.e2_7(1)-data.trials.t1.epochs.e2(1) data.trials.t1.epochs_new.e2_7(2)-data.trials.t1.epochs.e2(1)],...
    [ylim_e2_7(1)-0.2*ylim_e2_7(1) ylim_e2_7(1)-0.2*ylim_e2_7(1)],'k','LineWidth',2)
plot([data.trials.t1.epochs_new.e2_7(1)-data.trials.t1.epochs.e2(1) data.trials.t1.epochs_new.e2_7(2)-data.trials.t1.epochs.e2(1)],...
    [ylim_e2_7(2)-0.2*ylim_e2_7(2) ylim_e2_7(2)-0.2*ylim_e2_7(2)],'k','LineWidth',2)
plot([data.trials.t1.epochs_new.e2_7(1) data.trials.t1.epochs_new.e2_7(1)],[-400 -200],'k')
plot([data.trials.t1.epochs_new.e2_7(1)-data.trials.t1.epochs.e2(1) data.trials.t1.epochs_new.e2_7(1)-data.trials.t1.epochs.e2(1)],...
    [ylim_e2_7(1)-0.2*ylim_e2_7(1) ylim_e2_7(2)-0.2*ylim_e2_7(2)],'k','LineWidth',2)
plot([data.trials.t1.epochs_new.e2_7(2)-data.trials.t1.epochs.e2(1) data.trials.t1.epochs_new.e2_7(2)-data.trials.t1.epochs.e2(1)],...
    [ylim_e2_7(1)-0.2*ylim_e2_7(1) ylim_e2_7(2)-0.2*ylim_e2_7(2)],'k','LineWidth',2)

subplot(8,2,6); hold on
ylim_e2_18=get(gca,'ylim');
plot([data.trials.t1.epochs_new.e2_18(1)-data.trials.t1.epochs.e2(1) data.trials.t1.epochs_new.e2_18(2)-data.trials.t1.epochs.e2(1)],...
    [ylim_e2_18(1)-0.2*ylim_e2_18(1) ylim_e2_18(1)-0.2*ylim_e2_18(1)],'k','LineWidth',2)
plot([data.trials.t1.epochs_new.e2_18(1)-data.trials.t1.epochs.e2(1) data.trials.t1.epochs_new.e2_18(2)-data.trials.t1.epochs.e2(1)],...
    [ylim_e2_18(2)-0.2*ylim_e2_18(2) ylim_e2_18(2)-0.2*ylim_e2_18(2)],'k','LineWidth',2)
plot([data.trials.t1.epochs_new.e2_18(1) data.trials.t1.epochs_new.e2_18(1)],[-400 -200],'k')
plot([data.trials.t1.epochs_new.e2_18(1)-data.trials.t1.epochs.e2(1) data.trials.t1.epochs_new.e2_18(1)-data.trials.t1.epochs.e2(1)],...
    [ylim_e2_18(1)-0.2*ylim_e2_18(1) ylim_e2_18(2)-0.2*ylim_e2_18(2)],'k','LineWidth',2)
plot([data.trials.t1.epochs_new.e2_18(2)-data.trials.t1.epochs.e2(1) data.trials.t1.epochs_new.e2_18(2)-data.trials.t1.epochs.e2(1)],...
    [ylim_e2_18(1)-0.2*ylim_e2_18(1) ylim_e2_18(2)-0.2*ylim_e2_18(2)],'k','LineWidth',2)

subplot(8,2,9); hold on
ylim_e3_7=get(gca,'ylim');
plot([data.trials.t1.epochs_new.e3_7(1)-data.trials.t1.epochs.e3(1) data.trials.t1.epochs_new.e3_7(2)-data.trials.t1.epochs.e3(1)],...
    [ylim_e3_7(1)-0.2*ylim_e3_7(1) ylim_e3_7(1)-0.2*ylim_e3_7(1)],'k','LineWidth',2)
plot([data.trials.t1.epochs_new.e3_7(1)-data.trials.t1.epochs.e3(1) data.trials.t1.epochs_new.e3_7(2)-data.trials.t1.epochs.e3(1)],...
    [ylim_e3_7(2)-0.2*ylim_e3_7(2) ylim_e3_7(2)-0.2*ylim_e3_7(2)],'k','LineWidth',2)
plot([data.trials.t1.epochs_new.e3_7(1) data.trials.t1.epochs_new.e3_7(1)],[-400 -200],'k')
plot([data.trials.t1.epochs_new.e3_7(1)-data.trials.t1.epochs.e3(1) data.trials.t1.epochs_new.e3_7(1)-data.trials.t1.epochs.e3(1)],...
    [ylim_e3_7(1)-0.2*ylim_e3_7(1) ylim_e3_7(2)-0.2*ylim_e3_7(2)],'k','LineWidth',2)
plot([data.trials.t1.epochs_new.e3_7(2)-data.trials.t1.epochs.e3(1) data.trials.t1.epochs_new.e3_7(2)-data.trials.t1.epochs.e3(1)],...
    [ylim_e3_7(1)-0.2*ylim_e3_7(1) ylim_e3_7(2)-0.2*ylim_e3_7(2)],'k','LineWidth',2)

subplot(8,2,10); hold on
ylim_e3_18=get(gca,'ylim');
plot([data.trials.t1.epochs_new.e3_18(1)-data.trials.t1.epochs.e3(1) data.trials.t1.epochs_new.e3_18(2)-data.trials.t1.epochs.e3(1)],...
    [ylim_e3_18(1)-0.2*ylim_e3_18(1) ylim_e3_18(1)-0.2*ylim_e3_18(1)],'k','LineWidth',2)
plot([data.trials.t1.epochs_new.e3_18(1)-data.trials.t1.epochs.e3(1) data.trials.t1.epochs_new.e3_18(2)-data.trials.t1.epochs.e3(1)],...
    [ylim_e3_18(2)-0.2*ylim_e3_18(2) ylim_e3_18(2)-0.2*ylim_e3_18(2)],'k','LineWidth',2)
plot([data.trials.t1.epochs_new.e3_18(1) data.trials.t1.epochs_new.e3_18(1)],[-400 -200],'k')
plot([data.trials.t1.epochs_new.e3_18(1)-data.trials.t1.epochs.e3(1) data.trials.t1.epochs_new.e3_18(1)-data.trials.t1.epochs.e3(1)],...
    [ylim_e3_18(1)-0.2*ylim_e3_18(1) ylim_e3_18(2)-0.2*ylim_e3_18(2)],'k','LineWidth',2)
plot([data.trials.t1.epochs_new.e3_18(2)-data.trials.t1.epochs.e3(1) data.trials.t1.epochs_new.e3_18(2)-data.trials.t1.epochs.e3(1)],...
    [ylim_e3_18(1)-0.2*ylim_e3_18(1) ylim_e3_18(2)-0.2*ylim_e3_18(2)],'k','LineWidth',2)

subplot(8,2,13); hold on
ylim_e4_7=get(gca,'ylim');
plot([data.trials.t1.epochs_new.e4_7(1)-data.trials.t1.epochs.e4(1) data.trials.t1.epochs_new.e4_7(2)-data.trials.t1.epochs.e4(1)],...
    [ylim_e4_7(1)-0.2*ylim_e4_7(1) ylim_e4_7(1)-0.2*ylim_e4_7(1)],'k','LineWidth',2)
plot([data.trials.t1.epochs_new.e4_7(1)-data.trials.t1.epochs.e4(1) data.trials.t1.epochs_new.e4_7(2)-data.trials.t1.epochs.e4(1)],...
    [ylim_e4_7(2)-0.2*ylim_e4_7(2) ylim_e4_7(2)-0.2*ylim_e4_7(2)],'k','LineWidth',2)
plot([data.trials.t1.epochs_new.e4_7(1) data.trials.t1.epochs_new.e4_7(1)],[-400 -200],'k')
plot([data.trials.t1.epochs_new.e4_7(1)-data.trials.t1.epochs.e4(1) data.trials.t1.epochs_new.e4_7(1)-data.trials.t1.epochs.e4(1)],...
    [ylim_e4_7(1)-0.2*ylim_e4_7(1) ylim_e4_7(2)-0.2*ylim_e4_7(2)],'k','LineWidth',2)
plot([data.trials.t1.epochs_new.e4_7(2)-data.trials.t1.epochs.e4(1) data.trials.t1.epochs_new.e4_7(2)-data.trials.t1.epochs.e4(1)],...
    [ylim_e4_7(1)-0.2*ylim_e4_7(1) ylim_e4_7(2)-0.2*ylim_e4_7(2)],'k','LineWidth',2)

subplot(8,2,14); hold on
ylim_e4_18=get(gca,'ylim');
plot([data.trials.t1.epochs_new.e4_18(1)-data.trials.t1.epochs.e4(1) data.trials.t1.epochs_new.e4_18(2)-data.trials.t1.epochs.e4(1)],...
    [ylim_e4_18(1)-0.2*ylim_e4_18(1) ylim_e4_18(1)-0.2*ylim_e4_18(1)],'k','LineWidth',2)
plot([data.trials.t1.epochs_new.e4_18(1)-data.trials.t1.epochs.e4(1) data.trials.t1.epochs_new.e4_18(2)-data.trials.t1.epochs.e4(1)],...
    [ylim_e4_18(2)-0.2*ylim_e4_18(2) ylim_e4_18(2)-0.2*ylim_e4_18(2)],'k','LineWidth',2)
plot([data.trials.t1.epochs_new.e4_18(1) data.trials.t1.epochs_new.e4_18(1)],[-400 -200],'k')
plot([data.trials.t1.epochs_new.e4_18(1)-data.trials.t1.epochs.e4(1) data.trials.t1.epochs_new.e4_18(1)-data.trials.t1.epochs.e4(1)],...
    [ylim_e4_18(1)-0.2*ylim_e4_18(1) ylim_e4_18(2)-0.2*ylim_e4_18(2)],'k','LineWidth',2)
plot([data.trials.t1.epochs_new.e4_18(2)-data.trials.t1.epochs.e4(1) data.trials.t1.epochs_new.e4_18(2)-data.trials.t1.epochs.e4(1)],...
    [ylim_e4_18(1)-0.2*ylim_e4_18(1) ylim_e4_18(2)-0.2*ylim_e4_18(2)],'k','LineWidth',2)

cd ~/nr_data_analysis/data_analyzed/eeg
saveas(gcf,[data.cfg.info.dx,'_',data.cfg.info.stim_stat,'_',...
    data.cfg.info.n_sbj,'_',data.cfg.trial_data.t1.cond,'_02.pdf'])



%save new epochs
cd ~/nr_data_analysis/data_analyzed/eeg/
eval([var_name,'.trials.t1.epochs_new=data.trials.t1.epochs_new'])
eval(['save(''',data_file,''',''-append'',''',var_name,''')'])

