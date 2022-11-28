function step_03_nr_ac_eeg_anal_ser_sum_freq_plots_v01c(grp,epoch_type,freq_band,version,save_figs,save_data,date_str)

%7/3/22
% I first ran this with the original gen_02 data just to make sure it would
% run...DONE
% No sig differences for cs, but there are for hc ipsi stim, beta increases
% then decreases with stim off
% Next I compared to the saved figs for gen_02 and they were identical
% in order to run for gen_03, a number of changes needed to be made:
% I changed how I assigned ipsi vs contra channels (again I manually
% changed 42 and 43 for now)

% sum fig using epochsWhole

%tomorrow just finish substituting freqband for beta, then convert into
%function, save fig, figure out what data the lin reg function needs, save
%that, then compare final figs to the ones generated on left then you are
%readuy to move onto lin reg...DONE

%9/5/22
% added rest and changed stats to friedman

% grp='cs';
% epoch_type='epochsWhole';
% freq_band='beta';
% date_str='2022_09_05';
% version='f';
% save_figs='no';
% save_data='no';

mean_mean_var=['~/nr_data_analysis/data_analyzed/eeg/gen_03/analysis_pow/',date_str,'/gen_03_ver_',version,'_ew_mean_mean_',freq_band,'_ind_all.mat'];

load(mean_mean_var)

if strcmp(grp,'cs')
    sbjs_stm=['03';'04';'05';'42';'43'];
    for n=1:size(sbjs_stm,1)
        load(['/home/rowlandn/nr_data_analysis/data_analyzed/data_for_dlc/pro00087153_00',sbjs_stm(n,:),...
        '_sessioninfo.mat'])
        if strcmp(sessioninfo.stimlat,'R')
            elec_stm_ipsi(n)=18;
            elec_stm_cont(n)=7;
        elseif strcmp(sessioninfo.stimlat,'L')
            elec_stm_ipsi(n)=7;
            elec_stm_cont(n)=18;
        end
        l1_stm_str{n}=sbjs_stm(n,:);
    end
    %%%%%%manually change for 42 and 43%%%%%%
    elec_stm_ipsi(4)=18;
    elec_stm_cont(4)=7;
    elec_stm_ipsi(5)=7;
    elec_stm_cont(5)=18;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    sbjs_non=['13';'15';'17';'18';'21'];
    for n=1:size(sbjs_non,1)
        load(['/home/rowlandn/nr_data_analysis/data_analyzed/data_for_dlc/pro00087153_00',sbjs_non(n,:),...
        '_sessioninfo.mat'])
        if strcmp(sessioninfo.stimlat,'R')
            elec_non_ipsi(n)=18;
            elec_non_cont(n)=7;
        elseif strcmp(sessioninfo.stimlat,'L')
            elec_non_ipsi(n)=7;
            elec_non_cont(n)=18;
        end
        l1_non_str{n}=sbjs_non(n,:);
    end
elseif strcmp(grp,'hc')
    sbjs_stm=['22';'24';'25';'26';'29';'30'];
    for n=1:size(sbjs_stm,1)
        load(['/home/rowlandn/nr_data_analysis/data_analyzed/data_for_dlc/pro00087153_00',sbjs_stm(n,:),...
        '_sessioninfo.mat'])
        if strcmp(sessioninfo.stimlat,'R')
            elec_stm_ipsi(n)=18;
            elec_stm_cont(n)=7;
        elseif strcmp(sessioninfo.stimlat,'L')
            elec_stm_ipsi(n)=7;
            elec_stm_cont(n)=18;
        end
        l1_stm_str{n}=sbjs_stm(n,:);
    end
    sbjs_non=['20';'23';'27';'28';'36'];
    for n=1:size(sbjs_non,1)
        load(['/home/rowlandn/nr_data_analysis/data_analyzed/data_for_dlc/pro00087153_00',sbjs_non(n,:),...
        '_sessioninfo.mat'])
        if strcmp(sessioninfo.stimlat,'R')
            elec_non_ipsi(n)=18;
            elec_non_cont(n)=7;
        elseif strcmp(sessioninfo.stimlat,'L')
            elec_non_ipsi(n)=7;
            elec_non_cont(n)=18;
        end
        l1_non_str{n}=sbjs_non(n,:)
    end
end

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

phase={'atStartPosition';'cueEvent';'targetUp'};

%stim ipsi
for i=1:4
    for k=1:size(sbjs_stm,1)
            load(['/home/rowlandn/nr_data_analysis/data_analyzed/eeg/gen_03/data/pro00087153_00',sbjs_stm(k,:),'/analysis/S3-EEGanalysis/s3_dat_rest.mat'])
            eval(['find_freq_plot_sbj',num2str(sbjs_stm(k,:)),'_ch',num2str(elec_stm_ipsi(k)),'_t',num2str(i),'_p0',...
                '=find(epochs_rest.rest2.t',num2str(i),'.psd.freq<=50);'])
            eval(['psd_sbj',num2str(sbjs_stm(k,:)),'_ch',num2str(elec_stm_ipsi(k)),'_t',num2str(i),'_p0_saw',...
                '=epochs_rest.rest2.t',num2str(i),'.psd.saw(find_freq_plot_sbj',num2str(sbjs_stm(k,:)),...
                '_ch',num2str(elec_stm_ipsi(k)),'_t',num2str(i),'_p0,',num2str(elec_stm_ipsi(k)),',:);'])
            eval(['psd_sbj',num2str(sbjs_stm(k,:)),'_ch',num2str(elec_stm_ipsi(k)),'_t',num2str(i),'_p0_frq',...
                '=epochs_rest.rest2.t',num2str(i),'.psd.freq(find_freq_plot_sbj',num2str(sbjs_stm(k,:)),...
                '_ch',num2str(elec_stm_ipsi(k)),'_t',num2str(i),'_p0);'])
            eval(['psd_mean_sbj',num2str(sbjs_stm(k,:)),'_ch',num2str(elec_stm_ipsi(k)),'_t',num2str(i),'_p0_saw',...
                '=mean(log10(psd_sbj',num2str(sbjs_stm(k,:)),'_ch',num2str(elec_stm_ipsi(k)),'_t',num2str(i),'_p0_saw),3);'])
        clear epochs_rest
    end
       
    for j=1:3
        for k=1:size(sbjs_stm,1)
            load(['/home/rowlandn/nr_data_analysis/data_analyzed/eeg/gen_03/data/pro00087153_00',sbjs_stm(k,:),'/analysis/S3-EEGanalysis/s3_dat.mat'])
            eval(['find_freq_plot_sbj',num2str(sbjs_stm(k,:)),'_ch',num2str(elec_stm_ipsi(k)),'_t',num2str(i),'_p',num2str(j),...
                '=find(epochs.',epoch_type,'.t',num2str(i),'.',phase{j},'.psd.freq<=50);'])
            eval(['psd_sbj',num2str(sbjs_stm(k,:)),'_ch',num2str(elec_stm_ipsi(k)),'_t',num2str(i),'_p',num2str(j),'_saw',...
                '=epochs.',epoch_type,'.t',num2str(i),'.',phase{j},'.psd.saw(find_freq_plot_sbj',num2str(sbjs_stm(k,:)),...
                '_ch',num2str(elec_stm_ipsi(k)),'_t',num2str(i),'_p',num2str(j),',',num2str(elec_stm_ipsi(k)),',:);'])
            eval(['psd_sbj',num2str(sbjs_stm(k,:)),'_ch',num2str(elec_stm_ipsi(k)),'_t',num2str(i),'_p',num2str(j),'_frq',...
                '=epochs.',epoch_type,'.t',num2str(i),'.',phase{j},'.psd.freq(find_freq_plot_sbj',num2str(sbjs_stm(k,:)),...
                '_ch',num2str(elec_stm_ipsi(k)),'_t',num2str(i),'_p',num2str(j),');'])
            eval(['psd_mean_sbj',num2str(sbjs_stm(k,:)),'_ch',num2str(elec_stm_ipsi(k)),'_t',num2str(i),'_p',num2str(j),'_saw',...
                '=mean(log10(psd_sbj',num2str(sbjs_stm(k,:)),'_ch',num2str(elec_stm_ipsi(k)),'_t',num2str(i),'_p',num2str(j),'_saw),3);'])
        clear Epochcompare epochs
        end
    end
end

for i=1:4
    for k=1:size(sbjs_stm,1)
        eval(['mean_mean_sum_',freq_band,'_t',num2str(i),'_p0_stm_ipsi(',num2str(k),')=mean_mean_',freq_band,'_sbj',num2str(sbjs_stm(k,:)),...
            '_ch',num2str(elec_stm_ipsi(k)),'_t',num2str(i),'_p0'])
    end
        
    for j=1:3
        for k=1:size(sbjs_stm,1)
            eval(['mean_mean_sum_',freq_band,'_t',num2str(i),'_p',num2str(j),'_stm_ipsi(',num2str(k),')=mean_mean_',freq_band,'_sbj',num2str(sbjs_stm(k,:)),...
                '_ch',num2str(elec_stm_ipsi(k)),'_t',num2str(i),'_p',num2str(j)])
        end
    end
end

for i=1:4
    eval(['mean_mean_mean_sum_',freq_band,'_t',num2str(i),'_p0_stm_ipsi=mean(mean_mean_sum_',freq_band,'_t',num2str(i),'_p0_stm_ipsi);'])
    eval(['se_mean_mean_sum_',freq_band,'_t',num2str(i),'_p0_stm_ipsi=std(mean_mean_sum_',freq_band,'_t',num2str(i),'_p0',...
            '_stm_ipsi)/sqrt(size(mean_mean_sum_',freq_band,'_t',num2str(i),'_p0_stm_ipsi,2))'])
       
    for j=1:3
        eval(['mean_mean_mean_sum_',freq_band,'_t',num2str(i),'_p',num2str(j),'_stm_ipsi=mean(mean_mean_sum_',freq_band,'_t',num2str(i),'_p',num2str(j),'_stm_ipsi);'])
        eval(['se_mean_mean_sum_',freq_band,'_t',num2str(i),'_p',num2str(j),'_stm_ipsi=std(mean_mean_sum_',freq_band,'_t',num2str(i),'_p',num2str(j),...
            '_stm_ipsi)/sqrt(size(mean_mean_sum_',freq_band,'_t',num2str(i),'_p',num2str(j),'_stm_ipsi,2))'])
    end
end

figure; set(gcf,'Position',[1507 -65 744 898]); hold on
for i=1:4
    subplot(10,5,i)
    hold on
    for k=1:size(sbjs_stm,1)
                eval(['plot(psd_sbj',num2str(sbjs_stm(k,:)),'_ch',num2str(elec_stm_ipsi(k)),'_t',num2str(i),'_p0_frq,',...
                    'psd_mean_sbj',num2str(sbjs_stm(k,:)),'_ch',num2str(elec_stm_ipsi(k)),'_t',num2str(i),'_p0_saw,''LineWidth'',2)'])
        if i==1
            ylabel('Rest')
            title([grp,' all:ipsi stm:t1:',freq_band,':',labl,':ver ',version])
        else
            title(['t',num2str(i)])    
        end
        eval(['ylim_0',num2str(i),'=get(gca,''ylim'');'])
    end
        
    
end

count=0;
for j=1:3
    for i=1:4
        count=count+1;
        if j==1
            subplot(10,5,i+5); hold on
            sp=i+5;
        elseif j==2
            subplot(10,5,i+10); hold on
            sp=i+10;
        elseif j==3
            subplot(10,5,i+15); hold on
            sp=i+15;
        end
         
        for k=1:size(sbjs_stm,1)
            eval(['plot(psd_sbj',num2str(sbjs_stm(k,:)),'_ch',num2str(elec_stm_ipsi(k)),'_t',num2str(i),'_p',num2str(j),'_frq,',...
                'psd_mean_sbj',num2str(sbjs_stm(k,:)),'_ch',num2str(elec_stm_ipsi(k)),'_t',num2str(i),'_p',num2str(j),'_saw,''LineWidth'',2)'])
        end
        
        if count+4<10
            eval(['ylim_0',num2str(count+4),'=get(gca,''ylim'');'])
        elseif count+4>=10
            eval(['ylim_',num2str(count+4),'=get(gca,''ylim'');'])
        end
           
        if count==1
            ylabel('atStartPosition')
            %title([grp,' all:ipsi stm:t1:',freq_band,':',labl,':ver ',version])
%         elseif count==2
%             title('t2')
%         elseif count==3
%             title('t3')
%         elseif count==4
%             title('t4')
        elseif count==5
            ylabel('cueEvent')
        elseif count==9
            ylabel('targetUp')
        elseif count==12
            l1_stm_ipsi=legend;
        end
     end
end
min_ylim=min([ylim_01(1) ylim_02(1) ylim_03(1) ylim_04(1) ylim_05(1) ylim_06(1) ylim_07(1) ylim_08(1) ylim_09(1) ylim_10(1) ylim_11(1) ylim_12(1) ylim_13(1) ylim_14(1) ylim_15(1) ylim_16(1)]);
max_ylim=max([ylim_01(2) ylim_02(2) ylim_03(2) ylim_04(2) ylim_05(2) ylim_06(2) ylim_07(2) ylim_08(2) ylim_09(2) ylim_10(2) ylim_11(2) ylim_12(2) ylim_13(2) ylim_14(2) ylim_15(2) ylim_16(2)]);
for i=[1 2 3 4 6 7 8 9 11 12 13 14 16 17 18 19]
    subplot(10,5,i)
    set(gca,'ylim',[min_ylim max_ylim])
    plot([frq_rng_st frq_rng_st],[min_ylim max_ylim],'r')
    plot([frq_rng_ed frq_rng_ed],[min_ylim max_ylim],'r')
