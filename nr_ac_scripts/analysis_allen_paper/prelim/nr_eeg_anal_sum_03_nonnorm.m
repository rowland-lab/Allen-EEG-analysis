sbjs_stm=['03';'04';'05';'42';'43'];
elec_stm_ipsi=[7,7,18,18,7];
elec_stm_cont=[18,18,7,7,18];
sbjs_non=['13';'15';'17';'18';'21'];
elec_non_ipsi=[18,7,18,18,18];
elec_non_cont=[7,18,7,7,7];

%stim ipsi rest beta
for i=1:size(sbjs_stm,1)
    load(['/home/rowlandn/nr_data_analysis/data_analyzed/eeg/data_eeg_anal_rest_pro00087153_00',sbjs_stm(i,:),'.mat'])
    if elec_stm_ipsi(i)==7
        eval(['data_sum_cs_stm_ipsi_rest_beta(',num2str(i),',:)=data_eeg_anal_rest_pro00087153_00',sbjs_stm(i,:),'.plots_new_7.beta.c7.supermeans'])
    else
        eval(['data_sum_cs_stm_ipsi_rest_beta(',num2str(i),',:)=data_eeg_anal_rest_pro00087153_00',sbjs_stm(i,:),'.plots_new_18.beta.c18.supermeans'])
    end
    clear data_eeg*
end

%stim cont rest beta
for i=1:size(sbjs_stm,1)
    load(['/home/rowlandn/nr_data_analysis/data_analyzed/eeg/data_eeg_anal_rest_pro00087153_00',sbjs_stm(i,:),'.mat'])
    if elec_stm_cont(i)==7
        eval(['data_sum_cs_stm_cont_rest_beta(',num2str(i),',:)=data_eeg_anal_rest_pro00087153_00',sbjs_stm(i,:),'.plots_new_7.beta.c7.supermeans'])
    else
        eval(['data_sum_cs_stm_cont_rest_beta(',num2str(i),',:)=data_eeg_anal_rest_pro00087153_00',sbjs_stm(i,:),'.plots_new_18.beta.c18.supermeans'])
    end
    clear data_eeg*
end

%stim ipsi move beta
for i=1:size(sbjs_stm,1)
    load(['/home/rowlandn/nr_data_analysis/data_analyzed/eeg/data_eeg_anal_move_pro00087153_00',sbjs_stm(i,:),'.mat'])
    if elec_stm_ipsi(i)==7
        eval(['data_sum_cs_stm_ipsi_move_beta(',num2str(i),',:)=data_eeg_anal_move_pro00087153_00',sbjs_stm(i,:),'.plots_new_7.beta.c7.supermeans'])
    else
        eval(['data_sum_cs_stm_ipsi_move_beta(',num2str(i),',:)=data_eeg_anal_move_pro00087153_00',sbjs_stm(i,:),'.plots_new_18.beta.c18.supermeans'])
    end
    clear data_eeg*
end

%stim cont move beta
for i=1:size(sbjs_stm,1)
    load(['/home/rowlandn/nr_data_analysis/data_analyzed/eeg/data_eeg_anal_move_pro00087153_00',sbjs_stm(i,:),'.mat'])
    if elec_stm_cont(i)==7
        eval(['data_sum_cs_stm_cont_move_beta(',num2str(i),',:)=data_eeg_anal_move_pro00087153_00',sbjs_stm(i,:),'.plots_new_7.beta.c7.supermeans'])
    else
        eval(['data_sum_cs_stm_cont_move_beta(',num2str(i),',:)=data_eeg_anal_move_pro00087153_00',sbjs_stm(i,:),'.plots_new_18.beta.c18.supermeans'])
    end
    clear data_eeg*
end

%nonstim ipsi rest beta
for i=1:size(sbjs_non,1)
    load(['/home/rowlandn/nr_data_analysis/data_analyzed/eeg/data_eeg_anal_rest_pro00087153_00',sbjs_non(i,:),'.mat'])
    if elec_non_ipsi(i)==7
        eval(['data_sum_cs_non_ipsi_rest_beta(',num2str(i),',:)=data_eeg_anal_rest_pro00087153_00',sbjs_non(i,:),'.plots_new_7.beta.c7.supermeans'])
    else
        eval(['data_sum_cs_non_ipsi_rest_beta(',num2str(i),',:)=data_eeg_anal_rest_pro00087153_00',sbjs_non(i,:),'.plots_new_18.beta.c18.supermeans'])
    end
    clear data_eeg*
end
%substituting 13
data_sum_cs_non_ipsi_rest_beta(1,1)=data_sum_cs_non_ipsi_rest_beta(1,2)

%nonstim cont rest beta
for i=1:size(sbjs_non,1)
    load(['/home/rowlandn/nr_data_analysis/data_analyzed/eeg/data_eeg_anal_rest_pro00087153_00',sbjs_non(i,:),'.mat'])
    if elec_non_cont(i)==7
        eval(['data_sum_cs_non_cont_rest_beta(',num2str(i),',:)=data_eeg_anal_rest_pro00087153_00',sbjs_non(i,:),'.plots_new_7.beta.c7.supermeans'])
    else
        eval(['data_sum_cs_non_cont_rest_beta(',num2str(i),',:)=data_eeg_anal_rest_pro00087153_00',sbjs_non(i,:),'.plots_new_18.beta.c18.supermeans'])
    end
    clear data_eeg*
end

%nonstim ipsi move beta
for i=1:size(sbjs_non,1)
    load(['/home/rowlandn/nr_data_analysis/data_analyzed/eeg/data_eeg_anal_move_pro00087153_00',sbjs_non(i,:),'.mat'])
    if elec_non_ipsi(i)==7
        eval(['data_sum_cs_non_ipsi_move_beta(',num2str(i),',:)=data_eeg_anal_move_pro00087153_00',sbjs_non(i,:),'.plots_new_7.beta.c7.supermeans'])
    else
        eval(['data_sum_cs_non_ipsi_move_beta(',num2str(i),',:)=data_eeg_anal_move_pro00087153_00',sbjs_non(i,:),'.plots_new_18.beta.c18.supermeans'])
    end
    clear data_eeg*
