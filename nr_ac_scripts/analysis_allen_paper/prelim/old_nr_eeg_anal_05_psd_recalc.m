function nr_eeg_anal_05_psd_recalc(data_file)

data_file='~/nr_data_analysis/data_analyzed/eeg/data_eeg_anal_rest_pro00087153_0004.mat'
load(data_file)
data=eval(data_file(38:72))

frq_band_ind=data.cfg.info.frq_band_ind;
frq_band_txt=data.cfg.info.frq_band_txt;
mat_trial_epoch=data.cfg.info.mat_trial_epoch;

% %calculate psd of whole epoch
% for i=1:size(mat_trial_epoch,1)
%     for j=1:mat_trial_epoch(i,3)
%         eval(['[data.trials.t',num2str(i),'.psd.e',num2str(j),'.saw,data.trials.t',num2str(i),'.psd.freq]=pwelch(data.trials.t',num2str(i),...
%         '.sig.eeg([data.trials.t',num2str(i),'.epochs.e',num2str(j),'(1):data.trials.t',num2str(i),'.epochs.e',num2str(j),'(2)],:),512,0.5,512,1024);']);
%     end
% end

% %plot psd curves - separate by epoch - all channels overlaid
% for i=1:size(mat_trial_epoch,1)
%     for j=1:mat_trial_epoch(i,3)
% 
%         %if j==1
%             figure;%set(gcf,'Position',[549   303   583   767])
%             hold on
%             %set(gcf,'Position',[100 10 560 740])
%         %end
%         %subplot(2,2,j)
%         eval(['plot(data.trials.t',num2str(i),'.psd.freq(1:103),log10(data.trials.t',num2str(i),'.psd.e',num2str(j),'.saw(1:103,:)))'])
%         ylabel('log power')
%         xlabel('Hz')
%         %if j==1
%             legend('Lch1 ','Lch2 ','Lch3 ','Lch4 ','Lch5 ','Lch6 ','Lch7 ','Lch8 ','Lch9 ',...
%                 'Lch10','Lch11','Lch12','Lch13','Lch14','Lch15','Lch16','Lch17','Lch18','Lch19','Lch20','Lch21','Lch22')
%             title(['s',data.cfg.info.n_sbj,' t',num2str(i),' ',eval(['data.cfg.trial_data.t',num2str(i),'.cond']),' e',num2str(j),' all channels'])
%         %end
%     end
% end
%% Paul please change
% figure;
% set(gcf,'Position',[100 10 560 740])
% dim = [.1 .65 .3 .3];
% annotation('textbox',dim,'String','t1:e1:rest','FitBoxToText','on');
% dim = [.1 .60 .3 .3];
% annotation('textbox',dim,'String','t1:e2:VR baseline no stim - 1','FitBoxToText','on');
% dim = [.1 .55 .3 .3];
% annotation('textbox',dim,'String','t1:e3:VR baseline no stim - 2','FitBoxToText','on');
% dim = [.1 .50 .3 .3];
% annotation('textbox',dim,'String','t1:e4:rest - 1','FitBoxToText','on');
% dim = [.1 .45 .3 .3];
% annotation('textbox',dim,'String','t1:e5:rest - 2','FitBoxToText','on');
% dim = [.1 .40 .3 .3];
% annotation('textbox',dim,'String','t1:e6:VR prestim - 1','FitBoxToText','on');
% dim = [.1 .35 .3 .3];
% annotation('textbox',dim,'String','t1:e7:VR prestim - 2','FitBoxToText','on');
% dim = [.1 .30 .3 .3];
% annotation('textbox',dim,'String','t1:e8:5 min stim - 1','FitBoxToText','on');
% dim = [.1 .25 .3 .3];
% annotation('textbox',dim,'String','t1:e9:5 min stim - 2','FitBoxToText','on');
% dim = [.1 .20 .3 .3];
% annotation('textbox',dim,'String','t1:e10:VR poststim 1 - 1','FitBoxToText','on');
% dim = [.1 .15 .3 .3];
% annotation('textbox',dim,'String','t1:e11:VR poststim 1 - 2','FitBoxToText','on');
% dim = [.1 .10 .3 .3];
% annotation('textbox',dim,'String','t1:e12:8 min stim - 1','FitBoxToText','on');
% dim = [.1 .05 .3 .3];
% annotation('textbox',dim,'String','t1:e13:8 min stim - 2','FitBoxToText','on');
% % 
% % figure;
% % set(gcf,'Position',[100 10 560 740])
% dim = [.5 .65 .3 .3];
% annotation('textbox',dim,'String','t1:e14:VR poststim 2 - 1','FitBoxToText','on');
% dim = [.5 .60 .3 .3];
% annotation('textbox',dim,'String','t1:e15:VR poststim 2 - 2','FitBoxToText','on');
% dim = [.5 .55 .3 .3];
% annotation('textbox',dim,'String','t1:e16:3 min stim - 1','FitBoxToText','on');
% dim = [.5 .50 .3 .3];
% annotation('textbox',dim,'String','t1:e17:5 min rest','FitBoxToText','on');
% dim = [.5 .45 .3 .3];
% annotation('textbox',dim,'String','t1:e18:VR poststim 3 - 1','FitBoxToText','on');
% dim = [.5 .40 .3 .3];
% annotation('textbox',dim,'String','t1:e19:VR poststim 3 - 2','FitBoxToText','on');
% dim = [.5 .35 .3 .3];
% annotation('textbox',dim,'String','t1:e20:rest - 1','FitBoxToText','on');
% dim = [.5 .30 .3 .3];
% annotation('textbox',dim,'String','t1:e21:rest - 2','FitBoxToText','on');
% % dim = [.1 .25 .3 .3];
% % annotation('textbox',dim,'String','t1:e22:Left Anodal tdcs 2mA 2 min-1','FitBoxToText','on');
% % dim = [.1 .20 .3 .3];
% % annotation('textbox',dim,'String','t1:e23:Left Anodal tdcs 2mA 2 min-2','FitBoxToText','on');
% % dim = [.1 .15 .3 .3];
% % annotation('textbox',dim,'String','t1:e24:60s - 1','FitBoxToText','on');
% % dim = [.1 .10 .3 .3];
% % annotation('textbox',dim,'String','t1:e25:60s - 2','FitBoxToText','on');


