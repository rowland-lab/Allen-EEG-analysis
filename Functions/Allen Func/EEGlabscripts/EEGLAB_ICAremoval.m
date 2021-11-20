function eegevents=EEGLAB_ICAremoval(eegevents,auto)
%
% subjectfolder=fullfile(protocolfolder,subject);
% analysisfolder=fullfile(subjectfolder,'analysis','EEGlab');
%
% % Import EEG structures
% load(fullfile(analysisfolder,'Pre-ICA.mat'));
%
% % Check and see if want to use previous ICA removal components
% use_prev=0;
% % if any(exist(fullfile(analysisfolder,'ICA-Removed.mat')))
% %     use_prev=input('Use previous ICA? [0=no, 1=yes]');
% % end
%

% Remove ICA components
fn=fieldnames(eegevents.trials);
for i=1:numel(fn)
    EEG=eegevents.trials.(fn{i});
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
    
    % Calculate heart Coherence
    [heart_coh,heart_idx]=max(coh);
    

    % Remove ICA components
    clc
    if auto
        disp(['Heart component coherence ---',num2str(heart_coh)])
        if heart_coh>0.7
            EEG.rcmp=heart_idx;
            EEG=pop_subcomp(EEG,EEG.rcmp,0);
        else
            disp('Heart Coherence unable to be autodetected')
            EEG.rcmp=nan;
        end
    else
        % Run ICA label
        EEG = iclabel(EEG);
        
        % Visualize ICA labels
        pop_viewprops(EEG,0,[1:size(EEG.icaweights,1)],'freqrange', [2 80]);
        
        % Visualize potential components
        figure;
        sgtitle([sessioninfo.patientID,'-stimside(',EEG.sessioninfo.stimlat,')']);
        
        subplot(1,2,1)
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
        rcmp=input('ICA components to remove ..[#,#]-->');
        EEG=pop_subcomp(EEG,rcmp,1);
    end
    
    % Save EEG structure
    eegevents.trials.(fn{i})=EEG;
end

% ICA removal step completion tag
eegevents.pipeline.ICAremoval=true;


% save(fullfile(analysisfolder,'ICA-Removed'),'eegevents','-v7.3');
close all
end
