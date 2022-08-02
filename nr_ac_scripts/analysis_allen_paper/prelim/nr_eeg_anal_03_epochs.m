function nr_eeg_anal_03_epochs(data,e1_st,e1_ed,e2_st,e2_ed,e3_st,e3_ed,e4_st,e4_ed)

%define epochs
data.trials.t1.epochs.e1(1,1)=e1_st;
data.trials.t1.epochs.e1(1,2)=e1_ed;
data.trials.t1.epochs.e2(1,1)=e2_st;
data.trials.t1.epochs.e2(1,2)=e2_ed;
data.trials.t1.epochs.e3(1,1)=e3_st;
data.trials.t1.epochs.e3(1,2)=e3_ed;
data.trials.t1.epochs.e4(1,1)=e4_st;
data.trials.t1.epochs.e4(1,2)=e4_ed;

n_trial=data.cfg.info.n_trial;

% parse epochs
for i=1:size(n_trial,2)
    names_epoch=fieldnames(data.trials);
end

for i=1:size(n_trial,2)
    num_epoch(i)=size(fieldnames(eval(['data.trials.',names_epoch{i},'.epochs'])),1);
end

mat_trial_epoch_sort=sortrows([n_trial;num_epoch]');
mat_trial_epoch=[(1:size(n_trial,2))',mat_trial_epoch_sort(:,1),mat_trial_epoch_sort(:,2)];
data.cfg.info.mat_trial_epoch=mat_trial_epoch;

% plot data with epochs
for i=1:size(n_trial,2)
    for j=1:23%size(data.cfg.info.i_chan,2)
        if j==1
            figure; set(gcf,'Position',[123 60 840 1405])
        end
        if j==23
            eval(['plot(data.trials.t',num2str(i),'.sig.eeg(:,',num2str(j),')/10e2-j*1e3)']); hold on
        else
            eval(['plot(data.trials.t',num2str(i),'.sig.eeg(:,',num2str(j),')*2-j*1e3)']); hold on
        end
    end
    yplotlim=get(gca,'ylim');
    %eval(['plot(data.trials.t',num2str(i),'.sig.sync(:,1))']);
    %eval(['plot(data.trials.t',num2str(i),'.sig.trig(:,1))']);
    %eval(['plot(data.trials.t',num2str(i),'.sig.amps(:,1)/100)']);
    for k=1:mat_trial_epoch(i,3)
        eval(['plot([data.trials.t',num2str(i),'.epochs.e',num2str(k),'(1) data.trials.t',num2str(i),'.epochs.e',num2str(k),'(1)],[yplotlim(1) yplotlim(2)],''g'')']);
        eval(['plot([data.trials.t',num2str(i),'.epochs.e',num2str(k),'(2) data.trials.t',num2str(i),'.epochs.e',num2str(k),'(2)],[yplotlim(1) yplotlim(2)],''r'')']);
    end
    %legend('Lch1','Lch2','Lch3','Lch4','Lch5','Lch6','current')
    %title(eval(['data.cfg.trial_data.t',num2str(i),'.cond']))
    %use this instead title(['s',data.cfg.info.n_sbj,' t',num2str(i),' ',eval(['data.cfg.trial_data.t',num2str(i),'.cond']),' e',num2str(j),' all channels'])
            
end
title(['pro00087153 00',data.cfg.info.n_sbj,' ',data.cfg.trial_data.t1.cond])

data.trials.t1.sig.eeg(:,23)=[];

assignin('base','data',data)

