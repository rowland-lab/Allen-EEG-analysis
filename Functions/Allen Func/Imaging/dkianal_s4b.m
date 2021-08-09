function dkianal_s4b(dkifolder)
tractfolder=fullfile(dkifolder,'tracts');

 % Detect text outputs
textfiles={dir(fullfile(tractfolder,'*.txt')).name};

% Analyze ROIS
for roi=1:numel(textfiles)
    roiname=extractBetween(textfiles{roi},'fib.gz.','.stat');
    if isempty(roiname)
        continue
    else
        temptextfile=importdata(textfiles{roi});
        ROI.(roiname{:}).stats(:,1)=cellfun(@(x) extractBefore(x,'	'),temptextfile,'UniformOutput',false);
        ROI.(roiname{:}).stats(:,2)=cellfun(@(x) extractAfter(x,'	'),temptextfile,'UniformOutput',false);
    end
end

% Ratio (R/L)
ratio(:,1)=ROI.Corticospinal_Tract_L.stats(:,1);
ratio(:,2)=num2cell(cellfun(@(x) str2num(x),ROI.Corticospinal_Tract_R.stats(:,2))./cellfun(@(x) str2num(x),ROI.Corticospinal_Tract_L.stats(:,2)));

% Horizontal Bar graph
figure
bhdat=cellfun(@(x) x-1,ratio(:,2));
hold on
barh(find(bhdat>0),bhdat(bhdat>0),'red');
barh(find(bhdat<0),bhdat(bhdat<0),'green');
xlim([-0.5 0.5])
yticks([1:1:numel(bhdat)]);
yticklabels(ratio(:,1))
title('Right/Left Ratio')
grid on
ax=gca;
ax.XGrid='off';
ax.TickLabelInterpreter='none';
saveas(gcf,fullfile(tractfolder,'CST stats ratio'))

end