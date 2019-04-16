function newSOC = SOC_Calc(prevState,prevSOC)

%{
List of modes

Mode # //// Mode Type

1 //// Solar Array Deployment
2 //// Solar Array Retraction
3 //// Charge
4 //// Safe Mode
5 //// Aerocapture
6 //// Downlink
7 //// Science
8 //// Eclipse 
%}

%Power consumption per state with margin [W]

p_out(1) = 204.54; %Solar Array Deployment
p_out(2) = 204.54; %Solar Array Retraction
p_out(3) = 172.02; %Charge
p_out(4) = 140.70; %Safe Mode
p_out(5) = 145.94; %Aerocapture
p_out(6) = 542.23; %Downlink
p_out(7) = 323.25; %Science
p_out(8) = 134.94; %Eclipse

%Time step for SOC calculation
t_step = 1; %hrs

%/////Solar Array Calcs/////

%ROSA at 1AU
p_rosa = 20000; % Watts
A_rosa = 84; % m^2

%JAC Array Size
width = 13.5; % m
length = 2.5; % m
quantity = 2;
A_total = quantity*width*length;
losses = 0.1; %assume losses due to estimation, loss of efficiency with distance, etc.
margin = 0.2; %assume 20% margin on top of losses

%JAC array at 1 AU 0 deg offpoint
p_array1AU = (A_total/A_rosa)*p_rosa;
%JAC array power at 5.1 AU 0 deg offpoint
p_array = (1-losses-margin)*(p_array1AU/(5.1^2));

% /////Battery Calcs/////
mass = 3.95; %kg
power_density = 113.1; %W-hrs/kg
bat_quantity = 4;
maxBatCap = bat_quantity*power_density*mass; %W-hrs


energy_out = p_out(prevState)*t_step; %W-hrs
%offpoint angle
if prevState == 1
    sa_offpoint = 90; %deg
elseif prevState == 2
    sa_offpoint = 90; %deg
elseif prevState == 3
    sa_offpoint = 0; %deg
elseif prevState == 4
    sa_offpoint = 0; %deg
elseif prevState == 5
    sa_offpoint = 90; %deg
elseif prevState == 6
    sa_offpoint = 60; %deg
elseif prevState == 7
    sa_offpoint = 45; %deg
elseif prevState == 8
    sa_offpoint = 90; %deg
else
    sa_offpoint = 90; %deg
end
energy_in = p_array*cosd(sa_offpoint)*t_step; % W-hrs
deltaEnergy = energy_in-energy_out; % W-hrs
batterycap = maxBatCap*prevSOC+deltaEnergy;
if batterycap > maxBatCap
    batterycap = maxBatCap;
end
newSOC = batterycap/maxBatCap;