end
%set(l1,'String',{'sbj03','sbj04','sbj05','sbj42','sbj43'},'Position',[0.7837 0.5323 0.1051 0.0797])
set(l1_stm_ipsi,'String',l1_stm_str,'Position',[0.7891 0.5167 0.1051 0.0797])

subplot(10,5,5); hold on
eval(['bar([mean_mean_mean_sum_',freq_band,'_t1_p0_stm_ipsi mean_mean_mean_sum_',freq_band,'_t2_p0_stm_ipsi mean_mean_mean_sum_',freq_band,'_t3_p0_stm_ipsi mean_mean_mean_sum_',freq_band,'_t4_p0_stm_ipsi])'])
eval(['errorbar([mean_mean_mean_sum_',freq_band,'_t1_p0_stm_ipsi mean_mean_mean_sum_',freq_band,'_t2_p0_stm_ipsi mean_mean_mean_sum_',freq_band,'_t3_p0_stm_ipsi mean_mean_mean_sum_',freq_band,'_t4_p0_stm_ipsi],'...
    '[se_mean_mean_sum_',freq_band,'_t1_p0_stm_ipsi se_mean_mean_sum_',freq_band,'_t2_p0_stm_ipsi se_mean_mean_sum_',freq_band,'_t3_p0_stm_ipsi se_mean_mean_sum_',freq_band,'_t4_p0_stm_ipsi],''.k'')'])
set(gca,'XTick',[1:4],'XTickLabel',['t1';'t2';'t3';'t4'])
eval(['[p_mean_mean_sum_',freq_band,'_p0,anovatab_mean_mean_sum_',freq_band,'_p0,stats_mean_mean_sum_',freq_band,'_p0]='...
    'friedman([mean_mean_sum_',freq_band,'_t1_p0_stm_ipsi'',mean_mean_sum_',freq_band,'_t2_p0_stm_ipsi'',mean_mean_sum_',freq_band,'_t3_p0_stm_ipsi'',mean_mean_sum_',freq_band,'_t4_p0_stm_ipsi''],[1],''off'')'])
if eval(['p_mean_mean_sum_',freq_band,'_p0<=0.05'])
    eval(['title(num2str(p_mean_mean_sum_',freq_band,'_p0),''Color'',[1 0 0])'])
else
    eval(['title(num2str(p_mean_mean_sum_',freq_band,'_p0))'])
end
eval(['nr_multcompare_ind_tdcs_plot(stats_mean_mean_sum_',freq_band,'_p0,min_ylim)'])

subplot(10,5,10); hold on
eval(['bar([mean_mean_mean_sum_',freq_band,'_t1_p1_stm_ipsi mean_mean_mean_sum_',freq_band,'_t2_p1_stm_ipsi mean_mean_mean_sum_',freq_band,'_t3_p1_stm_ipsi mean_mean_mean_sum_',freq_band,'_t4_p1_stm_ipsi])'])
eval(['errorbar([mean_mean_mean_sum_',freq_band,'_t1_p1_stm_ipsi mean_mean_mean_sum_',freq_band,'_t2_p1_stm_ipsi mean_mean_mean_sum_',freq_band,'_t3_p1_stm_ipsi mean_mean_mean_sum_',freq_band,'_t4_p1_stm_ipsi],'...
    '[se_mean_mean_sum_',freq_band,'_t1_p1_stm_ipsi se_mean_mean_sum_',freq_band,'_t2_p1_stm_ipsi se_mean_mean_sum_',freq_band,'_t3_p1_stm_ipsi se_mean_mean_sum_',freq_band,'_t4_p1_stm_ipsi],''.k'')'])
set(gca,'XTick',[1:4],'XTickLabel',['t1';'t2';'t3';'t4'])
eval(['[p_mean_mean_sum_',freq_band,'_p1,anovatab_mean_mean_sum_',freq_band,'_p1,stats_mean_mean_sum_',freq_band,'_p1]='...
    'friedman([mean_mean_sum_',freq_band,'_t1_p1_stm_ipsi'',mean_mean_sum_',freq_band,'_t2_p1_stm_ipsi'',mean_mean_sum_',freq_band,'_t3_p1_stm_ipsi'',mean_mean_sum_',freq_band,'_t4_p1_stm_ipsi''],[1],''off'')'])
if eval(['p_mean_mean_sum_',freq_band,'_p1<=0.05'])
    eval(['title(num2str(p_mean_mean_sum_',freq_band,'_p1),''Color'',[1 0 0])'])
else
    eval(['title(num2str(p_mean_mean_sum_',freq_band,'_p1))'])
end
eval(['nr_multcompare_ind_tdcs_plot(stats_mean_mean_sum_',freq_band,'_p1,min_ylim)'])

subplot(10,5,15); hold on
eval(['bar([mean_mean_mean_sum_',freq_band,'_t1_p2_stm_ipsi mean_mean_mean_sum_',freq_band,'_t2_p2_stm_ipsi mean_mean_mean_sum_',freq_band,'_t3_p2_stm_ipsi mean_mean_mean_sum_',freq_band,'_t4_p2_stm_ipsi])'])
eval(['errorbar([mean_mean_mean_sum_',freq_band,'_t1_p2_stm_ipsi mean_mean_mean_sum_',freq_band,'_t2_p2_stm_ipsi mean_mean_mean_sum_',freq_band,'_t3_p2_stm_ipsi mean_mean_mean_sum_',freq_band,'_t4_p2_stm_ipsi],'...
    '[se_mean_mean_sum_',freq_band,'_t1_p2_stm_ipsi se_mean_mean_sum_',freq_band,'_t2_p2_stm_ipsi se_mean_mean_sum_',freq_band,'_t3_p2_stm_ipsi se_mean_mean_sum_',freq_band,'_t4_p2_stm_ipsi],''.k'')'])
set(gca,'XTick',[1:4],'XTickLabel',['t1';'t2';'t3';'t4'])
eval(['[p_mean_mean_sum_',freq_band,'_p2,anovatab_mean_mean_sum_',freq_band,'_p2,stats_mean_mean_sum_',freq_band,'_p2]='...
    'friedman([mean_mean_sum_',freq_band,'_t1_p2_stm_ipsi'',mean_mean_sum_',freq_band,'_t2_p2_stm_ipsi'',mean_mean_sum_',freq_band,'_t3_p2_stm_ipsi'',mean_mean_sum_',freq_band,'_t4_p2_stm_ipsi''],[1],''off'')'])
if eval(['p_mean_mean_sum_',freq_band,'_p2<=0.05'])
    eval(['title(num2str(p_mean_mean_sum_',freq_band,'_p2),''Color'',[1 0 0])'])
else
    eval(['title(num2str(p_mean_mean_sum_',freq_band,'_p2))'])
end
eval(['nr_multcompare_ind_tdcs_plot(stats_mean_mean_sum_',freq_band,'_p2,min_ylim)'])

subplot(10,5,20); hold on
eval(['bar([mean_mean_mean_sum_',freq_band,'_t1_p3_stm_ipsi mean_mean_mean_sum_',freq_band,'_t2_p3_stm_ipsi mean_mean_mean_sum_',freq_band,'_t3_p3_stm_ipsi mean_mean_mean_sum_',freq_band,'_t4_p3_stm_ipsi])'])
eval(['errorbar([mean_mean_mean_sum_',freq_band,'_t1_p3_stm_ipsi mean_mean_mean_sum_',freq_band,'_t2_p3_stm_ipsi mean_mean_mean_sum_',freq_band,'_t3_p3_stm_ipsi mean_mean_mean_sum_',freq_band,'_t4_p3_stm_ipsi],'...
    '[se_mean_mean_sum_',freq_band,'_t1_p3_stm_ipsi se_mean_mean_sum_',freq_band,'_t2_p3_stm_ipsi se_mean_mean_sum_',freq_band,'_t3_p3_stm_ipsi se_mean_mean_sum_',freq_band,'_t4_p3_stm_ipsi],''.k'')'])
set(gca,'XTick',[1:4],'XTickLabel',['t1';'t2';'t3';'t4'])
eval(['[p_mean_mean_sum_',freq_band,'_p3,anovatab_mean_mean_sum_',freq_band,'_p3,stats_mean_mean_sum_',freq_band,'_p3]='...
    'friedman([mean_mean_sum_',freq_band,'_t1_p3_stm_ipsi'',mean_mean_sum_',freq_band,'_t2_p3_stm_ipsi'',mean_mean_sum_',freq_band,'_t3_p3_stm_ipsi'',mean_mean_sum_',freq_band,'_t4_p3_stm_ipsi''],[1],''off'')'])
if eval(['p_mean_mean_sum_',freq_band,'_p3<=0.05'])
    eval(['title(num2str(p_mean_mean_sum_',freq_band,'_p3),''Color'',[1 0 0])'])
else
    eval(['title(num2str(p_mean_mean_sum_',freq_band,'_p3))'])
end
eval(['nr_multcompare_ind_tdcs_plot(stats_mean_mean_sum_',freq_band,'_p3,min_ylim)'])

subplot(10,5,21); hold on
eval(['bar([mean_mean_mean_sum_',freq_band,'_t1_p0_stm_ipsi mean_mean_mean_sum_',freq_band,'_t1_p1_stm_ipsi mean_mean_mean_sum_',freq_band,'_t1_p2_stm_ipsi mean_mean_mean_sum_',freq_band,'_t1_p3_stm_ipsi])'])
eval(['errorbar([mean_mean_mean_sum_',freq_band,'_t1_p0_stm_ipsi mean_mean_mean_sum_',freq_band,'_t1_p1_stm_ipsi mean_mean_mean_sum_',freq_band,'_t1_p2_stm_ipsi mean_mean_mean_sum_',freq_band,'_t1_p3_stm_ipsi],'...
    '[se_mean_mean_sum_',freq_band,'_t1_p0_stm_ipsi se_mean_mean_sum_',freq_band,'_t1_p1_stm_ipsi se_mean_mean_sum_',freq_band,'_t1_p2_stm_ipsi se_mean_mean_sum_',freq_band,'_t1_p3_stm_ipsi],''.k'')'])
set(gca,'XTick',[1:4],'XTickLabel',['r';'h';'p';'m'])
eval(['[p_mean_mean_sum_',freq_band,'_t1,anovatab_mean_mean_sum_',freq_band,'_t1,stats_mean_mean_sum_',freq_band,'_t1]='...
    'friedman([mean_mean_sum_',freq_band,'_t1_p0_stm_ipsi'',mean_mean_sum_',freq_band,'_t1_p1_stm_ipsi'',mean_mean_sum_',freq_band,'_t1_p2_stm_ipsi'',mean_mean_sum_',freq_band,'_t1_p3_stm_ipsi''],[1],''off'')'])
if eval(['p_mean_mean_sum_',freq_band,'_t1<=0.05'])
    eval(['title(num2str(p_mean_mean_sum_',freq_band,'_t1),''Color'',[1 0 0])'])
else
    eval(['title(num2str(p_mean_mean_sum_',freq_band,'_t1))'])
end
eval(['nr_multcompare_ind_tdcs_plot(stats_mean_mean_sum_',freq_band,'_t1,0)'])

subplot(10,5,22); hold on
eval(['bar([mean_mean_mean_sum_',freq_band,'_t2_p0_stm_ipsi mean_mean_mean_sum_',freq_band,'_t2_p1_stm_ipsi mean_mean_mean_sum_',freq_band,'_t2_p2_stm_ipsi mean_mean_mean_sum_',freq_band,'_t2_p3_stm_ipsi])'])
eval(['errorbar([mean_mean_mean_sum_',freq_band,'_t2_p0_stm_ipsi mean_mean_mean_sum_',freq_band,'_t2_p1_stm_ipsi mean_mean_mean_sum_',freq_band,'_t2_p2_stm_ipsi mean_mean_mean_sum_',freq_band,'_t2_p3_stm_ipsi],'...
    '[se_mean_mean_sum_',freq_band,'_t2_p0_stm_ipsi se_mean_mean_sum_',freq_band,'_t2_p1_stm_ipsi se_mean_mean_sum_',freq_band,'_t2_p2_stm_ipsi se_mean_mean_sum_',freq_band,'_t2_p3_stm_ipsi],''.k'')'])
set(gca,'XTick',[1:4],'XTickLabel',['r';'h';'p';'m'])
eval(['[p_mean_mean_sum_',freq_band,'_t2,anovatab_mean_mean_sum_',freq_band,'_t2,stats_mean_mean_sum_',freq_band,'_t2]='...
    'friedman([mean_mean_sum_',freq_band,'_t2_p0_stm_ipsi'',mean_mean_sum_',freq_band,'_t2_p1_stm_ipsi'',mean_mean_sum_',freq_band,'_t2_p2_stm_ipsi'',mean_mean_sum_',freq_band,'_t2_p3_stm_ipsi''],[1],''off'')'])
if eval(['p_mean_mean_sum_',freq_band,'_t2<=0.05'])
    eval(['title(num2str(p_mean_mean_sum_',freq_band,'_t2),''Color'',[1 0 0])'])
else
    eval(['title(num2str(p_mean_mean_sum_',freq_band,'_t2))'])
end
eval(['mc=nr_multcompare_ind_tdcs_plot(stats_mean_mean_sum_',freq_band,'_t2,0)'])

