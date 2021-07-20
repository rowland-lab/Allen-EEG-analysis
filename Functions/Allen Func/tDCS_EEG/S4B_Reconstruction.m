%% replay data collection

function S4B_Reconstruction(subjectName,protocol_folder,positionalplot,eegplot,tfplot,trial_num)
%% Generate variables
subjectFolder=fullfile(protocol_folder,subjectName);


% Import S1 preprocessed data
try
    import=load(fullfile(subjectFolder,'analysis','S1-VR_preproc',[subjectName,'_S1-VRdata_preprocessed.mat']));

catch
    error('Step 1 Preprocessing files NOT FOUND')
end

% Define folders
eegfile=import.sessioninfo.path.edffile;
reconFolder=fullfile(subjectFolder,'analysis','S2B-Reconstruction');


% Make reconstruction folder
mkdir(reconFolder)


if isempty(trial_num)
    trial_num=1:numel(import.preprocessed_vr);
end
%% Start Looping through all trials
for trials=trial_num
    trialFolder = fullfile(subjectFolder,'vr',import.preprocessed_vr(trials).information.trialName);
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

    trialData=loadVrTrialData_EEG(trialFolder,eegfile,{'DC1' 'DC2'},false,import.sessioninfo.vrchan);
    trialData.vr=import.preprocessed_vr(trials);
    trackerData = trialData.vr.tracker;
    
   
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
        rFig = figure('Name',[subjectName,'          ',import.sessioninfo.trialnames{trials}]);
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
        rFig = figure('Name',[subjectName,'          ',import.sessioninfo.trialnames{trials}]);
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
        tStart = trialData.vr.events.start.time;
        tStop = trialData.vr.events.stop.time;

        % Plot eeg
        fs=trialData.eeg.header.samplingrate;
        eegtime=trackerData.time.*fs;

        eegAx = axes('parent',rFig);
        eegAx.Position = [1-fullwidth*1.2 .70 0.2 0.2330];
        eegAx.Visible = 'on';



        cn7=plot(eegtime(1):eegtime(end),(trialData.eeg.data(eegtime(1):eegtime(end),7)-mean(trialData.eeg.data(eegtime(1):eegtime(end),7)))/std(trialData.eeg.data(eegtime(1):eegtime(end),7))); hold on;
        cn18=plot(eegtime(1):eegtime(end),(trialData.eeg.data(eegtime(1):eegtime(end),18)-mean(trialData.eeg.data(eegtime(1):eegtime(end),18)))/std(trialData.eeg.data(eegtime(1):eegtime(end),18))-20);
        set(eegAx,'ylim',[-30 10])

        % EEG TimeStamps
        yl = get(gca,'ylim');
    %     textpos=abs(max(trialData.eeg.data(eegtime(1):eegtime(end),7)/max(trialData.eeg.data(eegtime(1):eegtime(end),7))));
        textpos=-10;
        hold on
        s1 = plot(tStart*[1 1]*fs,yl,'m-.','linewidth',2);
        s1_text=text(tStart*fs,textpos,'START');
        set (s1_text, 'Clipping', 'on');

        s2 = plot(tStop*[1 1]*fs,yl,'c-.','linewidth',2);
        s2_text=text(tStop*fs,textpos,'STOP');
        set (s2_text, 'Clipping', 'on');

        ylim=get(gca,'ylim');


        for i=1:12
            % a) at start position, waiting for target to come up - "waiting for cue"
            event = trialData.vr.events.waitingForCue;
            e1 = plot(event.time(i)*[1 1]*fs,yl,'b');
            t1=text(event.time(i)*fs,textpos,['At Start Position (',num2str(i),')']);
            set (t1, 'Clipping', 'on');

            % b) at start position, target up, waiting for go sign - "waiting for go"
            event = trialData.vr.events.waitingForGo;
            e2 = plot(event.time(i)*[1 1]*fs,yl,'r');
            t2=text(event.time(i)*fs,textpos,['Cue Event (',num2str(i),')']);
            set (t2, 'Clipping', 'on');

            % c) at start position, go sign received - "go event"
            event = trialData.vr.events.goEvent;
            e3 = plot(event.time(i)*[1 1]*fs,yl,'g');
            t3 = text(event.time(i)*fs,textpos,['Target up(',num2str(i),')']);
            set (t3, 'Clipping', 'on');

            % d) target hit - "target Hit"
            event = trialData.vr.events.targetHit;
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

    % Reconstruction Video Creation
    wIM = [];
    rIM = [];

    vw = VideoWriter(fullfile(reconFolder,[import.sessioninfo.trialnames{trials},'-Reconstruction.mp4']),'MPEG-4');
    vw.FrameRate = round(1/mean(diff(trackerData.time(imageFrame))));
    open(vw);

    for i = 1:length(imageFrame)

        frameNumber = imageFrame(i);
        frameTime = trackerData.time(frameNumber);


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
        
        if eegplot
            % EEG Data Stream
            eegframetime = frameTime*fs;

            indiciator=plot(eegAx,eegframetime,eegAx.YLim,'-o','Color','w','MarkerFaceColor','k','MarkerSize',10);

            eegTimeMin = eegframetime-1*fs;
            eegTimeMax = eegframetime+1*fs;
            eegAx.XLim = [eegTimeMin eegTimeMax];
            eegAx.YLim = ylim;
            legend([cn7 cn18],{'Channel 7 (C3)','Channel 18 (C4)'})
        end
        
        if tfplot
            % Time Freq Analysis Stream
            tfaAx_7.XLim    = [eegTimeMin eegTimeMax];
            axes(tfaAx_7);hold on; indiciator7=plot(tfaAx_7,eegframetime,tfaAx_7.YLim,'-o','Color','w','MarkerFaceColor','k','MarkerSize',10);

            tfaAx_18.XLim   = [eegTimeMin eegTimeMax];
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
        F = getframe(rFig);
        
        if eegplot
            delete(indiciator)
        end
        
        if tfplot
            delete(indiciator7)
            delete(indiciator18)
        end
        
        writeVideo(vw,F);

    end

    close(vw)
end
end