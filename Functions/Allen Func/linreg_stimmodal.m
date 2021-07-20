function output=linreg_stimmodal(input)

data=input.dat;
info=input.info;

for trials=1:size(data,3)
    tempdata=data(:,:,trials);
    tempinfo=info(:,:,trials);
    stimside=[tempinfo{1,1}.stimamp]';
    anodidx=stimside==2;
    shamidx=stimside==0;
    
    anodal.dat(:,:,trials)=cellfun(@(x) x(anodidx,:),tempdata,'UniformOutput',false);
    [r,p]=cellfun(@corrcoef,anodal.dat(:,:,trials),'UniformOutput',false);
    if numel(r{1,1})>1
        anodal.rval(:,:,trials)=cellfun(@(x) x(1,2),r);
        anodal.pval(:,:,trials)=cellfun(@(x) x(1,2),p);
    else
        anodal.rval(:,:,trials)=nan(size(r,1),size(r,2));
        anodal.pval(:,:,trials)=nan(size(r,1),size(r,2));
    end
    temp=anodal.pval(:,:,trials);
    pvalidx=find(~isnan(temp));
    [~, ~, ~, adj_p]=fdr_bh(temp(pvalidx));
    temp(pvalidx)=adj_p;
    anodal.fdrval(:,:,trials)=temp;
    
    
    sham.dat(:,:,trials)=cellfun(@(x) x(shamidx,:),tempdata,'UniformOutput',false);
    [r,p]=cellfun(@corrcoef,sham.dat(:,:,trials),'UniformOutput',false);
    if numel(r{1,1})>1
        sham.rval(:,:,trials)=cellfun(@(x) x(1,2),r);
        sham.pval(:,:,trials)=cellfun(@(x) x(1,2),p);
    else
        sham.rval(:,:,trials)=nan(size(r,1),size(r,2));
        sham.pval(:,:,trials)=nan(size(r,1),size(r,2));
    end
    temp=sham.pval(:,:,trials);
    pvalidx=find(~isnan(temp));
    [~, ~, ~, adj_p]=fdr_bh(temp(pvalidx));
    temp(pvalidx)=adj_p;
    sham.fdrval(:,:,trials)=temp;
    
    anodal.info(:,:,trials)=cellfun(@(x) x(anodidx),tempinfo,'UniformOutput',false);
    sham.info(:,:,trials)=cellfun(@(x) x(shamidx),tempinfo,'UniformOutput',false);
end
anodal.nval=cellfun(@(x) size(x,1),anodal.dat);
sham.nval=cellfun(@(x) size(x,1),sham.dat);

output.anodal=anodal;
output.sham=sham;
end
    