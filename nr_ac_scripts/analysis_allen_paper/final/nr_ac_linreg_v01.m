function export=nr_ac_linreg_v01(datestr,subjectData,cmpdata,TOI,FOI_label,FOI_freq,phases,DOI,stimtypes,stimname,savefolder)
kinlabel={'movementDuration','reactionTime','handpathlength','avgVelocity','maxVelocity','velocityPeaks','timeToMaxVelocity','timeToMaxVelocity_n','avgAcceleration','maxAcceleration','accuracy','normalizedJerk','IOC'};

colors={'g','b','c','m'};


ax=[];
for f=1:numel(FOI_freq)
    figure; set(gcf,'Position',[2235 517 1304 732])
    count_ax=1;
    for t=1:numel(TOI)
        for p=1:numel(phases)
            ax(count_ax)=subplot(numel(TOI),numel(phases),p+(t-1)*numel(phases));
            count_ax=count_ax+1;
            hold on
            
            tempdat=[];
            tempdisease=[];
            tempstim=[];
            for s=1:size(subjectData,2)
                
                for d=1:numel(cmpdata)
                    if any(strcmp(cmpdata{d},'iCoh'))
                        tempcmp=cmpdata{d};
                        
                        % Calculate coherence
                        sbjicoh=subjectData(s).(tempcmp);
                        label_idx=all(strcmp(sbjicoh.label,'C3')+strcmp(sbjicoh.label,'C4'),2);
                        FOI_idx=sbjicoh.freq>=FOI_freq{f}{1} & sbjicoh.freq<=FOI_freq{f}{2};
                        TOI_idx=strcmp(subjectData(s).sessioninfo.trialnames,TOI{t});
                        tempdat(s,1)=mean(mean(sbjicoh.data(label_idx,FOI_idx,:,p,TOI_idx),2,'omitnan'),3,'omitnan');
                        axislabel{d}=[FOI_label{f},' - iCoh'];
                    elseif any(strcmp(cmpdata{d},kinlabel))
                        tempcmp=cmpdata{d};
                        
                        % Calculate kinematics
                        templabel=strcmp(subjectData(s).kinematics.label,tempcmp);
                        tempdat(s,2)=mean(subjectData(s).kinematics.data{templabel}(:,TOI_idx),'omitnan');
                        axislabel{d}=tempcmp;
                    end
                end
                
                % Organize disease
                tempdisease{s,1}=subjectData(s).sessioninfo.dx;
                
                % Organize stim
                tempstim(s,1)=subjectData(s).sessioninfo.stimamp;
            end
            
            clear l r pval
            count=1;
            legendlabels=[];
            countcolor=1;
            for d=1:numel(DOI)
                for s=1:numel(stimtypes)
                    idx=strcmp(tempdisease,DOI{d})&tempstim==stimtypes(s);
                    sbjs=extractAfter({subjectData(idx).SubjectName},'pro00087153_00');
                    
                    % organize data
                    hold on
                    xdat=tempdat(idx,1);
                    ydat=tempdat(idx,2);
                    
                    export.(FOI_label{f}).(phases{p}).(DOI{d}){t,s}=[xdat;ydat];
                    
                    
                    
                    
                    % Scatter plot
                    for i=1:numel(xdat)
                        txt=text(xdat(i),ydat(i),sbjs{i});
                        if stimtypes(s)==0
                            txt.Color=colors{countcolor};
                            linestyle='--';
                        else
                            txt.Color=colors{countcolor};
                            linestyle='-';
                        end
                    end
                    countcolor=countcolor+1;
                    
                    % Plot trendline
                    pv = polyfit(xdat, ydat, 1);
                    px = [min(xdat) max(xdat)];
                    py = polyval(pv, px);
                    l(count)=plot(px, py, 'LineWidth', 2,'Color',txt.Color,'LineStyle',linestyle);
                    
                    
                    % Calculate p and r
                    [r,pval]=corrcoef(xdat, ydat);
                    
                    % Save p and r value
                    rval=r(2,1);
                    pval=pval(2,1);
                    
                    % Change line if pval <=0.5
                    if pval<=0.05
                        if stimtypes(s)==0
                            l(count).Color=[0.8500 0.3250 0.0980];
                        else
                            l(count).Color=[0.6350 0.0780 0.1840];
                        end
                    end
                    
                    % Organize legend label
                    legendlabels{count}=sprintf('%s %s [p(%g),r(%g)]',DOI{d},stimname{s},pval,rval);
                    count=count+1;
                end
            end
            legend(l,legendlabels,'Location','best')
            ylabel(axislabel{2})
            xlabel(axislabel{1})
            title([TOI{t},'--',phases{p}]);
            sgtitle(FOI_label{f})
        end
    end
    linkaxes(ax)
    cd(['~/nr_data_analysis/data_analyzed/eeg/gen_03/analysis_icoh/',datestr])
    figname=['nr_icoh_linreg_',FOI_label{f},'_',axislabel{2},'_',datestr];
     %savefig(gcf,figname)
%    saveas(gcf,fullfile(savefolder,[axislabel{1},' vs ',axislabel{2},'.jpeg']))
end
end