subplot(10,5,23); hold on
eval(['bar([mean_mean_mean_sum_',freq_band,'_t3_p0_stm_ipsi mean_mean_mean_sum_',freq_band,'_t3_p1_stm_ipsi mean_mean_mean_sum_',freq_band,'_t3_p2_stm_ipsi mean_mean_mean_sum_',freq_band,'_t3_p3_stm_ipsi])'])
eval(['errorbar([mean_mean_mean_sum_',freq_band,'_t3_p0_stm_ipsi mean_mean_mean_sum_',freq_band,'_t3_p1_stm_ipsi mean_mean_mean_sum_',freq_band,'_t3_p2_stm_ipsi mean_mean_mean_sum_',freq_band,'_t3_p3_stm_ipsi],'...
    '[se_mean_mean_sum_',freq_band,'_t3_p0_stm_ipsi se_mean_mean_sum_',freq_band,'_t3_p1_stm_ipsi se_mean_mean_sum_',freq_band,'_t3_p2_stm_ipsi se_mean_mean_sum_',freq_band,'_t3_p3_stm_ipsi],''.k'')'])
set(gca,'XTick',[1:4],'XTickLabel',['r';'h';'p';'m'])
eval(['[p_mean_mean_sum_',freq_band,'_t3,anovatab_mean_mean_sum_',freq_band,'_t3,stats_mean_mean_sum_',freq_band,'_t3]='...
    'friedman([mean_mean_sum_',freq_band,'_t3_p0_stm_ipsi'',mean_mean_sum_',freq_band,'_t3_p1_stm_ipsi'',mean_mean_sum_',freq_band,'_t3_p2_stm_ipsi'',mean_mean_sum_',freq_band,'_t3_p3_stm_ipsi''],[1],''off'')'])
if eval(['p_mean_mean_sum_',freq_band,'_t3<=0.05'])
    eval(['title(num2str(p_mean_mean_sum_',freq_band,'_t3),''Color'',[1 0 0])'])
else
    eval(['title(num2str(p_mean_mean_sum_',freq_band,'_t3))'])
end
eval(['nr_multcompare_ind_tdcs_plot(stats_mean_mean_sum_',freq_band,'_t3,0)'])

subplot(10,5,24); hold on
eval(['bar([mean_mean_mean_sum_',freq_band,'_t4_p0_stm_ipsi mean_mean_mean_sum_',freq_band,'_t4_p1_stm_ipsi mean_mean_mean_sum_',freq_band,'_t4_p2_stm_ipsi mean_mean_mean_sum_',freq_band,'_t4_p3_stm_ipsi])'])
eval(['errorbar([mean_mean_mean_sum_',freq_band,'_t4_p0_stm_ipsi mean_mean_mean_sum_',freq_band,'_t4_p1_stm_ipsi mean_mean_mean_sum_',freq_band,'_t4_p2_stm_ipsi mean_mean_mean_sum_',freq_band,'_t4_p3_stm_ipsi],'...
    '[se_mean_mean_sum_',freq_band,'_t4_p0_stm_ipsi se_mean_mean_sum_',freq_band,'_t4_p1_stm_ipsi se_mean_mean_sum_',freq_band,'_t4_p2_stm_ipsi se_mean_mean_sum_',freq_band,'_t4_p3_stm_ipsi],''.k'')'])
set(gca,'XTick',[1:4],'XTickLabel',['r';'h';'p';'m'])
eval(['[p_mean_mean_sum_',freq_band,'_t4,anovatab_mean_mean_sum_',freq_band,'_t4,stats_mean_mean_sum_',freq_band,'_t4]='...
    'friedman([mean_mean_sum_',freq_band,'_t4_p0_stm_ipsi'',mean_mean_sum_',freq_band,'_t4_p1_stm_ipsi'',mean_mean_sum_',freq_band,'_t4_p2_stm_ipsi'',mean_mean_sum_',freq_band,'_t4_p3_stm_ipsi''],[1],''off'')'])
if eval(['p_mean_mean_sum_',freq_band,'_t4<=0.05'])
    eval(['title(num2str(p_mean_mean_sum_',freq_band,'_t4),''Color'',[1 0 0])'])
else
    eval(['title(num2str(p_mean_mean_sum_',freq_band,'_t4))'])
end
eval(['nr_multcompare_ind_tdcs_plot(stats_mean_mean_sum_',freq_band,'_t4,0)'])
%clear *ipsi
%clear anovatab* p_mean* stats* 

%cont
for i=1:4
    for k=1:size(sbjs_stm,1)
            load(['/home/rowlandn/nr_data_analysis/data_analyzed/eeg/gen_03/data/pro00087153_00',sbjs_stm(k,:),'/analysis/S3-EEGanalysis/s3_dat_rest.mat'])
            eval(['find_freq_plot_sbj',num2str(sbjs_stm(k,:)),'_ch',num2str(elec_stm_cont(k)),'_t',num2str(i),'_p0',...
                '=find(epochs_rest.rest2.t',num2str(i),'.psd.freq<=50);'])
            eval(['psd_sbj',num2str(sbjs_stm(k,:)),'_ch',num2str(elec_stm_cont(k)),'_t',num2str(i),'_p0_saw',...
                '=epochs_rest.rest2.t',num2str(i),'.psd.saw(find_freq_plot_sbj',num2str(sbjs_stm(k,:)),...
                '_ch',num2str(elec_stm_cont(k)),'_t',num2str(i),'_p0,',num2str(elec_stm_cont(k)),',:);'])
            eval(['psd_sbj',num2str(sbjs_stm(k,:)),'_ch',num2str(elec_stm_cont(k)),'_t',num2str(i),'_p0_frq',...
                '=epochs_rest.rest2.t',num2str(i),'.psd.freq(find_freq_plot_sbj',num2str(sbjs_stm(k,:)),...
                '_ch',num2str(elec_stm_cont(k)),'_t',num2str(i),'_p0);'])
            eval(['psd_mean_sbj',num2str(sbjs_stm(k,:)),'_ch',num2str(elec_stm_cont(k)),'_t',num2str(i),'_p0_saw',...
                '=mean(log10(psd_sbj',num2str(sbjs_stm(k,:)),'_ch',num2str(elec_stm_cont(k)),'_t',num2str(i),'_p0_saw),3);'])
        clear epochs_rest
    end
        
    for j=1:3
        for k=1:size(sbjs_stm,1)
            load(['/home/rowlandn/nr_data_analysis/data_analyzed/eeg/gen_03/data/pro00087153_00',sbjs_stm(k,:),'/analysis/S3-EEGanalysis/s3_dat.mat'])
            eval(['find_freq_plot_sbj',num2str(sbjs_stm(k,:)),'_ch',num2str(elec_stm_cont(k)),'_t',num2str(i),'_p',num2str(j),...
                '=find(epochs.',epoch_type,'.t',num2str(i),'.',phase{j},'.psd.freq<=50);'])
            eval(['psd_sbj',num2str(sbjs_stm(k,:)),'_ch',num2str(elec_stm_cont(k)),'_t',num2str(i),'_p',num2str(j),'_saw',...
                '=epochs.',epoch_type,'.t',num2str(i),'.',phase{j},'.psd.saw(find_freq_plot_sbj',num2str(sbjs_stm(k,:)),...
                '_ch',num2str(elec_stm_cont(k)),'_t',num2str(i),'_p',num2str(j),',',num2str(elec_stm_cont(k)),',:);'])
            eval(['psd_sbj',num2str(sbjs_stm(k,:)),'_ch',num2str(elec_stm_cont(k)),'_t',num2str(i),'_p',num2str(j),'_frq',...
                '=epochs.',epoch_type,'.t',num2str(i),'.',phase{j},'.psd.freq(find_freq_plot_sbj',num2str(sbjs_stm(k,:)),...
                '_ch',num2str(elec_stm_cont(k)),'_t',num2str(i),'_p',num2str(j),');'])
            eval(['psd_mean_sbj',num2str(sbjs_stm(k,:)),'_ch',num2str(elec_stm_cont(k)),'_t',num2str(i),'_p',num2str(j),'_saw',...
                '=mean(log10(psd_sbj',num2str(sbjs_stm(k,:)),'_ch',num2str(elec_stm_cont(k)),'_t',num2str(i),'_p',num2str(j),'_saw),3);'])
        clear Epochcompare epochs
        end
    end
end

for i=1:4
    for k=1:size(sbjs_stm,1)
        eval(['mean_mean_sum_',freq_band,'_t',num2str(i),'_p0_stm_cont(',num2str(k),')=mean_mean_',freq_band,'_sbj',num2str(sbjs_stm(k,:)),...
            '_ch',num2str(elec_stm_cont(k)),'_t',num2str(i),'_p0'])
    end
    
    for j=1:3
        for k=1:size(sbjs_stm,1)
            eval(['mean_mean_sum_',freq_band,'_t',num2str(i),'_p',num2str(j),'_stm_cont(',num2str(k),')=mean_mean_',freq_band,'_sbj',num2str(sbjs_stm(k,:)),...
                '_ch',num2str(elec_stm_cont(k)),'_t',num2str(i),'_p',num2str(j)])
        end
    end
end

for i=1:4
    eval(['mean_mean_mean_sum_',freq_band,'_t',num2str(i),'_p0_stm_cont=mean(mean_mean_sum_',freq_band,'_t',num2str(i),'_p0_stm_cont);'])
    eval(['se_mean_mean_sum_',freq_band,'_t',num2str(i),'_p0_stm_cont=std(mean_mean_sum_',freq_band,'_t',num2str(i),'_p0',...
            '_stm_cont)/sqrt(size(mean_mean_sum_',freq_band,'_t',num2str(i),'_p0_stm_cont,2))'])
    
    for j=1:3
        eval(['mean_mean_mean_sum_',freq_band,'_t',num2str(i),'_p',num2str(j),'_stm_cont=mean(mean_mean_sum_',freq_band,'_t',num2str(i),'_p',num2str(j),'_stm_cont)'])
        eval(['se_mean_mean_sum_',freq_band,'_t',num2str(i),'_p',num2str(j),'_stm_cont=std(mean_mean_sum_',freq_band,'_t',num2str(i),'_p',num2str(j),...
            '_stm_cont)/sqrt(size(mean_mean_sum_',freq_band,'_t',num2str(i),'_p',num2str(j),'_stm_cont,2))'])
    end
end

for i=1:4
    subplot(10,5,i+25)
    hold on
    for k=1:size(sbjs_stm,1)
            eval(['plot(psd_sbj',num2str(sbjs_stm(k,:)),'_ch',num2str(elec_stm_cont(k)),'_t',num2str(i),'_p0_frq,',...
                'psd_mean_sbj',num2str(sbjs_stm(k,:)),'_ch',num2str(elec_stm_cont(k)),'_t',num2str(i),'_p0_saw,''LineWidth'',2)'])
            if i==1
                title(['cont stm:t',num2str(i)])
            else
                title(['t',num2str(i)])
            end
            eval(['ylim_',num2str(i+25),'=get(gca,''ylim'');'])
    end
        
    if i==1
        ylabel('Rest')
    end
end

count=29;
for j=1:3
    for i=1:4
        count=count+1;
        if j==1
            subplot(10,5,i+30); hold on
            %sp=i+30;
        elseif j==2
            subplot(10,5,i+35); hold on
            %sp=i+35;
        elseif j==3
            subplot(10,5,i+40); hold on
            %sp=i+40;
        end
         
        for k=1:size(sbjs_stm,1)
            eval(['plot(psd_sbj',num2str(sbjs_stm(k,:)),'_ch',num2str(elec_stm_cont(k)),'_t',num2str(i),'_p',num2str(j),'_frq,',...
                'psd_mean_sbj',num2str(sbjs_stm(k,:)),'_ch',num2str(elec_stm_cont(k)),'_t',num2str(i),'_p',num2str(j),'_saw,''LineWidth'',2)'])
        end
        
        eval(['ylim_',num2str(count),'=get(gca,''ylim'');'])
           
        if count==30
            ylabel('atStartPosition')
            
%         elseif count==22
%             title('t2')
%         elseif count==23
%             title('t3')
%         elseif count==24
%             title('t4')
        elseif count==34
            ylabel('cueEvent')
        elseif count==38
            ylabel('targetUp')
        elseif count==41
            l1_stm_cont=legend
        end
    end
end
min_ylim=min([ylim_26(1) ylim_27(1) ylim_28(1) ylim_29(1) ylim_30(1) ylim_31(1) ylim_32(1) ylim_33(1) ylim_34(1) ylim_35(1) ylim_36(1) ylim_37(1) ylim_38(1) ylim_39(1) ylim_40(1) ylim_41(1)]);
max_ylim=max([ylim_26(2) ylim_27(2) ylim_28(2) ylim_29(2) ylim_30(2) ylim_31(2) ylim_32(2) ylim_33(2) ylim_34(2) ylim_35(2) ylim_36(2) ylim_37(2) ylim_38(2) ylim_39(2) ylim_40(2) ylim_41(2)]);
for i=[26 27 28 29 31 32 33 34 36 37 38 39 41 42 43 44]
    subplot(10,5,i)
    set(gca,'ylim',[min_ylim max_ylim])
    plot([frq_rng_st frq_rng_st],[min_ylim max_ylim],'r')
    plot([frq_rng_ed frq_rng_ed],[min_ylim max_ylim],'r')
end
set(l1_stm_cont,'String',l1_stm_str,'Position',[0.7931 0.0933 0.1051 0.0803])

subplot(10,5,30); hold on
eval(['bar([mean_mean_mean_sum_',freq_band,'_t1_p0_stm_cont mean_mean_mean_sum_',freq_band,'_t2_p0_stm_cont mean_mean_mean_sum_',freq_band,'_t3_p0_stm_cont mean_mean_mean_sum_',freq_band,'_t4_p0_stm_cont])'])
eval(['errorbar([mean_mean_mean_sum_',freq_band,'_t1_p0_stm_cont mean_mean_mean_sum_',freq_band,'_t2_p0_stm_cont mean_mean_mean_sum_',freq_band,'_t3_p0_stm_cont mean_mean_mean_sum_',freq_band,'_t4_p0_stm_cont],'...
    '[se_mean_mean_sum_',freq_band,'_t1_p0_stm_cont se_mean_mean_sum_',freq_band,'_t2_p0_stm_cont se_mean_mean_sum_',freq_band,'_t3_p0_stm_cont se_mean_mean_sum_',freq_band,'_t4_p0_stm_cont],''.k'')'])
