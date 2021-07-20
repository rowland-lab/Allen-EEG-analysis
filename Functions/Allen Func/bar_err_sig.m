% inputdata= n groups x 1 cells with each cell signifying different group 
% dim= which dimension data will be averaged

function bar_err_sig(inputdata,axesHandle,dim)

%% Bar
% Find bar average
inputdata_average=cell2mat(cellfun(@(x) mean(x,dim,'omitnan'),inputdata,'UniformOutput',false))';

% Plot bar
currentbar=bar(axesHandle,inputdata_average);

% Find bar locations
bar_location=[];
for i = 1:size(currentbar,2)
    bar_location = [bar_location; currentbar(i).XEndPoints];
end

%% Error
% Find error
err=[];
for i=1:numel(inputdata)
    temp=inputdata{i};
    for q=1:size(temp,2)
        tempcol=temp(:,q);
        err(i,q)=std(tempcol,'omitnan')/sqrt(sum(~isnan(tempcol)));
    end
end


% Plot Error
err_bar=errorbar(bar_location,inputdata_average',err,'k', 'linestyle', 'none');


%% Significance

% Make sure not all NaN data
if ~any(cell2mat(inputdata),'all')
    disp('Contains all NaN')
    return    
end

% Test for normality
normality=kstest(cell2mat(inputdata));

% Sig text location
max_data=max([zeros(size(err,1)) inputdata_average'+err],[],'all');    

% Prep Data for stat test
data_stat=cell2mat(inputdata);
bar_loc=reshape(bar_location',[],1);

% Check to see if enough samples
if sum(~isnan(data_stat),'all')<=2
    disp('not enough data')
    return
end

% Check to see missing time point
missing=find(sum(~isnan(data_stat),1)==0);

% Test for Normality
if normality==0
    [~,~,stats]=anova1(data_stat,[],'off');
    pvalues=multcompare(stats,'Display','off');
    test='an';
else
    [~,~,stats]=kruskalwallis(data_stat,[],'off');
    pvalues=multcompare(stats,'Display','off');
    test='kw';
end


% Find 0.05 significance
last_max=[];
if any(le(pvalues(:,6),0.05))
   idx=find(le(pvalues(:,6),0.05));
   spacer=diff(get(axesHandle,'YLim'))*0.05;
   for m=1:numel(idx)
       lstart=bar_loc(pvalues(idx(m),1));
       lend=bar_loc(pvalues(idx(m),2));
       if lstart>missing
          delay=sum(lstart>missing);
          lstart=lstart+delay;
       end
       if lend>missing
          delay=sum(lend>missing);
          lend=lend+delay;
       end
       l=line(axesHandle,[lstart lend],[1 1]*max_data+m*spacer);
       set(l,'linewidth',2)
       t=text(axesHandle,mean([lstart lend]),max_data+(m+.5)*spacer,[test,string(pvalues(idx(m),6))],'HorizontalAlignment','center');
   end
   last_max=t.Position(2);
end

% Find 0.10 trending
if any(le(pvalues(:,6),0.10)&ge(pvalues(:,6),0.05))
   idx=find(le(pvalues(:,6),0.10)&ge(pvalues(:,6),0.05));
   if isempty(last_max)
       spacer=diff(get(axesHandle,'YLim'))*0.05;
   else
       max_data=last_max;
   end
   for m=1:numel(idx)
       lstart=bar_loc(pvalues(idx(m),1));
       lend=bar_loc(pvalues(idx(m),2));
       if any(lstart>missing)
          delay=sum(lstart>missing);
          lstart=lstart+delay;
       end
       if any(lend>=missing)
          delay=sum(lend>=missing);
          lend=lend+delay;
       end
       l=line(axesHandle,[lstart lend],[1 1]*max_data+m*spacer);
       set(l,'linewidth',2)
       t=text(axesHandle,mean([lstart lend]),max_data+(m+.5)*spacer,[test,string(pvalues(idx(m),6))],'HorizontalAlignment','center');
       set(l,'Color','r')
   end
end

if any(le(pvalues(:,6),0.10))==false
   text(axesHandle,mean(axesHandle.XLim),max_data,[test,' N.S'],'HorizontalAlignment','center');
end

end


