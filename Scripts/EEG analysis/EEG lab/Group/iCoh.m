clear

% Enter gitpath
gitpath='C:\Users\allen\Documents\GitHub\Allen-EEG-analysis';
cd(gitpath)

% Enter in protocol folder
protocolfolder='C:\Users\allen\Box Sync\Desktop\Allen_Rowland_EEG\protocol_00087153';

% Add EEG related paths
allengit_genpaths(gitpath,'EEG')

% Detect subjects
sbj=dir(fullfile(protocolfolder,'pro000*.'));
sbj={sbj.name}';
%% 

subject1='pro00087153_0003';
subject2='pro00087153_0005';

sbj1_coh=load('C:\Users\allen\Box Sync\Desktop\Allen_Rowland_EEG\protocol_00087153\pro00087153_0003\analysis\EEGlab\EEGlab_ftimagcoh.mat');
sbj2_coh=load('C:\Users\allen\Box Sync\Desktop\Allen_Rowland_EEG\protocol_00087153\pro00087153_0005\analysis\EEGlab\EEGlab_ftimagcoh.mat');

freqband{1}=sbj1_coh.eegepochs.t1(1).ft_iCoh.freq>=10 & sbj1_coh.eegepochs.t1(1).ft_iCoh.freq<=13;
freqband{2}=sbj1_coh.eegepochs.t1(1).ft_iCoh.freq>=13 & sbj1_coh.eegepochs.t1(1).ft_iCoh.freq<=30;
freqband{3}=sbj1_coh.eegepochs.t1(1).ft_iCoh.freq>=30 & sbj1_coh.eegepochs.t1(1).ft_iCoh.freq<=70;
freqband{4}=sbj1_coh.eegepochs.t1(1).ft_iCoh.freq>=70;

freqband_label{1}='Alpha';
freqband_label{2}='Beta';
freqband_label{3}='Gamma-L';
freqband_label{4}='Gamma-B';


trials={'t1','t2','t3','t4'};

c3c4idx=116;
%% Calculated iCoh
phase={'hold','prep','move'};
for fb=1:numel(freqband)
    figure
    sgtitle([freqband_label{fb},' iCoh (C3-C4)'])
    for ph=1:numel(phase)
        ax(ph+(ph-1))=subplot(3,2,ph+(ph-1));
        hold on
        coh=NaN(12,numel(trials));
        for t=1:numel(trials)
            tempcoh=reshape(mean(sbj1_coh.eegepochs.(trials{t})(ph).ft_iCoh.cohspctrm(c3c4idx,freqband{fb},:),2),[],1);
            coh(1:numel(tempcoh),t)=tempcoh;
        end
        b=bar(mean(coh,1,'omitnan'));
        sem=std(coh,[],1,'omitnan')./sum(~isnan(coh),1);
        errorbar(b.YData,sem,'LineStyle','none')
        title(subject1)
        xlabel('trials')
        xticklabels(trials)
        xticks(1:4)
        ylabel(phase{ph});
        testKW(coh,trials,ax(ph+(ph-1)))
        
        
        
        ax(ph+1+(ph-1))=subplot(3,2,ph+1+(ph-1));
        hold on
        coh=NaN(12,numel(trials));
        for t=1:numel(trials)
            tempcoh=reshape(mean(sbj2_coh.eegepochs.(trials{t})(ph).ft_iCoh.cohspctrm(c3c4idx,freqband{fb},:),2),[],1);
            coh(1:numel(tempcoh),t)=tempcoh;
        end
        b=bar(mean(coh,1,'omitnan'));
        sem=std(coh,[],1,'omitnan')./sum(~isnan(coh),1);
        errorbar(b.YData,sem,'LineStyle','none')
        title(subject2)
        xlabel('trials')
        xticklabels(trials)
        xticks(1:4)
        ylabel(phase{ph});
        testKW(coh,trials,ax(ph+(ph-1)))
    end
    linkaxes(ax)
end
%% Calculated Granger Causality
phase={'hold','prep','move'};
for fb=1:numel(freqband)
    figure
    sgtitle([freqband_label{fb},' iCoh (C3-C4)'])
    for ph=1:numel(phase)
        ax(ph+(ph-1))=subplot(3,2,ph+(ph-1));
        hold on
        coh=NaN(12,numel(trials));
        for t=1:numel(trials)
            tempcoh=reshape(mean(sbj1_coh.eegepochs.(trials{t})(ph).ft_iCoh.cohspctrm(c3c4idx,freqband{fb},:),2),[],1);
            coh(1:numel(tempcoh),t)=tempcoh;
        end
        b=bar(mean(coh,1,'omitnan'));
        sem=std(coh,[],1,'omitnan')./sum(~isnan(coh),1);
        errorbar(b.YData,sem,'LineStyle','none')
        title(subject1)
        xlabel('trials')
        xticklabels(trials)
        xticks(1:4)
        ylabel(phase{ph});
        testKW(coh,trials,ax(ph+(ph-1)))
        
        
        
        ax(ph+1+(ph-1))=subplot(3,2,ph+1+(ph-1));
        hold on
        coh=NaN(12,numel(trials));
        for t=1:numel(trials)
            tempcoh=reshape(mean(sbj2_coh.eegepochs.(trials{t})(ph).ft_iCoh.cohspctrm(c3c4idx,freqband{fb},:),2),[],1);
            coh(1:numel(tempcoh),t)=tempcoh;
        end
        b=bar(mean(coh,1,'omitnan'));
        sem=std(coh,[],1,'omitnan')./sum(~isnan(coh),1);
        errorbar(b.YData,sem,'LineStyle','none')
        title(subject2)
        xlabel('trials')
        xticklabels(trials)
        xticks(1:4)
        ylabel(phase{ph});
        testKW(coh,trials,ax(ph+(ph-1)))
    end
    linkaxes(ax)
end

%%
function testKW(input,trials,ax)

[p,tbl,stats] = kruskalwallis(input,trials,'off');

if p<=0.05
    m=max(ax.Children(2).YData);
    [c,~]=multcompare(stats,'Display','off');
    sigidx=find(c(:,6)<=0.05);
    if any(sigidx)
        for s=1:numel(sigidx)
            hold(ax,'on')
            line(ax,[c(sigidx(s),1),c(sigidx(s),2)],[m+0.1*s m+0.1*s]);
            text(ax,mean([c(sigidx(s),1),c(sigidx(s),2)]),mean([m+0.1*s+0.05 m+0.1*s+0.05]),[num2str(c(sigidx(s),6)),'-kw'],'HorizontalAlignment','center');
            ylim([0 m+0.1*s+0.1])
        end
    end
end

end
    