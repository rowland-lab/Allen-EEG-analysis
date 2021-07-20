Rowland_start
close all
clear all
clc

%% Define Subject info
subject='pro00087153_0002';
protocolfolder='C:\Users\allen\Box Sync\Desktop\Allen_Rowland_EEG\protocol_00087153';

% Define folders
subjectfolder=fullfile(protocolfolder,subject);
vrfolder=fullfile(subjectfolder,'vr');
eegfile=fullfile(subjectfolder,[subject,'.edf']);
analysisfolder=fullfile(subjectfolder,'analysis');
ft_folder='C:\Users\allen\Box Sync\Desktop\Functions\EEG_toolboxes\Matlab\fieldtrip-20200607';

trials={dir(fullfile(vrfolder,'TRIAL*')).name};
for t=1:numel(trials)
    trialfolders{t}=fullfile(vrfolder,trials{t});
end

% Load subject info (S1)
s1_info=load(fullfile(analysisfolder,'S1-VR_preproc',[subject,'_S1-VRdata_preprocessed.mat']));
sessioninfo=s1_info.sessioninfo;

% Load synced EEG and VR
trialData = loadVrTrialData_EEG_ftsync(trialfolders,eegfile,[],[],s1_info.sessioninfo.vrchan,ft_folder);

% % VR with preprocessed s1 VR trials
% trialData.vr=s1_info.preprocessed_vr;

% EEG info
eeginfo=trialData.eeg.header;
fs=eeginfo.Fs;

% Define reach types (type 1 ; type 2; type 3; type 4]
reach_types=[-0.1 -0.15 0.45;-0.1 0.05 0.45;0.1 0.05 0.45;0.1 -0.15 0.45];

% Define trials and remove stimulation trials
comptrial_idx=[1:numel(sessioninfo.trialnames)];
% comptrial_idx([2 3])=[];

%% Preprocess EEG data
% Add EEGlab
addpath('C:\Users\allen\Box Sync\Desktop\Functions\EEG_toolboxes\Matlab\eeglab-develop');
eeglab
close all

% Load EDF+ file
edf_file=eegfile;
EEG = pop_biosig(edf_file,'importevent','off','importannot','off');

% High Pass Filter at 1 Hz
EEG = pop_eegfilt( EEG, 1, 0, 10, 0, 0, 0, 'fir1',0);

% Load Channel Locations
EEG.chanlocs=pop_chanedit(EEG.chanlocs, 'load',{'C:\Users\allen\Box Sync\Desktop\Allen_Rowland_EEG\EEGLab\Electrode_Loc.ced', 'filetype', 'autodetect'}); 

% Remove Unused Channel data/locations
EEG.chanlocs([21 24:end])=[];
EEG.data([21 24:end],:)=[];
EEG.nbchan=numel(EEG.chanlocs);

% Find Bad Channels
originalEEG=EEG;
EEGremoval=clean_artifacts(EEG,'Highpass','off','BurstCriterion','off','WindowCriterion','off','WindowCriterionTolerances','off');

if isfield(EEGremoval.etc,'clean_channel_mask')
    % Fix EKG, VR, tDCS channel auto-rejection
    EEGremoval.etc.clean_channel_mask(22:end)=true;

    % Remove Bad Channels
    channels=(1:26);
    EEG=pop_select(EEG,'channel',channels(EEGremoval.etc.clean_channel_mask));

    % Interpolate channels
    EEG = pop_interp(EEG, originalEEG.chanlocs, 'spherical');
else
    EEG=EEGremoval;
end

% Re-Reference Data (average)
EEG=pop_reref(EEG,[],'exclude',23);

% Save to trialData structure
trialData.eeg.data=EEG.data';
trialData.eeg.channels=EEG.chanlocs;