set(gca,'XTick',[1:4],'XTickLabel',['t1';'t2';'t3';'t4'])
eval(['[p_mean_mean_sum_',freq_band,'_p0,anovatab_mean_mean_sum_',freq_band,'_p0,stats_mean_mean_sum_',freq_band,'_p0]='...
    'friedman([mean_mean_sum_',freq_band,'_t1_p0_stm_cont'',mean_mean_sum_',freq_band,'_t2_p0_stm_cont'',mean_mean_sum_',freq_band,'_t3_p0_stm_cont'',mean_mean_sum_',freq_band,'_t4_p0_stm_cont''],[1],''off'')'])
if eval(['p_mean_mean_sum_',freq_band,'_p0<=0.05'])
    eval(['title(num2str(p_mean_mean_sum_',freq_band,'_p0),''Color'',[1 0 0])'])
else
    eval(['title(num2str(p_mean_mean_sum_',freq_band,'_p0))'])
end
eval(['nr_multcompare_ind_tdcs_plot(stats_mean_mean_sum_',freq_band,'_p0,min_ylim)'])

subplot(10,5,35); hold on
eval(['bar([mean_mean_mean_sum_',freq_band,'_t1_p1_stm_cont mean_mean_mean_sum_',freq_band,'_t2_p1_stm_cont mean_mean_mean_sum_',freq_band,'_t3_p1_stm_cont mean_mean_mean_sum_',freq_band,'_t4_p1_stm_cont])'])
eval(['errorbar([mean_mean_mean_sum_',freq_band,'_t1_p1_stm_cont mean_mean_mean_sum_',freq_band,'_t2_p1_stm_cont mean_mean_mean_sum_',freq_band,'_t3_p1_stm_cont mean_mean_mean_sum_',freq_band,'_t4_p1_stm_cont],'...
    '[se_mean_mean_sum_',freq_band,'_t1_p1_stm_cont se_mean_mean_sum_',freq_band,'_t2_p1_stm_cont se_mean_mean_sum_',freq_band,'_t3_p1_stm_cont se_mean_mean_sum_',freq_band,'_t4_p1_stm_cont],''.k'')'])
set(gca,'XTick',[1:4],'XTickLabel',['t1';'t2';'t3';'t4'])
eval(['[p_mean_mean_sum_',freq_band,'_p1,anovatab_mean_mean_sum_',freq_band,'_p1,stats_mean_mean_sum_',freq_band,'_p1]='...
    'friedman([mean_mean_sum_',freq_band,'_t1_p1_stm_cont'',mean_mean_sum_',freq_band,'_t2_p1_stm_cont'',mean_mean_sum_',freq_band,'_t3_p1_stm_cont'',mean_mean_sum_',freq_band,'_t4_p1_stm_cont''],[1],''off'')'])
if eval(['p_mean_mean_sum_',freq_band,'_p1<=0.05'])
    eval(['title(num2str(p_mean_mean_sum_',freq_band,'_p1),''Color'',[1 0 0])'])
else
    eval(['title(num2str(p_mean_mean_sum_',freq_band,'_p1))'])
end
eval(['nr_multcompare_ind_tdcs_plot(stats_mean_mean_sum_',freq_band,'_p1,min_ylim)'])

subplot(10,5,40); hold on
eval(['bar([mean_mean_mean_sum_',freq_band,'_t1_p2_stm_cont mean_mean_mean_sum_',freq_band,'_t2_p2_stm_cont mean_mean_mean_sum_',freq_band,'_t3_p2_stm_cont mean_mean_mean_sum_',freq_band,'_t4_p2_stm_cont])'])
eval(['errorbar([mean_mean_mean_sum_',freq_band,'_t1_p2_stm_cont mean_mean_mean_sum_',freq_band,'_t2_p2_stm_cont mean_mean_mean_sum_',freq_band,'_t3_p2_stm_cont mean_mean_mean_sum_',freq_band,'_t4_p2_stm_cont],'...
    '[se_mean_mean_sum_',freq_band,'_t1_p2_stm_cont se_mean_mean_sum_',freq_band,'_t2_p2_stm_cont se_mean_mean_sum_',freq_band,'_t3_p2_stm_cont se_mean_mean_sum_',freq_band,'_t4_p2_stm_cont],''.k'')'])
set(gca,'XTick',[1:4],'XTickLabel',['t1';'t2';'t3';'t4'])
eval(['[p_mean_mean_sum_',freq_band,'_p2,anovatab_mean_mean_sum_',freq_band,'_p2,stats_mean_mean_sum_',freq_band,'_p2]='...
    'friedman([mean_mean_sum_',freq_band,'_t1_p2_stm_cont'',mean_mean_sum_',freq_band,'_t2_p2_stm_cont'',mean_mean_sum_',freq_band,'_t3_p2_stm_cont'',mean_mean_sum_',freq_band,'_t4_p2_stm_cont''],[1],''off'')'])
if eval(['p_mean_mean_sum_',freq_band,'_p2<=0.05'])
    eval(['title(num2str(p_mean_mean_sum_',freq_band,'_p2),''Color'',[1 0 0])'])
else
    eval(['title(num2str(p_mean_mean_sum_',freq_band,'_p2))'])
end
eval(['nr_multcompare_ind_tdcs_plot(stats_mean_mean_sum_',freq_band,'_p2,min_ylim)'])

subplot(10,5,45); hold on
eval(['bar([mean_mean_mean_sum_',freq_band,'_t1_p3_stm_cont mean_mean_mean_sum_',freq_band,'_t2_p3_stm_cont mean_mean_mean_sum_',freq_band,'_t3_p3_stm_cont mean_mean_mean_sum_',freq_band,'_t4_p3_stm_cont])'])
eval(['errorbar([mean_mean_mean_sum_',freq_band,'_t1_p3_stm_cont mean_mean_mean_sum_',freq_band,'_t2_p3_stm_cont mean_mean_mean_sum_',freq_band,'_t3_p3_stm_cont mean_mean_mean_sum_',freq_band,'_t4_p3_stm_cont],'...
    '[se_mean_mean_sum_',freq_band,'_t1_p3_stm_cont se_mean_mean_sum_',freq_band,'_t2_p3_stm_cont se_mean_mean_sum_',freq_band,'_t3_p3_stm_cont se_mean_mean_sum_',freq_band,'_t4_p3_stm_cont],''.k'')'])
set(gca,'XTick',[1:4],'XTickLabel',['t1';'t2';'t3';'t4'])
eval(['[p_mean_mean_sum_',freq_band,'_p3,anovatab_mean_mean_sum_',freq_band,'_p3,stats_mean_mean_sum_',freq_band,'_p3]='...
    'friedman([mean_mean_sum_',freq_band,'_t1_p3_stm_cont'',mean_mean_sum_',freq_band,'_t2_p3_stm_cont'',mean_mean_sum_',freq_band,'_t3_p3_stm_cont'',mean_mean_sum_',freq_band,'_t4_p3_stm_cont''],[1],''off'')'])
if eval(['p_mean_mean_sum_',freq_band,'_p3<=0.05'])
    eval(['title(num2str(p_mean_mean_sum_',freq_band,'_p3),''Color'',[1 0 0])'])
else
    eval(['title(num2str(p_mean_mean_sum_',freq_band,'_p3))'])
end
eval(['nr_multcompare_ind_tdcs_plot(stats_mean_mean_sum_',freq_band,'_p3,min_ylim)'])

subplot(10,5,46); hold on
eval(['bar([ mean_mean_mean_sum_',freq_band,'_t1_p0_stm_cont mean_mean_mean_sum_',freq_band,'_t1_p1_stm_cont mean_mean_mean_sum_',freq_band,'_t1_p2_stm_cont mean_mean_mean_sum_',freq_band,'_t1_p3_stm_cont])'])
eval(['errorbar([mean_mean_mean_sum_',freq_band,'_t1_p0_stm_cont mean_mean_mean_sum_',freq_band,'_t1_p1_stm_cont mean_mean_mean_sum_',freq_band,'_t1_p2_stm_cont mean_mean_mean_sum_',freq_band,'_t1_p3_stm_cont],'...
    '[se_mean_mean_sum_',freq_band,'_t1_p0_stm_cont se_mean_mean_sum_',freq_band,'_t1_p1_stm_cont se_mean_mean_sum_',freq_band,'_t1_p2_stm_cont se_mean_mean_sum_',freq_band,'_t1_p3_stm_cont],''.k'')'])
set(gca,'XTick',[1:4],'XTickLabel',['r';'h';'p';'m'])
eval(['[p_mean_mean_sum_',freq_band,'_t1,anovatab_mean_mean_sum_',freq_band,'_t1,stats_mean_mean_sum_',freq_band,'_t1]='...
    'friedman([mean_mean_sum_',freq_band,'_t1_p0_stm_cont'',mean_mean_sum_',freq_band,'_t1_p1_stm_cont'',mean_mean_sum_',freq_band,'_t1_p2_stm_cont'',mean_mean_sum_',freq_band,'_t1_p3_stm_cont''],[1],''off'')'])
if eval(['p_mean_mean_sum_',freq_band,'_t1<=0.05'])
    eval(['title(num2str(p_mean_mean_sum_',freq_band,'_t1),''Color'',[1 0 0])'])
else
    eval(['title(num2str(p_mean_mean_sum_',freq_band,'_t1))'])
end
eval(['nr_multcompare_ind_tdcs_plot(stats_mean_mean_sum_',freq_band,'_t1,0)'])

subplot(10,5,47); hold on
eval(['bar([mean_mean_mean_sum_',freq_band,'_t2_p0_stm_cont mean_mean_mean_sum_',freq_band,'_t2_p1_stm_cont mean_mean_mean_sum_',freq_band,'_t2_p2_stm_cont mean_mean_mean_sum_',freq_band,'_t2_p3_stm_cont])'])
eval(['errorbar([mean_mean_mean_sum_',freq_band,'_t2_p0_stm_cont mean_mean_mean_sum_',freq_band,'_t2_p1_stm_cont mean_mean_mean_sum_',freq_band,'_t2_p2_stm_cont mean_mean_mean_sum_',freq_band,'_t2_p3_stm_cont],'...
    '[se_mean_mean_sum_',freq_band,'_t2_p0_stm_cont se_mean_mean_sum_',freq_band,'_t2_p1_stm_cont se_mean_mean_sum_',freq_band,'_t2_p2_stm_cont se_mean_mean_sum_',freq_band,'_t2_p3_stm_cont],''.k'')'])
set(gca,'XTick',[1:4],'XTickLabel',['r';'h';'p';'m'])
eval(['[p_mean_mean_sum_',freq_band,'_t2,anovatab_mean_mean_sum_',freq_band,'_t2,stats_mean_mean_sum_',freq_band,'_t2]='...
    'friedman([mean_mean_sum_',freq_band,'_t2_p0_stm_cont'',mean_mean_sum_',freq_band,'_t2_p1_stm_cont'',mean_mean_sum_',freq_band,'_t2_p2_stm_cont'',mean_mean_sum_',freq_band,'_t2_p3_stm_cont''],[1],''off'')'])
if eval(['p_mean_mean_sum_',freq_band,'_t2<=0.05'])
    eval(['title(num2str(p_mean_mean_sum_',freq_band,'_t2),''Color'',[1 0 0])'])
else
    eval(['title(num2str(p_mean_mean_sum_',freq_band,'_t2))'])
end
eval(['nr_multcompare_ind_tdcs_plot(stats_mean_mean_sum_',freq_band,'_t2,0)'])

subplot(10,5,48); hold on
eval(['bar([mean_mean_mean_sum_',freq_band,'_t3_p0_stm_cont mean_mean_mean_sum_',freq_band,'_t3_p1_stm_cont mean_mean_mean_sum_',freq_band,'_t3_p2_stm_cont mean_mean_mean_sum_',freq_band,'_t3_p3_stm_cont])'])
eval(['errorbar([mean_mean_mean_sum_',freq_band,'_t3_p0_stm_cont mean_mean_mean_sum_',freq_band,'_t3_p1_stm_cont mean_mean_mean_sum_',freq_band,'_t3_p2_stm_cont mean_mean_mean_sum_',freq_band,'_t3_p3_stm_cont],'...
    '[se_mean_mean_sum_',freq_band,'_t3_p0_stm_cont se_mean_mean_sum_',freq_band,'_t3_p1_stm_cont se_mean_mean_sum_',freq_band,'_t3_p2_stm_cont se_mean_mean_sum_',freq_band,'_t3_p3_stm_cont],''.k'')'])
set(gca,'XTick',[1:4],'XTickLabel',['r';'h';'p';'m'])
eval(['[p_mean_mean_sum_',freq_band,'_t3,anovatab_mean_mean_sum_',freq_band,'_t3,stats_mean_mean_sum_',freq_band,'_t3]='...
    'friedman([mean_mean_sum_',freq_band,'_t3_p0_stm_cont'',mean_mean_sum_',freq_band,'_t3_p1_stm_cont'',mean_mean_sum_',freq_band,'_t3_p2_stm_cont'',mean_mean_sum_',freq_band,'_t3_p3_stm_cont''],[1],''off'')'])
if eval(['p_mean_mean_sum_',freq_band,'_t3<=0.05'])
    eval(['title(num2str(p_mean_mean_sum_',freq_band,'_t3),''Color'',[1 0 0])'])
else
    eval(['title(num2str(p_mean_mean_sum_',freq_band,'_t3))'])
