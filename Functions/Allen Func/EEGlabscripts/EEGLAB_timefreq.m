function EEGLAB_timefreq(subject,protocolfolder)

subjectfolder=fullfile(protocolfolder,subject);
analysisfolder=fullfile(subjectfolder,'analysis','EEGlab');


% Create figure folders
figfolder=fullfile(analysisfolder,'figures');
mkdir(figfolder);

spectrogramfolder=fullfile(figfolder,'spectrogram');
mkdir(spectrogramfolder);

topoplotfolder=fullfile(figfolder,'topoplot');
mkdir(topoplotfolder);


try 
    % Import EEG structures
    load(fullfile(analysisfolder,'ICA-Removed.mat'));
catch
    disp('Missing Previous step files')
    return
end

% Import S1 session info
s1=load(fullfile(subjectfolder,'analysis','S1-VR_preproc',[subject,'_S1-VRdata_preprocessed.mat']));
sessioninfo=s1.sessioninfo;
trialnames=sessioninfo.trialnames;


% Time-Freq analysis creation
fn=fieldnames(eegevents);
phases={'hold','prep','move'};
for i=1:numel(fn)
    EEG=eegevents.(fn{i});

    % Find eventtypes
    event_types=unique({EEG.epoch.eventtype});
    
    % Fix EEG.event structure to match epoch
    epoch_idx=[EEG.epoch.event];
    EEG.event=EEG.event(epoch_idx);
    for ep=1:length(EEG.event)
        EEG.event(ep).epoch=ep;
    end
    
    % Calculate Power for each phase
    clearvars tempphaseeg
    for ph=1:numel(event_types)
        phaseEEG= pop_selectevent(EEG,'type',event_types{ph});
        
        % Define phase number
        pn=event_types{ph}(2);
        pn=str2double(pn);

        % Calculate Power of each channel
        for elec = 1:EEG.nbchan
            % Calculate Difference in Power
            [ersp,itc,powbase,times,freqs,erspboot,itcboot] = pop_newtimef(phaseEEG,1, elec,[-500,1000],0,'padratio',8, ... 
            'plotphase', 'off', 'timesout', 60, 'alpha', .01,'mcorrect','fdr','plotersp','off', 'plotitc','off');
            phaseEEG.power.ersp_diff(:,:,elec) = ersp;
            phaseEEG.power.times_diff(:,:,elec) = times;
            phaseEEG.power.freqs_diff(:,:,elec) = freqs;
            phaseEEG.power.erspboot_diff(:,:,elec) = erspboot;

            % Calculate Significant different in power
            tempdat=ersp;
            for r=1:size(tempdat,1)
                temprow=tempdat(r,:);
                tempboot=erspboot(r,:);

                tempdat(r,temprow>tempboot(1) & temprow<tempboot(2))=0;
            end
            phaseEEG.power.significant_diff(:,:,elec)=tempdat;

            % Calculate Raw Power
            [ersp,itc,powbase,times,freqs,erspboot,itcboot] = pop_newtimef(phaseEEG,1, elec,[-500,1000],0,'padratio',8, ... 
            'plotphase', 'off', 'timesout', 60,'plotersp','off', 'plotitc','off','baseline',nan);
            phaseEEG.power.ersp(:,:,elec) = ersp;
            phaseEEG.power.times(:,:,elec) = times;
            phaseEEG.power.freqs(:,:,elec) = freqs;
            phaseEEG.power.erspboot(:,:,elec) = erspboot;
        end
            
        % Save structure back to tempphaseeeg structure
        tempphaseeg(pn,:)=phaseEEG;
        
        
        
        
%         % Plot C3 power
%         figure('units','normalized','outerposition',[0 0 1 1])
%         c3elec=find(strcmp({phaseEEG.chanlocs.labels},'C3'));
%         pop_newtimef(phaseEEG,1, c3elec,[-500,1000],0,'padratio',8, ... 
%             'timesout', 60, 'alpha', .05,'mcorrect','fdr','plotitc','off','plotphase', 'off');
%         temptitle=[subject,' - ',phases{ph},' - ',trialnames{i},' --- Left Motor Cortex (C3), 0.05 alpha (fdr correct)'];
%         sgtitle(temptitle,'Interpreter', 'none')
%         graphchild=get(gcf,'Children');
%         graph=graphchild(5);
%         graph.CLim=[-5 5];
%         cb=graphchild(4);
%         cb.YLim=[-5 5];
%         cb.Children.YData=[-5 5];
%         
% %         saveas(gcf,fullfile(spectrogramfolder,[temptitle,'.jpeg']),'jpeg')
%         saveas(gcf,fullfile(spectrogramfolder,[temptitle]),'epsc')
%         close all
%         
%         
%         % Plot C4 power
%         figure('units','normalized','outerposition',[0 0 1 1])
%         c4elec=find(strcmp({phaseEEG.chanlocs.labels},'C4'));
%         pop_newtimef(phaseEEG,1, c4elec,[-500,1000],0,'padratio',8, ... 
%             'timesout', 60, 'alpha', .05,'mcorrect','fdr','plotitc','off','plotphase', 'off');
%         temptitle=[subject,' - ',phases{ph},' - ',trialnames{i},' --- Right Motor Cortex (C4), 0.05 alpha (fdr correct)'];
%         sgtitle(temptitle,'Interpreter', 'none')
%         graphchild=get(gcf,'Children');
%         graph=graphchild(5);
%         graph.CLim=[-5 5];
%         cb=graphchild(4);
%         cb.YLim=[-5 5];
%         cb.Children.YData=[-5 5];
%         saveas(gcf,fullfile(spectrogramfolder,[temptitle,'.jpeg']),'jpeg')
% %         saveas(gcf,fullfile(spectrogramfolder,[temptitle]),'epsc')
%         close all
    end
    
%     Save tempphaseeg back to eegevents structure
    eegevents.(fn{i})=tempphaseeg;
    
end
    


save(fullfile(analysisfolder,'EEGlab_power'),'eegevents','-v7.3');

end