% Save eeg structure
eegdat=trialData.eeg.data';
%% Compile data from all trials
for trl=1:numel(comptrial_idx)
    
    trial=comptrial_idx(trl);
    
	%%%%%%%%%%%%%%%%%%%%%%%%%% Organize VR reaches %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %%% Load VR info
    % Define trial folder
    wktrialfolder=fullfile(vrfolder,trials{trial});
    wkposfolder=fullfile(wktrialfolder,'Data');
    wkeventfolder=fullfile(wktrialfolder,'Events');
    wktrialinfofolder=fullfile(wktrialfolder,'trial information.xml');

    % Load trial info
    trialinfo=xml2struct(wktrialinfofolder);

    % Find reach side
    testside=trialinfo.TrialInformation.testedSide.Text;

    % Load VR xyz velocity data
    pos_dat=readtable(wkposfolder);

    % Load Event data
    opts=detectImportOptions(wkeventfolder);
    opts.VariableTypes{4}='char';
    event_dat=readtable(fullfile(wktrialfolder,'Events'),opts);
    
    % Sort Event data
    clearvars event_dat_temp
    for ev=1:size(event_dat,1)
        switch event_dat.Event{ev}
            case 'atStartPosition'
                event_dat_temp(ev,:)=table2cell(event_dat(ev,:)); 
            case 'cueEvent'
                event_dat_temp(ev,:)=table2cell(event_dat(ev,:)); 
            case 'targetUp'
                event_dat_temp(ev,:)=table2cell(event_dat(ev,:)); 
            case 'targetHit'
                event_dat_temp(ev,:)=table2cell(event_dat(ev,:)); 
            case 'outsideStartPosition'   
                event_dat_temp(ev,:)=table2cell(event_dat(ev,:)); 
        end
    end
    event_dat_temp=event_dat_temp(~all(cellfun('isempty',event_dat_temp),2),:);
    
    % Remove Outside Start Position events and associate events
    osp_idx=find(cellfun(@(x) strcmp('outsideStartPosition',x),event_dat_temp(:,3)));

    rm_idx=[];
    for osp=1:numel(osp_idx)
        switch event_dat_temp{osp_idx(osp)-1,3}
            case 'atStartPosition'
                rm_idx=[rm_idx;osp_idx(osp)-1];
            case 'cueEvent'
                rm_idx=[rm_idx;osp_idx(osp)-1;osp_idx(osp)-2];
        end
    end
    event_dat_temp([osp_idx;rm_idx],:)=[];
    
    % Check for premature stopping
    if ~strcmp(event_dat_temp{end,3},'targetHit')
        switch event_dat_temp{end,3}
            case 'atStartPosition'
                event_dat_temp(end,:)=[];
            case 'cueEvent'
                event_dat_temp(end-1:end,:)=[];
            case 'targetUp'
                event_dat_temp(end-2:end,:)=[];
        end
    end
    
    % Find number of total reaches
    treach_idx=~cellfun(@isempty,regexp([event_dat.EventData],'C'));
    treach_num=sum(treach_idx)/2;

    % Find xyz trace of each reach
    reachdat=[];
    for re=1:treach_num
        % Find reach idx
        reach_ii=find(~cellfun(@isempty,regexp([event_dat.EventData],['C',num2str(re)])));

        % Find reach start/end time
        reach_st=event_dat.Time((reach_ii(1)));
        reach_et=event_dat.Time((reach_ii(2)));

        % Position time idx
        reach_times_idx=pos_dat.Time>=reach_st & pos_dat.Time<=reach_et;
        reach_times=pos_dat.Time(reach_times_idx);

        % Detemine which side variables to take
        switch testside
            case 'right'
                sidename='RightHand';
            case 'left'
                sidename='LeftHand';
        end

        % Extract xyz position of reach
        reach_x=pos_dat.([sidename,'X'])(reach_times_idx);
        reach_y=pos_dat.([sidename,'Y'])(reach_times_idx);
        reach_z=pos_dat.([sidename,'Z'])(reach_times_idx);
        
        % Extract xyz velocity of reach
        reach_vx=pos_dat.([sidename,'VX'])(reach_times_idx);
        reach_vy=pos_dat.([sidename,'VY'])(reach_times_idx);
        reach_vz=pos_dat.([sidename,'VZ'])(reach_times_idx);
        
        % Calculate vector velocity of reach
        reach_vecv=sqrt(reach_vx.^2+reach_vy.^2+reach_vz.^2);
        
        % Calculate max vector velocity
        max_v=max(reach_vecv);
        
        % Calculate reaction time via threshold (start at 20% threshold)
        cal_rec=true;
        thres=0.2;
        
        while cal_rec
            max_v_thres=max_v*thres;
            reactiontime_idx=find(reach_vecv>max_v_thres,1);

            % Back track to start of movement
            for i=reactiontime_idx:-1:1
                if reach_vecv(i)<=max_v*0.05
                    reactiontime_idx_start=i;
                    cal_rec=false;
                    break
                end
                if i==1
                    thres=thres+0.1;
                end
            end            
        end
            
        % Calculate reaction time in seconds
        reactiontime=reach_times(reactiontime_idx_start)-reach_times(1);
        
        figure
        plot(reach_vecv)
        hold on
        plot(reactiontime_idx,reach_vecv(reactiontime_idx),'o')
        plot(reactiontime_idx_start,reach_vecv(reactiontime_idx_start),'x')

        
        
        % Find which reach type
        endpos=[reach_x(end),reach_y(end),reach_z(end)];

        [~,reach_type]=min([sum(abs(endpos-reach_types(1,:)));...
            sum(abs(endpos-reach_types(2,:)));...
            sum(abs(endpos-reach_types(3,:)));...
            sum(abs(endpos-reach_types(4,:)))]);

        % Save position data (adjusted for reaction time)
        reachdat{re,1}=reach_x(reactiontime_idx:end);
        reachdat{re,2}=reach_y(reactiontime_idx:end);
        reachdat{re,3}=reach_z(reactiontime_idx:end);
        
        % Save velocity data (adjusted for reaction time)
        reachdat{re,4}=reach_vx(reactiontime_idx:end);
        reachdat{re,5}=reach_vy(reactiontime_idx:end);
        reachdat{re,6}=reach_vz(reactiontime_idx:end);
        
        % Save Vector velocity data
        reachdat{re,7}=sqrt(reachdat{re,4}.^2+reachdat{re,5}.^2+reachdat{re,6}.^2);

        % Save trial number
        reachdat{re,8}=trial;
        
        % Save reach number
        reachdat{re,9}=re;
        
        % Save reach type
        reachdat{re,10}=reach_type;
        
    end
    art_temp.vr{trl,1}=reachdat;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%% Organize EEG data %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Epoch Reach events

    % Sort times
    epochs_temp=[];
    for t=1:length(trialData.vr(trial).events.all.all)
        switch trialData.vr(trial).events.all.all{t}
            case 'atStartPosition'
                epochs_temp{t,1}=trialData.vr(trial).events.all.name{t,1}; 
                epochs_temp{t,2}=trialData.vr(trial).events.all.time(t,1);       
            case 'cueEvent'
                epochs_temp{t,1}=trialData.vr(trial).events.all.name{t,1}; 
                epochs_temp{t,2}=trialData.vr(trial).events.all.time(t,1);
            case 'targetUp'
               epochs_temp{t,1}=trialData.vr(trial).events.all.name{t,1}; 
               epochs_temp{t,2}=trialData.vr(trial).events.all.time(t,1);
            case 'targetHit'
                epochs_temp{t,1}=trialData.vr(trial).events.all.name{t,1}; 
                epochs_temp{t,2}=trialData.vr(trial).events.all.time(t,1);
            case 'outsideStartPosition'   
               epochs_temp{t,1}=trialData.vr(trial).events.all.name{t,1}; 
               epochs_temp{t,2}=trialData.vr(trial).events.all.time(t,1);
        end
    end
    epochs_temp=epochs_temp(~all(cellfun('isempty',epochs_temp),2),:);

    % Remove Outside Start Position events and associate events
    osp_idx=find(cellfun(@(x) strcmp('outsideStartPosition',x),epochs_temp(:,1)));

    rm_idx=[];
    for osp=1:numel(osp_idx)
        switch epochs_temp{osp_idx(osp)-1,1}
            case 'atStartPosition'
                rm_idx=[rm_idx;osp_idx(osp)-1];
            case 'cueEvent'
                rm_idx=[rm_idx;osp_idx(osp)-1;osp_idx(osp)-2];
        end
    end
    epochs_temp([osp_idx;rm_idx],:)=[];
    
    % Check for premature stopping
    if ~strcmp(epochs_temp{end,1},'targetHit')
        switch epochs_temp{end,1}
            case 'atStartPosition'
                epochs_temp(end,:)=[];
            case 'cueEvent'
                epochs_temp(end-1:end,:)=[];
            case 'targetUp'
                epochs_temp(end-2:end,:)=[];
        end
    end
    
    % Check if VR events and EEG events are the same
    if size(event_dat_temp,1)~=size(epochs_temp,1)
        clc
        disp('ERROR')
        return
    end
    
    % Find event idx
    tu_idx=find(cellfun(@(x) strcmp('targetUp',x),epochs_temp(:,1)));
    th_idx=find(cellfun(@(x) strcmp('targetHit',x),epochs_temp(:,1)));
    asp_idx=find(cellfun(@(x) strcmp('atStartPosition',x),epochs_temp(:,1)));

    % Extension times (adjusted for reaction time)
    clearvars ext_times
    ext_times(:,1)=epochs_temp(tu_idx,2);
    ext_times(:,2)=epochs_temp(th_idx,2);
    ext_times=cell2mat(ext_times)*fs;
    
    % Adjust Extension times with reaction time
    ext_times(:,1)=ext_times(:,1)+reactiontime*1024;

