function eegevents=EEGLAB_timefreq(eegevents,subject)

% subjectfolder=fullfile(protocolfolder,subject);
% analysisfolder=fullfile(subjectfolder,'analysis','EEGlab');
%
%
% % Create figure folders
% figfolder=fullfile(analysisfolder,'figures');
% mkdir(figfolder);
%
% spectrogramfolder=fullfile(figfolder,'spectrogram');
% mkdir(spectrogramfolder);
%
% topoplotfolder=fullfile(figfolder,'topoplot');
% mkdir(topoplotfolder);


% try
%     % Import EEG structures
%     load(fullfile(analysisfolder,'ICA-Removed.mat'));
% catch
%     disp('Missing Previous step files')
%     return
% end
%
% % Import S1 session info
% s1=load(fullfile(subjectfolder,'analysis','S1-VR_preproc',[subject,'_S1-VRdata_preprocessed.mat']));
% sessioninfo=s1.sessioninfo;
% trialnames=sessioninfo.trialnames;


% Time-Freq analysis creation
fn=fieldnames(eegevents.trials);
for e=1:numel(fn)
    EEG=eegevents.trials.(fn{e});
    
    % Fix Epoch field to numbers and non-cells
    if iscell(EEG.epoch(1).eventlatency)
        for i=1:size(EEG.epoch,2)
            if any(cellfun(@ischar,EEG.epoch(i).eventtype))
               EEG.epoch(i).eventtype=cellfun(@str2num,EEG.epoch(i).eventtype,'UniformOutput',false);
            end
            EEG.epoch(i).eventlatency=cell2mat(EEG.epoch(i).eventlatency);
            EEG.epoch(i).eventtype=cell2mat(EEG.epoch(i).eventtype);
            EEG.epoch(i).eventurevent=cell2mat(EEG.epoch(i).eventurevent);
            EEG.epoch(i).eventtrial=cell2mat(EEG.epoch(i).eventtrial);
            EEG.epoch(i).eventreach=cell2mat(EEG.epoch(i).eventreach);
            EEG.epoch(i).eventphase=cell2mat(EEG.epoch(i).eventphase);
        end
    end
    
    % Fix Epoch field into numbers if string
    if ischar(EEG.epoch(1).eventtype)
        for i=1:size(EEG.epoch,2)
            EEG.epoch(i).eventtype=str2num(EEG.epoch(i).eventtype);
        end
    end
    
    event_types=cat(2,EEG.epoch.eventtype);
    event_types=unique(event_types);
    
    
    % Calculate Power for each phase
    for ph=1:numel(event_types)
        phaseEEG= pop_selectevent(EEG,'type',event_types(ph));
        
        % Fix Epoch field if cell
        if iscell(phaseEEG.epoch(1).eventtype)
            for i=1:size(phaseEEG.epoch,2)
                if any(cellfun(@ischar,phaseEEG.epoch(i).eventtype))
                    phaseEEG.epoch(i).eventtype=cellfun(@str2num,phaseEEG.epoch(i).eventtype,'UniformOutput',false);
                end
                phaseEEG.epoch(i).eventlatency=cell2mat(phaseEEG.epoch(i).eventlatency);
                phaseEEG.epoch(i).eventtype=cell2mat(phaseEEG.epoch(i).eventtype);
                phaseEEG.epoch(i).eventurevent=cell2mat(phaseEEG.epoch(i).eventurevent);
                phaseEEG.epoch(i).eventtrial=cell2mat(phaseEEG.epoch(i).eventtrial);
                phaseEEG.epoch(i).eventreach=cell2mat(phaseEEG.epoch(i).eventreach);
                phaseEEG.epoch(i).eventphase=cell2mat(phaseEEG.epoch(i).eventphase);
            end
        end
        
        % Fix Epoch field into numbers if string
        if ischar(phaseEEG.epoch(1).eventtype)
            for i=1:size(phaseEEG.epoch,2)
                phaseEEG.epoch(i).eventtype=str2num(phaseEEG.epoch(i).eventtype)
            end
        end

        % Check to see if double event epochs exist
        rmIdx=find(cellfun(@(x) x(1)==1,cellfun(@(x) x~=event_types(ph),{phaseEEG.epoch.eventtype},'UniformOutput',false)));
        
        phaseEEG.doubleeventlog=~isempty(rmIdx);
        phaseEEG.doubleevent=phaseEEG.event;
        
        
        
        % Fix double events
        if phaseEEG.doubleeventlog
            
            % Remove epochs for data
            phaseEEG.data(:,:,rmIdx)=[];
            
            % Remove epoch from event field
            phaseEEG.event(cellfun(@(x) any(x==rmIdx),{phaseEEG.event.epoch}))=[];
            for l=1:length(phaseEEG.event)
                phaseEEG.event(l).epoch=l;
            end
            
            % Remove Epoch from epoch field
            phaseEEG.epoch(rmIdx)=[];
            for l=1:length(phaseEEG.epoch)
                phaseEEG.epoch(l).event=l;
            end
            
            % Fix trials field
            phaseEEG.trials=size(phaseEEG.data,3);
        end
        
        
        % Define phase number
        pn=mod(event_types(ph),10);
        
        % Calculate Power of each channel
        for elec = 1:EEG.nbchan
            % Calculate Difference in Power
            [ersp,itc,powbase,times,freqs,erspboot,itcboot] = pop_newtimef(phaseEEG,1, elec,[phaseEEG.xmin*1000,phaseEEG.xmax*1000],0,'padratio',8, ...
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
            [ersp,itc,powbase,times,freqs,erspboot,itcboot] = pop_newtimef(phaseEEG,1,elec,[phaseEEG.xmin*1000,phaseEEG.xmax*1000],0,'padratio',8, ...
                'plotphase', 'off', 'timesout', 60,'plotersp','off', 'plotitc','off','baseline',nan);
            phaseEEG.power.ersp(:,:,elec) = ersp;
            phaseEEG.power.times(:,:,elec) = times;
            phaseEEG.power.freqs(:,:,elec) = freqs;
            phaseEEG.power.erspboot(:,:,elec) = erspboot;
        end
        
        % Save structure back to tempphaseeeg structure
        tempphaseeg(pn,:)=phaseEEG;
        
        phases={'hold';'prep';'move'}
        trialnames=fn;
        
        
                % Plot C3 power
                figure('units','normalized','outerposition',[0 0 1 1])
                c3elec=find(strcmp({phaseEEG.chanlocs.labels},'C3'));
                pop_newtimef(phaseEEG,1, c3elec,[-500,1000],0,'padratio',8, ...
                    'timesout', 60, 'alpha', .05,'mcorrect','fdr','plotitc','off','plotphase', 'off');
                temptitle=[subject,' - ',phases{ph},' - ',trialnames{e},' --- Left Motor Cortex (C3), 0.05 alpha (fdr correct)'];
                sgtitle(temptitle,'Interpreter', 'none')
                graphchild=get(gcf,'Children');
                graph=graphchild(5);
                graph.CLim=[-5 5];
                cb=graphchild(4);
                cb.YLim=[-5 5];
                cb.Children.YData=[-5 5];
        
        %         saveas(gcf,fullfile(spectrogramfolder,[temptitle,'.jpeg']),'jpeg')
                %saveas(gcf,fullfile(spectrogramfolder,[temptitle]),'epsc')
                %close allF
        
        
                % Plot C4 power
                figure('units','normalized','outerposition',[0 0 1 1])
                c4elec=find(strcmp({phaseEEG.chanlocs.labels},'C4'));
                pop_newtimef(phaseEEG,1, c4elec,[-500,1000],0,'padratio',8, ...
                    'timesout', 60, 'alpha', .05,'mcorrect','fdr','plotitc','off','plotphase', 'off');
                temptitle=[subject,' - ',phases{ph},' - ',trialnames{e},' --- Right Motor Cortex (C4), 0.05 alpha (fdr correct)'];
                sgtitle(temptitle,'Interpreter', 'none')
                graphchild=get(gcf,'Children');
                graph=graphchild(5);
                graph.CLim=[-5 5];
                cb=graphchild(4);
                cb.YLim=[-5 5];
                cb.Children.YData=[-5 5];
                %saveas(gcf,fullfile(spectrogramfolder,[temptitle,'.jpeg']),'jpeg')
        %         saveas(gcf,fullfile(spectrogramfolder,[temptitle]),'epsc')
                %close all
    end
    
    %     Save tempphaseeg back to eegevents structure
    eegevents.trials.(fn{e})=tempphaseeg;
end

% Preprocessing step completion tag
eegevents.pipeline.FieldTrip=true;


% save(fullfile(analysisfolder,'EEGlab_power'),'eegevents','-v7.3');

end