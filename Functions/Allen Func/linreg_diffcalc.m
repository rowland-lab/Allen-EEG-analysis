
function output=linreg_diffcalc(input)

data=input.dat;
info=input.info;

for i=2:size(data,3)
    tempdata=data(:,:,i);
    baselinedat=data(:,:,1);
    tempinfo=info(:,:,i);
    baselineinfo=info(:,:,1);
    
    baseline_subjnum=cellfun(@(x) extractAfter(x,'_00'),{baselineinfo{1,1}.patientID}','UniformOutput',false);    
    temp_subjnum=cellfun(@(x) extractAfter(x,'_00'),{tempinfo{1,1}.patientID}','UniformOutput',false);    
    
    tempoutput=cell(size(tempdata,1),size(tempdata,2));
    for r=1:size(tempdata,1)
        for c=1:size(tempdata,2)
            for num=1:size(tempdata{1,1},1)
                compidx=strcmp(temp_subjnum{num},baseline_subjnum);
                tempoutput{r,c}(num,1)=tempdata{r,c}(num,1);
                tempoutput{r,c}(num,2)=(tempdata{r,c}(num,2)-baselinedat{r,c}(compidx,2))./tempdata{r,c}(num,2)*100;
            end
        end
    end
    
    output.dat(:,:,i-1)=tempoutput;
    
    % Calculate n
    output.nval(:,:,i-1)=cellfun(@(x) size(x,1),tempoutput);    

    % Calculate p and r
    [r,p]=cellfun(@corrcoef,output.dat(:,:,i-1),'UniformOutput',false);

    if numel(r{1,1})>1
        output.rval(:,:,i-1)=cellfun(@(x) x(1,2),r);
        output.pval(:,:,i-1)=cellfun(@(x) x(1,2),p);
    else
        output.rval(:,:,i-1)=nan(size(r,1),size(r,2));
        output.pval(:,:,i-1)=nan(size(r,1),size(r,2));
    end
    
    temp=output.pval(:,:,i-1);
    pvalidx=find(~isnan(temp));
    [~, ~, ~, adj_p]=fdr_bh(temp(pvalidx));
    temp(pvalidx)=adj_p;
    output.fdrval(:,:,i-1)=temp;
end
output.info=info(:,:,2:end);
end