%     % Retraction times
%     clearvars ret_times
%     ret_times(:,1)=epochs_temp(th_idx(1:end-1),2);
%     ret_times(:,2)=epochs_temp(asp_idx(2:end),2);
%     ret_times=cell2mat(ret_times)*fs;
%     
    % Find extension epoch
    ext_epoch=[];
    for re=1:size(ext_times,1)
        ext_epoch{re,1}=eegdat(:,ext_times(re,1):ext_times(re,2));
    end
    
%     % Find retraction epoch
%     ret_epoch=[];
%     for re=1:size(ret_times,1)
%         ret_epoch{re,1}=eegdat(:,ret_times(re,1):ret_times(re,2));
%     end

    % Save data
    art_temp.eeg.times{trial,1}=ext_times;
%     art_temp.eeg.times{trial,2}=ret_times;
    
    art_temp.eeg.data{trial,1}=[ext_epoch,num2cell(ones(size(ext_epoch,1),1)*trial),num2cell(1:size(ext_epoch,1))'];
%     art_temp.eeg.data{trial,2}=[ret_epoch,num2cell(ones(size(ret_epoch,1),1)*trial),num2cell(1:size(ret_epoch,1))'];
end
%% Time Warp

% Load type data
vrdata=vertcat(art_temp.vr{:});

% Load extension EEG data
eeg_extdata=art_temp.eeg.times(:,1);
eeg_extdata=vertcat(eeg_extdata{:});

% Plot original reaches
figure
hold on
for rc=1:size(vrdata,1)
    xplot=vrdata{rc,1};
    yplot=vrdata{rc,2};
    zplot=vrdata{rc,3};
    plot3(xplot,yplot,zplot);
end

% Calculate each reach
% 1:size(reach_types,1)

for rt=4
    % Organize VR data
    rt_idx=cellfun(@(x) x==rt,vrdata(:,10));
    rt_vr=vrdata(rt_idx,:);
        
    rt_dat_raw=rt_vr;
    
    
    % Grab EEG data (extension)
    eegext=art_temp.eeg.data(:,1);
    eegext=vertcat(eegext{:});
    
    % Match EEG data to VR reaches
    eegtype=[];
    for i=1:size(rt_vr,1)
        trialnum=rt_vr{i,8};
        reachnum=rt_vr{i,9};
        idx=cellfun(@(x) x==trialnum,eegext(:,2)) & cellfun(@(x) x==reachnum,eegext(:,3));
        eegtype{i,1}=eegext{idx,1};
    end
    
    % Combine VR and EEG data
    rt_eegvr=[rt_vr eegtype];
    
    % Match sampling rate of VR and EEG (upsample VR)
    for r=1:size(rt_eegvr,1)
        tempreach=rt_eegvr(r,:);
        
        % For pos(x,y,z) and vel(x,y,z,vector)
        for i=1:7
            vrtemp=tempreach{i};
            eegtemp=tempreach{11};
        
            % Find sampling rates (assuming each trial is 1 second)
            vrsamples=size(vrtemp,1);
            eegsamples=size(eegtemp,2);
        
            % Pad VR data (due to edge aritfacts)
            xpad = [repmat(vrtemp(1), 1, 100), vrtemp',repmat(vrtemp(end), 1, 100)];
            
            % Resample
            ypad = resample(xpad,eegsamples,vrsamples);
            
            % Remove padding
            padresample=(length(ypad)-eegsamples)/2;
            rs=ypad(padresample+1:end-padresample);
            tempreach{i}=rs;
        end
        
        % Save back to structure
        rt_eegvr(r,:)=tempreach;
    end

    
    % Find longest reach
    [max_sample,max_idx]=max(cellfun(@numel,rt_eegvr(:,1)));
    lreachdat=rt_eegvr(max_idx,:);
    
    % Time warp rest of reaches to longest reach (reference is vector
    % velocity)
    reversemat=[];
    for rc=1:size(rt_eegvr,1)
    
        % Calculate longest reach Vector Velocity
        v1=lreachdat{7};

        % Calculate vector velocity of reach being transformed
        v2=rt_eegvr{rc, 7};
        
        % Calculate Timewarp matrix
        [~,vt1,vt2]=dtw(v1,v2,1);
        
        % Check to see correctly dtw
        if numel(vt1)>max_sample
            for i=1:max_sample
                if vt1(i)==i
                else
                    vt1(i)=[];
                    vt2(i)=[];
                end
            end
        end

        % Calculate reverse matrix
        rw=[];
        for i=1:numel(vt2)
            rw=[rw find(vt2==i,1,'first')];
        end
        reversemat{rc}=rw;
        
        % Apply TW matrix to VR measures
        rt_eegvr{rc, 1}=rt_eegvr{rc, 1}(vt2);
        rt_eegvr{rc, 2}=rt_eegvr{rc, 2}(vt2);
        rt_eegvr{rc, 3}=rt_eegvr{rc, 3}(vt2);
        rt_eegvr{rc, 4}=rt_eegvr{rc, 4}(vt2);
        rt_eegvr{rc, 5}=rt_eegvr{rc, 5}(vt2);
        rt_eegvr{rc, 6}=rt_eegvr{rc, 6}(vt2);
        rt_eegvr{rc, 7}=rt_eegvr{rc, 7}(vt2);
    end
    
    % Correlate reaches by xyz velocity
    rt_corr_x=abs(corrcoef(vertcat(rt_eegvr{:,4})'));
    rt_corr_y=abs(corrcoef(vertcat(rt_eegvr{:,5})'));
    rt_corr_z=abs(corrcoef(vertcat(rt_eegvr{:,6})'));
    
    
    % Find average correlation coefficient for each reach
    rt_corr_mean=mean(vertcat(rt_corr_x,rt_corr_y,rt_corr_z));
    
    % Find the top 6 correlations
    [~,rt_corr_mean_sort_idx]=sort(rt_corr_mean,'descend');
    rt_corr_top=rt_corr_mean_sort_idx(1:6);
    
    % Plot reaches
    figure
    hold on
    for rc=1:size(rt_eegvr,1)
        xplot=rt_eegvr{rc,1};
        yplot=rt_eegvr{rc,2};
        zplot=rt_eegvr{rc,3};
        p3=plot3(xplot,yplot,zplot);
        if any(rc==rt_corr_top)
            p3.LineWidth=2;
        end
    end
    legend
    
    % Reverse Time warp VR measures
    for rc=1:size(rt_eegvr,1)
        rt_eegvr{rc,1}=rt_eegvr{rc,1}(reversemat{rc});
        rt_eegvr{rc,2}=rt_eegvr{rc,2}(reversemat{rc});
        rt_eegvr{rc,3}=rt_eegvr{rc,3}(reversemat{rc});
        rt_eegvr{rc,4}=rt_eegvr{rc,4}(reversemat{rc});
        rt_eegvr{rc,5}=rt_eegvr{rc,5}(reversemat{rc});
        rt_eegvr{rc,6}=rt_eegvr{rc,6}(reversemat{rc});
        rt_eegvr{rc,7}=rt_eegvr{rc,7}(reversemat{rc});
    end
    
    % Only save top correlated reaches
    rt_eegvr_top=rt_eegvr(rt_corr_top,:);
    
    % Time-Freq Analysis calculation on raw EEG
    fs=1024;
    
    tf_analysis=[];
    for i=1:size(rt_eegvr_top,1)
        tempeeg=rt_eegvr_top{i,11};
        for cn=1:size(tempeeg,1)
            [s,f,t]=spectrogram(tempeeg(cn,:),100,[],[],fs);
            tf_analysis{i,1}{cn}={log(abs(s)),f,t};
        end
    end
    
    % Time warp EEG based on vector velocity
    
    % Normalize vector velocity
    for i=1:size(rt_eegvr_top,1)
        rt_eegvr_top{i,7}=mat2gray(rt_eegvr_top{i,7});
    end
    
    
    % Find longest reach
    [max_sample,max_idx]=max(cellfun(@numel,rt_eegvr_top(:,1)));
    lreachdat=rt_eegvr_top(max_idx,:);
    
    reversemat=[];
    rt_eegvr_top_tw=[];
    for rc=1:size(rt_eegvr_top,1)
    
        % Calculate longest reach Vector Velocity
        v1=lreachdat{7};

        % Calculate vector velocity of reach being transformed
        v2=rt_eegvr_top{rc, 7};
        
        % Calculate Timewarp matrix
        [~,vt1,vt2]=dtw(v1,v2,1);
        
        % Check to see correctly dtw
        if numel(vt1)>max_sample
            for i=1:max_sample
                if vt1(i)==i
                else
                    vt1(i)=[];
                    vt2(i)=[];
                end
            end
        end
        
        % Calculate reverse matrix
        rw=[];
        for i=1:numel(vt2)
            rw=[rw find(vt2==i,1,'first')];
        end
        reversemat{rc}=rw;
        
        
        % Apply TW matrix to EEG
        rt_eegvr_top_tw{rc,1}=rt_eegvr_top{rc, 11}(:,vt2);
        rt_eegvr_top_tw{rc,2}=rt_eegvr_top{rc, 7}(:,vt2);
    end
    
    figure;
    subplot(2,1,1)
    hold on
    for i=1:size(rt_eegvr_top,1)
        plot(rt_eegvr_top{i,7})
    end
    
    subplot(2,1,2)
    hold on
    for i=1:size(rt_eegvr_top_tw,1)
        plot(rt_eegvr_top_tw{i,2})
    end
    
    
    
    
    figure;
    subplot(2,1,1)
    hold on
    for i=1:size(rt_eegvr_top,1)
        plot(rt_eegvr_top{i,11}(13,:))
    end
    subplot(2,1,2)
    hold on
    for i=1:size(rt_eegvr_top_tw,1)
        plot(rt_eegvr_top_tw{i}(13,:))
    end
    
    % Calculate reach EEG template using top correlated reaches
    eeg_template=median(cell2mat(permute(rt_eegvr_top_tw,[2,3,1])),3);
    
    % Normalize EEG template
    bleeg_template=eeg_template(:,1);
    for i=1:size(eeg_template,2)
        eeg_template(:,i)=eeg_template(:,i)-bleeg_template;
    end
        
    % Subtract EEG template from each EEG reach
    eegtype_tw_removed=cellfun(@(x) x-eeg_template,rt_eegvr_top_tw,'UniformOutput',false);
    
    % Reverse timewarp
    eegtype_tw_removed_rtw=[];
    for en=1:size(eegtype_tw_removed,1)
        eegtype_tw_removed_rtw{en,1}=eegtype_tw_removed{en,1}(:,reversemat{en});
    end


    % Apply time freq after artifact subtraction
    WINDOW=60; 
    NOVERLAP=50;
    NFFT=200;
    fs=1024;
    
    tf_analysis_removed=[];
    for i=1:size(eegtype_tw_removed_rtw,1)
        tempeeg=eegtype_tw_removed_rtw{i};
        for cn=1:size(tempeeg,1)
            [s,f,t]=spectrogram(tempeeg(cn,:),100,[],[],fs);
            tf_analysis_removed{i,1}{cn}={log(abs(s)),f,t};
        end
    end

    % Combined all data structures
    timewarpprocessed.(['type',num2str(rt)]).data=[rt_eegvr_top tf_analysis eegtype_tw_removed_rtw tf_analysis_removed];
    timewarpprocessed.(['type',num2str(rt)]).template=eeg_template;
end

%% Compare data
typedata='type2';
compcn=[12];
reachnum=1;


tempdata=timewarpprocessed.(typedata).data(reachnum,:);
templatedata=timewarpprocessed.(typedata).template{reachnum,:};

[norm_fft,norm_fft_freq]=pwelch(tempdata{11}(compcn,:),100,[],[],1024);
[remove_fft,remove_fft_freq]=pwelch(tempdata{13}(compcn,:),100,[],[],1024);


figure;

sgtitle([typedata,' reach; ','Reach number (',num2str(reachnum),'); channel ',num2str(compcn)])

subplot(6,1,1)
hold on
plot(tempdata{1})
plot(tempdata{2})
plot(tempdata{3})
xlim([0 numel(tempdata{1})])
ylabel('position')
xlabel('samples')
legend({'x','y','z'})
title('Positional Data')

subplot(6,1,2)
hold on
plot(tempdata{4})
plot(tempdata{5})
plot(tempdata{6})
xlim([0 numel(tempdata{4})])
ylabel('velocity (m/s)')
xlabel('samples')
legend({'x','y','z'})
title('Velocity Data')

subplot(6,1,3)
plot(tempdata{7})
xlim([0 numel(tempdata{7})])
ylabel('velocity (m/s) position')
xlabel('samples')
title('Vector Velocity Data')

subplot(6,1,4)
plot(mean(templatedata(compcn,:),1))
title('Artifact template')
xlim([0 size(mean(templatedata(compcn,:),1),2)])

subplot(6,1,5)
hold on
plot(mean(tempdata{11}(compcn,:),1))
plot(mean(tempdata{13}(compcn,:),1))
legend({'Original','Template Removed'})
xlim([0 size(tempdata{11},2)])

subplot(6,1,6)
hold on
plot(norm_fft_freq,log(norm_fft));
plot(norm_fft_freq,log(remove_fft));
legend({'Original','Template Removed'})
xlim([0 100])
xlabel('Frequency')
ylabel('Log Power')










%%

figure;

sgtitle([typedata,' reach; channel ',num2str(compcn)])

subplot(5,1,1)
hold on
plot(tempdata{1})
plot(tempdata{2})
plot(tempdata{3})
xlim([0 numel(tempdata{1})])
ylabel('position')
xlabel('samples')
legend({'x','y','z'})
title('Positional Data')

subplot(5,1,2)
hold on
plot(tempdata{4})
plot(tempdata{5})
plot(tempdata{6})
xlim([0 numel(tempdata{4})])
ylabel('velocity (m/s) position')
xlabel('samples')
legend({'x','y','z'})
title('Velocity Data')

subplot(5,1,3)
plot(vec_velocity)
xlim([0 numel(vec_velocity)])
ylabel('velocity (m/s) position')
xlabel('samples')
title('Vector Velocity Data')

subplot(5,1,4)
pc=pcolor(t,f(targetfreqidx),s(targetfreqidx,:));
pc.FaceColor = 'interp';
colormap(jet)
ylabel('Frequency')
xlabel('seconds')
title('Time-Freq raw')

subplot(5,1,5)
pc=pcolor(tr,fr(targetfreqidx),sr(targetfreqidx,:));
pc.FaceColor = 'interp';
colormap(jet)
ylabel('Frequency')
xlabel('seconds')
title('Time-Freq template removed')

