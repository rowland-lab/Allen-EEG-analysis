%% replay data collection

function S4_Reconstruction(subjectName,protocol_folder,positionalplot,eegplot,tfplot,metricplot,metriccurves,trial_num)
%% Generate variables
subjectFolder=fullfile(protocol_folder,subjectName);


% Import S1 preprocessed data
try
    disp('Importing S1 data')
    s1=load(fullfile(subjectFolder,'analysis','S1-VR_preproc',[subjectName,'_S1-VRdata_preprocessed.mat']));
    fs=s1.trialData.eeg.header.samplingrate;
catch
    error('Step 1 Preprocessing files NOT FOUND')
end

% Import S2 preprocessed data
try
    disp('Importing S2 data')
    s2=load(fullfile(subjectFolder,'analysis','S2-metrics',[subjectName,'_S2-Metrics.mat']));
catch
    error('Step 2 Preprocessing files NOT FOUND')
end

% Import S3 preprocessed data
try
    disp('Importing S3 data')
    s3=load(fullfile(subjectFolder,'analysis','S3-EEGanalysis','s3_dat.mat'));
catch
    error('Step 3 Preprocessing files NOT FOUND')
end

% Define folders
eegfile=s1.sessioninfo.path.edffile;
reconFolder=fullfile(subjectFolder,'analysis','S4-Reconstruction');


% Make reconstruction folder
mkdir(reconFolder)


if isempty(trial_num)
    disp('Specific Trial Not selected. Running recon on all trials')
    trial_num=1:numel(s1.trialData.vr);
end