end
%substituting 13
data_sum_cs_non_ipsi_move_beta(1,1)=data_sum_cs_non_ipsi_move_beta(1,2)

%nonstim cont move beta
for i=1:size(sbjs_non,1)
    load(['/home/rowlandn/nr_data_analysis/data_analyzed/eeg/data_eeg_anal_move_pro00087153_00',sbjs_non(i,:),'.mat'])
    if elec_non_cont(i)==7
        eval(['data_sum_cs_non_cont_move_beta(',num2str(i),',:)=data_eeg_anal_move_pro00087153_00',sbjs_non(i,:),'.plots_new_7.beta.c7.supermeans'])
    else
        eval(['data_sum_cs_non_cont_move_beta(',num2str(i),',:)=data_eeg_anal_move_pro00087153_00',sbjs_non(i,:),'.plots_new_18.beta.c18.supermeans'])
    end
    clear data_eeg*
end

mean_data_sum_cs_stm_ipsi_rest_beta=mean(data_sum_cs_stm_ipsi_rest_beta)
se_data_sum_cs_stm_ipsi_rest_beta=std(data_sum_cs_stm_ipsi_rest_beta)/sqrt(size(data_sum_cs_stm_ipsi_rest_beta,1))

mean_data_sum_cs_stm_ipsi_move_beta=mean(data_sum_cs_stm_ipsi_move_beta)
se_data_sum_cs_stm_ipsi_move_beta=std(data_sum_cs_stm_ipsi_move_beta)/sqrt(size(data_sum_cs_stm_ipsi_move_beta,1))

mean_data_sum_cs_stm_cont_rest_beta=mean(data_sum_cs_stm_cont_rest_beta)
se_data_sum_cs_stm_cont_rest_beta=std(data_sum_cs_stm_cont_rest_beta)/sqrt(size(data_sum_cs_stm_cont_rest_beta,1))

mean_data_sum_cs_stm_cont_move_beta=mean(data_sum_cs_stm_cont_move_beta)
se_data_sum_cs_stm_cont_move_beta=std(data_sum_cs_stm_cont_move_beta)/sqrt(size(data_sum_cs_stm_cont_move_beta,1))

%13 substituted!!
mean_data_sum_cs_non_ipsi_rest_beta=mean(data_sum_cs_non_ipsi_rest_beta)
se_data_sum_cs_non_ipsi_rest_beta=std(data_sum_cs_non_ipsi_rest_beta)/sqrt(size(data_sum_cs_non_ipsi_rest_beta,1))

%13 substituted!!
mean_data_sum_cs_non_ipsi_move_beta=mean(data_sum_cs_non_ipsi_move_beta)
se_data_sum_cs_non_ipsi_move_beta=std(data_sum_cs_non_ipsi_move_beta)/sqrt(size(data_sum_cs_non_ipsi_move_beta,1))

mean_data_sum_cs_non_cont_rest_beta=mean(data_sum_cs_non_cont_rest_beta)
se_data_sum_cs_non_cont_rest_beta=std(data_sum_cs_non_cont_rest_beta)/sqrt(size(data_sum_cs_non_cont_rest_beta,1))

mean_data_sum_cs_non_cont_move_beta=mean(data_sum_cs_non_cont_move_beta)
se_data_sum_cs_non_cont_move_beta=std(data_sum_cs_non_cont_move_beta)/sqrt(size(data_sum_cs_non_cont_move_beta,1))

%stats
p_cs_stm_ipsi_rest_move_beta_base=ranksum(data_sum_cs_stm_ipsi_rest_beta(:,1),data_sum_cs_stm_ipsi_move_beta(:,1))
p_cs_stm_ipsi_rest_move_beta_earl=ranksum(data_sum_cs_stm_ipsi_rest_beta(:,2),data_sum_cs_stm_ipsi_move_beta(:,2))
p_cs_stm_ipsi_rest_move_beta_late=ranksum(data_sum_cs_stm_ipsi_rest_beta(:,3),data_sum_cs_stm_ipsi_move_beta(:,3))
p_cs_stm_ipsi_rest_move_beta_post=ranksum(data_sum_cs_stm_ipsi_rest_beta(:,4),data_sum_cs_stm_ipsi_move_beta(:,4))

p_cs_stm_cont_rest_move_beta_base=ranksum(data_sum_cs_stm_cont_rest_beta(:,1),data_sum_cs_stm_cont_move_beta(:,1))
p_cs_stm_cont_rest_move_beta_earl=ranksum(data_sum_cs_stm_cont_rest_beta(:,2),data_sum_cs_stm_cont_move_beta(:,2))
p_cs_stm_cont_rest_move_beta_late=ranksum(data_sum_cs_stm_cont_rest_beta(:,3),data_sum_cs_stm_cont_move_beta(:,3))
p_cs_stm_cont_rest_move_beta_post=ranksum(data_sum_cs_stm_cont_rest_beta(:,4),data_sum_cs_stm_cont_move_beta(:,4))

p_cs_non_ipsi_rest_move_beta_base=ranksum(data_sum_cs_non_ipsi_rest_beta(:,1),data_sum_cs_non_ipsi_move_beta(:,1))
p_cs_non_ipsi_rest_move_beta_earl=ranksum(data_sum_cs_non_ipsi_rest_beta(:,2),data_sum_cs_non_ipsi_move_beta(:,2))
p_cs_non_ipsi_rest_move_beta_late=ranksum(data_sum_cs_non_ipsi_rest_beta(:,3),data_sum_cs_non_ipsi_move_beta(:,3))
p_cs_non_ipsi_rest_move_beta_post=ranksum(data_sum_cs_non_ipsi_rest_beta(:,4),data_sum_cs_non_ipsi_move_beta(:,4))

