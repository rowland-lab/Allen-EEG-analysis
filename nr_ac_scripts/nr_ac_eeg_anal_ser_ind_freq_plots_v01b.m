function nr_ac_eeg_anal_ser_ind_freq_plots_v01b(grp,freq_band,save_fig,save_data)

%uses epochsWhole

%%% FYI I changed the multcompare to bonferroni to be able to compare
%%% directly with spss but can change back to tukey's if you like or can
%%% just make an input in the function

% grp='cs'
% save_fig='no'
% freq_band='beta'

if strcmp(grp,'cs')
    elec_stim_ipsi=[7,7,18,18,7,18,7,18,18,18]
    sbj_nums=['03';'04';'05';'42';'43';'13';'15';'17';'18';'21']
    cs_stm=[3,4,5,42,43]
    cs_non=[13,15,17,18,21]
elseif strcmp(grp,'hc')
    elec_stim_ipsi=[18,7,7,7,7,18,7,18,7,7,7]
    sbj_nums=['22';'24';'25';'26';'29';'30';'20';'23';'27';'28';'36'];
    hc_stm=[22,24,25,26,29,30]
    hc_non=[20,23,27,28,36]
end

if strcmp(freq_band,'beta')
    frq_rng_st=13;
    frq_rng_ed=30
elseif strcmp(freq_band,'alpha')
    frq_rng_st=8;
    frq_rng_ed=12;
end

out_ind_c18_p1=[1 4 7 10];
out_ind_c18_p2=[2 5 8 11];
out_ind_c18_p3=[3 6 9 12];
out_ind_c7_p1=[13 16 19 22];
out_ind_c7_p2=[14 17 20 23];
out_ind_c7_p3=[15 18 21 24];
phase={'atStartPosition';'cueEvent';'targetUp'}

%n=5

