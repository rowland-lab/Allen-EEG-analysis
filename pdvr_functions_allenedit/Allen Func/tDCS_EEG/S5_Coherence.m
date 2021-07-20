function S5_Coherence(subject,protocolfolder)
clc
close all

% Add Fieldtrip
addpath 'C:\Users\allen\Box Sync\Desktop\Functions\EEG_toolboxes\Matlab\fieldtrip-20200607'
ft_defaults
addpath 'C:\Users\allen\Box Sync\Desktop\Functions\EEG_toolboxes\Matlab\fieldtrip-20200607\external\spm12'
addpath 'C:\Users\allen\Box Sync\Desktop\Functions\EEG_toolboxes\Matlab\fieldtrip-20200607\external\bsmart'

%% Define Vars
% Folder
subjectfolder=fullfile(protocolfolder,subject);

analysisfolder=fullfile(subjectfolder,'analysis','S5-Coherence');
mkdir(analysisfolder);

% Import S3-preprocessed data
s3dat=load(fullfile(subjectfolder,'analysis','S3-EEGanalysis','s3_dat.mat'));

% Import S4-preprocessed data
s4dat=load(fullfile(subjectfolder,'analysis','S4-FieldTripPreproc','S4-FieldTripPreproc.mat'));
vrdat=s4dat.ft_vrdat;
sessioninfo=s4dat.ft_sessioninfo;
epochdat=s4dat.ft_epochs;

% Trial definitions
restepochs=epochdat.rest.val;

fn=fieldnames(epochdat.vrevents);
for i=1:numel(fn)
    holdepochs{i}=epochdat.vrevents.(fn{i}).atStartPosition.val;
    prepepoch{i}=epochdat.vrevents.(fn{i}).cueEvent.val;
    moveepoch{i}=epochdat.vrevents.(fn{i}).targetUp.val;
end

frequencies={'beta','gamma'};
freq_range={[13 30],[70 200]};
for freq=1:numel(frequencies)
%% Calculate Rest Epoch COH
cfg             = [];
cfg.dataset     = fullfile(subjectfolder,[subject,'.edf']);
cfg.continuous  = 'yes';
cfg.channel     = (1:21);
cfg.trl         = restepochs;
cfg.trl(:,3)    = 0;

cfg.hpfiltord   = 5;
cfg.hpfilter    = 'yes';
cfg.hpfreq      = 1;
cfg.bsfilter    = 'yes';
cfg.bsfreq      = [58 62;118 122;178 182];

data_eeg        = ft_preprocessing(cfg);

% Calculate coherence

cfg                 = [];
cfg.output          = 'powandcsd';
cfg.method          = 'mtmfft';
cfg.taper           = 'dpss';
cfg.pad             = 'nextpow2';
cfg.keeptrials      = 'yes';
cfg.tapsmofrq       = 2;
cfg.foilim          = freq_range{freq};
freq_csd            = ft_freqanalysis(cfg, data_eeg);

for q=1:size(restepochs,1)
    cfg                 = [];
    cfg.method          = 'coh';
    cfg.complex         = 'absimag';
    cfg.trials          = q;
    conn                = ft_connectivityanalysis(cfg, freq_csd);
    
    coherence.(frequencies{freq}).rest.total(:,:,q)=mean(conn.cohspctrm,2);

    temp=conn.cohspctrm;
    temp=mean(temp,2);

    count=1;
    temp2=nan(21,21);
    for i=1:20
        temp2(i+1:end,i)=temp(count:count+20-i);
        count=count+(21-i);
    end

    coherence.(frequencies{freq}).rest.dat(:,:,q)=temp2;
end

    
% Calculate difference
tempdat=coherence.(frequencies{freq}).rest.dat;

for i=2:size(tempdat,3)
    tempdiff(:,:,i-1)=tempdat(:,:,i)-tempdat(:,:,1);
end

coherence.(frequencies{freq}).rest.diffdat=tempdiff;

%% Calculate VR Epoch COH

vrepochtrlnames={'holdepochs','prepepoch','moveepoch'};