p_cs_non_cont_rest_move_beta_base=ranksum(data_sum_cs_non_cont_rest_beta(:,1),data_sum_cs_non_cont_move_beta(:,1))
p_cs_non_cont_rest_move_beta_earl=ranksum(data_sum_cs_non_cont_rest_beta(:,2),data_sum_cs_non_cont_move_beta(:,2))
p_cs_non_cont_rest_move_beta_late=ranksum(data_sum_cs_non_cont_rest_beta(:,3),data_sum_cs_non_cont_move_beta(:,3))
p_cs_non_cont_rest_move_beta_post=ranksum(data_sum_cs_non_cont_rest_beta(:,4),data_sum_cs_non_cont_move_beta(:,4))

[p_cs_stm_ipsi_rest_beta,anovatab_cs_stm_ipsi_rest_beta,stats_cs_stm_ipsi_rest_beta]=kruskalwallis(data_sum_cs_stm_ipsi_rest_beta,...
    ['bs';'es';'ls';'ps'],'off')
[p_cs_stm_ipsi_move_beta,anovatab_cs_stm_ipsi_move_beta,stats_cs_stm_ipsi_move_beta]=kruskalwallis(data_sum_cs_stm_ipsi_move_beta,...
    ['bs';'es';'ls';'ps'],'off')
[p_cs_stm_cont_rest_beta,anovatab_cs_stm_cont_rest_beta,stats_cs_stm_cont_rest_beta]=kruskalwallis(data_sum_cs_stm_cont_rest_beta,...
    ['bs';'es';'ls';'ps'],'off')
[p_cs_stm_cont_move_beta,anovatab_cs_stm_cont_move_beta,stats_cs_stm_cont_move_beta]=kruskalwallis(data_sum_cs_stm_cont_move_beta,...
    ['bs';'es';'ls';'ps'],'off')

[p_cs_non_ipsi_rest_beta,anovatab_cs_non_ipsi_rest_beta,stats_cs_non_ipsi_rest_beta]=kruskalwallis(data_sum_cs_non_ipsi_rest_beta,...
    ['bs';'es';'ls';'ps'],'off')
[p_cs_non_ipsi_move_beta,anovatab_cs_non_ipsi_move_beta,stats_cs_non_ipsi_move_beta]=kruskalwallis(data_sum_cs_non_ipsi_move_beta,...
    ['bs';'es';'ls';'ps'],'off')
[p_cs_non_cont_rest_beta,anovatab_cs_non_cont_rest_beta,stats_cs_non_cont_rest_beta]=kruskalwallis(data_sum_cs_non_cont_rest_beta,...
    ['bs';'es';'ls';'ps'],'off')
[p_cs_non_cont_move_beta,anovatab_cs_non_cont_move_beta,stats_cs_non_cont_move_beta]=kruskalwallis(data_sum_cs_non_cont_move_beta,...
    ['bs';'es';'ls';'ps'],'off')



%% figure 1
figure
set(gcf,'Position',[178 196 802 1285])
subplot(6,2,1)
hold
bar([mean_data_sum_cs_stm_ipsi_rest_beta(1) mean_data_sum_cs_stm_ipsi_move_beta(1) 0,...
     mean_data_sum_cs_stm_ipsi_rest_beta(2) mean_data_sum_cs_stm_ipsi_move_beta(2) 0,...
     mean_data_sum_cs_stm_ipsi_rest_beta(3) mean_data_sum_cs_stm_ipsi_move_beta(3) 0,...
     mean_data_sum_cs_stm_ipsi_rest_beta(4) mean_data_sum_cs_stm_ipsi_move_beta(4)])
errorbar([mean_data_sum_cs_stm_ipsi_rest_beta(1) mean_data_sum_cs_stm_ipsi_move_beta(1) 0,...
          mean_data_sum_cs_stm_ipsi_rest_beta(2) mean_data_sum_cs_stm_ipsi_move_beta(2) 0,...
          mean_data_sum_cs_stm_ipsi_rest_beta(3) mean_data_sum_cs_stm_ipsi_move_beta(3) 0,...
          mean_data_sum_cs_stm_ipsi_rest_beta(4) mean_data_sum_cs_stm_ipsi_move_beta(4)],...
         [se_data_sum_cs_stm_ipsi_rest_beta(1) se_data_sum_cs_stm_ipsi_move_beta(1) 0,...
          se_data_sum_cs_stm_ipsi_rest_beta(2) se_data_sum_cs_stm_ipsi_move_beta(2) 0,...
          se_data_sum_cs_stm_ipsi_rest_beta(3) se_data_sum_cs_stm_ipsi_move_beta(3) 0,...
          se_data_sum_cs_stm_ipsi_rest_beta(4) se_data_sum_cs_stm_ipsi_move_beta(4)],'.k')
title(['cs stim ipsi beta whole (n=',num2str(size(data_sum_cs_stm_ipsi_rest_beta,1)),')'])
set(gca,'XTick',[1.5 4.5 7.5 10.5],'XTickLabel',['Base ';'Early';'Late ';'Post '])
set(gca,'XTick',[1 2 4 5 7 8 10 11],'XTickLabel',['R';'M';'R';'M';'R';'M';'R';'M'])
text(1,-0.5,'Base')
text(4,-0.5,'Early')
text(7,-0.5,'Late')
text(10,-0.5,'Post')
annotation('textbox',[0.5 0.96 0.15 0.02],'String',{'13 substituted 42, 43 added nonnorm'},'FitBoxToText','on')
ylim1=get(gca,'ylim')
set(gca,'ylim',[ylim1(1) ylim1(2)+0.1*ylim1(2)])
text(1,ylim1(2),num2str(p_cs_stm_ipsi_rest_move_beta_base))
text(4,ylim1(2),num2str(p_cs_stm_ipsi_rest_move_beta_earl))
text(7,ylim1(2),num2str(p_cs_stm_ipsi_rest_move_beta_late))
text(10,ylim1(2),num2str(p_cs_stm_ipsi_rest_move_beta_post))

