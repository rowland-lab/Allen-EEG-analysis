datapath='C:\Users\allen\Box Sync\Desktop\Allen_Rowland_EEG\protocol_00087153';
addpath(genpath(datapath));

% save folder
savefolder='C:\Users\allen\Downloads\Rowland_fig';
mkdir(savefolder)

% Detect subjects
pro_sbj={dir(fullfile(datapath,'pro00*')).name}';

% Stroke subjects
stroke_sbjs=[17,13,05,03,04,43,21,42,18,15]';
stroke_idx=find(cellfun(@(x) any(str2double(extractAfter(x,'pro00087153_00'))==stroke_sbjs),pro_sbj));

events={'atStartPosition','cueEvent','targetUp'};
ax=[];
for s=1:numel(stroke_idx)
    figure('WindowState','maximized')
    sgtitle(pro_sbj{stroke_idx(s)},'Interpreter','none')
    cn7beta=repmat({nan(12,9)},3,4);
    cn18beta=repmat({nan(12,9)},3,4);
    imp=load(fullfile(datapath,pro_sbj{stroke_idx(s)},'analysis','S3-EEGanalysis','s3_dat.mat'));
    trialdat=imp.epochs.vrevents;
    for type=1:4
        for trial=1:5
            if type~=4
                if trial~=5
                    psd=trialdat.(sprintf('t%u',trial)).(events{type}).psd;
            
                    freqidx=psd.freq<100;
                    betaidx=psd.freq>=13&psd.freq<=30;
                    
                    % Plot cn 7
                    subplot(8,5,trial+5*(type-1))
                    tempdat=permute(psd.saw(:,7,:),[3 1 2]);
                    plot(psd.freq(freqidx),log10(tempdat(:,freqidx)))
                    if trial==1&&type==1
                        title(sprintf('t%u: CHANNEL 7',trial))
                    else
                        title(sprintf('t%u',trial))
                    end
                    if trial==1
                        ylabel(events{type})
                    end
                    tempdat_beta=tempdat(:,betaidx);
                    sz=size(tempdat_beta);
                    cn7beta{type,trial}(1:sz(1),1:sz(2))=tempdat_beta;
                    ylim([-2 4])

                    % Plot cn 18
                    subplot(8,5,trial+20+5*(type-1))
                    tempdat=permute(psd.saw(:,18,:),[3 1 2]);
                    plot(psd.freq(freqidx),log10(tempdat(:,freqidx)))
                    if trial==1&&type==1
                        title(sprintf('t%u: CHANNEL 18',trial))
                    else
                        title(sprintf('t%u',trial))
                    end
                    if trial==1
                        ylabel(events{type})
                    end
                    tempdat_beta=tempdat(:,betaidx);
                    sz=size(tempdat_beta);
                    cn18beta{type,trial}(1:sz(1),1:sz(2))=tempdat_beta;
                    ylim([-2 4])
                else
                    % Plot cn 7 bar
                    tempax=subplot(8,5,trial+5*(type-1));
                    ax=[ax tempax];
                    tempdat=cn7beta(type,:);
                    tempdat=cellfun(@(x) log10(x),tempdat,'UniformOutput',false);
                    bardat=cellfun(@(x) mean(x,'all','omitnan'),tempdat);
                    err=cellfun(@(x) std(mean(x,2,'omitnan'))/sqrt(size(x,1)),tempdat);
                    hold on
                    bar(bardat)
                    errorbar([1:4],bardat,err,'LineStyle','none')
                    xlabel('trials')
                    
                    kwdat=cellfun(@(x) mean(x,2,'omitnan'),tempdat,'UniformOutput',false);
                    [p,tbl,stats] = kruskalwallis(cell2mat(kwdat),[],'off');
                    if p<0.05
                        title(num2str(p),'color','r')
                    else
                        title(num2str(p))
                    end

                    % Plot cn 18 bar
                    tempax=subplot(8,5,trial+20+5*(type-1));
                    ax=[ax tempax];
                    tempdat=cn18beta(type,:);
                    tempdat=cellfun(@(x) log10(x),tempdat,'UniformOutput',false);
                    bardat=cellfun(@(x) mean(x,'all','omitnan'),tempdat);
                    err=cellfun(@(x) std(mean(x,2,'omitnan'))/sqrt(size(x,1)),tempdat);
                    hold on
                    bar(bardat)
                    errorbar([1:4],bardat,err,'LineStyle','none')
                    title('Average beta')
                    xlabel('trials')
                    
                    kwdat=cellfun(@(x) mean(x,2,'omitnan'),tempdat,'UniformOutput',false);
                    [p,tbl,stats] = kruskalwallis(cell2mat(kwdat),[],'off');
                    if p<0.05
                        title(num2str(p),'color','r')
                    else
                        title(num2str(p))
                    end
                end
            else
                try
                    % Plot cn 7 bar
                    tempax=subplot(8,5,trial+5*(type-1));
                    ax=[ax tempax];
                    tempdat=cn7beta(:,trial)';
                    tempdat=cellfun(@(x) log10(x),tempdat,'UniformOutput',false);
                    bardat=cellfun(@(x) mean(x,'all','omitnan'),tempdat);
                    err=cellfun(@(x) std(mean(x,2,'omitnan'))/sqrt(size(x,1)),tempdat);
                    hold on
                    bar(bardat)
                    errorbar([1:3],bardat,err,'LineStyle','none')
                    xticks(1:3)
                    xticklabels({'h','p','m'})
                    
                    kwdat=cellfun(@(x) mean(x,2,'omitnan'),tempdat,'UniformOutput',false);
                    [p,tbl,stats] = kruskalwallis(cell2mat(kwdat),[],'off');
                    if p<0.05
                        title(num2str(p),'color','r')
                    else
                        title(num2str(p))
                    end

                    % Plot cn 18 bar
                    tempax=subplot(8,5,trial+20+5*(type-1));
                    ax=[ax tempax];
                    tempdat=cn18beta(:,trial)';
                    tempdat=cellfun(@(x) log10(x),tempdat,'UniformOutput',false);
                    bardat=cellfun(@(x) mean(x,'all','omitnan'),tempdat);
                    err=cellfun(@(x) std(mean(x,2,'omitnan'))/sqrt(size(x,1)),tempdat);
                    hold on
                    bar(bardat)
                    errorbar([1:3],bardat,err,'LineStyle','none')
                    xticks(1:3)
                    xticklabels({'h','p','m'})
                    
                    kwdat=cellfun(@(x) mean(x,2,'omitnan'),tempdat,'UniformOutput',false);
                    [p,tbl,stats] = kruskalwallis(cell2mat(kwdat),[],'off');
                    if p<0.05
                        title(num2str(p),'color','r')
                    else
                        title(num2str(p))
                    end
                catch
                    continue
                end
            end
        end
    end
    linkaxes(ax)
    savefig(gcf,fullfile(savefolder,pro_sbj{stroke_idx(s)}))
    close all
end