function eeg_dat_file=nr_eeg_anal_01_data_vis(file_path,sbj_no,dx,intervention)

% next you should count how many channels
% decide whether you want to look at reconstructions at this point or not


addpath ~/nr_data_analysis/data_scripts/nr
addpath ~/nr_data_analysis/data_raw/eeg

[hdr,c]=edfread(file_path);

[hdr,c]=edfread('~/Downloads/FENNELL~ WILSO_1d4784f8-d611-4da3-beb8-89acdb60a2df.edf');

figure
plot(hdr.C3{1})

eeg_dat_file.hdr=hdr;
eeg_dat_file.chans=c;
eeg_dat_file.cfg.sbj_no=sbj_no;
eeg_dat_file.cfg.dx=dx;
eeg_dat_file.cfg.int=intervention;

plot(hdr(

% %plot data (unscaled)
% for i=1:size(eeg_dat_file.chans,1)
%     figure; set(gcf,'Position',[3273 1013 512 418])
%     eval(['plot(eeg_dat_file.chans(',num2str(i),',:))'])
% end


% can probably delete!         
%     data.trials.t',num2str(i),'.sig.eeg(:,',num2str(j),')*10+j*1e4)']); hold on
%     end
% %     eval(['plot(data.trials.t',num2str(i),'.sig.sync(:,1))']);
% %     eval(['plot(data.trials.t',num2str(i),'.sig.trig(:,1))']);
% %     eval(['plot(data.trials.t',num2str(i),'.sig.amps(:,1))']);
% %     legend('Lch1','Lch2','Lch3','Lch4','Lch5','Lch6','sync','trig','amps')
%     %title(eval(['data.cfg.trial_data.t',num2str(i),'.cond']))
% end

%do this manually
figure; 
set(gcf,'Position',[6 56 830 1412]); hold on
for i=1:22
    eval(['plot(eeg_dat_file.chans(',num2str(i),',:)*2-(',num2str(i),'-1)*1000)'])
end
title(['pro00087153 ',sbj_no])
%set(gca,'ylim',[-2.5e4 0.5e4])
legend('Fp1','F7 ','T3 ','T5 ','O1 ','F3 ','C3 ','P3 ','A1 ','Fz ','Cz ','Fp2','F8 ',...
    'T4 ','T6 ','O2 ','F4 ','C4 ','P4 ','A2 ','Fpz ','Pz ')

% plot(eeg_dat_file.chans(1,:)*2)
% plot(eeg_dat_file.chans(2,:)*2-1000)
% plot(eeg_dat_file.chans(3,:)*2-2000)
% plot(eeg_dat_file.chans(4,:)*2-3000)
% plot(eeg_dat_file.chans(5,:)*2-4000)
% plot(eeg_dat_file.chans(6,:)*2-5000)
% plot(eeg_dat_file.chans(7,:)*2-6000)
% plot(eeg_dat_file.chans(8,:)*2-7000)
% plot(eeg_dat_file.chans(9,:)*2-8000)
% plot(eeg_dat_file.chans(10,:)*2-9000)
% plot(eeg_dat_file.chans(11,:)*2-10000)
% plot(eeg_dat_file.chans(12,:)*2-11000)
% plot(eeg_dat_file.chans(13,:)*2-12000)
% plot(eeg_dat_file.chans(14,:)*2-13000)
% plot(eeg_dat_file.chans(15,:)*2-14000)
% plot(eeg_dat_file.chans(16,:)*2-15000)
% plot(eeg_dat_file.chans(17,:)*2-16000)
% plot(eeg_dat_file.chans(18,:)*2-17000)
% plot(eeg_dat_file.chans(19,:)*2-18000)
% plot(eeg_dat_file.chans(20,:)*2-19000)
% plot(eeg_dat_file.chans(21,:)*2-20000)
% plot(eeg_dat_file.chans(22,:)*2-21000)

figure; 
set(gcf,'Position',[825 54 830 1412]); hold on

plot(eeg_dat_file.chans(23,:)*2)
plot(eeg_dat_file.chans(24,:)*2-2000)
plot(eeg_dat_file.chans(25,:)*2-4000)
plot(eeg_dat_file.chans(26,:)*2-6000)
plot(eeg_dat_file.chans(27,:)*2-8000)
plot(eeg_dat_file.chans(28,:)*2-10000)
plot(eeg_dat_file.chans(29,:)*2-12000)
plot(eeg_dat_file.chans(30,:)*2-14000)
plot(eeg_dat_file.chans(31,:)*2-16000)
plot(eeg_dat_file.chans(32,:)*2-18000)
plot(eeg_dat_file.chans(33,:)*2-20000)
plot(eeg_dat_file.chans(34,:)*2-22000)
plot(eeg_dat_file.chans(35,:)*2-24000)
plot(eeg_dat_file.chans(36,:)*2-26000)
plot(eeg_dat_file.chans(37,:)*2-28000)
plot(eeg_dat_file.chans(38,:)*2-30000)
plot(eeg_dat_file.chans(39,:)*2-32000)
plot(eeg_dat_file.chans(40,:)*2-34000)
plot(eeg_dat_file.chans(41,:)/20-38000)
plot(eeg_dat_file.chans(42,:)/5-35000)
plot(eeg_dat_file.chans(43,:)+18000)
plot(eeg_dat_file.chans(44,:))
plot(eeg_dat_file.chans(45,:)-60000)
plot(eeg_dat_file.chans(46,:)-62000)
%plot(eeg_dat_file.chans(47,:)-64000)
%title(['pro00087153 ',sbj_no])
legend

% legend('23','24','25','26','27','28','29','30','31','32','33','34','35',...
%     '36','37','38','39','40','41','42','43','44','45','46','47')
% set(gca,'ylim',[-7e4 2e4])
