function step_03_nr_ac_eeg_anal_ser_ind_freq_plots_v01d(sbjs,filt,freq_band,epoch_type,version,date_str,save_fig,save_data)



% 7/3/22
%things we accomplished up to this point
% For this function, I've changed a few of the variables to make it a bit
% easier to run.
% changed beta to be any freq band btn alpha and gamma,
%i think Allen put the opposite sides for 42 and 43 so I manually change
%them here without changing the actual sessioninfo variable (confirmed by
%looking at the original videos)
% For gen_02, I first changed the epoch type to vrevents (vr events is just
% 1 second of data after the start of the event whereas epochswhole is the 
% entire event), and compared these to epochsWhole
% (confirming they are slightly different but have the same general pattern
% of significance), then saved these plots as version d along with the data separately
% Also for gen_02, sbj3's outliers had been overwritten so I regenerated
% these and in the process refamiliarized myself with that script in case
% its needed later on (renamed it step_02a)
% I transferred all the epoch outlier variables to the gen_03 s3_dat
% variables and reran all the plots with both epochsWhole and vr events,
% compared them to the gen_02 versions (verc), and saved all plots and all data
% separately under gen_03. Note that the psd's for 42 and 43 for gen_03
% were generated differently (still not exactly sure in what way) but I do
% think they were done correctly so I left them that way. after extensive
%checking, all other subjects appear to be identical btn gen_02 and gen_03
% now time to move on to the sum analyses

%8/28/22
% cleaned code up just a bit. Tried to match the icoh analyses more but
% still not identical. Saved to different folder. And I agree 42 and 43 look
% different than all other versions but appears to have been done correctly so
% I think this is a stable version .

%9/2/22
%adding rest epochs




% grp='cs'
% sbjs='03'
% save_fig='no';
% save_data='no';
% freq_band='alpha';
% epoch_type='epochsWhole';
% version='f';
% date_str='2022_09_05';

if strcmp(epoch_type,'epochsWhole')
    labl='ew';
elseif strcmp(epoch_type,'vrevents')
    labl='vr';
end

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


% cs_stm=[3,4,5,42,43]
% cs_non=[13,15,17,18,21]
% hc_stm=[22,24,25,26,29,30]
% hc_non=[20,23,27,28,36]

out_ind_c18_p0=[1 2 3 4];%we will call p0 rest
out_ind_c18_p1=[1 4 7 10];
out_ind_c18_p2=[2 5 8 11];
out_ind_c18_p3=[3 6 9 12];
out_ind_c7_p0=[5 6 7 8];%these are backwards bc ch 18 was processed first
out_ind_c7_p1=[13 16 19 22];%these are backwards bc ch 18 was processed first
out_ind_c7_p2=[14 17 20 23];%so ch18 is 1-12 (i.e., t1*3 phases, t2*3 phases and so on)
out_ind_c7_p3=[15 18 21 24];%followed by ch7 which makes 24 (even though ch7 is plotted 
%on top of 18)
phase={'atStartPosition';'cueEvent';'targetUp'};

sbjs_all=['03';'04';'05';'42';'43';'13';'15';'17';'18';'21';'22';'24';'25';'26';'29';'30';'20';'23';'27';'28';'36'];
sbjs_all_cell={'03';'04';'05';'42';'43';'13';'15';'17';'18';'21';'22';'24';'25';'26';'29';'30';'20';'23';'27';'28';'36'};

if strcmp(sbjs,'all')
    sbjs_all=sbjs_all;
else
    sbj_find=strfind(sbjs_all_cell,sbjs);
    for i=1:size(sbj_find,1)
        if isempty(sbj_find{i})
        else
            find_sbj_find(i)=find(sbj_find{i})
        end
    end
    sbjs_ind=find(find_sbj_find);
    sbjs_all=sbjs_all(sbjs_ind,:);
end

for n=1:size(sbjs_all,1)
    if strcmp(filt,'no')
        load(['/home/rowlandn/nr_data_analysis/data_analyzed/eeg/gen_03/data/pro00087153_00',sbjs_all(n,:),...
            '/analysis/S3-EEGanalysis/s3_dat.mat'])
        load(['/home/rowlandn/nr_data_analysis/data_analyzed/eeg/gen_03/data/pro00087153_00',sbjs_all(n,:),...
            '/analysis/S3-EEGanalysis/s3_dat_rest.mat'])
    elseif strcmp(filt,'yes')
        load(['/home/rowlandn/nr_data_analysis/data_analyzed/eeg/gen_03/data/pro00087153_00',sbjs_all(n,:),...
            '/analysis/S3-EEGanalysis/s3_dat_filt.mat'])
        load(['/home/rowlandn/nr_data_analysis/data_analyzed/eeg/gen_03/data/pro00087153_00',sbjs_all(n,:),...
            '/analysis/S3-EEGanalysis/s3_dat_filt_rest.mat'])
    end
            
    load(['/home/rowlandn/nr_data_analysis/data_analyzed/data_for_dlc/pro00087153_00',sbjs_all(n,:),...
        '_sessioninfo.mat'])
    if n==4
        sessioninfo.stimlat='R';
    end
    if n==5
        sessioninfo.stimlat='L';
    end
