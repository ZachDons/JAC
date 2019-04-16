%% Housekeeping, sweep sweep
close all; clear all; clc;

%% Read In Data
Io2Sun = xlsread('Io_to_Sun.csv','A2:D26306');
Gany2Sun = xlsread('Ganymede_to_Sun.csv','A2:D26306');
Eur2Sun = xlsread('Europa_to_Sun.csv','A2:D26306');
Call2Sun = xlsread('Callisto_to_Sun.csv','A2:D26306');
JAC2Sun = xlsread('JAC_to_Sun.csv','A2:D26306');
Jup2Sun = xlsread('Jup_to_Sun.csv','A2:D26306');
% Data Format: 7 Columns
%             | (ICRF) Vect 2 Sun |
% |Time (UTCG)|x (km)|y (km)|z (km)|

% Time Scale
% NOTE: All data is taken at 1 hour intervals beginning on 30 May 2023 1800
% and in UTCG format (reference the excel sheets depicting this). When
% reading in the time data from the excel sheet an error occurs in
% converting UTCG to numerical data. This needs to be fixed in the future
time = 0:1:length(JAC2Sun)-1; %hrs
Io2Sun(:,1) = time;
Eur2Sun(:,1) = time;
Gany2Sun(:,1) = time;
Call2Sun(:,1) = time;
JAC2Sun(:,1) = time;
Jup2Sun(:,1) = time;
%% Calculate distance of Objects from the Sun
% Calculate Euclidean norm of X,Y,Z comps: JAC 3 moon
Io.distSun = vecnorm(Io2Sun(:,2:4),2,2); % mag of dist from body 2 Sun, km
Eur.distSun = vecnorm(Eur2Sun(:,2:4),2,2); % mag of dist from body 2 Sun, km
Gany.distSun = vecnorm(Gany2Sun(:,2:4),2,2); % mag of dist from body 2 Sun, km
Call.distSun = vecnorm(Call2Sun(:,2:4),2,2); % mag of dist from body 2 Sun, km
JAC.distSun = vecnorm(JAC2Sun(:,2:4),2,2); % mag of dist from body 2 Sun, km
Jup.distSun = vecnorm(Jup2Sun(:,2:4),2,2); % mag of dist from body 2 Sun, km

figure
hold on
plot(time, Io.distSun, 'DisplayName', 'Io')
plot(time, Eur.distSun, 'DisplayName', 'Europa')
plot(time, Gany.distSun, 'DisplayName', 'Ganymede')
plot(time, Call.distSun, 'DisplayName', 'Callisto')
%plot(time, JAC.distSun, 'DisplayName', 'JAC')
plot(time, Jup.distSun, 'LineWidth',1.2, 'DisplayName', 'Jupiter')
xlabel('Time from Epoch, hrs')
ylabel('\Delta from Planetary Bodies to Sun, km')
legend('show', 'Location', 'best')
title('Distance from Planetary Bodies to Sun')
grid on
hold off

%% Calculations
%bodies = cat(3,Io2Sun(:,2:4), Eur2Sun(:,2:4), Gany2Sun(:,2:4), Call2Sun(:,2:4));
degObs = [atan2d(5268,600000), atan2d((139820*0.5),600000), atan2d(1.391e6,741e6)*10]; % Obstructions of moons, Jupiter, and the Sun
bodies = cat(3,Io2Sun, Eur2Sun, Gany2Sun, Call2Sun);
visData = RM_Obstruct(bodies, JAC2Sun(:,2:4), Jup2Sun(:,2:4), degObs);

%% Find distance to Planet
% Calculate distance from JAC to each moon
Io.dist = vecnorm(visData(:,2:4,1),2,2); % mag of dist from body 2 Sun, km
Eur.dist = vecnorm(visData(:,2:4,2),2,2); % mag of dist from body 2 Sun, km
Gany.dist = vecnorm(visData(:,2:4,3),2,2); % mag of dist from body 2 Sun, km
Call.dist = vecnorm(visData(:,2:4,4),2,2); % mag of dist from body 2 Sun, km

%% Plot observation windows of all moons
% Plot all observation windows of moons
figure
hold on
plot(time, Io.dist, 'DisplayName', 'Io')
plot(time, Eur.dist, 'DisplayName', 'Europa')
plot(time, Gany.dist, 'DisplayName', 'Ganymede')
plot(time, Call.dist, 'DisplayName', 'Callisto')
xlabel('Time from Epoch, hrs')
ylabel('\Delta from JAC to moon, km')
legend('show', 'Location', 'best')
title('Distance from JAC to Moon')
hold off
% Plot individual observation windows of moons
plotDistances(visData(:,:,1), 'Io')
plotDistances(visData(:,:,2), 'Europa')
plotDistances(visData(:,:,3), 'Ganymede')
plotDistances(visData(:,:,4), 'Callisto')

%% Calculate the schedule of planets

[hrTable, timeT] = Schedule(time, visData);

% Plot the Schedule
plotSchedule(hrTable);

%xlswrite('ObritBreakdown.xls',hrTable)



