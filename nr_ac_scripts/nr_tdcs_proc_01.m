function tdcs_proc_01(data_file,sbj_no,trial_no,epochs

s13_t1_ecog_res=resample(s13_t1_ecog',2^10,5^5);
s13_t1_sync_res=resample(s13_t1_sync',2^10,5^5);
s13_t1_trig_res=resample(s13_t1_trig',2^10,5^5);
s13_t1_amps_res=resample(s13_t1_amps',2^10,5^5);
% include description of trial? would need a cell for that...actually would
% do a whole separate function for that or maybe just define the cell
% upfront then put the cell in the function and let that set up the trials,
% etc
%include a legend somewhere in there
legend('Rch1','Rch2','Rch3','Rch4','Rch5','Rch6','Rch7','Rch8')

%filter
Fs=1000;
[n2_b, n2_a]=butter(3,2*[117 123]/Fs,'stop');%120 Hz
[n3_b, n3_a]=butter(3,2*[177 183]/Fs,'stop');%180 Hz
s13_t1_ecog_res_filt=filtfilt(n2_b,n2_a,s13_t1_ecog_res);
s13_t1_ecog_res_filt=filtfilt(n3_b,n3_a,s13_t1_ecog_res_filt);

data_pro00073545_s13.t1.sig.ecog=s13_t1_ecog_res_filt;

data_pro00073545_s13.t1.epochs.e1(1,1)=1e4;
data_pro00073545_s13.t1.epochs.e1(1,2)=4e4;

%calculate psd of whole segment
[data_pro00073545_s13.t1.psd.e1.saw,data_pro00073545_s13.t1.psd.freq]=pwelch(data_pro00073545_s13.t1.sig.ecog,512,0.5,512,1000);

%plot#1
%plot psd curves - all overlaid
figure
plot(log10(data_pro00073545_s13.t1.psd.e1.saw([1:103],:)))

%plot#2 - separate by channel
figure;
set(gcf,'Position',[100 10 560 740])
for i=1:6
    subplot(6,2,i+(i-1))
    plot(log10(psd_s13_t1_ecog_e1_saw([1:103],i)));
    set(gca,'ylim',[min_psd_s13_t1_ecog_e1_saw max_psd_s13_t1_ecog_e1_saw-0.1*max_psd_s13_t1_ecog_e1_saw])
    ylabel(['ch',num2str(i)])
    if i==1
        title('s13 t1 e1 60s rest Left')
    end
    if i==6
        xlabel('Hz')
    end
end

%plot#3
%512
% delta(2-3)        1-4 Hz
% theta(3-5)        4-8 Hz
% alpha(5-7)       8-12 Hz
% beta(8-16)       13-30 Hz
% gamma_low(16-27)  30-50 Hz
% gamma_bb(37-103)  70-200 Hz

%plot #3calculate mean psd by freq band to see if there are big changes
mean_psd_saw_delta_s13_t1_e1=mean(log10(data_pro00073545_s13.t1.psd.e1.saw([2:3],:)));
mean_psd_saw_theta_s13_t1_e1=mean(log10(data_pro00073545_s13.t1.psd.e1.saw([3:5],:)));
mean_psd_saw_alpha_s13_t1_e1=mean(log10(data_pro00073545_s13.t1.psd.e1.saw([5:7],:)));
mean_psd_saw_beta_s13_t1_e1=mean(log10(data_pro00073545_s13.t1.psd.e1.saw([8:16],:)));
mean_psd_saw_gamma_l_s13_t1_e1=mean(log10(data_pro00073545_s13.t1.psd.e1.saw([16:27],:)));
mean_psd_saw_gamma_bb_s13_t1_e1=mean(log10(data_pro00073545_s13.t1.psd.e1.saw([37:103],:)));





figure
subplot(6,1,1)
bar(mean_psd_saw_delta_s13_t1_e1)
set(gca,'XTick',[],'ylim',[-16 0])
title('s13 t1 e1 60s rest mean psd delta')
subplot(6,1,2)
bar(mean_psd_saw_theta_s13_t1_e1)
set(gca,'XTick',[],'ylim',[-16 0])
title('mean psd theta')
subplot(6,1,3)
bar(mean_psd_saw_alpha_s13_t1_e1)
set(gca,'XTick',[],'ylim',[-16 0])
title('mean psd alpha')
subplot(6,1,4)
bar(mean_psd_saw_beta_s13_t1_e1)
set(gca,'XTick',[],'ylim',[-16 0])
title('mean psd beta')
subplot(6,1,5)
bar(mean_psd_saw_gamma_l_s13_t1_e1)
set(gca,'XTick',[],'ylim',[-16 0])
title('mean psd gamma low')
subplot(6,1,6)
bar(mean_psd_saw_gamma_bb_s13_t1_e1)
title('mean psd gamma bb')
set(gca,'ylim',[-17 0])
xlabel('channel #')

frq_ind{1}=[2:3];
frq_ind{2}=[3:5];
frq_ind{3}=[5:7];
frq_ind{4}=[8:16];
frq_ind{5}=[16:27];
frq_ind{6}=[37:103];

%in general things were set up this way, 3 for loops: first freq band, then
%epoch, then channel

for i=1:size(frq_ind,2)
    figure
    set(gcf,'Position',[100 10 560 740])
    for j=1:6
        subplot(6,2,j+(j-1))
        hold on
        for k=1:size(psd_s12_t10_ecog_seg_st.e1,1)
            
            frq_band_txt{1}='delta';
frq_band_txt{2}='theta';
frq_band_txt{3}='alpha';
frq_band_txt{4}='beta';
frq_band_txt{5}='gamma_l';
frq_band_txt{6}='gamma_bb';

% what about spectrograms?

%I think it makes sense to do stats only at the end and not for each
%individual trial

%calculate mean/se psd of each freq band for each segment
frq_band_txt{1}='delta';
frq_band_txt{2}='theta';
frq_band_txt{3}='alpha';
frq_band_txt{4}='beta';
frq_band_txt{5}='gamma_l';
frq_band_txt{6}='gamma_bb';
frq_band_ind{1}=['2:3'];
frq_band_ind{2}=['3:5'];
frq_band_ind{3}=['5:7'];
frq_band_ind{4}=['8:16'];
frq_band_ind{5}=['16:27'];
frq_band_ind{6}=['37:103'];

for i=1:6
    for j=1:size(data_pro00073545_s13.t1.psd.e1.sai.vals,1)
        eval(['data_pro00073545_s13.t1.psd.e1.sai.means.',frq_band_txt{i},'(',num2str(j),',:)=mean(data_pro00073545_s13.t1.psd.e1.sai.vals(',...
            num2str(j),',',frq_band_ind{i},',:));']);
    end        
end

%calculate supermeans
for i=1:6
    eval(['data_pro00073545_s13.t1.psd.e1.sai.supermeans.',frq_band_txt{i},'=mean(data_pro00073545_s13.t1.psd.e1.sai.means.',...
        frq_band_txt{i},')'])     
end

% looks like you will need 4 levels of for loops
%btw you should do a config piece of code to add in all the filenames,
%trials, etc