subplot(6,2,2)
hold
bar([mean_data_sum_cs_stm_cont_rest_beta(1) mean_data_sum_cs_stm_cont_move_beta(1) 0,...
     mean_data_sum_cs_stm_cont_rest_beta(2) mean_data_sum_cs_stm_cont_move_beta(2) 0,...
     mean_data_sum_cs_stm_cont_rest_beta(3) mean_data_sum_cs_stm_cont_move_beta(3) 0,...
     mean_data_sum_cs_stm_cont_rest_beta(4) mean_data_sum_cs_stm_cont_move_beta(4)])
errorbar([mean_data_sum_cs_stm_cont_rest_beta(1) mean_data_sum_cs_stm_cont_move_beta(1) 0,...
          mean_data_sum_cs_stm_cont_rest_beta(2) mean_data_sum_cs_stm_cont_move_beta(2) 0,...
          mean_data_sum_cs_stm_cont_rest_beta(3) mean_data_sum_cs_stm_cont_move_beta(3) 0,...
          mean_data_sum_cs_stm_cont_rest_beta(4) mean_data_sum_cs_stm_cont_move_beta(4)],...
         [se_data_sum_cs_stm_cont_rest_beta(1) se_data_sum_cs_stm_cont_move_beta(1) 0,...
          se_data_sum_cs_stm_cont_rest_beta(2) se_data_sum_cs_stm_cont_move_beta(2) 0,...
          se_data_sum_cs_stm_cont_rest_beta(3) se_data_sum_cs_stm_cont_move_beta(3) 0,...
          se_data_sum_cs_stm_cont_rest_beta(4) se_data_sum_cs_stm_cont_move_beta(4)],'.k')
title(['cs stim cont beta whole (n=',num2str(size(data_sum_cs_stm_cont_rest_beta,1)),')'])
set(gca,'XTick',[1.5 4.5 7.5 10.5],'XTickLabel',['Base ';'Early';'Late ';'Post '])
ylim2=get(gca,'ylim')
set(gca,'ylim',[ylim2(1) ylim2(2)+0.1*ylim2(2)])
text(1,ylim2(2),num2str(p_cs_stm_cont_rest_move_beta_base))
text(4,ylim2(2),num2str(p_cs_stm_cont_rest_move_beta_earl))
text(7,ylim2(2),num2str(p_cs_stm_cont_rest_move_beta_late))
text(10,ylim2(2),num2str(p_cs_stm_cont_rest_move_beta_post))

subplot(6,2,3)
hold
bar([mean_data_sum_cs_non_ipsi_rest_beta(1) mean_data_sum_cs_non_ipsi_move_beta(1) 0,...
     mean_data_sum_cs_non_ipsi_rest_beta(2) mean_data_sum_cs_non_ipsi_move_beta(2) 0,...
     mean_data_sum_cs_non_ipsi_rest_beta(3) mean_data_sum_cs_non_ipsi_move_beta(3) 0,...
     mean_data_sum_cs_non_ipsi_rest_beta(4) mean_data_sum_cs_non_ipsi_move_beta(4)])
errorbar([mean_data_sum_cs_non_ipsi_rest_beta(1) mean_data_sum_cs_non_ipsi_move_beta(1) 0,...
          mean_data_sum_cs_non_ipsi_rest_beta(2) mean_data_sum_cs_non_ipsi_move_beta(2) 0,...
          mean_data_sum_cs_non_ipsi_rest_beta(3) mean_data_sum_cs_non_ipsi_move_beta(3) 0,...
          mean_data_sum_cs_non_ipsi_rest_beta(4) mean_data_sum_cs_non_ipsi_move_beta(4)],...
         [se_data_sum_cs_non_ipsi_rest_beta(1) se_data_sum_cs_non_ipsi_move_beta(1) 0,...
          se_data_sum_cs_non_ipsi_rest_beta(2) se_data_sum_cs_non_ipsi_move_beta(2) 0,...
          se_data_sum_cs_non_ipsi_rest_beta(3) se_data_sum_cs_non_ipsi_move_beta(3) 0,...
          se_data_sum_cs_non_ipsi_rest_beta(4) se_data_sum_cs_non_ipsi_move_beta(4)],'.k')
title(['cs non ipsi beta whole (n=',num2str(size(data_sum_cs_non_ipsi_rest_beta,1)),')'])
set(gca,'XTick',[1.5 4.5 7.5 10.5],'XTickLabel',['Base ';'Early';'Late ';'Post '])
ylim3=get(gca,'ylim')
set(gca,'ylim',[ylim3(1) ylim3(2)+0.1*ylim3(2)])
text(1,ylim3(2),num2str(p_cs_non_ipsi_rest_move_beta_base))
text(4,ylim3(2),num2str(p_cs_non_ipsi_rest_move_beta_earl))
text(7,ylim3(2),num2str(p_cs_non_ipsi_rest_move_beta_late))
text(10,ylim3(2),num2str(p_cs_non_ipsi_rest_move_beta_post))

subplot(6,2,4)
hold
bar([mean_data_sum_cs_non_cont_rest_beta(1) mean_data_sum_cs_non_cont_move_beta(1) 0,...
     mean_data_sum_cs_non_cont_rest_beta(2) mean_data_sum_cs_non_cont_move_beta(2) 0,...
     mean_data_sum_cs_non_cont_rest_beta(3) mean_data_sum_cs_non_cont_move_beta(3) 0,...
     mean_data_sum_cs_non_cont_rest_beta(4) mean_data_sum_cs_non_cont_move_beta(4)])
errorbar([mean_data_sum_cs_non_cont_rest_beta(1) mean_data_sum_cs_non_cont_move_beta(1) 0,...
          mean_data_sum_cs_non_cont_rest_beta(2) mean_data_sum_cs_non_cont_move_beta(2) 0,...
          mean_data_sum_cs_non_cont_rest_beta(3) mean_data_sum_cs_non_cont_move_beta(3) 0,...
          mean_data_sum_cs_non_cont_rest_beta(4) mean_data_sum_cs_non_cont_move_beta(4)],...
         [se_data_sum_cs_non_cont_rest_beta(1) se_data_sum_cs_non_cont_move_beta(1) 0,...
          se_data_sum_cs_non_cont_rest_beta(2) se_data_sum_cs_non_cont_move_beta(2) 0,...
          se_data_sum_cs_non_cont_rest_beta(3) se_data_sum_cs_non_cont_move_beta(3) 0,...
          se_data_sum_cs_non_cont_rest_beta(4) se_data_sum_cs_non_cont_move_beta(4)],'.k')
