function status=runEEGlab(sbj,opt)
try
    % Preprocess EEGLab (Epoch, Filter, ICA weights)
    eegevents_icarem=EEGLAB_preprocessing(sbj,opt);

    % Time Freq-Analysis (power)
    eegevents_tfa=EEGLAB_timefreq(eegevents_icarem,sbj,opt);

    % FieldTrip
    eegevents_ft=EEGLAB_imaginarycoh(eegevents_tfa,sbj,opt);
    
    status='complete';
    
    save(fullfile(opt.paths.protocolfolder,sbj,'analysis','EEGlab','EEGlab_Total'),'eegevents_icarem','eegevents_tfa','eegevents_ft','-v7.3');
catch ME
    status.message=ME.message;
    status.stack=ME.stack;
end

end

