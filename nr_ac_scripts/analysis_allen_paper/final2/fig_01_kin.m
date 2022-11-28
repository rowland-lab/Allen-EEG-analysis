% kinematics - this plots position and movement start for each reach
%(warning: not all are correct but gives you good 1st impression)
sbj_num=['03';'04';'05';'42';'43';'13';'15';'17';'18';'21';'22';'24';'25';'26';'29';'30';'20';'23';'27';'28';'36'];

for i=3%1:size(sbj_num,1)
    load(['~/nr_data_analysis/data_analyzed/eeg/gen_03/data/pro00087153_00',sbj_num(i,:),...
        '/analysis/S2-metrics/pro00087153_00',sbj_num(i,:),'_S2-Metrics.mat'])
    if strcmp(trialData.sessioninfo.stimlat,'L')
        hand='right';
    elseif strcmp(trialData.sessioninfo.stimlat,'R')
        hand='left';
    end
    
%     hand=left
%     downsample(trialData.vr(1).tracker.a.',hand,'(770:1500,1))
%     
%     hand
%     figure
    %subplot(2,2,1)
    %hold on
    %subplot(2,2,1)
    %plot(trialData.vr(1).tracker.time,trialData.vr(1).tracker.a.',hand,'(:,1)
    
    %a=trialData.vr(1).tracker.time,trialData.vr(1).tracker.a.right(3814,1);
    
    %eval(['plot(trialData.vr(1).tracker.time,trialData.vr(1).tracker.p.',hand,'(:,1),''LineWidth'',2)'])
    %eval(['plot(trialData.vr(1).tracker.time,trialData.vr(1).tracker.v.',hand,'(:,1),''LineWidth'',2)'])
    hand='left'
    subplot(3,2,1); hold on
    eval(['plot(trialData.vr(1).tracker.time(770:1500),trialData.vr(1).tracker.a.',hand,'(770:1500,1))'])
    title('left')
    subplot(3,2,3); hold on
    eval(['plot(trialData.vr(1).tracker.time(770:1500),trialData.vr(1).tracker.a.',hand,'(770:1500,2))'])
    subplot(3,2,5); hold on
    eval(['plot(trialData.vr(1).tracker.time(770:1500),trialData.vr(1).tracker.a.',hand,'(770:1500,3))'])
    
    hand='right'
    subplot(3,2,2); hold on
    eval(['plot(trialData.vr(1).tracker.time(770:1500),trialData.vr(1).tracker.a.',hand,'(770:1500,1))'])
    title('right')
    subplot(3,2,4); hold on
    eval(['plot(trialData.vr(1).tracker.time(770:1500),trialData.vr(1).tracker.a.',hand,'(770:1500,2))'])
    subplot(3,2,6); hold on
    eval(['plot(trialData.vr(1).tracker.time(770:1500),trialData.vr(1).tracker.a.',hand,'(770:1500,3))'])
    
    hand='left'
    a1=smooth(trialData.vr(1).tracker.a.left(770:1500,1),300);
    figure; plot(a1)
    
    p=polyfit(trialData.vr(1).tracker.time(770:1300),trialData.vr(1).tracker.a.left(770:1300,1),4);
    y1=polyval(p,trialData.vr(1).tracker.time(770:1300));
    figure;plot(trialData.vr(1).tracker.time(770:1300),y1); hold on
    plot(trialData.vr(1).tracker.time(770:1300),trialData.vr(1).tracker.a.left(770:1300,1)/30,'r')
    
    y_lim1=get(gca,'ylim');
    for j=1:size(movementstart.pre{1,1},2)
        plot([movementstart.pre{1,1}(j) movementstart.pre{1,1}(j)],...
        [y_lim1(1) y_lim1(2)],'r')
    end
%     plot(trialData.vr(1).tracker.p.right(:,2))
%     plot(trialData.vr(1).tracker.p.right(:,3))
    %plot(trialData.vr(1).tracker.v.right(1700:2100,1))
    title('prestim')
    legend('position','velocity','acceleration')

    subplot(2,2,2)
    hold on
    eval(['plot(trialData.vr(2).tracker.time,trialData.vr(2).tracker.p.',hand,'(:,1))'])
    y_lim2=get(gca,'ylim');
    for j=1:size(movementstart.stim{1,1},2)
        plot([movementstart.stim{1,1}(j) movementstart.stim{1,1}(j)],...
        [y_lim2(1) y_lim2(2)],'r')
    end
    %plot(trialData.vr(2).tracker.v.right(650:1000,1))
    title('intra5')

    subplot(2,2,3)
    hold on
    eval(['plot(trialData.vr(3).tracker.time,trialData.vr(3).tracker.p.',hand,'(:,1))'])
    y_lim3=get(gca,'ylim');
    for j=1:size(movementstart.stim{1,2},2)
        plot([movementstart.stim{1,2}(j) movementstart.stim{1,2}(j)],...
        [y_lim3(1) y_lim3(2)],'r')
    end
    %plot(trialData.vr(3).tracker.v.right(950:1250,1)*-1)
    title('intra15')

    subplot(2,2,4)
    hold on
    eval(['plot(trialData.vr(4).tracker.time,trialData.vr(4).tracker.p.',hand,'(:,1))'])
    y_lim4=get(gca,'ylim');
    for j=1:size(movementstart.post{1,1},2)
        plot([movementstart.post{1,1}(j) movementstart.post{1,1}(j)],...
        [y_lim4(1) y_lim4(2)],'r')
    end
    %plot(trialData.vr(4).tracker.v.right(1000:1300,1))
    title('post5')
    
    sgtitle(sbj_num(i,:))
end

% now I will work on metrics
%% now that I've tinkered around with fitting a curve for acceleration, let's scale for the whole data set
sbj_num=['03';'04';'05';'42';'43';'13';'15';'17';'18';'21';'22';'24';'25';'26';'29';'30';'20';'23';'27';'28';'36'];
sp1=[1,4,7,10,13,16,19,22,25,28,31,34];
sp2=[2,5,8,11,14,17,20,23,26,29,32,35];
time={'pre{1,1}';'stim{1,1}';'stim{1,2}';'post{1,1}'};

for i=3%1:size(sbj_num,1)
    load(['~/nr_data_analysis/data_analyzed/eeg/gen_03/data/pro00087153_00',sbj_num(i,:),...
        '/analysis/S2-metrics/pro00087153_00',sbj_num(i,:),'_S2-Metrics.mat'])
    if strcmp(trialData.sessioninfo.stimlat,'L')
        hand='right';
    elseif strcmp(trialData.sessioninfo.stimlat,'R')
        hand='left';
    end
    
    for k=1:size(time,1)
        for j=1:eval(['size(movementstart.',time{k},',2)'])
            eval([time{k}(1:end-5),'_starttime',num2str(j),'=find(trialData.vr(',num2str(k),').tracker.time>movementstart.',time{k},'(j));'])
            if j==12
                eval(['accel_orig_line_plot',num2str(j),'(:,1)=trialData.vr(',num2str(k),').tracker.a.',hand,'(',time{k}(1:end-5),'_starttime',num2str(j),'(1)-30:end,1);']) 
                if eval(['trialData.vr(',num2str(k),').events.targetUp.data(',num2str(j),').targetPosition(1)'])<0
                    eval(['accel_pfit',num2str(k),'_line_plot',num2str(j),'_pf=polyfit(trialData.vr(',num2str(k),').tracker.time(',time{k}(1:end-5),'_starttime',num2str(j),'(1)-30:end),trialData.vr(',num2str(k),').tracker.a.',...
                        hand,'(',time{k}(1:end-5),'_starttime',num2str(j),'(1)-30:end,1),7);'])
                else
                    eval(['accel_pfit',num2str(k),'_line_plot',num2str(j),'_pf=polyfit(trialData.vr(',num2str(k),').tracker.time(',time{k}(1:end-5),'_starttime',num2str(j),'(1)-30:end),trialData.vr(',num2str(k),').tracker.a.',...
                        hand,'(',time{k}(1:end-5),'_starttime',num2str(j),'(1)-30:end,1)*-1,7);'])
                end
                eval(['accel_pfit',num2str(k),'_line_plot',num2str(j),'_pv=polyval(accel_pfit',num2str(k),'_line_plot',num2str(j),'_pf,trialData.vr(',num2str(k),').tracker.time(',time{k}(1:end-5),'_starttime',num2str(j),'(1)-30:end));'])
            else
                eval(['accel_orig_line_plot',num2str(j),'(:,1)=trialData.vr(',num2str(k),').tracker.a.',hand,'(',time{k}(1:end-5),'_starttime',num2str(j),'(1)-30:',time{k}(1:end-5),'_starttime',num2str(j),'(1)+200,1);']) 
                if eval(['trialData.vr(',num2str(k),').events.targetUp.data(',num2str(j),').targetPosition(1)'])<0
                    eval(['accel_pfit',num2str(k),'_line_plot',num2str(j),'_pf=polyfit(trialData.vr(',num2str(k),').tracker.time(',time{k}(1:end-5),'_starttime',num2str(j),'(1)-30:',time{k}(1:end-5),'_starttime',num2str(j),'(1)+200),trialData.vr(',num2str(k),').tracker.a.',...
                        hand,'(',time{k}(1:end-5),'_starttime',num2str(j),'(1)-30:',time{k}(1:end-5),'_starttime',num2str(j),'(1)+200,1),7);'])
                else
                    eval(['accel_pfit',num2str(k),'_line_plot',num2str(j),'_pf=polyfit(trialData.vr(',num2str(k),').tracker.time(',time{k}(1:end-5),'_starttime',num2str(j),'(1)-30:',time{k}(1:end-5),'_starttime',num2str(j),'(1)+200),trialData.vr(',num2str(k),').tracker.a.',...
                        hand,'(',time{k}(1:end-5),'_starttime',num2str(j),'(1)-30:',time{k}(1:end-5),'_starttime',num2str(j),'(1)+200,1)*-1,7);'])
                end
                eval(['accel_pfit',num2str(k),'_line_plot',num2str(j),'_pv=polyval(accel_pfit',num2str(k),'_line_plot',num2str(j),'_pf,trialData.vr(',num2str(k),').tracker.time(',time{k}(1:end-5),'_starttime',num2str(j),...
                    '(1)-30:',time{k}(1:end-5),'_starttime',num2str(j),'(1)+200));'])
            end

            if j==1
                figure
                set(gcf,'Position',[2950 171 702 961])
            end
            subplot(12,3,sp1(j))
            eval(['plot(accel_orig_line_plot',num2str(j),')'])

            subplot(12,3,sp2(j))
            if j==12
                eval(['plot(trialData.vr(',num2str(k),').tracker.time(',time{k}(1:end-5),'_starttime',num2str(j),'(1)-30:end),accel_pfit',num2str(k),'_line_plot',num2str(j),'_pv)'])
            else
                eval(['plot(trialData.vr(',num2str(k),').tracker.time(',time{k}(1:end-5),'_starttime',num2str(j),'(1)-30:',time{k}(1:end-5),'_starttime',num2str(j),'(1)+200),accel_pfit',num2str(k),'_line_plot',num2str(j),'_pv)'])
            end
            
        end
        clear *orig* *starttime*
        
        if k==1
            sgtitle(['sbj ',sbj_num(i,:),' pre'])
        elseif k==2
            sgtitle(['sbj ',sbj_num(i,:),' i05'])
        elseif k==3
            sgtitle(['sbj ',sbj_num(i,:),' i15'])
        elseif k==4
            sgtitle(['sbj ',sbj_num(i,:),' pos'])
        end
    end
    all_pv1=[accel_pfit1_line_plot1_pv,accel_pfit1_line_plot2_pv,accel_pfit1_line_plot3_pv,accel_pfit1_line_plot4_pv,accel_pfit1_line_plot5_pv,accel_pfit1_line_plot6_pv,...
    accel_pfit1_line_plot7_pv,accel_pfit1_line_plot8_pv,accel_pfit1_line_plot9_pv,accel_pfit1_line_plot10_pv,accel_pfit1_line_plot11_pv];
all_pv2=[accel_pfit2_line_plot1_pv,accel_pfit2_line_plot2_pv,accel_pfit2_line_plot3_pv,accel_pfit2_line_plot4_pv,accel_pfit2_line_plot5_pv,accel_pfit2_line_plot6_pv,...
    accel_pfit2_line_plot7_pv,accel_pfit2_line_plot8_pv,accel_pfit2_line_plot9_pv,accel_pfit2_line_plot10_pv,accel_pfit2_line_plot11_pv];
all_pv3=[accel_pfit3_line_plot1_pv,accel_pfit3_line_plot2_pv,accel_pfit3_line_plot3_pv,accel_pfit3_line_plot4_pv,accel_pfit3_line_plot5_pv,accel_pfit3_line_plot6_pv,...
    accel_pfit3_line_plot7_pv,accel_pfit3_line_plot8_pv,accel_pfit3_line_plot9_pv,accel_pfit3_line_plot10_pv,accel_pfit3_line_plot11_pv];
all_pv4=[accel_pfit4_line_plot1_pv,accel_pfit4_line_plot2_pv,accel_pfit4_line_plot3_pv,accel_pfit4_line_plot4_pv,accel_pfit4_line_plot5_pv,accel_pfit4_line_plot6_pv,...
    accel_pfit4_line_plot7_pv,accel_pfit4_line_plot8_pv,accel_pfit4_line_plot9_pv,accel_pfit4_line_plot10_pv,accel_pfit4_line_plot11_pv];
mean_pv1=mean(all_pv1,2);
mean_pv2=mean(all_pv2,2);
mean_pv3=mean(all_pv3,2);
mean_pv4=mean(all_pv4,2);
figure; hold on
plot(mean_pv1)
plot(mean_pv2)
plot(mean_pv3)
plot(mean_pv4)
legend('pre','i05','i15','pos')
title(['sbj ',sbj_num(i,:)])
clear accel* all* mean*
end




figure
subplot(2,2,1); hold on
plot(all_pv1)
subplot(2,2,2); hold on
plot(all_pv2)
subplot(2,2,3); hold on
plot(all_pv3)
subplot(2,2,4); hold on
plot(all_pv4)





figure; plot(all_pv)
        

%     figure;plot(trialData.vr(1).tracker.time(770:1300),y1); hold on
%     plot(trialData.vr(1).tracker.time(770:1300),trialData.vr(1).tracker.a.left(770:1300,1)/30,'r')
%     
        
        
        
        
    %end
    
    figure;plot(accel_orig_line_plot)
            
            
            
    eval(['trialData.vr(1).tracker.a.',hand,'(3814:3822,1)'])

    ans1=find(trialData.vr(1).tracker.time>movementstart.pre{1,1}(j))
    trialData.vr(1).tracker.a.left(movementstart.pre{1,1}(j):movementstart.pre{1,1}(j+1),1)
    
    figure; plot(trialData.vr(1).tracker.a.left(ans1(1):ans1(1)+400))
    %end
    endfigure
    %subplot(2,2,1)
    %hold on
    %subplot(2,2,1)
    %plot(trialData.vr(1).tracker.time,trialData.vr(1).tracker.a.',hand,'(:,1)
    
    %a=trialData.vr(1).tracker.time,trialData.vr(1).tracker.a.right(3814,1);
    
    figure; hold on
    eval(['plot(trialData.vr(1).tracker.time,trialData.vr(1).tracker.p.',hand,'(:,1),''LineWidth'',2)'])
    %eval(['plot(trialData.vr(1).tracker.time,trialData.vr(1).tracker.v.',hand,'(:,1),''LineWidth'',2)'])
    
    y_lim1=get(gca,'ylim');
    for j=1:size(movementstart.pre{1,1},2)
        plot([movementstart.pre{1,1}(j) movementstart.pre{1,1}(j)],...
        [y_lim1(1) y_lim1(2)],'r')
    end
    
    a=trialData.vr(1).tracker.p.left(:,1)
    figure; plot(a)
    diffa=diff(a);
    figure; plot(diffa); hold on
    plot(trialData.vr(1).tracker.v.left(:,1),'r')
    diffdiffa=diff(diffa);
    figure; plot(diffdiffa)
    
    
    figure; plot(trialData.vr(4).tracker.p.left(:,1))
    
    

%% individual line plots - all kinematics

sbjs_cs=['03';'04';'05';'42';'43';'13';'15';'17';'18';'21'];
figure
set(gcf,'Position',[35 230 1285 715])
for i=1:10
    eval(['load(''~/nr_data_analysis/data_analyzed/eeg/gen_03/data/pro00087153_00',sbjs_cs(i,:),'/analysis/S2-metrics/pro00087153_00',sbjs_cs(i,:),'_S2-Metrics.mat'')'])
    for j=2:13
        subplot(2,6,j-1); hold on
        plot(metricdat.data{1,j}(1:4),'Marker','o','MarkerSize',10,'LineWidth',2)
        set(gca,'XTick',[1:4],'XTickLabel',['BL';'ES';'LS';'PS'])
        title(metricdat.label{1,j})
    end
    if i==10
        legend('03','04','05','42','43','13','15','17','18','21')
    end
end
sgtitle('chronic stroke')

sbjs_hc=['22';'24';'25';'26';'29';'30';'20';'23';'27';'28';'36'];
figure
set(gcf,'Position',[35 230 1285 715])
for i=1:11
    eval(['load(''~/nr_data_analysis/data_analyzed/eeg/gen_03/data/pro00087153_00',sbjs_hc(i,:),'/analysis/S2-metrics/pro00087153_00',sbjs_hc(i,:),'_S2-Metrics.mat'')'])
    for j=2:13
        subplot(2,6,j-1); hold on
        plot(metricdat.data{1,j}(1:4),'Marker','o','MarkerSize',10,'LineWidth',2)
        set(gca,'XTick',[1:4],'XTickLabel',['BL';'ES';'LS';'PS'])
        title(metricdat.label{1,j})
    end
    if i==11
        legend('22','24','25','26','29','30','20','23','27','28','36')
    end
end
sgtitle('healthy control')

%% group line plots - all kinematics

sbjs_cs_stm=['03';'04';'05';'42';'43'];
for i=1:5
    eval(['load(''~/nr_data_analysis/data_analyzed/eeg/gen_03/data/pro00087153_00',sbjs_cs_stm(i,:),'/analysis/S2-metrics/pro00087153_00',sbjs_cs_stm(i,:),'_S2-Metrics.mat'')'])
    for j=1:13
        for k=1:4
            eval(['cs_stm_kin',num2str(j),'(i,k)=metricdat.data{1,j}(k);'])
        end
    end
    clear t* s2* move* metric*
end

sbjs_cs_non=['13';'15';'17';'18';'21'];
for i=1:5
    eval(['load(''~/nr_data_analysis/data_analyzed/eeg/gen_03/data/pro00087153_00',sbjs_cs_non(i,:),'/analysis/S2-metrics/pro00087153_00',sbjs_cs_non(i,:),'_S2-Metrics.mat'')'])
    for j=1:13
        for k=1:4
            eval(['cs_non_kin',num2str(j),'(i,k)=metricdat.data{1,j}(k);'])
        end
    end
    clear t* s2* move* metric*
end

sbjs_hc_stm=['22';'24';'25';'26';'29';'30'];
for i=1:6
    eval(['load(''~/nr_data_analysis/data_analyzed/eeg/gen_03/data/pro00087153_00',sbjs_hc_stm(i,:),'/analysis/S2-metrics/pro00087153_00',sbjs_hc_stm(i,:),'_S2-Metrics.mat'')'])
    for j=1:13
        for k=1:4
            eval(['hc_stm_kin',num2str(j),'(i,k)=metricdat.data{1,j}(k);'])
        end
    end
    clear t* s2* move* metric*
end

sbjs_hc_non=['20';'23';'27';'28';'36'];
for i=1:5
    eval(['load(''~/nr_data_analysis/data_analyzed/eeg/gen_03/data/pro00087153_00',sbjs_hc_non(i,:),'/analysis/S2-metrics/pro00087153_00',sbjs_hc_non(i,:),'_S2-Metrics.mat'')'])
    for j=1:13
        for k=1:4
            eval(['hc_non_kin',num2str(j),'(i,k)=metricdat.data{1,j}(k);'])
        end
    end
    clear t* s2* move* metric*
end
        
for i=1:13
    eval(['mean_kin',num2str(i),'_cs_stm=mean(cs_stm_kin',num2str(i),');'])
    eval(['se_kin',num2str(i),'_cs_stm=std(cs_stm_kin',num2str(i),')/sqrt(5);'])
    
    eval(['mean_kin',num2str(i),'_cs_non=mean(cs_non_kin',num2str(i),');'])
    eval(['se_kin',num2str(i),'_cs_non=std(cs_non_kin',num2str(i),')/sqrt(5);'])
    
    eval(['mean_kin',num2str(i),'_hc_stm=mean(hc_stm_kin',num2str(i),');'])
    eval(['se_kin',num2str(i),'_hc_stm=std(hc_stm_kin',num2str(i),')/sqrt(6);'])
    
    eval(['mean_kin',num2str(i),'_hc_non=mean(hc_non_kin',num2str(i),');'])
    eval(['se_kin',num2str(i),'_hc_non=std(hc_non_kin',num2str(i),')/sqrt(5);'])
end
    
figure % this is for cs group - looks exact same as allen's
set(gcf,'Position',[35 230 1285 715])
load('~/nr_data_analysis/data_analyzed/eeg/gen_03/data/pro00087153_0003/analysis/S2-metrics/pro00087153_0003_S2-Metrics.mat','metricdat')
for j=2:13
    subplot(2,6,j-1); hold on
    eval(['plot(mean_kin',num2str(j),'_cs_stm,''g'')'])
    eval(['errorbar(mean_kin',num2str(j),'_cs_stm,se_kin',num2str(j),'_cs_stm,''g'')'])
    eval(['plot(mean_kin',num2str(j),'_cs_non,''r'')'])
    eval(['errorbar(mean_kin',num2str(j),'_cs_non,se_kin',num2str(j),'_cs_non,''r'')'])
    %plot(metricdat.data{1,j}(1:4),'Marker','o','MarkerSize',10,'LineWidth',2)
    set(gca,'XTick',[1:4],'XTickLabel',['BL';'ES';'LS';'PS'])
    title(metricdat.label{1,j})
    if j==7
        legend('stim','','sham')
    end
end
sgtitle('chronic stroke')

figure%compared to allen's healthy group and looks exactly same
set(gcf,'Position',[35 230 1285 715])
for j=2:13
    subplot(2,6,j-1); hold on
    eval(['plot(mean_kin',num2str(j),'_hc_stm,''g'')'])
    eval(['errorbar(mean_kin',num2str(j),'_hc_stm,se_kin',num2str(j),'_hc_stm,''g'')'])
    eval(['plot(mean_kin',num2str(j),'_hc_non,''r'')'])
    eval(['errorbar(mean_kin',num2str(j),'_hc_non,se_kin',num2str(j),'_hc_non,''r'')'])
    %plot(metricdat.data{1,j}(1:4),'Marker','o','MarkerSize',10,'LineWidth',2)
    set(gca,'XTick',[1:4],'XTickLabel',['BL';'ES';'LS';'PS'])
    title(metricdat.label{1,j})
    if j==7
        legend('stim','','sham')
    end
end
sgtitle('healthy control')

%% individual bar plots - anova1

grp_var_5x4_01=[linspace(1,1,12)',linspace(2,2,12)',linspace(3,3,12)',linspace(4,4,12)'];
grp_var_5x4_02=[linspace(1,1,5)',linspace(2,2,5)',linspace(3,3,5)',linspace(4,4,5)'];


kin_lbl={'movementDuration';'reactionTime';'handpathlength';'avgVelocity';'maxVelocity';'velocityPeaks';...
    'timetoMaxVelocity';'timetoMaxVelocitynorm';'avgAcceleration';'maxAcceleration';...
    'accuracy';'normalizedjerk';'IOC'};
kin_idx=10;

sbjs_cs_stm=['03';'04';'05';'42';'43'];
for i=1:5
    eval(['load(''~/nr_data_analysis/data_analyzed/eeg/gen_03/data/pro00087153_00',sbjs_cs_stm(i,:),'/analysis/S2-metrics/pro00087153_00',sbjs_cs_stm(i,:),'_S2-Metrics.mat'')'])
    eval(['mean_kin_',sbjs_cs_stm(i,:),'=mean(metricdatraw.data{1,kin_idx}(:,1:4));'])
    eval(['se_kin_',sbjs_cs_stm(i,:),'=std(metricdatraw.data{1,kin_idx}(:,1:4))/sqrt(5);'])
    eval(['[a1_kin_',sbjs_cs_stm(i,:),'_p,a1_kin_',sbjs_cs_stm(i,:),'_anovatab,a1_kin_',sbjs_cs_stm(i,:),'_stats]=',...
        'anova1(metricdatraw.data{1,kin_idx}(:,1:4),[],''off'');'])
    
end
mean_mean_kin_cs_stm=mean([mean_kin_03;mean_kin_04;mean_kin_05;mean_kin_42;mean_kin_43]);
se_mean_kin_cs_stm=std([mean_kin_03;mean_kin_04;mean_kin_05;mean_kin_42;mean_kin_43])/sqrt(5);
[a1_mean_mean_kin_cs_stm_p,a1_mean_mean_kin_cs_stm_anovatab,a1_mean_mean_kin_cs_stm_stats]=...
    anova1([mean_kin_03;mean_kin_04;mean_kin_05;mean_kin_42;mean_kin_43],[],'off');
eval(['gp_anova2_cs_stm_',kin_lbl{kin_idx},'_mat=[mean_kin_03'',mean_kin_04'',mean_kin_05'',mean_kin_42'',mean_kin_43'']']) 
eval(['dlmwrite(''~/Downloads/gp_anova2_cs_stm_',kin_lbl{kin_idx},'.txt'',gp_anova2_cs_stm_',kin_lbl{kin_idx},'_mat)'])


sbjs_cs_non=['13';'15';'17';'18';'21'];
for i=1:5
    eval(['load(''~/nr_data_analysis/data_analyzed/eeg/gen_03/data/pro00087153_00',sbjs_cs_non(i,:),'/analysis/S2-metrics/pro00087153_00',sbjs_cs_non(i,:),'_S2-Metrics.mat'')'])
    eval(['mean_kin_',sbjs_cs_non(i,:),'=nanmean(metricdatraw.data{1,kin_idx}(:,1:4));'])
    eval(['se_kin_',sbjs_cs_non(i,:),'=nanstd(metricdatraw.data{1,kin_idx}(:,1:4))/sqrt(5);'])
    eval(['[a1_kin_',sbjs_cs_non(i,:),'_p,a1_kin_',sbjs_cs_non(i,:),'_anovatab,a1_kin_',sbjs_cs_non(i,:),'_stats]=',...
        'anova1(metricdatraw.data{1,kin_idx}(:,1:4),[],''off'');'])
end
mean_mean_kin_cs_non=mean([mean_kin_13;mean_kin_15;mean_kin_17;mean_kin_18;mean_kin_21]);
se_mean_kin_cs_non=std([mean_kin_13;mean_kin_15;mean_kin_17;mean_kin_18;mean_kin_21])/sqrt(5);
[a1_mean_mean_kin_cs_non_p,a1_mean_mean_kin_cs_non_anovatab,a1_mean_mean_kin_cs_non_stats]=...
    anova1([mean_kin_13;mean_kin_15;mean_kin_17;mean_kin_18;mean_kin_21],[],'off');
eval(['gp_anova2_cs_non_',kin_lbl{kin_idx},'_mat=[mean_kin_13'',mean_kin_15'',mean_kin_17'',mean_kin_18'',mean_kin_21'']'])
eval(['dlmwrite(''~/Downloads/gp_anova2_cs_non_',kin_lbl{kin_idx},'.txt'',gp_anova2_cs_non_',kin_lbl{kin_idx},'_mat)'])

sbjs_hc_stm=['22';'24';'25';'26';'29';'30'];
for i=1:6
    eval(['load(''~/nr_data_analysis/data_analyzed/eeg/gen_03/data/pro00087153_00',sbjs_hc_stm(i,:),'/analysis/S2-metrics/pro00087153_00',sbjs_hc_stm(i,:),'_S2-Metrics.mat'')'])
    eval(['mean_kin_',sbjs_hc_stm(i,:),'=mean(metricdatraw.data{1,kin_idx}(:,1:4));'])
    eval(['se_kin_',sbjs_hc_stm(i,:),'=std(metricdatraw.data{1,kin_idx}(:,1:4))/sqrt(6);'])
    eval(['[a1_kin_',sbjs_hc_stm(i,:),'_p,a1_kin_',sbjs_hc_stm(i,:),'_anovatab,a1_kin_',sbjs_hc_stm(i,:),'_stats]=',...
        'anova1(metricdatraw.data{1,kin_idx}(:,1:4),[],''off'');'])
end
mean_mean_kin_hc_stm=mean([mean_kin_22;mean_kin_24;mean_kin_25;mean_kin_26;mean_kin_29;mean_kin_30]);
se_mean_kin_hc_stm=std([mean_kin_22;mean_kin_24;mean_kin_25;mean_kin_26;mean_kin_29;mean_kin_30])/sqrt(6);
[a1_mean_mean_kin_hc_stm_p,a1_mean_mean_kin_hc_stm_anovatab,a1_mean_mean_kin_hc_stm_stats]=...
    anova1([mean_kin_22;mean_kin_24;mean_kin_25;mean_kin_26;mean_kin_29;mean_kin_30],[],'off');
eval(['gp_anova2_hc_stm_',kin_lbl{kin_idx},'_mat=[mean_kin_22'',mean_kin_24'',mean_kin_25'',mean_kin_26'',mean_kin_29'',mean_kin_30'']'])
eval(['dlmwrite(''~/Downloads/gp_anova2_hc_stm_',kin_lbl{kin_idx},'.txt'',gp_anova2_hc_stm_',kin_lbl{kin_idx},'_mat)'])

sbjs_hc_non=['20';'23';'27';'28';'36'];
for i=1:5
    eval(['load(''~/nr_data_analysis/data_analyzed/eeg/gen_03/data/pro00087153_00',sbjs_hc_non(i,:),'/analysis/S2-metrics/pro00087153_00',sbjs_hc_non(i,:),'_S2-Metrics.mat'')'])
    eval(['mean_kin_',sbjs_hc_non(i,:),'=mean(metricdatraw.data{1,kin_idx}(:,1:4));'])
    eval(['se_kin_',sbjs_hc_non(i,:),'=std(metricdatraw.data{1,kin_idx}(:,1:4))/sqrt(5);'])
    eval(['[a1_kin_',sbjs_hc_non(i,:),'_p,a1_kin_',sbjs_hc_non(i,:),'_anovatab,a1_kin_',sbjs_hc_non(i,:),'_stats]=',...
        'anova1(metricdatraw.data{1,kin_idx}(:,1:4),[],''off'');'])
end
mean_mean_kin_hc_non=mean([mean_kin_20;mean_kin_23;mean_kin_27;mean_kin_28;mean_kin_36]);
se_mean_kin_hc_non=std([mean_kin_20;mean_kin_23;mean_kin_27;mean_kin_28;mean_kin_36])/sqrt(5);
[a1_mean_mean_kin_hc_non_p,a1_mean_mean_kin_hc_non_anovatab,a1_mean_mean_kin_hc_non_stats]=...
    anova1([mean_kin_20;mean_kin_23;mean_kin_27;mean_kin_28;mean_kin_36],[],'off');
eval(['gp_anova2_hc_non_',kin_lbl{kin_idx},'_mat=[mean_kin_20'',mean_kin_23'',mean_kin_27'',mean_kin_28'',mean_kin_36'']'])
eval(['dlmwrite(''~/Downloads/gp_anova2_hc_non_',kin_lbl{kin_idx},'.txt'',gp_anova2_hc_non_',kin_lbl{kin_idx},'_mat)'])

figure
set(gcf,'Position',[128 573 640 786])
for i=1:5
    subplot(3,2,i); hold on
    eval(['bar(mean_kin_',sbjs_cs_stm(i,:),')'])
    eval(['errorbar(mean_kin_',sbjs_cs_stm(i,:),',se_kin_',sbjs_cs_stm(i,:),',''k.'')'])
    set(gca,'XTick',[1:4],'XTickLabel',{'pre';'i05';'i15';'pos'})
    ylabel(kin_lbl{kin_idx})
    title([sbjs_cs_stm(i,:),' (',eval(['num2str(a1_kin_',sbjs_cs_stm(i,:),'_p)']),')'])
end
subplot(3,2,6); hold on
bar(mean_mean_kin_cs_stm)
errorbar(mean_mean_kin_cs_stm,se_mean_kin_cs_stm,'k.')
set(gca,'XTick',[1:4],'XTickLabel',{'pre';'i05';'i15';'pos'})
ylabel(kin_lbl{kin_idx})
title(['All (',num2str(a1_mean_mean_kin_cs_stm_p),')'])
sgtitle(['cs stm ',kin_lbl{kin_idx}])

figure
set(gcf,'Position',[128 573 640 786])
for i=1:5
    subplot(3,2,i); hold on
    eval(['bar(mean_kin_',sbjs_cs_non(i,:),')'])
    eval(['errorbar(mean_kin_',sbjs_cs_non(i,:),',se_kin_',sbjs_cs_non(i,:),',''k.'')'])
    set(gca,'XTick',[1:4],'XTickLabel',{'pre';'i05';'i15';'pos'})
    ylabel(kin_lbl{kin_idx})
    title([sbjs_cs_non(i,:),' (',eval(['num2str(a1_kin_',sbjs_cs_non(i,:),'_p)']),')'])
end
subplot(3,2,6); hold on
bar(mean_mean_kin_cs_non)
errorbar(mean_mean_kin_cs_non,se_mean_kin_cs_non,'k.')
set(gca,'XTick',[1:4],'XTickLabel',{'pre';'i05';'i15';'pos'})
ylabel(kin_lbl{kin_idx})
title(['All (',num2str(a1_mean_mean_kin_cs_non_p),')'])
sgtitle(['cs non ',kin_lbl{kin_idx}])

figure
set(gcf,'Position',[128 573 640 786])
for i=1:5
    subplot(3,2,i); hold on
    eval(['bar(mean_kin_',sbjs_hc_stm(i,:),')'])
    eval(['errorbar(mean_kin_',sbjs_hc_stm(i,:),',se_kin_',sbjs_hc_stm(i,:),',''k.'')'])
    set(gca,'XTick',[1:4],'XTickLabel',{'pre';'i05';'i15';'pos'})
    ylabel(kin_lbl{kin_idx})
    title([sbjs_hc_stm(i,:),' (',eval(['num2str(a1_kin_',sbjs_hc_stm(i,:),'_p)']),')'])
end
subplot(3,2,6); hold on
bar(mean_mean_kin_hc_stm)
errorbar(mean_mean_kin_hc_stm,se_mean_kin_hc_stm,'k.')
set(gca,'XTick',[1:4],'XTickLabel',{'pre';'i05';'i15';'pos'})
ylabel(kin_lbl{kin_idx})
title(['All (',num2str(a1_mean_mean_kin_hc_stm_p),')'])
sgtitle(['hc stm ',kin_lbl{kin_idx}])

figure
set(gcf,'Position',[128 573 640 786])
for i=1:5
    subplot(3,2,i); hold on
    eval(['bar(mean_kin_',sbjs_hc_non(i,:),')'])
    eval(['errorbar(mean_kin_',sbjs_hc_non(i,:),',se_kin_',sbjs_hc_non(i,:),',''k.'')'])
    set(gca,'XTick',[1:4],'XTickLabel',{'pre';'i05';'i15';'pos'})
    ylabel(kin_lbl{kin_idx})
    title([sbjs_hc_non(i,:),' (',eval(['num2str(a1_kin_',sbjs_hc_non(i,:),'_p)']),')'])
end
subplot(3,2,6); hold on
bar(mean_mean_kin_hc_non)
errorbar(mean_mean_kin_hc_non,se_mean_kin_hc_non,'k.')
set(gca,'XTick',[1:4],'XTickLabel',{'pre';'i05';'i15';'pos'})
ylabel(kin_lbl{kin_idx})
title(['All (',num2str(a1_mean_mean_kin_hc_non_p),')'])
sgtitle(['hc non ',kin_lbl{kin_idx}])


%results
%there are isolated sig p-values but none for the 'All' condition
%interestingly for cs stm 4/5 were significant for inc maxacceleration
%not true hc non had sig decreased in reaction time

%% anova2

%difficult to replicate with graphpad bc it runs a repeated measures 2-way
%anova which I'm not sure matlab can do

%while I'm thinkking about it, these are the figures so far:
% fig 1 - methods
% fig 2 - kinematics - a?, b accel curves superimposed, c line plots, d bar
% plots
% fig 3- raw data with epochs
% fig 4 bar plots + linear regressions
% specgtrograms and topoplots

%%%% using graphpad
% accuracy - hc only
% avg velocity - cs + hc
% max accel - cs only
% max velocity - cs only
% reaction time - hc only



   


% dat=[mean_kin_03',mean_kin_04'];mean_kin_05';mean_kin_42';mean_kin_43';mean_kin_13';mean_kin_15';mean_kin_17';mean_kin_18';mean_kin_21']
% sbj=[linspace(1,1,4)';linspace(2,2,4)';linspace(3,3,4)';linspace(4,4,4)';linspace(5,5,4)';linspace(6,6,4)';...
%     linspace(7,7,4)';linspace(8,8,4)';linspace(9,9,4)';linspace(10,10,4)']
% f1_grp=[1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2]
% f2_grp=[1;2;3;4;1;2;3;4;1;2;3;4;1;2;3;4;1;2;3;4;1;2;3;4;1;2;3;4;1;2;3;4;1;2;3;4;1;2;3;4]
% stats=rm_anova2(dat,sbj,f1_grp,f2_grp,{'stim';'phase'})
% 

%% not super thrilled about the acceleration plots, may try velocity later
% for now will try linear regressions with the diff
sbj_num=['03';'04';'05';'42';'43';'13';'15';'17';'18';'21';'22';'24';'25';'26';'29';'30';'20';'23';'27';'28';'36'];

dz={'stroke';'healthy'}
stim_status={'Stim';'Sham'}
kin_lbl={'movementDuration';'reactionTime';'handpathlength';'avgVelocity';'maxVelocity';'velocityPeaks';...
    'timetoMaxVelocity';'timetoMaxVelocitynorm';'avgAcceleration';'maxAcceleration';...
    'accuracy';'normalizedjerk';'IOC'};
cs_stim=[1 2 3 20 21]
cs_sham=[4 5 6 7 9]
hc_stim=[10 12 13 14 17 18]
hc_sham=[8 11 15 16 19]

for k=2%:2
    for l=2%:2
        for kin_idx=6%:13
            %Hold-Prep
            for i=[8 11 15 16 19]
                for j=1:4
                    eval(['gamma_',kin_lbl{kin_idx},'_c3c4_diff_hold_prep_',dz{k},'_',stim_stat{l},'_kin(',num2str(i),',',num2str(j),')=nanmean(subjectData(',num2str(i),').kinematics.data{1,',num2str(kin_idx),'}(:,',num2str(j),'))'])
                end
            end
            eval(['gamma_',kin_lbl{kin_idx},'_c3c4_diff_hold_prep_',dz{k},'_',stim_status{l},'_kin=gamma_',kin_lbl{kin_idx},'_c3c4_diff_hold_prep_',dz{k},'_',stim_status{l},'_kin(~all(gamma_',kin_lbl{kin_idx},'_c3c4_diff_hold_prep_',dz{k},'_',stim_status{l},'_kin==0,2),:)'])

            times_all={'pre';'i05';'i15';'pos'}
            for i=1:4
                eval(['gamma_',kin_lbl{kin_idx},'_c3c4_diff_hold_prep_',dz{k},'_',stim_status{l},'_eeg(:,',num2str(i),')=squeeze(icoh_data_anal_2022_11_09.mat_diff.c3c4.Gamma.',dz{k},'.Hold_Prep.',stim_status{l},'.',times_all{i,:},')'])
            end

            eval(['gamma_',kin_lbl{kin_idx},'_c3c4_diff_hold_prep_',dz{k},'_',stim_status{l},'_pre_pf=polyfit(gamma_',kin_lbl{kin_idx},'_c3c4_diff_hold_prep_',dz{k},'_',stim_status{l},'_eeg(:,1),',...
                'gamma_',kin_lbl{kin_idx},'_c3c4_diff_hold_prep_',dz{k},'_',stim_status{l},'_kin(:,1),1)'])
            eval(['gamma_',kin_lbl{kin_idx},'_c3c4_diff_hold_prep_',dz{k},'_',stim_status{l},'_pre_pv=polyval(gamma_',kin_lbl{kin_idx},'_c3c4_diff_hold_prep_',dz{k},'_',stim_status{l},'_pre_pf,',...
                'gamma_',kin_lbl{kin_idx},'_c3c4_diff_hold_prep_',dz{k},'_',stim_status{l},'_eeg(:,1))'])
            eval(['[gamma_',kin_lbl{kin_idx},'_c3c4_diff_hold_prep_',dz{k},'_',stim_status{l},'_pre_r,gamma_',kin_lbl{kin_idx},'_c3c4_diff_hold_prep_',dz{k},'_',stim_status{l},'_pre_p]=',...
                'corrcoef(gamma_',kin_lbl{kin_idx},'_c3c4_diff_hold_prep_',dz{k},'_',stim_status{l},'_eeg(:,1),gamma_',kin_lbl{kin_idx},'_c3c4_diff_hold_prep_',dz{k},'_',stim_status{l},'_kin(:,1))'])

            eval(['gamma_',kin_lbl{kin_idx},'_c3c4_diff_hold_prep_',dz{k},'_',stim_status{l},'_i05_pf=polyfit(gamma_',kin_lbl{kin_idx},'_c3c4_diff_hold_prep_',dz{k},'_',stim_status{l},'_eeg(:,2),',...
                'gamma_',kin_lbl{kin_idx},'_c3c4_diff_hold_prep_',dz{k},'_',stim_status{l},'_kin(:,2),1)'])
            eval(['gamma_',kin_lbl{kin_idx},'_c3c4_diff_hold_prep_',dz{k},'_',stim_status{l},'_i05_pv=polyval(gamma_',kin_lbl{kin_idx},'_c3c4_diff_hold_prep_',dz{k},'_',stim_status{l},'_i05_pf,',...
                'gamma_',kin_lbl{kin_idx},'_c3c4_diff_hold_prep_',dz{k},'_',stim_status{l},'_eeg(:,2))'])
            eval(['[gamma_',kin_lbl{kin_idx},'_c3c4_diff_hold_prep_',dz{k},'_',stim_status{l},'_i05_r,gamma_',kin_lbl{kin_idx},'_c3c4_diff_hold_prep_',dz{k},'_',stim_status{l},'_i05_p]=',...
                'corrcoef(gamma_',kin_lbl{kin_idx},'_c3c4_diff_hold_prep_',dz{k},'_',stim_status{l},'_eeg(:,2),gamma_',kin_lbl{kin_idx},'_c3c4_diff_hold_prep_',dz{k},'_',stim_status{l},'_kin(:,2))'])

            eval(['gamma_',kin_lbl{kin_idx},'_c3c4_diff_hold_prep_',dz{k},'_',stim_status{l},'_i15_pf=polyfit(gamma_',kin_lbl{kin_idx},'_c3c4_diff_hold_prep_',dz{k},'_',stim_status{l},'_eeg(:,3),',...
                'gamma_',kin_lbl{kin_idx},'_c3c4_diff_hold_prep_',dz{k},'_',stim_status{l},'_kin(:,3),1)'])
            eval(['gamma_',kin_lbl{kin_idx},'_c3c4_diff_hold_prep_',dz{k},'_',stim_status{l},'_i15_pv=polyval(gamma_',kin_lbl{kin_idx},'_c3c4_diff_hold_prep_',dz{k},'_',stim_status{l},'_i15_pf,',...
                'gamma_',kin_lbl{kin_idx},'_c3c4_diff_hold_prep_',dz{k},'_',stim_status{l},'_eeg(:,3))'])
            eval(['[gamma_',kin_lbl{kin_idx},'_c3c4_diff_hold_prep_',dz{k},'_',stim_status{l},'_i15_r,gamma_',kin_lbl{kin_idx},'_c3c4_diff_hold_prep_',dz{k},'_',stim_status{l},'_i15_p]=',...
                'corrcoef(gamma_',kin_lbl{kin_idx},'_c3c4_diff_hold_prep_',dz{k},'_',stim_status{l},'_eeg(:,3),gamma_',kin_lbl{kin_idx},'_c3c4_diff_hold_prep_',dz{k},'_',stim_status{l},'_kin(:,3))'])

            eval(['gamma_',kin_lbl{kin_idx},'_c3c4_diff_hold_prep_',dz{k},'_',stim_status{l},'_pos_pf=polyfit(gamma_',kin_lbl{kin_idx},'_c3c4_diff_hold_prep_',dz{k},'_',stim_status{l},'_eeg(:,4),',...
                'gamma_',kin_lbl{kin_idx},'_c3c4_diff_hold_prep_',dz{k},'_',stim_status{l},'_kin(:,4),1);'])
            eval(['gamma_',kin_lbl{kin_idx},'_c3c4_diff_hold_prep_',dz{k},'_',stim_status{l},'_pos_pv=polyval(gamma_',kin_lbl{kin_idx},'_c3c4_diff_hold_prep_',dz{k},'_',stim_status{l},'_pos_pf,',...
                'gamma_',kin_lbl{kin_idx},'_c3c4_diff_hold_prep_',dz{k},'_',stim_status{l},'_eeg(:,4))'])
            eval(['[gamma_',kin_lbl{kin_idx},'_c3c4_diff_hold_prep_',dz{k},'_',stim_status{l},'_pos_r,gamma_',kin_lbl{kin_idx},'_c3c4_diff_hold_prep_',dz{k},'_',stim_status{l},'_pos_p]=',...
                'corrcoef(gamma_',kin_lbl{kin_idx},'_c3c4_diff_hold_prep_',dz{k},'_',stim_status{l},'_eeg(:,4),gamma_',kin_lbl{kin_idx},'_c3c4_diff_hold_prep_',dz{k},'_',stim_status{l},'_kin(:,4))'])

            figure; set(gcf,'Position',[1411 656 583 437])
            subplot(2,2,1); hold on
            eval(['plot(gamma_',kin_lbl{kin_idx},'_c3c4_diff_hold_prep_',dz{k},'_',stim_status{l},'_eeg(:,1),gamma_',kin_lbl{kin_idx},'_c3c4_diff_hold_prep_',dz{k},'_',stim_status{l},'_kin(:,1),''.'')'])
            eval(['plot(gamma_',kin_lbl{kin_idx},'_c3c4_diff_hold_prep_',dz{k},'_',stim_status{l},'_eeg(:,1),gamma_',kin_lbl{kin_idx},'_c3c4_diff_hold_prep_',dz{k},'_',stim_status{l},'_pre_pv,''r'')'])
            title(['pre ',num2str(eval(['gamma_',kin_lbl{kin_idx},'_c3c4_diff_hold_prep_',dz{k},'_',stim_status{l},'_pre_p(2)']))])

            subplot(2,2,2); hold on
            eval(['plot(gamma_',kin_lbl{kin_idx},'_c3c4_diff_hold_prep_',dz{k},'_',stim_status{l},'_eeg(:,2),gamma_',kin_lbl{kin_idx},'_c3c4_diff_hold_prep_',dz{k},'_',stim_status{l},'_kin(:,2),''.'')'])
            eval(['plot(gamma_',kin_lbl{kin_idx},'_c3c4_diff_hold_prep_',dz{k},'_',stim_status{l},'_eeg(:,2),gamma_',kin_lbl{kin_idx},'_c3c4_diff_hold_prep_',dz{k},'_',stim_status{l},'_i05_pv,''r'')'])
            title(['i05 ',num2str(eval(['gamma_',kin_lbl{kin_idx},'_c3c4_diff_hold_prep_',dz{k},'_',stim_status{l},'_i05_p(2)']))])

            subplot(2,2,3); hold on
            eval(['plot(gamma_',kin_lbl{kin_idx},'_c3c4_diff_hold_prep_',dz{k},'_',stim_status{l},'_eeg(:,3),gamma_',kin_lbl{kin_idx},'_c3c4_diff_hold_prep_',dz{k},'_',stim_status{l},'_kin(:,3),''.'')'])
            eval(['plot(gamma_',kin_lbl{kin_idx},'_c3c4_diff_hold_prep_',dz{k},'_',stim_status{l},'_eeg(:,3),gamma_',kin_lbl{kin_idx},'_c3c4_diff_hold_prep_',dz{k},'_',stim_status{l},'_i15_pv,''r'')'])
            title(['i15 ',num2str(eval(['gamma_',kin_lbl{kin_idx},'_c3c4_diff_hold_prep_',dz{k},'_',stim_status{l},'_i15_p(2)']))])

            subplot(2,2,4); hold on
            eval(['plot(gamma_',kin_lbl{kin_idx},'_c3c4_diff_hold_prep_',dz{k},'_',stim_status{l},'_eeg(:,4),gamma_',kin_lbl{kin_idx},'_c3c4_diff_hold_prep_',dz{k},'_',stim_status{l},'_kin(:,4),''.'')'])
            eval(['plot(gamma_',kin_lbl{kin_idx},'_c3c4_diff_hold_prep_',dz{k},'_',stim_status{l},'_eeg(:,4),gamma_',kin_lbl{kin_idx},'_c3c4_diff_hold_prep_',dz{k},'_',stim_status{l},'_pos_pv,''r'')'])
            title(['pos ',num2str(eval(['gamma_',kin_lbl{kin_idx},'_c3c4_diff_hold_prep_',dz{k},'_',stim_status{l},'_pos_p(2)']))])
            sgtitle(['Hold Prep ',dz{k},' ',stim_status{l},' ',subjectData(1).kinematics.label{kin_idx}])

            %Prep-Reach
            for i=[8 11 15 16 19]
                for j=1:4
                    eval(['gamma_',kin_lbl{kin_idx},'_c3c4_diff_Prep_Reach_',dz{k},'_',stim_status{l},'_kin(',num2str(i),',',num2str(j),')=nanmean(subjectData(',num2str(i),').kinematics.data{1,',num2str(kin_idx),'}(:,',num2str(j),'))'])
                end
            end
            eval(['gamma_',kin_lbl{kin_idx},'_c3c4_diff_Prep_Reach_',dz{k},'_',stim_status{l},'_kin=gamma_',kin_lbl{kin_idx},'_c3c4_diff_Prep_Reach_',dz{k},'_',stim_status{l},'_kin(~all(gamma_',kin_lbl{kin_idx},'_c3c4_diff_Prep_Reach_',dz{k},'_',stim_status{l},'_kin==0,2),:)'])

            times_all={'pre';'i05';'i15';'pos'}
            for i=1:4
                eval(['gamma_',kin_lbl{kin_idx},'_c3c4_diff_Prep_Reach_',dz{k},'_',stim_status{l},'_eeg(:,',num2str(i),')=squeeze(icoh_data_anal_2022_11_09.mat_diff.c3c4.Gamma.',dz{k},'.Prep_Reach.',stim_status{l},'.',times_all{i,:},')'])
            end

            eval(['gamma_',kin_lbl{kin_idx},'_c3c4_diff_Prep_Reach_',dz{k},'_',stim_status{l},'_pre_pf=polyfit(gamma_',kin_lbl{kin_idx},'_c3c4_diff_Prep_Reach_',dz{k},'_',stim_status{l},'_eeg(:,1),',...
                'gamma_',kin_lbl{kin_idx},'_c3c4_diff_Prep_Reach_',dz{k},'_',stim_status{l},'_kin(:,1),1)'])
            eval(['gamma_',kin_lbl{kin_idx},'_c3c4_diff_Prep_Reach_',dz{k},'_',stim_status{l},'_pre_pv=polyval(gamma_',kin_lbl{kin_idx},'_c3c4_diff_Prep_Reach_',dz{k},'_',stim_status{l},'_pre_pf,',...
                'gamma_',kin_lbl{kin_idx},'_c3c4_diff_Prep_Reach_',dz{k},'_',stim_status{l},'_eeg(:,1))'])
            eval(['[gamma_',kin_lbl{kin_idx},'_c3c4_diff_Prep_Reach_',dz{k},'_',stim_status{l},'_pre_r,gamma_',kin_lbl{kin_idx},'_c3c4_diff_Prep_Reach_',dz{k},'_',stim_status{l},'_pre_p]=',...
                'corrcoef(gamma_',kin_lbl{kin_idx},'_c3c4_diff_Prep_Reach_',dz{k},'_',stim_status{l},'_eeg(:,1),gamma_',kin_lbl{kin_idx},'_c3c4_diff_Prep_Reach_',dz{k},'_',stim_status{l},'_kin(:,1))'])

            eval(['gamma_',kin_lbl{kin_idx},'_c3c4_diff_Prep_Reach_',dz{k},'_',stim_status{l},'_i05_pf=polyfit(gamma_',kin_lbl{kin_idx},'_c3c4_diff_Prep_Reach_',dz{k},'_',stim_status{l},'_eeg(:,2),',...
                'gamma_',kin_lbl{kin_idx},'_c3c4_diff_Prep_Reach_',dz{k},'_',stim_status{l},'_kin(:,2),1)'])
            eval(['gamma_',kin_lbl{kin_idx},'_c3c4_diff_Prep_Reach_',dz{k},'_',stim_status{l},'_i05_pv=polyval(gamma_',kin_lbl{kin_idx},'_c3c4_diff_Prep_Reach_',dz{k},'_',stim_status{l},'_i05_pf,',...
                'gamma_',kin_lbl{kin_idx},'_c3c4_diff_Prep_Reach_',dz{k},'_',stim_status{l},'_eeg(:,2))'])
            eval(['[gamma_',kin_lbl{kin_idx},'_c3c4_diff_Prep_Reach_',dz{k},'_',stim_status{l},'_i05_r,gamma_',kin_lbl{kin_idx},'_c3c4_diff_Prep_Reach_',dz{k},'_',stim_status{l},'_i05_p]=',...
                'corrcoef(gamma_',kin_lbl{kin_idx},'_c3c4_diff_Prep_Reach_',dz{k},'_',stim_status{l},'_eeg(:,2),gamma_',kin_lbl{kin_idx},'_c3c4_diff_Prep_Reach_',dz{k},'_',stim_status{l},'_kin(:,2))'])

            eval(['gamma_',kin_lbl{kin_idx},'_c3c4_diff_Prep_Reach_',dz{k},'_',stim_status{l},'_i15_pf=polyfit(gamma_',kin_lbl{kin_idx},'_c3c4_diff_Prep_Reach_',dz{k},'_',stim_status{l},'_eeg(:,3),',...
                'gamma_',kin_lbl{kin_idx},'_c3c4_diff_Prep_Reach_',dz{k},'_',stim_status{l},'_kin(:,3),1)'])
            eval(['gamma_',kin_lbl{kin_idx},'_c3c4_diff_Prep_Reach_',dz{k},'_',stim_status{l},'_i15_pv=polyval(gamma_',kin_lbl{kin_idx},'_c3c4_diff_Prep_Reach_',dz{k},'_',stim_status{l},'_i15_pf,',...
                'gamma_',kin_lbl{kin_idx},'_c3c4_diff_Prep_Reach_',dz{k},'_',stim_status{l},'_eeg(:,3))'])
            eval(['[gamma_',kin_lbl{kin_idx},'_c3c4_diff_Prep_Reach_',dz{k},'_',stim_status{l},'_i15_r,gamma_',kin_lbl{kin_idx},'_c3c4_diff_Prep_Reach_',dz{k},'_',stim_status{l},'_i15_p]=',...
                'corrcoef(gamma_',kin_lbl{kin_idx},'_c3c4_diff_Prep_Reach_',dz{k},'_',stim_status{l},'_eeg(:,3),gamma_',kin_lbl{kin_idx},'_c3c4_diff_Prep_Reach_',dz{k},'_',stim_status{l},'_kin(:,3))'])

            eval(['gamma_',kin_lbl{kin_idx},'_c3c4_diff_Prep_Reach_',dz{k},'_',stim_status{l},'_pos_pf=polyfit(gamma_',kin_lbl{kin_idx},'_c3c4_diff_Prep_Reach_',dz{k},'_',stim_status{l},'_eeg(:,4),',...
                'gamma_',kin_lbl{kin_idx},'_c3c4_diff_Prep_Reach_',dz{k},'_',stim_status{l},'_kin(:,4),1)'])
            eval(['gamma_',kin_lbl{kin_idx},'_c3c4_diff_Prep_Reach_',dz{k},'_',stim_status{l},'_pos_pv=polyval(gamma_',kin_lbl{kin_idx},'_c3c4_diff_Prep_Reach_',dz{k},'_',stim_status{l},'_pos_pf,',...
                'gamma_',kin_lbl{kin_idx},'_c3c4_diff_Prep_Reach_',dz{k},'_',stim_status{l},'_eeg(:,4))'])
            eval(['[gamma_',kin_lbl{kin_idx},'_c3c4_diff_Prep_Reach_',dz{k},'_',stim_status{l},'_pos_r,gamma_',kin_lbl{kin_idx},'_c3c4_diff_Prep_Reach_',dz{k},'_',stim_status{l},'_pos_p]=',...
                'corrcoef(gamma_',kin_lbl{kin_idx},'_c3c4_diff_Prep_Reach_',dz{k},'_',stim_status{l},'_eeg(:,4),gamma_',kin_lbl{kin_idx},'_c3c4_diff_Prep_Reach_',dz{k},'_',stim_status{l},'_kin(:,4))'])

            figure; set(gcf,'Position',[2062 660 593 430])
            subplot(2,2,1); hold on
            eval(['plot(gamma_',kin_lbl{kin_idx},'_c3c4_diff_Prep_Reach_',dz{k},'_',stim_status{l},'_eeg(:,1),gamma_',kin_lbl{kin_idx},'_c3c4_diff_Prep_Reach_',dz{k},'_',stim_status{l},'_kin(:,1),''.'')'])
            eval(['plot(gamma_',kin_lbl{kin_idx},'_c3c4_diff_Prep_Reach_',dz{k},'_',stim_status{l},'_eeg(:,1),gamma_',kin_lbl{kin_idx},'_c3c4_diff_Prep_Reach_',dz{k},'_',stim_status{l},'_pre_pv,''r'')'])
            title(['pre ',num2str(eval(['gamma_',kin_lbl{kin_idx},'_c3c4_diff_Prep_Reach_',dz{k},'_',stim_status{l},'_pre_p(2)']))])

            subplot(2,2,2); hold on
            eval(['plot(gamma_',kin_lbl{kin_idx},'_c3c4_diff_Prep_Reach_',dz{k},'_',stim_status{l},'_eeg(:,2),gamma_',kin_lbl{kin_idx},'_c3c4_diff_Prep_Reach_',dz{k},'_',stim_status{l},'_kin(:,2),''.'')'])
            eval(['plot(gamma_',kin_lbl{kin_idx},'_c3c4_diff_Prep_Reach_',dz{k},'_',stim_status{l},'_eeg(:,2),gamma_',kin_lbl{kin_idx},'_c3c4_diff_Prep_Reach_',dz{k},'_',stim_status{l},'_i05_pv,''r'')'])
            title(['i05 ',num2str(eval(['gamma_',kin_lbl{kin_idx},'_c3c4_diff_Prep_Reach_',dz{k},'_',stim_status{l},'_i05_p(2)']))])

            subplot(2,2,3); hold on
            eval(['plot(gamma_',kin_lbl{kin_idx},'_c3c4_diff_Prep_Reach_',dz{k},'_',stim_status{l},'_eeg(:,3),gamma_',kin_lbl{kin_idx},'_c3c4_diff_Prep_Reach_',dz{k},'_',stim_status{l},'_kin(:,3),''.'')'])
            eval(['plot(gamma_',kin_lbl{kin_idx},'_c3c4_diff_Prep_Reach_',dz{k},'_',stim_status{l},'_eeg(:,3),gamma_',kin_lbl{kin_idx},'_c3c4_diff_Prep_Reach_',dz{k},'_',stim_status{l},'_i15_pv,''r'')'])
            title(['i15 ',num2str(eval(['gamma_',kin_lbl{kin_idx},'_c3c4_diff_Prep_Reach_',dz{k},'_',stim_status{l},'_i15_p(2)']))])

            subplot(2,2,4); hold on
            eval(['plot(gamma_',kin_lbl{kin_idx},'_c3c4_diff_Prep_Reach_',dz{k},'_',stim_status{l},'_eeg(:,4),gamma_',kin_lbl{kin_idx},'_c3c4_diff_Prep_Reach_',dz{k},'_',stim_status{l},'_kin(:,4),''.'')'])
            eval(['plot(gamma_',kin_lbl{kin_idx},'_c3c4_diff_Prep_Reach_',dz{k},'_',stim_status{l},'_eeg(:,4),gamma_',kin_lbl{kin_idx},'_c3c4_diff_Prep_Reach_',dz{k},'_',stim_status{l},'_pos_pv,''r'')'])
            title(['pos ',num2str(eval(['gamma_',kin_lbl{kin_idx},'_c3c4_diff_Prep_Reach_',dz{k},'_',stim_status{l},'_pos_p(2)']))])
            sgtitle(['Prep Reach ',dz{k},' ',stim_status{l},' ',subjectData(1).kinematics.label{kin_idx}])


            %clear gamma*
        end
    end
end
str_stim_vp_eeg=gamma_velocityPeaks_c3c4_diff_hold_prep_stroke_Stim_eeg(:,3)
str_stim_vp_kin=gamma_velocityPeaks_c3c4_diff_hold_prep_stroke_Stim_kin(:,3)
figure; plot(str_stim_vp_eeg,str_stim_vp_kin)
dlmwrite('file_str_stim_vp_eeg.txt',str_stim_vp_eeg)
dlmwrite('file_str_stim_vp_kin.txt',str_stim_vp_kin)

%% will work on 3D plots

%pre
reach1=[500:2000]
reach2=[2000:2500]
reach8=[6600:7600]

reach3=[2500:3000]
reach4=[3000:4000]
reach12=[10600:10899]

reach5=[4000:4600]
reach7=[5600:6600]
reach9=[7600:8600]

reach6=[4600:5600]
reach10=[8600:9600]
reach11=[9600:10600]

figure; hold on
plot3(trialData.vr(1).tracker.p.left(reach1,1),trialData.vr(1).tracker.p.left(reach1,2),trialData.vr(1).tracker.p.left(reach1,3),'r','Linewidth',2)
plot3(trialData.vr(1).tracker.p.left(reach2,1),trialData.vr(1).tracker.p.left(reach2,2),trialData.vr(1).tracker.p.left(reach2,3),'r','Linewidth',2)
plot3(trialData.vr(1).tracker.p.left(reach3,1),trialData.vr(1).tracker.p.left(reach3,2),trialData.vr(1).tracker.p.left(reach3,3),'c','Linewidth',2)
plot3(trialData.vr(1).tracker.p.left(reach4,1),trialData.vr(1).tracker.p.left(reach4,2),trialData.vr(1).tracker.p.left(reach4,3),'c','Linewidth',2)
plot3(trialData.vr(1).tracker.p.left(reach5,1),trialData.vr(1).tracker.p.left(reach5,2),trialData.vr(1).tracker.p.left(reach5,3),'g','Linewidth',2)
plot3(trialData.vr(1).tracker.p.left(reach6,1),trialData.vr(1).tracker.p.left(reach6,2),trialData.vr(1).tracker.p.left(reach6,3),'Color',[0.9290 0.6940 0.1250],'Linewidth',2)
plot3(trialData.vr(1).tracker.p.left(reach7,1),trialData.vr(1).tracker.p.left(reach7,2),trialData.vr(1).tracker.p.left(reach7,3),'g','Linewidth',2)
plot3(trialData.vr(1).tracker.p.left(reach8,1),trialData.vr(1).tracker.p.left(reach8,2),trialData.vr(1).tracker.p.left(reach8,3),'r','Linewidth',2)
plot3(trialData.vr(1).tracker.p.left(reach9,1),trialData.vr(1).tracker.p.left(reach9,2),trialData.vr(1).tracker.p.left(reach9,3),'g','Linewidth',2)
plot3(trialData.vr(1).tracker.p.left(reach10,1),trialData.vr(1).tracker.p.left(reach10,2),trialData.vr(1).tracker.p.left(reach10,3),'Color',[0.9290 0.6940 0.1250],'Linewidth',2)
plot3(trialData.vr(1).tracker.p.left(reach11,1),trialData.vr(1).tracker.p.left(reach11,2),trialData.vr(1).tracker.p.left(reach11,3),'Color',[0.9290 0.6940 0.1250],'Linewidth',2)
plot3(trialData.vr(1).tracker.p.left(reach12,1),trialData.vr(1).tracker.p.left(reach12,2),trialData.vr(1).tracker.p.left(reach12,3),'c','Linewidth',2)
xlabel('x')
ylabel('y')
zlabel('z')
set(gca,'View',[49.2496 58.3385])
grid on
legend

%pos
reach1=[700:1500]
reach2=[1500:2500]
reach8=[6000:6600]

reach3=[2500:3200]
reach4=[3200:4200]
reach12=[9000:9680]

reach5=[4200:4600]
reach7=[5600:6000]
reach9=[6600:7600]

reach6=[4600:5600]
reach10=[7600:8600]
reach11=[8600:9000]

figure; hold on
plot3(trialData.vr(3).tracker.p.left(reach1,1),trialData.vr(3).tracker.p.left(reach1,2),trialData.vr(3).tracker.p.left(reach1,3),'Color',[0.9290 0.6940 0.1250],'Linewidth',2)%%%
plot3(trialData.vr(3).tracker.p.left(reach2,1),trialData.vr(3).tracker.p.left(reach2,2),trialData.vr(3).tracker.p.left(reach2,3),'c','Linewidth',2)%%%
plot3(trialData.vr(3).tracker.p.left(reach3,1),trialData.vr(3).tracker.p.left(reach3,2),trialData.vr(3).tracker.p.left(reach3,3),'c','Linewidth',2)%%%
plot3(trialData.vr(3).tracker.p.left(reach4,1),trialData.vr(3).tracker.p.left(reach4,2),trialData.vr(3).tracker.p.left(reach4,3),'g','Linewidth',2)%%%
plot3(trialData.vr(3).tracker.p.left(reach5,1),trialData.vr(3).tracker.p.left(reach5,2),trialData.vr(3).tracker.p.left(reach5,3),'r','Linewidth',2)%%%
plot3(trialData.vr(3).tracker.p.left(reach6,1),trialData.vr(3).tracker.p.left(reach6,2),trialData.vr(3).tracker.p.left(reach6,3),'r','Linewidth',2)%
plot3(trialData.vr(3).tracker.p.left(reach7,1),trialData.vr(3).tracker.p.left(reach7,2),trialData.vr(3).tracker.p.left(reach7,3),'r','Linewidth',2)%%%
plot3(trialData.vr(3).tracker.p.left(reach8,1),trialData.vr(3).tracker.p.left(reach8,2),trialData.vr(3).tracker.p.left(reach8,3),'Color',[0.9290 0.6940 0.1250],'Linewidth',2)%%%
plot3(trialData.vr(3).tracker.p.left(reach9,1),trialData.vr(3).tracker.p.left(reach9,2),trialData.vr(3).tracker.p.left(reach9,3),'c','Linewidth',2)
plot3(trialData.vr(3).tracker.p.left(reach10,1),trialData.vr(3).tracker.p.left(reach10,2),trialData.vr(3).tracker.p.left(reach10,3),'Color',[0.9290 0.6940 0.1250],'Linewidth',2)
plot3(trialData.vr(3).tracker.p.left(reach11,1),trialData.vr(3).tracker.p.left(reach11,2),trialData.vr(3).tracker.p.left(reach11,3),'g','Linewidth',2)%%%
plot3(trialData.vr(3).tracker.p.left(reach12,1),trialData.vr(3).tracker.p.left(reach12,2),trialData.vr(3).tracker.p.left(reach12,3),'g','Linewidth',2)%
xlabel('x')
ylabel('y')
zlabel('z')
set(gca,'View',[49.2496 58.3385])
grid on
%legend


figure
plot(trialData.vr(3).tracker.v.left(:,1),'g','Linewidth',2)%




subplot(2,2,2)
plot3(trialData.vr(3).tracker.p.left(:,1),trialData.vr(3).tracker.p.left(:,2),trialData.vr(3).tracker.p.left(:,3))
subplot(2,2,3)
plot3(trialData.vr(3).tracker.p.left(:,1),trialData.vr(3).tracker.p.left(:,2),trialData.vr(3).tracker.p.left(:,3))
subplot(2,2,4)
plot3(trialData.vr(3).tracker.p.left(:,1),trialData.vr(3).tracker.p.left(:,2),trialData.vr(3).tracker.p.left(:,3))

    


