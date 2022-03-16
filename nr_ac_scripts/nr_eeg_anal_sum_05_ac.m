%%
% sbjs_stm=['03';'04';'05';'42';'43'];
% elec_stm_ipsi=[7,7,18,18,7];
% elec_stm_cont=[18,18,7,7,18];
% sbjs_non=['13';'15';'17';'18';'21'];
% elec_non_ipsi=[18,7,18,18,18];
% elec_non_cont=[7,18,7,7,7];

%YOU COULD TURN THIS INTO A FUNCTION, JUST GIVE ELEC_STIM_IPSI, SBJ_NUMS,
%COHORT (cs OR hc) AND COULD EVEN GIVE A FREQ RANGE, MAYBE MAKE TITLE A BIT
%MORE SPECIFIC CS STIM SBJxx BETA, TO MAKE IT EASIER ON YOURSELF DOWN THE
%ROAD I WOULD GO AHEAD AND MAKE A FOR LOOP TO INCLUDE CH7 AND 18 SO YOU
%DON'T HAVE TO DUPLICATE THAT CODE, AND OH BTW AS INPUTS YOU NEED TO
%INCLUDE THE SUBJECT NUMBERS AS WELL, ALSO YOU MIGHT CALL ELEC_STIM_IPSI
%ELEC_STIM_LAT OR SOMETHING LIKE THA, will also need to give path

%cs
elec_stim_ipsi=[7,7,18,18,7,18,7,18,18,18]
sbj_nums=['03';'04';'05';'42';'43';'13';'15';'17';'18';'21']

% %hc
% elec_stim_ipsi=[18,7,7,7,7,18,7,18,7,7,7]
% sbj_nums=['22';'24';'25';'26';'29';'30';'20';'23';'27';'28';'36']