title(['cs non cont beta whole (n=',num2str(size(data_sum_cs_non_cont_rest_beta,1)),')'])
set(gca,'XTick',[1.5 4.5 7.5 10.5],'XTickLabel',['Base ';'Early';'Late ';'Post '])
ylim4=get(gca,'ylim')
set(gca,'ylim',[ylim4(1) ylim4(2)+0.1*ylim4(2)])
text(1,ylim4(2),num2str(p_cs_non_cont_rest_move_beta_base))
text(4,ylim4(2),num2str(p_cs_non_cont_rest_move_beta_earl))
text(7,ylim4(2),num2str(p_cs_non_cont_rest_move_beta_late))
text(10,ylim4(2),num2str(p_cs_non_cont_rest_move_beta_post))

subplot(6,2,5)
box_var_sum_stm_ipsi_beta(:,1)=data_sum_cs_stm_ipsi_rest_beta(:,1)
box_var_sum_stm_ipsi_beta(:,2)=data_sum_cs_stm_ipsi_move_beta(:,1)
box_var_sum_stm_ipsi_beta(:,3)=linspace(0,0,5)'
box_var_sum_stm_ipsi_beta(:,4)=data_sum_cs_stm_ipsi_rest_beta(:,2)
box_var_sum_stm_ipsi_beta(:,5)=data_sum_cs_stm_ipsi_move_beta(:,2)
box_var_sum_stm_ipsi_beta(:,6)=linspace(0,0,5)'
box_var_sum_stm_ipsi_beta(:,7)=data_sum_cs_stm_ipsi_rest_beta(:,3)
box_var_sum_stm_ipsi_beta(:,8)=data_sum_cs_stm_ipsi_move_beta(:,3)
box_var_sum_stm_ipsi_beta(:,9)=linspace(0,0,5)'
box_var_sum_stm_ipsi_beta(:,10)=data_sum_cs_stm_ipsi_rest_beta(:,4)
box_var_sum_stm_ipsi_beta(:,11)=data_sum_cs_stm_ipsi_move_beta(:,4)
boxplot(box_var_sum_stm_ipsi_beta)
title(['cs stim ipsi beta whole (n=',num2str(size(data_sum_cs_stm_ipsi_rest_beta,1)),')'])
set(gca,'XTick',[1.5 4.5 7.5 10.5],'XTickLabel',['Base ';'Early';'Late ';'Post '])

subplot(6,2,6)
box_var_sum_stm_cont_beta(:,1)=data_sum_cs_stm_cont_rest_beta(:,1)
box_var_sum_stm_cont_beta(:,2)=data_sum_cs_stm_cont_move_beta(:,1)
box_var_sum_stm_cont_beta(:,3)=linspace(0,0,5)'
box_var_sum_stm_cont_beta(:,4)=data_sum_cs_stm_cont_rest_beta(:,2)
box_var_sum_stm_cont_beta(:,5)=data_sum_cs_stm_cont_move_beta(:,2)
box_var_sum_stm_cont_beta(:,6)=linspace(0,0,5)'
box_var_sum_stm_cont_beta(:,7)=data_sum_cs_stm_cont_rest_beta(:,3)
box_var_sum_stm_cont_beta(:,8)=data_sum_cs_stm_cont_move_beta(:,3)
box_var_sum_stm_cont_beta(:,9)=linspace(0,0,5)'
box_var_sum_stm_cont_beta(:,10)=data_sum_cs_stm_cont_rest_beta(:,4)
box_var_sum_stm_cont_beta(:,11)=data_sum_cs_stm_cont_move_beta(:,4)
boxplot(box_var_sum_stm_cont_beta)
title(['cs stim cont beta whole (n=',num2str(size(data_sum_cs_stm_cont_rest_beta,1)),')'])
set(gca,'XTick',[1.5 4.5 7.5 10.5],'XTickLabel',['Base ';'Early';'Late ';'Post '])

subplot(6,2,7)
box_var_sum_non_ipsi_beta(:,1)=data_sum_cs_non_ipsi_rest_beta(:,1)
box_var_sum_non_ipsi_beta(:,2)=data_sum_cs_non_ipsi_move_beta(:,1)
box_var_sum_non_ipsi_beta(:,3)=linspace(0,0,5)'
box_var_sum_non_ipsi_beta(:,4)=data_sum_cs_non_ipsi_rest_beta(:,2)
box_var_sum_non_ipsi_beta(:,5)=data_sum_cs_non_ipsi_move_beta(:,2)
box_var_sum_non_ipsi_beta(:,6)=linspace(0,0,5)'
box_var_sum_non_ipsi_beta(:,7)=data_sum_cs_non_ipsi_rest_beta(:,3)
box_var_sum_non_ipsi_beta(:,8)=data_sum_cs_non_ipsi_move_beta(:,3)
box_var_sum_non_ipsi_beta(:,9)=linspace(0,0,5)'
box_var_sum_non_ipsi_beta(:,10)=data_sum_cs_non_ipsi_rest_beta(:,4)
box_var_sum_non_ipsi_beta(:,11)=data_sum_cs_non_ipsi_move_beta(:,4)
boxplot(box_var_sum_non_ipsi_beta)
title(['cs non ipsi beta whole (n=',num2str(size(data_sum_cs_non_ipsi_rest_beta,1)),')'])
set(gca,'XTick',[1.5 4.5 7.5 10.5],'XTickLabel',['Base ';'Early';'Late ';'Post '])

