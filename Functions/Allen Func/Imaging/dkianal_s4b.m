function dkianal_s4b(dkifolder)
statsfolder=fullfile(dkifolder,'stat');

 % Detect text outputs
textfiles={dir(fullfile(statsfolder,'*.txt')).name};

% Analyze ROIS
for roi=1:numel(textfiles)
    roiname=extractBefore(textfiles{roi},'.tt');
    temptextfile=importdata(textfiles{roi});
    ROI.(roiname).stats(:,1)=cellfun(@(x) extractBefore(x,'	'),temptextfile,'UniformOutput',false);
    ROI.(roiname).stats(:,2)=cellfun(@(x) extractAfter(x,'	'),temptextfile,'UniformOutput',false);    
end

% Ratio (L/R)
ratio(:,1)=ROI.CST_L.stats(:,1);
ratio(:,2)=num2cell(cellfun(@(x) str2num(x),ROI.CST_R.stats(:,2))./cellfun(@(x) str2num(x),ROI.CST_L.stats(:,2)));

% Horizontal Bar graph
bhdat=cellfun(@(x) x-1,ratio(:,2));
hold on
barh(find(bhdat>0),bhdat(bhdat>0),'red');
barh(find(bhdat<0),bhdat(bhdat<0),'green');
xlim([-0.25 0.25])
yticks([1:1:numel(bhdat)]);
yticklabels(ratio(:,1))
title('Left/Right Ratio')
grid on
ax=gca;
ax.XGrid='off';
saveas(gcf,fullfile(statsfolder,'CST stats ratio'))

end