for vre=1:numel(vrepochtrlnames)
    tempdat=eval(vrepochtrlnames{vre});
    
    for trials=1:size(tempdat,2)
        cfg             = [];
        cfg.dataset     = fullfile(subjectfolder,[subject,'.edf']);
        cfg.continuous  = 'yes';
        cfg.channel     = (1:21);
        cfg.trl         = tempdat{1,trials};
        cfg.trl(:,3)    = 0;

        cfg.hpfiltord   = 5;
        cfg.hpfilter    = 'yes';
        cfg.hpfreq      = 1;
        cfg.bsfilter    = 'yes';
        cfg.bsfreq      = [58 62;118 122;178 182];

        data_eeg        = ft_preprocessing(cfg);

        % Calculate coherence

        cfg                 = [];
        cfg.output          = 'powandcsd';
        cfg.method          = 'mtmfft';
        cfg.taper           = 'dpss';
        cfg.pad             = 'nextpow2';
        cfg.keeptrials      = 'yes';
        cfg.tapsmofrq       = 2;
        cfg.foilim          = freq_range{freq};
        freq_csd            = ft_freqanalysis(cfg, data_eeg);

        cfg                 = [];
        cfg.method          = 'coh';
        cfg.complex         = 'absimag';
        conn                = ft_connectivityanalysis(cfg, freq_csd);

        temp=conn.cohspctrm;
        temp=mean(temp,2);

        count=1;
        temp2=nan(21,21);
        for i=1:20
            temp2(i+1:end,i)=temp(count:count+20-i);
            count=count+(21-i);
        end

        coherence.(frequencies{freq}).(vrepochtrlnames{vre}).dat(:,:,trials)=temp2;
        
        coherence.(frequencies{freq}).(vrepochtrlnames{vre}).total(:,:,trials)=mean(conn.cohspctrm,2);
    end
    
    % Calculate difference
    tempdat=coherence.(frequencies{freq}).(vrepochtrlnames{vre}).dat;
    
    for i=2:size(tempdat,3)
        tempdiff(:,:,i-1)=tempdat(:,:,i)-tempdat(:,:,1);
    end
    
    coherence.(frequencies{freq}).(vrepochtrlnames{vre}).diffdat=tempdiff;
end

coherence.(frequencies{freq}).label=unique([conn.labelcmb(:,2),conn.labelcmb(:,1)],'stable');
coherence.(frequencies{freq}).pairs=conn.labelcmb;
coherence.(frequencies{freq}).epochcompare=s3dat.Epochcompare;

save(fullfile(subjectfolder,'analysis','S5-Coherence','coherencemat'),'coherence')

%% Create graphs

% Create rest graphs
restidx=coherence.(frequencies{freq}).epochcompare(:,2);
restnames=sessioninfo.trialnames(restidx);

figure('Name',['Rest ',frequencies{freq},'-Imaginary Coherence'])
sgtitle(['Rest ',frequencies{freq},' Imaginary Coherence-',subject])
for i=1:numel(restidx)
    if numel(restnames)==1
        spnum=[1 1];
    elseif numel(restnames)==2
        spnum=[1 2];
    else
        spnum=[round(numel(restnames)/2) round(numel(restnames)/2)];
    end
    
    subplot(spnum(1),spnum(2),i)
    imagesc(coherence.(frequencies{freq}).rest.dat(:,:,restidx(i)))
    set(gca,'XTick',[1:numel(coherence.(frequencies{freq}).label)],'YTick',[1:numel(coherence.(frequencies{freq}).label)],'XTickLabelRotation',90)
    xticklabels(coherence.(frequencies{freq}).label);
    yticklabels(coherence.(frequencies{freq}).label);
    c=colorbar;
    ylabel(c,[frequencies{freq},' Imaginary Coherence']);
    colormap('jet');
    title(restnames{i});
end
savefig(gcf,fullfile(analysisfolder,get(gcf,'Name')));

% Create hold graphs
holdepochsidx=coherence.(frequencies{freq}).epochcompare(:,2);
holdepochsnames=sessioninfo.trialnames(holdepochsidx);

figure('Name',['Hold ',frequencies{freq},'-Imaginary Coherence'])
sgtitle(['Hold ',frequencies{freq},' Imaginary Coherence-',subject])
for i=1:numel(holdepochsidx)
    if numel(holdepochsnames)==1
        spnum=[1 1];
    elseif numel(holdepochsnames)==2
        spnum=[1 2];
    else
        spnum=[round(numel(holdepochsnames)/2) round(numel(holdepochsnames)/2)];
    end
    
    subplot(spnum(1),spnum(2),i)
    imagesc(coherence.(frequencies{freq}).holdepochs.dat(:,:,holdepochsidx(i)))
    set(gca,'XTick',[1:numel(coherence.(frequencies{freq}).label)],'YTick',[1:numel(coherence.(frequencies{freq}).label)],'XTickLabelRotation',90)
    xticklabels(coherence.(frequencies{freq}).label);
    yticklabels(coherence.(frequencies{freq}).label);
    c=colorbar;
    ylabel(c,[frequencies{freq},' Imaginary Coherence']);
    colormap('jet');
    title(holdepochsnames{i});