subplot(6,2,8)
box_var_sum_non_cont_beta(:,1)=data_sum_cs_non_cont_rest_beta(:,1)
box_var_sum_non_cont_beta(:,2)=data_sum_cs_non_cont_move_beta(:,1)
box_var_sum_non_cont_beta(:,3)=linspace(0,0,5)'
box_var_sum_non_cont_beta(:,4)=data_sum_cs_non_cont_rest_beta(:,2)
box_var_sum_non_cont_beta(:,5)=data_sum_cs_non_cont_move_beta(:,2)
box_var_sum_non_cont_beta(:,6)=linspace(0,0,5)'
box_var_sum_non_cont_beta(:,7)=data_sum_cs_non_cont_rest_beta(:,3)
box_var_sum_non_cont_beta(:,8)=data_sum_cs_non_cont_move_beta(:,3)
box_var_sum_non_cont_beta(:,9)=linspace(0,0,5)'
box_var_sum_non_cont_beta(:,10)=data_sum_cs_non_cont_rest_beta(:,4)
box_var_sum_non_cont_beta(:,11)=data_sum_cs_non_cont_move_beta(:,4)
boxplot(box_var_sum_non_cont_beta)
title(['cs non cont beta whole (n=',num2str(size(data_sum_cs_non_cont_rest_beta,1)),')'])
set(gca,'XTick',[1.5 4.5 7.5 10.5],'XTickLabel',['Base ';'Early';'Late ';'Post '])

data_st_stm_ipsi_all=[data_sum_cs_stm_ipsi_rest_beta;data_sum_cs_stm_ipsi_move_beta];
data_st_stm_cont_all=[data_sum_cs_stm_cont_rest_beta;data_sum_cs_stm_cont_move_beta];
data_st_non_ipsi_all=[data_sum_cs_non_ipsi_rest_beta;data_sum_cs_non_ipsi_move_beta];
data_st_non_cont_all=[data_sum_cs_non_cont_rest_beta;data_sum_cs_non_cont_move_beta];
max_data_st_stm_ipsi_all=max(max(data_st_stm_ipsi_all));
max_data_st_stm_cont_all=max(max(data_st_stm_cont_all));
max_data_st_non_ipsi_all=max(max(data_st_non_ipsi_all));
max_data_st_non_cont_all=max(max(data_st_non_cont_all));
cs_stim_sbj_num=['03';'04';'05';'42';'43']
cs_stim_color=['r','b','g','c','m']
cs_nonstim_sbj_num=['13';'15';'17';'18';'21']
cs_nonstim_color=['r','b','g','c','m']

subplot(6,2,9)
set(gca,'xlim',[0 12],'ylim',[0 max_data_st_stm_ipsi_all+0.1*max_data_st_stm_ipsi_all])
hold on
for i=1:size(data_sum_cs_stm_ipsi_rest_beta,1)
    text(1,data_sum_cs_stm_ipsi_rest_beta(i,1),cs_stim_sbj_num(i,:),'Color',cs_stim_color(i))
    text(2,data_sum_cs_stm_ipsi_move_beta(i,1),cs_stim_sbj_num(i,:),'Color',cs_stim_color(i))
    text(4,data_sum_cs_stm_ipsi_rest_beta(i,2),cs_stim_sbj_num(i,:),'Color',cs_stim_color(i))
    text(5,data_sum_cs_stm_ipsi_move_beta(i,2),cs_stim_sbj_num(i,:),'Color',cs_stim_color(i))
    text(7,data_sum_cs_stm_ipsi_rest_beta(i,3),cs_stim_sbj_num(i,:),'Color',cs_stim_color(i))
    text(8,data_sum_cs_stm_ipsi_move_beta(i,3),cs_stim_sbj_num(i,:),'Color',cs_stim_color(i))
    text(10,data_sum_cs_stm_ipsi_rest_beta(i,4),cs_stim_sbj_num(i,:),'Color',cs_stim_color(i))
    text(11,data_sum_cs_stm_ipsi_move_beta(i,4),cs_stim_sbj_num(i,:),'Color',cs_stim_color(i))
end
title(['cs stim ipsi beta whole (n=',num2str(size(data_sum_cs_stm_ipsi_rest_beta,1)),')'])
set(gca,'XTick',[1.5 4.5 7.5 10.5],'XTickLabel',['Base ';'Early';'Late ';'Post '])

subplot(6,2,10)
set(gca,'xlim',[0 12],'ylim',[0 max_data_st_stm_cont_all+0.1*max_data_st_stm_cont_all])
hold on
for i=1:size(data_sum_cs_stm_cont_rest_beta,1)
    text(1,data_sum_cs_stm_cont_rest_beta(i,1),cs_stim_sbj_num(i,:),'Color',cs_stim_color(i))
    text(2,data_sum_cs_stm_cont_move_beta(i,1),cs_stim_sbj_num(i,:),'Color',cs_stim_color(i))
    text(4,data_sum_cs_stm_cont_rest_beta(i,2),cs_stim_sbj_num(i,:),'Color',cs_stim_color(i))
    text(5,data_sum_cs_stm_cont_move_beta(i,2),cs_stim_sbj_num(i,:),'Color',cs_stim_color(i))
    text(7,data_sum_cs_stm_cont_rest_beta(i,3),cs_stim_sbj_num(i,:),'Color',cs_stim_color(i))
    text(8,data_sum_cs_stm_cont_move_beta(i,3),cs_stim_sbj_num(i,:),'Color',cs_stim_color(i))
    text(10,data_sum_cs_stm_cont_rest_beta(i,4),cs_stim_sbj_num(i,:),'Color',cs_stim_color(i))
    text(11,data_sum_cs_stm_cont_move_beta(i,4),cs_stim_sbj_num(i,:),'Color',cs_stim_color(i))
end
title(['cs stim cont beta whole (n=',num2str(size(data_sum_cs_stm_cont_rest_beta,1)),')'])
set(gca,'XTick',[1.5 4.5 7.5 10.5],'XTickLabel',['Base ';'Early';'Late ';'Post '])