% % plot psd curves - separate by channel - all epochs overlaid
% %spi=[1,3,5,7,9,11];
% spi=[1:22];
% 
% for i=1:size(mat_trial_epoch,1)
%     figure
%     set(gcf,'Position',[44 78 1301 741])
%     for j=1:mat_trial_epoch(i,3)
%         for k=1:size(data.cfg.info.i_chan,2)
%             subplot(6,4,spi(k))
%             hold on
% %             if k==1
% %                 title(['s',data.cfg.info.n_sbj,' t',num2str(i),' ',eval(['data.cfg.trial_data.t',num2str(i),'.cond']),' e',num2str(j),' all channels'])
% %                 
% %             end
%             eval(['plot(data.trials.t',num2str(i),'.psd.freq(1:103),log10(data.trials.t',num2str(i),'.psd.e',num2str(j),'.saw(1:103,',num2str(k),')))'])
%             ylabel(['ch',num2str(k)])
%             if k==1
%                 legend
%             elseif k==6
%                 xlabel('Hz')
%             end
%         end
%     end
% %     subplot(6,2,1)
% %     epoch_names_all=eval(['fieldnames(data.trials.t',num2str(i),'.psd);']);
% %     epoch_names_e=epoch_names_all(strncmp(epoch_names_all,'e',1),:);
% %     legend(epoch_names_e)
% end
% title(['sbj ',data.cfg.info.n_sbj,' all epochs'])


% calculate psd in 1-sec segments of each epoch

% delta(2-3)        1-4 Hz
% theta(3-5)        4-8 Hz
% alpha(5-7)       8-12 Hz
% beta(8-16)       13-30 Hz
% gamma_low(16-27)  30-50 Hz
% gamma_bb(37-103)  70-200 Hz

