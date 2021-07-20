function pvalues=paired_sigtest(currentfig,data,data_bar,error_length,bar_loc)
% Test for normality
normality=kstest([data{:}]);

% Sig text location
max_data=max([zeros(1,size(data_bar,2)); data_bar ;data_bar+error_length],[],'all');    


% Prep Data for stat test
nansize=max(cellfun(@(x) numel(x),data),[],'all');
beta_bar_stat=nan(nansize,size(data,2));
for z=1:size(data,2)
    beta_bar_stat(1:length(data{z}),z)=data{z};
end

beta_bar_stat(any(isnan(beta_bar_stat),2),:)=[];

% Test for Normality
if normality ==0
    [~,~,stats]=ranova(beta_bar_stat,[],'off');
    pvalues=multcompare(stats,'Display','off');
    test='ran';
else
    [~,~,stats]=friedman(beta_bar_stat,size(beta_bar_stat,2),'off'); 
    pvalues=multcompare(stats,'Display','off');
    test='fr';
end

% Find 0.05 significance
last_max=[];
if any(le(pvalues(:,6),0.05))
   idx=find(le(pvalues(:,6),0.05));
   spacer=diff(get(currentfig,'YLim'))*0.05;
   for m=1:numel(idx)
       l=line(currentfig,[bar_loc(pvalues(idx(m),1)) bar_loc(pvalues(idx(m),2))],[1 1]*max_data+m*spacer);
       set(l,'linewidth',2)
       t=text(currentfig,mean([bar_loc(pvalues(idx(m),1)) bar_loc(pvalues(idx(m),2))]),max_data+(m+.5)*spacer,[test,string(pvalues(idx(m),6))],'HorizontalAlignment','center');
   end
   last_max=t.Position(2);
end

% Find 0.10 trending
if any(le(pvalues(:,6),0.10)&ge(pvalues(:,6),0.05))
   idx=find(le(pvalues(:,6),0.10)&ge(pvalues(:,6),0.05));
   if isempty(last_max)
       spacer=diff(get(currentfig,'YLim'))*0.05;
   else
       max_data=last_max;
   end
   for m=1:numel(idx)
       l=line(currentfig,[bar_loc(pvalues(idx(m),1)) bar_loc(pvalues(idx(m),2))],[1 1]*max_data+m*spacer);
       set(l,'linewidth',2)
       t=text(currentfig,mean([bar_loc(pvalues(idx(m),1)) bar_loc(pvalues(idx(m),2))]),max_data+(m+.5)*spacer,[test,string(pvalues(idx(m),6))],'HorizontalAlignment','center');
       set(l,'Color','r')
   end
end

end