end
savefig(gcf,fullfile(analysisfolder,get(gcf,'Name')));
    

% Create prep graphs
prepepochidx=coherence.(frequencies{freq}).epochcompare(:,2);
prepepochnames=sessioninfo.trialnames(prepepochidx);

figure('Name',['Prep',frequencies{freq},'-Imaginary Coherence'])
sgtitle(['Prep ',frequencies{freq},' Imaginary Coherence-',subject])
for i=1:numel(prepepochidx)
    if numel(prepepochnames)==1
        spnum=[1 1];
    elseif numel(prepepochnames)==2
        spnum=[1 2];
    else
        spnum=[round(numel(prepepochnames)/2) round(numel(prepepochnames)/2)];
    end
    
    subplot(spnum(1),spnum(2),i)
    imagesc(coherence.(frequencies{freq}).prepepoch.dat(:,:,prepepochidx(i)))
    set(gca,'XTick',[1:numel(coherence.(frequencies{freq}).label)],'YTick',[1:numel(coherence.(frequencies{freq}).label)],'XTickLabelRotation',90)
    xticklabels(coherence.(frequencies{freq}).label);
    yticklabels(coherence.(frequencies{freq}).label);
    c=colorbar;
    ylabel(c,[frequencies{freq},' Imaginary Coherence']);
    colormap('jet');
    title(prepepochnames{i});
end
savefig(gcf,fullfile(analysisfolder,get(gcf,'Name')));


% Create Move graphs
moveepochidx=coherence.(frequencies{freq}).epochcompare(:,2);
moveepochnames=sessioninfo.trialnames(moveepochidx);

figure('Name',['Move ',frequencies{freq},'-Imaginary Coherence'])
sgtitle(['Move ',frequencies{freq},' Imaginary Coherence-',subject])
for i=1:numel(moveepochidx)
    if numel(moveepochnames)==1
        spnum=[1 1];
    elseif numel(moveepochnames)==2
        spnum=[1 2];
    else
        spnum=[round(numel(moveepochnames)/2) round(numel(moveepochnames)/2)];
    end
    
    subplot(spnum(1),spnum(2),i)
    imagesc(coherence.(frequencies{freq}).moveepoch.dat(:,:,moveepochidx(i)))
    set(gca,'XTick',[1:numel(coherence.(frequencies{freq}).label)],'YTick',[1:numel(coherence.(frequencies{freq}).label)],'XTickLabelRotation',90)
    xticklabels(coherence.(frequencies{freq}).label);
    yticklabels(coherence.(frequencies{freq}).label);
    c=colorbar;
    ylabel(c,[frequencies{freq},' Imaginary Coherence']);
    colormap('jet');
    title(moveepochnames{i});
end
savefig(gcf,fullfile(analysisfolder,get(gcf,'Name')));

%% Create graphs (differences)
if any(coherence.(frequencies{freq}).epochcompare(coherence.(frequencies{freq}).epochcompare(:,2))==1)

% Create rest graphs
restidx=coherence.(frequencies{freq}).epochcompare(coherence.(frequencies{freq}).epochcompare(:,2)~=1,2);
restnames=sessioninfo.trialnames(restidx);

figure('Name',['Rest ',frequencies{freq},'-Imaginary Coherence Difference'])
sgtitle(['Rest ',frequencies{freq},'-Imaginary Coherence Difference-',subject])
for i=1:numel(restidx)
    if numel(restnames)==1
        spnum=[1 1];
    elseif numel(restnames)==2
        spnum=[1 2];
    else
        spnum=[round(numel(restnames)/2) round(numel(restnames)/2)];
    end
    
    subplot(spnum(1),spnum(2),i)
    imagesc(coherence.(frequencies{freq}).rest.diffdat(:,:,restidx(i)-1))
    set(gca,'XTick',[1:numel(coherence.(frequencies{freq}).label)],'YTick',[1:numel(coherence.(frequencies{freq}).label)],'XTickLabelRotation',90)
    xticklabels(coherence.(frequencies{freq}).label);
    yticklabels(coherence.(frequencies{freq}).label);
    c=colorbar;
    colormap('jet');
    ylabel(c,[frequencies{freq},' Imaginary Coherence']);
    caxis([-0.3 0.3])
    title(restnames{i});
