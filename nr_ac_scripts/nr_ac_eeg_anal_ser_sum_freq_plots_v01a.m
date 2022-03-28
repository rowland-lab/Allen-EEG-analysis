function nr_ac_eeg_anal_ser_sum_freq_plots_v01a(grp,freq_band,save_figs,save_data)

% sum fig using vrevents

%%%THIS CAN OBVIOUSLY BE OPTIMIZED BY MAKING A FOR LOOP FOR STM VS NON
%%%(AND IPSI VS CONTRA WITHIN EACH

%cs
sbjs_stm=['03';'04';'05';'42';'43'];
elec_stm_ipsi=[7,7,18,18,7];
elec_stm_cont=[18,18,7,7,18];
sbjs_non=['13';'15';'17';'18';'21'];
elec_non_ipsi=[18,7,18,18,18];
elec_non_cont=[7,18,7,7,7];
phase={'atStartPosition';'cueEvent';'targetUp'};

% %hc
% sbjs_stm=['22';'24';'25';'26';'29';'30'];
% elec_stm_ipsi=[18,7,7,7,7,18];
% elec_stm_cont=[7,18,18,18,18,7];
% sbjs_non=['20';'23';'27';'28';'36'];
% elec_non_ipsi=[7,18,7,7,7];
% elec_non_cont=[18,7,18,18,18];
% phase={'atStartPosition';'cueEvent';'targetUp'};

% figure; set(gcf,'Position',[3 47 744 898])
%     for i=1:4
%         subplot(8,5,i)
%         hold on
%         eval(['find_freq_plot_ch7_atStartPosition=find(epochs.vrevents.t',num2str(i),'.atStartPosition.psd.freq<=100)'])
%         for j=eval(['pro00087153_00',num2str(sbj_nums(n,:)),'_reaches_wo_outliers{out_ind_c7_p1(i)}'])
%         %for j=1:eval(['size(epochs.vrevents.t',num2str(i),'.atStartPosition.val,1)'])
%             eval(['plot(epochs.vrevents.t',num2str(i),'.atStartPosition.psd.freq(find_freq_plot_ch7_atStartPosition),log10(epochs.vrevents.t',num2str(i),'.atStartPosition.psd.saw(find_freq_plot_ch7_atStartPosition,7,j)))'])
%         end
%         ylimasp=get(gca,'ylim');
%         text(75,ylimasp(2)-0.1*ylimasp(2),num2str(eval(['size(pro00087153_00',num2str(sbj_nums(n,:)),'_reaches_wo_outliers{out_ind_c7_p1(i)},2)'])))
%         %text(75,ylimasp(2)-0.1*ylimasp(2),num2str(eval(['size(epochs.vrevents.t',num2str(i),'.atStartPosition.val,1)'])))
%         if i==1 & elec_stim_ipsi(n)==7
%             ylabel('atStartPosition')
%             title(['Sbj',m(1,:),':ch7:t',num2str(i)],'Color',[1 0 0])
%         elseif i==1 & elec_stim_ipsi(n)~=7
%             ylabel('atStartPosition')
%             title(['Sbj',m(1,:),':ch7:t',num2str(i)])
%         else
%             title(['t',num2str(i)])
%         end
%         eval(['ylim_',num2str(i),'=get(gca,''ylim'');'])
%     end

%stim ipsi
for i=1:4
    for j=1:3
        for k=1:size(sbjs_stm,1)
            load(['/home/rowlandn/nr_data_analysis/data_analyzed/eeg/gen_02/data/pro00087153_00',sbjs_stm(k,:),'/analysis/S3-EEGanalysis/s3_dat.mat'])
            eval(['find_freq_plot_sbj',num2str(sbjs_stm(k,:)),'_ch',num2str(elec_stm_ipsi(k)),'_t',num2str(i),'_p',num2str(j),...
                '=find(epochs.vrevents.t',num2str(i),'.',phase{j},'.psd.freq<=50);'])
            %HERE YOU ARE REPEATING A LOT OF WHAT YOU DID IN THE PREVIOUS
            %SCRIPT FOR PLOTTING PURPOSES BUT INSTEAD OF SELECTING ONLY CH7
            %OR CH18 YOU ARE CUSTOMIZING TO IPSI VS CONTRA FOR EACH SUBJECT
            eval(['psd_sbj',num2str(sbjs_stm(k,:)),'_ch',num2str(elec_stm_ipsi(k)),'_t',num2str(i),'_p',num2str(j),'_saw',...
                '=epochs.vrevents.t',num2str(i),'.',phase{j},'.psd.saw(find_freq_plot_sbj',num2str(sbjs_stm(k,:)),...
                '_ch',num2str(elec_stm_ipsi(k)),'_t',num2str(i),'_p',num2str(j),',',num2str(elec_stm_ipsi(k)),',:);'])
            eval(['psd_sbj',num2str(sbjs_stm(k,:)),'_ch',num2str(elec_stm_ipsi(k)),'_t',num2str(i),'_p',num2str(j),'_frq',...
                '=epochs.vrevents.t',num2str(i),'.',phase{j},'.psd.freq(find_freq_plot_sbj',num2str(sbjs_stm(k,:)),...
                '_ch',num2str(elec_stm_ipsi(k)),'_t',num2str(i),'_p',num2str(j),');'])
            eval(['psd_mean_sbj',num2str(sbjs_stm(k,:)),'_ch',num2str(elec_stm_ipsi(k)),'_t',num2str(i),'_p',num2str(j),'_saw',...
                '=mean(log10(psd_sbj',num2str(sbjs_stm(k,:)),'_ch',num2str(elec_stm_ipsi(k)),'_t',num2str(i),'_p',num2str(j),'_saw),3);'])
        clear Epochcompare epochs
        end
    end
end

for i=1:4
    for j=1:3
        for k=1:size(sbjs_stm,1)
            eval(['mean_mean_sum_beta_t',num2str(i),'_p',num2str(j),'_stm_ipsi(',num2str(k),')=mean_mean_beta_sbj',num2str(sbjs_stm(k,:)),...
                '_ch',num2str(elec_stm_ipsi(k)),'_t',num2str(i),'_p',num2str(j)])
        end
    end
end

for i=1:4
    for j=1:3
        eval(['mean_mean_mean_sum_beta_t',num2str(i),'_p',num2str(j),'_stm_ipsi=mean(mean_mean_sum_beta_t',num2str(i),'_p',num2str(j),'_stm_ipsi)'])
        eval(['se_mean_mean_sum_beta_t',num2str(i),'_p',num2str(j),'_stm_ipsi=std(mean_mean_sum_beta_t',num2str(i),'_p',num2str(j),...
            '_stm_ipsi)/sqrt(size(mean_mean_sum_beta_t',num2str(i),'_p',num2str(j),'_stm_ipsi,2))'])
    end
end

figure; set(gcf,'Position',[3 47 744 898]); hold on
count=0
for j=1:3
    for i=1:4
        count=count+1
        if j==1
            subplot(8,5,i); hold on
            sp=i;
        elseif j==2
            subplot(8,5,i+5); hold on
            sp=i+5;
        elseif j==3
            subplot(8,5,i+10); hold on
            sp=i+10;
        end
         
        for k=1:size(sbjs_stm,1)
            eval(['plot(psd_sbj',num2str(sbjs_stm(k,:)),'_ch',num2str(elec_stm_ipsi(k)),'_t',num2str(i),'_p',num2str(j),'_frq,',...
                'psd_mean_sbj',num2str(sbjs_stm(k,:)),'_ch',num2str(elec_stm_ipsi(k)),'_t',num2str(i),'_p',num2str(j),'_saw,''LineWidth'',2)'])
        end
        
        if sp<10
            eval(['ylim_0',num2str(sp),'=get(gca,''ylim'')'])
        elseif sp>=10
            eval(['ylim_',num2str(sp),'=get(gca,''ylim'')'])
        end
           
        if count==1
            ylabel('atStartPosition')
            title('SbjAll:ipsi stim:t1')
        elseif count==2
            title('t2')
        elseif count==3
            title('t3')
        elseif count==4
            title('t4')
        elseif count==5
            ylabel('cueEvent')
        elseif count==9
            ylabel('targetUp')
        elseif count==12
            l1=legend;
        end
    end
end
min_ylim=min([ylim_01(1) ylim_02(1) ylim_03(1) ylim_04(1) ylim_06(1) ylim_07(1) ylim_08(1) ylim_09(1) ylim_11(1) ylim_12(1) ylim_13(1) ylim_14(1)])
max_ylim=max([ylim_01(2) ylim_02(2) ylim_03(2) ylim_04(2) ylim_06(2) ylim_07(2) ylim_08(2) ylim_09(2) ylim_11(2) ylim_12(2) ylim_13(2) ylim_14(2)])
for i=[1 2 3 4 6 7 8 9 11 12 13 14]
    subplot(8,5,i)
    set(gca,'ylim',[0 max_ylim])
    plot([13 13],[0 max_ylim],'r')
    plot([30 30],[0 max_ylim],'r')
end
set(l1,'String',{'sbj03','sbj04','sbj05','sbj42','sbj43'},'Position',[0.7837 0.5323 0.1051 0.0797])

subplot(8,5,5); hold on
bar([mean_mean_mean_sum_beta_t1_p1_stm_ipsi mean_mean_mean_sum_beta_t2_p1_stm_ipsi mean_mean_mean_sum_beta_t3_p1_stm_ipsi mean_mean_mean_sum_beta_t4_p1_stm_ipsi])
errorbar([mean_mean_mean_sum_beta_t1_p1_stm_ipsi mean_mean_mean_sum_beta_t2_p1_stm_ipsi mean_mean_mean_sum_beta_t3_p1_stm_ipsi mean_mean_mean_sum_beta_t4_p1_stm_ipsi],...
    [se_mean_mean_sum_beta_t1_p1_stm_ipsi se_mean_mean_sum_beta_t2_p1_stm_ipsi se_mean_mean_sum_beta_t3_p1_stm_ipsi se_mean_mean_sum_beta_t4_p1_stm_ipsi],'.k')
set(gca,'XTick',[1:4],'XTickLabel',['t1';'t2';'t3';'t4'])
[p_mean_mean_sum_beta_p1,anovatab_mean_mean_sum_beta_p1,stats_mean_mean_sum_beta_p1]=...
    kruskalwallis([mean_mean_sum_beta_t1_p1_stm_ipsi',mean_mean_sum_beta_t2_p1_stm_ipsi',mean_mean_sum_beta_t3_p1_stm_ipsi',mean_mean_sum_beta_t4_p1_stm_ipsi'],[],'off')
if p_mean_mean_sum_beta_p1<=0.05
    title(num2str(p_mean_mean_sum_beta_p1),'Color',[1 0 0])
else
    title(num2str(p_mean_mean_sum_beta_p1))
end
nr_multcompare_ind_tdcs_plot(stats_mean_mean_sum_beta_p1,min_ylim)

subplot(8,5,10); hold on
bar([mean_mean_mean_sum_beta_t1_p2_stm_ipsi mean_mean_mean_sum_beta_t2_p2_stm_ipsi mean_mean_mean_sum_beta_t3_p2_stm_ipsi mean_mean_mean_sum_beta_t4_p2_stm_ipsi])
errorbar([mean_mean_mean_sum_beta_t1_p2_stm_ipsi mean_mean_mean_sum_beta_t2_p2_stm_ipsi mean_mean_mean_sum_beta_t3_p2_stm_ipsi mean_mean_mean_sum_beta_t4_p2_stm_ipsi],...
    [se_mean_mean_sum_beta_t1_p2_stm_ipsi se_mean_mean_sum_beta_t2_p2_stm_ipsi se_mean_mean_sum_beta_t3_p2_stm_ipsi se_mean_mean_sum_beta_t4_p2_stm_ipsi],'.k')
set(gca,'XTick',[1:4],'XTickLabel',['t1';'t2';'t3';'t4'])
[p_mean_mean_sum_beta_p2,anovatab_mean_mean_sum_beta_p2,stats_mean_mean_sum_beta_p2]=...
    kruskalwallis([mean_mean_sum_beta_t1_p2_stm_ipsi',mean_mean_sum_beta_t2_p2_stm_ipsi',mean_mean_sum_beta_t3_p2_stm_ipsi',mean_mean_sum_beta_t4_p2_stm_ipsi'],[],'off')
if p_mean_mean_sum_beta_p2<=0.05
    title(num2str(p_mean_mean_sum_beta_p2),'Color',[1 0 0])
else
    title(num2str(p_mean_mean_sum_beta_p2))
end
nr_multcompare_ind_tdcs_plot(stats_mean_mean_sum_beta_p2,min_ylim)

subplot(8,5,15); hold on
bar([mean_mean_mean_sum_beta_t1_p3_stm_ipsi mean_mean_mean_sum_beta_t2_p3_stm_ipsi mean_mean_mean_sum_beta_t3_p3_stm_ipsi mean_mean_mean_sum_beta_t4_p3_stm_ipsi])
errorbar([mean_mean_mean_sum_beta_t1_p3_stm_ipsi mean_mean_mean_sum_beta_t2_p3_stm_ipsi mean_mean_mean_sum_beta_t3_p3_stm_ipsi mean_mean_mean_sum_beta_t4_p3_stm_ipsi],...
    [se_mean_mean_sum_beta_t1_p3_stm_ipsi se_mean_mean_sum_beta_t2_p3_stm_ipsi se_mean_mean_sum_beta_t3_p3_stm_ipsi se_mean_mean_sum_beta_t4_p3_stm_ipsi],'.k')
set(gca,'XTick',[1:4],'XTickLabel',['t1';'t2';'t3';'t4'])
[p_mean_mean_sum_beta_p3,anovatab_mean_mean_sum_beta_p3,stats_mean_mean_sum_beta_p3]=...
    kruskalwallis([mean_mean_sum_beta_t1_p3_stm_ipsi',mean_mean_sum_beta_t2_p3_stm_ipsi',mean_mean_sum_beta_t3_p3_stm_ipsi',mean_mean_sum_beta_t4_p3_stm_ipsi'],[],'off')
if p_mean_mean_sum_beta_p3<=0.05
    title(num2str(p_mean_mean_sum_beta_p3),'Color',[1 0 0])
else
    title(num2str(p_mean_mean_sum_beta_p3))
end
nr_multcompare_ind_tdcs_plot(stats_mean_mean_sum_beta_p3,min_ylim)

subplot(8,5,16); hold on
bar([mean_mean_mean_sum_beta_t1_p1_stm_ipsi mean_mean_mean_sum_beta_t1_p2_stm_ipsi mean_mean_mean_sum_beta_t1_p3_stm_ipsi])
errorbar([mean_mean_mean_sum_beta_t1_p1_stm_ipsi mean_mean_mean_sum_beta_t1_p2_stm_ipsi mean_mean_mean_sum_beta_t1_p3_stm_ipsi],...
    [se_mean_mean_sum_beta_t1_p1_stm_ipsi se_mean_mean_sum_beta_t1_p2_stm_ipsi se_mean_mean_sum_beta_t1_p3_stm_ipsi],'.k')
set(gca,'XTick',[1:3],'XTickLabel',['h';'p';'m'])
[p_mean_mean_sum_beta_t1,anovatab_mean_mean_sum_beta_t1,stats_mean_mean_sum_beta_t1]=...
    kruskalwallis([mean_mean_sum_beta_t1_p1_stm_ipsi',mean_mean_sum_beta_t1_p2_stm_ipsi',mean_mean_sum_beta_t1_p3_stm_ipsi'],[],'off')
if p_mean_mean_sum_beta_t1<=0.05
    title(num2str(p_mean_mean_sum_beta_t1),'Color',[1 0 0])
else
    title(num2str(p_mean_mean_sum_beta_t1))
end
nr_multcompare_ind_tdcs_plot(stats_mean_mean_sum_beta_t1,0)

subplot(8,5,17); hold on
bar([mean_mean_mean_sum_beta_t2_p1_stm_ipsi mean_mean_mean_sum_beta_t2_p2_stm_ipsi mean_mean_mean_sum_beta_t2_p3_stm_ipsi])
errorbar([mean_mean_mean_sum_beta_t2_p1_stm_ipsi mean_mean_mean_sum_beta_t2_p2_stm_ipsi mean_mean_mean_sum_beta_t2_p3_stm_ipsi],...
    [se_mean_mean_sum_beta_t2_p1_stm_ipsi se_mean_mean_sum_beta_t2_p2_stm_ipsi se_mean_mean_sum_beta_t2_p3_stm_ipsi],'.k')
set(gca,'XTick',[1:3],'XTickLabel',['h';'p';'m'])
[p_mean_mean_sum_beta_t2,anovatab_mean_mean_sum_beta_t2,stats_mean_mean_sum_beta_t2]=...
    kruskalwallis([mean_mean_sum_beta_t2_p1_stm_ipsi',mean_mean_sum_beta_t2_p2_stm_ipsi',mean_mean_sum_beta_t2_p3_stm_ipsi'],[],'off')
if p_mean_mean_sum_beta_t2<=0.05
    title(num2str(p_mean_mean_sum_beta_t2),'Color',[1 0 0])
else
    title(num2str(p_mean_mean_sum_beta_t2))
end
nr_multcompare_ind_tdcs_plot(stats_mean_mean_sum_beta_t2,0)

subplot(8,5,18); hold on
bar([mean_mean_mean_sum_beta_t3_p1_stm_ipsi mean_mean_mean_sum_beta_t3_p2_stm_ipsi mean_mean_mean_sum_beta_t3_p3_stm_ipsi])
errorbar([mean_mean_mean_sum_beta_t3_p1_stm_ipsi mean_mean_mean_sum_beta_t3_p2_stm_ipsi mean_mean_mean_sum_beta_t3_p3_stm_ipsi],...
    [se_mean_mean_sum_beta_t3_p1_stm_ipsi se_mean_mean_sum_beta_t3_p2_stm_ipsi se_mean_mean_sum_beta_t3_p3_stm_ipsi],'.k')
set(gca,'XTick',[1:3],'XTickLabel',['h';'p';'m'])
[p_mean_mean_sum_beta_t3,anovatab_mean_mean_sum_beta_t3,stats_mean_mean_sum_beta_t3]=...
    kruskalwallis([mean_mean_sum_beta_t3_p1_stm_ipsi',mean_mean_sum_beta_t3_p2_stm_ipsi',mean_mean_sum_beta_t3_p3_stm_ipsi'],[],'off')
if p_mean_mean_sum_beta_t3<=0.05
    title(num2str(p_mean_mean_sum_beta_t3),'Color',[1 0 0])
else
    title(num2str(p_mean_mean_sum_beta_t3))
end
nr_multcompare_ind_tdcs_plot(stats_mean_mean_sum_beta_t3,0)

subplot(8,5,19); hold on
bar([mean_mean_mean_sum_beta_t4_p1_stm_ipsi mean_mean_mean_sum_beta_t4_p2_stm_ipsi mean_mean_mean_sum_beta_t4_p3_stm_ipsi])
errorbar([mean_mean_mean_sum_beta_t4_p1_stm_ipsi mean_mean_mean_sum_beta_t4_p2_stm_ipsi mean_mean_mean_sum_beta_t4_p3_stm_ipsi],...
    [se_mean_mean_sum_beta_t4_p1_stm_ipsi se_mean_mean_sum_beta_t4_p2_stm_ipsi se_mean_mean_sum_beta_t4_p3_stm_ipsi],'.k')
set(gca,'XTick',[1:3],'XTickLabel',['h';'p';'m'])
[p_mean_mean_sum_beta_t4,anovatab_mean_mean_sum_beta_t4,stats_mean_mean_sum_beta_t4]=...
    kruskalwallis([mean_mean_sum_beta_t4_p1_stm_ipsi',mean_mean_sum_beta_t4_p2_stm_ipsi',mean_mean_sum_beta_t4_p3_stm_ipsi'],[],'off')
if p_mean_mean_sum_beta_t4<=0.05
    title(num2str(p_mean_mean_sum_beta_t4),'Color',[1 0 0])
else
    title(num2str(p_mean_mean_sum_beta_t4))
end
nr_multcompare_ind_tdcs_plot(stats_mean_mean_sum_beta_t4,0)
%clear *ipsi


%stim cont
for i=1:4
    for j=1:3
        for k=1:size(sbjs_stm,1)
            load(['/home/rowlandn/nr_data_analysis/data_analyzed/eeg/gen_02/data/pro00087153_00',sbjs_stm(k,:),'/analysis/S3-EEGanalysis/s3_dat.mat'])
            eval(['find_freq_plot_sbj',num2str(sbjs_stm(k,:)),'_ch',num2str(elec_stm_cont(k)),'_t',num2str(i),'_p',num2str(j),...
                '=find(epochs.vrevents.t',num2str(i),'.',phase{j},'.psd.freq<=50);'])
            eval(['psd_sbj',num2str(sbjs_stm(k,:)),'_ch',num2str(elec_stm_cont(k)),'_t',num2str(i),'_p',num2str(j),'_saw',...
                '=epochs.vrevents.t',num2str(i),'.',phase{j},'.psd.saw(find_freq_plot_sbj',num2str(sbjs_stm(k,:)),...
                '_ch',num2str(elec_stm_cont(k)),'_t',num2str(i),'_p',num2str(j),',',num2str(elec_stm_cont(k)),',:);'])
            eval(['psd_sbj',num2str(sbjs_stm(k,:)),'_ch',num2str(elec_stm_cont(k)),'_t',num2str(i),'_p',num2str(j),'_frq',...
                '=epochs.vrevents.t',num2str(i),'.',phase{j},'.psd.freq(find_freq_plot_sbj',num2str(sbjs_stm(k,:)),...
                '_ch',num2str(elec_stm_cont(k)),'_t',num2str(i),'_p',num2str(j),');'])
            eval(['psd_mean_sbj',num2str(sbjs_stm(k,:)),'_ch',num2str(elec_stm_cont(k)),'_t',num2str(i),'_p',num2str(j),'_saw',...
                '=mean(log10(psd_sbj',num2str(sbjs_stm(k,:)),'_ch',num2str(elec_stm_cont(k)),'_t',num2str(i),'_p',num2str(j),'_saw),3);'])
        clear Epochcompare epochs
        end
    end
end

for i=1:4
    for j=1:3
        for k=1:size(sbjs_stm,1)
            eval(['mean_mean_sum_beta_t',num2str(i),'_p',num2str(j),'_stm_cont(',num2str(k),')=mean_mean_beta_sbj',num2str(sbjs_stm(k,:)),...
                '_ch',num2str(elec_stm_cont(k)),'_t',num2str(i),'_p',num2str(j)])
        end
    end
end

for i=1:4
    for j=1:3
        eval(['mean_mean_mean_sum_beta_t',num2str(i),'_p',num2str(j),'_stm_cont=mean(mean_mean_sum_beta_t',num2str(i),'_p',num2str(j),'_stm_cont)'])
        eval(['se_mean_mean_sum_beta_t',num2str(i),'_p',num2str(j),'_stm_cont=std(mean_mean_sum_beta_t',num2str(i),'_p',num2str(j),...
            '_stm_cont)/sqrt(size(mean_mean_sum_beta_t',num2str(i),'_p',num2str(j),'_stm_cont,2))'])
    end
end

count=20
for j=1:3
    for i=1:4
        count=count+1
        if j==1
            subplot(8,5,i+20); hold on
            sp=i+20;
        elseif j==2
            subplot(8,5,i+25); hold on
            sp=i+25;
        elseif j==3
            subplot(8,5,i+30); hold on
            sp=i+30;
        end
         
        for k=1:size(sbjs_stm,1)
            eval(['plot(psd_sbj',num2str(sbjs_stm(k,:)),'_ch',num2str(elec_stm_cont(k)),'_t',num2str(i),'_p',num2str(j),'_frq,',...
                'psd_mean_sbj',num2str(sbjs_stm(k,:)),'_ch',num2str(elec_stm_cont(k)),'_t',num2str(i),'_p',num2str(j),'_saw,''LineWidth'',2)'])
        end
        
        eval(['ylim_',num2str(sp),'=get(gca,''ylim'')'])
           
        if count==21
            ylabel('atStartPosition')
            title('cont stim:t1')
        elseif count==22
            title('t2')
        elseif count==23
            title('t3')
        elseif count==24
            title('t4')
        elseif count==25
            ylabel('cueEvent')
        elseif count==29
            ylabel('targetUp')
        elseif count==32
            l2=legend
        end
    end
end
min_ylim=max([ylim_21(1) ylim_22(1) ylim_23(1) ylim_24(1) ylim_26(1) ylim_27(1) ylim_28(1) ylim_29(1) ylim_31(1) ylim_32(1) ylim_33(1) ylim_34(1)])
max_ylim=max([ylim_21(2) ylim_22(2) ylim_23(2) ylim_24(2) ylim_26(2) ylim_27(2) ylim_28(2) ylim_29(2) ylim_31(2) ylim_32(2) ylim_33(2) ylim_34(2)])
for i=[21 22 23 24 26 27 28 29 31 32 33 34]
    subplot(8,5,i)
    set(gca,'ylim',[0 max_ylim])
    plot([13 13],[0 max_ylim],'r')
    plot([30 30],[0 max_ylim],'r')
end
set(l2,'String',{'sbj03','sbj04','sbj05','sbj42','sbj43'},'Position',[0.7837 0.1033 0.1051 0.0803])

subplot(8,5,25); hold on
bar([mean_mean_mean_sum_beta_t1_p1_stm_cont mean_mean_mean_sum_beta_t2_p1_stm_cont mean_mean_mean_sum_beta_t3_p1_stm_cont mean_mean_mean_sum_beta_t4_p1_stm_cont])
errorbar([mean_mean_mean_sum_beta_t1_p1_stm_cont mean_mean_mean_sum_beta_t2_p1_stm_cont mean_mean_mean_sum_beta_t3_p1_stm_cont mean_mean_mean_sum_beta_t4_p1_stm_cont],...
    [se_mean_mean_sum_beta_t1_p1_stm_cont se_mean_mean_sum_beta_t2_p1_stm_cont se_mean_mean_sum_beta_t3_p1_stm_cont se_mean_mean_sum_beta_t4_p1_stm_cont],'.k')
set(gca,'XTick',[1:4],'XTickLabel',['t1';'t2';'t3';'t4'])
[p_mean_mean_sum_beta_p1,anovatab_mean_mean_sum_beta_p1,stats_mean_mean_sum_beta_p1]=...
    kruskalwallis([mean_mean_sum_beta_t1_p1_stm_cont',mean_mean_sum_beta_t2_p1_stm_cont',mean_mean_sum_beta_t3_p1_stm_cont',mean_mean_sum_beta_t4_p1_stm_cont'],[],'off')
if p_mean_mean_sum_beta_p1<=0.05
    title(num2str(p_mean_mean_sum_beta_p1),'Color',[1 0 0])
else
    title(num2str(p_mean_mean_sum_beta_p1))
end
nr_multcompare_ind_tdcs_plot(stats_mean_mean_sum_beta_p1,min_ylim)

subplot(8,5,30); hold on
bar([mean_mean_mean_sum_beta_t1_p2_stm_cont mean_mean_mean_sum_beta_t2_p2_stm_cont mean_mean_mean_sum_beta_t3_p2_stm_cont mean_mean_mean_sum_beta_t4_p2_stm_cont])
errorbar([mean_mean_mean_sum_beta_t1_p2_stm_cont mean_mean_mean_sum_beta_t2_p2_stm_cont mean_mean_mean_sum_beta_t3_p2_stm_cont mean_mean_mean_sum_beta_t4_p2_stm_cont],...
    [se_mean_mean_sum_beta_t1_p2_stm_cont se_mean_mean_sum_beta_t2_p2_stm_cont se_mean_mean_sum_beta_t3_p2_stm_cont se_mean_mean_sum_beta_t4_p2_stm_cont],'.k')
set(gca,'XTick',[1:4],'XTickLabel',['t1';'t2';'t3';'t4'])
[p_mean_mean_sum_beta_p2,anovatab_mean_mean_sum_beta_p2,stats_mean_mean_sum_beta_p2]=...
    kruskalwallis([mean_mean_sum_beta_t1_p2_stm_cont',mean_mean_sum_beta_t2_p2_stm_cont',mean_mean_sum_beta_t3_p2_stm_cont',mean_mean_sum_beta_t4_p2_stm_cont'],[],'off')
if p_mean_mean_sum_beta_p2<=0.05
    title(num2str(p_mean_mean_sum_beta_p2),'Color',[1 0 0])
else
    title(num2str(p_mean_mean_sum_beta_p2))
end
nr_multcompare_ind_tdcs_plot(stats_mean_mean_sum_beta_p2,min_ylim)

subplot(8,5,35); hold on
bar([mean_mean_mean_sum_beta_t1_p3_stm_cont mean_mean_mean_sum_beta_t2_p3_stm_cont mean_mean_mean_sum_beta_t3_p3_stm_cont mean_mean_mean_sum_beta_t4_p3_stm_cont])
errorbar([mean_mean_mean_sum_beta_t1_p3_stm_cont mean_mean_mean_sum_beta_t2_p3_stm_cont mean_mean_mean_sum_beta_t3_p3_stm_cont mean_mean_mean_sum_beta_t4_p3_stm_cont],...
    [se_mean_mean_sum_beta_t1_p3_stm_cont se_mean_mean_sum_beta_t2_p3_stm_cont se_mean_mean_sum_beta_t3_p3_stm_cont se_mean_mean_sum_beta_t4_p3_stm_cont],'.k')
set(gca,'XTick',[1:4],'XTickLabel',['t1';'t2';'t3';'t4'])
[p_mean_mean_sum_beta_p3,anovatab_mean_mean_sum_beta_p3,stats_mean_mean_sum_beta_p3]=...
    kruskalwallis([mean_mean_sum_beta_t1_p3_stm_cont',mean_mean_sum_beta_t2_p3_stm_cont',mean_mean_sum_beta_t3_p3_stm_cont',mean_mean_sum_beta_t4_p3_stm_cont'],[],'off')
if p_mean_mean_sum_beta_p3<=0.05
    title(num2str(p_mean_mean_sum_beta_p3),'Color',[1 0 0])
else
    title(num2str(p_mean_mean_sum_beta_p3))
end
nr_multcompare_ind_tdcs_plot(stats_mean_mean_sum_beta_p3,min_ylim)

subplot(8,5,36); hold on
bar([mean_mean_mean_sum_beta_t1_p1_stm_cont mean_mean_mean_sum_beta_t1_p2_stm_cont mean_mean_mean_sum_beta_t1_p3_stm_cont])
errorbar([mean_mean_mean_sum_beta_t1_p1_stm_cont mean_mean_mean_sum_beta_t1_p2_stm_cont mean_mean_mean_sum_beta_t1_p3_stm_cont],...
    [se_mean_mean_sum_beta_t1_p1_stm_cont se_mean_mean_sum_beta_t1_p2_stm_cont se_mean_mean_sum_beta_t1_p3_stm_cont],'.k')
set(gca,'XTick',[1:3],'XTickLabel',['h';'p';'m'])
[p_mean_mean_sum_beta_t1,anovatab_mean_mean_sum_beta_t1,stats_mean_mean_sum_beta_t1]=...
    kruskalwallis([mean_mean_sum_beta_t1_p1_stm_cont',mean_mean_sum_beta_t1_p2_stm_cont',mean_mean_sum_beta_t1_p3_stm_cont'],[],'off')
if p_mean_mean_sum_beta_t1<=0.05
    title(num2str(p_mean_mean_sum_beta_t1),'Color',[1 0 0])
else
    title(num2str(p_mean_mean_sum_beta_t1))
end
nr_multcompare_ind_tdcs_plot(stats_mean_mean_sum_beta_t1,0)

subplot(8,5,37); hold on
bar([mean_mean_mean_sum_beta_t2_p1_stm_cont mean_mean_mean_sum_beta_t2_p2_stm_cont mean_mean_mean_sum_beta_t2_p3_stm_cont])
errorbar([mean_mean_mean_sum_beta_t2_p1_stm_cont mean_mean_mean_sum_beta_t2_p2_stm_cont mean_mean_mean_sum_beta_t2_p3_stm_cont],...
    [se_mean_mean_sum_beta_t2_p1_stm_cont se_mean_mean_sum_beta_t2_p2_stm_cont se_mean_mean_sum_beta_t2_p3_stm_cont],'.k')
set(gca,'XTick',[1:3],'XTickLabel',['h';'p';'m'])
[p_mean_mean_sum_beta_t2,anovatab_mean_mean_sum_beta_t2,stats_mean_mean_sum_beta_t2]=...
    kruskalwallis([mean_mean_sum_beta_t2_p1_stm_cont',mean_mean_sum_beta_t2_p2_stm_cont',mean_mean_sum_beta_t2_p3_stm_cont'],[],'off')
if p_mean_mean_sum_beta_t2<=0.05
    title(num2str(p_mean_mean_sum_beta_t2),'Color',[1 0 0])
else
    title(num2str(p_mean_mean_sum_beta_t2))
end
nr_multcompare_ind_tdcs_plot(stats_mean_mean_sum_beta_t2,0)

subplot(8,5,38); hold on
bar([mean_mean_mean_sum_beta_t3_p1_stm_cont mean_mean_mean_sum_beta_t3_p2_stm_cont mean_mean_mean_sum_beta_t3_p3_stm_cont])
errorbar([mean_mean_mean_sum_beta_t3_p1_stm_cont mean_mean_mean_sum_beta_t3_p2_stm_cont mean_mean_mean_sum_beta_t3_p3_stm_cont],...
    [se_mean_mean_sum_beta_t3_p1_stm_cont se_mean_mean_sum_beta_t3_p2_stm_cont se_mean_mean_sum_beta_t3_p3_stm_cont],'.k')
set(gca,'XTick',[1:3],'XTickLabel',['h';'p';'m'])
[p_mean_mean_sum_beta_t3,anovatab_mean_mean_sum_beta_t3,stats_mean_mean_sum_beta_t3]=...
    kruskalwallis([mean_mean_sum_beta_t3_p1_stm_cont',mean_mean_sum_beta_t3_p2_stm_cont',mean_mean_sum_beta_t3_p3_stm_cont'],[],'off')
if p_mean_mean_sum_beta_t3<=0.05
    title(num2str(p_mean_mean_sum_beta_t3),'Color',[1 0 0])
else
    title(num2str(p_mean_mean_sum_beta_t3))
end
nr_multcompare_ind_tdcs_plot(stats_mean_mean_sum_beta_t3,0)

subplot(8,5,39); hold on
bar([mean_mean_mean_sum_beta_t4_p1_stm_cont mean_mean_mean_sum_beta_t4_p2_stm_cont mean_mean_mean_sum_beta_t4_p3_stm_cont])
errorbar([mean_mean_mean_sum_beta_t4_p1_stm_cont mean_mean_mean_sum_beta_t4_p2_stm_cont mean_mean_mean_sum_beta_t4_p3_stm_cont],...
    [se_mean_mean_sum_beta_t4_p1_stm_cont se_mean_mean_sum_beta_t4_p2_stm_cont se_mean_mean_sum_beta_t4_p3_stm_cont],'.k')
set(gca,'XTick',[1:3],'XTickLabel',['h';'p';'m'])
[p_mean_mean_sum_beta_t4,anovatab_mean_mean_sum_beta_t4,stats_mean_mean_sum_beta_t4]=...
    kruskalwallis([mean_mean_sum_beta_t4_p1_stm_cont',mean_mean_sum_beta_t4_p2_stm_cont',mean_mean_sum_beta_t4_p3_stm_cont'],[],'off')
if p_mean_mean_sum_beta_t4<=0.05
    title(num2str(p_mean_mean_sum_beta_t4),'Color',[1 0 0])
else
    title(num2str(p_mean_mean_sum_beta_t4))
end
nr_multcompare_ind_tdcs_plot(stats_mean_mean_sum_beta_t4,0)

%non ipsi
for i=1:4
    for j=1:3
        for k=1:size(sbjs_non,1)
            load(['/home/rowlandn/nr_data_analysis/data_analyzed/eeg/gen_02/data/pro00087153_00',sbjs_non(k,:),'/analysis/S3-EEGanalysis/s3_dat.mat'])
            eval(['find_freq_plot_sbj',num2str(sbjs_non(k,:)),'_ch',num2str(elec_non_ipsi(k)),'_t',num2str(i),'_p',num2str(j),...
                '=find(epochs.vrevents.t',num2str(i),'.',phase{j},'.psd.freq<=50);'])
            eval(['psd_sbj',num2str(sbjs_non(k,:)),'_ch',num2str(elec_non_ipsi(k)),'_t',num2str(i),'_p',num2str(j),'_saw',...
                '=epochs.vrevents.t',num2str(i),'.',phase{j},'.psd.saw(find_freq_plot_sbj',num2str(sbjs_non(k,:)),...
                '_ch',num2str(elec_non_ipsi(k)),'_t',num2str(i),'_p',num2str(j),',',num2str(elec_non_ipsi(k)),',:);'])
            eval(['psd_sbj',num2str(sbjs_non(k,:)),'_ch',num2str(elec_non_ipsi(k)),'_t',num2str(i),'_p',num2str(j),'_frq',...
                '=epochs.vrevents.t',num2str(i),'.',phase{j},'.psd.freq(find_freq_plot_sbj',num2str(sbjs_non(k,:)),...
                '_ch',num2str(elec_non_ipsi(k)),'_t',num2str(i),'_p',num2str(j),');'])
            eval(['psd_mean_sbj',num2str(sbjs_non(k,:)),'_ch',num2str(elec_non_ipsi(k)),'_t',num2str(i),'_p',num2str(j),'_saw',...
                '=mean(log10(psd_sbj',num2str(sbjs_non(k,:)),'_ch',num2str(elec_non_ipsi(k)),'_t',num2str(i),'_p',num2str(j),'_saw),3);'])
        clear Epochcompare epochs
        end
    end
end

for i=1:4
    for j=1:3
        for k=1:size(sbjs_non,1)
            eval(['mean_mean_sum_beta_t',num2str(i),'_p',num2str(j),'_non_ipsi(',num2str(k),')=mean_mean_beta_sbj',num2str(sbjs_non(k,:)),...
                '_ch',num2str(elec_non_ipsi(k)),'_t',num2str(i),'_p',num2str(j)])
        end
    end
end

for i=1:4
    for j=1:3
        eval(['mean_mean_mean_sum_beta_t',num2str(i),'_p',num2str(j),'_non_ipsi=mean(mean_mean_sum_beta_t',num2str(i),'_p',num2str(j),'_non_ipsi)'])
        eval(['se_mean_mean_sum_beta_t',num2str(i),'_p',num2str(j),'_non_ipsi=std(mean_mean_sum_beta_t',num2str(i),'_p',num2str(j),...
            '_non_ipsi)/sqrt(size(mean_mean_sum_beta_t',num2str(i),'_p',num2str(j),'_non_ipsi,2))'])
    end
end

figure; set(gcf,'Position',[3 47 744 898]); hold on
count=0
for j=1:3
    for i=1:4
        count=count+1
        if j==1
            subplot(8,5,i); hold on
            sp=i;
        elseif j==2
            subplot(8,5,i+5); hold on
            sp=i+5;
        elseif j==3
            subplot(8,5,i+10); hold on
            sp=i+10;
        end
         
        for k=1:size(sbjs_non,1)
            eval(['plot(psd_sbj',num2str(sbjs_non(k,:)),'_ch',num2str(elec_non_ipsi(k)),'_t',num2str(i),'_p',num2str(j),'_frq,',...
                'psd_mean_sbj',num2str(sbjs_non(k,:)),'_ch',num2str(elec_non_ipsi(k)),'_t',num2str(i),'_p',num2str(j),'_saw,''LineWidth'',2)'])
        end
        
        if sp<10
            eval(['ylim_0',num2str(sp),'=get(gca,''ylim'')'])
        elseif sp>=10
            eval(['ylim_',num2str(sp),'=get(gca,''ylim'')'])
        end
           
        if count==1
            ylabel('atStartPosition')
            title('SbjAll:ipsi non:t1')
        elseif count==2
            title('t2')
        elseif count==3
            title('t3')
        elseif count==4
            title('t4')
        elseif count==5
            ylabel('cueEvent')
        elseif count==9
            ylabel('targetUp')
        elseif count==12
            l1=legend;
        end
    end
end
min_ylim=min([ylim_01(1) ylim_02(1) ylim_03(1) ylim_04(1) ylim_06(1) ylim_07(1) ylim_08(1) ylim_09(1) ylim_11(1) ylim_12(1) ylim_13(1) ylim_14(1)])
max_ylim=max([ylim_01(2) ylim_02(2) ylim_03(2) ylim_04(2) ylim_06(2) ylim_07(2) ylim_08(2) ylim_09(2) ylim_11(2) ylim_12(2) ylim_13(2) ylim_14(2)])
for i=[1 2 3 4 6 7 8 9 11 12 13 14]
    subplot(8,5,i)
    set(gca,'ylim',[0 max_ylim])
    plot([13 13],[0 max_ylim],'r')
    plot([30 30],[0 max_ylim],'r')
end
set(l1,'String',{'sbj13','sbj15','sbj17','sbj18','sbj21'},'Position',[0.7837 0.5323 0.1051 0.0797])

subplot(8,5,5); hold on
bar([mean_mean_mean_sum_beta_t1_p1_non_ipsi mean_mean_mean_sum_beta_t2_p1_non_ipsi mean_mean_mean_sum_beta_t3_p1_non_ipsi mean_mean_mean_sum_beta_t4_p1_non_ipsi])
errorbar([mean_mean_mean_sum_beta_t1_p1_non_ipsi mean_mean_mean_sum_beta_t2_p1_non_ipsi mean_mean_mean_sum_beta_t3_p1_non_ipsi mean_mean_mean_sum_beta_t4_p1_non_ipsi],...
    [se_mean_mean_sum_beta_t1_p1_non_ipsi se_mean_mean_sum_beta_t2_p1_non_ipsi se_mean_mean_sum_beta_t3_p1_non_ipsi se_mean_mean_sum_beta_t4_p1_non_ipsi],'.k')
set(gca,'XTick',[1:4],'XTickLabel',['t1';'t2';'t3';'t4'])
[p_mean_mean_sum_beta_p1,anovatab_mean_mean_sum_beta_p1,stats_mean_mean_sum_beta_p1]=...
    kruskalwallis([mean_mean_sum_beta_t1_p1_non_ipsi',mean_mean_sum_beta_t2_p1_non_ipsi',mean_mean_sum_beta_t3_p1_non_ipsi',mean_mean_sum_beta_t4_p1_non_ipsi'],[],'off')
if p_mean_mean_sum_beta_p1<=0.05
    title(num2str(p_mean_mean_sum_beta_p1),'Color',[1 0 0])
else
    title(num2str(p_mean_mean_sum_beta_p1))
end
nr_multcompare_ind_tdcs_plot(stats_mean_mean_sum_beta_p1,min_ylim)

subplot(8,5,10); hold on
bar([mean_mean_mean_sum_beta_t1_p2_non_ipsi mean_mean_mean_sum_beta_t2_p2_non_ipsi mean_mean_mean_sum_beta_t3_p2_non_ipsi mean_mean_mean_sum_beta_t4_p2_non_ipsi])
errorbar([mean_mean_mean_sum_beta_t1_p2_non_ipsi mean_mean_mean_sum_beta_t2_p2_non_ipsi mean_mean_mean_sum_beta_t3_p2_non_ipsi mean_mean_mean_sum_beta_t4_p2_non_ipsi],...
    [se_mean_mean_sum_beta_t1_p2_non_ipsi se_mean_mean_sum_beta_t2_p2_non_ipsi se_mean_mean_sum_beta_t3_p2_non_ipsi se_mean_mean_sum_beta_t4_p2_non_ipsi],'.k')
set(gca,'XTick',[1:4],'XTickLabel',['t1';'t2';'t3';'t4'])
[p_mean_mean_sum_beta_p2,anovatab_mean_mean_sum_beta_p2,stats_mean_mean_sum_beta_p2]=...
    kruskalwallis([mean_mean_sum_beta_t1_p2_non_ipsi',mean_mean_sum_beta_t2_p2_non_ipsi',mean_mean_sum_beta_t3_p2_non_ipsi',mean_mean_sum_beta_t4_p2_non_ipsi'],[],'off')
if p_mean_mean_sum_beta_p2<=0.05
    title(num2str(p_mean_mean_sum_beta_p2),'Color',[1 0 0])
else
    title(num2str(p_mean_mean_sum_beta_p2))
end
nr_multcompare_ind_tdcs_plot(stats_mean_mean_sum_beta_p2,min_ylim)

subplot(8,5,15); hold on
bar([mean_mean_mean_sum_beta_t1_p3_non_ipsi mean_mean_mean_sum_beta_t2_p3_non_ipsi mean_mean_mean_sum_beta_t3_p3_non_ipsi mean_mean_mean_sum_beta_t4_p3_non_ipsi])
errorbar([mean_mean_mean_sum_beta_t1_p3_non_ipsi mean_mean_mean_sum_beta_t2_p3_non_ipsi mean_mean_mean_sum_beta_t3_p3_non_ipsi mean_mean_mean_sum_beta_t4_p3_non_ipsi],...
    [se_mean_mean_sum_beta_t1_p3_non_ipsi se_mean_mean_sum_beta_t2_p3_non_ipsi se_mean_mean_sum_beta_t3_p3_non_ipsi se_mean_mean_sum_beta_t4_p3_non_ipsi],'.k')
set(gca,'XTick',[1:4],'XTickLabel',['t1';'t2';'t3';'t4'])
[p_mean_mean_sum_beta_p3,anovatab_mean_mean_sum_beta_p3,stats_mean_mean_sum_beta_p3]=...
    kruskalwallis([mean_mean_sum_beta_t1_p3_non_ipsi',mean_mean_sum_beta_t2_p3_non_ipsi',mean_mean_sum_beta_t3_p3_non_ipsi',mean_mean_sum_beta_t4_p3_non_ipsi'],[],'off')
if p_mean_mean_sum_beta_p3<=0.05
    title(num2str(p_mean_mean_sum_beta_p3),'Color',[1 0 0])
else
    title(num2str(p_mean_mean_sum_beta_p3))
end
nr_multcompare_ind_tdcs_plot(stats_mean_mean_sum_beta_p3,min_ylim)

subplot(8,5,16); hold on
bar([mean_mean_mean_sum_beta_t1_p1_non_ipsi mean_mean_mean_sum_beta_t1_p2_non_ipsi mean_mean_mean_sum_beta_t1_p3_non_ipsi])
errorbar([mean_mean_mean_sum_beta_t1_p1_non_ipsi mean_mean_mean_sum_beta_t1_p2_non_ipsi mean_mean_mean_sum_beta_t1_p3_non_ipsi],...
    [se_mean_mean_sum_beta_t1_p1_non_ipsi se_mean_mean_sum_beta_t1_p2_non_ipsi se_mean_mean_sum_beta_t1_p3_non_ipsi],'.k')
set(gca,'XTick',[1:3],'XTickLabel',['h';'p';'m'])
[p_mean_mean_sum_beta_t1,anovatab_mean_mean_sum_beta_t1,stats_mean_mean_sum_beta_t1]=...
    kruskalwallis([mean_mean_sum_beta_t1_p1_non_ipsi',mean_mean_sum_beta_t1_p2_non_ipsi',mean_mean_sum_beta_t1_p3_non_ipsi'],[],'off')
if p_mean_mean_sum_beta_t1<=0.05
    title(num2str(p_mean_mean_sum_beta_t1),'Color',[1 0 0])
else
    title(num2str(p_mean_mean_sum_beta_t1))
end
nr_multcompare_ind_tdcs_plot(stats_mean_mean_sum_beta_t1,0)

subplot(8,5,17); hold on
bar([mean_mean_mean_sum_beta_t2_p1_non_ipsi mean_mean_mean_sum_beta_t2_p2_non_ipsi mean_mean_mean_sum_beta_t2_p3_non_ipsi])
errorbar([mean_mean_mean_sum_beta_t2_p1_non_ipsi mean_mean_mean_sum_beta_t2_p2_non_ipsi mean_mean_mean_sum_beta_t2_p3_non_ipsi],...
    [se_mean_mean_sum_beta_t2_p1_non_ipsi se_mean_mean_sum_beta_t2_p2_non_ipsi se_mean_mean_sum_beta_t2_p3_non_ipsi],'.k')
set(gca,'XTick',[1:3],'XTickLabel',['h';'p';'m'])
[p_mean_mean_sum_beta_t2,anovatab_mean_mean_sum_beta_t2,stats_mean_mean_sum_beta_t2]=...
    kruskalwallis([mean_mean_sum_beta_t2_p1_non_ipsi',mean_mean_sum_beta_t2_p2_non_ipsi',mean_mean_sum_beta_t2_p3_non_ipsi'],[],'off')
if p_mean_mean_sum_beta_t2<=0.05
    title(num2str(p_mean_mean_sum_beta_t2),'Color',[1 0 0])
else
    title(num2str(p_mean_mean_sum_beta_t2))
end
nr_multcompare_ind_tdcs_plot(stats_mean_mean_sum_beta_t2,0)

subplot(8,5,18); hold on
bar([mean_mean_mean_sum_beta_t3_p1_non_ipsi mean_mean_mean_sum_beta_t3_p2_non_ipsi mean_mean_mean_sum_beta_t3_p3_non_ipsi])
errorbar([mean_mean_mean_sum_beta_t3_p1_non_ipsi mean_mean_mean_sum_beta_t3_p2_non_ipsi mean_mean_mean_sum_beta_t3_p3_non_ipsi],...
    [se_mean_mean_sum_beta_t3_p1_non_ipsi se_mean_mean_sum_beta_t3_p2_non_ipsi se_mean_mean_sum_beta_t3_p3_non_ipsi],'.k')
set(gca,'XTick',[1:3],'XTickLabel',['h';'p';'m'])
[p_mean_mean_sum_beta_t3,anovatab_mean_mean_sum_beta_t3,stats_mean_mean_sum_beta_t3]=...
    kruskalwallis([mean_mean_sum_beta_t3_p1_non_ipsi',mean_mean_sum_beta_t3_p2_non_ipsi',mean_mean_sum_beta_t3_p3_non_ipsi'],[],'off')
if p_mean_mean_sum_beta_t3<=0.05
    title(num2str(p_mean_mean_sum_beta_t3),'Color',[1 0 0])
else
    title(num2str(p_mean_mean_sum_beta_t3))
end
nr_multcompare_ind_tdcs_plot(stats_mean_mean_sum_beta_t3,0)

subplot(8,5,19); hold on
bar([mean_mean_mean_sum_beta_t4_p1_non_ipsi mean_mean_mean_sum_beta_t4_p2_non_ipsi mean_mean_mean_sum_beta_t4_p3_non_ipsi])
errorbar([mean_mean_mean_sum_beta_t4_p1_non_ipsi mean_mean_mean_sum_beta_t4_p2_non_ipsi mean_mean_mean_sum_beta_t4_p3_non_ipsi],...
    [se_mean_mean_sum_beta_t4_p1_non_ipsi se_mean_mean_sum_beta_t4_p2_non_ipsi se_mean_mean_sum_beta_t4_p3_non_ipsi],'.k')
set(gca,'XTick',[1:3],'XTickLabel',['h';'p';'m'])
[p_mean_mean_sum_beta_t4,anovatab_mean_mean_sum_beta_t4,stats_mean_mean_sum_beta_t4]=...
    kruskalwallis([mean_mean_sum_beta_t4_p1_non_ipsi',mean_mean_sum_beta_t4_p2_non_ipsi',mean_mean_sum_beta_t4_p3_non_ipsi'],[],'off')
if p_mean_mean_sum_beta_t4<=0.05
    title(num2str(p_mean_mean_sum_beta_t4),'Color',[1 0 0])
else
    title(num2str(p_mean_mean_sum_beta_t4))
end
nr_multcompare_ind_tdcs_plot(stats_mean_mean_sum_beta_t4,0)

%clear *ipsi

%non cont
for i=1:4
    for j=1:3
        for k=1:size(sbjs_non,1)
            load(['/home/rowlandn/nr_data_analysis/data_analyzed/eeg/gen_02/data/pro00087153_00',sbjs_non(k,:),'/analysis/S3-EEGanalysis/s3_dat.mat'])
            eval(['find_freq_plot_sbj',num2str(sbjs_non(k,:)),'_ch',num2str(elec_non_cont(k)),'_t',num2str(i),'_p',num2str(j),...
                '=find(epochs.vrevents.t',num2str(i),'.',phase{j},'.psd.freq<=50);'])
            eval(['psd_sbj',num2str(sbjs_non(k,:)),'_ch',num2str(elec_non_cont(k)),'_t',num2str(i),'_p',num2str(j),'_saw',...
                '=epochs.vrevents.t',num2str(i),'.',phase{j},'.psd.saw(find_freq_plot_sbj',num2str(sbjs_non(k,:)),...
                '_ch',num2str(elec_non_cont(k)),'_t',num2str(i),'_p',num2str(j),',',num2str(elec_non_cont(k)),',:);'])
            eval(['psd_sbj',num2str(sbjs_non(k,:)),'_ch',num2str(elec_non_cont(k)),'_t',num2str(i),'_p',num2str(j),'_frq',...
                '=epochs.vrevents.t',num2str(i),'.',phase{j},'.psd.freq(find_freq_plot_sbj',num2str(sbjs_non(k,:)),...
                '_ch',num2str(elec_non_cont(k)),'_t',num2str(i),'_p',num2str(j),');'])
            eval(['psd_mean_sbj',num2str(sbjs_non(k,:)),'_ch',num2str(elec_non_cont(k)),'_t',num2str(i),'_p',num2str(j),'_saw',...
                '=mean(log10(psd_sbj',num2str(sbjs_non(k,:)),'_ch',num2str(elec_non_cont(k)),'_t',num2str(i),'_p',num2str(j),'_saw),3);'])
        clear Epochcompare epochs
        end
    end
end

for i=1:4
    for j=1:3
        for k=1:size(sbjs_non,1)
            eval(['mean_mean_sum_beta_t',num2str(i),'_p',num2str(j),'_non_cont(',num2str(k),')=mean_mean_beta_sbj',num2str(sbjs_non(k,:)),...
                '_ch',num2str(elec_non_cont(k)),'_t',num2str(i),'_p',num2str(j)])
        end
    end
end

for i=1:4
    for j=1:3
        eval(['mean_mean_mean_sum_beta_t',num2str(i),'_p',num2str(j),'_non_cont=mean(mean_mean_sum_beta_t',num2str(i),'_p',num2str(j),'_non_cont)'])
        eval(['se_mean_mean_sum_beta_t',num2str(i),'_p',num2str(j),'_non_cont=std(mean_mean_sum_beta_t',num2str(i),'_p',num2str(j),...
            '_non_cont)/sqrt(size(mean_mean_sum_beta_t',num2str(i),'_p',num2str(j),'_non_cont,2))'])
    end
end


count=20
for j=1:3
    for i=1:4
        count=count+1
        if j==1
            subplot(8,5,i+20); hold on
            sp=i+20;
        elseif j==2
            subplot(8,5,i+25); hold on
            sp=i+25;
        elseif j==3
            subplot(8,5,i+30); hold on
            sp=i+30;
        end
         
        for k=1:size(sbjs_non,1)
            eval(['plot(psd_sbj',num2str(sbjs_non(k,:)),'_ch',num2str(elec_non_cont(k)),'_t',num2str(i),'_p',num2str(j),'_frq,',...
                'psd_mean_sbj',num2str(sbjs_non(k,:)),'_ch',num2str(elec_non_cont(k)),'_t',num2str(i),'_p',num2str(j),'_saw,''LineWidth'',2)'])
        end
        
        eval(['ylim_',num2str(sp),'=get(gca,''ylim'')'])
           
        if count==21
            ylabel('atStartPosition')
            title('cont non:t1')
        elseif count==22
            title('t2')
        elseif count==23
            title('t3')
        elseif count==24
            title('t4')
        elseif count==25
            ylabel('cueEvent')
        elseif count==29
            ylabel('targetUp')
        elseif count==32
            l2=legend
        end
    end
end
min_ylim=min([ylim_21(1) ylim_22(1) ylim_23(1) ylim_24(1) ylim_26(1) ylim_27(1) ylim_28(1) ylim_29(1) ylim_31(1) ylim_32(1) ylim_33(1) ylim_34(1)])
max_ylim=max([ylim_21(2) ylim_22(2) ylim_23(2) ylim_24(2) ylim_26(2) ylim_27(2) ylim_28(2) ylim_29(2) ylim_31(2) ylim_32(2) ylim_33(2) ylim_34(2)])
for i=[21 22 23 24 26 27 28 29 31 32 33 34]
    subplot(8,5,i)
    set(gca,'ylim',[0 max_ylim])
    plot([13 13],[0 max_ylim],'r')
    plot([30 30],[0 max_ylim],'r')
end
set(l2,'String',{'sbj13','sbj15','sbj17','sbj18','sbj21'},'Position',[0.7837 0.1033 0.1051 0.0803])

subplot(8,5,25); hold on
bar([mean_mean_mean_sum_beta_t1_p1_non_cont mean_mean_mean_sum_beta_t2_p1_non_cont mean_mean_mean_sum_beta_t3_p1_non_cont mean_mean_mean_sum_beta_t4_p1_non_cont])
errorbar([mean_mean_mean_sum_beta_t1_p1_non_cont mean_mean_mean_sum_beta_t2_p1_non_cont mean_mean_mean_sum_beta_t3_p1_non_cont mean_mean_mean_sum_beta_t4_p1_non_cont],...
    [se_mean_mean_sum_beta_t1_p1_non_cont se_mean_mean_sum_beta_t2_p1_non_cont se_mean_mean_sum_beta_t3_p1_non_cont se_mean_mean_sum_beta_t4_p1_non_cont],'.k')
set(gca,'XTick',[1:4],'XTickLabel',['t1';'t2';'t3';'t4'])
[p_mean_mean_sum_beta_p1,anovatab_mean_mean_sum_beta_p1,stats_mean_mean_sum_beta_p1]=...
    kruskalwallis([mean_mean_sum_beta_t1_p1_non_cont',mean_mean_sum_beta_t2_p1_non_cont',mean_mean_sum_beta_t3_p1_non_cont',mean_mean_sum_beta_t4_p1_non_cont'],[],'off')
if p_mean_mean_sum_beta_p1<=0.05
    title(num2str(p_mean_mean_sum_beta_p1),'Color',[1 0 0])
else
    title(num2str(p_mean_mean_sum_beta_p1))
end
nr_multcompare_ind_tdcs_plot(stats_mean_mean_sum_beta_p1,min_ylim)

subplot(8,5,30); hold on
bar([mean_mean_mean_sum_beta_t1_p2_non_cont mean_mean_mean_sum_beta_t2_p2_non_cont mean_mean_mean_sum_beta_t3_p2_non_cont mean_mean_mean_sum_beta_t4_p2_non_cont])
errorbar([mean_mean_mean_sum_beta_t1_p2_non_cont mean_mean_mean_sum_beta_t2_p2_non_cont mean_mean_mean_sum_beta_t3_p2_non_cont mean_mean_mean_sum_beta_t4_p2_non_cont],...
    [se_mean_mean_sum_beta_t1_p2_non_cont se_mean_mean_sum_beta_t2_p2_non_cont se_mean_mean_sum_beta_t3_p2_non_cont se_mean_mean_sum_beta_t4_p2_non_cont],'.k')
set(gca,'XTick',[1:4],'XTickLabel',['t1';'t2';'t3';'t4'])
[p_mean_mean_sum_beta_p2,anovatab_mean_mean_sum_beta_p2,stats_mean_mean_sum_beta_p2]=...
    kruskalwallis([mean_mean_sum_beta_t1_p2_non_cont',mean_mean_sum_beta_t2_p2_non_cont',mean_mean_sum_beta_t3_p2_non_cont',mean_mean_sum_beta_t4_p2_non_cont'],[],'off')
if p_mean_mean_sum_beta_p2<=0.05
    title(num2str(p_mean_mean_sum_beta_p2),'Color',[1 0 0])
else
    title(num2str(p_mean_mean_sum_beta_p2))
end
nr_multcompare_ind_tdcs_plot(stats_mean_mean_sum_beta_p2,min_ylim)

subplot(8,5,35); hold on
bar([mean_mean_mean_sum_beta_t1_p3_non_cont mean_mean_mean_sum_beta_t2_p3_non_cont mean_mean_mean_sum_beta_t3_p3_non_cont mean_mean_mean_sum_beta_t4_p3_non_cont])
errorbar([mean_mean_mean_sum_beta_t1_p3_non_cont mean_mean_mean_sum_beta_t2_p3_non_cont mean_mean_mean_sum_beta_t3_p3_non_cont mean_mean_mean_sum_beta_t4_p3_non_cont],...
    [se_mean_mean_sum_beta_t1_p3_non_cont se_mean_mean_sum_beta_t2_p3_non_cont se_mean_mean_sum_beta_t3_p3_non_cont se_mean_mean_sum_beta_t4_p3_non_cont],'.k')
set(gca,'XTick',[1:4],'XTickLabel',['t1';'t2';'t3';'t4'])
[p_mean_mean_sum_beta_p3,anovatab_mean_mean_sum_beta_p3,stats_mean_mean_sum_beta_p3]=...
    kruskalwallis([mean_mean_sum_beta_t1_p3_non_cont',mean_mean_sum_beta_t2_p3_non_cont',mean_mean_sum_beta_t3_p3_non_cont',mean_mean_sum_beta_t4_p3_non_cont'],[],'off')
if p_mean_mean_sum_beta_p3<=0.05
    title(num2str(p_mean_mean_sum_beta_p3),'Color',[1 0 0])
else
    title(num2str(p_mean_mean_sum_beta_p3))
end
nr_multcompare_ind_tdcs_plot(stats_mean_mean_sum_beta_p3,min_ylim)

subplot(8,5,36); hold on
bar([mean_mean_mean_sum_beta_t1_p1_non_cont mean_mean_mean_sum_beta_t1_p2_non_cont mean_mean_mean_sum_beta_t1_p3_non_cont])
errorbar([mean_mean_mean_sum_beta_t1_p1_non_cont mean_mean_mean_sum_beta_t1_p2_non_cont mean_mean_mean_sum_beta_t1_p3_non_cont],...
    [se_mean_mean_sum_beta_t1_p1_non_cont se_mean_mean_sum_beta_t1_p2_non_cont se_mean_mean_sum_beta_t1_p3_non_cont],'.k')
set(gca,'XTick',[1:3],'XTickLabel',['h';'p';'m'])
[p_mean_mean_sum_beta_t1,anovatab_mean_mean_sum_beta_t1,stats_mean_mean_sum_beta_t1]=...
    kruskalwallis([mean_mean_sum_beta_t1_p1_non_cont',mean_mean_sum_beta_t1_p2_non_cont',mean_mean_sum_beta_t1_p3_non_cont'],[],'off')
if p_mean_mean_sum_beta_t1<=0.05
    title(num2str(p_mean_mean_sum_beta_t1),'Color',[1 0 0])
else
    title(num2str(p_mean_mean_sum_beta_t1))
end
nr_multcompare_ind_tdcs_plot(stats_mean_mean_sum_beta_t1,0)

subplot(8,5,37); hold on
bar([mean_mean_mean_sum_beta_t2_p1_non_cont mean_mean_mean_sum_beta_t2_p2_non_cont mean_mean_mean_sum_beta_t2_p3_non_cont])
errorbar([mean_mean_mean_sum_beta_t2_p1_non_cont mean_mean_mean_sum_beta_t2_p2_non_cont mean_mean_mean_sum_beta_t2_p3_non_cont],...
    [se_mean_mean_sum_beta_t2_p1_non_cont se_mean_mean_sum_beta_t2_p2_non_cont se_mean_mean_sum_beta_t2_p3_non_cont],'.k')
set(gca,'XTick',[1:3],'XTickLabel',['h';'p';'m'])
[p_mean_mean_sum_beta_t2,anovatab_mean_mean_sum_beta_t2,stats_mean_mean_sum_beta_t2]=...
    kruskalwallis([mean_mean_sum_beta_t2_p1_non_cont',mean_mean_sum_beta_t2_p2_non_cont',mean_mean_sum_beta_t2_p3_non_cont'],[],'off')
if p_mean_mean_sum_beta_t2<=0.05
    title(num2str(p_mean_mean_sum_beta_t2),'Color',[1 0 0])
else
    title(num2str(p_mean_mean_sum_beta_t2))
end
nr_multcompare_ind_tdcs_plot(stats_mean_mean_sum_beta_t2,0)

subplot(8,5,38); hold on
bar([mean_mean_mean_sum_beta_t3_p1_non_cont mean_mean_mean_sum_beta_t3_p2_non_cont mean_mean_mean_sum_beta_t3_p3_non_cont])
errorbar([mean_mean_mean_sum_beta_t3_p1_non_cont mean_mean_mean_sum_beta_t3_p2_non_cont mean_mean_mean_sum_beta_t3_p3_non_cont],...
    [se_mean_mean_sum_beta_t3_p1_non_cont se_mean_mean_sum_beta_t3_p2_non_cont se_mean_mean_sum_beta_t3_p3_non_cont],'.k')
set(gca,'XTick',[1:3],'XTickLabel',['h';'p';'m'])
[p_mean_mean_sum_beta_t3,anovatab_mean_mean_sum_beta_t3,stats_mean_mean_sum_beta_t3]=...
    kruskalwallis([mean_mean_sum_beta_t3_p1_non_cont',mean_mean_sum_beta_t3_p2_non_cont',mean_mean_sum_beta_t3_p3_non_cont'],[],'off')
if p_mean_mean_sum_beta_t3<=0.05
    title(num2str(p_mean_mean_sum_beta_t3),'Color',[1 0 0])
else
    title(num2str(p_mean_mean_sum_beta_t3))
end
nr_multcompare_ind_tdcs_plot(stats_mean_mean_sum_beta_t3,0)

subplot(8,5,39); hold on
bar([mean_mean_mean_sum_beta_t4_p1_non_cont mean_mean_mean_sum_beta_t4_p2_non_cont mean_mean_mean_sum_beta_t4_p3_non_cont])
errorbar([mean_mean_mean_sum_beta_t4_p1_non_cont mean_mean_mean_sum_beta_t4_p2_non_cont mean_mean_mean_sum_beta_t4_p3_non_cont],...
    [se_mean_mean_sum_beta_t4_p1_non_cont se_mean_mean_sum_beta_t4_p2_non_cont se_mean_mean_sum_beta_t4_p3_non_cont],'.k')
set(gca,'XTick',[1:3],'XTickLabel',['h';'p';'m'])
[p_mean_mean_sum_beta_t4,anovatab_mean_mean_sum_beta_t4,stats_mean_mean_sum_beta_t4]=...
    kruskalwallis([mean_mean_sum_beta_t4_p1_non_cont',mean_mean_sum_beta_t4_p2_non_cont',mean_mean_sum_beta_t4_p3_non_cont'],[],'off')
if p_mean_mean_sum_beta_t4<=0.05
    title(num2str(p_mean_mean_sum_beta_t4),'Color',[1 0 0])
else
    title(num2str(p_mean_mean_sum_beta_t4))
end
nr_multcompare_ind_tdcs_plot(stats_mean_mean_sum_beta_t4,0)

%clear anovatab* find* mean_mean_mean_* mean_mean_beta* p* psd* se* stats* ylim*



