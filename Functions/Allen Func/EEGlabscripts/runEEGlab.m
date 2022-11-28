function status=runEEGlab(sbj,protocolfolder,gitpath,save_procPipeline,manual,ica_auto)
try
    % Preprocess EEGLab (Epoch, Filter, ICA weights)
    eegevents_icarem=EEGLAB_preprocessing(sbj,protocolfolder,gitpath,save_procPipeline,manual,ica_auto);

%     % Time Freq-Analysis (power)
%     eegevents_tfa=EEGLAB_timefreq(eegevents_icarem);
% 
%     % FieldTrip
%     eegevents_ft=EEGLAB_imaginarycoh(eegevents_tfa);
%     
%     status='complete';
%     
%     save(fullfile(protocolfolder,sbj,'analysis','EEGlab','EEGlab_Total'),'eegevents_icarem','eegevents_tfa','eegevents_ft','-v7.3');
catch ME
    status.message=ME.message;
    status.stack=ME.stack;
end

end