%% Start Looping through all trials
for trials=trial_num
    
    trialFolder = fullfile(subjectFolder,'vr',s1.trialData.vr(trials).information.trialName);
    addVideo = false;
    videoFile = '';
    videoFiles = dir(fullfile(trialFolder,'Camera Recording *.mp4'));
    if ~isempty(videoFiles)
        addVideo = true;
        videoFile = fullfile(trialFolder,videoFiles(1).name);
    end

    %% load data

    % load trial information
    trialInfoFile = fullfile(trialFolder,'trial information.xml');
    trialInformation = parseXML(trialInfoFile);
    trialInformation = trialInformation.TrialInformation;

    % load data
    dataFile = fullfile(trialFolder,'Data.csv');
    eventsFile = fullfile(trialFolder,'Events.csv');
    trialData = s1.trialData;
    trackerData = trialData.vr(trials).tracker;
    
   
    % get tested side
    testedSide = lower(trialInformation.testedSide);

    % scan image files
    imageFolder = fullfile(trialFolder,'User View Screenshots');
    if ~exist(imageFolder,'dir')
        disp([trialName_dir{trials},' User View Screenshots NOT detected'])
         continue
    end

    imageFiles = dir(fullfile(imageFolder,'frame *.png'));
    imageFiles = {imageFiles.name};

    imageFrame = zeros(1,length(imageFiles));
    for i = 1:length(imageFiles)
        [~, imageName] = fileparts(imageFiles{i});
        p = strsplit(imageName,' ');
        imageFrame(i) = str2double(p{2});
    end
    imageFrame = sort(imageFrame);

    %% replay

    if addVideo

        scale = 0.85;

        reader = VideoReader(videoFile);

        replayWidth = 1024;
        replayHeight = 768;
        webcamHeight = replayHeight * scale;
        webcamWidth = round(reader.Width * webcamHeight/reader.Height);

        % set up replay figure
        rFig = figure('Name',[subjectName,'          ',s1.sessioninfo.trialnames{trials}]);
        rFig.Color = [0 0 0]; % black background
        rFig.Units = 'pixels';
        rFig.Position = [20 100 webcamWidth+replayWidth replayHeight];

        wAx = axes('parent',rFig);

        fullwidth = webcamWidth/(webcamWidth+replayWidth);
        width = fullwidth;
        height = scale;
        wAx.Position = [0 1-height width height];
        wAx.Visible = 'off';

        rAx = axes('parent',rFig);

        fullwidth = replayWidth/(webcamWidth+replayWidth);
        width = scale * fullwidth;
        height = scale;
        rAx.Position = [1-fullwidth 1-height width height];
        rAx.Visible = 'off';

        if positionalplot
            plotAx = axes('parent',rFig);
            plotAx.Position = [1-fullwidth*.3 0.1 0.4*fullwidth 0.44];
        end
        
    else

        reader = [];

        % set up replay figure
        rFig = figure('Name',[subjectName,'          ',s1.sessioninfo.trialnames{trials}]);
        rFig.Color = [0 0 0]; % black background
        rFig.Units = 'pixels';
        rFig.Position = [20 100 1024 768];

        wAx = [];

        rAx = axes('parent',rFig);
        scale = 0.85;
        width = scale;
        height = width*rFig.Position(3)/1024 * 768/rFig.Position(4);
        rAx.Position = [0 1-height width height];
        rAx.Visible = 'off';
        
        if positionalplot
            plotAx = axes('parent',rFig);
            plotAx.Position = [0.59 0.06 0.4 0.44];    
        end
    end

    if positionalplot
        xmax = max(trackerData.p.(testedSide)(:,1));
        ymax = max(trackerData.p.(testedSide)(:,2));
        zmax = max(trackerData.p.(testedSide)(:,3));
        xmin = min(trackerData.p.(testedSide)(:,1));
        ymin = min(trackerData.p.(testedSide)(:,2));
        zmin = min(trackerData.p.(testedSide)(:,3));
        delta = 0.05; %m
        axis(plotAx,'equal')
        plotAx.XLim = [xmin-delta xmax+delta];
        plotAx.ZLim = [ymin-delta ymax+delta];
        plotAx.YLim = [zmin-delta zmax+delta];


        pathPlot = plot3(plotAx,mean(trackerData.p.(testedSide)(:,1)),mean(trackerData.p.(testedSide)(:,3)),mean(trackerData.p.(testedSide)(:,2)),'k');
        hold(plotAx,'on')
        pathMarker = plot3(plotAx,mean(trackerData.p.(testedSide)(:,1)),mean(trackerData.p.(testedSide)(:,3)),mean(trackerData.p.(testedSide)(:,2)),'ro','markerfacecolor','r');
        xlabel(plotAx,'x [m]')
        ylabel(plotAx,'z [m]')
        zlabel(plotAx,'y [m]')
        plotAx.XColor = [1 1 1];
        plotAx.YColor = [1 1 1];
        plotAx.ZColor = [1 1 1];
        plotAx.GridColor='k';
        plotAx.LineWidth=2;
        grid(plotAx, 'on')
    end

    if eegplot
        % start and stop events
        tStart = trialData.vr(trials).events.start.time;
        tStop = trialData.vr(trials).events.stop.time;
     

        % Plot eeg
        
        eegtime=trackerData.time.*fs;

        eegAx = axes('parent',rFig);
        eegAx.Position = [1-fullwidth*1.2 .70 0.2 0.2330];
        eegAx.Visible = 'on';


       
        cn7=plot(eegtime(1):eegtime(end),(s1.trialData.eeg.data(eegtime(1):eegtime(end),7)-mean(s1.trialData.eeg.data(eegtime(1):eegtime(end),7)))/std(s1.trialData.eeg.data(eegtime(1):eegtime(end),7))); hold on;
        cn18=plot(eegtime(1):eegtime(end),(s1.trialData.eeg.data(eegtime(1):eegtime(end),18)-mean(s1.trialData.eeg.data(eegtime(1):eegtime(end),18)))/std(s1.trialData.eeg.data(eegtime(1):eegtime(end),18))-20); hold on;
       
        set(eegAx,'ylim',[-30 10])

        % EEG TimeStamps
        yl = get(gca,'ylim');
        textpos=abs(max(s1.trialData.eeg.data(eegtime(1):eegtime(end),7)/max(s1.trialData.eeg.data(eegtime(1):eegtime(end),7))));
        textpos=-10;
        hold on
        s1_line = plot(tStart*[1 1]*fs,yl,'m-.','linewidth',2);
        s1_text=text(tStart*fs,textpos,'START');
        set (s1_text, 'Clipping', 'on');

        s2_line = plot(tStop*[1 1]*fs,yl,'c-.','linewidth',2);
        s2_text=text(tStop*fs,textpos,'STOP');
        set (s2_text, 'Clipping', 'on');

        for i=1:12
            % a) at start position, waiting for target to come up - "waiting for cue"
            event = trialData.vr(trials).events.waitingForCue;
            e1 = plot(event.time(i)*[1 1]*fs,yl,'b');
            t1=text(event.time(i)*fs,textpos,['At Start Position (',num2str(i),')']);
            set (t1, 'Clipping', 'on');

            % b) at start position, target up, waiting for go sign - "waiting for go"
            event = trialData.vr(trials).events.waitingForGo;
            e2 = plot(event.time(i)*[1 1]*fs,yl,'r');
            t2=text(event.time(i)*fs,textpos,['Cue Event (',num2str(i),')']);
            set (t2, 'Clipping', 'on');

            % c) at start position, go sign received - "go event"
            event = trialData.vr(trials).events.goEvent;
            e3 = plot(event.time(i)*[1 1]*fs,yl,'g');
            t3 = text(event.time(i)*fs,textpos,['Target up(',num2str(i),')']);
            set (t3, 'Clipping', 'on');

            % d) target hit - "target Hit"
            event = trialData.vr(trials).events.targetHit;
            e4 = plot(event.time(i)*[1 1]*fs,yl,'m');
            t4 = text(event.time(i)*fs,textpos,['Target Hit(',num2str(i),')']);
            set (t4, 'Clipping', 'on');
        end
    end
    
    if tfplot
        % Time-Freq Analysis calculation

        WINDOW=512; 
        NOVERLAP=462;
        NFFT=1024;
        FRAME_ADVANCE=WINDOW-NOVERLAP;

        clearvars S
        S(:,:,1)=spectrogram(trialData.eeg.data(eegtime(1)-(WINDOW/2):eegtime(end)+(WINDOW/2),7),WINDOW,NOVERLAP,NFFT,fs); %Channel 7
        S(:,:,2)=spectrogram(trialData.eeg.data(eegtime(1)-(WINDOW/2):eegtime(end)+(WINDOW/2),18),WINDOW,NOVERLAP,NFFT,fs);%Channel 18


        S_mag=abs(S); % real component
        [nfchans,nframes] = size(S_mag(:,:,1));

        nfchansteps=nfchans-1;
        maxfreq=fs/2;
        faxis=maxfreq*(0:nfchansteps)/nfchansteps;
        t_res=FRAME_ADVANCE/fs; % temporal resolution of spectrogram (sec)
        taxis=[0:nframes-1]*FRAME_ADVANCE+eegtime(1);

        A2plot=log10(S_mag);
        ff=find(faxis<=200);

        spectrogram_data.taxis=taxis;
        spectrogram_data.faxis=faxis;
        spectrogram_data.spec=A2plot;

        faxis_new = spectrogram_data.faxis(1:200);

        % Time-Freq Analysis plot

        tfaAx_7 = axes('parent',rFig);
        tfaAx_7.Position = [1-fullwidth*1.2 .42 0.2 0.2330];
        tfaAx_7.Visible = 'on';

        tfaAx_18 = axes('parent',rFig);
        tfaAx_18.Position = [1-fullwidth*1.2 .15 0.2 0.2330];
        tfaAx_18.Visible = 'on';

        tfa_freq=[8 13;14 30;31 50];
        tfa_freqlabel={'alpha','beta','gammalow'};

        axes(tfaAx_7);
        clearvars tmp7
        for i=1:length(tfa_freqlabel)
            tmp7(i,:)=mean(spectrogram_data.spec(tfa_freq(i,1):tfa_freq(i,2),:,1));
        end
        spectrogram_plot7=imagesc(spectrogram_data.taxis,faxis_new,tmp7);
        set(gca,'YDir','normal');
        set(gca,'XLim',[spectrogram_data.taxis(1) spectrogram_data.taxis(end)])
        set(gca,'YTick',[0 100 200])
        set(gca,'YTickLabel',tfa_freqlabel)
        xlabel(gca,'Channel 7');
        colormap(jet)
        cb7=colorbar;
        cb7.Location='northoutside';


        axes(tfaAx_18);
        clearvars tmp18
        for i=1:length(tfa_freqlabel)
            tmp18(i,:)=mean(spectrogram_data.spec(tfa_freq(i,1):tfa_freq(i,2),:,2));
        end
        spectrogram_plot18=imagesc(spectrogram_data.taxis,faxis_new,tmp18);
        set(gca,'YDir','normal');
        set(gca,'XLim',[spectrogram_data.taxis(1) spectrogram_data.taxis(end)])
        set(gca,'YTick',[0 100 200])
        set(gca,'YTickLabel',tfa_freqlabel)
        xlabel(gca,'Channel 18');
        colormap(jet);
        cb18=colorbar;
        cb18.Location='northoutside';

        combine_tmp=[tmp7 tmp18];
        combine_tmp=combine_tmp(~isinf(combine_tmp)); %elimnate inf

        cbarmax=mean(combine_tmp,'all')+2*std(combine_tmp);
        cbarmin=mean(combine_tmp,'all')-2*std(combine_tmp);

        axes(tfaAx_7);
        caxis([cbarmin cbarmax]);

        axes(tfaAx_18);
        caxis([cbarmin cbarmax]);
    end
       
    % Plot metric curves (velocity and acceleration)
    if metriccurves
        velAx = axes('parent',rFig);
        velAx.Position = [0.80 0.77 0.15 0.1];
        vecVel=sqrt(trackerData.v.(testedSide)(:,1).^2+trackerData.v.(testedSide)(:,2).^2+trackerData.v.(testedSide)(:,3).^2);
        plot(velAx,vecVel)
        t=title(velAx,'Velocity');
        t.Color='w';
        t.FontSize=14;

        accAx = axes('parent',rFig);
        accAx.Position = [0.80 0.57 0.15 0.1];
        vecAcc=sqrt(trackerData.a.(testedSide)(:,1).^2+trackerData.a.(testedSide)(:,2).^2+trackerData.a.(testedSide)(:,3).^2);
        plot(accAx,vecAcc)
        t=title(accAx,'Acceleration');
        t.Color='w';
        t.FontSize=14;
    end
       
       
    % Reconstruction Video Creation
    wIM = [];
    rIM = [];
    videoname=fullfile(reconFolder,[s1.sessioninfo.trialnames{trials}, num2str(double([positionalplot,eegplot,tfplot,metricplot,metriccurves])),'.mp4']);
    if exist(videoname,'file') ~= 0
        disp('Old file detected... Removing old file')
        delete(videoname)
    end
    vw = VideoWriter(videoname,'MPEG-4');
    vw.FrameRate = round(1/mean(diff(trackerData.time(imageFrame))));
    open(vw);
     
    %%% Reconstruct video for each reach
    temptrialData=trialData.vr(trials);
    tempepochs=s3.epochs.vrevents.(['t',num2str(trials)]);
    
    for r=1:size(tempepochs.atStartPosition.val,1)
        
        % Find reach start and end
        if r==size(tempepochs.atStartPosition.val,1)
            reachStart=tempepochs.atStartPosition.val(r,1);
            reachEnd=temptrialData.events.stop.time*fs;
        else
            reachStart=tempepochs.atStartPosition.val(r,1);
            reachEnd=tempepochs.atStartPosition.val(r+1,1);
        end
        
        if eegplot
            % Set eegplot title and xlim
            t=title(eegAx,['Reach ',num2str(r)]);
            t.Color='w';
            t.FontSize=14;
            xlim(eegAx,[reachStart reachEnd])
        end
        
        % Set metrics
        if metricplot
            xtextpos=0.5;
            metricdat=s2.metricdatraw.data;
            metriclabel=s2.metricdatraw.label;
            pos=[1-fullwidth*1.27 .55 0.05 .1];
            for m=1:numel(metriclabel)
                if r==1
                    metricAx{m} = axes('parent',rFig);
                    metricAx{m}.Visible = 'on';
                    metricAx{m}.NextPlot='add';
                    t=title(metricAx{m},metriclabel{m});
                    t.Color='w';
                    if m <=4
                        temppos=pos;
                        temppos(2)=pos(2)-(m-1)*0.15;
                        metricAx{m}.Position = temppos;
                    elseif m>=5 && m<9
                        count=m-4;
                        temppos=pos;
                        temppos(2)=pos(2)-(count-1)*0.15;
                        temppos(1)=pos(1)+0.065;
                        metricAx{m}.Position = temppos;
                    elseif m>=9 && m<13
                        count=m-8;
                        temppos=pos;
                        temppos(2)=pos(2)-(count-1)*0.15;
                        temppos(1)=pos(1)+0.065*2;
                        metricAx{m}.Position = temppos;
                    else
                        count=m-12;
                        temppos=pos;
                        temppos(2)=pos(2)-(count-1)*0.15;
                        temppos(1)=pos(1)+0.065*3;
                        metricAx{m}.Position = temppos;
                    end
                end
                trial_indicator{m,r}=text(metricAx{m},xtextpos,metricdat{m}(r,trials),num2str(r),'FontWeight','bold','Color','r');
                ylim([0 max(max(metricdat{m}))])
            end
        end
        
        % Which frames are within each reach
        reachTrackerTime=find(trackerData.time>reachStart/fs & trackerData.time<reachEnd/fs);
        reachFrames=find(imageFrame>=reachTrackerTime(1)& imageFrame<=reachTrackerTime(end));
        
        % Adjust metric curves for each reach
        if metriccurves
            xlim(velAx,[imageFrame(reachFrames(1)) imageFrame(reachFrames(end))])
            xlim(accAx,[imageFrame(reachFrames(1)) imageFrame(reachFrames(end))])
        end
        
        for i = 1:length(reachFrames)
            frameNumber=imageFrame(reachFrames(i));
            frameTime=trackerData.time(frameNumber);
            
            % update image
            imageFile = fullfile(imageFolder,['frame ' num2str(frameNumber) '.png']);
            IM = imread(imageFile);

            if i==1
                rIM = imshow(IM,'parent',rAx);
            else
                rIM.CData = IM;
            end
        
            if positionalplot
            % update positional plot
                pathPlot.XData = trackerData.p.(testedSide)(1:frameNumber,1);
                pathPlot.YData = trackerData.p.(testedSide)(1:frameNumber,3);
                pathPlot.ZData = trackerData.p.(testedSide)(1:frameNumber,2);

                pathMarker.XData = trackerData.p.(testedSide)(frameNumber,1);
                pathMarker.YData = trackerData.p.(testedSide)(frameNumber,3);
                pathMarker.ZData = trackerData.p.(testedSide)(frameNumber,2);

                axis(plotAx,'equal')
                plotAx.XLim = [xmin-delta xmax+delta];
                plotAx.ZLim = [ymin-delta ymax+delta];
                plotAx.YLim = [zmin-delta zmax+delta];
            end
            
            % Add metric curves indicator
            if metriccurves
                velIndicator = xline(velAx,frameNumber,'-b','LineWidth',4);
                accIndicator = xline(accAx,frameNumber,'-b','LineWidth',4);
            end
        
            if eegplot
                % EEG Data Stream
                eegframetime = frameTime*fs;

                indicatorLine = xline(eegAx,eegframetime,'-b','LineWidth',4);
                legend([cn7 cn18],{'Channel 7 (C3)','Channel 18 (C4)'},'location','southoutside')
            end
        
            if tfplot
                % Time Freq Analysis Stream
                eegTimeMin=eegframetime-(fs);
                eegTimeMax=eegframetime+(fs);
                tfaAx_7.XLim = [eegTimeMin eegTimeMax];
                axes(tfaAx_7);hold on; indiciator7=plot(tfaAx_7,eegframetime,tfaAx_7.YLim,'-o','Color','w','MarkerFaceColor','k','MarkerSize',10);

                tfaAx_18.XLim = [eegTimeMin eegTimeMax];
                axes(tfaAx_18);hold on; indiciator18=plot(tfaAx_18,eegframetime,tfaAx_18.YLim, '-o','Color','w','MarkerFaceColor','k','MarkerSize',10);
            end


            if addVideo
                % update webcam image
                webcamTime = trackerData.time(frameNumber) - trackerData.time(1);
                webcamTime = max(0,webcamTime);
                webcamTime = min(webcamTime,reader.Duration);

                reader.CurrentTime = webcamTime;
                if reader.hasFrame
                    frm = reader.readFrame();

                    if i==1
                        wIM = imshow(frm,'parent',wAx);
                    else
                        wIM.CData = frm;
                    end
                end
            end

            drawnow

            % Saving figure as frame
            F = getframe(rFig);
            writeVideo(vw,F);

            if eegplot
                delete(indicatorLine)
            end

            if tfplot
                delete(indiciator7)
                delete(indiciator18)
            end
            
            if metriccurves
                delete(velIndicator)
                delete(accIndicator)
            end
                
        end
        
        if metricplot
           for m=1:numel(metriclabel)
               set(trial_indicator{m,r},'FontWeight','normal','Color','k');
           end
        end
    end
    close(vw)
    close(rFig)
end 
end