function icoh_data_anal=nr_ac_columnscatter_v01(datestr,subjectData,datlabel,TOI,FOI_label,FOI_freq,phases,DOI,stimtypes,stimname,savefigures)

count_ax=1;
ax=[];
for f=1:numel(FOI_freq)
    figname=['nr_icoh_col_scat_',FOI_label{f},'_',datestr];
    %figure('Name',figname,'WindowState','Maximized')
    figure('Name',figname)
    set(gcf,'Position',[174 182 1062 883])
    for t=1:numel(TOI)
        for p=1:numel(phases)
            ax(count_ax)=subplot(numel(TOI),numel(phases),p+(t-1)*numel(phases));
            count_ax=count_ax+1;
            hold on
            
            tempdat=[];
            tempdisease=[];
            tempstim=[];
            tempacc=[];
            for s=1:size(subjectData,2)
                
                if strcmp(datlabel,'iCoh')
                    % Calculate coherence
                    sbjicoh=subjectData(s).(datlabel);
                    label_idx=all(strcmp(sbjicoh.label,'C3')+strcmp(sbjicoh.label,'C4'),2);
                    FOI_idx=sbjicoh.freq>=FOI_freq{f}{1} & sbjicoh.freq<=FOI_freq{f}{2};
                    TOI_idx=strcmp(subjectData(s).sessioninfo.trialnames,TOI{t});
                    tempdat(s,1)=mean(mean(sbjicoh.data(label_idx,FOI_idx,:,p,TOI_idx),2,'omitnan'),3,'omitnan');
                end
                
                
                % Organize disease
                tempdisease{s,1}=subjectData(s).sessioninfo.dx;
                
                % Organize stim
                tempstim(s,1)=subjectData(s).sessioninfo.stimamp;
            end
            
            clear l r pval
            count=1;
            axislabel=[];
            kwdat=nan(10,numel(DOI)*numel(stimtypes));
            sbj_name=cell(10,numel(DOI)*numel(stimtypes));
            sbjcount=1;
            for d=1:numel(DOI)
                for s=1:numel(stimtypes)
                    idx=strcmp(tempdisease,DOI{d})&tempstim==stimtypes(s);
                    
                    % organize data
                    hold on
                    ydat=tempdat(idx);
                    sbjs=extractAfter({subjectData(idx).SubjectName},'pro00087153_00');
                    sbj_name(1:numel(sbjs),sbjcount)=sbjs;
                    sbjcount=sbjcount+1;
                    
                    % Column Scatter plot
                    xshift=-.2;
                    for i=1:numel(sbjs)
                        xshift=xshift+0.05;
                        text((s+(d-1)*numel(stimtypes))+xshift,ydat(i),sbjs{i});
                    end
                    line([(s+(d-1)*numel(stimtypes))-0.1 (s+(d-1)*numel(stimtypes))+0.1],[mean(ydat) mean(ydat)],'LineWidth',2)
                    errorbar(s+(d-1)*numel(stimtypes),mean(ydat),std(ydat)/sqrt(numel(ydat)),'LineStyle','none','Color','k')
                    
                    % Group axis labels
                    axislabel=[axislabel {sprintf('%s - %s',DOI{d},stimname{s})}];
                    
                    % Group data for KW test
                    kwdat(1:numel(ydat),s+(d-1)*numel(stimtypes))=ydat;
                end
            end
            xticks([1:4])
            xticklabels(axislabel)
            ylim([0 1])
            ylabel([FOI_label{f},' iCoh'])
            
            title([TOI{t},'--',phases{p}]);
            
            % KW test
            kwdat(all(isnan(kwdat),2),:)=[];
            [pval,~,stat]=kruskalwallis(kwdat,[],'off');
            if pval<=0.05
                c = multcompare(stat,'Display','off');
                sigIdx=find(c(:,6)<=0.05& c(:,6)>0);
                maxy=max(kwdat,[],'all');
                for si=1:numel(sigIdx)
                    maxy=maxy+0.05;
                    line([c(sigIdx(si),1) c(sigIdx(si),2)],[maxy maxy])
                    text(mean([c(sigIdx(si),1) c(sigIdx(si),2)]),maxy,num2str(c(sigIdx(si),6)),'HorizontalAlignment','center')
                end
            end
            
            % Export data
            icoh_data_anal.(FOI_label{f}).(phases{p}).data{t,1}=kwdat;
            icoh_data_anal.(FOI_label{f}).(phases{p}).columnLabel=axislabel;
            icoh_data_anal.(FOI_label{f}).(phases{p}).SubjectNames=sbj_name(any(~cellfun(@isempty,(sbj_name)),2),:);
            %here you can export p-values
        end
    end
    linkaxes(ax)
    sgtitle(FOI_label{f})
    
    % Save figure
    if savefigures
        figname=['nr_icoh_col_scat_',FOI_label{f},'_',datestr];
        cd(['~/nr_data_analysis/data_analyzed/eeg/gen_03/analysis_icoh/',datestr])
        savefig(gcf,figname)
    end

    close all
    
end
%end
