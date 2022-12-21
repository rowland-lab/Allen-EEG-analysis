% shade option= 0(no) or 1 (yes)


function [vrMetrics,rejecttrials,reachstarttime] = calculateVRMetrics(vrData,environmentSettings,figureHandles,colors,ls,shadeoption)

% initialize sphere radiuses
startPositionRadius = 0.048;
targetPositionRadius = 0.03;
handSphereRadius = 0.03;

% get tested side
testedSide = vrData.information.testedSide;

% get start position
startPosition = [str2double(environmentSettings.startPosition.position.x) str2double(environmentSettings.startPosition.position.y) str2double(environmentSettings.startPosition.position.z)];

% rotate start position
alpha = -str2double(environmentSettings.altitude);
sp = [startPosition';1];
sp2 = makehgtform('xrotate',alpha*pi/180)*sp;
startPosition = sp2(1:3)';

if strcmp(vrData.information.studyCondition,'Multiple reaches per cue')
    
    % get target positions
    environmentTargetPositions = [str2double(environmentSettings.target1.position.x) str2double(environmentSettings.target1.position.y) str2double(environmentSettings.target1.position.z)
        str2double(environmentSettings.target2.position.x) str2double(environmentSettings.target2.position.y) str2double(environmentSettings.target2.position.z)];
    
    % rotate target positions
    for i = 1:2
        tp = [environmentTargetPositions(i,:)';1];
        tp2 = makehgtform('xrotate',alpha*pi/180)*tp;
        environmentTargetPositions(i,:) = tp2(1:3)';
    end
end
                          
% get events pertaining to first reach of each sequence
atStartPosition = vrData.events.atStartPosition.time;
cueEvent = vrData.events.cueEvent.time;
goEvent = vrData.events.goEvent.time;
targetHit = vrData.events.targetHit.time;

% get targret up event data
targetUpData = vrData.events.targetUp.data;

% remove all 'atStartPosition' events that are not just before a cue
% (subject went in and out of start position)
tmp = [];
for i = 1:length(cueEvent)
    ind = find(atStartPosition<cueEvent(i),1,'last');
    tmp = [tmp; atStartPosition(ind)];
end
atStartPosition = tmp;

% get first target hit after go (just focus on the first reach)
firstReachInd = [];
for i = 1:length(goEvent)
    firstReachInd = [firstReachInd; find(targetHit>goEvent(i),1,'first')];
end
targetHit = targetHit(firstReachInd);
targetUpData = targetUpData(firstReachInd);

% get target positions and used hand
targetPositions = zeros(length(firstReachInd),3);
usedHand = cell(length(firstReachInd),3);
for i = 1:length(firstReachInd)
    
    if strcmp(vrData.information.studyCondition,'Multiple reaches per cue')
        targetPositions(i,:) = environmentTargetPositions(vrData.events.targetHit.data(firstReachInd(i)).targetNumber,:);
    elseif strcmp(vrData.information.studyCondition,'Single reach per cue, random time') || strcmp(vrData.information.studyCondition,'Single reach per cue, random time, no visual cue')
        
        p = [targetUpData(i).targetPosition'; 1];
        p2 = makehgtform('xrotate',alpha*pi/180)*p;
        targetPositions(i,:) = p2(1:3)';
        
    else
        targetPositions(i,:) = NaN(1,3);
    end
    usedHand{i} = vrData.events.targetHit.data(firstReachInd(i)).hand;
end

% compact everything into a structure format
reaches = struct();
for i = 1:length(atStartPosition)
    reaches(i).atStartPosition = atStartPosition(i);
    reaches(i).cueEvent = cueEvent(i);
    reaches(i).goEvent = goEvent(i);
    reaches(i).targetHit = targetHit(i);
    reaches(i).startPosition = startPosition;
    reaches(i).targetPosition = targetPositions(i,:);
    reaches(i).usedHand = usedHand{i};
    reaches(i).testedSide = testedSide;
end

% initialize results structure
vrMetrics.IOC = NaN(1,length(reaches));
vrMetrics.maxVelocity = NaN(1,length(reaches));
vrMetrics.movementDuration = NaN(1,length(reaches));
vrMetrics.reactionTime = NaN(1,length(reaches));
vrMetrics.timeToMaxVelocity = NaN(1,length(reaches));
vrMetrics.timeToMaxVelocity_n = NaN(1,length(reaches));
vrMetrics.velocityPeaks = NaN(1,length(reaches));
vrMetrics.normalizedJerk = NaN(1,length(reaches));
vrMetrics.accuracy = NaN(1,length(reaches));
vrMetrics.avgVelocity = NaN(1,length(reaches));

% initialize plot variables
x_plot = [];
y_plot = [];
z_plot = [];
V_plot = [];

%% cycle through reaches and calculate metrics
rejecttrials=nan;

for i = 1:length(reaches)
    
    %% at start position waiting for target to appear
    ind = (vrData.tracker.time>=reaches(i).atStartPosition) & (vrData.tracker.time<=(reaches(i).cueEvent));
        
    x = vrData.tracker.p.(reaches(i).testedSide)(ind,1);
    y = vrData.tracker.p.(reaches(i).testedSide)(ind,2);
    z = vrData.tracker.p.(reaches(i).testedSide)(ind,3);
    
    vx = vrData.tracker.v.(reaches(i).testedSide)(ind,1);
    vy = vrData.tracker.v.(reaches(i).testedSide)(ind,2);
    vz = vrData.tracker.v.(reaches(i).testedSide)(ind,3);
    V = sqrt(vx.^2+vy.^2+vz.^2);
    
    ax = vrData.tracker.a.(reaches(i).testedSide)(ind,1);
    ay = vrData.tracker.a.(reaches(i).testedSide)(ind,2);
    az = vrData.tracker.a.(reaches(i).testedSide)(ind,3);
    A = sqrt(ax.^2+ay.^2+az.^2);
    
    d_start = sqrt(sum(([x y z] - repmat(reaches(i).startPosition,length(x),1)).^2,2));
    
    % skip if mean distance from start exceeds 8 cm
    if mean(d_start) >= 0.08 & strcmp(vrData.information.env,'3')
        vrMetrics.IOC(i) = NaN;
        vrMetrics.maxVelocity(i) = NaN;
        vrMetrics.movementDuration(i) = NaN;
        vrMetrics.reactionTime(i) = NaN;
        vrMetrics.timeToMaxVelocity(i) = NaN;
        vrMetrics.timeToMaxVelocity_n(i) = NaN;
        vrMetrics.velocityPeaks(i) = NaN;
        vrMetrics.normalizedJerk(i) = NaN;
        vrMetrics.accuracy(i) = NaN;
        vrMetrics.handpathlength(i) = NaN;
        vrMetrics.avgVelocity(i) = NaN;
        vrMetrics.avgAcceleration(i) = NaN;
        vrMetrics.maxAcceleration(i)= NaN;
        
        rejecttrials=[rejecttrials i];
        reachstarttime(i)=nan;
        continue
    end
    
    %% at start position waiting for go
    ind = (vrData.tracker.time>=reaches(i).cueEvent) & (vrData.tracker.time<=(reaches(i).goEvent));
        
    x = vrData.tracker.p.(reaches(i).testedSide)(ind,1);
    y = vrData.tracker.p.(reaches(i).testedSide)(ind,2);
    z = vrData.tracker.p.(reaches(i).testedSide)(ind,3);
    
    vx = vrData.tracker.v.(reaches(i).testedSide)(ind,1);
    vy = vrData.tracker.v.(reaches(i).testedSide)(ind,2);
    vz = vrData.tracker.v.(reaches(i).testedSide)(ind,3);
    V = sqrt(vx.^2+vy.^2+vz.^2);
    
    ax = vrData.tracker.a.(reaches(i).testedSide)(ind,1);
    ay = vrData.tracker.a.(reaches(i).testedSide)(ind,2);
    az = vrData.tracker.a.(reaches(i).testedSide)(ind,3);
    A = sqrt(ax.^2+ay.^2+az.^2);
    
    d_start = sqrt(sum(([x y z] - repmat(reaches(i).startPosition,length(x),1)).^2,2));
    
    % skip if distance from start (towards end of wait time) exceeds 8 cm
    if mean(d_start(end-10:end)) >= 0.08 && strcmp(vrData.information.env,'3')
        vrMetrics.IOC(i) = NaN;
        vrMetrics.maxVelocity(i) = NaN;
        vrMetrics.movementDuration(i) = NaN;
        vrMetrics.reactionTime(i) = NaN;
        vrMetrics.timeToMaxVelocity(i) = NaN;
        vrMetrics.timeToMaxVelocity_n(i) = NaN;
        vrMetrics.velocityPeaks(i) = NaN;
        vrMetrics.normalizedJerk(i) = NaN;
        vrMetrics.accuracy(i) = NaN;
        vrMetrics.handpathlength(i) = NaN;
        vrMetrics.avgVelocity(i) = NaN;
        vrMetrics.avgAcceleration(i) = NaN;
        vrMetrics.maxAcceleration(i)= NaN;
        
        rejecttrials=[rejecttrials i];
        reachstarttime(i)=nan;
        
        continue
    end
    
    %% from go to shortly after target hit
    ind = (vrData.tracker.time>=reaches(i).goEvent) & (vrData.tracker.time<=(reaches(i).targetHit+0.5));
    
    t = vrData.tracker.time(ind);
    
    x = vrData.tracker.p.(reaches(i).testedSide)(ind,1);
    y = vrData.tracker.p.(reaches(i).testedSide)(ind,2);
    z = vrData.tracker.p.(reaches(i).testedSide)(ind,3);
    
    vx = vrData.tracker.v.(reaches(i).testedSide)(ind,1);
    vy = vrData.tracker.v.(reaches(i).testedSide)(ind,2);
    vz = vrData.tracker.v.(reaches(i).testedSide)(ind,3);
    V = sqrt(vx.^2+vy.^2+vz.^2);
    
    ax = vrData.tracker.a.(reaches(i).testedSide)(ind,1);
    ay = vrData.tracker.a.(reaches(i).testedSide)(ind,2);
    az = vrData.tracker.a.(reaches(i).testedSide)(ind,3);
    A = sqrt(ax.^2+ay.^2+az.^2);
    
    d_start = sqrt(sum(([x y z] - repmat(reaches(i).startPosition,length(x),1)).^2,2));
    d_target = sqrt(sum(([x y z] - repmat(reaches(i).targetPosition,length(x),1)).^2,2));
    
    % define reach end as time of smallest distance to target
    indReachEnd = find(d_target == min(d_target),1,'first');
    reachEnd = t(indReachEnd);
    
    % find time when hand sphere first exits start sphere
    indStartExit = find(d_start>(startPositionRadius+handSphereRadius),1,'first');
    tStartExit = t(indStartExit);
    
    % find velocity peak
    vMax = max(V(max(1,(indStartExit-10)):indReachEnd));
    vMin = min(V(1:indStartExit));
    
    % define reach start as time closest to sphere exit when the hand
    % velocity rises above 10% of max
    th = vMin + (vMax-vMin)*0.1;
    if V(indStartExit)<th
        indReachStart = find(t>tStartExit & V>=th,1,'first');
        reachStart = t(indReachStart);
    else
        indReachStart = find(t<=tStartExit & V<th,1,'last')+1;
        reachStart = t(indReachStart);
    end
    
    % reach indices
    indReach = indReachStart:indReachEnd;
    
    % calculate jerk
    dax = ax(3:end) - ax(1:end - 2);
    day = ay(3:end) - ay(1:end - 2);
    daz = az(3:end) - az(1:end - 2);
    dt = t(3:end) - t(1:end - 2);
    
    jx = dax./dt; jx = [jx(1); jx; jx(end)];
    jy = day./dt; jy = [jy(1); jy; jy(end)];
    jz = daz./dt; jz = [jz(1); jz; jz(end)];
    
    J = sqrt(jx.^2 + jy.^2 + jz.^2); % magnitude of jerk
    
    % extract movement data
    Pr = [x(indReach) y(indReach) z(indReach)];
    Vr = [vx(indReach) vy(indReach) vz(indReach)];
    Ar = [ax(indReach) ay(indReach) az(indReach)];
    Jr = [jx(indReach) jy(indReach) jz(indReach)];
    
    % calculate IoC
    pStart = [x(indReachStart) y(indReachStart) z(indReachStart)];
    pEnd = [x(indReachEnd) y(indReachEnd) z(indReachEnd)];
    straightLineDistance = norm(pEnd-pStart);
    handPathLength = sum(sqrt(sum(diff([x(indReach) y(indReach) z(indReach)]).^2,2)));
    IOC = handPathLength/straightLineDistance;
    
    % calculate maxumum velocity
    [maxVelocity, indMaxV] = max(V(indReach));
    indMaxV = indMaxV + indReachStart-1;
    
    % calculate movement duration
    movementDuration = reachEnd-reachStart;
    
    % calculate reaction time
    reactionTime = reachStart-reaches(i).goEvent;
    
    % calculate time from start to peak velocity, normalized by movement
    % time
    maxVTime = t(indMaxV);
    timeToMaxVelocity = maxVTime-reachStart;
    timeToMaxVelocity_n = timeToMaxVelocity/movementDuration*100;
    
    % calculate number of velocity peaks
    n_mov = pEnd'-pStart'; n_mov = n_mov/norm(n_mov);
    handAccelForPeaks = (Ar*n_mov);
    th = 0.05*(max(handAccelForPeaks)-min(handAccelForPeaks));
    above = handAccelForPeaks>th;
    below = handAccelForPeaks<(-th);
    transition = zeros(size(handAccelForPeaks));
    transition(above) = 1;
    transition(below) = -1;
    transition(transition==0) = [];
    
    velocityPeaks = sum(diff(transition)<0);
    
    % normalized jerk
    [Pmj, Vmj, Amj, Jmj] = generateMinJerkTrajectory(Pr,Vr,Ar,Jr,t(indReach));
    normalizedJerk = trapz(t(indReach),sqrt(sum(Jr.^2,2))) / trapz(t(indReach),sqrt(sum(Jmj.^2,2)));
    
    % precision
    accuracy = 1/min(d_target);
    
    % average velocity
    avgVelocity=handPathLength/movementDuration;
    
    % average acceleration
    avgAcceleration=mean(A);
    
    % max acceleration
    maxAcceleration=max(A);
    
    
    % save results
    vrMetrics.IOC(i) = IOC;
    vrMetrics.maxVelocity(i) = maxVelocity;
    vrMetrics.movementDuration(i) = movementDuration;
    vrMetrics.reactionTime(i) = reactionTime;
    vrMetrics.timeToMaxVelocity(i) = timeToMaxVelocity;
    vrMetrics.timeToMaxVelocity_n(i) = timeToMaxVelocity_n;
    vrMetrics.velocityPeaks(i) = velocityPeaks;
    vrMetrics.normalizedJerk(i) = normalizedJerk;
    vrMetrics.accuracy(i) = accuracy;
    vrMetrics.handpathlength(i) = handPathLength;
    vrMetrics.avgVelocity(i) =avgVelocity;
    vrMetrics.avgAcceleration(i) = avgAcceleration;
    vrMetrics.maxAcceleration(i)= maxAcceleration;
    
    reachstarttime(i)=reactionTime;
    
    % generate plot data
    t_reach = t(indReach);
    t_plot = linspace(t_reach(1),t_reach(end),500)';
    x_plot = [x_plot interp1(t_reach,x(indReach),t_plot)];
    y_plot = [y_plot interp1(t_reach,y(indReach),t_plot)];
    z_plot = [z_plot interp1(t_reach,z(indReach),t_plot)];
    V_plot = [V_plot interp1(t_reach,V(indReach),t_plot)];
    
end

% plot graphs
x_mean = mean(x_plot,2); x_std = std(x_plot,[],2);
y_mean = mean(y_plot,2); y_std = std(y_plot,[],2);
z_mean = mean(z_plot,2); z_std = std(z_plot,[],2);
V_mean = mean(V_plot,2); V_std = std(V_plot,[],2);
t = linspace(0,100,size(x_plot,1))';
vrMetrics.V_mean = V_mean;
vrMetrics.t=t;

if shadeoption==1
    figure(figureHandles(1));
    subplot(3,1,1)
    patch([t; t(end:-1:1)],[x_mean-x_std; x_mean(end:-1:1)+x_std(end:-1:1)],'r','facecolor',colors,'facealpha',0.1,'linestyle','none');
    hold on
    xline=plot(t,x_mean,'linewidth',2,'color',colors);
    set(xline,'linestyle',ls)
    ylabel('X [m]')

    subplot(3,1,2)
    patch([t; t(end:-1:1)],[y_mean-y_std; y_mean(end:-1:1)+y_std(end:-1:1)],'r','facecolor',colors,'facealpha',0.1,'linestyle','none');
    hold on
    yline=plot(t,y_mean,'linewidth',2,'color',colors);
    set(yline,'linestyle',ls)
    ylabel('Y [m]')

    subplot(3,1,3)
    patch([t; t(end:-1:1)],[z_mean-z_std; z_mean(end:-1:1)+z_std(end:-1:1)],'r','facecolor',colors,'facealpha',0.1,'linestyle','none');
    hold on
    zline=plot(t,z_mean,'linewidth',2,'color',colors);
    set(zline,'linestyle',ls)
    ylabel('Z [m]')
    xlabel('% movement []')

    figure(figureHandles(2));
    patch([t; t(end:-1:1)],[V_mean-V_std; V_mean(end:-1:1)+V_std(end:-1:1)],'r','facecolor',colors,'facealpha',0.1,'linestyle','none');
    hold on
    vline=plot(t,V_mean,'linewidth',2,'color',colors);
    set(vline,'linestyle',ls)
    ylabel('|V| [m/s]')
    xlabel('% movement []')
else
    figure(figureHandles(1));
    subplot(3,1,1)
    hold on
    xline=plot(t,x_mean,'linewidth',2,'color',colors);
    set(xline,'linestyle',ls)
    ylabel('X [m]')

    subplot(3,1,2)
    hold on
    yline=plot(t,y_mean,'linewidth',2,'color',colors);
    set(yline,'linestyle',ls)
    ylabel('Y [m]')

    subplot(3,1,3)
    hold on
    zline=plot(t,z_mean,'linewidth',2,'color',colors);
    set(zline,'linestyle',ls)
    ylabel('Z [m]')
    xlabel('% movement []')

    figure(figureHandles(2));
    hold on
    vline=plot(t,V_mean,'linewidth',2,'color',colors);
    set(vline,'linestyle',ls)
    ylabel('|V| [m/s]')
    xlabel('% movement []')
end

    