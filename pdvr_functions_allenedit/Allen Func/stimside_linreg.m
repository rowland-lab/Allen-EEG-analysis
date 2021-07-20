function [output]=stimside_linreg(com_struct,raw_struct,trialnames,updrsnames_com,updrsnames)
    for trials=1:numel(trialnames)
        tempdata_com=com_struct.dat(:,:,trials);
        tempdata_raw=raw_struct.dat(:,:,trials);
        tempinfo=com_struct.info(:,:,trials);

        rlinfo=cellfun(@(x) {x.stimlat}',tempinfo,'UniformOutput',false);
        rlidx=find(~cellfun(@isempty,regexp(updrsnames_com,'.*RL.*')));

        for updrs=1:size(tempdata_raw,2)
            if any(updrs==rlidx)
                updrsscore=nan(length(rlinfo{updrs}),1);
                for i=1:length(rlinfo{updrs})
                    if rlinfo{updrs}{i}=='R'
                        idx=find(contains(updrsnames,[extractBefore(updrsnames_com{updrs},'RL'),'right']));
                        updrsscore(i,1)=tempdata_raw{idx,1}(i,1);
                    else
                        idx=find(contains(updrsnames,[extractBefore(updrsnames_com{updrs},'RL'),'left']));
                        updrsscore(i,1)=tempdata_raw{idx,1}(i,1);
                    end
                end
                for q=1:size(tempdata_com,2)
                    tempdata_com{updrs,q}(:,1)=updrsscore;
                end          
            else
                continue
            end
        end
        output.dat(:,:,trials)=tempdata_com;
        [r,p]=cellfun(@corrcoef,output.dat(:,:,trials),'UniformOutput',false);

        if numel(r)>1
            output.rval(:,:,trials)=cellfun(@(x) x(1,2),r);
            output.pval(:,:,trials)=cellfun(@(x) x(1,2),p);
        else
            output.rval(:,:,trials)=nan(size(r,1),size(r,2));
            output.pval(:,:,trials)=nan(size(r,1),size(r,2));
        end
        
        temp=output.pval(:,:,trials);
        pvalidx=find(~isnan(temp));
        [~, ~, ~, adj_p]=fdr_bh(temp(pvalidx));
        temp(pvalidx)=adj_p;
        output.fdrval(:,:,trials)=temp;
    end
    output.info=com_struct.info;
    output.nval=com_struct.nval;    
end
