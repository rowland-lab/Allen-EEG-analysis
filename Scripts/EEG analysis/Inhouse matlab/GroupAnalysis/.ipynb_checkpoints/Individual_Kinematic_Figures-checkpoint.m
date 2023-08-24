clear all
clc

gitpath = 'C:\Users\allen\Documents\GitHub\Allen-EEG-analysis';
cd(gitpath)
allengit_genpaths(gitpath,'tDCS')

% Grab matlab

%%
for sub=1:numel(sbj)
    
    wk_sbjfolder=fullfile(protocolfolder,sbj{sub});
    
    % Load S1 Data
    s1_file=fullfile(wk_sbjfolder,'analysis','S1-VR_preproc',[sbj{sub},'_S1-VRdata_preprocessed.mat']);
    if exist(s1_file)==0
        disp(['Preprocessing file is missing on ',sbj{sub}]);
        continue
    end
    disp(['Loading s1 data...',sbj{sub}]);
    s1_dat=load(fullfile(wk_sbjfolder,'analysis','S1-VR_preproc',[sbj{sub},'_S1-VRdata_preprocessed.mat']));
    sessioninfo=s1_dat.sessioninfo;
    
    % Load S2 data
    disp(['Loading s2 data...',sbj{sub}]);
    s2_dat=load(fullfile(wk_sbjfolder,'analysis','S2-metrics',[sbj{sub},'_S2-Metrics.mat']));
    temp_metric=s2_dat.metricdat;
    
    % Save VR data
    disp(['Calculating VR metrics...',sbj{sub}]);

    metricdat.data(sub,:)=temp_metric.data;
    metricdat.label=temp_metric.label;
    metricdat.dx{sub,1}=sessioninfo.dx;
    metricdat.trial(sub,:)=sessioninfo.trialidx;
    metricdat.stim(sub,:)=sessioninfo.stimamp;
    metricdat.units={'time [s]' 'hand path length[m]' 'Average Velocity [m/s]' '|V| [m/s]' 'peaks []' 'time [s]' '% movement []' 'Average Acceleration [m/s^2]' 'Max Acceleration [m/s^2]' 'accuracy score [1/mm]' 'normalized jerk []' 'IOC []' 'straight line distance[m]'};
end
%%
dx_type={'stroke','pd','healthy'};
stim_type={0,2};
metric=metricdat.label;


temp_xml=[];
tempnames=[];
for d=[1 3]

    % Create figure
    figure

    bardat=nan(10,2);
    inputmat=[];
    
    for stim=1:numel(stim_type)

        % Obtain dx idx
        dx_idx=strcmp(metricdat.dx,dx_type{d});

        % Obtain stim idx
        stim_idx=metricdat.stim==stim_type{stim};

        % Subject Idx
        subj_idx=dx_idx&stim_idx;

        % Subject names
        subjectnames=sbj_label(subj_idx);

        % Obtain 10 data
        tempmetricdat=metricdat.data(subj_idx,10);


        % Obtain trial data
        temptrial=metricdat.trial(subj_idx,:);

        % Allocate tempdat
        tempdat=nan(sum(subj_idx),7);

        % Reorganize based on trial times
        for s=1:size(tempmetricdat,1)

            % Trial idx
            temptrialidx=~cellfun(@isempty,temptrial(s,:));

            % Save tempdat
            tempdat(s,temptrialidx)=tempmetricdat{s};
        end

        % only take base, intra 5, intra 15, post 5,
        tempdat=tempdat(:,[1:3 5]);
        hold on
        if stim == 1
            plot(tempdat','-o')
        else
            plot(tempdat','--square')
        end
    end

    ylim([0 22])
    xlim([0 5])
    % Title figure
    sgtitle(dx_type{d})
end