%     load(['/home/rowlandn/nr_data_analysis/data_analyzed/eeg/gen_03/data/pro00087153_00',sbjs_all(n,:),...
%         '/analysis/S3-EEGanalysis/s3_dat.mat'])
    m=num2str(sbjs_all(n,:));
    
   
    %psd plots
    %figure; set(gcf,'Position',[786 47 744 898])
    figure; set(gcf,'Position',[534 -93 754 891])
    for i=1:4
        subplot(10,5,i)
        hold on
        eval(['find_freq_plot_ch7_atRest=find(epochs_rest.rest2.t',num2str(i),'.psd.freq<=100);'])
        for j=eval(['pro00087153_00',num2str(sbjs_all(n,:)),'_gen_03_ver_',version,'_rest_epochs_wo_outliers_',freq_band,'{out_ind_c7_p0(i)}'])
            eval(['plot(epochs_rest.rest2.t',num2str(i),'.psd.freq(find_freq_plot_ch7_atRest),log10(epochs_rest.rest2.t',num2str(i),'.psd.saw(find_freq_plot_ch7_atRest,7,j)))'])
        end
        ylimasp=get(gca,'ylim');
        text(75,ylimasp(2)-0.1*ylimasp(2),num2str(eval(['size(pro00087153_00',num2str(sbjs_all(n,:)),'_gen_03_ver_',version,'_rest_epochs_wo_outliers_',freq_band,'{out_ind_c7_p0(i)},2)'])))
        if i==1 & strcmp(sessioninfo.stimlat,'L')==1 
            ylabel('Rest')
            title(['Sbj',m(1,:),':ch7:t',num2str(i),':',freq_band,':',labl,':ver ',version],'Color',[1 0 0])
        elseif i==1 & strcmp(sessioninfo.stimlat,'L')~=1 
            ylabel('Rest')
            title(['Sbj',m(1,:),':ch7:t',num2str(i),':',freq_band,':',labl,':ver ',version])
        else
            title(['t',num2str(i)])
        end
        eval(['ylim_',num2str(i),'=get(gca,''ylim'');'])
    end
    
    for i=1:4
        subplot(10,5,i+5)
        hold on
        eval(['find_freq_plot_ch7_atStartPosition=find(epochs.',epoch_type,'.t',num2str(i),'.atStartPosition.psd.freq<=100);'])
        for j=eval(['pro00087153_00',num2str(sbjs_all(n,:)),'_gen_03_ver_',version,'_reaches_wo_outliers_',freq_band,'{out_ind_c7_p1(i)}'])
            eval(['plot(epochs.',epoch_type,'.t',num2str(i),'.atStartPosition.psd.freq(find_freq_plot_ch7_atStartPosition),log10(epochs.',epoch_type,'.t',num2str(i),'.atStartPosition.psd.saw(find_freq_plot_ch7_atStartPosition,7,j)))'])
        end
        ylimasp=get(gca,'ylim');
        text(75,ylimasp(2)-0.1*ylimasp(2),num2str(eval(['size(pro00087153_00',num2str(sbjs_all(n,:)),'_gen_03_ver_',version,'_reaches_wo_outliers_',freq_band,'{out_ind_c7_p1(i)},2)'])))
        if i==1 && strcmp(sessioninfo.stimlat,'L')==1 
            ylabel('atStartPosition')
            %title(['Sbj',m(1,:),':ch7:t',num2str(i),':',freq_band,':',labl,':ver ',version],'Color',[1 0 0])
        elseif i==1 & strcmp(sessioninfo.stimlat,'L')~=1 
            ylabel('atStartPosition')
            %title(['Sbj',m(1,:),':ch7:t',num2str(i),':',freq_band,':',labl])
        else
            title(['t',num2str(i)])
        end
        eval(['ylim_',num2str(i+5),'=get(gca,''ylim'');'])
    end

    for i=1:4
        subplot(10,5,i+10)
        hold on
        eval(['find_freq_plot_ch7_cueEvent=find(epochs.',epoch_type,'.t',num2str(i),'.cueEvent.psd.freq<=100);'])
        for j=eval(['pro00087153_00',num2str(sbjs_all(n,:)),'_gen_03_ver_',version,'_reaches_wo_outliers_',freq_band,'{out_ind_c7_p2(i)}'])
            eval(['plot(epochs.',epoch_type,'.t',num2str(i),'.cueEvent.psd.freq(find_freq_plot_ch7_cueEvent),log10(epochs.',epoch_type,'.t',num2str(i),'.cueEvent.psd.saw(find_freq_plot_ch7_cueEvent,7,j)))'])
        end
        ylimce=get(gca,'ylim');
        text(75,ylimasp(2)-0.1*ylimasp(2),num2str(eval(['size(pro00087153_00',num2str(sbjs_all(n,:)),'_gen_03_ver_',version,'_reaches_wo_outliers_',freq_band,'{out_ind_c7_p2(i)},2)'])))
        if i==1
            ylabel('cueEvent')
        end
        title(['t',num2str(i)])
        eval(['ylim_',num2str(i+10),'=get(gca,''ylim'');'])
    end

    for i=1:4
        subplot(10,5,i+15)
        hold on
        eval(['find_freq_plot_ch7_targetUp=find(epochs.',epoch_type,'.t',num2str(i),'.targetUp.psd.freq<=100);'])
        for j=eval(['pro00087153_00',num2str(sbjs_all(n,:)),'_gen_03_ver_',version,'_reaches_wo_outliers_',freq_band,'{out_ind_c7_p3(i)}'])
            eval(['plot(epochs.',epoch_type,'.t',num2str(i),'.targetUp.psd.freq(find_freq_plot_ch7_targetUp),log10(epochs.',epoch_type,'.t',num2str(i),'.targetUp.psd.saw(find_freq_plot_ch7_targetUp,7,j)))'])
        end
        ylimtu=get(gca,'ylim');
        text(75,ylimasp(2)-0.1*ylimasp(2),num2str(eval(['size(pro00087153_00',num2str(sbjs_all(n,:)),'_gen_03_ver_',version,'_reaches_wo_outliers_',freq_band,'{out_ind_c7_p3(i)},2)'])))
        if i==1
            ylabel('targetUp')
        end
        title(['t',num2str(i)])
        eval(['ylim_',num2str(i+15),'=get(gca,''ylim'');'])
    end

    %%%scale psd plots
    ymin=min([ylim_1(1) ylim_2(1) ylim_3(1) ylim_4(1),...
              ylim_6(1) ylim_7(1) ylim_8(1) ylim_9(1),...
              ylim_11(1) ylim_12(1) ylim_13(1) ylim_14(1),...
              ylim_16(1) ylim_17(1) ylim_18(1) ylim_19(1)]);
    ymax=max([ylim_1(2) ylim_2(2) ylim_3(2) ylim_4(2),...
              ylim_6(2) ylim_7(2) ylim_8(2) ylim_9(2),...
              ylim_11(2) ylim_12(2) ylim_13(2) ylim_14(2),...
              ylim_16(2) ylim_17(2) ylim_18(2) ylim_19(2)]);
             
    for l=1:19
        if l<=4
            subplot(10,5,l)
            set(gca,'ylim',[ymin ymax])
        elseif l>=6 & l<=9
            subplot(10,5,l)
            set(gca,'ylim',[ymin ymax])
        elseif l>=11 & l<=14
            subplot(10,5,l)
            set(gca,'ylim',[ymin ymax])
        elseif l>=16 & l<=19
            subplot(10,5,l)
            set(gca,'ylim',[ymin ymax])
        end
    end
    %%%
    
       
    %%%
    count=0;
    for i=1:4
        for l=eval(['pro00087153_00',num2str(sbjs_all(n,:)),'_gen_03_ver_',version,'_rest_epochs_wo_outliers_',freq_band,'{out_ind_c7_p0(i)}'])
            eval(['find_freq_',freq_band,'_ch7_t',num2str(i),'_p0=find(epochs_rest.rest2.t',num2str(i),'.psd.freq>=',...
                    num2str(frq_rng_st),' & epochs_rest.rest2.t',num2str(i),'.psd.freq<=',num2str(frq_rng_ed),');']);
            eval(['mean_',freq_band,'_sbj',m,'_ch7_t',num2str(i),'_p0(l)=log10(mean(epochs_rest.rest2.t',num2str(i),...
                '.psd.saw(find_freq_',freq_band,'_ch7_t',num2str(i),'_p0,7,l)));'])
        end
        
        for j=1:3
            count=count+1;
            for l=eval(['pro00087153_00',num2str(sbjs_all(n,:)),'_gen_03_ver_',version,'_reaches_wo_outliers_',freq_band,'{count+12}'])
                l;
                eval(['find_freq_',freq_band,'_ch7_t',num2str(i),'_p',num2str(j),'=find(epochs.',epoch_type,'.t',num2str(i),'.',phase{j},'.psd.freq>=',...
                    num2str(frq_rng_st),' & epochs.',epoch_type,'.t',num2str(i),'.',phase{j},'.psd.freq<=',num2str(frq_rng_ed),');']);
                eval(['mean_',freq_band,'_sbj',m,'_ch7_t',num2str(i),'_p',num2str(j),'(l)=log10(mean(epochs.',epoch_type,'.t',num2str(i),'.',phase{j},...
                    '.psd.saw(find_freq_',freq_band,'_ch7_t',num2str(i),'_p',num2str(j),',7,l)));'])
            end
        end
    end
    
    for i=1:4
        eval(['mean_',freq_band,'_sbj',m,'_ch7_t',num2str(i),'_p0=nonzeros(mean_',freq_band,'_sbj',m,'_ch7_t',num2str(i),'_p0)'';'])
        eval(['size_mean_',freq_band,'_sbj',m,'_ch7_t',num2str(i),'_p0=size(mean_',freq_band,'_sbj',m,'_ch7_t',num2str(i),'_p0,2);'])
        for j=1:3
            eval(['mean_',freq_band,'_sbj',m,'_ch7_t',num2str(i),'_p',num2str(j),'=nonzeros(mean_',freq_band,'_sbj',m,'_ch7_t',num2str(i),'_p',num2str(j),')'';'])
            eval(['size_mean_',freq_band,'_sbj',m,'_ch7_t',num2str(i),'_p',num2str(j),'=size(mean_',freq_band,'_sbj',m,'_ch7_t',num2str(i),'_p',num2str(j),',2);'])
        end
    end
    %supermean of each t and p combination to get 1 value
    for i=1:4
        eval(['mean_mean_',freq_band,'_sbj',m,'_ch7_t',num2str(i),'_p0=mean(mean_',freq_band,'_sbj',m,'_ch7_t',num2str(i),'_p0);'])
        eval(['se_mean_',freq_band,'_sbj',m,'_ch7_t',num2str(i),'_p0=std(mean_',freq_band,'_sbj',m,'_ch7_t',num2str(i),'_p0',...
            ')/sqrt(size_mean_',freq_band,'_sbj',m,'_ch7_t',num2str(i),'_p0);'])
        for j=1:3
            eval(['mean_mean_',freq_band,'_sbj',m,'_ch7_t',num2str(i),'_p',num2str(j),'=mean(mean_',freq_band,'_sbj',m,'_ch7_t',num2str(i),'_p',num2str(j),');'])
            eval(['se_mean_',freq_band,'_sbj',m,'_ch7_t',num2str(i),'_p',num2str(j),'=std(mean_',freq_band,'_sbj',m,'_ch7_t',num2str(i),'_p',num2str(j),...
                ')/sqrt(size_mean_',freq_band,'_sbj',m,'_ch7_t',num2str(i),'_p',num2str(j),');'])
        end
    end
    
    %generate group variable for stats below
    count=0;
    for i=1:4
        for j=1:3
            count=count+1;         
            eval(['mat_sz_mean_ch7{',num2str(count),'}=linspace(',num2str(count),',',num2str(count),...
            ',size_mean_',freq_band,'_sbj',m,'_ch7_t',num2str(i),'_p',num2str(j),');'])
        end
    end
    grp_means=cat(2,mat_sz_mean_ch7{:}); %probably don't need this bc you generate each separate one below
    
    %t1-4 for p0
    %grps_plot_05=[1 4 7 10]; 
    for i=1:4               
        %for j=1
            eval(['mat_sz_plot_05{',num2str(i),'}=linspace(',num2str(i),',',num2str(i),...
            ',size_mean_',freq_band,'_sbj',m,'_ch7_t',num2str(i),'_p0);'])
        %end
    end
    grp_plot_05_all=cat(2,mat_sz_plot_05{:});
    
    subplot(10,5,5)
    hold on
    eval(['bar([mean_mean_',freq_band,'_sbj',m,'_ch7_t1_p0 mean_mean_',freq_band,'_sbj',m,'_ch7_t2_p0 mean_mean_',freq_band,'_sbj',m,'_ch7_t3_p0 mean_mean_',freq_band,'_sbj',m,'_ch7_t4_p0])'])
    eval(['errorbar([mean_mean_',freq_band,'_sbj',m,'_ch7_t1_p0 mean_mean_',freq_band,'_sbj',m,'_ch7_t2_p0 mean_mean_',freq_band,'_sbj',m,'_ch7_t3_p0 mean_mean_',freq_band,'_sbj',m,'_ch7_t4_p0],',...
        '[se_mean_',freq_band,'_sbj',m,'_ch7_t1_p0 se_mean_',freq_band,'_sbj',m,'_ch7_t2_p0 se_mean_',freq_band,'_sbj',m,'_ch7_t3_p0 se_mean_',freq_band,'_sbj',m,'_ch7_t4_p0],''.k'')'])
    ylim_5=get(gca,'ylim');
    set(gca,'XTick',[1:4],'XTickLabel',{'t1';'t2';'t3';'t4'})
    eval(['[p_mean_',freq_band,'_sbj',m,'_ch7_p0,table_mean_',freq_band,'_sbj',m,'_ch7_p0,stats_mean_',freq_band,'_sbj',m,...
        '_ch7_p0]=kruskalwallis([mean_',freq_band,'_sbj',m,'_ch7_t1_p0,mean_',freq_band,'_sbj',m,'_ch7_t2_p0,mean_',freq_band,'_sbj',m,'_ch7_t3_p0,mean_',freq_band,'_sbj',m,'_ch7_t4_p0],[grp_plot_05_all],''off'');'])
    if eval(['p_mean_',freq_band,'_sbj',m,'_ch7_p0'])<=0.05
        eval(['title(num2str(p_mean_',freq_band,'_sbj',m,'_ch7_p0),''Color'',[1 0 0])'])
    else
        eval(['title(num2str(p_mean_',freq_band,'_sbj',m,'_ch7_p0))'])
    end
        
    %t1-4 for p1
    grps_plot_10=[1 4 7 10]; %don't remember how I came up with these indices 1,4,7,10 but I do remember it was necessary to assign each mean a unique #
    for i=1:4               % they are used to group the kruskall-wallis groups
        for j=1
            eval(['mat_sz_plot_10{',num2str(i),'}=linspace(',num2str(grps_plot_10(i)),',',num2str(grps_plot_10(i)),...
            ',size_mean_',freq_band,'_sbj',m,'_ch7_t',num2str(i),'_p',num2str(j),');'])
        end
    end
    grp_plot_10_all=cat(2,mat_sz_plot_10{:});
    
    subplot(10,5,10)
    hold on
    eval(['bar([mean_mean_',freq_band,'_sbj',m,'_ch7_t1_p1 mean_mean_',freq_band,'_sbj',m,'_ch7_t2_p1 mean_mean_',freq_band,'_sbj',m,'_ch7_t3_p1 mean_mean_',freq_band,'_sbj',m,'_ch7_t4_p1])'])
    eval(['errorbar([mean_mean_',freq_band,'_sbj',m,'_ch7_t1_p1 mean_mean_',freq_band,'_sbj',m,'_ch7_t2_p1 mean_mean_',freq_band,'_sbj',m,'_ch7_t3_p1 mean_mean_',freq_band,'_sbj',m,'_ch7_t4_p1],',...
        '[se_mean_',freq_band,'_sbj',m,'_ch7_t1_p1 se_mean_',freq_band,'_sbj',m,'_ch7_t2_p1 se_mean_',freq_band,'_sbj',m,'_ch7_t3_p1 se_mean_',freq_band,'_sbj',m,'_ch7_t4_p1],''.k'')'])
    ylim_10=get(gca,'ylim');
    set(gca,'XTick',[1:4],'XTickLabel',{'t1';'t2';'t3';'t4'})
    eval(['[p_mean_',freq_band,'_sbj',m,'_ch7_p1,table_mean_',freq_band,'_sbj',m,'_ch7_p1,stats_mean_',freq_band,'_sbj',m,...
        '_ch7_p1]=kruskalwallis([mean_',freq_band,'_sbj',m,'_ch7_t1_p1,mean_',freq_band,'_sbj',m,'_ch7_t2_p1,mean_',freq_band,'_sbj',m,'_ch7_t3_p1,mean_',freq_band,'_sbj',m,'_ch7_t4_p1],[grp_plot_10_all],''off'');'])
    if eval(['p_mean_',freq_band,'_sbj',m,'_ch7_p1'])<=0.05
        eval(['title(num2str(p_mean_',freq_band,'_sbj',m,'_ch7_p1),''Color'',[1 0 0])'])
    else
        eval(['title(num2str(p_mean_',freq_band,'_sbj',m,'_ch7_p1))'])
    end
        
    %t1-4 for p2
    grps_plot_15=[2 5 8 11];
    for i=1:4
        for j=2
            eval(['mat_sz_plot_15{',num2str(i),'}=linspace(',num2str(grps_plot_15(i)),',',num2str(grps_plot_15(i)),...
            ',size_mean_',freq_band,'_sbj',m,'_ch7_t',num2str(i),'_p',num2str(j),');'])
        end
    end
    grp_plot_15_all=cat(2,mat_sz_plot_15{:});

    subplot(10,5,15)
    hold on
    eval(['bar([mean_mean_',freq_band,'_sbj',m,'_ch7_t1_p2 mean_mean_',freq_band,'_sbj',m,'_ch7_t2_p2 mean_mean_',freq_band,'_sbj',m,'_ch7_t3_p2 mean_mean_',freq_band,'_sbj',m,'_ch7_t4_p2])'])
    eval(['errorbar([mean_mean_',freq_band,'_sbj',m,'_ch7_t1_p2 mean_mean_',freq_band,'_sbj',m,'_ch7_t2_p2 mean_mean_',freq_band,'_sbj',m,'_ch7_t3_p2 mean_mean_',freq_band,'_sbj',m,'_ch7_t4_p2],',...
        '[se_mean_',freq_band,'_sbj',m,'_ch7_t1_p2 se_mean_',freq_band,'_sbj',m,'_ch7_t2_p2 se_mean_',freq_band,'_sbj',m,'_ch7_t3_p2 se_mean_',freq_band,'_sbj',m,'_ch7_t4_p2],''.k'')'])
    ylim_15=get(gca,'ylim');
    set(gca,'XTick',[1:4],'XTickLabel',{'t1';'t2';'t3';'t4'})
    eval(['[p_mean_',freq_band,'_sbj',m,'_ch7_p2,table_mean_',freq_band,'_sbj',m,'_ch7_p2,stats_mean_',freq_band,'_sbj',m,...
        '_ch7_p2]=kruskalwallis([mean_',freq_band,'_sbj',m,'_ch7_t1_p2,mean_',freq_band,'_sbj',m,'_ch7_t2_p2,mean_',freq_band,'_sbj',m,'_ch7_t3_p2,mean_',freq_band,'_sbj',m,'_ch7_t4_p2],[grp_plot_15_all],''off'');'])
    if eval(['p_mean_',freq_band,'_sbj',m,'_ch7_p2'])<=0.05
        eval(['title(num2str(p_mean_',freq_band,'_sbj',m,'_ch7_p2),''Color'',[1 0 0])'])
    else
        eval(['title(num2str(p_mean_',freq_band,'_sbj',m,'_ch7_p2))'])
    end
        
    %t1-4 for p3
    grps_plot_20=[3 6 9 12];
    for i=1:4
        for j=3
            eval(['mat_sz_plot_20{',num2str(i),'}=linspace(',num2str(grps_plot_20(i)),',',num2str(grps_plot_20(i)),...
            ',size_mean_',freq_band,'_sbj',m,'_ch7_t',num2str(i),'_p',num2str(j),');'])
        end
    end
    grp_plot_20_all=cat(2,mat_sz_plot_20{:});

    subplot(10,5,20)
    hold on
    eval(['bar([mean_mean_',freq_band,'_sbj',m,'_ch7_t1_p3 mean_mean_',freq_band,'_sbj',m,'_ch7_t2_p3 mean_mean_',freq_band,'_sbj',m,'_ch7_t3_p3 mean_mean_',freq_band,'_sbj',m,'_ch7_t4_p3])'])
    eval(['errorbar([mean_mean_',freq_band,'_sbj',m,'_ch7_t1_p3 mean_mean_',freq_band,'_sbj',m,'_ch7_t2_p3 mean_mean_',freq_band,'_sbj',m,'_ch7_t3_p3 mean_mean_',freq_band,'_sbj',m,'_ch7_t4_p3],',...
        '[se_mean_',freq_band,'_sbj',m,'_ch7_t1_p3 se_mean_',freq_band,'_sbj',m,'_ch7_t2_p3 se_mean_',freq_band,'_sbj',m,'_ch7_t3_p3 se_mean_',freq_band,'_sbj',m,'_ch7_t4_p3],''.k'')'])
    ylim_20=get(gca,'ylim');
    ymin2=min([ylim_5(1) ylim_10(1) ylim_15(1) ylim_20(1)]);
    ymax2=max([ylim_5(2) ylim_10(2) ylim_15(2) ylim_20(2)]);
    set(gca,'XTick',[1:4],'XTickLabel',{'t1';'t2';'t3';'t4'})
    eval(['[p_mean_',freq_band,'_sbj',m,'_ch7_p3,table_mean_',freq_band,'_sbj',m,'_ch7_p3,stats_mean_',freq_band,'_sbj',m,...
        '_ch7_p3]=kruskalwallis([mean_',freq_band,'_sbj',m,'_ch7_t1_p3,mean_',freq_band,'_sbj',m,'_ch7_t2_p3,mean_',freq_band,'_sbj',m,'_ch7_t3_p3,mean_',freq_band,'_sbj',m,'_ch7_t4_p3],[grp_plot_20_all],''off'');'])
    if eval(['p_mean_',freq_band,'_sbj',m,'_ch7_p3'])<=0.05
        eval(['title(num2str(p_mean_',freq_band,'_sbj',m,'_ch7_p3),''Color'',[1 0 0])'])
    else
        eval(['title(num2str(p_mean_',freq_band,'_sbj',m,'_ch7_p3))'])
    end

    for i=[5 10 15 20]
        subplot(10,5,i)
        set(gca,'ylim',[ymin2 ymax2])
    end
    
    subplot(10,5,5)
    eval(['mc_ch7_p0=nr_multcompare_ind_tdcs_plot(stats_mean_',freq_band,'_sbj',m,'_ch7_p0,ymin2);'])
    subplot(10,5,10)
    eval(['mc_ch7_p1=nr_multcompare_ind_tdcs_plot(stats_mean_',freq_band,'_sbj',m,'_ch7_p1,ymin2);'])
    subplot(10,5,15)
    eval(['mc_ch7_p2=nr_multcompare_ind_tdcs_plot(stats_mean_',freq_band,'_sbj',m,'_ch7_p2,ymin2);'])
    subplot(10,5,20)
    eval(['mc_ch7_p3=nr_multcompare_ind_tdcs_plot(stats_mean_',freq_band,'_sbj',m,'_ch7_p3,ymin2);'])
    
       
    %p0-3 for t1
    grps_plot_21=[1 2 3];
    for i=1
        for j=1:3
                eval(['mat_sz_plot_21{',num2str(j+1),'}=linspace(',num2str(grps_plot_21(j)),',',num2str(grps_plot_21(j)),...
                ',size_mean_',freq_band,'_sbj',m,'_ch7_t',num2str(i),'_p',num2str(j),');'])
        end
    end
    eval(['mat_sz_plot_21{1}=linspace(0,0,size_mean_',freq_band,'_sbj',m,'_ch7_t',num2str(i),'_p0);'])
    grp_plot_21_all=cat(2,mat_sz_plot_21{:});

    subplot(10,5,21)
    hold on
    eval(['bar([mean_mean_',freq_band,'_sbj',m,'_ch7_t1_p0 mean_mean_',freq_band,'_sbj',m,'_ch7_t1_p1 mean_mean_',freq_band,'_sbj',m,'_ch7_t1_p2 mean_mean_',freq_band,'_sbj',m,'_ch7_t1_p3])'])
    eval(['errorbar([mean_mean_',freq_band,'_sbj',m,'_ch7_t1_p0 mean_mean_',freq_band,'_sbj',m,'_ch7_t1_p1 mean_mean_',freq_band,'_sbj',m,'_ch7_t1_p2 mean_mean_',freq_band,'_sbj',m,'_ch7_t1_p3],',...
        '[se_mean_',freq_band,'_sbj',m,'_ch7_t1_p0 se_mean_',freq_band,'_sbj',m,'_ch7_t1_p1 se_mean_',freq_band,'_sbj',m,'_ch7_t1_p2 se_mean_',freq_band,'_sbj',m,'_ch7_t1_p3],''.k'')'])
    ylim_21=get(gca,'ylim');
    set(gca,'XTick',[1:4],'XTickLabel',{'r';'h';'p';'m'})
    eval(['[p_mean_',freq_band,'_sbj',m,'_ch7_t1,table_mean_',freq_band,'_sbj',m,'_ch7_t1,stats_mean_',freq_band,'_sbj',m,...
        '_ch7_t1]=kruskalwallis([mean_',freq_band,'_sbj',m,'_ch7_t1_p0,mean_',freq_band,'_sbj',m,'_ch7_t1_p1,mean_',freq_band,'_sbj',m,'_ch7_t1_p2,mean_',freq_band,'_sbj',m,'_ch7_t1_p3],[grp_plot_21_all],''off'');'])
    if eval(['p_mean_',freq_band,'_sbj',m,'_ch7_t1'])<=0.05
        eval(['title(num2str(p_mean_',freq_band,'_sbj',m,'_ch7_t1),''Color'',[1 0 0])'])
    else
        eval(['title(num2str(p_mean_',freq_band,'_sbj',m,'_ch7_t1))'])
    end
    
      
    %p0-3 for t2
    grps_plot_22=[4 5 6];
    for i=2
        for j=1:3
            eval(['mat_sz_plot_22{',num2str(j+1),'}=linspace(',num2str(grps_plot_22(j)),',',num2str(grps_plot_22(j)),...
            ',size_mean_',freq_band,'_sbj',m,'_ch7_t',num2str(i),'_p',num2str(j),');'])
        end
    end
    eval(['mat_sz_plot_22{1}=linspace(0,0,size_mean_',freq_band,'_sbj',m,'_ch7_t',num2str(i),'_p0);'])
    grp_plot_22_all=cat(2,mat_sz_plot_22{:});
    
    subplot(10,5,22)
    hold on
    eval(['bar([mean_mean_',freq_band,'_sbj',m,'_ch7_t2_p0 mean_mean_',freq_band,'_sbj',m,'_ch7_t2_p1 mean_mean_',freq_band,'_sbj',m,'_ch7_t2_p2 mean_mean_',freq_band,'_sbj',m,'_ch7_t2_p3 ])'])
    eval(['errorbar([mean_mean_',freq_band,'_sbj',m,'_ch7_t2_p0 mean_mean_',freq_band,'_sbj',m,'_ch7_t2_p1 mean_mean_',freq_band,'_sbj',m,'_ch7_t2_p2 mean_mean_',freq_band,'_sbj',m,'_ch7_t2_p3],',...
        '[se_mean_',freq_band,'_sbj',m,'_ch7_t2_p0 se_mean_',freq_band,'_sbj',m,'_ch7_t2_p1 se_mean_',freq_band,'_sbj',m,'_ch7_t2_p2 se_mean_',freq_band,'_sbj',m,'_ch7_t2_p3],''.k'')'])
    ylim_22=get(gca,'ylim');
    set(gca,'XTick',[1:4],'XTickLabel',{'r';'h';'p';'m'})
    eval(['[p_mean_',freq_band,'_sbj',m,'_ch7_t2,table_mean_',freq_band,'_sbj',m,'_ch7_t2,stats_mean_',freq_band,'_sbj',m,...
        '_ch7_t2]=kruskalwallis([mean_',freq_band,'_sbj',m,'_ch7_t2_p0,mean_',freq_band,'_sbj',m,'_ch7_t2_p1,mean_',freq_band,'_sbj',m,'_ch7_t2_p2,mean_',freq_band,'_sbj',m,'_ch7_t2_p3],[grp_plot_22_all],''off'');'])
    if eval(['p_mean_',freq_band,'_sbj',m,'_ch7_t2'])<=0.05
        eval(['title(num2str(p_mean_',freq_band,'_sbj',m,'_ch7_t2),''Color'',[1 0 0])'])
    else
        eval(['title(num2str(p_mean_',freq_band,'_sbj',m,'_ch7_t2))'])
    end
    
    %p0-3 for t3
    grps_plot_23=[7 8 9];
    for i=3
        for j=1:3
            eval(['mat_sz_plot_23{',num2str(j+1),'}=linspace(',num2str(grps_plot_23(j)),',',num2str(grps_plot_23(j)),...
            ',size_mean_',freq_band,'_sbj',m,'_ch7_t',num2str(i),'_p',num2str(j),');'])
        end
    end
    eval(['mat_sz_plot_23{1}=linspace(0,0,size_mean_',freq_band,'_sbj',m,'_ch7_t',num2str(i),'_p0);'])
    grp_plot_23_all=cat(2,mat_sz_plot_23{:});

    subplot(10,5,23)
    hold on
    eval(['bar([mean_mean_',freq_band,'_sbj',m,'_ch7_t3_p0 mean_mean_',freq_band,'_sbj',m,'_ch7_t3_p1 mean_mean_',freq_band,'_sbj',m,'_ch7_t3_p2 mean_mean_',freq_band,'_sbj',m,'_ch7_t3_p3])'])
    eval(['errorbar([mean_mean_',freq_band,'_sbj',m,'_ch7_t3_p0 mean_mean_',freq_band,'_sbj',m,'_ch7_t3_p1 mean_mean_',freq_band,'_sbj',m,'_ch7_t3_p2 mean_mean_',freq_band,'_sbj',m,'_ch7_t3_p3],',...
        '[se_mean_',freq_band,'_sbj',m,'_ch7_t3_p0 se_mean_',freq_band,'_sbj',m,'_ch7_t3_p1 se_mean_',freq_band,'_sbj',m,'_ch7_t3_p2 se_mean_',freq_band,'_sbj',m,'_ch7_t3_p3],''.k'')'])
    ylim_23=get(gca,'ylim');
    set(gca,'XTick',[1:4],'XTickLabel',{'r';'h';'p';'m'})
    eval(['[p_mean_',freq_band,'_sbj',m,'_ch7_t3,table_mean_',freq_band,'_sbj',m,'_ch7_t3,stats_mean_',freq_band,'_sbj',m,...
        '_ch7_t3]=kruskalwallis([mean_',freq_band,'_sbj',m,'_ch7_t3_p0,mean_',freq_band,'_sbj',m,'_ch7_t3_p1,mean_',freq_band,'_sbj',m,'_ch7_t3_p2,mean_',freq_band,'_sbj',m,'_ch7_t3_p3],[grp_plot_23_all],''off'');'])
    if eval(['p_mean_',freq_band,'_sbj',m,'_ch7_t3'])<=0.05
        eval(['title(num2str(p_mean_',freq_band,'_sbj',m,'_ch7_t3),''Color'',[1 0 0])'])
    else
        eval(['title(num2str(p_mean_',freq_band,'_sbj',m,'_ch7_t3))'])
    end
    
    %p0-3 for t4
    grps_plot_24=[10 11 12];
    for i=4
        for j=1:3
            eval(['mat_sz_plot_24{',num2str(j+1),'}=linspace(',num2str(grps_plot_24(j)),',',num2str(grps_plot_24(j)),...
            ',size_mean_',freq_band,'_sbj',m,'_ch7_t',num2str(i),'_p',num2str(j),');'])
        end
    end
    eval(['mat_sz_plot_24{1}=linspace(0,0,size_mean_',freq_band,'_sbj',m,'_ch7_t',num2str(i),'_p0);'])
    grp_plot_24_all=cat(2,mat_sz_plot_24{:});

    subplot(10,5,24)
    hold on
    eval(['bar([mean_mean_',freq_band,'_sbj',m,'_ch7_t4_p0 mean_mean_',freq_band,'_sbj',m,'_ch7_t4_p1 mean_mean_',freq_band,'_sbj',m,'_ch7_t4_p2 mean_mean_',freq_band,'_sbj',m,'_ch7_t4_p3])'])
    eval(['errorbar([mean_mean_',freq_band,'_sbj',m,'_ch7_t4_p0 mean_mean_',freq_band,'_sbj',m,'_ch7_t4_p1 mean_mean_',freq_band,'_sbj',m,'_ch7_t4_p2 mean_mean_',freq_band,'_sbj',m,'_ch7_t4_p3],',...
        '[se_mean_',freq_band,'_sbj',m,'_ch7_t4_p0 se_mean_',freq_band,'_sbj',m,'_ch7_t4_p1 se_mean_',freq_band,'_sbj',m,'_ch7_t4_p2 se_mean_',freq_band,'_sbj',m,'_ch7_t4_p3],''.k'')'])
    ylim_24=get(gca,'ylim');
    set(gca,'XTick',[1:4],'XTickLabel',{'r';'h';'p';'m'})
    eval(['[p_mean_',freq_band,'_sbj',m,'_ch7_t4,table_mean_',freq_band,'_sbj',m,'_ch7_t4,stats_mean_',freq_band,'_sbj',m,...
        '_ch7_t4]=kruskalwallis([mean_',freq_band,'_sbj',m,'_ch7_t4_p0,mean_',freq_band,'_sbj',m,'_ch7_t4_p1,mean_',freq_band,'_sbj',m,'_ch7_t4_p2,mean_',freq_band,'_sbj',m,'_ch7_t4_p3],[grp_plot_24_all],''off'');'])
    if eval(['p_mean_',freq_band,'_sbj',m,'_ch7_t4'])<=0.05
        eval(['title(num2str(p_mean_',freq_band,'_sbj',m,'_ch7_t4),''Color'',[1 0 0])'])
    else
        eval(['title(num2str(p_mean_',freq_band,'_sbj',m,'_ch7_t4))'])
    end

    ymin3=min([ylim_21(1) ylim_22(1) ylim_23(1) ylim_24(1)]);
    ymax3=max([ylim_21(2) ylim_22(2) ylim_23(2) ylim_24(2)]);
    for i=[21:24]
        subplot(10,5,i)
        set(gca,'ylim',[ymin3 ymax3])
    end

    subplot(10,5,21)
    eval(['mc_ch7_t1=nr_multcompare_ind_tdcs_plot(stats_mean_',freq_band,'_sbj',m,'_ch7_t1,ymin3);'])
    subplot(10,5,22)
    eval(['mc_ch7_t2=nr_multcompare_ind_tdcs_plot(stats_mean_',freq_band,'_sbj',m,'_ch7_t2,ymin3);'])
    subplot(10,5,23)
    eval(['mc_ch7_t3=nr_multcompare_ind_tdcs_plot(stats_mean_',freq_band,'_sbj',m,'_ch7_t3,ymin3);'])
    subplot(10,5,24)
    eval(['mc_ch7_t4=nr_multcompare_ind_tdcs_plot(stats_mean_',freq_band,'_sbj',m,'_ch7_t4,ymin3);'])


    %%%%%%%%%%%%%%%%%%%%%%%%%%%ch18
    %psd plots
        
    for i=1:4
        subplot(10,5,i+25)
        hold on
        eval(['find_freq_plot_ch18_atRest=find(epochs_rest.rest2.t',num2str(i),'.psd.freq<=100);'])
        for j=eval(['pro00087153_00',num2str(sbjs_all(n,:)),'_gen_03_ver_',version,'_rest_epochs_wo_outliers_',freq_band,'{out_ind_c18_p0(i)}'])
            eval(['plot(epochs_rest.rest2.t',num2str(i),'.psd.freq(find_freq_plot_ch18_atRest),log10(epochs_rest.rest2.t',num2str(i),'.psd.saw(find_freq_plot_ch18_atRest,18,j)))'])
        end
        ylimasp=get(gca,'ylim');
        text(75,ylimasp(2)-0.1*ylimasp(2),num2str(eval(['size(pro00087153_00',num2str(sbjs_all(n,:)),'_gen_03_ver_',version,'_rest_epochs_wo_outliers_',freq_band,'{out_ind_c18_p0(i)},2)'])))
        if i==1 & strcmp(sessioninfo.stimlat,'R')==1 
            ylabel('Rest')
            title(['ch18:t',num2str(i)],'Color',[1 0 0])
        elseif i==1 & strcmp(sessioninfo.stimlat,'R')~=1 
            ylabel('Rest')
            title(['ch18:t',num2str(i)])
        else
            title(['t',num2str(i)])
        end
        eval(['ylim_',num2str(i+25),'=get(gca,''ylim'');'])
    end
    
    for i=1:4
        subplot(10,5,i+30)
        hold on
        eval(['find_freq_plot_ch18_atStartPosition=find(epochs.',epoch_type,'.t',num2str(i),'.atStartPosition.psd.freq<=100);'])
        for j=eval(['pro00087153_00',num2str(sbjs_all(n,:)),'_gen_03_ver_',version,'_reaches_wo_outliers_',freq_band,'{out_ind_c18_p1(i)}'])
            eval(['plot(epochs.',epoch_type,'.t',num2str(i),'.atStartPosition.psd.freq(find_freq_plot_ch18_atStartPosition),log10(epochs.',epoch_type,'.t',num2str(i),'.atStartPosition.psd.saw(find_freq_plot_ch18_atStartPosition,18,j)))'])
        end
        ylimasp=get(gca,'ylim');
        text(75,ylimasp(2)-0.1*ylimasp(2),num2str(eval(['size(pro00087153_00',num2str(sbjs_all(n,:)),'_gen_03_ver_',version,'_reaches_wo_outliers_',freq_band,'{out_ind_c18_p1(i)},2)'])))
        if i==1
            ylabel('atStartPosition')
        end
        title(['t',num2str(i)])
        eval(['ylim_',num2str(i+30),'=get(gca,''ylim'');'])
    end

    for i=1:4
        subplot(10,5,i+35)
        hold on
        eval(['find_freq_plot_ch18_cueEvent=find(epochs.',epoch_type,'.t',num2str(i),'.cueEvent.psd.freq<=100);'])
        for j=eval(['pro00087153_00',num2str(sbjs_all(n,:)),'_gen_03_ver_',version,'_reaches_wo_outliers_',freq_band,'{out_ind_c18_p2(i)}'])
            eval(['plot(epochs.',epoch_type,'.t',num2str(i),'.cueEvent.psd.freq(find_freq_plot_ch18_cueEvent),log10(epochs.',epoch_type,'.t',num2str(i),'.cueEvent.psd.saw(find_freq_plot_ch18_cueEvent,18,j)))'])
        end
        ylimce=get(gca,'ylim');
        text(75,ylimasp(2)-0.1*ylimasp(2),num2str(eval(['size(pro00087153_00',num2str(sbjs_all(n,:)),'_gen_03_ver_',version,'_reaches_wo_outliers_',freq_band,'{out_ind_c18_p2(i)},2)'])))
        if i==1
            ylabel('cueEvent')
        end
        title(['t',num2str(i)])
        eval(['ylim_',num2str(i+35),'=get(gca,''ylim'');'])
    end

    for i=1:4
        subplot(10,5,i+40)
        hold on
        eval(['find_freq_plot_ch18_targetUp=find(epochs.',epoch_type,'.t',num2str(i),'.targetUp.psd.freq<=100);'])
        for j=eval(['pro00087153_00',num2str(sbjs_all(n,:)),'_gen_03_ver_',version,'_reaches_wo_outliers_',freq_band,'{out_ind_c18_p3(i)}'])
            eval(['plot(epochs.',epoch_type,'.t',num2str(i),'.targetUp.psd.freq(find_freq_plot_ch18_targetUp),log10(epochs.',epoch_type,'.t',num2str(i),'.targetUp.psd.saw(find_freq_plot_ch18_targetUp,18,j)))'])
        end
        ylimtu=get(gca,'ylim');
        text(75,ylimasp(2)-0.1*ylimasp(2),num2str(eval(['size(pro00087153_00',num2str(sbjs_all(n,:)),'_gen_03_ver_',version,'_reaches_wo_outliers_',freq_band,'{out_ind_c18_p3(i)},2)'])))
        if i==1
            ylabel('targetUp')
        end
        title(['t',num2str(i)])
        eval(['ylim_',num2str(i+40),'=get(gca,''ylim'');'])
    end
    
    %%%scale psd plots
    ymin=min([ylim_26(1) ylim_27(1) ylim_28(1) ylim_29(1),...
              ylim_31(1) ylim_32(1) ylim_33(1) ylim_34(1),...
              ylim_36(1) ylim_37(1) ylim_38(1) ylim_39(1),...
              ylim_41(1) ylim_42(1) ylim_43(1) ylim_44(1)]);
    ymax=max([ylim_26(2) ylim_27(2) ylim_28(2) ylim_29(2),...
              ylim_31(2) ylim_32(2) ylim_33(2) ylim_34(2),...
              ylim_36(2) ylim_37(2) ylim_38(2) ylim_39(2),...
              ylim_41(2) ylim_42(2) ylim_43(2) ylim_44(2)]);

    for l=26:44
        if l>=26 & l<=29
            subplot(10,5,l)
            set(gca,'ylim',[ymin ymax])
        elseif l>=31 & l<=34
            subplot(10,5,l)
            set(gca,'ylim',[ymin ymax])
        elseif l>=36 & l<=39
            subplot(10,5,l)
            set(gca,'ylim',[ymin ymax])
        elseif l>=41 & l<=44
            subplot(10,5,l)
            set(gca,'ylim',[ymin ymax])
        end
    end
    %%%
    
    phase={'atStartPosition';'cueEvent';'targetUp'};
    count=0;
    for i=1:4
        for l=eval(['pro00087153_00',num2str(sbjs_all(n,:)),'_gen_03_ver_',version,'_rest_epochs_wo_outliers_',freq_band,'{out_ind_c18_p0(i)}'])
            eval(['find_freq_',freq_band,'_ch18_t',num2str(i),'_p0=find(epochs_rest.rest2.t',num2str(i),'.psd.freq>=',...
                    num2str(frq_rng_st),' & epochs_rest.rest2.t',num2str(i),'.psd.freq<=',num2str(frq_rng_ed),');']);
            eval(['mean_',freq_band,'_sbj',m,'_ch18_t',num2str(i),'_p0(l)=log10(mean(epochs_rest.rest2.t',num2str(i),...
                '.psd.saw(find_freq_',freq_band,'_ch18_t',num2str(i),'_p0,18,l)));'])
        end        
        
        for j=1:3
            count=count+1;
            for l=eval(['pro00087153_00',num2str(sbjs_all(n,:)),'_gen_03_ver_',version,'_reaches_wo_outliers_',freq_band,'{count}'])
                eval(['find_freq_',freq_band,'_ch18_t',num2str(i),'_p',num2str(j),'=find(epochs.',epoch_type,'.t',num2str(i),'.',phase{j},'.psd.freq>=',...
                    num2str(frq_rng_st),' & epochs.',epoch_type,'.t',num2str(i),'.',phase{j},'.psd.freq<=',num2str(frq_rng_ed),');'])
                eval(['mean_',freq_band,'_sbj',m,'_ch18_t',num2str(i),'_p',num2str(j),'(l)=log10(mean(epochs.',epoch_type,'.t',num2str(i),'.',phase{j},...
                    '.psd.saw(find_freq_',freq_band,'_ch18_t',num2str(i),'_p',num2str(j),',18,l)));'])
            end
        end
    end
    
    for i=1:4
        eval(['mean_',freq_band,'_sbj',m,'_ch18_t',num2str(i),'_p0=nonzeros(mean_',freq_band,'_sbj',m,'_ch18_t',num2str(i),'_p0)'';'])
        eval(['size_mean_',freq_band,'_sbj',m,'_ch18_t',num2str(i),'_p0=size(mean_',freq_band,'_sbj',m,'_ch18_t',num2str(i),'_p0,2);'])
        for j=1:3
            eval(['mean_',freq_band,'_sbj',m,'_ch18_t',num2str(i),'_p',num2str(j),'=nonzeros(mean_',freq_band,'_sbj',m,'_ch18_t',num2str(i),'_p',num2str(j),')'''])
            eval(['size_mean_',freq_band,'_sbj',m,'_ch18_t',num2str(i),'_p',num2str(j),'=size(mean_',freq_band,'_sbj',m,'_ch18_t',num2str(i),'_p',num2str(j),',2);'])
        end
    end
        
    for i=1:4
        eval(['mean_mean_',freq_band,'_sbj',m,'_ch18_t',num2str(i),'_p0=mean(mean_',freq_band,'_sbj',m,'_ch18_t',num2str(i),'_p0);'])
        eval(['se_mean_',freq_band,'_sbj',m,'_ch18_t',num2str(i),'_p0=std(mean_',freq_band,'_sbj',m,'_ch18_t',num2str(i),'_p0',...
            ')/sqrt(size_mean_',freq_band,'_sbj',m,'_ch18_t',num2str(i),'_p0);'])
        for j=1:3
            eval(['mean_mean_',freq_band,'_sbj',m,'_ch18_t',num2str(i),'_p',num2str(j),'=mean(mean_',freq_band,'_sbj',m,'_ch18_t',num2str(i),'_p',num2str(j),');'])
            eval(['se_mean_',freq_band,'_sbj',m,'_ch18_t',num2str(i),'_p',num2str(j),'=std(mean_',freq_band,'_sbj',m,'_ch18_t',num2str(i),'_p',num2str(j),...
                ')/sqrt(size(mean_',freq_band,'_sbj',m,'_ch18_t',num2str(i),'_p',num2str(j),',2));'])
        end
    end
    
    %p0
    for i=1:4               
        %for j=1
            eval(['mat_sz_plot_30{',num2str(i),'}=linspace(',num2str(i),',',num2str(i),...
            ',size_mean_',freq_band,'_sbj',m,'_ch18_t',num2str(i),'_p0);'])
        %end
    end
    grp_plot_30_all=cat(2,mat_sz_plot_30{:});
    
    subplot(10,5,30)
    hold on
    eval(['bar([mean_mean_',freq_band,'_sbj',m,'_ch18_t1_p0 mean_mean_',freq_band,'_sbj',m,'_ch18_t2_p0 mean_mean_',freq_band,'_sbj',m,'_ch18_t3_p0 mean_mean_',freq_band,'_sbj',m,'_ch18_t4_p0])'])
    eval(['errorbar([mean_mean_',freq_band,'_sbj',m,'_ch18_t1_p0 mean_mean_',freq_band,'_sbj',m,'_ch18_t2_p0 mean_mean_',freq_band,'_sbj',m,'_ch18_t3_p0 mean_mean_',freq_band,'_sbj',m,'_ch18_t4_p0],',...
        '[se_mean_',freq_band,'_sbj',m,'_ch18_t1_p0 se_mean_',freq_band,'_sbj',m,'_ch18_t2_p0 se_mean_',freq_band,'_sbj',m,'_ch18_t3_p0 se_mean_',freq_band,'_sbj',m,'_ch18_t4_p0],''.k'')'])
    ylim_30=get(gca,'ylim');
    set(gca,'XTick',[1:4],'XTickLabel',{'t1';'t2';'t3';'t4'})
    eval(['[p_mean_',freq_band,'_sbj',m,'_ch18_p0,table_mean_',freq_band,'_sbj',m,'_ch18_p0,stats_mean_',freq_band,'_sbj',m,...
        '_ch18_p0]=kruskalwallis([mean_',freq_band,'_sbj',m,'_ch18_t1_p0,mean_',freq_band,'_sbj',m,'_ch18_t2_p0,mean_',freq_band,'_sbj',m,'_ch18_t3_p0,mean_',freq_band,'_sbj',m,'_ch18_t4_p0],[grp_plot_30_all],''off'');'])
    if eval(['p_mean_',freq_band,'_sbj',m,'_ch18_p0'])<=0.05
        eval(['title(num2str(p_mean_',freq_band,'_sbj',m,'_ch18_p0),''Color'',[1 0 0])'])
    else
        eval(['title(num2str(p_mean_',freq_band,'_sbj',m,'_ch18_p0))'])
    end
    
    %p1
    grps_plot_35=[1 4 7 10];
    for i=1:4
        for j=1
            eval(['mat_sz_plot_35{',num2str(i),'}=linspace(',num2str(grps_plot_35(i)),',',num2str(grps_plot_35(i)),...
            ',size_mean_',freq_band,'_sbj',m,'_ch18_t',num2str(i),'_p',num2str(j),');'])
        end
    end
    grp_plot_35_all=cat(2,mat_sz_plot_35{:});
    
    subplot(10,5,35)
    hold on
    eval(['bar([mean_mean_',freq_band,'_sbj',m,'_ch18_t1_p1 mean_mean_',freq_band,'_sbj',m,'_ch18_t2_p1 mean_mean_',freq_band,'_sbj',m,'_ch18_t3_p1 mean_mean_',freq_band,'_sbj',m,'_ch18_t4_p1])'])
    eval(['errorbar([mean_mean_',freq_band,'_sbj',m,'_ch18_t1_p1 mean_mean_',freq_band,'_sbj',m,'_ch18_t2_p1 mean_mean_',freq_band,'_sbj',m,'_ch18_t3_p1 mean_mean_',freq_band,'_sbj',m,'_ch18_t4_p1],',...
        '[se_mean_',freq_band,'_sbj',m,'_ch18_t1_p1 se_mean_',freq_band,'_sbj',m,'_ch18_t2_p1 se_mean_',freq_band,'_sbj',m,'_ch18_t3_p1 se_mean_',freq_band,'_sbj',m,'_ch18_t4_p1],''.k'')'])
    ylim_35=get(gca,'ylim');
    set(gca,'XTick',[1:4],'XTickLabel',{'t1';'t2';'t3';'t4'})
    eval(['[p_mean_',freq_band,'_sbj',m,'_ch18_p1,table_mean_',freq_band,'_sbj',m,'_ch18_p1,stats_mean_',freq_band,'_sbj',m,...
        '_ch18_p1]=kruskalwallis([mean_',freq_band,'_sbj',m,'_ch18_t1_p1,mean_',freq_band,'_sbj',m,'_ch18_t2_p1,mean_',freq_band,'_sbj',m,'_ch18_t3_p1,mean_',freq_band,'_sbj',m,'_ch18_t4_p1],[grp_plot_35_all],''off'');'])
    if eval(['p_mean_',freq_band,'_sbj',m,'_ch18_p1'])<=0.05
        eval(['title(num2str(p_mean_',freq_band,'_sbj',m,'_ch18_p1),''Color'',[1 0 0])'])
    else
        eval(['title(num2str(p_mean_',freq_band,'_sbj',m,'_ch18_p1))'])
    end

    %p2
    grps_plot_40=[2 5 8 11];
    for i=1:4
        for j=2
            eval(['mat_sz_plot_40{',num2str(i),'}=linspace(',num2str(grps_plot_40(i)),',',num2str(grps_plot_40(i)),...
            ',size_mean_',freq_band,'_sbj',m,'_ch18_t',num2str(i),'_p',num2str(j),');'])
        end
    end
    grp_plot_40_all=cat(2,mat_sz_plot_40{:});
    
    subplot(10,5,40)
    hold on
    eval(['bar([mean_mean_',freq_band,'_sbj',m,'_ch18_t1_p2 mean_mean_',freq_band,'_sbj',m,'_ch18_t2_p2 mean_mean_',freq_band,'_sbj',m,'_ch18_t3_p2 mean_mean_',freq_band,'_sbj',m,'_ch18_t4_p2])'])
    eval(['errorbar([mean_mean_',freq_band,'_sbj',m,'_ch18_t1_p2 mean_mean_',freq_band,'_sbj',m,'_ch18_t2_p2 mean_mean_',freq_band,'_sbj',m,'_ch18_t3_p2 mean_mean_',freq_band,'_sbj',m,'_ch18_t4_p2],',...
        '[se_mean_',freq_band,'_sbj',m,'_ch18_t1_p2 se_mean_',freq_band,'_sbj',m,'_ch18_t2_p2 se_mean_',freq_band,'_sbj',m,'_ch18_t3_p2 se_mean_',freq_band,'_sbj',m,'_ch18_t4_p2],''.k'')'])
    ylim_40=get(gca,'ylim');
    set(gca,'XTick',[1:4],'XTickLabel',{'t1';'t2';'t3';'t4'})
    eval(['[p_mean_',freq_band,'_sbj',m,'_ch18_p2,table_mean_',freq_band,'_sbj',m,'_ch18_p2,stats_mean_',freq_band,'_sbj',m,...
        '_ch18_p2]=kruskalwallis([mean_',freq_band,'_sbj',m,'_ch18_t1_p2,mean_',freq_band,'_sbj',m,'_ch18_t2_p2,mean_',freq_band,'_sbj',m,'_ch18_t3_p2,mean_',freq_band,'_sbj',m,'_ch18_t4_p2],[grp_plot_40_all],''off'');'])
    if eval(['p_mean_',freq_band,'_sbj',m,'_ch18_p2'])<=0.05
        eval(['title(num2str(p_mean_',freq_band,'_sbj',m,'_ch18_p2),''Color'',[1 0 0])'])
    else
        eval(['title(num2str(p_mean_',freq_band,'_sbj',m,'_ch18_p2))'])
    end

    %p3
    grps_plot_45=[3 6 9 12];
    for i=1:4
        for j=3
            eval(['mat_sz_plot_45{',num2str(i),'}=linspace(',num2str(grps_plot_45(i)),',',num2str(grps_plot_45(i)),...
            ',size_mean_',freq_band,'_sbj',m,'_ch18_t',num2str(i),'_p',num2str(j),');'])
        end
    end
    grp_plot_45_all=cat(2,mat_sz_plot_45{:});
    
    subplot(10,5,45)
    hold on
    eval(['bar([mean_mean_',freq_band,'_sbj',m,'_ch18_t1_p3 mean_mean_',freq_band,'_sbj',m,'_ch18_t2_p3 mean_mean_',freq_band,'_sbj',m,'_ch18_t3_p3 mean_mean_',freq_band,'_sbj',m,'_ch18_t4_p3])'])
    eval(['errorbar([mean_mean_',freq_band,'_sbj',m,'_ch18_t1_p3 mean_mean_',freq_band,'_sbj',m,'_ch18_t2_p3 mean_mean_',freq_band,'_sbj',m,'_ch18_t3_p3 mean_mean_',freq_band,'_sbj',m,'_ch18_t4_p3],',...
        '[se_mean_',freq_band,'_sbj',m,'_ch18_t1_p3 se_mean_',freq_band,'_sbj',m,'_ch18_t2_p3 se_mean_',freq_band,'_sbj',m,'_ch18_t3_p3 se_mean_',freq_band,'_sbj',m,'_ch18_t4_p3],''.k'')'])
    ylim_45=get(gca,'ylim');
    set(gca,'XTick',[1:4],'XTickLabel',{'t1';'t2';'t3';'t4'})
    eval(['[p_mean_',freq_band,'_sbj',m,'_ch18_p3,table_mean_',freq_band,'_sbj',m,'_ch18_p3,stats_mean_',freq_band,'_sbj',m,...
        '_ch18_p3]=kruskalwallis([mean_',freq_band,'_sbj',m,'_ch18_t1_p3,mean_',freq_band,'_sbj',m,'_ch18_t2_p3,mean_',freq_band,'_sbj',m,'_ch18_t3_p3,mean_',freq_band,'_sbj',m,'_ch18_t4_p3],[grp_plot_45_all],''off'');'])
    if eval(['p_mean_',freq_band,'_sbj',m,'_ch18_p3'])<=0.05
        eval(['title(num2str(p_mean_',freq_band,'_sbj',m,'_ch18_p3),''Color'',[1 0 0])'])
    else
        eval(['title(num2str(p_mean_',freq_band,'_sbj',m,'_ch18_p3))'])
    end
    
    ymin4=min([ylim_30(1) ylim_35(1) ylim_40(1) ylim_45(1)]);
    ymax4=max([ylim_30(2) ylim_35(2) ylim_40(2) ylim_45(2)]);

    for i=[30 35 40 45]
        subplot(10,5,i)
        set(gca,'ylim',[ymin4 ymax4])
    end
    
    subplot(10,5,30)
    eval(['mc_ch18_p0=nr_multcompare_ind_tdcs_plot(stats_mean_',freq_band,'_sbj',m,'_ch18_p0,ymin4);'])    
    subplot(10,5,35)
    eval(['mc_ch18_p1=nr_multcompare_ind_tdcs_plot(stats_mean_',freq_band,'_sbj',m,'_ch18_p1,ymin4);'])
    subplot(10,5,40)
    eval(['mc_ch18_p2=nr_multcompare_ind_tdcs_plot(stats_mean_',freq_band,'_sbj',m,'_ch18_p2,ymin4);'])
    subplot(10,5,45)
    eval(['mc_ch18_p3=nr_multcompare_ind_tdcs_plot(stats_mean_',freq_band,'_sbj',m,'_ch18_p3,ymin4);'])
    
    %t1
    grps_plot_46=[1 2 3];
    for i=1
        for j=1:3
            eval(['mat_sz_plot_46{',num2str(j+1),'}=linspace(',num2str(grps_plot_46(j)),',',num2str(grps_plot_46(j)),...
            ',size_mean_',freq_band,'_sbj',m,'_ch18_t',num2str(i),'_p',num2str(j),');'])
        end
    end
    eval(['mat_sz_plot_46{1}=linspace(0,0,size_mean_',freq_band,'_sbj',m,'_ch18_t',num2str(i),'_p0);'])
    grp_plot_46_all=cat(2,mat_sz_plot_46{:});

    subplot(10,5,46)
    hold on
    eval(['bar([mean_mean_',freq_band,'_sbj',m,'_ch18_t1_p0 mean_mean_',freq_band,'_sbj',m,'_ch18_t1_p1 mean_mean_',freq_band,'_sbj',m,'_ch18_t1_p2 mean_mean_',freq_band,'_sbj',m,'_ch18_t1_p3])'])
    eval(['errorbar([mean_mean_',freq_band,'_sbj',m,'_ch18_t1_p0 mean_mean_',freq_band,'_sbj',m,'_ch18_t1_p1 mean_mean_',freq_band,'_sbj',m,'_ch18_t1_p2 mean_mean_',freq_band,'_sbj',m,'_ch18_t1_p3],',...
        '[se_mean_',freq_band,'_sbj',m,'_ch18_t1_p0 se_mean_',freq_band,'_sbj',m,'_ch18_t1_p1 se_mean_',freq_band,'_sbj',m,'_ch18_t1_p2 se_mean_',freq_band,'_sbj',m,'_ch18_t1_p3],''.k'')'])
    ylim_46=get(gca,'ylim');
    set(gca,'XTick',[1:4],'XTickLabel',{'r';'h';'p';'m'})
    eval(['[p_mean_',freq_band,'_sbj',m,'_ch18_t1,table_mean_',freq_band,'_sbj',m,'_ch18_t1_new,stats_mean_',freq_band,'_sbj',m,...
        '_ch18_t1]=kruskalwallis([mean_',freq_band,'_sbj',m,'_ch18_t1_p0,mean_',freq_band,'_sbj',m,'_ch18_t1_p1,mean_',freq_band,'_sbj',m,'_ch18_t1_p2,mean_',freq_band,'_sbj',m,'_ch18_t1_p3],[grp_plot_46_all],''off'');'])
    if eval(['p_mean_',freq_band,'_sbj',m,'_ch18_t1'])<=0.05
        eval(['title(num2str(p_mean_',freq_band,'_sbj',m,'_ch18_t1),''Color'',[1 0 0])'])
    else
        eval(['title(num2str(p_mean_',freq_band,'_sbj',m,'_ch18_t1))'])
    end
    
    %t2
    grps_plot_47=[4 5 6];
    for i=2
        for j=1:3
            eval(['mat_sz_plot_47{',num2str(j+1),'}=linspace(',num2str(grps_plot_47(j)),',',num2str(grps_plot_47(j)),...
            ',size_mean_',freq_band,'_sbj',m,'_ch18_t',num2str(i),'_p',num2str(j),');'])
        end
    end
    eval(['mat_sz_plot_47{1}=linspace(0,0,size_mean_',freq_band,'_sbj',m,'_ch18_t',num2str(i),'_p0);'])
    grp_plot_47_all=cat(2,mat_sz_plot_47{:});

    subplot(10,5,47)
    hold on
    eval(['bar([mean_mean_',freq_band,'_sbj',m,'_ch18_t2_p0 mean_mean_',freq_band,'_sbj',m,'_ch18_t2_p1 mean_mean_',freq_band,'_sbj',m,'_ch18_t2_p2 mean_mean_',freq_band,'_sbj',m,'_ch18_t2_p3])'])
    eval(['errorbar([mean_mean_',freq_band,'_sbj',m,'_ch18_t2_p0 mean_mean_',freq_band,'_sbj',m,'_ch18_t2_p1 mean_mean_',freq_band,'_sbj',m,'_ch18_t2_p2 mean_mean_',freq_band,'_sbj',m,'_ch18_t2_p3],',...
        '[se_mean_',freq_band,'_sbj',m,'_ch18_t2_p0 se_mean_',freq_band,'_sbj',m,'_ch18_t2_p1 se_mean_',freq_band,'_sbj',m,'_ch18_t2_p2 se_mean_',freq_band,'_sbj',m,'_ch18_t2_p3],''.k'')'])
    ylim_47=get(gca,'ylim');
    set(gca,'XTick',[1:4],'XTickLabel',{'r';'h';'p';'m'})
    eval(['[p_mean_',freq_band,'_sbj',m,'_ch18_t2,table_mean_',freq_band,'_sbj',m,'_ch18_t2,stats_mean_',freq_band,'_sbj',m,...
        '_ch18_t2]=kruskalwallis([mean_',freq_band,'_sbj',m,'_ch18_t2_p0,mean_',freq_band,'_sbj',m,'_ch18_t2_p1,mean_',freq_band,'_sbj',m,'_ch18_t2_p2,mean_',freq_band,'_sbj',m,'_ch18_t2_p3],[grp_plot_47_all],''off'');'])
    if eval(['p_mean_',freq_band,'_sbj',m,'_ch18_t2'])<=0.05
        eval(['title(num2str(p_mean_',freq_band,'_sbj',m,'_ch18_t2),''Color'',[1 0 0])'])
    else
        eval(['title(num2str(p_mean_',freq_band,'_sbj',m,'_ch18_t2))'])
    end
    
    %t3
    grps_plot_48=[7 8 9];
    for i=3
        for j=1:3
            eval(['mat_sz_plot_48{',num2str(j+1),'}=linspace(',num2str(grps_plot_48(j)),',',num2str(grps_plot_48(j)),...
            ',size_mean_',freq_band,'_sbj',m,'_ch18_t',num2str(i),'_p',num2str(j),');'])
        end
    end
    eval(['mat_sz_plot_48{1}=linspace(0,0,size_mean_',freq_band,'_sbj',m,'_ch18_t',num2str(i),'_p0);'])
    grp_plot_48_all=cat(2,mat_sz_plot_48{:});

    subplot(10,5,48)
    hold on
    eval(['bar([mean_mean_',freq_band,'_sbj',m,'_ch18_t3_p0 mean_mean_',freq_band,'_sbj',m,'_ch18_t3_p1 mean_mean_',freq_band,'_sbj',m,'_ch18_t3_p2 mean_mean_',freq_band,'_sbj',m,'_ch18_t3_p3])'])
    eval(['errorbar([mean_mean_',freq_band,'_sbj',m,'_ch18_t3_p0 mean_mean_',freq_band,'_sbj',m,'_ch18_t3_p1 mean_mean_',freq_band,'_sbj',m,'_ch18_t3_p2 mean_mean_',freq_band,'_sbj',m,'_ch18_t3_p3],',...
        '[se_mean_',freq_band,'_sbj',m,'_ch18_t3_p0 se_mean_',freq_band,'_sbj',m,'_ch18_t3_p1 se_mean_',freq_band,'_sbj',m,'_ch18_t3_p2 se_mean_',freq_band,'_sbj',m,'_ch18_t3_p3],''.k'')'])
    ylim_48=get(gca,'ylim');
    set(gca,'XTick',[1:4],'XTickLabel',{'r';'h';'p';'m'})
    eval(['[p_mean_',freq_band,'_sbj',m,'_ch18_t3,table_mean_',freq_band,'_sbj',m,'_ch18_t3,stats_mean_',freq_band,'_sbj',m,...
        '_ch18_t3]=kruskalwallis([mean_',freq_band,'_sbj',m,'_ch18_t3_p0,mean_',freq_band,'_sbj',m,'_ch18_t3_p1,mean_',freq_band,'_sbj',m,'_ch18_t3_p2,mean_',freq_band,'_sbj',m,'_ch18_t3_p3],[grp_plot_48_all],''off'');'])
    if eval(['p_mean_',freq_band,'_sbj',m,'_ch18_t3'])<=0.05
        eval(['title(num2str(p_mean_',freq_band,'_sbj',m,'_ch18_t3),''Color'',[1 0 0])'])
    else
        eval(['title(num2str(p_mean_',freq_band,'_sbj',m,'_ch18_t3))'])
    end
    
    %t4
    grps_plot_49=[10 11 12];
    for i=4
        for j=1:3
            eval(['mat_sz_plot_49{',num2str(j+1),'}=linspace(',num2str(grps_plot_49(j)),',',num2str(grps_plot_49(j)),...
            ',size_mean_',freq_band,'_sbj',m,'_ch18_t',num2str(i),'_p',num2str(j),');'])
        end
    end
    eval(['mat_sz_plot_49{1}=linspace(0,0,size_mean_',freq_band,'_sbj',m,'_ch18_t',num2str(i),'_p0);'])
    grp_plot_49_all=cat(2,mat_sz_plot_49{:});

    subplot(10,5,49)
    hold on
    eval(['bar([mean_mean_',freq_band,'_sbj',m,'_ch18_t4_p0 mean_mean_',freq_band,'_sbj',m,'_ch18_t4_p1 mean_mean_',freq_band,'_sbj',m,'_ch18_t4_p2 mean_mean_',freq_band,'_sbj',m,'_ch18_t4_p3])'])
    eval(['errorbar([mean_mean_',freq_band,'_sbj',m,'_ch18_t4_p0 mean_mean_',freq_band,'_sbj',m,'_ch18_t4_p1 mean_mean_',freq_band,'_sbj',m,'_ch18_t4_p2 mean_mean_',freq_band,'_sbj',m,'_ch18_t4_p3],',...
        '[se_mean_',freq_band,'_sbj',m,'_ch18_t4_p0 se_mean_',freq_band,'_sbj',m,'_ch18_t4_p1 se_mean_',freq_band,'_sbj',m,'_ch18_t4_p2 se_mean_',freq_band,'_sbj',m,'_ch18_t4_p3],''.k'')'])
    ylim_49=get(gca,'ylim');
    set(gca,'XTick',[1:4],'XTickLabel',{'r';'h';'p';'m'})
    eval(['[p_mean_',freq_band,'_sbj',m,'_ch18_t4,table_mean_',freq_band,'_sbj',m,'_ch18_t4,stats_mean_',freq_band,'_sbj',m,...
        '_ch18_t4]=kruskalwallis([mean_',freq_band,'_sbj',m,'_ch18_t4_p0,mean_',freq_band,'_sbj',m,'_ch18_t4_p1,mean_',freq_band,'_sbj',m,'_ch18_t4_p2,mean_',freq_band,'_sbj',m,'_ch18_t4_p3],[grp_plot_49_all],''off'');'])
    if eval(['p_mean_',freq_band,'_sbj',m,'_ch18_t4'])<=0.05
        eval(['title(num2str(p_mean_',freq_band,'_sbj',m,'_ch18_t4),''Color'',[1 0 0])'])
    else
        eval(['title(num2str(p_mean_',freq_band,'_sbj',m,'_ch18_t4))'])
    end

    ymin5=min([ylim_46(1) ylim_47(1) ylim_48(1) ylim_49(1)]);
    ymax5=max([ylim_46(2) ylim_47(2) ylim_48(2) ylim_49(2)]);
    for i=[46:49]
        subplot(10,5,i)
        set(gca,'ylim',[ymin5 ymax5])
    end
    
    subplot(10,5,46)
    eval(['mc_ch18_t1=nr_multcompare_ind_tdcs_plot(stats_mean_',freq_band,'_sbj',m,'_ch18_t1,ymin5);'])
    subplot(10,5,47)
    eval(['mc_ch18_t2=nr_multcompare_ind_tdcs_plot(stats_mean_',freq_band,'_sbj',m,'_ch18_t2,ymin5);'])
    subplot(10,5,48)
    eval(['mc_ch18_t3=nr_multcompare_ind_tdcs_plot(stats_mean_',freq_band,'_sbj',m,'_ch18_t3,ymin5);'])
    subplot(10,5,49)
    eval(['mc_ch18_t4=nr_multcompare_ind_tdcs_plot(stats_mean_',freq_band,'_sbj',m,'_ch18_t4,ymin5);'])
    
    if strcmp(save_fig,'yes')
        saveas(gcf,['~/nr_data_analysis/data_analyzed/eeg/gen_03/analysis_pow/',date_str,'/gen_03_ver_',version,'_',labl,'_ind_',...
            freq_band,'_sbj',m,'.fig'],'fig')
    end
    
    clear Epochcompare epochs find* grps* mat* mc* mean_',freq_band,'_* p_* se* si* stats* table* y*
        
end

if strcmp(save_data,'yes')
        save(['~/nr_data_analysis/data_analyzed/eeg/gen_03/analysis_pow/',date_str,'/gen_03_ver_',version,...
            '_',labl,'_mean_mean_',freq_band,'_ind_all'] ,['mean_mean_',freq_band,'*']) 
end


% find100=find(epochs.',epoch_type,'.t1.atStartPosition.psd.freq<100)
% figure
% plot(epochs.',epoch_type,'.t1.atStartPosition.psd.freq(1:17),log10(epochs.',epoch_type,'.t1.atStartPosition.psd.saw(1:17,:,1)))

% clear
% load('/home/rowlandn/nr_data_analysis/data_analyzed/eeg/gen_02/data/pro00087153_0043/analysis/S3-EEGanalysis/s3_dat.mat')
% clear e* E*
% load('/home/rowlandn/nr_data_analysis/data_analyzed/eeg/gen_03/data/pro00087153_0043/analysis/S3-EEGanalysis/s3_dat.mat')
% save('/home/rowlandn/nr_data_analysis/data_analyzed/eeg/gen_03/data/pro00087153_0043/analysis/S3-EEGanalysis/s3_dat.mat')
% 