end
savefig(gcf,fullfile(analysisfolder,get(gcf,'Name')));

holdepochsidx=coherence.(frequencies{freq}).epochcompare(coherence.(frequencies{freq}).epochcompare(:,2)~=1,2);
holdepochsnames=sessioninfo.trialnames(holdepochsidx);

figure('Name',['Hold ',frequencies{freq},'-Imaginary Coherence Difference'])
sgtitle(['Hold ',frequencies{freq},' Imaginary Coherence Difference-',subject])
for i=1:numel(holdepochsidx)
    if numel(holdepochsnames)==1
        spnum=[1 1];
    elseif numel(holdepochsnames)==2
        spnum=[1 2];
    else
        spnum=[round(numel(holdepochsnames)/2) round(numel(holdepochsnames)/2)];
    end
    
    subplot(spnum(1),spnum(2),i)
    imagesc(coherence.(frequencies{freq}).holdepochs.diffdat(:,:,holdepochsidx(i)-1))
    set(gca,'XTick',[1:numel(coherence.(frequencies{freq}).label)],'YTick',[1:numel(coherence.(frequencies{freq}).label)],'XTickLabelRotation',90)
    xticklabels(coherence.(frequencies{freq}).label);
    yticklabels(coherence.(frequencies{freq}).label);
    c=colorbar;
    colormap('jet');
    ylabel(c,[frequencies{freq},' Imaginary Coherence']);
    caxis([-0.3 0.3])
    title(holdepochsnames{i});
end
savefig(gcf,fullfile(analysisfolder,get(gcf,'Name')));

prepepochidx=coherence.(frequencies{freq}).epochcompare(coherence.(frequencies{freq}).epochcompare(:,2)~=1,2);
prepepochnames=sessioninfo.trialnames(prepepochidx);

figure('Name',['Prep ',frequencies{freq},'-Imaginary Coherence Difference'])
sgtitle(['Prep Imaginary Coherence ',frequencies{freq},' Difference-',subject])
for i=1:numel(prepepochidx)
    if numel(prepepochnames)==1
        spnum=[1 1];
    elseif numel(prepepochnames)==2
        spnum=[1 2];
    else
        spnum=[round(numel(prepepochnames)/2) round(numel(prepepochnames)/2)];
    end
    
    subplot(spnum(1),spnum(2),i)
    imagesc(coherence.(frequencies{freq}).prepepoch.diffdat(:,:,prepepochidx(i)-1))
    set(gca,'XTick',[1:numel(coherence.(frequencies{freq}).label)],'YTick',[1:numel(coherence.(frequencies{freq}).label)],'XTickLabelRotation',90)
    xticklabels(coherence.(frequencies{freq}).label);
    yticklabels(coherence.(frequencies{freq}).label);
    c=colorbar;
    colormap('jet');
    ylabel(c,[frequencies{freq},' Imaginary Coherence']);
    caxis([-0.3 0.3])
    title(prepepochnames{i});
end
savefig(gcf,fullfile(analysisfolder,get(gcf,'Name')));

moveepochidx=coherence.(frequencies{freq}).epochcompare(coherence.(frequencies{freq}).epochcompare(:,2)~=1,2);
moveepochnames=sessioninfo.trialnames(moveepochidx);

figure('Name',['Move ',frequencies{freq},'-Imaginary Coherence Difference'])
sgtitle(['Move Imaginary Coherence ',frequencies{freq},' Difference-',subject])
for i=1:numel(moveepochidx)
    if numel(moveepochnames)==1
        spnum=[1 1];
    elseif numel(moveepochnames)==2
        spnum=[1 2];
    else
        spnum=[round(numel(moveepochnames)/2) round(numel(moveepochnames)/2)];
    end
    
    subplot(spnum(1),spnum(2),i)
    imagesc(coherence.(frequencies{freq}).moveepoch.diffdat(:,:,moveepochidx(i)-1))
    set(gca,'XTick',[1:numel(coherence.(frequencies{freq}).label)],'YTick',[1:numel(coherence.(frequencies{freq}).label)],'XTickLabelRotation',90)
    xticklabels(coherence.(frequencies{freq}).label);
    yticklabels(coherence.(frequencies{freq}).label);
    c=colorbar;
    colormap('jet');
    caxis([-0.3 0.3])
    ylabel(c,[frequencies{freq},' Imaginary Coherence']);
    title(moveepochnames{i});