% for i=1:size(mat_trial_epoch,1)
%     for j=1:mat_trial_epoch(i,3)
%         for k=1:eval(['(data.trials.t',num2str(i),'.epochs.e',num2str(j),'(2)-data.trials.t',...
%                 num2str(i),'.epochs.e',num2str(j),'(1))/1000'])
%             eval(['data.trials.t',num2str(i),'.psd.e',num2str(j),'.sai.vals(',num2str(k),',:,:)=pwelch(data.trials.t',...
%                 num2str(i),'.sig.eeg([(',num2str(k),'-1)*1000+1+data.trials.t',num2str(i),'.epochs.e',num2str(j),...
%                 '(1):',num2str(k),'*1000+data.trials.t',num2str(i),'.epochs.e',num2str(j),'(1)],:),512,0.5,512,1000);']);
%         end
%     end
% end
% 
%  
% % calculate mean psd of each freq band for each segment
% for i=1:size(mat_trial_epoch,1)
%     for j=1:mat_trial_epoch(i,3)
%         for k=1:size(frq_band_ind,2)
%             for m=1:eval(['size(data.trials.t',num2str(i),'.psd.e',num2str(j),'.sai.vals,1)'])
%                 eval(['data.trials.t',num2str(i),'.psd.e',num2str(j),'.sai.means.',frq_band_txt{k},'(',num2str(m),',:)=mean(data.trials.t',num2str(i),'.psd.e',num2str(j),'.sai.vals(',...
%                     num2str(m),',',frq_band_ind{k},',:));']);
%         %         ['data_pro00073545_s14.t4.psd.e',num2str(i),'.sai.means.',frq_band_txt{j},'(',num2str(k),',:)=mean(data_pro00073545_s14.t4.psd.e',num2str(i),'.sai.vals(',...
%         %             num2str(k),',',frq_band_ind{j},',:))']
% %                 ['data_pro00073545_s14.t4.psd.e',num2str(i),'.sai.means.',frq_band_txt{j},'(k,:)=mean(data_pro00073545_s14.t4.psd.e',num2str(i),'.sai.vals(',...
% %                     'k,',frq_band_ind{j},',:))']
% % ['data_pro00073545_s14.t',num2str(i),'.psd.e',num2str(j),'.sai.means.',frq_band_txt{k},'(',num2str(m),',:)=mean(data_pro00073545_s14.t',num2str(i),'.psd.e',num2str(j),'.sai.vals(',...
% %                      num2str(m),',',frq_band_ind{k},',:));']
%             end        
%         end
%     end
% end


% %calculate supermeans and ses
% for i=1:size(mat_trial_epoch,1)
%     for j=1:mat_trial_epoch(i,3)
%         for k=1:size(frq_band_ind,2)
%             eval(['data.trials.t',num2str(i),'.psd.e',num2str(j),'.sai.supermeans.',frq_band_txt{k},'=mean(data.trials.t',num2str(i),'.psd.e',num2str(j),'.sai.means.',...
%                 frq_band_txt{k},');']);
%             eval(['data.trials.t',num2str(i),'.psd.e',num2str(j),'.sai.ses.',frq_band_txt{k},'=std(data.trials.t',num2str(i),'.psd.e',num2str(j),'.sai.means.',...
%                 frq_band_txt{k},')/sqrt(size(data.trials.t',num2str(i),'.psd.e',num2str(j),'.sai.means.',frq_band_txt{k},',1))']);
%         end
%     end
% end
% 
% 
% %plotting individual segment means - remember these should not have errorbars
% %WARNING - lots of plots, break up into individual freq bands
% for i=1:size(mat_trial_epoch,1)
%     for j=1:mat_trial_epoch(i,3)
%         for k=4%:size(frq_band_ind,2)
%             for m=[7 18]%1:size(data.cfg.info.i_chan,2)
%                 if m==7%1
%                     figure;
%                     set(gcf,'Position',[44 78 1301 741])
%                 end
%                 subplot(6,4,spi(m))
%                 eval(['bar(data.trials.t',num2str(i),'.psd.e',num2str(j),'.sai.means.',frq_band_txt{k},'(:,m))'])
%                 ylabel(['ch',num2str(m)])
%                 if m==1
%                     title(['s',data.cfg.info.n_sbj,' t',num2str(i),' ',eval(['data.cfg.trial_data.t',...
%                         num2str(i),'.cond']),' ',frq_band_txt{k},' e',num2str(j)])
%                 end
%                 if m==size(data.cfg.info.i_chan,2)
%                     xlabel('segment #')
%                 end
%             end
%         end
%     end
% end

figure
set(gcf,'Position',[99 100 852 1362])

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