for n=1:10 %%%%%MUST CHANGE!!!!!
    load(['/home/rowlandn/nr_data_analysis/data_analyzed/eeg/gen_02/data/pro00087153_00',sbj_nums(n,:),'/analysis/S3-EEGanalysis/s3_dat.mat'])
    m=num2str(sbj_nums(n,:))
    
    %psd plots
    figure; set(gcf,'Position',[3 47 744 898])
    for i=1:4
        subplot(8,5,i)
        hold on
        eval(['find_freq_plot_ch7_atStartPosition=find(epochs.vrevents.t',num2str(i),'.atStartPosition.psd.freq<=100)'])
        for j=1:eval(['size(epochs.vrevents.t',num2str(i),'.atStartPosition.val,1)'])
            eval(['plot(epochs.vrevents.t',num2str(i),'.atStartPosition.psd.freq(find_freq_plot_ch7_atStartPosition),log10(epochs.vrevents.t',num2str(i),'.atStartPosition.psd.saw(find_freq_plot_ch7_atStartPosition,7,j)))'])
        end
        ylimasp=get(gca,'ylim');
        text(75,ylimasp(2)-0.1*ylimasp(2),num2str(eval(['size(epochs.vrevents.t',num2str(i),'.atStartPosition.val,1)'])))
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
        eval(['find_freq_plot_ch7_cueEvent=find(epochs.vrevents.t',num2str(i),'.cueEvent.psd.freq<=100)'])
        for j=1:eval(['size(epochs.vrevents.t',num2str(i),'.cueEvent.val,1)'])
            eval(['plot(epochs.vrevents.t',num2str(i),'.cueEvent.psd.freq(find_freq_plot_ch7_cueEvent),log10(epochs.vrevents.t',num2str(i),'.cueEvent.psd.saw(find_freq_plot_ch7_cueEvent,7,j)))'])
        end
        ylimce=get(gca,'ylim');
        text(75,ylimce(2)-0.1*ylimce(2),num2str(eval(['size(epochs.vrevents.t',num2str(i),'.cueEvent.val,1)'])))
        if i==1
            ylabel('cueEvent')
        end
        title(['t',num2str(i)])
        eval(['ylim_',num2str(i+5),'=get(gca,''ylim'');'])
    end

    for i=1:4
        subplot(8,5,i+10)
        hold on
        eval(['find_freq_plot_ch7_targetUp=find(epochs.vrevents.t',num2str(i),'.targetUp.psd.freq<=100)'])
        for j=1:eval(['size(epochs.vrevents.t',num2str(i),'.targetUp.val,1)'])
            eval(['plot(epochs.vrevents.t',num2str(i),'.targetUp.psd.freq(find_freq_plot_ch7_targetUp),log10(epochs.vrevents.t',num2str(i),'.targetUp.psd.saw(find_freq_plot_ch7_targetUp,7,j)))'])
        end
        ylimtu=get(gca,'ylim');
        text(75,ylimtu(2)-0.1*ylimtu(2),num2str(eval(['size(epochs.vrevents.t',num2str(i),'.targetUp.val,1)'])))
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
    
    %%%now start bar plots (line 106 is where you would want to put in the
    %%%frequency!!!
    phase={'atStartPosition';'cueEvent';'targetUp'}
    %mean beta (from 13-30 Hz) of each t and p combination for all reaches
    %(12 or so separate values)
    for i=1:4
        for j=1:3
            for l=1:eval(['size(epochs.vrevents.t',num2str(i),'.',phase{j},'.val,1)'])
                eval(['find_freq_beta_ch7_t',num2str(i),'_p',num2str(j),'=find(epochs.vrevents.t',num2str(i),'.',phase{j},'.psd.freq>12 & epochs.vrevents.t',num2str(i),'.',phase{j},'.psd.freq<31)'])
                eval(['mean_beta_sbj',m,'_ch7_t',num2str(i),'_p',num2str(j),'(l)=log10(mean(epochs.vrevents.t',num2str(i),'.',phase{j},...
                    '.psd.saw(find_freq_beta_ch7_t',num2str(i),'_p',num2str(j),',7,l)));'])
                eval(['size_mean_beta_sbj',m,'_ch7_t',num2str(i),'_p',num2str(j),'=size(mean_beta_sbj',m,'_ch7_t',num2str(i),'_p',num2str(j),',2)'])
            end
        end
    end
    
    %supermean of each t and p combination to get 1 value
    for i=1:4
        for j=1:3
            eval(['mean_mean_beta_sbj',m,'_ch7_t',num2str(i),'_p',num2str(j),'=mean(mean_beta_sbj',m,'_ch7_t',num2str(i),'_p',num2str(j),');'])
            eval(['se_mean_beta_sbj',m,'_ch7_t',num2str(i),'_p',num2str(j),'=std(mean_beta_sbj',m,'_ch7_t',num2str(i),'_p',num2str(j),...
                ')/sqrt(size(mean_beta_sbj',m,'_ch7_t',num2str(i),'_p',num2str(j),',2));'])
        end
    end
    
    %generate group variable for stats below
    count=0
    for i=1:4
        for j=1:3
            count=count+1         
            eval(['mat_sz_mean_ch7{',num2str(count),'}=linspace(',num2str(count),',',num2str(count),...
            ',size_mean_beta_sbj',m,'_ch7_t',num2str(i),'_p',num2str(j),')'])
        end
    end
    grp_means=cat(2,mat_sz_mean_ch7{:}); %probably don't need this bc you generate each separate one below
    
    %t1-4 for p1
    grps_plot_05=[1 4 7 10] %don't remember how I came up with these indices 1,4,7,10 but I do remember it was necessary to assign each mean a unique #
    for i=1:4
        for j=1
            eval(['mat_sz_plot_05{',num2str(i),'}=linspace(',num2str(grps_plot_05(i)),',',num2str(grps_plot_05(i)),...
            ',size_mean_beta_sbj',m,'_ch7_t',num2str(i),'_p',num2str(j),')'])
        end
    end
    grp_plot_05_all=cat(2,mat_sz_plot_05{:});
    
    subplot(8,5,5)
    hold on
    eval(['bar([mean_mean_beta_sbj',m,'_ch7_t1_p1 mean_mean_beta_sbj',m,'_ch7_t2_p1 mean_mean_beta_sbj',m,'_ch7_t3_p1 mean_mean_beta_sbj',m,'_ch7_t4_p1])'])
    eval(['errorbar([mean_mean_beta_sbj',m,'_ch7_t1_p1 mean_mean_beta_sbj',m,'_ch7_t2_p1 mean_mean_beta_sbj',m,'_ch7_t3_p1 mean_mean_beta_sbj',m,'_ch7_t4_p1],',...
        '[se_mean_beta_sbj',m,'_ch7_t1_p1 se_mean_beta_sbj',m,'_ch7_t2_p1 se_mean_beta_sbj',m,'_ch7_t3_p1 se_mean_beta_sbj',m,'_ch7_t4_p1],''.k'')'])
    ylim_5=get(gca,'ylim');
    set(gca,'XTick',[1:4],'XTickLabel',{'t1';'t2';'t3';'t4'})
    eval(['[p_mean_beta_sbj',m,'_ch7_p1,table_mean_beta_sbj',m,'_ch7_p1,stats_mean_beta_sbj',m,...
        '_ch7_p1]=kruskalwallis([mean_beta_sbj',m,'_ch7_t1_p1,mean_beta_sbj',m,'_ch7_t2_p1,mean_beta_sbj',m,'_ch7_t3_p1,mean_beta_sbj',m,'_ch7_t4_p1],[grp_plot_05_all],''off'')'])
    if eval(['p_mean_beta_sbj',m,'_ch7_p1'])<=0.05
        eval(['title(num2str(p_mean_beta_sbj',m,'_ch7_p1),''Color'',[1 0 0])'])
    else
        eval(['title(num2str(p_mean_beta_sbj',m,'_ch7_p1))'])
    end
        
    %t1-4 for p2
    grps_plot_10=[2 5 8 11]
    for i=1:4
        for j=2
            eval(['mat_sz_plot_10{',num2str(i),'}=linspace(',num2str(grps_plot_10(i)),',',num2str(grps_plot_10(i)),...
            ',size_mean_beta_sbj',m,'_ch7_t',num2str(i),'_p',num2str(j),')'])
        end
    end
    grp_plot_10_all=cat(2,mat_sz_plot_10{:});

    subplot(8,5,10)
    hold on
    eval(['bar([mean_mean_beta_sbj',m,'_ch7_t1_p2 mean_mean_beta_sbj',m,'_ch7_t2_p2 mean_mean_beta_sbj',m,'_ch7_t3_p2 mean_mean_beta_sbj',m,'_ch7_t4_p2])'])
    eval(['errorbar([mean_mean_beta_sbj',m,'_ch7_t1_p2 mean_mean_beta_sbj',m,'_ch7_t2_p2 mean_mean_beta_sbj',m,'_ch7_t3_p2 mean_mean_beta_sbj',m,'_ch7_t4_p2],',...
        '[se_mean_beta_sbj',m,'_ch7_t1_p2 se_mean_beta_sbj',m,'_ch7_t2_p2 se_mean_beta_sbj',m,'_ch7_t3_p2 se_mean_beta_sbj',m,'_ch7_t4_p2],''.k'')'])
    ylim_10=get(gca,'ylim');
    set(gca,'XTick',[1:4],'XTickLabel',{'t1';'t2';'t3';'t4'})
    eval(['[p_mean_beta_sbj',m,'_ch7_p2,table_mean_beta_sbj',m,'_ch7_p2,stats_mean_beta_sbj',m,...
        '_ch7_p2]=kruskalwallis([mean_beta_sbj',m,'_ch7_t1_p2,mean_beta_sbj',m,'_ch7_t2_p2,mean_beta_sbj',m,'_ch7_t3_p2,mean_beta_sbj',m,'_ch7_t4_p2],[grp_plot_10_all],''off'')'])
    if eval(['p_mean_beta_sbj',m,'_ch7_p2'])<=0.05
        eval(['title(num2str(p_mean_beta_sbj',m,'_ch7_p2),''Color'',[1 0 0])'])
    else
        eval(['title(num2str(p_mean_beta_sbj',m,'_ch7_p2))'])
    end
        
    %t1-4 for p3
    grps_plot_15=[3 6 9 12]
    for i=1:4
        for j=3
            eval(['mat_sz_plot_15{',num2str(i),'}=linspace(',num2str(grps_plot_15(i)),',',num2str(grps_plot_15(i)),...
            ',size_mean_beta_sbj',m,'_ch7_t',num2str(i),'_p',num2str(j),')'])
        end
    end
    grp_plot_15_all=cat(2,mat_sz_plot_15{:});

    subplot(8,5,15)
    hold on
    eval(['bar([mean_mean_beta_sbj',m,'_ch7_t1_p3 mean_mean_beta_sbj',m,'_ch7_t2_p3 mean_mean_beta_sbj',m,'_ch7_t3_p3 mean_mean_beta_sbj',m,'_ch7_t4_p3])'])
    eval(['errorbar([mean_mean_beta_sbj',m,'_ch7_t1_p3 mean_mean_beta_sbj',m,'_ch7_t2_p3 mean_mean_beta_sbj',m,'_ch7_t3_p3 mean_mean_beta_sbj',m,'_ch7_t4_p3],',...
        '[se_mean_beta_sbj',m,'_ch7_t1_p3 se_mean_beta_sbj',m,'_ch7_t2_p3 se_mean_beta_sbj',m,'_ch7_t3_p3 se_mean_beta_sbj',m,'_ch7_t4_p3],''.k'')'])
    ylim_15=get(gca,'ylim');
    ymin2=min([ylim_5(1) ylim_10(1) ylim_15(1)]);
    ymax2=max([ylim_5(2) ylim_10(2) ylim_15(2)]);
    set(gca,'XTick',[1:4],'XTickLabel',{'t1';'t2';'t3';'t4'})
    eval(['[p_mean_beta_sbj',m,'_ch7_p3,table_mean_beta_sbj',m,'_ch7_p3,stats_mean_beta_sbj',m,...
        '_ch7_p3]=kruskalwallis([mean_beta_sbj',m,'_ch7_t1_p3,mean_beta_sbj',m,'_ch7_t2_p3,mean_beta_sbj',m,'_ch7_t3_p3,mean_beta_sbj',m,'_ch7_t4_p3],[grp_plot_15_all],''off'')'])
    if eval(['p_mean_beta_sbj',m,'_ch7_p3'])<=0.05
        eval(['title(num2str(p_mean_beta_sbj',m,'_ch7_p3),''Color'',[1 0 0])'])
    else
        eval(['title(num2str(p_mean_beta_sbj',m,'_ch7_p3))'])
    end

    for i=[5 10 15]
        subplot(8,5,i)
        set(gca,'ylim',[ymin2 ymax2])
    end
    
    subplot(8,5,5)
    eval(['nr_multcompare_ind_tdcs_plot(stats_mean_beta_sbj',m,'_ch7_p1,ymin2)'])
    subplot(8,5,10)
    eval(['nr_multcompare_ind_tdcs_plot(stats_mean_beta_sbj',m,'_ch7_p2,ymin2)'])
    subplot(8,5,15)
    eval(['nr_multcompare_ind_tdcs_plot(stats_mean_beta_sbj',m,'_ch7_p3,ymin2)'])
    
    %p1-3 for t1
    grps_plot_16=[1 2 3]
    for i=1
        for j=1:3
            eval(['mat_sz_plot_16{',num2str(j),'}=linspace(',num2str(grps_plot_16(j)),',',num2str(grps_plot_16(j)),...
            ',size_mean_beta_sbj',m,'_ch7_t',num2str(i),'_p',num2str(j),')'])
        end
    end
    grp_plot_16_all=cat(2,mat_sz_plot_16{:});

    subplot(8,5,16)
    hold on
    eval(['bar([mean_mean_beta_sbj',m,'_ch7_t1_p1 mean_mean_beta_sbj',m,'_ch7_t1_p2 mean_mean_beta_sbj',m,'_ch7_t1_p3])'])
    eval(['errorbar([mean_mean_beta_sbj',m,'_ch7_t1_p1 mean_mean_beta_sbj',m,'_ch7_t1_p2 mean_mean_beta_sbj',m,'_ch7_t1_p3],',...
        '[se_mean_beta_sbj',m,'_ch7_t1_p1 se_mean_beta_sbj',m,'_ch7_t1_p2 se_mean_beta_sbj',m,'_ch7_t1_p3],''.k'')'])
    ylim_16=get(gca,'ylim');
    set(gca,'XTick',[1:3],'XTickLabel',{'h';'p';'m'})
    eval(['[p_mean_beta_sbj',m,'_ch7_t1,table_mean_beta_sbj',m,'_ch7_t1,stats_mean_beta_sbj',m,...
        '_ch7_t1]=kruskalwallis([mean_beta_sbj',m,'_ch7_t1_p1,mean_beta_sbj',m,'_ch7_t1_p2,mean_beta_sbj',m,'_ch7_t1_p3],[grp_plot_16_all],''off'')'])
    if eval(['p_mean_beta_sbj',m,'_ch7_t1'])<=0.05
        eval(['title(num2str(p_mean_beta_sbj',m,'_ch7_t1),''Color'',[1 0 0])'])
    else
        eval(['title(num2str(p_mean_beta_sbj',m,'_ch7_t1))'])
    end

    %p1-3 for t2
    grps_plot_17=[4 5 6]
    for i=2
        for j=1:3
            eval(['mat_sz_plot_17{',num2str(j),'}=linspace(',num2str(grps_plot_17(j)),',',num2str(grps_plot_17(j)),...
            ',size_mean_beta_sbj',m,'_ch7_t',num2str(i),'_p',num2str(j),')'])
        end
    end
    grp_plot_17_all=cat(2,mat_sz_plot_17{:});
    
    subplot(8,5,17)
    hold on
    eval(['bar([mean_mean_beta_sbj',m,'_ch7_t2_p1 mean_mean_beta_sbj',m,'_ch7_t2_p2 mean_mean_beta_sbj',m,'_ch7_t2_p3 ])'])
    eval(['errorbar([mean_mean_beta_sbj',m,'_ch7_t2_p1 mean_mean_beta_sbj',m,'_ch7_t2_p2 mean_mean_beta_sbj',m,'_ch7_t2_p3],',...
        '[se_mean_beta_sbj',m,'_ch7_t2_p1 se_mean_beta_sbj',m,'_ch7_t2_p2 se_mean_beta_sbj',m,'_ch7_t2_p3],''.k'')'])
    ylim_17=get(gca,'ylim');
    set(gca,'XTick',[1:3],'XTickLabel',{'h';'p';'m'})
    eval(['[p_mean_beta_sbj',m,'_ch7_t2,table_mean_beta_sbj',m,'_ch7_t2,stats_mean_beta_sbj',m,...
        '_ch7_t2]=kruskalwallis([mean_beta_sbj',m,'_ch7_t2_p1,mean_beta_sbj',m,'_ch7_t2_p2,mean_beta_sbj',m,'_ch7_t2_p3],[grp_plot_17_all],''off'')'])
    if eval(['p_mean_beta_sbj',m,'_ch7_t2'])<=0.05
        eval(['title(num2str(p_mean_beta_sbj',m,'_ch7_t2),''Color'',[1 0 0])'])
    else
        eval(['title(num2str(p_mean_beta_sbj',m,'_ch7_t2))'])
    end
    
    %p1-3 for t3
    grps_plot_18=[7 8 9]
    for i=3
        for j=1:3
            eval(['mat_sz_plot_18{',num2str(j),'}=linspace(',num2str(grps_plot_18(j)),',',num2str(grps_plot_18(j)),...
            ',size_mean_beta_sbj',m,'_ch7_t',num2str(i),'_p',num2str(j),')'])
        end
    end
    grp_plot_18_all=cat(2,mat_sz_plot_18{:});

    subplot(8,5,18)
    hold on
    eval(['bar([mean_mean_beta_sbj',m,'_ch7_t3_p1 mean_mean_beta_sbj',m,'_ch7_t3_p2 mean_mean_beta_sbj',m,'_ch7_t3_p3])'])
    eval(['errorbar([mean_mean_beta_sbj',m,'_ch7_t3_p1 mean_mean_beta_sbj',m,'_ch7_t3_p2 mean_mean_beta_sbj',m,'_ch7_t3_p3],',...
        '[se_mean_beta_sbj',m,'_ch7_t3_p1 se_mean_beta_sbj',m,'_ch7_t3_p2 se_mean_beta_sbj',m,'_ch7_t3_p3],''.k'')'])
    ylim_18=get(gca,'ylim');
    set(gca,'XTick',[1:3],'XTickLabel',{'h';'p';'m'})
    eval(['[p_mean_beta_sbj',m,'_ch7_t3,table_mean_beta_sbj',m,'_ch7_t3,stats_mean_beta_sbj',m,...
        '_ch7_t3]=kruskalwallis([mean_beta_sbj',m,'_ch7_t3_p1,mean_beta_sbj',m,'_ch7_t3_p2,mean_beta_sbj',m,'_ch7_t3_p3],[grp_plot_18_all],''off'')'])
    if eval(['p_mean_beta_sbj',m,'_ch7_t3'])<=0.05
        eval(['title(num2str(p_mean_beta_sbj',m,'_ch7_t3),''Color'',[1 0 0])'])
    else
        eval(['title(num2str(p_mean_beta_sbj',m,'_ch7_t3))'])
    end
    
    %p1-3 for t4
    grps_plot_19=[10 11 12]
    for i=4
        for j=1:3
            eval(['mat_sz_plot_19{',num2str(j),'}=linspace(',num2str(grps_plot_19(j)),',',num2str(grps_plot_19(j)),...
            ',size_mean_beta_sbj',m,'_ch7_t',num2str(i),'_p',num2str(j),')'])
        end
    end
    grp_plot_19_all=cat(2,mat_sz_plot_19{:});

    subplot(8,5,19)
    hold on
    eval(['bar([mean_mean_beta_sbj',m,'_ch7_t4_p1 mean_mean_beta_sbj',m,'_ch7_t4_p2 mean_mean_beta_sbj',m,'_ch7_t4_p3])'])
    eval(['errorbar([mean_mean_beta_sbj',m,'_ch7_t4_p1 mean_mean_beta_sbj',m,'_ch7_t4_p2 mean_mean_beta_sbj',m,'_ch7_t4_p3],',...
        '[se_mean_beta_sbj',m,'_ch7_t4_p1 se_mean_beta_sbj',m,'_ch7_t4_p2 se_mean_beta_sbj',m,'_ch7_t4_p3],''.k'')'])
    ylim_19=get(gca,'ylim');
    set(gca,'XTick',[1:3],'XTickLabel',{'h';'p';'m'})
    eval(['[p_mean_beta_sbj',m,'_ch7_t4,table_mean_beta_sbj',m,'_ch7_t4,stats_mean_beta_sbj',m,...
        '_ch7_t4]=kruskalwallis([mean_beta_sbj',m,'_ch7_t4_p1,mean_beta_sbj',m,'_ch7_t4_p2,mean_beta_sbj',m,'_ch7_t4_p3],[grp_plot_19_all],''off'')'])
    if eval(['p_mean_beta_sbj',m,'_ch7_t4'])<=0.05
        eval(['title(num2str(p_mean_beta_sbj',m,'_ch7_t4),''Color'',[1 0 0])'])
    else
        eval(['title(num2str(p_mean_beta_sbj',m,'_ch7_t4))'])
    end

    ymin3=min([ylim_16(1) ylim_17(1) ylim_18(1) ylim_19(1)]);
    ymax3=max([ylim_16(2) ylim_17(2) ylim_18(2) ylim_19(2)]);
    for i=[16:19]
        subplot(8,5,i)
        set(gca,'ylim',[ymin3 ymax3])
    end

    subplot(8,5,16)
    eval(['nr_multcompare_ind_tdcs_plot(stats_mean_beta_sbj',m,'_ch7_t1,ymin3)'])
    subplot(8,5,17)
    eval(['nr_multcompare_ind_tdcs_plot(stats_mean_beta_sbj',m,'_ch7_t2,ymin3)'])
    subplot(8,5,18)
    eval(['nr_multcompare_ind_tdcs_plot(stats_mean_beta_sbj',m,'_ch7_t3,ymin3)'])
    subplot(8,5,19)
    eval(['nr_multcompare_ind_tdcs_plot(stats_mean_beta_sbj',m,'_ch7_t4,ymin3)'])


    %ch18
    %psd plots
    for i=1:4
        subplot(8,5,i+20)
        hold on
        eval(['find_freq_plot_ch18_atStartPosition=find(epochs.vrevents.t',num2str(i),'.atStartPosition.psd.freq<=100)'])
        for j=1:eval(['size(epochs.vrevents.t',num2str(i),'.atStartPosition.val,1)'])
            eval(['plot(epochs.vrevents.t',num2str(i),'.atStartPosition.psd.freq(find_freq_plot_ch18_atStartPosition),log10(epochs.vrevents.t',num2str(i),'.atStartPosition.psd.saw(find_freq_plot_ch18_atStartPosition,18,j)))'])
        end
        ylimasp=get(gca,'ylim');
        text(75,ylimasp(2)-0.1*ylimasp(2),num2str(eval(['size(epochs.vrevents.t',num2str(i),'.atStartPosition.val,1)'])))
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
        eval(['find_freq_plot_ch18_cueEvent=find(epochs.vrevents.t',num2str(i),'.cueEvent.psd.freq<=100)'])
        for j=1:eval(['size(epochs.vrevents.t',num2str(i),'.cueEvent.val,1)'])
            eval(['plot(epochs.vrevents.t',num2str(i),'.cueEvent.psd.freq(find_freq_plot_ch18_cueEvent),log10(epochs.vrevents.t',num2str(i),'.cueEvent.psd.saw(find_freq_plot_ch18_cueEvent,18,j)))'])
        end
        ylimce=get(gca,'ylim');
        text(75,ylimce(2)-0.1*ylimce(2),num2str(eval(['size(epochs.vrevents.t',num2str(i),'.cueEvent.val,1)'])))
        if i==1
            ylabel('cueEvent')
        end
        title(['t',num2str(i)])
        eval(['ylim_',num2str(i+25),'=get(gca,''ylim'');'])
    end

    for i=1:4
        subplot(8,5,i+30)
        hold on
        eval(['find_freq_plot_ch18_targetUp=find(epochs.vrevents.t',num2str(i),'.targetUp.psd.freq<=100)'])
        for j=1:eval(['size(epochs.vrevents.t',num2str(i),'.targetUp.val,1)'])
            eval(['plot(epochs.vrevents.t',num2str(i),'.targetUp.psd.freq(find_freq_plot_ch18_targetUp),log10(epochs.vrevents.t',num2str(i),'.targetUp.psd.saw(find_freq_plot_ch18_targetUp,18,j)))'])
        end
        ylimtu=get(gca,'ylim');
        text(75,ylimtu(2)-0.1*ylimtu(2),num2str(eval(['size(epochs.vrevents.t',num2str(i),'.targetUp.val,1)'])))
        if i==1
            ylabel('targetUp')
        end
        title(['t',num2str(i)])
        eval(['ylim_',num2str(i+30),'=get(gca,''ylim'');'])
    end
    
    %scale psd plots
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
    
    phase={'atStartPosition';'cueEvent';'targetUp'}
    for i=1:4
        for j=1:3
            for l=1:eval(['size(epochs.vrevents.t',num2str(i),'.',phase{j},'.val,1)'])
                eval(['find_freq_beta_ch18_t',num2str(i),'_p',num2str(j),'=find(epochs.vrevents.t',num2str(i),'.',phase{j},'.psd.freq>12 & epochs.vrevents.t',num2str(i),'.',phase{j},'.psd.freq<31)'])
                eval(['mean_beta_sbj',m,'_ch18_t',num2str(i),'_p',num2str(j),'(l)=log10(mean(epochs.vrevents.t',num2str(i),'.',phase{j},...
                    '.psd.saw(find_freq_beta_ch18_t',num2str(i),'_p',num2str(j),',18,l)));'])
                eval(['size_mean_beta_sbj',m,'_ch18_t',num2str(i),'_p',num2str(j),'=size(mean_beta_sbj',m,'_ch18_t',num2str(i),'_p',num2str(j),',2)'])
            end
        end
    end
        
    for i=1:4
        for j=1:3
            eval(['mean_mean_beta_sbj',m,'_ch18_t',num2str(i),'_p',num2str(j),'=mean(mean_beta_sbj',m,'_ch18_t',num2str(i),'_p',num2str(j),');'])
            eval(['se_mean_beta_sbj',m,'_ch18_t',num2str(i),'_p',num2str(j),'=std(mean_beta_sbj',m,'_ch18_t',num2str(i),'_p',num2str(j),...
                ')/sqrt(size(mean_beta_sbj',m,'_ch18_t',num2str(i),'_p',num2str(j),',2));'])
        end
    end
    
    grps_plot_25=[1 4 7 10]
    for i=1:4
        for j=1
            eval(['mat_sz_plot_25{',num2str(i),'}=linspace(',num2str(grps_plot_25(i)),',',num2str(grps_plot_25(i)),...
            ',size_mean_beta_sbj',m,'_ch18_t',num2str(i),'_p',num2str(j),')'])
        end
    end
    grp_plot_25_all=cat(2,mat_sz_plot_25{:});
    
    subplot(8,5,25)
    hold on
    eval(['bar([mean_mean_beta_sbj',m,'_ch18_t1_p1 mean_mean_beta_sbj',m,'_ch18_t2_p1 mean_mean_beta_sbj',m,'_ch18_t3_p1 mean_mean_beta_sbj',m,'_ch18_t4_p1])'])
    eval(['errorbar([mean_mean_beta_sbj',m,'_ch18_t1_p1 mean_mean_beta_sbj',m,'_ch18_t2_p1 mean_mean_beta_sbj',m,'_ch18_t3_p1 mean_mean_beta_sbj',m,'_ch18_t4_p1],',...
        '[se_mean_beta_sbj',m,'_ch18_t1_p1 se_mean_beta_sbj',m,'_ch18_t2_p1 se_mean_beta_sbj',m,'_ch18_t3_p1 se_mean_beta_sbj',m,'_ch18_t4_p1],''.k'')'])
    ylim_25=get(gca,'ylim');
    set(gca,'XTick',[1:4],'XTickLabel',{'t1';'t2';'t3';'t4'})
    eval(['[p_mean_beta_sbj',m,'_ch18_p1,table_mean_beta_sbj',m,'_ch18_p1,stats_mean_beta_sbj',m,...
        '_ch18_p1]=kruskalwallis([mean_beta_sbj',m,'_ch18_t1_p1,mean_beta_sbj',m,'_ch18_t2_p1,mean_beta_sbj',m,'_ch18_t3_p1,mean_beta_sbj',m,'_ch18_t4_p1],[grp_plot_25_all],''off'')'])
    if eval(['p_mean_beta_sbj',m,'_ch18_p1'])<=0.05
        eval(['title(num2str(p_mean_beta_sbj',m,'_ch18_p1),''Color'',[1 0 0])'])
    else
        eval(['title(num2str(p_mean_beta_sbj',m,'_ch18_p1))'])
    end

    grps_plot_30=[2 5 8 11]
    for i=1:4
        for j=2
            eval(['mat_sz_plot_30{',num2str(i),'}=linspace(',num2str(grps_plot_30(i)),',',num2str(grps_plot_30(i)),...
            ',size_mean_beta_sbj',m,'_ch18_t',num2str(i),'_p',num2str(j),')'])
        end
    end
    grp_plot_30_all=cat(2,mat_sz_plot_30{:});
    
    subplot(8,5,30)
    hold on
    eval(['bar([mean_mean_beta_sbj',m,'_ch18_t1_p2 mean_mean_beta_sbj',m,'_ch18_t2_p2 mean_mean_beta_sbj',m,'_ch18_t3_p2 mean_mean_beta_sbj',m,'_ch18_t4_p2])'])
    eval(['errorbar([mean_mean_beta_sbj',m,'_ch18_t1_p2 mean_mean_beta_sbj',m,'_ch18_t2_p2 mean_mean_beta_sbj',m,'_ch18_t3_p2 mean_mean_beta_sbj',m,'_ch18_t4_p2],',...
        '[se_mean_beta_sbj',m,'_ch18_t1_p2 se_mean_beta_sbj',m,'_ch18_t2_p2 se_mean_beta_sbj',m,'_ch18_t3_p2 se_mean_beta_sbj',m,'_ch18_t4_p2],''.k'')'])
    ylim_30=get(gca,'ylim');
    set(gca,'XTick',[1:4],'XTickLabel',{'t1';'t2';'t3';'t4'})
    eval(['[p_mean_beta_sbj',m,'_ch18_p2,table_mean_beta_sbj',m,'_ch18_p2,stats_mean_beta_sbj',m,...
        '_ch18_p2]=kruskalwallis([mean_beta_sbj',m,'_ch18_t1_p2,mean_beta_sbj',m,'_ch18_t2_p2,mean_beta_sbj',m,'_ch18_t3_p2,mean_beta_sbj',m,'_ch18_t4_p2],[grp_plot_30_all],''off'')'])
    if eval(['p_mean_beta_sbj',m,'_ch18_p2'])<=0.05
        eval(['title(num2str(p_mean_beta_sbj',m,'_ch18_p2),''Color'',[1 0 0])'])
    else
        eval(['title(num2str(p_mean_beta_sbj',m,'_ch18_p2))'])
    end

    grps_plot_35=[3 6 9 12]
    for i=1:4
        for j=3
            eval(['mat_sz_plot_35{',num2str(i),'}=linspace(',num2str(grps_plot_35(i)),',',num2str(grps_plot_35(i)),...
            ',size_mean_beta_sbj',m,'_ch18_t',num2str(i),'_p',num2str(j),')'])
        end
    end
    grp_plot_35_all=cat(2,mat_sz_plot_35{:});
    
    subplot(8,5,35)
    hold on
    eval(['bar([mean_mean_beta_sbj',m,'_ch18_t1_p3 mean_mean_beta_sbj',m,'_ch18_t2_p3 mean_mean_beta_sbj',m,'_ch18_t3_p3 mean_mean_beta_sbj',m,'_ch18_t4_p3])'])
    eval(['errorbar([mean_mean_beta_sbj',m,'_ch18_t1_p3 mean_mean_beta_sbj',m,'_ch18_t2_p3 mean_mean_beta_sbj',m,'_ch18_t3_p3 mean_mean_beta_sbj',m,'_ch18_t4_p3],',...
        '[se_mean_beta_sbj',m,'_ch18_t1_p3 se_mean_beta_sbj',m,'_ch18_t2_p3 se_mean_beta_sbj',m,'_ch18_t3_p3 se_mean_beta_sbj',m,'_ch18_t4_p3],''.k'')'])
    ylim_35=get(gca,'ylim');
    ymin4=min([ylim_25(1) ylim_30(1) ylim_35(1)]);
    ymax4=max([ylim_25(2) ylim_30(2) ylim_35(2)]);
    set(gca,'XTick',[1:4],'XTickLabel',{'t1';'t2';'t3';'t4'})
    eval(['[p_mean_beta_sbj',m,'_ch18_p3,table_mean_beta_sbj',m,'_ch18_p3,stats_mean_beta_sbj',m,...
        '_ch18_p3]=kruskalwallis([mean_beta_sbj',m,'_ch18_t1_p3,mean_beta_sbj',m,'_ch18_t2_p3,mean_beta_sbj',m,'_ch18_t3_p3,mean_beta_sbj',m,'_ch18_t4_p3],[grp_plot_35_all],''off'')'])
    if eval(['p_mean_beta_sbj',m,'_ch18_p3'])<=0.05
        eval(['title(num2str(p_mean_beta_sbj',m,'_ch18_p3),''Color'',[1 0 0])'])
    else
        eval(['title(num2str(p_mean_beta_sbj',m,'_ch18_p3))'])
    end

    for i=[25 30 35]
        subplot(8,5,i)
        set(gca,'ylim',[ymin4 ymax4])
    end
    
    subplot(8,5,25)
    eval(['nr_multcompare_ind_tdcs_plot(stats_mean_beta_sbj',m,'_ch18_p1,ymin4)'])
    subplot(8,5,30)
    eval(['nr_multcompare_ind_tdcs_plot(stats_mean_beta_sbj',m,'_ch18_p2,ymin4)'])
    subplot(8,5,35)
    eval(['nr_multcompare_ind_tdcs_plot(stats_mean_beta_sbj',m,'_ch18_p3,ymin4)'])
    
    grps_plot_36=[1 2 3]
    for i=1
        for j=1:3
            eval(['mat_sz_plot_36{',num2str(j),'}=linspace(',num2str(grps_plot_36(j)),',',num2str(grps_plot_36(j)),...
            ',size_mean_beta_sbj',m,'_ch18_t',num2str(i),'_p',num2str(j),')'])
        end
    end
    grp_plot_36_all=cat(2,mat_sz_plot_36{:});

    subplot(8,5,36)
    hold on
    eval(['bar([mean_mean_beta_sbj',m,'_ch18_t1_p1 mean_mean_beta_sbj',m,'_ch18_t1_p2 mean_mean_beta_sbj',m,'_ch18_t1_p3])'])
    eval(['errorbar([mean_mean_beta_sbj',m,'_ch18_t1_p1 mean_mean_beta_sbj',m,'_ch18_t1_p2 mean_mean_beta_sbj',m,'_ch18_t1_p3],',...
        '[se_mean_beta_sbj',m,'_ch18_t1_p1 se_mean_beta_sbj',m,'_ch18_t1_p2 se_mean_beta_sbj',m,'_ch18_t1_p3],''.k'')'])
    ylim_36=get(gca,'ylim');
    set(gca,'XTick',[1:3],'XTickLabel',{'h';'p';'m'})
    eval(['[p_mean_beta_sbj',m,'_ch18_t1,table_mean_beta_sbj',m,'_ch18_t1_new,stats_mean_beta_sbj',m,...
        '_ch18_t1]=kruskalwallis([mean_beta_sbj',m,'_ch18_t1_p1,mean_beta_sbj',m,'_ch18_t1_p2,mean_beta_sbj',m,'_ch18_t1_p3],[grp_plot_36_all],''off'')'])
    if eval(['p_mean_beta_sbj',m,'_ch18_t1'])<=0.05
        eval(['title(num2str(p_mean_beta_sbj',m,'_ch18_t1),''Color'',[1 0 0])'])
    else
        eval(['title(num2str(p_mean_beta_sbj',m,'_ch18_t1))'])
    end
    
    grps_plot_37=[4 5 6]
    for i=2
        for j=1:3
            eval(['mat_sz_plot_37{',num2str(j),'}=linspace(',num2str(grps_plot_37(j)),',',num2str(grps_plot_37(j)),...
            ',size_mean_beta_sbj',m,'_ch18_t',num2str(i),'_p',num2str(j),')'])
        end
    end
    grp_plot_37_all=cat(2,mat_sz_plot_37{:});

    subplot(8,5,37)
    hold on
    eval(['bar([mean_mean_beta_sbj',m,'_ch18_t2_p1 mean_mean_beta_sbj',m,'_ch18_t2_p2 mean_mean_beta_sbj',m,'_ch18_t2_p3])'])
    eval(['errorbar([mean_mean_beta_sbj',m,'_ch18_t2_p1 mean_mean_beta_sbj',m,'_ch18_t2_p2 mean_mean_beta_sbj',m,'_ch18_t2_p3],',...
        '[se_mean_beta_sbj',m,'_ch18_t2_p1 se_mean_beta_sbj',m,'_ch18_t2_p2 se_mean_beta_sbj',m,'_ch18_t2_p3],''.k'')'])
    ylim_37=get(gca,'ylim');
    set(gca,'XTick',[1:3],'XTickLabel',{'h';'p';'m'})
    eval(['[p_mean_beta_sbj',m,'_ch18_t2,table_mean_beta_sbj',m,'_ch18_t2,stats_mean_beta_sbj',m,...
        '_ch18_t2]=kruskalwallis([mean_beta_sbj',m,'_ch18_t2_p1,mean_beta_sbj',m,'_ch18_t2_p2,mean_beta_sbj',m,'_ch18_t2_p3],[grp_plot_37_all],''off'')'])
    if eval(['p_mean_beta_sbj',m,'_ch18_t2'])<=0.05
        eval(['title(num2str(p_mean_beta_sbj',m,'_ch18_t2),''Color'',[1 0 0])'])
    else
        eval(['title(num2str(p_mean_beta_sbj',m,'_ch18_t2))'])
    end
    
    grps_plot_38=[7 8 9]
    for i=3
        for j=1:3
            eval(['mat_sz_plot_38{',num2str(j),'}=linspace(',num2str(grps_plot_38(j)),',',num2str(grps_plot_38(j)),...
            ',size_mean_beta_sbj',m,'_ch18_t',num2str(i),'_p',num2str(j),')'])
        end
    end
    grp_plot_38_all=cat(2,mat_sz_plot_38{:});

    subplot(8,5,38)
    hold on
    eval(['bar([mean_mean_beta_sbj',m,'_ch18_t3_p1 mean_mean_beta_sbj',m,'_ch18_t3_p2 mean_mean_beta_sbj',m,'_ch18_t3_p3])'])
    eval(['errorbar([mean_mean_beta_sbj',m,'_ch18_t3_p1 mean_mean_beta_sbj',m,'_ch18_t3_p2 mean_mean_beta_sbj',m,'_ch18_t3_p3],',...
        '[se_mean_beta_sbj',m,'_ch18_t3_p1 se_mean_beta_sbj',m,'_ch18_t3_p2 se_mean_beta_sbj',m,'_ch18_t3_p3],''.k'')'])
    ylim_38=get(gca,'ylim');
    set(gca,'XTick',[1:3],'XTickLabel',{'h';'p';'m'})
    eval(['[p_mean_beta_sbj',m,'_ch18_t3,table_mean_beta_sbj',m,'_ch18_t3,stats_mean_beta_sbj',m,...
        '_ch18_t3]=kruskalwallis([mean_beta_sbj',m,'_ch18_t3_p1,mean_beta_sbj',m,'_ch18_t3_p2,mean_beta_sbj',m,'_ch18_t3_p3],[grp_plot_38_all],''off'')'])
    if eval(['p_mean_beta_sbj',m,'_ch18_t3'])<=0.05
        eval(['title(num2str(p_mean_beta_sbj',m,'_ch18_t3),''Color'',[1 0 0])'])
    else
        eval(['title(num2str(p_mean_beta_sbj',m,'_ch18_t3))'])
    end
    
    grps_plot_39=[10 11 12]
    for i=4
        for j=1:3
            eval(['mat_sz_plot_39{',num2str(j),'}=linspace(',num2str(grps_plot_39(j)),',',num2str(grps_plot_39(j)),...
            ',size_mean_beta_sbj',m,'_ch18_t',num2str(i),'_p',num2str(j),')'])
        end
    end
    grp_plot_39_all=cat(2,mat_sz_plot_39{:});

    subplot(8,5,39)
    hold on
    eval(['bar([mean_mean_beta_sbj',m,'_ch18_t4_p1 mean_mean_beta_sbj',m,'_ch18_t4_p2 mean_mean_beta_sbj',m,'_ch18_t4_p3])'])
    eval(['errorbar([mean_mean_beta_sbj',m,'_ch18_t4_p1 mean_mean_beta_sbj',m,'_ch18_t4_p2 mean_mean_beta_sbj',m,'_ch18_t4_p3],',...
        '[se_mean_beta_sbj',m,'_ch18_t4_p1 se_mean_beta_sbj',m,'_ch18_t4_p2 se_mean_beta_sbj',m,'_ch18_t4_p3],''.k'')'])
    ylim_39=get(gca,'ylim');
    set(gca,'XTick',[1:3],'XTickLabel',{'h';'p';'m'})
    eval(['[p_mean_beta_sbj',m,'_ch18_t4,table_mean_beta_sbj',m,'_ch18_t4,stats_mean_beta_sbj',m,...
        '_ch18_t4]=kruskalwallis([mean_beta_sbj',m,'_ch18_t4_p1,mean_beta_sbj',m,'_ch18_t4_p2,mean_beta_sbj',m,'_ch18_t4_p3],[grp_plot_39_all],''off'')'])
    if eval(['p_mean_beta_sbj',m,'_ch18_t4'])<=0.05
        eval(['title(num2str(p_mean_beta_sbj',m,'_ch18_t4),''Color'',[1 0 0])'])
    else
        eval(['title(num2str(p_mean_beta_sbj',m,'_ch18_t4))'])
    end

    ymin5=min([ylim_36(1) ylim_37(1) ylim_38(1) ylim_39(1)]);
    ymax5=max([ylim_36(2) ylim_37(2) ylim_38(2) ylim_39(2)]);
    for i=[36:39]
        subplot(8,5,i)
        set(gca,'ylim',[ymin5 ymax5])
    end
    
    subplot(8,5,36)
    eval(['nr_multcompare_ind_tdcs_plot(stats_mean_beta_sbj',m,'_ch18_t1,ymin5)'])
    subplot(8,5,37)
    eval(['nr_multcompare_ind_tdcs_plot(stats_mean_beta_sbj',m,'_ch18_t2,ymin5)'])
    subplot(8,5,38)
    eval(['nr_multcompare_ind_tdcs_plot(stats_mean_beta_sbj',m,'_ch18_t3,ymin5)'])
    subplot(8,5,39)
    eval(['nr_multcompare_ind_tdcs_plot(stats_mean_beta_sbj',m,'_ch18_t4,ymin5)'])
    
    clear Epochcompare epochs f* g* mat* mean_beta_* p_* se* si* stats* table* y*
    %stats y g tbale p_*
    %clear Epochcompare epochs
 end

%%

% 3) need to carefully check all coding - check red asterisks for
% multcompares that aren't significant(?), 
%should I create a checking script that can go through each subject and
%check the trial information file?? - go through your bash script to get
%all the steps
% 4) have claudia work on reconstructions
% 5) rerun all subjects with allen's newest scripts
% 7) try z-scoring, common average referencing
% also have to rerun with different stats tests completely, then customize
% to each test based on normality