subplot(6,2,11)
set(gca,'xlim',[0 12],'ylim',[0 max_data_st_non_ipsi_all+0.1*max_data_st_non_ipsi_all])
hold on
for i=1:size(data_sum_cs_non_ipsi_rest_beta,1)
    text(1,data_sum_cs_non_ipsi_rest_beta(i,1),cs_nonstim_sbj_num(i,:),'Color',cs_nonstim_color(i))
    text(2,data_sum_cs_non_ipsi_move_beta(i,1),cs_nonstim_sbj_num(i,:),'Color',cs_nonstim_color(i))
    text(4,data_sum_cs_non_ipsi_rest_beta(i,2),cs_nonstim_sbj_num(i,:),'Color',cs_nonstim_color(i))
    text(5,data_sum_cs_non_ipsi_move_beta(i,2),cs_nonstim_sbj_num(i,:),'Color',cs_nonstim_color(i))
    text(7,data_sum_cs_non_ipsi_rest_beta(i,3),cs_nonstim_sbj_num(i,:),'Color',cs_nonstim_color(i))
    text(8,data_sum_cs_non_ipsi_move_beta(i,3),cs_nonstim_sbj_num(i,:),'Color',cs_nonstim_color(i))
    text(10,data_sum_cs_non_ipsi_rest_beta(i,4),cs_nonstim_sbj_num(i,:),'Color',cs_nonstim_color(i))
    text(11,data_sum_cs_non_ipsi_move_beta(i,4),cs_nonstim_sbj_num(i,:),'Color',cs_nonstim_color(i))
end
title(['cs non ipsi beta whole (n=',num2str(size(data_sum_cs_non_ipsi_rest_beta,1)),')'])
set(gca,'XTick',[1.5 4.5 7.5 10.5],'XTickLabel',['Base ';'Early';'Late ';'Post '])

subplot(6,2,12)
set(gca,'xlim',[0 12],'ylim',[0 max_data_st_non_cont_all+0.1*max_data_st_non_cont_all])
hold on
for i=1:size(data_sum_cs_non_cont_rest_beta,1)
    text(1,data_sum_cs_non_cont_rest_beta(i,1),cs_nonstim_sbj_num(i,:),'Color',cs_nonstim_color(i))
    text(2,data_sum_cs_non_cont_move_beta(i,1),cs_nonstim_sbj_num(i,:),'Color',cs_nonstim_color(i))
    text(4,data_sum_cs_non_cont_rest_beta(i,2),cs_nonstim_sbj_num(i,:),'Color',cs_nonstim_color(i))
    text(5,data_sum_cs_non_cont_move_beta(i,2),cs_nonstim_sbj_num(i,:),'Color',cs_nonstim_color(i))
    text(7,data_sum_cs_non_cont_rest_beta(i,3),cs_nonstim_sbj_num(i,:),'Color',cs_nonstim_color(i))
    text(8,data_sum_cs_non_cont_move_beta(i,3),cs_nonstim_sbj_num(i,:),'Color',cs_nonstim_color(i))
    text(10,data_sum_cs_non_cont_rest_beta(i,4),cs_nonstim_sbj_num(i,:),'Color',cs_nonstim_color(i))
    text(11,data_sum_cs_non_cont_move_beta(i,4),cs_nonstim_sbj_num(i,:),'Color',cs_nonstim_color(i))
end
title(['cs non cont beta whole (n=',num2str(size(data_sum_cs_non_cont_rest_beta,1)),')'])
set(gca,'XTick',[1.5 4.5 7.5 10.5],'XTickLabel',['Base ';'Early';'Late ';'Post '])

%% figure #2
figure
set(gcf,'Position',[924 196 802 1285])

subplot(8,2,1); hold on
bar(mean_data_sum_cs_stm_ipsi_rest_beta)
errorbar(mean_data_sum_cs_stm_ipsi_rest_beta,se_data_sum_cs_stm_ipsi_rest_beta,'.k')
title(['cs stim ipsi rest beta whole',' (',num2str(p_cs_stm_ipsi_rest_beta),')'])
ylabel('mean beta power')
set(gca,'XTick',[1:4],'XTickLabel',['BL';'ES';'LS';'PS'])
annotation('textbox',[0.5 0.96 0.14 0.02],'String',{'13 substituted 42,43 added nonnorm'},'FitBoxToText','on')

subplot(8,2,3); hold on
for i=1:size(data_sum_cs_stm_ipsi_rest_beta,1)
    plot(data_sum_cs_stm_ipsi_rest_beta(i,:),'-o','LineWidth',2,'MarkerSize',10)
end
ylabel('mean beta power')
set(gca,'xlim',[0 5],'XTick',[1:4],'XTickLabel',['BL';'ES';'LS';'PS'])
l1=legend('3','4','5','42','43');
l1p=get(l1,'Position')
set(l1,'Position',[l1p(1)+0.1*l1p(1) l1p(2) l1p(3) l1p(4)])

subplot(8,2,2); hold on
bar(mean_data_sum_cs_stm_ipsi_move_beta)
errorbar(mean_data_sum_cs_stm_ipsi_move_beta,se_data_sum_cs_stm_ipsi_move_beta,'.k')
title(['cs stim ipsi move beta whole',' (',num2str(p_cs_stm_ipsi_move_beta),')'])
ylabel('mean beta power')
set(gca,'XTick',[1 2 3 4],'XTickLabel',['BS';'ES';'LS';'PS'])

subplot(8,2,4)
hold on
for i=1:size(data_sum_cs_stm_ipsi_move_beta,1)
    plot(data_sum_cs_stm_ipsi_move_beta(i,:),'-o','LineWidth',2,'MarkerSize',10)
end
ylabel('mean beta power')
set(gca,'xlim',[0 5],'XTick',[1:4],'XTickLabel',['BL';'ES';'LS';'PS'])
l2=legend('3','4','5','42','43')
l2p=get(l2,'Position')
set(l2,'Position',[l2p(1)+0.1*l2p(1) l2p(2) l2p(3) l2p(4)])

subplot(8,2,5); hold on
bar(mean_data_sum_cs_stm_cont_rest_beta)
errorbar(mean_data_sum_cs_stm_cont_rest_beta,se_data_sum_cs_stm_cont_rest_beta,'.k')
title(['cs stim cont rest beta whole',' (',num2str(p_cs_stm_cont_rest_beta),')'])
ylabel('mean beta power')
set(gca,'XTick',[1:4],'XTickLabel',['BL';'ES';'LS';'PS'])