for n=1:size(sbj_nums,1) 
    load(['/home/rowlandn/nr_data_analysis/data_analyzed/eeg/gen_02/data/pro00087153_00',sbj_nums(n,:),'/analysis/S3-EEGanalysis/s3_dat.mat'])
    m=num2str(sbj_nums(n,:))
    
    %psd plots
    figure; set(gcf,'Position',[786 47 744 898])
    for i=1:4
        subplot(8,5,i)
        hold on
        eval(['find_freq_plot_ch7_atStartPosition=find(epochs.epochsWhole.t',num2str(i),'.atStartPosition.psd.freq<=100)'])
        for j=eval(['pro00087153_00',num2str(sbj_nums(n,:)),'_reaches_wo_outliers{out_ind_c7_p1(i)}'])
            eval(['plot(epochs.epochsWhole.t',num2str(i),'.atStartPosition.psd.freq(find_freq_plot_ch7_atStartPosition),log10(epochs.epochsWhole.t',num2str(i),'.atStartPosition.psd.saw(find_freq_plot_ch7_atStartPosition,7,j)))'])
        end
        ylimasp=get(gca,'ylim');
        text(75,ylimasp(2)-0.1*ylimasp(2),num2str(eval(['size(pro00087153_00',num2str(sbj_nums(n,:)),'_reaches_wo_outliers{out_ind_c7_p1(i)},2)'])))
        if i==1 & elec_stim_ipsi(n)==7
            ylabel('atStartPosition')
            title(['Sbj',m(1,:),':ch7:t',num2str(i)],'Color',[1 0 0])
        elseif i==1 & elec_stim_ipsi(n)~=7
            ylabel('atStartPosition')
            title(['Sbj',m(1,:),':ch7:t',num2str(i)])
        else
            title(['t',num2str(i)])
        end
        eval(['ylim_',num2str(i),'=get(gca,''ylim'');'])
    end

    for i=1:4
        subplot(8,5,i+5)
        hold on
        eval(['find_freq_plot_ch7_cueEvent=find(epochs.epochsWhole.t',num2str(i),'.cueEvent.psd.freq<=100)'])
        for j=eval(['pro00087153_00',num2str(sbj_nums(n,:)),'_reaches_wo_outliers{out_ind_c7_p2(i)}'])
            eval(['plot(epochs.epochsWhole.t',num2str(i),'.cueEvent.psd.freq(find_freq_plot_ch7_cueEvent),log10(epochs.epochsWhole.t',num2str(i),'.cueEvent.psd.saw(find_freq_plot_ch7_cueEvent,7,j)))'])
        end
        ylimce=get(gca,'ylim');
        text(75,ylimasp(2)-0.1*ylimasp(2),num2str(eval(['size(pro00087153_00',num2str(sbj_nums(n,:)),'_reaches_wo_outliers{out_ind_c7_p2(i)},2)'])))
        if i==1
            ylabel('cueEvent')
        end
        title(['t',num2str(i)])
        eval(['ylim_',num2str(i+5),'=get(gca,''ylim'');'])
    end

    for i=1:4
        subplot(8,5,i+10)
        hold on
        eval(['find_freq_plot_ch7_targetUp=find(epochs.epochsWhole.t',num2str(i),'.targetUp.psd.freq<=100)'])
        for j=eval(['pro00087153_00',num2str(sbj_nums(n,:)),'_reaches_wo_outliers{out_ind_c7_p3(i)}'])
            eval(['plot(epochs.epochsWhole.t',num2str(i),'.targetUp.psd.freq(find_freq_plot_ch7_targetUp),log10(epochs.epochsWhole.t',num2str(i),'.targetUp.psd.saw(find_freq_plot_ch7_targetUp,7,j)))'])
        end
        ylimtu=get(gca,'ylim');
        text(75,ylimasp(2)-0.1*ylimasp(2),num2str(eval(['size(pro00087153_00',num2str(sbj_nums(n,:)),'_reaches_wo_outliers{out_ind_c7_p3(i)},2)'])))
        if i==1
            ylabel('targetUp')
        end
        title(['t',num2str(i)])
        eval(['ylim_',num2str(i+10),'=get(gca,''ylim'');'])
    end

    %%%scale psd plots
    ymin=min([ylim_1(1) ylim_2(1) ylim_3(1) ylim_4(1),...
              ylim_6(1) ylim_7(1) ylim_8(1) ylim_9(1),...
              ylim_11(1) ylim_12(1) ylim_13(1) ylim_14(1)])
    ymax=max([ylim_1(2) ylim_2(2) ylim_3(2) ylim_4(2),...
              ylim_6(2) ylim_7(2) ylim_8(2) ylim_9(2),...
              ylim_11(2) ylim_12(2) ylim_13(2) ylim_14(2)])
             
    for l=1:14
        if l<=4
            subplot(8,5,l)
            set(gca,'ylim',[ymin ymax])
        elseif l>=6 & l<=9
            subplot(8,5,l)
            set(gca,'ylim',[ymin ymax])
        elseif l>=11 & l<=14
            subplot(8,5,l)
            set(gca,'ylim',[ymin ymax])
        end
    end
    %%%
    
      
    %bar plots
    count=0
    for i=1:4
        for j=1:3
            count=count+1
            for l=eval(['pro00087153_00',num2str(sbj_nums(n,:)),'_reaches_wo_outliers{count+12}'])
                l
                eval(['find_freq_',freq_band,'_ch7_t',num2str(i),'_p',num2str(j),'=find(epochs.epochsWhole.t',num2str(i),'.',phase{j},'.psd.freq>=',num2str(frq_rng_st),' & epochs.epochsWhole.t',num2str(i),'.',phase{j},'.psd.freq<=',num2str(frq_rng_ed),')'])
                eval(['mean_',freq_band,'_sbj',m,'_ch7_t',num2str(i),'_p',num2str(j),'(l)=log10(mean(epochs.epochsWhole.t',num2str(i),'.',phase{j},...
                    '.psd.saw(find_freq_',freq_band,'_ch7_t',num2str(i),'_p',num2str(j),',7,l)));'])
            end
        end
    end
    
    for i=1:4
        for j=1:3
            eval(['mean_',freq_band,'_sbj',m,'_ch7_t',num2str(i),'_p',num2str(j),'=nonzeros(mean_',freq_band,'_sbj',m,'_ch7_t',num2str(i),'_p',num2str(j),')'''])
            eval(['size_mean_',freq_band,'_sbj',m,'_ch7_t',num2str(i),'_p',num2str(j),'=size(mean_',freq_band,'_sbj',m,'_ch7_t',num2str(i),'_p',num2str(j),',2)'])
        end
    end
    %supermean of each t and p combination to get 1 value
    for i=1:4
        for j=1:3
            eval(['mean_mean_',freq_band,'_sbj',m,'_ch7_t',num2str(i),'_p',num2str(j),'=mean(mean_',freq_band,'_sbj',m,'_ch7_t',num2str(i),'_p',num2str(j),')'])
            eval(['se_mean_',freq_band,'_sbj',m,'_ch7_t',num2str(i),'_p',num2str(j),'=std(mean_',freq_band,'_sbj',m,'_ch7_t',num2str(i),'_p',num2str(j),...
                ')/sqrt(size_mean_',freq_band,'_sbj',m,'_ch7_t',num2str(i),'_p',num2str(j),');'])
        end
    end
    
    %generate group variable for stats below
    count=0
    for i=1:4
        for j=1:3
            count=count+1         
            eval(['mat_sz_mean_ch7{',num2str(count),'}=linspace(',num2str(count),',',num2str(count),...
            ',size_mean_',freq_band,'_sbj',m,'_ch7_t',num2str(i),'_p',num2str(j),')'])
        end
    end
    grp_means=cat(2,mat_sz_mean_ch7{:}); %probably don't need this bc you generate each separate one below
    
    %t1-4 for p1
    grps_plot_05=[1 4 7 10] %don't remember how I came up with these indices 1,4,7,10 but I do remember it was necessary to assign each mean a unique #
    for i=1:4               % they are used to group the kruskall-wallis groups
        for j=1
            eval(['mat_sz_plot_05{',num2str(i),'}=linspace(',num2str(grps_plot_05(i)),',',num2str(grps_plot_05(i)),...
            ',size_mean_',freq_band,'_sbj',m,'_ch7_t',num2str(i),'_p',num2str(j),')'])
        end
    end
    grp_plot_05_all=cat(2,mat_sz_plot_05{:});
    
    subplot(8,5,5)
    hold on
    eval(['bar([mean_mean_',freq_band,'_sbj',m,'_ch7_t1_p1 mean_mean_',freq_band,'_sbj',m,'_ch7_t2_p1 mean_mean_',freq_band,'_sbj',m,'_ch7_t3_p1 mean_mean_',freq_band,'_sbj',m,'_ch7_t4_p1])'])
    eval(['errorbar([mean_mean_',freq_band,'_sbj',m,'_ch7_t1_p1 mean_mean_',freq_band,'_sbj',m,'_ch7_t2_p1 mean_mean_',freq_band,'_sbj',m,'_ch7_t3_p1 mean_mean_',freq_band,'_sbj',m,'_ch7_t4_p1],',...
        '[se_mean_',freq_band,'_sbj',m,'_ch7_t1_p1 se_mean_',freq_band,'_sbj',m,'_ch7_t2_p1 se_mean_',freq_band,'_sbj',m,'_ch7_t3_p1 se_mean_',freq_band,'_sbj',m,'_ch7_t4_p1],''.k'')'])
    ylim_5=get(gca,'ylim');
    set(gca,'XTick',[1:4],'XTickLabel',{'t1';'t2';'t3';'t4'})
    eval(['[p_mean_',freq_band,'_sbj',m,'_ch7_p1,table_mean_',freq_band,'_sbj',m,'_ch7_p1,stats_mean_',freq_band,'_sbj',m,...
        '_ch7_p1]=kruskalwallis([mean_',freq_band,'_sbj',m,'_ch7_t1_p1,mean_',freq_band,'_sbj',m,'_ch7_t2_p1,mean_',freq_band,'_sbj',m,'_ch7_t3_p1,mean_',freq_band,'_sbj',m,'_ch7_t4_p1],[grp_plot_05_all],''off'')'])
    if eval(['p_mean_',freq_band,'_sbj',m,'_ch7_p1'])<=0.05
        eval(['title(num2str(p_mean_',freq_band,'_sbj',m,'_ch7_p1),''Color'',[1 0 0])'])
    else
        eval(['title(num2str(p_mean_',freq_band,'_sbj',m,'_ch7_p1))'])
    end
        
    %t1-4 for p2
    grps_plot_10=[2 5 8 11]
    for i=1:4
        for j=2
            eval(['mat_sz_plot_10{',num2str(i),'}=linspace(',num2str(grps_plot_10(i)),',',num2str(grps_plot_10(i)),...
            ',size_mean_',freq_band,'_sbj',m,'_ch7_t',num2str(i),'_p',num2str(j),')'])
        end
    end
    grp_plot_10_all=cat(2,mat_sz_plot_10{:});

    subplot(8,5,10)
    hold on
    eval(['bar([mean_mean_',freq_band,'_sbj',m,'_ch7_t1_p2 mean_mean_',freq_band,'_sbj',m,'_ch7_t2_p2 mean_mean_',freq_band,'_sbj',m,'_ch7_t3_p2 mean_mean_',freq_band,'_sbj',m,'_ch7_t4_p2])'])
    eval(['errorbar([mean_mean_',freq_band,'_sbj',m,'_ch7_t1_p2 mean_mean_',freq_band,'_sbj',m,'_ch7_t2_p2 mean_mean_',freq_band,'_sbj',m,'_ch7_t3_p2 mean_mean_',freq_band,'_sbj',m,'_ch7_t4_p2],',...
        '[se_mean_',freq_band,'_sbj',m,'_ch7_t1_p2 se_mean_',freq_band,'_sbj',m,'_ch7_t2_p2 se_mean_',freq_band,'_sbj',m,'_ch7_t3_p2 se_mean_',freq_band,'_sbj',m,'_ch7_t4_p2],''.k'')'])
    ylim_10=get(gca,'ylim');
    set(gca,'XTick',[1:4],'XTickLabel',{'t1';'t2';'t3';'t4'})
    eval(['[p_mean_',freq_band,'_sbj',m,'_ch7_p2,table_mean_',freq_band,'_sbj',m,'_ch7_p2,stats_mean_',freq_band,'_sbj',m,...
        '_ch7_p2]=kruskalwallis([mean_',freq_band,'_sbj',m,'_ch7_t1_p2,mean_',freq_band,'_sbj',m,'_ch7_t2_p2,mean_',freq_band,'_sbj',m,'_ch7_t3_p2,mean_',freq_band,'_sbj',m,'_ch7_t4_p2],[grp_plot_10_all],''off'')'])
    if eval(['p_mean_',freq_band,'_sbj',m,'_ch7_p2'])<=0.05
        eval(['title(num2str(p_mean_',freq_band,'_sbj',m,'_ch7_p2),''Color'',[1 0 0])'])
    else
        eval(['title(num2str(p_mean_',freq_band,'_sbj',m,'_ch7_p2))'])
    end
        
    %t1-4 for p3
    grps_plot_15=[3 6 9 12]
    for i=1:4
        for j=3
            eval(['mat_sz_plot_15{',num2str(i),'}=linspace(',num2str(grps_plot_15(i)),',',num2str(grps_plot_15(i)),...
            ',size_mean_',freq_band,'_sbj',m,'_ch7_t',num2str(i),'_p',num2str(j),')'])
        end
    end
    grp_plot_15_all=cat(2,mat_sz_plot_15{:});

    subplot(8,5,15)
    hold on
    eval(['bar([mean_mean_',freq_band,'_sbj',m,'_ch7_t1_p3 mean_mean_',freq_band,'_sbj',m,'_ch7_t2_p3 mean_mean_',freq_band,'_sbj',m,'_ch7_t3_p3 mean_mean_',freq_band,'_sbj',m,'_ch7_t4_p3])'])
    eval(['errorbar([mean_mean_',freq_band,'_sbj',m,'_ch7_t1_p3 mean_mean_',freq_band,'_sbj',m,'_ch7_t2_p3 mean_mean_',freq_band,'_sbj',m,'_ch7_t3_p3 mean_mean_',freq_band,'_sbj',m,'_ch7_t4_p3],',...
        '[se_mean_',freq_band,'_sbj',m,'_ch7_t1_p3 se_mean_',freq_band,'_sbj',m,'_ch7_t2_p3 se_mean_',freq_band,'_sbj',m,'_ch7_t3_p3 se_mean_',freq_band,'_sbj',m,'_ch7_t4_p3],''.k'')'])
    ylim_15=get(gca,'ylim');
    ymin2=min([ylim_5(1) ylim_10(1) ylim_15(1)]);
    ymax2=max([ylim_5(2) ylim_10(2) ylim_15(2)]);
    set(gca,'XTick',[1:4],'XTickLabel',{'t1';'t2';'t3';'t4'})
    eval(['[p_mean_',freq_band,'_sbj',m,'_ch7_p3,table_mean_',freq_band,'_sbj',m,'_ch7_p3,stats_mean_',freq_band,'_sbj',m,...
        '_ch7_p3]=kruskalwallis([mean_',freq_band,'_sbj',m,'_ch7_t1_p3,mean_',freq_band,'_sbj',m,'_ch7_t2_p3,mean_',freq_band,'_sbj',m,'_ch7_t3_p3,mean_',freq_band,'_sbj',m,'_ch7_t4_p3],[grp_plot_15_all],''off'')'])
    if eval(['p_mean_',freq_band,'_sbj',m,'_ch7_p3'])<=0.05
        eval(['title(num2str(p_mean_',freq_band,'_sbj',m,'_ch7_p3),''Color'',[1 0 0])'])
    else
        eval(['title(num2str(p_mean_',freq_band,'_sbj',m,'_ch7_p3))'])
    end

    for i=[5 10 15]
        subplot(8,5,i)
        set(gca,'ylim',[ymin2 ymax2])
    end
    
    subplot(8,5,5)
    eval(['mc_ch7_p1=nr_multcompare_ind_tdcs_plot(stats_mean_',freq_band,'_sbj',m,'_ch7_p1,ymin2)'])
    subplot(8,5,10)
    eval(['mc_ch7_p2=nr_multcompare_ind_tdcs_plot(stats_mean_',freq_band,'_sbj',m,'_ch7_p2,ymin2)'])
    subplot(8,5,15)
    eval(['mc_ch7_p3=nr_multcompare_ind_tdcs_plot(stats_mean_',freq_band,'_sbj',m,'_ch7_p3,ymin2)'])
    
    %p1-3 for t1
    grps_plot_16=[1 2 3]
    for i=1
        for j=1:3
            eval(['mat_sz_plot_16{',num2str(j),'}=linspace(',num2str(grps_plot_16(j)),',',num2str(grps_plot_16(j)),...
            ',size_mean_',freq_band,'_sbj',m,'_ch7_t',num2str(i),'_p',num2str(j),')'])
        end
    end
    grp_plot_16_all=cat(2,mat_sz_plot_16{:});

    subplot(8,5,16)
    hold on
    eval(['bar([mean_mean_',freq_band,'_sbj',m,'_ch7_t1_p1 mean_mean_',freq_band,'_sbj',m,'_ch7_t1_p2 mean_mean_',freq_band,'_sbj',m,'_ch7_t1_p3])'])
    eval(['errorbar([mean_mean_',freq_band,'_sbj',m,'_ch7_t1_p1 mean_mean_',freq_band,'_sbj',m,'_ch7_t1_p2 mean_mean_',freq_band,'_sbj',m,'_ch7_t1_p3],',...
        '[se_mean_',freq_band,'_sbj',m,'_ch7_t1_p1 se_mean_',freq_band,'_sbj',m,'_ch7_t1_p2 se_mean_',freq_band,'_sbj',m,'_ch7_t1_p3],''.k'')'])
    ylim_16=get(gca,'ylim');
    set(gca,'XTick',[1:3],'XTickLabel',{'h';'p';'m'})
    eval(['[p_mean_',freq_band,'_sbj',m,'_ch7_t1,table_mean_',freq_band,'_sbj',m,'_ch7_t1,stats_mean_',freq_band,'_sbj',m,...
        '_ch7_t1]=kruskalwallis([mean_',freq_band,'_sbj',m,'_ch7_t1_p1,mean_',freq_band,'_sbj',m,'_ch7_t1_p2,mean_',freq_band,'_sbj',m,'_ch7_t1_p3],[grp_plot_16_all],''off'')'])
    if eval(['p_mean_',freq_band,'_sbj',m,'_ch7_t1'])<=0.05
        eval(['title(num2str(p_mean_',freq_band,'_sbj',m,'_ch7_t1),''Color'',[1 0 0])'])
    else
        eval(['title(num2str(p_mean_',freq_band,'_sbj',m,'_ch7_t1))'])
    end

    %p1-3 for t2
    grps_plot_17=[4 5 6]
    for i=2
        for j=1:3
            eval(['mat_sz_plot_17{',num2str(j),'}=linspace(',num2str(grps_plot_17(j)),',',num2str(grps_plot_17(j)),...
            ',size_mean_',freq_band,'_sbj',m,'_ch7_t',num2str(i),'_p',num2str(j),')'])
        end
    end
    grp_plot_17_all=cat(2,mat_sz_plot_17{:});
    
    subplot(8,5,17)
    hold on
    eval(['bar([mean_mean_',freq_band,'_sbj',m,'_ch7_t2_p1 mean_mean_',freq_band,'_sbj',m,'_ch7_t2_p2 mean_mean_',freq_band,'_sbj',m,'_ch7_t2_p3 ])'])
    eval(['errorbar([mean_mean_',freq_band,'_sbj',m,'_ch7_t2_p1 mean_mean_',freq_band,'_sbj',m,'_ch7_t2_p2 mean_mean_',freq_band,'_sbj',m,'_ch7_t2_p3],',...
        '[se_mean_',freq_band,'_sbj',m,'_ch7_t2_p1 se_mean_',freq_band,'_sbj',m,'_ch7_t2_p2 se_mean_',freq_band,'_sbj',m,'_ch7_t2_p3],''.k'')'])
    ylim_17=get(gca,'ylim');
    set(gca,'XTick',[1:3],'XTickLabel',{'h';'p';'m'})
    eval(['[p_mean_',freq_band,'_sbj',m,'_ch7_t2,table_mean_',freq_band,'_sbj',m,'_ch7_t2,stats_mean_',freq_band,'_sbj',m,...
        '_ch7_t2]=kruskalwallis([mean_',freq_band,'_sbj',m,'_ch7_t2_p1,mean_',freq_band,'_sbj',m,'_ch7_t2_p2,mean_',freq_band,'_sbj',m,'_ch7_t2_p3],[grp_plot_17_all],''off'')'])
    if eval(['p_mean_',freq_band,'_sbj',m,'_ch7_t2'])<=0.05
        eval(['title(num2str(p_mean_',freq_band,'_sbj',m,'_ch7_t2),''Color'',[1 0 0])'])
    else
        eval(['title(num2str(p_mean_',freq_band,'_sbj',m,'_ch7_t2))'])
    end
    
    %p1-3 for t3
    grps_plot_18=[7 8 9]
    for i=3
        for j=1:3
            eval(['mat_sz_plot_18{',num2str(j),'}=linspace(',num2str(grps_plot_18(j)),',',num2str(grps_plot_18(j)),...
            ',size_mean_',freq_band,'_sbj',m,'_ch7_t',num2str(i),'_p',num2str(j),')'])
        end
    end
    grp_plot_18_all=cat(2,mat_sz_plot_18{:});

    subplot(8,5,18)
    hold on
    eval(['bar([mean_mean_',freq_band,'_sbj',m,'_ch7_t3_p1 mean_mean_',freq_band,'_sbj',m,'_ch7_t3_p2 mean_mean_',freq_band,'_sbj',m,'_ch7_t3_p3])'])
    eval(['errorbar([mean_mean_',freq_band,'_sbj',m,'_ch7_t3_p1 mean_mean_',freq_band,'_sbj',m,'_ch7_t3_p2 mean_mean_',freq_band,'_sbj',m,'_ch7_t3_p3],',...
        '[se_mean_',freq_band,'_sbj',m,'_ch7_t3_p1 se_mean_',freq_band,'_sbj',m,'_ch7_t3_p2 se_mean_',freq_band,'_sbj',m,'_ch7_t3_p3],''.k'')'])
    ylim_18=get(gca,'ylim');
    set(gca,'XTick',[1:3],'XTickLabel',{'h';'p';'m'})
    eval(['[p_mean_',freq_band,'_sbj',m,'_ch7_t3,table_mean_',freq_band,'_sbj',m,'_ch7_t3,stats_mean_',freq_band,'_sbj',m,...
        '_ch7_t3]=kruskalwallis([mean_',freq_band,'_sbj',m,'_ch7_t3_p1,mean_',freq_band,'_sbj',m,'_ch7_t3_p2,mean_',freq_band,'_sbj',m,'_ch7_t3_p3],[grp_plot_18_all],''off'')'])
    if eval(['p_mean_',freq_band,'_sbj',m,'_ch7_t3'])<=0.05
        eval(['title(num2str(p_mean_',freq_band,'_sbj',m,'_ch7_t3),''Color'',[1 0 0])'])
    else
        eval(['title(num2str(p_mean_',freq_band,'_sbj',m,'_ch7_t3))'])
    end
    
    %p1-3 for t4
    grps_plot_19=[10 11 12]
    for i=4
        for j=1:3
            eval(['mat_sz_plot_19{',num2str(j),'}=linspace(',num2str(grps_plot_19(j)),',',num2str(grps_plot_19(j)),...
            ',size_mean_',freq_band,'_sbj',m,'_ch7_t',num2str(i),'_p',num2str(j),')'])
        end
    end
    grp_plot_19_all=cat(2,mat_sz_plot_19{:});

    subplot(8,5,19)
    hold on
    eval(['bar([mean_mean_',freq_band,'_sbj',m,'_ch7_t4_p1 mean_mean_',freq_band,'_sbj',m,'_ch7_t4_p2 mean_mean_',freq_band,'_sbj',m,'_ch7_t4_p3])'])
    eval(['errorbar([mean_mean_',freq_band,'_sbj',m,'_ch7_t4_p1 mean_mean_',freq_band,'_sbj',m,'_ch7_t4_p2 mean_mean_',freq_band,'_sbj',m,'_ch7_t4_p3],',...
        '[se_mean_',freq_band,'_sbj',m,'_ch7_t4_p1 se_mean_',freq_band,'_sbj',m,'_ch7_t4_p2 se_mean_',freq_band,'_sbj',m,'_ch7_t4_p3],''.k'')'])
    ylim_19=get(gca,'ylim');
    set(gca,'XTick',[1:3],'XTickLabel',{'h';'p';'m'})
    eval(['[p_mean_',freq_band,'_sbj',m,'_ch7_t4,table_mean_',freq_band,'_sbj',m,'_ch7_t4,stats_mean_',freq_band,'_sbj',m,...
        '_ch7_t4]=kruskalwallis([mean_',freq_band,'_sbj',m,'_ch7_t4_p1,mean_',freq_band,'_sbj',m,'_ch7_t4_p2,mean_',freq_band,'_sbj',m,'_ch7_t4_p3],[grp_plot_19_all],''off'')'])
    if eval(['p_mean_',freq_band,'_sbj',m,'_ch7_t4'])<=0.05
        eval(['title(num2str(p_mean_',freq_band,'_sbj',m,'_ch7_t4),''Color'',[1 0 0])'])
    else
        eval(['title(num2str(p_mean_',freq_band,'_sbj',m,'_ch7_t4))'])
    end

    ymin3=min([ylim_16(1) ylim_17(1) ylim_18(1) ylim_19(1)]);
    ymax3=max([ylim_16(2) ylim_17(2) ylim_18(2) ylim_19(2)]);
    for i=[16:19]
        subplot(8,5,i)
        set(gca,'ylim',[ymin3 ymax3])
    end

    subplot(8,5,16)
    eval(['mc_ch7_t1=nr_multcompare_ind_tdcs_plot(stats_mean_',freq_band,'_sbj',m,'_ch7_t1,ymin3)'])
    subplot(8,5,17)
    eval(['mc_ch7_t2=nr_multcompare_ind_tdcs_plot(stats_mean_',freq_band,'_sbj',m,'_ch7_t2,ymin3)'])
    subplot(8,5,18)
    eval(['mc_ch7_t3=nr_multcompare_ind_tdcs_plot(stats_mean_',freq_band,'_sbj',m,'_ch7_t3,ymin3)'])
    subplot(8,5,19)
    eval(['mc_ch7_t4=nr_multcompare_ind_tdcs_plot(stats_mean_',freq_band,'_sbj',m,'_ch7_t4,ymin3)'])


    %ch18
    %psd plots
    for i=1:4
        subplot(8,5,i+20)
        hold on
        eval(['find_freq_plot_ch18_atStartPosition=find(epochs.epochsWhole.t',num2str(i),'.atStartPosition.psd.freq<=100)'])
        for j=eval(['pro00087153_00',num2str(sbj_nums(n,:)),'_reaches_wo_outliers{out_ind_c18_p1(i)}'])
            eval(['plot(epochs.epochsWhole.t',num2str(i),'.atStartPosition.psd.freq(find_freq_plot_ch18_atStartPosition),log10(epochs.epochsWhole.t',num2str(i),'.atStartPosition.psd.saw(find_freq_plot_ch18_atStartPosition,18,j)))'])
        end
        ylimasp=get(gca,'ylim');
        text(75,ylimasp(2)-0.1*ylimasp(2),num2str(eval(['size(pro00087153_00',num2str(sbj_nums(n,:)),'_reaches_wo_outliers{out_ind_c18_p1(i)},2)'])))
        if i==1 & elec_stim_ipsi(n)==18
            ylabel('atStartPosition')
            title(['ch18:t',num2str(i)],'Color',[1 0 0])
        elseif i==1 & elec_stim_ipsi(n)~=18
            ylabel('atStartPosition')
            title(['ch18:t',num2str(i)])
        else
            title(['t',num2str(i)])
        end
        eval(['ylim_',num2str(i+20),'=get(gca,''ylim'');'])
    end

    for i=1:4
        subplot(8,5,i+25)
        hold on
        eval(['find_freq_plot_ch18_cueEvent=find(epochs.epochsWhole.t',num2str(i),'.cueEvent.psd.freq<=100)'])
        for j=eval(['pro00087153_00',num2str(sbj_nums(n,:)),'_reaches_wo_outliers{out_ind_c18_p2(i)}'])
            eval(['plot(epochs.epochsWhole.t',num2str(i),'.cueEvent.psd.freq(find_freq_plot_ch18_cueEvent),log10(epochs.epochsWhole.t',num2str(i),'.cueEvent.psd.saw(find_freq_plot_ch18_cueEvent,18,j)))'])
        end
        ylimce=get(gca,'ylim');
        text(75,ylimasp(2)-0.1*ylimasp(2),num2str(eval(['size(pro00087153_00',num2str(sbj_nums(n,:)),'_reaches_wo_outliers{out_ind_c18_p2(i)},2)'])))
        if i==1
            ylabel('cueEvent')
        end
        title(['t',num2str(i)])
        eval(['ylim_',num2str(i+25),'=get(gca,''ylim'');'])
    end

    for i=1:4
        subplot(8,5,i+30)
        hold on
        eval(['find_freq_plot_ch18_targetUp=find(epochs.epochsWhole.t',num2str(i),'.targetUp.psd.freq<=100)'])
        for j=eval(['pro00087153_00',num2str(sbj_nums(n,:)),'_reaches_wo_outliers{out_ind_c18_p3(i)}'])
            eval(['plot(epochs.epochsWhole.t',num2str(i),'.targetUp.psd.freq(find_freq_plot_ch18_targetUp),log10(epochs.epochsWhole.t',num2str(i),'.targetUp.psd.saw(find_freq_plot_ch18_targetUp,18,j)))'])
        end
        ylimtu=get(gca,'ylim');
        text(75,ylimasp(2)-0.1*ylimasp(2),num2str(eval(['size(pro00087153_00',num2str(sbj_nums(n,:)),'_reaches_wo_outliers{out_ind_c18_p3(i)},2)'])))
        if i==1
            ylabel('targetUp')
        end
        title(['t',num2str(i)])
        eval(['ylim_',num2str(i+30),'=get(gca,''ylim'');'])
    end
    
    %%%scale psd plots
    ymin=min([ylim_21(1) ylim_22(1) ylim_23(1) ylim_24(1),...
              ylim_26(1) ylim_27(1) ylim_28(1) ylim_29(1),...
              ylim_31(1) ylim_32(1) ylim_33(1) ylim_34(1)])
    ymax=max([ylim_21(2) ylim_22(2) ylim_23(2) ylim_24(2),...
              ylim_26(2) ylim_27(2) ylim_28(2) ylim_29(2),...
              ylim_31(2) ylim_32(2) ylim_33(2) ylim_34(2)])

    for l=21:34
        if l>=21 & l<=24
            subplot(8,5,l)
            set(gca,'ylim',[ymin ymax])
        elseif l>=26 & l<=29
            subplot(8,5,l)
            set(gca,'ylim',[ymin ymax])
        elseif l>=31 & l<=34
            subplot(8,5,l)
            set(gca,'ylim',[ymin ymax])
        end
    end
    %%%
    
    phase={'atStartPosition';'cueEvent';'targetUp'}
    count=0
    for i=1:4
        for j=1:3
            count=count+1
            for l=eval(['pro00087153_00',num2str(sbj_nums(n,:)),'_reaches_wo_outliers{count}'])
                eval(['find_freq_',freq_band,'_ch18_t',num2str(i),'_p',num2str(j),'=find(epochs.epochsWhole.t',num2str(i),'.',phase{j},'.psd.freq>=',num2str(frq_rng_st),' & epochs.epochsWhole.t',num2str(i),'.',phase{j},'.psd.freq<=',num2str(frq_rng_ed),')'])
                eval(['mean_',freq_band,'_sbj',m,'_ch18_t',num2str(i),'_p',num2str(j),'(l)=log10(mean(epochs.epochsWhole.t',num2str(i),'.',phase{j},...
                    '.psd.saw(find_freq_',freq_band,'_ch18_t',num2str(i),'_p',num2str(j),',18,l)));'])
            end
        end
    end
    
    for i=1:4
        for j=1:3
            eval(['mean_',freq_band,'_sbj',m,'_ch18_t',num2str(i),'_p',num2str(j),'=nonzeros(mean_',freq_band,'_sbj',m,'_ch18_t',num2str(i),'_p',num2str(j),')'''])
            eval(['size_mean_',freq_band,'_sbj',m,'_ch18_t',num2str(i),'_p',num2str(j),'=size(mean_',freq_band,'_sbj',m,'_ch18_t',num2str(i),'_p',num2str(j),',2)'])
        end
    end
        
    for i=1:4
        for j=1:3
            eval(['mean_mean_',freq_band,'_sbj',m,'_ch18_t',num2str(i),'_p',num2str(j),'=mean(mean_',freq_band,'_sbj',m,'_ch18_t',num2str(i),'_p',num2str(j),');'])
            eval(['se_mean_',freq_band,'_sbj',m,'_ch18_t',num2str(i),'_p',num2str(j),'=std(mean_',freq_band,'_sbj',m,'_ch18_t',num2str(i),'_p',num2str(j),...
                ')/sqrt(size(mean_',freq_band,'_sbj',m,'_ch18_t',num2str(i),'_p',num2str(j),',2));'])
        end
    end
    
    grps_plot_25=[1 4 7 10]
    for i=1:4
        for j=1
            eval(['mat_sz_plot_25{',num2str(i),'}=linspace(',num2str(grps_plot_25(i)),',',num2str(grps_plot_25(i)),...
            ',size_mean_',freq_band,'_sbj',m,'_ch18_t',num2str(i),'_p',num2str(j),')'])
        end
    end
    grp_plot_25_all=cat(2,mat_sz_plot_25{:});
    
    subplot(8,5,25)
    hold on
    eval(['bar([mean_mean_',freq_band,'_sbj',m,'_ch18_t1_p1 mean_mean_',freq_band,'_sbj',m,'_ch18_t2_p1 mean_mean_',freq_band,'_sbj',m,'_ch18_t3_p1 mean_mean_',freq_band,'_sbj',m,'_ch18_t4_p1])'])
    eval(['errorbar([mean_mean_',freq_band,'_sbj',m,'_ch18_t1_p1 mean_mean_',freq_band,'_sbj',m,'_ch18_t2_p1 mean_mean_',freq_band,'_sbj',m,'_ch18_t3_p1 mean_mean_',freq_band,'_sbj',m,'_ch18_t4_p1],',...
        '[se_mean_',freq_band,'_sbj',m,'_ch18_t1_p1 se_mean_',freq_band,'_sbj',m,'_ch18_t2_p1 se_mean_',freq_band,'_sbj',m,'_ch18_t3_p1 se_mean_',freq_band,'_sbj',m,'_ch18_t4_p1],''.k'')'])
    ylim_25=get(gca,'ylim');
    set(gca,'XTick',[1:4],'XTickLabel',{'t1';'t2';'t3';'t4'})
    eval(['[p_mean_',freq_band,'_sbj',m,'_ch18_p1,table_mean_',freq_band,'_sbj',m,'_ch18_p1,stats_mean_',freq_band,'_sbj',m,...
        '_ch18_p1]=kruskalwallis([mean_',freq_band,'_sbj',m,'_ch18_t1_p1,mean_',freq_band,'_sbj',m,'_ch18_t2_p1,mean_',freq_band,'_sbj',m,'_ch18_t3_p1,mean_',freq_band,'_sbj',m,'_ch18_t4_p1],[grp_plot_25_all],''off'')'])
    if eval(['p_mean_',freq_band,'_sbj',m,'_ch18_p1'])<=0.05
        eval(['title(num2str(p_mean_',freq_band,'_sbj',m,'_ch18_p1),''Color'',[1 0 0])'])
    else
        eval(['title(num2str(p_mean_',freq_band,'_sbj',m,'_ch18_p1))'])
    end

    grps_plot_30=[2 5 8 11]
    for i=1:4
        for j=2
            eval(['mat_sz_plot_30{',num2str(i),'}=linspace(',num2str(grps_plot_30(i)),',',num2str(grps_plot_30(i)),...
            ',size_mean_',freq_band,'_sbj',m,'_ch18_t',num2str(i),'_p',num2str(j),')'])
        end
    end
    grp_plot_30_all=cat(2,mat_sz_plot_30{:});
    
    subplot(8,5,30)
    hold on
    eval(['bar([mean_mean_',freq_band,'_sbj',m,'_ch18_t1_p2 mean_mean_',freq_band,'_sbj',m,'_ch18_t2_p2 mean_mean_',freq_band,'_sbj',m,'_ch18_t3_p2 mean_mean_',freq_band,'_sbj',m,'_ch18_t4_p2])'])
    eval(['errorbar([mean_mean_',freq_band,'_sbj',m,'_ch18_t1_p2 mean_mean_',freq_band,'_sbj',m,'_ch18_t2_p2 mean_mean_',freq_band,'_sbj',m,'_ch18_t3_p2 mean_mean_',freq_band,'_sbj',m,'_ch18_t4_p2],',...
        '[se_mean_',freq_band,'_sbj',m,'_ch18_t1_p2 se_mean_',freq_band,'_sbj',m,'_ch18_t2_p2 se_mean_',freq_band,'_sbj',m,'_ch18_t3_p2 se_mean_',freq_band,'_sbj',m,'_ch18_t4_p2],''.k'')'])
    ylim_30=get(gca,'ylim');
    set(gca,'XTick',[1:4],'XTickLabel',{'t1';'t2';'t3';'t4'})
    eval(['[p_mean_',freq_band,'_sbj',m,'_ch18_p2,table_mean_',freq_band,'_sbj',m,'_ch18_p2,stats_mean_',freq_band,'_sbj',m,...
        '_ch18_p2]=kruskalwallis([mean_',freq_band,'_sbj',m,'_ch18_t1_p2,mean_',freq_band,'_sbj',m,'_ch18_t2_p2,mean_',freq_band,'_sbj',m,'_ch18_t3_p2,mean_',freq_band,'_sbj',m,'_ch18_t4_p2],[grp_plot_30_all],''off'')'])
    if eval(['p_mean_',freq_band,'_sbj',m,'_ch18_p2'])<=0.05
        eval(['title(num2str(p_mean_',freq_band,'_sbj',m,'_ch18_p2),''Color'',[1 0 0])'])
    else
        eval(['title(num2str(p_mean_',freq_band,'_sbj',m,'_ch18_p2))'])
    end

    grps_plot_35=[3 6 9 12]
    for i=1:4
        for j=3
            eval(['mat_sz_plot_35{',num2str(i),'}=linspace(',num2str(grps_plot_35(i)),',',num2str(grps_plot_35(i)),...
            ',size_mean_',freq_band,'_sbj',m,'_ch18_t',num2str(i),'_p',num2str(j),')'])
        end
    end
    grp_plot_35_all=cat(2,mat_sz_plot_35{:});
    
    subplot(8,5,35)
    hold on
    eval(['bar([mean_mean_',freq_band,'_sbj',m,'_ch18_t1_p3 mean_mean_',freq_band,'_sbj',m,'_ch18_t2_p3 mean_mean_',freq_band,'_sbj',m,'_ch18_t3_p3 mean_mean_',freq_band,'_sbj',m,'_ch18_t4_p3])'])
    eval(['errorbar([mean_mean_',freq_band,'_sbj',m,'_ch18_t1_p3 mean_mean_',freq_band,'_sbj',m,'_ch18_t2_p3 mean_mean_',freq_band,'_sbj',m,'_ch18_t3_p3 mean_mean_',freq_band,'_sbj',m,'_ch18_t4_p3],',...
        '[se_mean_',freq_band,'_sbj',m,'_ch18_t1_p3 se_mean_',freq_band,'_sbj',m,'_ch18_t2_p3 se_mean_',freq_band,'_sbj',m,'_ch18_t3_p3 se_mean_',freq_band,'_sbj',m,'_ch18_t4_p3],''.k'')'])
    ylim_35=get(gca,'ylim');
    ymin4=min([ylim_25(1) ylim_30(1) ylim_35(1)]);
    ymax4=max([ylim_25(2) ylim_30(2) ylim_35(2)]);
    set(gca,'XTick',[1:4],'XTickLabel',{'t1';'t2';'t3';'t4'})
    eval(['[p_mean_',freq_band,'_sbj',m,'_ch18_p3,table_mean_',freq_band,'_sbj',m,'_ch18_p3,stats_mean_',freq_band,'_sbj',m,...
        '_ch18_p3]=kruskalwallis([mean_',freq_band,'_sbj',m,'_ch18_t1_p3,mean_',freq_band,'_sbj',m,'_ch18_t2_p3,mean_',freq_band,'_sbj',m,'_ch18_t3_p3,mean_',freq_band,'_sbj',m,'_ch18_t4_p3],[grp_plot_35_all],''off'')'])
    if eval(['p_mean_',freq_band,'_sbj',m,'_ch18_p3'])<=0.05
        eval(['title(num2str(p_mean_',freq_band,'_sbj',m,'_ch18_p3),''Color'',[1 0 0])'])
    else
        eval(['title(num2str(p_mean_',freq_band,'_sbj',m,'_ch18_p3))'])
    end

    for i=[25 30 35]
        subplot(8,5,i)
        set(gca,'ylim',[ymin4 ymax4])
    end
    
    subplot(8,5,25)
    eval(['mc_ch18_p1=nr_multcompare_ind_tdcs_plot(stats_mean_',freq_band,'_sbj',m,'_ch18_p1,ymin4)'])
    subplot(8,5,30)
    eval(['mc_ch18_p2=nr_multcompare_ind_tdcs_plot(stats_mean_',freq_band,'_sbj',m,'_ch18_p2,ymin4)'])
    subplot(8,5,35)
    eval(['mc_ch18_p3=nr_multcompare_ind_tdcs_plot(stats_mean_',freq_band,'_sbj',m,'_ch18_p3,ymin4)'])
    
    grps_plot_36=[1 2 3]
    for i=1
        for j=1:3
            eval(['mat_sz_plot_36{',num2str(j),'}=linspace(',num2str(grps_plot_36(j)),',',num2str(grps_plot_36(j)),...
            ',size_mean_',freq_band,'_sbj',m,'_ch18_t',num2str(i),'_p',num2str(j),')'])
        end
    end
    grp_plot_36_all=cat(2,mat_sz_plot_36{:});

    subplot(8,5,36)
    hold on
    eval(['bar([mean_mean_',freq_band,'_sbj',m,'_ch18_t1_p1 mean_mean_',freq_band,'_sbj',m,'_ch18_t1_p2 mean_mean_',freq_band,'_sbj',m,'_ch18_t1_p3])'])
    eval(['errorbar([mean_mean_',freq_band,'_sbj',m,'_ch18_t1_p1 mean_mean_',freq_band,'_sbj',m,'_ch18_t1_p2 mean_mean_',freq_band,'_sbj',m,'_ch18_t1_p3],',...
        '[se_mean_',freq_band,'_sbj',m,'_ch18_t1_p1 se_mean_',freq_band,'_sbj',m,'_ch18_t1_p2 se_mean_',freq_band,'_sbj',m,'_ch18_t1_p3],''.k'')'])
    ylim_36=get(gca,'ylim');
    set(gca,'XTick',[1:3],'XTickLabel',{'h';'p';'m'})
    eval(['[p_mean_',freq_band,'_sbj',m,'_ch18_t1,table_mean_',freq_band,'_sbj',m,'_ch18_t1_new,stats_mean_',freq_band,'_sbj',m,...
        '_ch18_t1]=kruskalwallis([mean_',freq_band,'_sbj',m,'_ch18_t1_p1,mean_',freq_band,'_sbj',m,'_ch18_t1_p2,mean_',freq_band,'_sbj',m,'_ch18_t1_p3],[grp_plot_36_all],''off'')'])
    if eval(['p_mean_',freq_band,'_sbj',m,'_ch18_t1'])<=0.05
        eval(['title(num2str(p_mean_',freq_band,'_sbj',m,'_ch18_t1),''Color'',[1 0 0])'])
    else
        eval(['title(num2str(p_mean_',freq_band,'_sbj',m,'_ch18_t1))'])
    end
    
    grps_plot_37=[4 5 6]
    for i=2
        for j=1:3
            eval(['mat_sz_plot_37{',num2str(j),'}=linspace(',num2str(grps_plot_37(j)),',',num2str(grps_plot_37(j)),...
            ',size_mean_',freq_band,'_sbj',m,'_ch18_t',num2str(i),'_p',num2str(j),')'])
        end
    end
    grp_plot_37_all=cat(2,mat_sz_plot_37{:});

    subplot(8,5,37)
    hold on
    eval(['bar([mean_mean_',freq_band,'_sbj',m,'_ch18_t2_p1 mean_mean_',freq_band,'_sbj',m,'_ch18_t2_p2 mean_mean_',freq_band,'_sbj',m,'_ch18_t2_p3])'])
    eval(['errorbar([mean_mean_',freq_band,'_sbj',m,'_ch18_t2_p1 mean_mean_',freq_band,'_sbj',m,'_ch18_t2_p2 mean_mean_',freq_band,'_sbj',m,'_ch18_t2_p3],',...
        '[se_mean_',freq_band,'_sbj',m,'_ch18_t2_p1 se_mean_',freq_band,'_sbj',m,'_ch18_t2_p2 se_mean_',freq_band,'_sbj',m,'_ch18_t2_p3],''.k'')'])
    ylim_37=get(gca,'ylim');
    set(gca,'XTick',[1:3],'XTickLabel',{'h';'p';'m'})
    eval(['[p_mean_',freq_band,'_sbj',m,'_ch18_t2,table_mean_',freq_band,'_sbj',m,'_ch18_t2,stats_mean_',freq_band,'_sbj',m,...
        '_ch18_t2]=kruskalwallis([mean_',freq_band,'_sbj',m,'_ch18_t2_p1,mean_',freq_band,'_sbj',m,'_ch18_t2_p2,mean_',freq_band,'_sbj',m,'_ch18_t2_p3],[grp_plot_37_all],''off'')'])
    if eval(['p_mean_',freq_band,'_sbj',m,'_ch18_t2'])<=0.05
        eval(['title(num2str(p_mean_',freq_band,'_sbj',m,'_ch18_t2),''Color'',[1 0 0])'])
    else
        eval(['title(num2str(p_mean_',freq_band,'_sbj',m,'_ch18_t2))'])
    end
    
    grps_plot_38=[7 8 9]
    for i=3
        for j=1:3
            eval(['mat_sz_plot_38{',num2str(j),'}=linspace(',num2str(grps_plot_38(j)),',',num2str(grps_plot_38(j)),...
            ',size_mean_',freq_band,'_sbj',m,'_ch18_t',num2str(i),'_p',num2str(j),')'])
        end
    end
    grp_plot_38_all=cat(2,mat_sz_plot_38{:});

    subplot(8,5,38)
    hold on
    eval(['bar([mean_mean_',freq_band,'_sbj',m,'_ch18_t3_p1 mean_mean_',freq_band,'_sbj',m,'_ch18_t3_p2 mean_mean_',freq_band,'_sbj',m,'_ch18_t3_p3])'])
    eval(['errorbar([mean_mean_',freq_band,'_sbj',m,'_ch18_t3_p1 mean_mean_',freq_band,'_sbj',m,'_ch18_t3_p2 mean_mean_',freq_band,'_sbj',m,'_ch18_t3_p3],',...
        '[se_mean_',freq_band,'_sbj',m,'_ch18_t3_p1 se_mean_',freq_band,'_sbj',m,'_ch18_t3_p2 se_mean_',freq_band,'_sbj',m,'_ch18_t3_p3],''.k'')'])
    ylim_38=get(gca,'ylim');
    set(gca,'XTick',[1:3],'XTickLabel',{'h';'p';'m'})
    eval(['[p_mean_',freq_band,'_sbj',m,'_ch18_t3,table_mean_',freq_band,'_sbj',m,'_ch18_t3,stats_mean_',freq_band,'_sbj',m,...
        '_ch18_t3]=kruskalwallis([mean_',freq_band,'_sbj',m,'_ch18_t3_p1,mean_',freq_band,'_sbj',m,'_ch18_t3_p2,mean_',freq_band,'_sbj',m,'_ch18_t3_p3],[grp_plot_38_all],''off'')'])
    if eval(['p_mean_',freq_band,'_sbj',m,'_ch18_t3'])<=0.05
        eval(['title(num2str(p_mean_',freq_band,'_sbj',m,'_ch18_t3),''Color'',[1 0 0])'])
    else
        eval(['title(num2str(p_mean_',freq_band,'_sbj',m,'_ch18_t3))'])
    end
    
    grps_plot_39=[10 11 12]
    for i=4
        for j=1:3
            eval(['mat_sz_plot_39{',num2str(j),'}=linspace(',num2str(grps_plot_39(j)),',',num2str(grps_plot_39(j)),...
            ',size_mean_',freq_band,'_sbj',m,'_ch18_t',num2str(i),'_p',num2str(j),')'])
        end
    end
    grp_plot_39_all=cat(2,mat_sz_plot_39{:});

    subplot(8,5,39)
    hold on
    eval(['bar([mean_mean_',freq_band,'_sbj',m,'_ch18_t4_p1 mean_mean_',freq_band,'_sbj',m,'_ch18_t4_p2 mean_mean_',freq_band,'_sbj',m,'_ch18_t4_p3])'])
    eval(['errorbar([mean_mean_',freq_band,'_sbj',m,'_ch18_t4_p1 mean_mean_',freq_band,'_sbj',m,'_ch18_t4_p2 mean_mean_',freq_band,'_sbj',m,'_ch18_t4_p3],',...
        '[se_mean_',freq_band,'_sbj',m,'_ch18_t4_p1 se_mean_',freq_band,'_sbj',m,'_ch18_t4_p2 se_mean_',freq_band,'_sbj',m,'_ch18_t4_p3],''.k'')'])
    ylim_39=get(gca,'ylim');
    set(gca,'XTick',[1:3],'XTickLabel',{'h';'p';'m'})
    eval(['[p_mean_',freq_band,'_sbj',m,'_ch18_t4,table_mean_',freq_band,'_sbj',m,'_ch18_t4,stats_mean_',freq_band,'_sbj',m,...
        '_ch18_t4]=kruskalwallis([mean_',freq_band,'_sbj',m,'_ch18_t4_p1,mean_',freq_band,'_sbj',m,'_ch18_t4_p2,mean_',freq_band,'_sbj',m,'_ch18_t4_p3],[grp_plot_39_all],''off'')'])
    if eval(['p_mean_',freq_band,'_sbj',m,'_ch18_t4'])<=0.05
        eval(['title(num2str(p_mean_',freq_band,'_sbj',m,'_ch18_t4),''Color'',[1 0 0])'])
    else
        eval(['title(num2str(p_mean_',freq_band,'_sbj',m,'_ch18_t4))'])
    end

    ymin5=min([ylim_36(1) ylim_37(1) ylim_38(1) ylim_39(1)]);
    ymax5=max([ylim_36(2) ylim_37(2) ylim_38(2) ylim_39(2)]);
    for i=[36:39]
        subplot(8,5,i)
        set(gca,'ylim',[ymin5 ymax5])
    end
    
    subplot(8,5,36)
    eval(['mc_ch18_t1=nr_multcompare_ind_tdcs_plot(stats_mean_',freq_band,'_sbj',m,'_ch18_t1,ymin5)'])
    subplot(8,5,37)
    eval(['mc_ch18_t2=nr_multcompare_ind_tdcs_plot(stats_mean_',freq_band,'_sbj',m,'_ch18_t2,ymin5)'])
    subplot(8,5,38)
    eval(['mc_ch18_t3=nr_multcompare_ind_tdcs_plot(stats_mean_',freq_band,'_sbj',m,'_ch18_t3,ymin5)'])
    subplot(8,5,39)
    eval(['mc_ch18_t4=nr_multcompare_ind_tdcs_plot(stats_mean_',freq_band,'_sbj',m,'_ch18_t4,ymin5)'])
    
    if strcmp(save_fig,'yes')
        if strcmp(grp,'cs') & ismember(str2num(m),cs_stm)
            saveas(gcf,['~/nr_data_analysis/data_analyzed/eeg/gen_02/figures/gen_02_verc_ind_',grp,'_stm_',freq_band,'_sbj',m,'.fig'],'fig')
        elseif strcmp(grp,'cs') & ismember(str2num(m),cs_non)
            saveas(gcf,['~/nr_data_analysis/data_analyzed/eeg/gen_02/figures/gen_02_verc_ind_',grp,'_non_',freq_band,'_sbj',m,'.fig'],'fig')
        elseif strcmp(grp,'hc') & ismember(str2num(m),hc_stm)
            saveas(gcf,['~/nr_data_analysis/data_analyzed/eeg/gen_02/figures/gen_02_verc_ind_',grp,'_stm_',freq_band,'_sbj',m,'.fig'],'fig')
        elseif strcmp(grp,'hc') & ismember(str2num(m),hc_non)
            saveas(gcf,['~/nr_data_analysis/data_analyzed/eeg/gen_02/figures/gen_02_verc_ind_',grp,'_non_',freq_band,'_sbj',m,'.fig'],'fig')
        end
    end
    
    clear Epochcompare epochs find* grp_* mat* mc* mean_delta_* mean_theta_* mean_alpha_* mean_beta_* mean_gamma_* p_* se* si* stats* table* y*
    %stats y g tbale p_*
    %clear Epochcompare epochs
    
end

if strcmp(save_data,'yes')
        save(['~/nr_data_analysis/data_analyzed/eeg/gen_02/data/',grp,'_mean_mean_',freq_band,'_all'] ,['mean_mean_',freq_band,'*']) 
end
