function [ hrTable, timeT, downNum, chargeNum] = Schedule(time, visData)
% Items of importance while scheduling
% 1) View time of Callisto
% 2) science, downlink, charge time
% 3) Equal views of other planets

%% Allocation of Scheduling Variables
% Allocate 
hrTable = cell(length(time),3); % Designate the Schedule Storage

soc = 1; % Set the SOC to 100% initially
chargeMode = false; % While TRUE continue charging
timeM = [0 0 0 0]; % Time per moon 
timeT = [0 0 0 0]; % Total Time per moon 

% Designate the moon weighting
viewTotal = 60; % Available time per orbit for science
%perMoon = [0.01 0.3 0.3 0.39]; %Must add to 1
perMoon = [0.15 0.17 0.2 0.45]; %Must add to 1

avail = [0 0 0 0]; % Availabilite of moons vector
strMoons = {'Io','Europa','Ganymede','Callisto'};
numMoons = [1:4];

% Downlink counter
downCnt = 0; % Counter of science orbits
downTime = 0; % Counter of downlink time
downMode = false; % Determines when time to downlink
downMax = 840; % Number of science orbits before downlink
downNum = 0; % Number of discharges
chargeNum = 0; % Number of Charges

%% Construction of the Schedule
for ii = 1:length(time) 

% Reset the moon weighting every orbit    
if mod(time(ii),72) == 0
    timeM = [0 0 0 0];
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%% DOWNLINK %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% If # of science orbits acheived && SOC will not drop below 80% && not
% charging
if downCnt == downMax && SOC_Calc(6,soc) > 0.8 && ~chargeMode 
    soc = SOC_Calc(6,soc); % downlink SOC
    % Downlink for 6 hours
    if downTime == 5
        downMode = false;
        downCnt = 0; % reset downlink counter
        downTime = 0;
    else
        downMode = true;
        downTime = downTime + 1;
    end
    downNum = downNum + 1;
    hrTable(ii,:) = {'Downlink',0,ii}; %add downlink to table


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%% SCIENCE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% If not downlinking && SOC will not drop below 80% && not
% charging
elseif SOC_Calc(7,soc) > 0.8 && downCnt ~= downMax && ~chargeMode && ~downMode
    soc = SOC_Calc(7,soc); % science SOC
    
    % See which planets are aviailable for a given timestep
    avail(1) = ~isnan(visData(ii,1,1)); 
    avail(2) = ~isnan(visData(ii,1,2));
    avail(3) = ~isnan(visData(ii,1,3));
    avail(4) = ~isnan(visData(ii,1,4));
    
    % Test moon availability
    if all(avail==0) %No moons available!
        hrTable(ii,:) = {'No Moons', nan, ii};
        continue %Procede to next iteration of for loop
    end
    
    % Chose Moon
    availM = find(avail == 1); %index of available moons
    wMoon = perMoon(availM).*viewTotal - timeM(availM); %wieght of available moons
    [~,iMax] = max(wMoon); %index of max weight
    iMoon = availM(iMax); %this moon is viewed
    timeM(iMoon) = timeM(iMoon) + 1; %add display time to moon chosen
    timeT(iMoon) = timeT(iMoon) + 1; %tracks total time of each moon
    downCnt = downCnt + 1; %increment downlink cnter
    hrTable(ii,:) = {strMoons{iMoon},numMoons(iMoon) ,ii}; %add chosen moon to table
    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%% CHARGING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% If not downlinking || scienceing then charge!
else %if soc < 1
    soc = SOC_Calc(3,soc); % charging SOC
    
    % Charge until battery is 100%
    if soc == 1
        chargeMode = false;
    else
        chargeMode = true;
    end
    
    chargeNum = chargeNum + 1;
    % Add charging to table
    hrTable(ii,:) = {'Charge',0 ,ii};
end

end