end
eval(['nr_multcompare_ind_tdcs_plot(stats_mean_mean_sum_',freq_band,'_t3,0)'])

subplot(10,5,49); hold on
eval(['bar([mean_mean_mean_sum_',freq_band,'_t4_p0_stm_cont mean_mean_mean_sum_',freq_band,'_t4_p1_stm_cont mean_mean_mean_sum_',freq_band,'_t4_p2_stm_cont mean_mean_mean_sum_',freq_band,'_t4_p3_stm_cont])'])
eval(['errorbar([mean_mean_mean_sum_',freq_band,'_t4_p0_stm_cont mean_mean_mean_sum_',freq_band,'_t4_p1_stm_cont mean_mean_mean_sum_',freq_band,'_t4_p2_stm_cont mean_mean_mean_sum_',freq_band,'_t4_p3_stm_cont],'...
    '[se_mean_mean_sum_',freq_band,'_t4_p0_stm_cont se_mean_mean_sum_',freq_band,'_t4_p1_stm_cont se_mean_mean_sum_',freq_band,'_t4_p2_stm_cont se_mean_mean_sum_',freq_band,'_t4_p3_stm_cont],''.k'')'])
set(gca,'XTick',[1:4],'XTickLabel',['r';'h';'p';'m'])
eval(['[p_mean_mean_sum_',freq_band,'_t4,anovatab_mean_mean_sum_',freq_band,'_t4,stats_mean_mean_sum_',freq_band,'_t4]='...
    'friedman([mean_mean_sum_',freq_band,'_t4_p0_stm_cont'',mean_mean_sum_',freq_band,'_t4_p1_stm_cont'',mean_mean_sum_',freq_band,'_t4_p2_stm_cont'',mean_mean_sum_',freq_band,'_t4_p3_stm_cont''],[1],''off'')'])
if eval(['p_mean_mean_sum_',freq_band,'_t4<=0.05'])
    eval(['title(num2str(p_mean_mean_sum_',freq_band,'_t4),''Color'',[1 0 0])'])
else
    eval(['title(num2str(p_mean_mean_sum_',freq_band,'_t4))'])
end
eval(['nr_multcompare_ind_tdcs_plot(stats_mean_mean_sum_',freq_band,'_t4,0)'])

clear anovatab* p_mean* stats* 

if strcmp(save_figs,'yes')
    saveas(gcf,['~/nr_data_analysis/data_analyzed/eeg/gen_03/analysis_pow/',date_str,'/gen_03_ver_',version,'_',labl,'_sum_',freq_band,'_',grp,'_stm.fig'],'fig')
end

%non ipsi
for i=1:4
    for k=1:size(sbjs_non,1)
            load(['/home/rowlandn/nr_data_analysis/data_analyzed/eeg/gen_03/data/pro00087153_00',sbjs_non(k,:),'/analysis/S3-EEGanalysis/s3_dat_rest.mat'])
            eval(['find_freq_plot_sbj',num2str(sbjs_non(k,:)),'_ch',num2str(elec_non_ipsi(k)),'_t',num2str(i),'_p0',...
                '=find(epochs_rest.rest2.t',num2str(i),'.psd.freq<=50);'])
            eval(['psd_sbj',num2str(sbjs_non(k,:)),'_ch',num2str(elec_non_ipsi(k)),'_t',num2str(i),'_p0_saw',...
                '=epochs_rest.rest2.t',num2str(i),'.psd.saw(find_freq_plot_sbj',num2str(sbjs_non(k,:)),...
                '_ch',num2str(elec_non_ipsi(k)),'_t',num2str(i),'_p0,',num2str(elec_non_ipsi(k)),',:);'])
            eval(['psd_sbj',num2str(sbjs_non(k,:)),'_ch',num2str(elec_non_ipsi(k)),'_t',num2str(i),'_p0_frq',...
                '=epochs_rest.rest2.t',num2str(i),'.psd.freq(find_freq_plot_sbj',num2str(sbjs_non(k,:)),...
                '_ch',num2str(elec_non_ipsi(k)),'_t',num2str(i),'_p0);'])
            eval(['psd_mean_sbj',num2str(sbjs_non(k,:)),'_ch',num2str(elec_non_ipsi(k)),'_t',num2str(i),'_p0_saw',...
                '=mean(log10(psd_sbj',num2str(sbjs_non(k,:)),'_ch',num2str(elec_non_ipsi(k)),'_t',num2str(i),'_p0_saw),3);'])
        clear epochs_rest
    end
    
    for j=1:3
        for k=1:size(sbjs_non,1)
            load(['/home/rowlandn/nr_data_analysis/data_analyzed/eeg/gen_03/data/pro00087153_00',sbjs_non(k,:),'/analysis/S3-EEGanalysis/s3_dat.mat'])
            eval(['find_freq_plot_sbj',num2str(sbjs_non(k,:)),'_ch',num2str(elec_non_ipsi(k)),'_t',num2str(i),'_p',num2str(j),...
                '=find(epochs.',epoch_type,'.t',num2str(i),'.',phase{j},'.psd.freq<=50);'])
            eval(['psd_sbj',num2str(sbjs_non(k,:)),'_ch',num2str(elec_non_ipsi(k)),'_t',num2str(i),'_p',num2str(j),'_saw',...
                '=epochs.',epoch_type,'.t',num2str(i),'.',phase{j},'.psd.saw(find_freq_plot_sbj',num2str(sbjs_non(k,:)),...
                '_ch',num2str(elec_non_ipsi(k)),'_t',num2str(i),'_p',num2str(j),',',num2str(elec_non_ipsi(k)),',:);'])
            eval(['psd_sbj',num2str(sbjs_non(k,:)),'_ch',num2str(elec_non_ipsi(k)),'_t',num2str(i),'_p',num2str(j),'_frq',...
                '=epochs.',epoch_type,'.t',num2str(i),'.',phase{j},'.psd.freq(find_freq_plot_sbj',num2str(sbjs_non(k,:)),...
                '_ch',num2str(elec_non_ipsi(k)),'_t',num2str(i),'_p',num2str(j),');'])
            eval(['psd_mean_sbj',num2str(sbjs_non(k,:)),'_ch',num2str(elec_non_ipsi(k)),'_t',num2str(i),'_p',num2str(j),'_saw',...
                '=mean(log10(psd_sbj',num2str(sbjs_non(k,:)),'_ch',num2str(elec_non_ipsi(k)),'_t',num2str(i),'_p',num2str(j),'_saw),3);'])
        clear Epochcompare epochs
        end
    end
end

for i=1:4
    for k=1:size(sbjs_non,1)
        eval(['mean_mean_sum_',freq_band,'_t',num2str(i),'_p0_non_ipsi(',num2str(k),')=mean_mean_',freq_band,'_sbj',num2str(sbjs_non(k,:)),...
            '_ch',num2str(elec_non_ipsi(k)),'_t',num2str(i),'_p0'])
    end
    
    for j=1:3
        for k=1:size(sbjs_non,1)
            eval(['mean_mean_sum_',freq_band,'_t',num2str(i),'_p',num2str(j),'_non_ipsi(',num2str(k),')=mean_mean_',freq_band,'_sbj',num2str(sbjs_non(k,:)),...
                '_ch',num2str(elec_non_ipsi(k)),'_t',num2str(i),'_p',num2str(j)])
        end
    end
end

for i=1:4
    eval(['mean_mean_mean_sum_',freq_band,'_t',num2str(i),'_p0_non_ipsi=mean(mean_mean_sum_',freq_band,'_t',num2str(i),'_p0_non_ipsi);'])
    eval(['se_mean_mean_sum_',freq_band,'_t',num2str(i),'_p0_non_ipsi=std(mean_mean_sum_',freq_band,'_t',num2str(i),'_p0',...
            '_non_ipsi)/sqrt(size(mean_mean_sum_',freq_band,'_t',num2str(i),'_p0_non_ipsi,2))'])
     
    for j=1:3
        eval(['mean_mean_mean_sum_',freq_band,'_t',num2str(i),'_p',num2str(j),'_non_ipsi=mean(mean_mean_sum_',freq_band,'_t',num2str(i),'_p',num2str(j),'_non_ipsi)'])
        eval(['se_mean_mean_sum_',freq_band,'_t',num2str(i),'_p',num2str(j),'_non_ipsi=std(mean_mean_sum_',freq_band,'_t',num2str(i),'_p',num2str(j),...
            '_non_ipsi)/sqrt(size(mean_mean_sum_',freq_band,'_t',num2str(i),'_p',num2str(j),'_non_ipsi,2))'])
    end
end

figure; set(gcf,'Position',[3 47 744 898]); hold on
for i=1:4
    subplot(10,5,i)
    hold on
    for k=1:size(sbjs_non,1)
                eval(['plot(psd_sbj',num2str(sbjs_non(k,:)),'_ch',num2str(elec_non_ipsi(k)),'_t',num2str(i),'_p0_frq,',...
                    'psd_mean_sbj',num2str(sbjs_non(k,:)),'_ch',num2str(elec_non_ipsi(k)),'_t',num2str(i),'_p0_saw,''LineWidth'',2)'])
        if i==1
            ylabel('Rest')
            title([grp,' all:ipsi non:t1:',freq_band,':',labl,':ver ',version])
        else
            title(['t',num2str(i)])    
        end
        eval(['ylim_0',num2str(i),'=get(gca,''ylim'');'])
    end
        
    
end

count=0;
for j=1:3
    for i=1:4
        count=count+1;
        if j==1
            subplot(10,5,i+5); hold on
            sp=i+5;
        elseif j==2
            subplot(10,5,i+10); hold on
            sp=i+10;
        elseif j==3
            subplot(10,5,i+15); hold on
            sp=i+15;
        end
         
        for k=1:size(sbjs_non,1)
            eval(['plot(psd_sbj',num2str(sbjs_non(k,:)),'_ch',num2str(elec_non_ipsi(k)),'_t',num2str(i),'_p',num2str(j),'_frq,',...
                'psd_mean_sbj',num2str(sbjs_non(k,:)),'_ch',num2str(elec_non_ipsi(k)),'_t',num2str(i),'_p',num2str(j),'_saw,''LineWidth'',2)'])
        end
        
        if count+4<10
            eval(['ylim_0',num2str(count+4),'=get(gca,''ylim'');'])
        elseif count+4>=10
            eval(['ylim_',num2str(count+4),'=get(gca,''ylim'');'])
        end
           
        if count==1
            ylabel('atStartPosition')
%             title([grp,' all:ipsi non:t1:',labl])
%         elseif count==2
%             title('t2')
%         elseif count==3
%             title('t3')
%         elseif count==4
%             title('t4')
        elseif count==5
            ylabel('cueEvent')
        elseif count==9
            ylabel('targetUp')
        elseif count==12
            l1_non_ipsi=legend;
        end
    end
end
min_ylim=min([ylim_01(1) ylim_02(1) ylim_03(1) ylim_04(1) ylim_05(1) ylim_06(1) ylim_07(1) ylim_08(1) ylim_09(1) ylim_10(1) ylim_11(1) ylim_12(1) ylim_13(1) ylim_14(1) ylim_15(1) ylim_16(1)]);
max_ylim=max([ylim_01(2) ylim_02(2) ylim_03(2) ylim_04(2) ylim_05(2) ylim_06(2) ylim_07(2) ylim_08(2) ylim_09(2) ylim_10(2) ylim_11(2) ylim_12(2) ylim_13(2) ylim_14(2) ylim_15(2) ylim_16(2)]);
for i=[1 2 3 4 6 7 8 9 11 12 13 14 16 17 18 19]
    subplot(10,5,i)
    set(gca,'ylim',[min_ylim max_ylim])
    plot([frq_rng_st frq_rng_st],[min_ylim max_ylim],'r')
    plot([frq_rng_ed frq_rng_ed],[min_ylim max_ylim],'r')
end
set(l1_non_ipsi,'String',l1_non_str,'Position',[0.7924 0.5163 0.1037 0.0803])

subplot(10,5,5); hold on
eval(['bar([mean_mean_mean_sum_',freq_band,'_t1_p0_non_ipsi mean_mean_mean_sum_',freq_band,'_t2_p0_non_ipsi mean_mean_mean_sum_',freq_band,'_t3_p0_non_ipsi mean_mean_mean_sum_',freq_band,'_t4_p0_non_ipsi])'])
eval(['errorbar([mean_mean_mean_sum_',freq_band,'_t1_p0_non_ipsi mean_mean_mean_sum_',freq_band,'_t2_p0_non_ipsi mean_mean_mean_sum_',freq_band,'_t3_p0_non_ipsi mean_mean_mean_sum_',freq_band,'_t4_p0_non_ipsi],'...
    '[se_mean_mean_sum_',freq_band,'_t1_p0_non_ipsi se_mean_mean_sum_',freq_band,'_t2_p0_non_ipsi se_mean_mean_sum_',freq_band,'_t3_p0_non_ipsi se_mean_mean_sum_',freq_band,'_t4_p0_non_ipsi],''.k'')'])
set(gca,'XTick',[1:4],'XTickLabel',['t1';'t2';'t3';'t4'])
eval(['[p_mean_mean_sum_',freq_band,'_p0,anovatab_mean_mean_sum_',freq_band,'_p0,stats_mean_mean_sum_',freq_band,'_p0]='...
    'friedman([mean_mean_sum_',freq_band,'_t1_p0_non_ipsi'',mean_mean_sum_',freq_band,'_t2_p0_non_ipsi'',mean_mean_sum_',freq_band,'_t3_p0_non_ipsi'',mean_mean_sum_',freq_band,'_t4_p0_non_ipsi''],[1],''off'')'])
if eval(['p_mean_mean_sum_',freq_band,'_p0<=0.05'])
    eval(['title(num2str(p_mean_mean_sum_',freq_band,'_p0),''Color'',[1 0 0])'])
