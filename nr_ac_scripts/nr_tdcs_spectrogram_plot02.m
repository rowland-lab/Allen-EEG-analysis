function nr_tdcs_spectrogram_plot02(spectrogram,data,n)

figure;
set(gcf,'Position',[660 10 560 740])
%spi=[1,3,5,7,9,11];
clims1=[-7 -1];

for i=1:6%size(data.cfg.info.i_chan,2)
    subplot(6,2,i+(i-1))
    %subplot(size(data.cfg.info.i_chan,2),1,spi(i))
    hold(gca,'on');
    tmp1=spectrogram.spec(1:200,:,i);
    faxis_new = spectrogram.faxis(1:200);
    imagesc(spectrogram.taxis,faxis_new,tmp1,clims1);
    %imagesc(spectrogram.taxis,faxis_new,tmp1);
    hold(gca,'off');
    set(gca,'YDir','normal');
    set(gca,'XLim',[spectrogram.taxis(1) spectrogram.taxis(end)])
    set(gca,'YLim',[faxis_new(1) faxis_new(end)])
    %ylabel('Hz')
    ylabel(['ch',num2str(i)])
    if i==6
        xlabel('sec')
    end
    if i==1
        title(['s',data.cfg.info.n_sbj,' ',eval(['data.cfg.trial_data.t',...
                        num2str(n),'.cond'])])
    end
%     if i==6
%         xlabel('sec')
%     end 
    colorbar
end

for i=1:6%size(data.cfg.info.i_chan,2)
    subplot(6,2,i*2)
    %subplot(size(data.cfg.info.i_chan,2),1,spi(i))
    hold(gca,'on');
    tmp1=spectrogram.spec(1:200,:,[(i*2)+(6-i)]);
    faxis_new = spectrogram.faxis(1:200);
    imagesc(spectrogram.taxis,faxis_new,tmp1,clims1);
    %imagesc(spectrogram.taxis,faxis_new,tmp1);
    hold(gca,'off');
    set(gca,'YDir','normal');
    set(gca,'XLim',[spectrogram.taxis(1) spectrogram.taxis(end)])
    set(gca,'YLim',[faxis_new(1) faxis_new(end)])
    %ylabel('Hz')
    ylabel(['ch',num2str([(i*2)+(6-i)])])
    if i==6
        xlabel('sec')
    end
%     if i==1
%         title(['s',data.cfg.info.n_sbj,' ',eval(['data.cfg.trial_data.t',...
%                         num2str(i),'.cond'])])
%     end
%     if i==6
%         xlabel('sec')
%     end 
    colorbar
end

