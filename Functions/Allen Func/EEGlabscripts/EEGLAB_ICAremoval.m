function EEGLAB_ICAremoval(subject,protocolfolder)

subjectfolder=fullfile(protocolfolder,subject);
analysisfolder=fullfile(subjectfolder,'analysis','EEGlab');

% Import EEG structures
load(fullfile(analysisfolder,'Pre-ICA.mat'));

% Check and see if want to use previous ICA removal components
use_prev=0;
if any(exist(fullfile(analysisfolder,'ICA-Removed.mat')))
    use_prev=input('Use previous ICA? [0=no, 1=yes]');
end

if use_prev==1
    icaremove=load(fullfile(analysisfolder,'ICA-Removed.mat'));
    
elseif use_prev==0

    % Remove ICA components
    fn=fieldnames(eegevents);
    for i=1:numel(fn)
        EEG=eegevents.(fn{i});

        sessioninfo=EEG.sessioninfo;

        % Calculate coherence between EKG channel and components
        comp_data=pop_plotdata(EEG,0,[1:size(EEG.icawinv,2)]);
        close all
        heart_data=pop_plotdata(EEG,1,find(strcmp({EEG.chanlocs.labels},'EKG')));
        close all

        coh=[];
        for c=1:size(comp_data,1)
            coh(c)=mean(mscohere(comp_data(c,:),heart_data),'all');
        end

        % Detect Bad Trials (contains two eventtypes)
        events={EEG.epoch.eventtype};
        events_log=cellfun(@class,events,'UniformOutput',false);
        if any(strcmp(events_log{1},'cell'))
            events_rm=[];
            for q=1:length(events_log)
                if numel(events{q})==1
                    events_rm=[events_rm false];
                else
                    events_rm=[events_rm true];
                end
            end
            % Remove bad trials
            events_rm=logical(events_rm);
            EEG.epoch(events_rm)=[];
            EEG.data(:,:,events_rm)=[];
            EEG.trials=size(EEG.data,3);
            for et=1:size(EEG.epoch,2)
                EEG.epoch(et).eventtype=EEG.epoch(et).eventtype{:};
            end
        end

        % Calculate potential movement components
        for c=1:size(comp_data,1)
            icaacttmp  = eeg_getdatact(EEG, 'component', c);

            % z-transform ERP
            zscoreicaacttmp=zscore(icaacttmp);

            % Find trigger idx
            trig_idx= EEG.times>0;
            pretrig_idx= EEG.times<0;

            % Vars in Move vs non-move
            event_types=unique({EEG.event.type});

            eventvar=[];
            for et=1:numel(event_types)
                event_idx=logical(cell2mat(cellfun(@(x) strcmp(x,event_types(et)),{EEG.epoch.eventtype},'UniformOutput',false)));

                eventvar(et)=var(zscoreicaacttmp(:,trig_idx,event_idx),0,'all');
            end
            compvar(c)=diff([mean([eventvar(1) eventvar(2)]) eventvar(3)]);

            % Vars between Pre-Hold vs Post-Hold
            hold_idx=logical(cell2mat(cellfun(@(x) strcmp(x,(string(i*10+1))),{EEG.epoch.eventtype},'UniformOutput',false)));

            pre_hold=var(zscoreicaacttmp(:,pretrig_idx,hold_idx),0,'all');
            post_hold=var(zscoreicaacttmp(:,trig_idx,hold_idx),0,'all');

            holdvar(c)=diff([post_hold pre_hold]);

            % Vars between Pre-Hold vs Post-Hold
            move_idx=logical(cell2mat(cellfun(@(x) strcmp(x,(string(i*10+3))),{EEG.epoch.eventtype},'UniformOutput',false)));

            pre_move=var(zscoreicaacttmp(:,pretrig_idx,hold_idx),0,'all');
            post_move=var(zscoreicaacttmp(:,trig_idx,hold_idx),0,'all');

            movevar(c)=diff([pre_move post_move]);

            % Combine vars for movement component
            c_movevar(c)=compvar(c)+holdvar(c)+movevar(c);
        end

        % Run ICA label
%         EEG = iclabel(EEG);

        % Visualize ICA labels
        pop_viewprops(EEG,0,[1:size(EEG.icaweights,1)],'freqrange', [2 80]);

        % Visualize potential components
        figure;
        sgtitle([sessioninfo.patientID,'-stimside(',EEG.sessioninfo.stimlat,')']);

        subplot(1,2,1)
        [heart_coh,heart_idx]=max(coh);
        coh_b=bar(coh);
        coh_b.FaceColor = 'flat';
        coh_b.CData(heart_idx,:)=[1 0 0];
        ytips = coh_b.YEndPoints(heart_idx);
        text(heart_idx,ytips,string(heart_idx),'HorizontalAlignment','center',...
            'VerticalAlignment','bottom');
        ylim([0 1]);
        ylabel('Coherence with EKG channel');
        xlabel('Components');
        title('Likely Heart Component');

        subplot(1,2,2)
        [move_var,move_idx]=max(c_movevar);
        positive_idx=find(c_movevar>0);
        compvar_b=bar(c_movevar);
        compvar_b.FaceColor='flat';
        compvar_b.CData(move_idx,:)=[1,0,0];
        for p=1:numel(positive_idx)
            ytips = double(compvar_b.YEndPoints(positive_idx(p)));
            text(positive_idx(p),ytips,string(positive_idx(p)),'HorizontalAlignment','center',...
                'VerticalAlignment','bottom');
        end
        ylim([0 2]);
        ylabel('Z-var movement score');
        xlabel('Components');
        title('Likely Movement Component(s)');

        % Remove ICA components
        clc
        rcmp=input('ICA components to remove ..[#,#]-->');
        EEG=pop_subcomp(EEG,rcmp,1);



    %     % Perform AUTOMATIC IC rejection using ICLabel scores and r.v. from dipole fitting.
    % 
    %     EEG       = iclabel(EEG, 'default');
    %     brainIdx  = find(EEG.etc.ic_classification.ICLabel.classifications(:,1) >= 0.7);
    %     rvList    = [EEG.dipfit.model.rv];
    %     goodRvIdx = find(rvList < 0.15); 
    %     goodIcIdx = intersect(brainIdx, goodRvIdx);
    %     if heart_coh>0.7& any(goodIcIdx==heart_idx)
    %         goodIcIdx(goodIcIdx==heart_idx)=[];
    %     end      
    %     EEG = pop_subcomp(EEG, goodIcIdx, 0, 1);
        
        % Save EEG structure
        eegevents.(fn{i})=EEG;    

        close all
    end
end


save(fullfile(analysisfolder,'ICA-Removed'),'eegevents','-v7.3');

end