else
    eval(['title(num2str(p_mean_mean_sum_',freq_band,'_p0))'])
end
eval(['nr_multcompare_ind_tdcs_plot(stats_mean_mean_sum_',freq_band,'_p0,min_ylim)'])

subplot(10,5,10); hold on
eval(['bar([mean_mean_mean_sum_',freq_band,'_t1_p1_non_ipsi mean_mean_mean_sum_',freq_band,'_t2_p1_non_ipsi mean_mean_mean_sum_',freq_band,'_t3_p1_non_ipsi mean_mean_mean_sum_',freq_band,'_t4_p1_non_ipsi])'])
eval(['errorbar([mean_mean_mean_sum_',freq_band,'_t1_p1_non_ipsi mean_mean_mean_sum_',freq_band,'_t2_p1_non_ipsi mean_mean_mean_sum_',freq_band,'_t3_p1_non_ipsi mean_mean_mean_sum_',freq_band,'_t4_p1_non_ipsi],'...
    '[se_mean_mean_sum_',freq_band,'_t1_p1_non_ipsi se_mean_mean_sum_',freq_band,'_t2_p1_non_ipsi se_mean_mean_sum_',freq_band,'_t3_p1_non_ipsi se_mean_mean_sum_',freq_band,'_t4_p1_non_ipsi],''.k'')'])
set(gca,'XTick',[1:4],'XTickLabel',['t1';'t2';'t3';'t4'])
eval(['[p_mean_mean_sum_',freq_band,'_p1,anovatab_mean_mean_sum_',freq_band,'_p1,stats_mean_mean_sum_',freq_band,'_p1]='...
    'friedman([mean_mean_sum_',freq_band,'_t1_p1_non_ipsi'',mean_mean_sum_',freq_band,'_t2_p1_non_ipsi'',mean_mean_sum_',freq_band,'_t3_p1_non_ipsi'',mean_mean_sum_',freq_band,'_t4_p1_non_ipsi''],[1],''off'')'])
if eval(['p_mean_mean_sum_',freq_band,'_p1<=0.05'])
    eval(['title(num2str(p_mean_mean_sum_',freq_band,'_p1),''Color'',[1 0 0])'])
else
    eval(['title(num2str(p_mean_mean_sum_',freq_band,'_p1))'])
end
eval(['nr_multcompare_ind_tdcs_plot(stats_mean_mean_sum_',freq_band,'_p1,min_ylim)'])

subplot(10,5,15); hold on
eval(['bar([mean_mean_mean_sum_',freq_band,'_t1_p2_non_ipsi mean_mean_mean_sum_',freq_band,'_t2_p2_non_ipsi mean_mean_mean_sum_',freq_band,'_t3_p2_non_ipsi mean_mean_mean_sum_',freq_band,'_t4_p2_non_ipsi])'])
eval(['errorbar([mean_mean_mean_sum_',freq_band,'_t1_p2_non_ipsi mean_mean_mean_sum_',freq_band,'_t2_p2_non_ipsi mean_mean_mean_sum_',freq_band,'_t3_p2_non_ipsi mean_mean_mean_sum_',freq_band,'_t4_p2_non_ipsi],'...
    '[se_mean_mean_sum_',freq_band,'_t1_p2_non_ipsi se_mean_mean_sum_',freq_band,'_t2_p2_non_ipsi se_mean_mean_sum_',freq_band,'_t3_p2_non_ipsi se_mean_mean_sum_',freq_band,'_t4_p2_non_ipsi],''.k'')'])
set(gca,'XTick',[1:4],'XTickLabel',['t1';'t2';'t3';'t4'])
eval(['[p_mean_mean_sum_',freq_band,'_p2,anovatab_mean_mean_sum_',freq_band,'_p2,stats_mean_mean_sum_',freq_band,'_p2]='...
    'friedman([mean_mean_sum_',freq_band,'_t1_p2_non_ipsi'',mean_mean_sum_',freq_band,'_t2_p2_non_ipsi'',mean_mean_sum_',freq_band,'_t3_p2_non_ipsi'',mean_mean_sum_',freq_band,'_t4_p2_non_ipsi''],[1],''off'')'])
if eval(['p_mean_mean_sum_',freq_band,'_p2<=0.05'])
    eval(['title(num2str(p_mean_mean_sum_',freq_band,'_p2),''Color'',[1 0 0])'])
else
    eval(['title(num2str(p_mean_mean_sum_',freq_band,'_p2))'])
end
eval(['nr_multcompare_ind_tdcs_plot(stats_mean_mean_sum_',freq_band,'_p2,min_ylim)'])

subplot(10,5,20); hold on
eval(['bar([mean_mean_mean_sum_',freq_band,'_t1_p3_non_ipsi mean_mean_mean_sum_',freq_band,'_t2_p3_non_ipsi mean_mean_mean_sum_',freq_band,'_t3_p3_non_ipsi mean_mean_mean_sum_',freq_band,'_t4_p3_non_ipsi])'])
eval(['errorbar([mean_mean_mean_sum_',freq_band,'_t1_p3_non_ipsi mean_mean_mean_sum_',freq_band,'_t2_p3_non_ipsi mean_mean_mean_sum_',freq_band,'_t3_p3_non_ipsi mean_mean_mean_sum_',freq_band,'_t4_p3_non_ipsi],'...
    '[se_mean_mean_sum_',freq_band,'_t1_p3_non_ipsi se_mean_mean_sum_',freq_band,'_t2_p3_non_ipsi se_mean_mean_sum_',freq_band,'_t3_p3_non_ipsi se_mean_mean_sum_',freq_band,'_t4_p3_non_ipsi],''.k'')'])
set(gca,'XTick',[1:4],'XTickLabel',['t1';'t2';'t3';'t4'])
eval(['[p_mean_mean_sum_',freq_band,'_p3,anovatab_mean_mean_sum_',freq_band,'_p3,stats_mean_mean_sum_',freq_band,'_p3]='...
    'friedman([mean_mean_sum_',freq_band,'_t1_p3_non_ipsi'',mean_mean_sum_',freq_band,'_t2_p3_non_ipsi'',mean_mean_sum_',freq_band,'_t3_p3_non_ipsi'',mean_mean_sum_',freq_band,'_t4_p3_non_ipsi''],[1],''off'')'])
if eval(['p_mean_mean_sum_',freq_band,'_p3<=0.05'])
    eval(['title(num2str(p_mean_mean_sum_',freq_band,'_p3),''Color'',[1 0 0])'])
else
    eval(['title(num2str(p_mean_mean_sum_',freq_band,'_p3))'])
end
eval(['nr_multcompare_ind_tdcs_plot(stats_mean_mean_sum_',freq_band,'_p3,min_ylim)'])

subplot(10,5,21); hold on
eval(['bar([mean_mean_mean_sum_',freq_band,'_t1_p0_non_ipsi mean_mean_mean_sum_',freq_band,'_t1_p1_non_ipsi mean_mean_mean_sum_',freq_band,'_t1_p2_non_ipsi mean_mean_mean_sum_',freq_band,'_t1_p3_non_ipsi])'])
eval(['errorbar([mean_mean_mean_sum_',freq_band,'_t1_p0_non_ipsi mean_mean_mean_sum_',freq_band,'_t1_p1_non_ipsi mean_mean_mean_sum_',freq_band,'_t1_p2_non_ipsi mean_mean_mean_sum_',freq_band,'_t1_p3_non_ipsi],'...
    '[se_mean_mean_sum_',freq_band,'_t1_p0_non_ipsi se_mean_mean_sum_',freq_band,'_t1_p1_non_ipsi se_mean_mean_sum_',freq_band,'_t1_p2_non_ipsi se_mean_mean_sum_',freq_band,'_t1_p3_non_ipsi],''.k'')'])
set(gca,'XTick',[1:4],'XTickLabel',['r';'h';'p';'m'])
eval(['[p_mean_mean_sum_',freq_band,'_t1,anovatab_mean_mean_sum_',freq_band,'_t1,stats_mean_mean_sum_',freq_band,'_t1]='...
    'friedman([mean_mean_sum_',freq_band,'_t1_p0_non_ipsi'',mean_mean_sum_',freq_band,'_t1_p1_non_ipsi'',mean_mean_sum_',freq_band,'_t1_p2_non_ipsi'',mean_mean_sum_',freq_band,'_t1_p3_non_ipsi''],[1],''off'')'])
if eval(['p_mean_mean_sum_',freq_band,'_t1<=0.05'])
    eval(['title(num2str(p_mean_mean_sum_',freq_band,'_t1),''Color'',[1 0 0])'])
else
    eval(['title(num2str(p_mean_mean_sum_',freq_band,'_t1))'])
end
eval(['nr_multcompare_ind_tdcs_plot(stats_mean_mean_sum_',freq_band,'_t1,0)'])

subplot(10,5,22); hold on
eval(['bar([mean_mean_mean_sum_',freq_band,'_t2_p0_non_ipsi mean_mean_mean_sum_',freq_band,'_t2_p1_non_ipsi mean_mean_mean_sum_',freq_band,'_t2_p2_non_ipsi mean_mean_mean_sum_',freq_band,'_t2_p3_non_ipsi])'])
eval(['errorbar([mean_mean_mean_sum_',freq_band,'_t2_p0_non_ipsi mean_mean_mean_sum_',freq_band,'_t2_p1_non_ipsi mean_mean_mean_sum_',freq_band,'_t2_p2_non_ipsi mean_mean_mean_sum_',freq_band,'_t2_p3_non_ipsi],'...
    '[se_mean_mean_sum_',freq_band,'_t2_p0_non_ipsi se_mean_mean_sum_',freq_band,'_t2_p1_non_ipsi se_mean_mean_sum_',freq_band,'_t2_p2_non_ipsi se_mean_mean_sum_',freq_band,'_t2_p3_non_ipsi],''.k'')'])
set(gca,'XTick',[1:4],'XTickLabel',['r';'h';'p';'m'])
eval(['[p_mean_mean_sum_',freq_band,'_t2,anovatab_mean_mean_sum_',freq_band,'_t2,stats_mean_mean_sum_',freq_band,'_t2]='...
    'friedman([mean_mean_sum_',freq_band,'_t2_p0_non_ipsi'',mean_mean_sum_',freq_band,'_t2_p1_non_ipsi'',mean_mean_sum_',freq_band,'_t2_p2_non_ipsi'',mean_mean_sum_',freq_band,'_t2_p3_non_ipsi''],[1],''off'')'])
if eval(['p_mean_mean_sum_',freq_band,'_t2<=0.05'])
    eval(['title(num2str(p_mean_mean_sum_',freq_band,'_t2),''Color'',[1 0 0])'])
else
    eval(['title(num2str(p_mean_mean_sum_',freq_band,'_t2))'])
end
eval(['nr_multcompare_ind_tdcs_plot(stats_mean_mean_sum_',freq_band,'_t2,0)'])

subplot(10,5,23); hold on
eval(['bar([mean_mean_mean_sum_',freq_band,'_t3_p0_non_ipsi mean_mean_mean_sum_',freq_band,'_t3_p1_non_ipsi mean_mean_mean_sum_',freq_band,'_t3_p2_non_ipsi mean_mean_mean_sum_',freq_band,'_t3_p3_non_ipsi])'])
eval(['errorbar([mean_mean_mean_sum_',freq_band,'_t3_p0_non_ipsi mean_mean_mean_sum_',freq_band,'_t3_p1_non_ipsi mean_mean_mean_sum_',freq_band,'_t3_p2_non_ipsi mean_mean_mean_sum_',freq_band,'_t3_p3_non_ipsi],'...
    '[se_mean_mean_sum_',freq_band,'_t3_p0_non_ipsi se_mean_mean_sum_',freq_band,'_t3_p1_non_ipsi se_mean_mean_sum_',freq_band,'_t3_p2_non_ipsi se_mean_mean_sum_',freq_band,'_t3_p3_non_ipsi],''.k'')'])
set(gca,'XTick',[1:4],'XTickLabel',['r';'h';'p';'m'])
eval(['[p_mean_mean_sum_',freq_band,'_t3,anovatab_mean_mean_sum_',freq_band,'_t3,stats_mean_mean_sum_',freq_band,'_t3]='...
    'friedman([mean_mean_sum_',freq_band,'_t3_p0_non_ipsi'',mean_mean_sum_',freq_band,'_t3_p1_non_ipsi'',mean_mean_sum_',freq_band,'_t3_p2_non_ipsi'',mean_mean_sum_',freq_band,'_t3_p3_non_ipsi''],[1],''off'')'])
if eval(['p_mean_mean_sum_',freq_band,'_t3<=0.05'])
    eval(['title(num2str(p_mean_mean_sum_',freq_band,'_t3),''Color'',[1 0 0])'])
else
    eval(['title(num2str(p_mean_mean_sum_',freq_band,'_t3))'])
end
eval(['nr_multcompare_ind_tdcs_plot(stats_mean_mean_sum_',freq_band,'_t3,0)'])

subplot(10,5,24); hold on
eval(['bar([mean_mean_mean_sum_',freq_band,'_t4_p0_non_ipsi mean_mean_mean_sum_',freq_band,'_t4_p1_non_ipsi mean_mean_mean_sum_',freq_band,'_t4_p2_non_ipsi mean_mean_mean_sum_',freq_band,'_t4_p3_non_ipsi])'])
eval(['errorbar([mean_mean_mean_sum_',freq_band,'_t4_p0_non_ipsi mean_mean_mean_sum_',freq_band,'_t4_p1_non_ipsi mean_mean_mean_sum_',freq_band,'_t4_p2_non_ipsi mean_mean_mean_sum_',freq_band,'_t4_p3_non_ipsi],'...
    '[se_mean_mean_sum_',freq_band,'_t4_p0_non_ipsi se_mean_mean_sum_',freq_band,'_t4_p1_non_ipsi se_mean_mean_sum_',freq_band,'_t4_p2_non_ipsi se_mean_mean_sum_',freq_band,'_t4_p3_non_ipsi],''.k'')'])
