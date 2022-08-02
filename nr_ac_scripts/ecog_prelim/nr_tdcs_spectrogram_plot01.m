function nr_tdcs_spectrogram_plot01(spectrogram,data,n,spi)

figure;
set(gcf,'Position',[50 10 560 740])
%spi=[1,3,5,7,9,11];
clims1=[-7 -1];

for i=1:size(data.cfg.info.i_chan,2)
    subplot(size(data.cfg.info.i_chan,2),1,spi(i))
    hold(gca,'on');
    tmp1=spectrogram.spec(1:200,:,i);
    faxis_new = spectrogram.faxis(1:200);
    imagesc(spectrogram.taxis,faxis_new,tmp1,clims1);
    hold(gca,'off');
    set(gca,'YDir','normal');
    set(gca,'XLim',[spectrogram.taxis(1) spectrogram.taxis(end)])
    %set(gca,'YLim',[faxis_new(1) faxis_new(end)])
    set(gca,'YLim',[0 200])
    %ylabel('Hz')
    ylabel(['ch',num2str(i)])
    if i==6
        xlabel('s')
    end
    if i==1
        title(['s',data.cfg.info.n_sbj,' t',num2str(n),' ',eval(['data.cfg.trial_data.t',...
                        num2str(n),'.cond'])])
    end
%     if i==6
%         xlabel('sec')
%     end 
    colorbar
end