%the next time you spot check p-values in spss, also check normality and
%then recheck in matlab

%things you will need to go back and check
%check allen's individual figures against yours
%check his epoch times
%how was the rest epoch decided
%I don't see a line for the end of each epoch, although there is a value
%associated with the end - where does that come from?


% Next, check code
% then learn git and reanalyze with allen's code, recheck all plots
% then next week repeat for all frequency bands so you can give matrix to
% irene and have her work on PCA
% Next, maybe work on your controls
%next,work with claudia's data
%then can do reactivity

%don;t forget to analyze 10 and 15 minute epochs for those that have them

%questions for allen
%use his sum code and find out why he did it that way

% do reactivity - beta desync and beta resync
% use movement epochs
%don't forget to do imaginary movement

% also you should look at the velocituy curves and maybe plot average stim
% vs sham and cs vs hc

%code final average plot with and without normalization
%then would have allen do similar plots
%
%do your linear regressions (also for last analysis you were running)

%after that, want to pursue your controls:
%make sure you have removed bad trials

%filter for beta only
%try eeglab + fieldtrip
%do pca for other freq bands and also other channels
%do reactivity and coherence
%
%sunday
%generate individual, summary and linear regression plots - go through them
%in detail or at least just see if you still have significance
%match each individual plot with all of allen's 16 individual plots and see
%if they make sense
% make sure to use s2 epochs for ind plots - see if that one subject still has 45 reaches
% look closely into rejected trials - how is numbering changed? - make sure
% psd's that look weird match rejected trials and vice versa - look at the
% raw data for each epoch
%look into sawtooth psd's - figure out what to do with them
% match figures of tdcs stim with stim or sham
% check actual epochs in raw data with that one large figure that allen
% generates against epochs in variable
% check p values in spss
% make the file matching script to make sure the correct folders are saved
% with the correct subject names and vr files etc

% btw, still need to fix that box around 'corrected' on the lr plots, need
% to fix the sbj legend on the sum plots, need to fix the red lettering for
% nonsignificant p-values and need to not run mc for nonsignificant
% p-values



% paper
% validation of vr task
% see if velocity curves match FMA scores
           
%% sum fig

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

% hc
% sbjs_stm=['22';'24';'25';'26';'29';'30'];
% elec_stm_ipsi=[18,7,7,7,7,18];
% elec_stm_cont=[7,18,18,18,18,7];
% sbjs_non=['20';'23';'27';'28';'36'];
% elec_non_ipsi=[7,18,7,7,7];
% elec_non_cont=[18,7,18,18,18];
% phase={'atStartPosition';'cueEvent';'targetUp'};
% 

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

clear anovatab* find* mean_mean_mean_* mean_mean_beta* p* psd* se* stats* ylim*






                
                
                
                
                
                
                
                
                