set(gca,'XTick',[1:4],'XTickLabel',['r';'h';'p';'m'])
eval(['[p_mean_mean_sum_',freq_band,'_t4,anovatab_mean_mean_sum_',freq_band,'_t4,stats_mean_mean_sum_',freq_band,'_t4]='...
    'friedman([mean_mean_sum_',freq_band,'_t4_p0_non_ipsi'',mean_mean_sum_',freq_band,'_t4_p1_non_ipsi'',mean_mean_sum_',freq_band,'_t4_p2_non_ipsi'',mean_mean_sum_',freq_band,'_t4_p3_non_ipsi''],[1],''off'')'])
if eval(['p_mean_mean_sum_',freq_band,'_t4<=0.05'])
    eval(['title(num2str(p_mean_mean_sum_',freq_band,'_t4),''Color'',[1 0 0])'])
else
    eval(['title(num2str(p_mean_mean_sum_',freq_band,'_t4))'])
end
eval(['nr_multcompare_ind_tdcs_plot(stats_mean_mean_sum_',freq_band,'_t4,0)'])

clear anovatab* p_mean* stats* 
%clear *ipsi

%non cont
for i=1:4
    for k=1:size(sbjs_non,1)
            load(['/home/rowlandn/nr_data_analysis/data_analyzed/eeg/gen_03/data/pro00087153_00',sbjs_non(k,:),'/analysis/S3-EEGanalysis/s3_dat_rest.mat'])
            eval(['find_freq_plot_sbj',num2str(sbjs_non(k,:)),'_ch',num2str(elec_non_cont(k)),'_t',num2str(i),'_p0',...
                '=find(epochs_rest.rest2.t',num2str(i),'.psd.freq<=50);'])
            eval(['psd_sbj',num2str(sbjs_non(k,:)),'_ch',num2str(elec_non_cont(k)),'_t',num2str(i),'_p0_saw',...
                '=epochs_rest.rest2.t',num2str(i),'.psd.saw(find_freq_plot_sbj',num2str(sbjs_non(k,:)),...
                '_ch',num2str(elec_non_cont(k)),'_t',num2str(i),'_p0,',num2str(elec_non_cont(k)),',:);'])
            eval(['psd_sbj',num2str(sbjs_non(k,:)),'_ch',num2str(elec_non_cont(k)),'_t',num2str(i),'_p0_frq',...
                '=epochs_rest.rest2.t',num2str(i),'.psd.freq(find_freq_plot_sbj',num2str(sbjs_non(k,:)),...
                '_ch',num2str(elec_non_cont(k)),'_t',num2str(i),'_p0);'])
            eval(['psd_mean_sbj',num2str(sbjs_non(k,:)),'_ch',num2str(elec_non_cont(k)),'_t',num2str(i),'_p0_saw',...
                '=mean(log10(psd_sbj',num2str(sbjs_non(k,:)),'_ch',num2str(elec_non_cont(k)),'_t',num2str(i),'_p0_saw),3);'])
        clear epochs_rest
    end
    
    for j=1:3
        for k=1:size(sbjs_non,1)
            load(['/home/rowlandn/nr_data_analysis/data_analyzed/eeg/gen_03/data/pro00087153_00',sbjs_non(k,:),'/analysis/S3-EEGanalysis/s3_dat.mat'])
            eval(['find_freq_plot_sbj',num2str(sbjs_non(k,:)),'_ch',num2str(elec_non_cont(k)),'_t',num2str(i),'_p',num2str(j),...
                '=find(epochs.',epoch_type,'.t',num2str(i),'.',phase{j},'.psd.freq<=50);'])
            eval(['psd_sbj',num2str(sbjs_non(k,:)),'_ch',num2str(elec_non_cont(k)),'_t',num2str(i),'_p',num2str(j),'_saw',...
                '=epochs.',epoch_type,'.t',num2str(i),'.',phase{j},'.psd.saw(find_freq_plot_sbj',num2str(sbjs_non(k,:)),...
                '_ch',num2str(elec_non_cont(k)),'_t',num2str(i),'_p',num2str(j),',',num2str(elec_non_cont(k)),',:);'])
            eval(['psd_sbj',num2str(sbjs_non(k,:)),'_ch',num2str(elec_non_cont(k)),'_t',num2str(i),'_p',num2str(j),'_frq',...
                '=epochs.',epoch_type,'.t',num2str(i),'.',phase{j},'.psd.freq(find_freq_plot_sbj',num2str(sbjs_non(k,:)),...
                '_ch',num2str(elec_non_cont(k)),'_t',num2str(i),'_p',num2str(j),');'])
            eval(['psd_mean_sbj',num2str(sbjs_non(k,:)),'_ch',num2str(elec_non_cont(k)),'_t',num2str(i),'_p',num2str(j),'_saw',...
                '=mean(log10(psd_sbj',num2str(sbjs_non(k,:)),'_ch',num2str(elec_non_cont(k)),'_t',num2str(i),'_p',num2str(j),'_saw),3);'])
        clear Epochcompare epochs
        end
    end
end

for i=1:4
    for k=1:size(sbjs_non,1)
        eval(['mean_mean_sum_',freq_band,'_t',num2str(i),'_p0_non_cont(',num2str(k),')=mean_mean_',freq_band,'_sbj',num2str(sbjs_non(k,:)),...
            '_ch',num2str(elec_non_cont(k)),'_t',num2str(i),'_p0'])
    end
    
    for j=1:3
        for k=1:size(sbjs_non,1)
            eval(['mean_mean_sum_',freq_band,'_t',num2str(i),'_p',num2str(j),'_non_cont(',num2str(k),')=mean_mean_',freq_band,'_sbj',num2str(sbjs_non(k,:)),...
                '_ch',num2str(elec_non_cont(k)),'_t',num2str(i),'_p',num2str(j)])
        end
    end
end

for i=1:4
    eval(['mean_mean_mean_sum_',freq_band,'_t',num2str(i),'_p0_non_cont=mean(mean_mean_sum_',freq_band,'_t',num2str(i),'_p0_non_cont);'])
    eval(['se_mean_mean_sum_',freq_band,'_t',num2str(i),'_p0_non_cont=std(mean_mean_sum_',freq_band,'_t',num2str(i),'_p0',...
            '_non_cont)/sqrt(size(mean_mean_sum_',freq_band,'_t',num2str(i),'_p0_non_cont,2))'])
        
    for j=1:3
        eval(['mean_mean_mean_sum_',freq_band,'_t',num2str(i),'_p',num2str(j),'_non_cont=mean(mean_mean_sum_',freq_band,'_t',num2str(i),'_p',num2str(j),'_non_cont)'])
        eval(['se_mean_mean_sum_',freq_band,'_t',num2str(i),'_p',num2str(j),'_non_cont=std(mean_mean_sum_',freq_band,'_t',num2str(i),'_p',num2str(j),...
            '_non_cont)/sqrt(size(mean_mean_sum_',freq_band,'_t',num2str(i),'_p',num2str(j),'_non_cont,2))'])
    end
end

for i=1:4
    subplot(10,5,i+25)
    hold on
    for k=1:size(sbjs_non,1)
            eval(['plot(psd_sbj',num2str(sbjs_non(k,:)),'_ch',num2str(elec_non_cont(k)),'_t',num2str(i),'_p0_frq,',...
                'psd_mean_sbj',num2str(sbjs_non(k,:)),'_ch',num2str(elec_non_cont(k)),'_t',num2str(i),'_p0_saw,''LineWidth'',2)'])
            if i==1
                title(['cont non:t',num2str(i)])
            else
                title(['t',num2str(i)])
            end
            eval(['ylim_',num2str(i+25),'=get(gca,''ylim'');'])
    end
        
    if i==1
        ylabel('Rest')
    end
end

count=29;
for j=1:3
    for i=1:4
        count=count+1;
        if j==1
            subplot(10,5,i+30); hold on
            %sp=i+20;
        elseif j==2
            subplot(10,5,i+35); hold on
            %sp=i+25;
        elseif j==3
            subplot(10,5,i+40); hold on
            %sp=i+30;
        end
         
        for k=1:size(sbjs_non,1)
            eval(['plot(psd_sbj',num2str(sbjs_non(k,:)),'_ch',num2str(elec_non_cont(k)),'_t',num2str(i),'_p',num2str(j),'_frq,',...
                'psd_mean_sbj',num2str(sbjs_non(k,:)),'_ch',num2str(elec_non_cont(k)),'_t',num2str(i),'_p',num2str(j),'_saw,''LineWidth'',2)'])
        end
        
        eval(['ylim_',num2str(count),'=get(gca,''ylim'');'])
           
        if count==30
            ylabel('atStartPosition')
            %title('cont non:t1')
%         elseif count==22
%             title('t2')
%         elseif count==23
%             title('t3')
%         elseif count==24
%             title('t4')
        elseif count==34
            ylabel('cueEvent')
        elseif count==38
            ylabel('targetUp')
        elseif count==41
            l1_non_cont=legend
        end
    end
end
min_ylim=min([ylim_26(1) ylim_27(1) ylim_28(1) ylim_29(1) ylim_30(1) ylim_31(1) ylim_32(1) ylim_33(1) ylim_34(1) ylim_35(1) ylim_36(1) ylim_37(1) ylim_38(1) ylim_39(1) ylim_40(1) ylim_41(1)]);
max_ylim=max([ylim_26(2) ylim_27(2) ylim_28(2) ylim_29(2) ylim_30(2) ylim_31(2) ylim_32(2) ylim_33(2) ylim_34(2) ylim_35(2) ylim_36(2) ylim_37(2) ylim_38(2) ylim_39(2) ylim_40(2) ylim_41(2)]);
for i=[26 27 28 29 31 32 33 34 36 37 38 39 41 42 43 44]
    subplot(10,5,i)
    set(gca,'ylim',[min_ylim max_ylim])
    plot([frq_rng_st frq_rng_st],[min_ylim max_ylim],'r')
    plot([frq_rng_ed frq_rng_ed],[min_ylim max_ylim],'r')
end
set(l1_non_cont,'String',l1_non_str,'Position',[0.7884 0.0951 0.1037 0.0809])

subplot(10,5,30); hold on
eval(['bar([mean_mean_mean_sum_',freq_band,'_t1_p0_non_cont mean_mean_mean_sum_',freq_band,'_t2_p0_non_cont mean_mean_mean_sum_',freq_band,'_t3_p0_non_cont mean_mean_mean_sum_',freq_band,'_t4_p0_non_cont])'])
eval(['errorbar([mean_mean_mean_sum_',freq_band,'_t1_p0_non_cont mean_mean_mean_sum_',freq_band,'_t2_p0_non_cont mean_mean_mean_sum_',freq_band,'_t3_p0_non_cont mean_mean_mean_sum_',freq_band,'_t4_p0_non_cont],'...
    '[se_mean_mean_sum_',freq_band,'_t1_p0_non_cont se_mean_mean_sum_',freq_band,'_t2_p0_non_cont se_mean_mean_sum_',freq_band,'_t3_p0_non_cont se_mean_mean_sum_',freq_band,'_t4_p0_non_cont],''.k'')'])
set(gca,'XTick',[1:4],'XTickLabel',['t1';'t2';'t3';'t4'])
eval(['[p_mean_mean_sum_',freq_band,'_p0,anovatab_mean_mean_sum_',freq_band,'_p0,stats_mean_mean_sum_',freq_band,'_p0]='...
    'friedman([mean_mean_sum_',freq_band,'_t1_p0_non_cont'',mean_mean_sum_',freq_band,'_t2_p0_non_cont'',mean_mean_sum_',freq_band,'_t3_p0_non_cont'',mean_mean_sum_',freq_band,'_t4_p0_non_cont''],[1],''off'')'])
if eval(['p_mean_mean_sum_',freq_band,'_p0<=0.05'])
    eval(['title(num2str(p_mean_mean_sum_',freq_band,'_p0),''Color'',[1 0 0])'])
else
    eval(['title(num2str(p_mean_mean_sum_',freq_band,'_p0))'])
end
eval(['nr_multcompare_ind_tdcs_plot(stats_mean_mean_sum_',freq_band,'_p0,min_ylim)'])

subplot(10,5,35); hold on
eval(['bar([mean_mean_mean_sum_',freq_band,'_t1_p1_non_cont mean_mean_mean_sum_',freq_band,'_t2_p1_non_cont mean_mean_mean_sum_',freq_band,'_t3_p1_non_cont mean_mean_mean_sum_',freq_band,'_t4_p1_non_cont])'])
eval(['errorbar([mean_mean_mean_sum_',freq_band,'_t1_p1_non_cont mean_mean_mean_sum_',freq_band,'_t2_p1_non_cont mean_mean_mean_sum_',freq_band,'_t3_p1_non_cont mean_mean_mean_sum_',freq_band,'_t4_p1_non_cont],'...
    '[se_mean_mean_sum_',freq_band,'_t1_p1_non_cont se_mean_mean_sum_',freq_band,'_t2_p1_non_cont se_mean_mean_sum_',freq_band,'_t3_p1_non_cont se_mean_mean_sum_',freq_band,'_t4_p1_non_cont],''.k'')'])
