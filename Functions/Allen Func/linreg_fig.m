function [figdat,fighandle,info]=linreg_fig(input,figdim,figtitle,trialnames,rownames,columnnames)


data=input.dat;
nval=input.nval;
rval=input.rval;
fdrval=input.fdrval;
info=input.info;


fighandle=figure('Name',figtitle,'units','normalized','outerposition',[0 0 1 1]);
for i=1:length(trialnames)
    subplot(figdim(1),figdim(2),i)
    figdata=fdrval(:,:,i);
    figdata(isnan(figdata))=1;
    figdata(figdata>0.05)=1;
    imagesc(figdata)
    title([trialnames{i},' n=',num2str(unique(nval(:,:,i)))])
    cb=colorbar;
    caxis([0 0.10])
    ylabel(cb,'fdr corrected pvalue','fontsize',6);
    cb.FontSize = 10;
    colormap(flipud(jet));
    yticks(1:numel(rownames))
    xticks(1:numel(columnnames))
    set(gca,'XTickLabel',columnnames,'fontsize',6,'XTickLabelRotation',90,'YTickLabel',rownames)    
    rdata=rval;
    for q=1:size(rdata,2)
        for z=1:size(rdata,1)
            text(q,z,num2str(round(rdata(z,q),1)),'HorizontalAlignment', 'Center','fontsize',4)
        end
    end
end
figdat=data;
sgtitle(get(gcf,'Name'));
end