subplot(8,2,7); hold on
for i=1:size(data_sum_cs_stm_cont_rest_beta,1)
    plot(data_sum_cs_stm_cont_rest_beta(i,:),'-o','LineWidth',2,'MarkerSize',10)
end
ylabel('mean beta power')
set(gca,'xlim',[0 5],'XTick',[1:4],'XTickLabel',['BL';'ES';'LS';'PS'])
l3=legend('3','4','5','42','43')
l3p=get(l3,'Position')
set(l3,'Position',[l3p(1)+0.1*l3p(1) l3p(2) l3p(3) l3p(4)])

subplot(8,2,6); hold on
bar(mean_data_sum_cs_stm_cont_move_beta)
errorbar(mean_data_sum_cs_stm_cont_move_beta,se_data_sum_cs_stm_cont_move_beta,'.k')
title(['cs stim cont move beta whole',' (',num2str(p_cs_stm_cont_move_beta),')'])
ylabel('mean beta power')
set(gca,'XTick',[1 2 3 4],'XTickLabel',['BS';'ES';'LS';'PS'])

subplot(8,2,8)
hold on
for i=1:size(data_sum_cs_stm_cont_move_beta,1)
    plot(data_sum_cs_stm_cont_move_beta(i,:),'-o','LineWidth',2,'MarkerSize',10)
end
ylabel('mean beta power')
set(gca,'xlim',[0 5],'XTick',[1:4],'XTickLabel',['BL';'ES';'LS';'PS'])
l4=legend('3','4','5','42','43')
l4p=get(l4,'Position')
set(l4,'Position',[l4p(1)+0.1*l4p(1) l4p(2) l4p(3) l4p(4)])

subplot(8,2,9); hold on
bar(mean_data_sum_cs_non_ipsi_rest_beta)
errorbar(mean_data_sum_cs_non_ipsi_rest_beta,se_data_sum_cs_non_ipsi_rest_beta,'.k')
title(['cs non ipsi rest beta whole',' (',num2str(p_cs_non_ipsi_rest_beta),')'])
ylabel('mean beta power')
set(gca,'XTick',[1:4],'XTickLabel',['BL';'ES';'LS';'PS'])

subplot(8,2,11); hold on
for i=1:size(data_sum_cs_non_ipsi_rest_beta,1)
    plot(data_sum_cs_non_ipsi_rest_beta(i,:),'-x','LineWidth',2,'MarkerSize',10)
end
ylabel('mean beta power')
set(gca,'xlim',[0 5],'XTick',[1:4],'XTickLabel',['BL';'ES';'LS';'PS'])
l5=legend('13','15','17','18','21')
l5p=get(l5,'Position')
set(l5,'Position',[l5p(1)+0.1*l5p(1) l5p(2) l5p(3) l5p(4)])

subplot(8,2,10); hold on
bar(mean_data_sum_cs_non_ipsi_move_beta)
errorbar(mean_data_sum_cs_non_ipsi_move_beta,se_data_sum_cs_non_ipsi_move_beta,'.k')
title(['cs non ipsi move beta whole',' (',num2str(p_cs_non_ipsi_move_beta),')'])
ylabel('mean beta power')
set(gca,'XTick',[1 2 3 4],'XTickLabel',['BS';'ES';'LS';'PS'])

subplot(8,2,12)
hold on
for i=1:size(data_sum_cs_non_ipsi_move_beta,1)
    plot(data_sum_cs_non_ipsi_move_beta(i,:),'-x','LineWidth',2,'MarkerSize',10)
end
ylabel('mean beta power')
set(gca,'xlim',[0 5],'XTick',[1:4],'XTickLabel',['BL';'ES';'LS';'PS'])
l6=legend('13','15','17','18','21')
l6p=get(l6,'Position')
set(l6,'Position',[l6p(1)+0.1*l6p(1) l6p(2) l6p(3) l6p(4)])

subplot(8,2,13); hold on
bar(mean_data_sum_cs_non_cont_rest_beta)
errorbar(mean_data_sum_cs_non_cont_rest_beta,se_data_sum_cs_non_cont_rest_beta,'.k')
title(['cs non cont rest beta whole',' (',num2str(p_cs_non_cont_rest_beta),')'])
ylabel('mean beta power')
set(gca,'XTick',[1:4],'XTickLabel',['BL';'ES';'LS';'PS'])

subplot(8,2,15); hold on
for i=1:size(data_sum_cs_non_cont_rest_beta,1)
    plot(data_sum_cs_non_cont_rest_beta(i,:),'-x','LineWidth',2,'MarkerSize',10)
end
ylabel('mean beta power')
set(gca,'xlim',[0 5],'XTick',[1:4],'XTickLabel',['BL';'ES';'LS';'PS'])
l7=legend('13','15','17','18','21')
l7p=get(l7,'Position')
set(l7,'Position',[l7p(1)+0.1*l7p(1) l7p(2) l7p(3) l7p(4)])

subplot(8,2,14); hold on
bar(mean_data_sum_cs_non_cont_move_beta)
errorbar(mean_data_sum_cs_non_cont_move_beta,se_data_sum_cs_non_cont_move_beta,'.k')
title(['cs non cont move beta whole',' (',num2str(p_cs_non_cont_move_beta),')'])
ylabel('mean beta power')
set(gca,'XTick',[1 2 3 4],'XTickLabel',['BS';'ES';'LS';'PS'])

subplot(8,2,16)
hold on
for i=1:size(data_sum_cs_non_cont_move_beta,1)
    plot(data_sum_cs_non_cont_move_beta(i,:),'-x','LineWidth',2,'MarkerSize',10)
end
ylabel('mean beta power')
set(gca,'xlim',[0 5],'XTick',[1:4],'XTickLabel',['BL';'ES';'LS';'PS'])
l8=legend('13','15','17','18','21')
l8p=get(l8,'Position')
set(l8,'Position',[l8p(1)+0.1*l8p(1) l8p(2) l8p(3) l8p(4)])