set(gca,'XTick',[1:4],'XTickLabel',['t1';'t2';'t3';'t4'])
eval(['[p_mean_mean_sum_',freq_band,'_p1,anovatab_mean_mean_sum_',freq_band,'_p1,stats_mean_mean_sum_',freq_band,'_p1]='...
    'friedman([mean_mean_sum_',freq_band,'_t1_p1_non_cont'',mean_mean_sum_',freq_band,'_t2_p1_non_cont'',mean_mean_sum_',freq_band,'_t3_p1_non_cont'',mean_mean_sum_',freq_band,'_t4_p1_non_cont''],[1],''off'')'])
if eval(['p_mean_mean_sum_',freq_band,'_p1<=0.05'])
    eval(['title(num2str(p_mean_mean_sum_',freq_band,'_p1),''Color'',[1 0 0])'])
else
    eval(['title(num2str(p_mean_mean_sum_',freq_band,'_p1))'])
end
eval(['nr_multcompare_ind_tdcs_plot(stats_mean_mean_sum_',freq_band,'_p1,min_ylim)'])

subplot(10,5,40); hold on
eval(['bar([mean_mean_mean_sum_',freq_band,'_t1_p2_non_cont mean_mean_mean_sum_',freq_band,'_t2_p2_non_cont mean_mean_mean_sum_',freq_band,'_t3_p2_non_cont mean_mean_mean_sum_',freq_band,'_t4_p2_non_cont])'])
eval(['errorbar([mean_mean_mean_sum_',freq_band,'_t1_p2_non_cont mean_mean_mean_sum_',freq_band,'_t2_p2_non_cont mean_mean_mean_sum_',freq_band,'_t3_p2_non_cont mean_mean_mean_sum_',freq_band,'_t4_p2_non_cont],'...
    '[se_mean_mean_sum_',freq_band,'_t1_p2_non_cont se_mean_mean_sum_',freq_band,'_t2_p2_non_cont se_mean_mean_sum_',freq_band,'_t3_p2_non_cont se_mean_mean_sum_',freq_band,'_t4_p2_non_cont],''.k'')'])
set(gca,'XTick',[1:4],'XTickLabel',['t1';'t2';'t3';'t4'])
eval(['[p_mean_mean_sum_',freq_band,'_p2,anovatab_mean_mean_sum_',freq_band,'_p2,stats_mean_mean_sum_',freq_band,'_p2]='...
    'friedman([mean_mean_sum_',freq_band,'_t1_p2_non_cont'',mean_mean_sum_',freq_band,'_t2_p2_non_cont'',mean_mean_sum_',freq_band,'_t3_p2_non_cont'',mean_mean_sum_',freq_band,'_t4_p2_non_cont''],[1],''off'')'])
if eval(['p_mean_mean_sum_',freq_band,'_p2<=0.05'])
    eval(['title(num2str(p_mean_mean_sum_',freq_band,'_p2),''Color'',[1 0 0])'])
else
    eval(['title(num2str(p_mean_mean_sum_',freq_band,'_p2))'])
end
eval(['nr_multcompare_ind_tdcs_plot(stats_mean_mean_sum_',freq_band,'_p2,min_ylim)'])

subplot(10,5,45); hold on
eval(['bar([mean_mean_mean_sum_',freq_band,'_t1_p3_non_cont mean_mean_mean_sum_',freq_band,'_t2_p3_non_cont mean_mean_mean_sum_',freq_band,'_t3_p3_non_cont mean_mean_mean_sum_',freq_band,'_t4_p3_non_cont])'])
eval(['errorbar([mean_mean_mean_sum_',freq_band,'_t1_p3_non_cont mean_mean_mean_sum_',freq_band,'_t2_p3_non_cont mean_mean_mean_sum_',freq_band,'_t3_p3_non_cont mean_mean_mean_sum_',freq_band,'_t4_p3_non_cont],'...
    '[se_mean_mean_sum_',freq_band,'_t1_p3_non_cont se_mean_mean_sum_',freq_band,'_t2_p3_non_cont se_mean_mean_sum_',freq_band,'_t3_p3_non_cont se_mean_mean_sum_',freq_band,'_t4_p3_non_cont],''.k'')'])
set(gca,'XTick',[1:4],'XTickLabel',['t1';'t2';'t3';'t4'])
eval(['[p_mean_mean_sum_',freq_band,'_p3,anovatab_mean_mean_sum_',freq_band,'_p3,stats_mean_mean_sum_',freq_band,'_p3]='...
    'friedman([mean_mean_sum_',freq_band,'_t1_p3_non_cont'',mean_mean_sum_',freq_band,'_t2_p3_non_cont'',mean_mean_sum_',freq_band,'_t3_p3_non_cont'',mean_mean_sum_',freq_band,'_t4_p3_non_cont''],[1],''off'')'])
if eval(['p_mean_mean_sum_',freq_band,'_p3<=0.05'])
    eval(['title(num2str(p_mean_mean_sum_',freq_band,'_p3),''Color'',[1 0 0])'])
else
    eval(['title(num2str(p_mean_mean_sum_',freq_band,'_p3))'])
end
eval(['nr_multcompare_ind_tdcs_plot(stats_mean_mean_sum_',freq_band,'_p3,min_ylim)'])

subplot(10,5,46); hold on
eval(['bar([mean_mean_mean_sum_',freq_band,'_t1_p0_non_cont mean_mean_mean_sum_',freq_band,'_t1_p1_non_cont mean_mean_mean_sum_',freq_band,'_t1_p2_non_cont mean_mean_mean_sum_',freq_band,'_t1_p3_non_cont])'])
eval(['errorbar([mean_mean_mean_sum_',freq_band,'_t1_p0_non_cont mean_mean_mean_sum_',freq_band,'_t1_p1_non_cont mean_mean_mean_sum_',freq_band,'_t1_p2_non_cont mean_mean_mean_sum_',freq_band,'_t1_p3_non_cont],'...
    '[se_mean_mean_sum_',freq_band,'_t1_p0_non_cont se_mean_mean_sum_',freq_band,'_t1_p1_non_cont se_mean_mean_sum_',freq_band,'_t1_p2_non_cont se_mean_mean_sum_',freq_band,'_t1_p3_non_cont],''.k'')'])
set(gca,'XTick',[1:4],'XTickLabel',['r';'h';'p';'m'])
eval(['[p_mean_mean_sum_',freq_band,'_t1,anovatab_mean_mean_sum_',freq_band,'_t1,stats_mean_mean_sum_',freq_band,'_t1]='...
    'friedman([mean_mean_sum_',freq_band,'_t1_p0_non_cont'',mean_mean_sum_',freq_band,'_t1_p1_non_cont'',mean_mean_sum_',freq_band,'_t1_p2_non_cont'',mean_mean_sum_',freq_band,'_t1_p3_non_cont''],[1],''off'')'])
if eval(['p_mean_mean_sum_',freq_band,'_t1<=0.05'])
    eval(['title(num2str(p_mean_mean_sum_',freq_band,'_t1),''Color'',[1 0 0])'])
else
    eval(['title(num2str(p_mean_mean_sum_',freq_band,'_t1))'])
end
eval(['nr_multcompare_ind_tdcs_plot(stats_mean_mean_sum_',freq_band,'_t1,0)'])

subplot(10,5,47); hold on
eval(['bar([mean_mean_mean_sum_',freq_band,'_t2_p0_non_cont mean_mean_mean_sum_',freq_band,'_t2_p1_non_cont mean_mean_mean_sum_',freq_band,'_t2_p2_non_cont mean_mean_mean_sum_',freq_band,'_t2_p3_non_cont])'])
eval(['errorbar([mean_mean_mean_sum_',freq_band,'_t2_p0_non_cont mean_mean_mean_sum_',freq_band,'_t2_p1_non_cont mean_mean_mean_sum_',freq_band,'_t2_p2_non_cont mean_mean_mean_sum_',freq_band,'_t2_p3_non_cont],'...
    '[se_mean_mean_sum_',freq_band,'_t2_p0_non_cont se_mean_mean_sum_',freq_band,'_t2_p1_non_cont se_mean_mean_sum_',freq_band,'_t2_p2_non_cont se_mean_mean_sum_',freq_band,'_t2_p3_non_cont],''.k'')'])
set(gca,'XTick',[1:4],'XTickLabel',['r';'h';'p';'m'])
eval(['[p_mean_mean_sum_',freq_band,'_t2,anovatab_mean_mean_sum_',freq_band,'_t2,stats_mean_mean_sum_',freq_band,'_t2]='...
    'friedman([mean_mean_sum_',freq_band,'_t2_p0_non_cont'',mean_mean_sum_',freq_band,'_t2_p1_non_cont'',mean_mean_sum_',freq_band,'_t2_p2_non_cont'',mean_mean_sum_',freq_band,'_t2_p3_non_cont''],[1],''off'')'])
if eval(['p_mean_mean_sum_',freq_band,'_t2<=0.05'])
    eval(['title(num2str(p_mean_mean_sum_',freq_band,'_t2),''Color'',[1 0 0])'])
else
    eval(['title(num2str(p_mean_mean_sum_',freq_band,'_t2))'])
end
eval(['nr_multcompare_ind_tdcs_plot(stats_mean_mean_sum_',freq_band,'_t2,0)'])

subplot(10,5,48); hold on
eval(['bar([mean_mean_mean_sum_',freq_band,'_t3_p0_non_cont mean_mean_mean_sum_',freq_band,'_t3_p1_non_cont mean_mean_mean_sum_',freq_band,'_t3_p2_non_cont mean_mean_mean_sum_',freq_band,'_t3_p3_non_cont])'])
eval(['errorbar([mean_mean_mean_sum_',freq_band,'_t3_p0_non_cont mean_mean_mean_sum_',freq_band,'_t3_p1_non_cont mean_mean_mean_sum_',freq_band,'_t3_p2_non_cont mean_mean_mean_sum_',freq_band,'_t3_p3_non_cont],'...
    '[se_mean_mean_sum_',freq_band,'_t3_p0_non_cont se_mean_mean_sum_',freq_band,'_t3_p1_non_cont se_mean_mean_sum_',freq_band,'_t3_p2_non_cont se_mean_mean_sum_',freq_band,'_t3_p3_non_cont],''.k'')'])
set(gca,'XTick',[1:4],'XTickLabel',['r';'h';'p';'m'])
eval(['[p_mean_mean_sum_',freq_band,'_t3,anovatab_mean_mean_sum_',freq_band,'_t3,stats_mean_mean_sum_',freq_band,'_t3]='...
    'friedman([mean_mean_sum_',freq_band,'_t3_p0_non_cont'',mean_mean_sum_',freq_band,'_t3_p1_non_cont'',mean_mean_sum_',freq_band,'_t3_p2_non_cont'',mean_mean_sum_',freq_band,'_t3_p3_non_cont''],[1],''off'')'])
if eval(['p_mean_mean_sum_',freq_band,'_t3<=0.05'])
    eval(['title(num2str(p_mean_mean_sum_',freq_band,'_t3),''Color'',[1 0 0])'])
else
    eval(['title(num2str(p_mean_mean_sum_',freq_band,'_t3))'])
end
eval(['nr_multcompare_ind_tdcs_plot(stats_mean_mean_sum_',freq_band,'_t3,0)'])

subplot(10,5,49); hold on
eval(['bar([mean_mean_mean_sum_',freq_band,'_t4_p0_non_cont mean_mean_mean_sum_',freq_band,'_t4_p1_non_cont mean_mean_mean_sum_',freq_band,'_t4_p2_non_cont mean_mean_mean_sum_',freq_band,'_t4_p3_non_cont])'])
eval(['errorbar([mean_mean_mean_sum_',freq_band,'_t4_p0_non_cont mean_mean_mean_sum_',freq_band,'_t4_p1_non_cont mean_mean_mean_sum_',freq_band,'_t4_p2_non_cont mean_mean_mean_sum_',freq_band,'_t4_p3_non_cont],'...
    '[se_mean_mean_sum_',freq_band,'_t4_p0_non_cont se_mean_mean_sum_',freq_band,'_t4_p1_non_cont se_mean_mean_sum_',freq_band,'_t4_p2_non_cont se_mean_mean_sum_',freq_band,'_t4_p3_non_cont],''.k'')'])
set(gca,'XTick',[1:4],'XTickLabel',['r';'h';'p';'m'])
eval(['[p_mean_mean_sum_',freq_band,'_t4,anovatab_mean_mean_sum_',freq_band,'_t4,stats_mean_mean_sum_',freq_band,'_t4]='...
    'friedman([mean_mean_sum_',freq_band,'_t4_p0_non_cont'',mean_mean_sum_',freq_band,'_t4_p1_non_cont'',mean_mean_sum_',freq_band,'_t4_p2_non_cont'',mean_mean_sum_',freq_band,'_t4_p3_non_cont''],[1],''off'')'])
if eval(['p_mean_mean_sum_',freq_band,'_t4<=0.05'])
    eval(['title(num2str(p_mean_mean_sum_',freq_band,'_t4),''Color'',[1 0 0])'])
else
    eval(['title(num2str(p_mean_mean_sum_',freq_band,'_t4))'])
end
eval(['nr_multcompare_ind_tdcs_plot(stats_mean_mean_sum_',freq_band,'_t4,0)'])

clear anovatab* p_mean* stats* 
%clear anovatab* find* mean_mean_mean_* mean_mean_beta* p* psd* se* stats* ylim*

if strcmp(save_figs,'yes')
    saveas(gcf,['~/nr_data_analysis/data_analyzed/eeg/gen_03/analysis_pow/',date_str,'/gen_03_ver_',version,'_',labl,'_sum_',freq_band,'_',grp,'_non.fig'],'fig')
end

if strcmp(save_data,'yes')
        save(['~/nr_data_analysis/data_analyzed/eeg/gen_03/analysis_pow/',date_str,'/gen_03_ver_',version,'_',labl,'_mean_mean_',freq_band,'_sum_',grp] ,['mean_mean_sum_',freq_band,'*']) 
end


