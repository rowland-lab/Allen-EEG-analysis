function [error]=err_bar(currentbar,bardata,barmean)

error_bar_location=[];
for i = 1:size(bardata,2)
    error_bar_location = [error_bar_location ; currentbar(i).XEndPoints];
end

err=cellfun(@(x) std(x,'omitnan')/sqrt(sum(~isnan(x))),bardata);
errorbar(error_bar_location',barmean,err,'k', 'linestyle', 'none');

error.data= err;
error.location= error_bar_location;
end