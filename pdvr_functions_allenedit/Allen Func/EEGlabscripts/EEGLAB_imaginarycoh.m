function EEGLAB_imaginarycoh(subject,protocolfolder)

% Add Fieldtrip
addpath 'C:\Users\allen\Box Sync\Desktop\Functions\EEG_toolboxes\Matlab\fieldtrip-20200607'
ft_defaults
addpath 'C:\Users\allen\Box Sync\Desktop\Functions\EEG_toolboxes\Matlab\fieldtrip-20200607\external\spm12'
addpath 'C:\Users\allen\Box Sync\Desktop\Functions\EEG_toolboxes\Matlab\fieldtrip-20200607\external\bsmart'

subjectfolder=fullfile(protocolfolder,subject);
analysisfolder=fullfile(subjectfolder,'analysis','EEGlab');

% Import power calculated EEG structures
powermatfile=fullfile(analysisfolder,'EEGlab_power.mat');
if any(exist(powermatfile))
    import=load(powermatfile);
    eegepochs=import.eegevents;
else
    disp([subject,' missing EEGlab power file'])
    return
end

fn=fieldnames(eegepochs);
for i=1:numel(fn)
    wkEEG=eegepochs.(fn{i});
    
    for phas=1:size(wkEEG,1)
        
        peeg=wkEEG(phas,:);
        
        if isempty(peeg.setname)
            continue
        end
        
        timeidx=peeg.times>=0;

        peeg.times=peeg.times(timeidx);
        peeg.data=peeg.data(:,timeidx,:);

        % Convert EEGLAB structure to FieldTrip Strucutre
        ft_EEG=[];

        ft_EEG.hdr.Fs=peeg.srate;
        ft_EEG.hdr.nChans=peeg.nbchan;
        ft_EEG.hdr.labels={peeg.chanlocs.labels}';
        ft_EEG.hdr.nSamples=peeg.pnts;
        ft_EEG.hdr.nTrials=peeg.trials;

        ft_EEG.label=ft_EEG.hdr.labels;
        ft_EEG.time=repmat({peeg.times/1000},1,peeg.trials);

        for t=1:size(peeg.data,3)
            ft_EEG.trial{t}=double(peeg.data(:,:,t));
        end
        ft_EEG.fsample=peeg.srate;


        % Calculate imaginary coherence        
        cfg                 = [];
        cfg.output          = 'powandcsd';
        cfg.method          = 'mtmfft';
        cfg.taper           = 'dpss';
        cfg.pad             = 'maxperlen';
        cfg.keeptrials      = 'yes';
        cfg.tapsmofrq       = 1;
        cfg.channel         = [1:21];
        freq_csd            = ft_freqanalysis(cfg, ft_EEG);

        cfg                 = [];
        cfg.method          = 'coh';
        cfg.complex         = 'absimag';
        conn                = ft_connectivityanalysis(cfg, freq_csd);

        % Save Coherence structure
        peeg.ft_iCoh=conn;
        
        % Save peeg to tempeeg structure
        tempeeg(phas,:)=peeg;
    end
    
    % Save tempeeg to eegepochs
    eegepochs.(fn{i})=tempeeg;
end

save(fullfile(analysisfolder,'EEGlab_ftimagcoh'),'eegepochs');

end