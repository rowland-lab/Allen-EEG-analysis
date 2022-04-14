function export=linreg2(subjectData,cmpdata,TOI,FOI_label,FOI_freq,phases,DOI,stimtypes,stimname,savefolder)
kinlabel={'movementDuration','reactionTime','handpathlength','avgVelocity','maxVelocity','velocityPeaks','timeToMaxVelocity','timeToMaxVelocity_n','avgAcceleration','maxAcceleration','accuracy','normalizedJerk','IOC'};

colors={'g','b','c','m'};

%cmpdata={'iCoh','IOC'}
%linreg_dat=linreg2(subjectData,{'iCoh','IOC'},TOI,FOI_label,FOI_freq,phases,DOI,stimtypes,stimname,linReg_folder);




ax=[];
for f=2%1:numel(FOI_freq)
    figure; set(gcf,'Position',[2380 99 1224 827])
    %('WindowState','Maximized')
    subplot_count=1;
    count_ax=1;
    for t=1:numel(TOI)
        for p=1:numel(phases)-1
            h(count_ax)=subplot(numel(TOI),(numel(phases)-1),subplot_count);
            subplot_count=subplot_count+1;
            count_ax=count_ax+1;
            %ax(count_ax)=subplot(numel(TOI),numel(phases),p+(t-1)*numel(phases));
            %count_ax=count_ax+1;
            hold on
            
            tempdat=[];
            tempdat1=[];
            tempdat2=[];
            tempdisease=[];
            tempstim=[];
            for s=1:size(subjectData,2)
                
                for d=1:numel(cmpdata)
                    if any(strcmp(cmpdata{d},'iCoh'))
                        tempcmp=cmpdata{d};
                        
                        % Calculate coherence1
                        sbjicoh=subjectData(s).(tempcmp);
                        label_idx=all(strcmp(sbjicoh.label,'C3')+strcmp(sbjicoh.label,'C4'),2);
                        FOI_idx=sbjicoh.freq>=FOI_freq{f}{1} & sbjicoh.freq<=FOI_freq{f}{2};
                        TOI_idx=strcmp(subjectData(s).sessioninfo.trialnames,TOI{t});
                        tempdat1(s,1)=mean(mean(sbjicoh.data(label_idx,FOI_idx,:,p,TOI_idx),2,'omitnan'),3,'omitnan');
                        axislabel{d}=[FOI_label{f},' - iCoh'];
                        
                        % Calculate coherence2
                        sbjicoh=subjectData(s).(tempcmp);
                        label_idx=all(strcmp(sbjicoh.label,'C3')+strcmp(sbjicoh.label,'C4'),2);
                        FOI_idx=sbjicoh.freq>=FOI_freq{f}{1} & sbjicoh.freq<=FOI_freq{f}{2};
                        TOI_idx=strcmp(subjectData(s).sessioninfo.trialnames,TOI{t});
                        tempdat2(s,1)=mean(mean(sbjicoh.data(label_idx,FOI_idx,:,p+1,TOI_idx),2,'omitnan'),3,'omitnan');
                        axislabel{d}=[FOI_label{f},' - iCoh'];
                        
%                         %Find diff
%                         tempdat(s,1)=(tempdat2-tempdat1)./tempdat1*100;
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
            %Find diff
                tempdat(:,1)=(tempdat2-tempdat1)./tempdat1*100;
            
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
            %title([TOI{t},'--',phases{p}]);
            title([TOI{t},'--',phases{p},' - ',phases{p+1}])
            
%                 bar(mean(plotdat,1))
%                 
%                 subtitle(TOI{t})
%                 xticklabels({'Sham','Stim'})
        end
    end
%     linkaxes(ax)
%     savefig(gcf,fullfile(savefolder,[axislabel{1},' vs ',axislabel{2}]))
%     saveas(gcf,fullfile(savefolder,[axislabel{1},' vs ',axislabel{2},'.jpeg']))
end
end
