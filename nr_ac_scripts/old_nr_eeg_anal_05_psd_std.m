

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

%find indices above 3STD, then should be able to automatically recalc epoch
%can even put a green line there or something could maybe identify all
%possible epochs and then which one it chose
%maybe best to create a new field epoch_new then rerun untitled4

%%

find_means_above_3std_e1_7=find(data.trials.t1.psd.e1.sai.means.beta(:,7)>=data.trials.t1.psd.e1.sai.supermeans.beta(7)+3*std_sai_means_e1_7)
if isempty(find(find_means_above_3std_e1_7==0))==1
    range_find_means_above_3std_e1_7=[0 find_means_above_3std_e1_7']
end

if isempty(find(find_means_above_3std_e1_7==100))==1
    range_find_means_above_3std_e1_7=[range_find_means_above_3std_e1_7 100]
end
[max_diff_range_find_means_above_3std_e1_7,i_max_diff_range_find_means_above_3std_e1_7]=max(diff(range_find_means_above_3std_e1_7))
epoch_new_e1_7=[range_find_means_above_3std_e1_7(i_max_diff_range_find_means_above_3std_e1_7) range_find_means_above_3std_e1_7(i_max_diff_range_find_means_above_3std_e1_7+1)]*1e3
data.trials.t1.epochs_new.e1_7=[data.trials.t1.epochs.e1(1)+epoch_new_e1_7(1) data.trials.t1.epochs.e1(1)+epoch_new_e1_7(2)]


find_means_above_3std_e1_18=find(data.trials.t1.psd.e1.sai.means.beta(:,18)>=data.trials.t1.psd.e1.sai.supermeans.beta(18)+3*std_sai_means_e1_18)
if isempty(find(find_means_above_3std_e1_18==0))==1
    range_find_means_above_3std_e1_18=[0 find_means_above_3std_e1_18']
end

if isempty(find(find_means_above_3std_e1_18==100))==1
    range_find_means_above_3std_e1_18=[range_find_means_above_3std_e1_18 100]
end
[max_diff_range_find_means_above_3std_e1_18,i_max_diff_range_find_means_above_3std_e1_18]=max(diff(range_find_means_above_3std_e1_18))
epoch_new_e1_18=[range_find_means_above_3std_e1_18(i_max_diff_range_find_means_above_3std_e1_18) range_find_means_above_3std_e1_18(i_max_diff_range_find_means_above_3std_e1_18+1)]*1e3
data.trials.t1.epochs_new.e1_18=[data.trials.t1.epochs.e1(1)+epoch_new_e1_18(1) data.trials.t1.epochs.e1(1)+epoch_new_e1_18(2)]


find_means_above_3std_e2_7=find(data.trials.t1.psd.e2.sai.means.beta(:,7)>=data.trials.t1.psd.e2.sai.supermeans.beta(7)+3*std_sai_means_e2_7)
if isempty(find(find_means_above_3std_e2_7==0))==1
    range_find_means_above_3std_e2_7=[0 find_means_above_3std_e2_7']
end

if isempty(find(find_means_above_3std_e2_7==100))==1
    range_find_means_above_3std_e2_7=[range_find_means_above_3std_e2_7 100]
end
[max_diff_range_find_means_above_3std_e2_7,i_max_diff_range_find_means_above_3std_e2_7]=max(diff(range_find_means_above_3std_e2_7))
epoch_new_e2_7=[range_find_means_above_3std_e2_7(i_max_diff_range_find_means_above_3std_e2_7) range_find_means_above_3std_e2_7(i_max_diff_range_find_means_above_3std_e2_7+1)]*1e3
data.trials.t1.epochs_new.e2_7=[data.trials.t1.epochs.e2(1)+epoch_new_e2_7(1) data.trials.t1.epochs.e2(1)+epoch_new_e2_7(2)]


find_means_above_3std_e2_18=find(data.trials.t1.psd.e2.sai.means.beta(:,18)>=data.trials.t1.psd.e2.sai.supermeans.beta(18)+3*std_sai_means_e2_18)
if isempty(find(find_means_above_3std_e2_18==0))==1
    range_find_means_above_3std_e2_18=[0 find_means_above_3std_e2_18']
end

if isempty(find(find_means_above_3std_e2_18==100))==1
    range_find_means_above_3std_e2_18=[range_find_means_above_3std_e2_18 100]
end
[max_diff_range_find_means_above_3std_e2_18,i_max_diff_range_find_means_above_3std_e2_18]=max(diff(range_find_means_above_3std_e2_18))
epoch_new_e2_18=[range_find_means_above_3std_e2_18(i_max_diff_range_find_means_above_3std_e2_18) range_find_means_above_3std_e2_18(i_max_diff_range_find_means_above_3std_e2_18+1)]*1e3
data.trials.t1.epochs_new.e2_18=[data.trials.t1.epochs.e2(1)+epoch_new_e2_18(1) data.trials.t1.epochs.e2(1)+epoch_new_e2_18(2)]

find_means_above_3std_e3_7=find(data.trials.t1.psd.e3.sai.means.beta(:,7)>=data.trials.t1.psd.e3.sai.supermeans.beta(7)+3*std_sai_means_e3_7)
if isempty(find(find_means_above_3std_e3_7==0))==1
    range_find_means_above_3std_e3_7=[0 find_means_above_3std_e3_7']
end

if isempty(find(find_means_above_3std_e3_7==100))==1
    range_find_means_above_3std_e3_7=[range_find_means_above_3std_e3_7 100]
end
[max_diff_range_find_means_above_3std_e3_7,i_max_diff_range_find_means_above_3std_e3_7]=max(diff(range_find_means_above_3std_e3_7))
epoch_new_e3_7=[range_find_means_above_3std_e3_7(i_max_diff_range_find_means_above_3std_e3_7) range_find_means_above_3std_e3_7(i_max_diff_range_find_means_above_3std_e3_7+1)]*1e3
data.trials.t1.epochs_new.e3_7=[data.trials.t1.epochs.e3(1)+epoch_new_e3_7(1) data.trials.t1.epochs.e3(1)+epoch_new_e3_7(2)]

find_means_above_3std_e3_18=find(data.trials.t1.psd.e3.sai.means.beta(:,18)>=data.trials.t1.psd.e3.sai.supermeans.beta(18)+3*std_sai_means_e3_18)
if isempty(find(find_means_above_3std_e3_18==0))==1
    range_find_means_above_3std_e3_18=[0 find_means_above_3std_e3_18']
end

if isempty(find(find_means_above_3std_e3_18==100))==1
    range_find_means_above_3std_e3_18=[range_find_means_above_3std_e3_18 100]
end
[max_diff_range_find_means_above_3std_e3_18,i_max_diff_range_find_means_above_3std_e3_18]=max(diff(range_find_means_above_3std_e3_18))
epoch_new_e3_18=[range_find_means_above_3std_e3_18(i_max_diff_range_find_means_above_3std_e3_18) range_find_means_above_3std_e3_18(i_max_diff_range_find_means_above_3std_e3_18+1)]*1e3
data.trials.t1.epochs_new.e3_18=[data.trials.t1.epochs.e3(1)+epoch_new_e3_18(1) data.trials.t1.epochs.e3(1)+epoch_new_e3_18(2)]

find_means_above_3std_e4_7=find(data.trials.t1.psd.e4.sai.means.beta(:,7)>=data.trials.t1.psd.e4.sai.supermeans.beta(7)+3*std_sai_means_e4_7)
if isempty(find(find_means_above_3std_e4_7==0))==1
    range_find_means_above_3std_e4_7=[0 find_means_above_3std_e4_7']
end

if isempty(find(find_means_above_3std_e4_7==100))==1
    range_find_means_above_3std_e4_7=[range_find_means_above_3std_e4_7 100]
end
[max_diff_range_find_means_above_3std_e4_7,i_max_diff_range_find_means_above_3std_e4_7]=max(diff(range_find_means_above_3std_e4_7))
epoch_new_e4_7=[range_find_means_above_3std_e4_7(i_max_diff_range_find_means_above_3std_e4_7) range_find_means_above_3std_e4_7(i_max_diff_range_find_means_above_3std_e4_7+1)]*1e3
data.trials.t1.epochs_new.e4_7=[data.trials.t1.epochs.e4(1)+epoch_new_e4_7(1) data.trials.t1.epochs.e4(1)+epoch_new_e4_7(2)]

find_means_above_3std_e4_18=find(data.trials.t1.psd.e4.sai.means.beta(:,18)>=data.trials.t1.psd.e4.sai.supermeans.beta(18)+3*std_sai_means_e4_18)
if isempty(find(find_means_above_3std_e4_18==0))==1
    range_find_means_above_3std_e4_18=[0 find_means_above_3std_e4_18']
end

if isempty(find(find_means_above_3std_e4_18==100))==1
    range_find_means_above_3std_e4_18=[range_find_means_above_3std_e4_18 100]
end
[max_diff_range_find_means_above_3std_e4_18,i_max_diff_range_find_means_above_3std_e4_18]=max(diff(range_find_means_above_3std_e4_18))
epoch_new_e4_18=[range_find_means_above_3std_e4_18(i_max_diff_range_find_means_above_3std_e4_18) range_find_means_above_3std_e4_18(i_max_diff_range_find_means_above_3std_e4_18+1)]*1e3
data.trials.t1.epochs_new.e4_18=[data.trials.t1.epochs.e4(1)+epoch_new_e4_18(1) data.trials.t1.epochs.e4(1)+epoch_new_e4_18(2)]



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

cd ~/nr_data_analysis/data_analyzed/eeg
data_eeg_anal_rest_pro00087153_0003.trials.t1.epochs_new=data.trials.t1.epochs_new