% 
% 
% 
% 
% %% stats
% 
% % calculate groups
% for i=1% here i is serving just for the counter
%     count=0
%     for j=mat_trial_epoch(:,1)'
%         for k=1:mat_trial_epoch(j,3)
%             count=count+1
%             eval(['mat_sz_epoch{',num2str(count),'}=linspace(',num2str(count),',',num2str(count),...
%                 ',size(data.trials.t',num2str(mat_trial_epoch(j,2)),'.psd.e',num2str(k),'.sai.vals,1));'])
%         end
%     end
% end
% grp_epochs=cat(2,mat_sz_epoch{:});
% 
% % %%% another way to do it
% % grp_epochs=0
% % for i=1:size(mat_sz_epoch,2)
% %     if i==1
% %         grp_epochs(1:size(mat_sz_epoch{i},2))=mat_sz_epoch{i};
% %     else
% %         grp_epochs(size(grp_epochs,2)+1:size(grp_epochs,2)+size(mat_sz_epoch{i},2))=mat_sz_epoch{i};
% %     end
% % end
% % %%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% % rearrange means by frq band and channel
% for i=1:size(mat_trial_epoch,1)
%     for j=1:mat_trial_epoch(i,3)
%         for k=1:size(frq_band_ind,2)
%             for l=1:size(data.cfg.info.i_chan,2)                
%                 eval(['mat_stat_means.t',num2str(i),'.e',num2str(j),'.',frq_band_txt{k},'.c',num2str(l),'=data.trials.t',num2str(i),'.psd.e',num2str(j),'.sai.means.',frq_band_txt{k},'(:,',num2str(l),');']);
%             end
%         end
%     end
% end
% 
% for i=1:size(frq_band_ind,2)
%     for j=1:size(data.cfg.info.i_chan,2)   
%     count=0;
%         for k=1:size(mat_trial_epoch,1)
%             for l=1:mat_trial_epoch(k,3)
%                 count=count+1;
%                 eval(['mat_stat_means.',frq_band_txt{i},'.c',num2str(j),'{count}=data.trials.t',...
%                 num2str(k),'.psd.e',num2str(l),'.sai.means.',frq_band_txt{i},'(:,',num2str(j),');']);
%             end
%         end
%     end
% end
% 
% for i=1:size(frq_band_ind,2)
%     for j=1:size(data.cfg.info.i_chan,2)  
%         eval(['data.stats.psd.means.',frq_band_txt{i},'.c',num2str(j),'=cat(1,mat_stat_means.',frq_band_txt{i},'.c',num2str(j),'{:})''']);
%     end
% end
%     
% %calculate statistic and corrected p-values
% for i=1:size(frq_band_txt,2)
%     for j=1:size(data.cfg.info.i_chan,2)
%         eval(['[data.stats.psd.test.kw.p.',frq_band_txt{i},'.c',num2str(j),...
%             ',data.stats.psd.test.kw.anovatab.',frq_band_txt{i},'.c',num2str(j),...
%             ',data.stats.psd.test.kw.stats.',frq_band_txt{i},'.c',num2str(j),...
%             ']= kruskalwallis(data.stats.psd.means.',frq_band_txt{i},'.c',num2str(j),...
%             ',grp_epochs,''off'')'])
%     end
% end
% 
% for i=1:size(frq_band_txt,2)
%     for j=1:size(data.cfg.info.i_chan,2)
%         eval(['data.stats.psd.test.kw.mc.',frq_band_txt{i},'.c',num2str(j),'= multcompare(data.stats.psd.test.kw.stats.',frq_band_txt{i},'.c',num2str(j),',''ctype'',''bonferroni'',''display'',''off'')'])
%     end
% end
% 
% for i=1:size(frq_band_txt,2)
%     for j=1:size(data.cfg.info.i_chan,2)
%         eval(['mc_find.',frq_band_txt{i},'.p_corr{',num2str(j),'}=find(data.stats.psd.test.kw.mc.',frq_band_txt{i},'.c',num2str(j),'(:,6)<0.05)'])
%     end
% end
% 
% data.stats.psd.test.kw.p_corr=[];
% for i=1:size(frq_band_txt,2)
%     for j=1:size(data.cfg.info.i_chan,2)
%         if isempty(data.stats.psd.test.kw.p_corr)==1
%             eval(['data.stats.psd.test.kw.p_corr=linspace(',num2str(i),',',num2str(i),...
%                 ',length(mc_find.',frq_band_txt{i},'.p_corr{',num2str(j),'}))'';']);
%             eval(['data.stats.psd.test.kw.p_corr(:,2)=linspace(',num2str(j),',',num2str(j),...
%                 ',length(mc_find.',frq_band_txt{i},'.p_corr{',num2str(j),'}))'';']);
%             eval(['data.stats.psd.test.kw.p_corr(:,3)=data.stats.psd.test.kw.mc.',...
%                 frq_band_txt{i},'.c',num2str(j),'(mc_find.',frq_band_txt{i},'.p_corr{j},1);'])
%             eval(['data.stats.psd.test.kw.p_corr(:,4)=data.stats.psd.test.kw.mc.',...
%                 frq_band_txt{i},'.c',num2str(j),'(mc_find.',frq_band_txt{i},'.p_corr{j},2);'])
%             eval(['data.stats.psd.test.kw.p_corr(:,5)=data.stats.psd.test.kw.mc.',...
%                 frq_band_txt{i},'.c',num2str(j),'(mc_find.',frq_band_txt{i},'.p_corr{j},6);'])
%         else
%             size_p_corr=size(data.stats.psd.test.kw.p_corr,1); 
%             eval(['data.stats.psd.test.kw.p_corr(size_p_corr+1:size_p_corr+length(mc_find.',frq_band_txt{i},'.p_corr{',num2str(j),'}),1)=linspace(',num2str(i),',',num2str(i),...
%                 ',length(mc_find.',frq_band_txt{i},'.p_corr{',num2str(j),'}))'';']);
%             eval(['data.stats.psd.test.kw.p_corr(size_p_corr+1:size_p_corr+length(mc_find.',frq_band_txt{i},'.p_corr{',num2str(j),'}),2)=linspace(',num2str(j),',',num2str(j),...
%                 ',length(mc_find.',frq_band_txt{i},'.p_corr{',num2str(j),'}))'';']);
%             eval(['data.stats.psd.test.kw.p_corr(size_p_corr+1:size_p_corr+length(mc_find.',frq_band_txt{i},'.p_corr{',num2str(j),'}),3)=data.stats.psd.test.kw.mc.',...
%                 frq_band_txt{i},'.c',num2str(j),'(mc_find.',frq_band_txt{i},'.p_corr{j},1);'])
%             eval(['data.stats.psd.test.kw.p_corr(size_p_corr+1:size_p_corr+length(mc_find.',frq_band_txt{i},'.p_corr{',num2str(j),'}),4)=data.stats.psd.test.kw.mc.',...
%                 frq_band_txt{i},'.c',num2str(figure
set(gcf,'Position',[99 100 852 1362])

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
bar(data.trials.t1.psd.e4.sai.means.beta(:,18))j),'(mc_find.',frq_band_txt{i},'.p_corr{j},2);'])
%             eval(['data.stats.psd.test.kw.p_corr(size_p_corr+1:size_p_corr+length(mc_find.',frq_band_txt{i},'.p_corr{',num2str(j),'}),5)=data.stats.psd.test.kw.mc.',...
%                 frq_band_txt{i},'.c',num2str(j),'(mc_find.',frq_band_txt{i},'.p_corr{j},6);'])
%         end
%     end
% end
% 
% %also I would calculate the most frequently seen epoch pairing within the
% %corrected p-values as well as the most frequently seen frequency range and
% %channel
% data.stats.psd.test.kw.p_corr_mets.frq(1,1)=1;
% data.stats.psd.test.kw.p_corr_mets.frq(1,2)=size(find(data.stats.psd.test.kw.p_corr(:,1)==1),1);
% data.stats.psd.test.kw.p_corr_mets.frq(2,1)=2;
% data.stats.psd.test.kw.p_corr_mets.frq(2,2)=size(find(data.stats.psd.test.kw.p_corr(:,1)==2),1);
% data.stats.psd.test.kw.p_corr_mets.frq(3,1)=3;
% data.stats.psd.test.kw.p_corr_mets.frq(3,2)=size(find(data.stats.psd.test.kw.p_corr(:,1)==3),1);
% data.stats.psd.test.kw.p_corr_mets.frq(4,1)=4;
% data.stats.psd.test.kw.p_corr_mets.frq(4,2)=size(find(data.stats.psd.test.kw.p_corr(:,1)==4),1);
% data.stats.psd.test.kw.p_corr_mets.frq(5,1)=5;
% data.stats.psd.test.kw.p_corr_mets.frq(5,2)=size(find(data.stats.psd.test.kw.p_corr(:,1)==5),1);
% data.stats.psd.test.kw.p_corr_mets.frq(6,1)=6;
% data.stats.psd.test.kw.p_corr_mets.frq(6,2)=size(find(data.stats.psd.test.kw.p_corr(:,1)==6),1);
% 
% data.stats.psd.test.kw.p_corr_mets.ch(1,1)=1;
% data.stats.psd.test.kw.p_corr_mets.ch(1,2)=size(find(data.stats.psd.test.kw.p_corr(:,2)==1),1);
% data.stats.psd.test.kw.p_corr_mets.ch(2,1)=2;
% data.stats.psd.test.kw.p_corr_mets.ch(2,2)=size(find(data.stats.psd.test.kw.p_corr(:,2)==2),1);
% data.stats.psd.test.kw.p_corr_mets.ch(3,1)=3;
% data.stats.psd.test.kw.p_corr_mets.ch(3,2)=size(find(data.stats.psd.test.kw.p_corr(:,2)==3),1);
% data.stats.psd.test.kw.p_corr_mets.ch(4,1)=4;
% data.stats.psd.test.kw.p_corr_mets.ch(4,2)=size(find(data.stats.psd.test.kw.p_corr(:,2)==4),1);
% data.stats.psd.test.kw.p_corr_mets.ch(5,1)=5;
% data.stats.psd.test.kw.p_corr_mets.ch(5,2)=size(find(data.stats.psd.test.kw.p_corr(:,2)==5),1);
% data.stats.psd.test.kw.p_corr_mets.ch(6,1)=6;
% data.stats.psd.test.kw.p_corr_mets.ch(6,2)=size(find(data.stats.psd.test.kw.p_corr(:,2)==6),1);
% %% plots
% 
% %prepare supermeans and errorbars for plotting - arranged by epoch and
% %channel
% for i=1:size(frq_band_txt,2)
%     for j=1:size(data.cfg.info.i_chan,2)
%     count=0
%         for k=mat_trial_epoch(:,1)'
%             for l=1:mat_trial_epoch(k,3)
%                 count=count+1;
%                 eval(['data.plots.',frq_band_txt{i},'.c',num2str(j),...
%                     '.supermeans(',num2str(count),')=data.trials.t',...
%                     num2str(mat_trial_epoch(k,2)),'.psd.e',num2str(l),...
%                     '.sai.supermeans.',frq_band_txt{i},'(',num2str(j),')'])
%                 eval(['data.plots.',frq_band_txt{i},'.c',num2str(j),...
%                     '.ses(',num2str(count),')=data.trials.t',...
%                     num2str(mat_trial_epoch(k,2)),'.psd.e',num2str(l),...
%                     '.sai.ses.',frq_band_txt{i},'(',num2str(j),')'])
%             end
%         end
%     clear count
%     end
% end
% 
% %plot supermeans and errorbars 
% for i=1:size(frq_band_txt,2)
%     for j=1:size(data.cfg.info.i_chan,2)
%         if j==1
%             figure
%             set(gcf,'Position',[44 78 1301 741])
%         end
%             %subplot(size(data.cfg.info.i_chan,2),2,spi(j))
%             subplot(6,4,spi(j))
%             eval(['bar([data.plots.',frq_band_txt{i},'.c',num2str(j),'.supermeans])']);hold on
%             eval(['errorbar(data.plots.',frq_band_txt{i},'.c',num2str(j),'.supermeans,data.plots.',frq_band_txt{i},'.c',num2str(j),'.ses,''.k'')'])
%             ylabel(['ch',num2str(j)])
%         if j==1
%             title(['pro00087153 00',data.cfg.info.n_sbj,' ',data.cfg.trial_data.t1.cond,' ',frq_band_txt{i}])
%         elseif j==size(data.cfg.info.i_chan,2)
%             xlabel('epochs')
%         end
%     end
% end
% 
% cd('~/nr_data_analysis/data_analyzed/eeg')
% eval(['data_eeg_anal_',data.cfg.trial_data.t1.cond,'_pro00087153_00',data.cfg.info.n_sbj,'=data;'])
% eval(['save(''data_eeg_anal_',data.cfg.trial_data.t1.cond,'_pro00087153_00',data.cfg.info.n_sbj,''')'])
% clear