end
savefig(gcf,fullfile(analysisfolder,get(gcf,'Name')));
else
end

%% Create bar graph

epochcompare=coherence.(frequencies{freq}).epochcompare;
figure('Name',['Total ',frequencies{freq},'-Imaginary Coherence'])
title(['Total ',frequencies{freq},'-Imaginary Coherence',subject])
set(gca,'YLim',[0 1],'XTick',[1:4],'XTickLabel',{'Rest','Hold','Prep','Move'})
ylabel([frequencies{freq},' Imaginary Coherence']);
hold on

bardat=[];
for i=1:size(epochcompare,1)
    restidx=epochcompare(i,1);
    vridx=epochcompare(i,2);
    bardat{1,1}(:,i)=coherence.(frequencies{freq}).rest.total(:,:,restidx);
    bardat{2,1}(:,i)=coherence.(frequencies{freq}).holdepochs.total(:,:,vridx);
    bardat{3,1}(:,i)=coherence.(frequencies{freq}).prepepoch.total(:,:,vridx);
    bardat{4,1}(:,i)=coherence.(frequencies{freq}).moveepoch.total(:,:,vridx);
end
barmeandat=cell2mat(cellfun(@(x) mean(x,1),bardat,'UniformOutput',false));
b=bar(barmeandat);

xpoints=[];
err=[];
for i=1:numel(b)
    xpoints(i,:)=b(i).XEndPoints;
    tempdat=cellfun(@(x) x(:,i),bardat,'UniformOutput',false);
    for z=1:size(tempdat,1)
        x=tempdat{z}(:,:);
        err(i,z)=std(x)/sqrt(numel(x));
    end
    errorbar(xpoints(i,:),barmeandat(:,i),err(i,:),'k', 'linestyle', 'none');
end

for i=1:size(bardat,1)
    tempdat=bardat{i};
    
    % Test for normality
    normality=kstest(tempdat(:));

    % Sig text location
    max_data=max(mean(tempdat,1)+err(:,i)',[],'all');

    % Test for Normality
    if normality ==0
        [~,~,stats]=anova1(tempdat,[],'off');
        pvalues=multcompare(stats,'Display','off');
        test='an';
    else
        [~,~,stats]=kruskalwallis(tempdat,[],'off');
        pvalues=multcompare(stats,'Display','off');
        test='kw';
    end
    
    bar_loc=xpoints(:,i);

    % Find 0.05 significance
    last_max=[];
    if any(le(pvalues(:,6),0.05))
       idx=find(le(pvalues(:,6),0.05));
       spacer=diff(get(gca,'YLim'))*0.05;
       for m=1:numel(idx)
           l=line(gca,[bar_loc(pvalues(idx(m),1)) bar_loc(pvalues(idx(m),2))],[1 1]*max_data+m*spacer);
           set(l,'linewidth',2)
           t=text(gca,mean([bar_loc(pvalues(idx(m),1)) bar_loc(pvalues(idx(m),2))]),max_data+(m+.5)*spacer,[test,string(pvalues(idx(m),6))],'HorizontalAlignment','center');
       end
       last_max=t.Position(2);
    end

    % Find 0.10 trending
    if any(le(pvalues(:,6),0.10)&ge(pvalues(:,6),0.05))
       idx=find(le(pvalues(:,6),0.10)&ge(pvalues(:,6),0.05));
       if isempty(last_max)
           spacer=diff(get(gca,'YLim'))*0.05;
       else
           max_data=last_max;
       end
       for m=1:numel(idx)
           l=line(gca,[bar_loc(pvalues(idx(m),1)) bar_loc(pvalues(idx(m),2))],[1 1]*max_data+m*spacer);
           set(l,'linewidth',2)
           t=text(gca,mean([bar_loc(pvalues(idx(m),1)) bar_loc(pvalues(idx(m),2))]),max_data+(m+.5)*spacer,[test,string(pvalues(idx(m),6))],'HorizontalAlignment','center');
           set(l,'Color','r')
       end
    end
end

legend(sessioninfo.trialnames(epochcompare(:,1)))

savefig(gcf,fullfile(analysisfolder,get(gcf,'Name')));

close all
end
