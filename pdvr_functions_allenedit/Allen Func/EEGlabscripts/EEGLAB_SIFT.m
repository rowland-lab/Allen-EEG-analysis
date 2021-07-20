function EEGLAB_SIFT(subject,protocolfolder)

subjectfolder=fullfile(protocolfolder,subject);
analysisfolder=fullfile(subjectfolder,'analysis','EEGlab');

% Import EEG structures
import=load(fullfile(analysisfolder,'EEGlab_power.mat'));
eegepochs=import.eegepochs;

fn=fieldnames(eegepochs);
for i=1:numel(fn)
    for p=1:3
        wkEEG=eegepochs.(fn{i})(p);

        % Preprocess
        wkEEG = pre_prepData(wkEEG,'SignalType','Channels');
        
        % Test model orders/Window times
        modelorderselection=est_selModelOrder(wkEEG);
        maxmodelorder=max(modelorderselection.fpe.popt);
        
        modelorders=[maxmodelorder-4:maxmodelorder+4];
        windowlengths=[0.25 0.3 0.35 0.4 0.45 0.5];

        stab.white=nan(numel(modelorders),numel(windowlengths));
        stab.PC=nan(numel(modelorders),numel(windowlengths));
        stab.stability=nan(numel(modelorders),numel(windowlengths));
        for mo=1:numel(modelorders)
            for wl=1:numel(windowlengths)
                try
                    wkEEG.CAT.MODEL = est_fitMVAR(wkEEG,'ModelOrder',modelorders(mo),'WindowLength',windowlengths(wl));
                    [whitestats,PC,stability]=est_validateMVAR(wkEEG);
                    stab.white(mo,wl)=(sum(whitestats.ljungbox.w)+sum(whitestats.acf.w)+sum(whitestats.boxpierce.w)+sum(whitestats.limcleod.w))/(numel(whitestats.ljungbox.w)+numel(whitestats.acf.w)+numel(whitestats.boxpierce.w)+numel(whitestats.limcleod.w));
                    stab.PC(mo,wl)=mean(PC.PC);
                    stab.stability(mo,wl)=sum(stability.stability)/numel(stability.stability);
                catch
                    continue
                end
                close all
            end
        end
        
        % Find ideal model order and window length
        cumulativescore=mat2gray(stab.white)+mat2gray(stab.PC)+mat2gray(stab.stability);
        max_score=max(cumulativescore,[],'all');
        [modelorder windowlength]=find(cumulativescore==max_score);
        
        % Apply model order and window length
        wkEEG.CAT.MODEL = est_fitMVAR(wkEEG,'ModelOrder',modelorders(modelorder),'WindowLength',windowlengths(windowlength));

        % Find Imaginary Coherence
        cfg.connmethods={'iCoh'};
        wkEEG.CAT.Conn = est_mvarConnectivity(wkEEG,wkEEG.CAT.MODEL,cfg);   

        eegconnectivity.(fn{i})(p)=wkEEG;
    end
end

save(fullfile(analysisfolder,'EEGlab_connectivity'),'eegconnectivity');

end