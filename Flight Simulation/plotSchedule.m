function [] = plotSchedule(hrTable)

% Graphically display the planet schedule
figure
hold on
% pltInd1 = floor(length(hrTable)/2)+730;
% pltInd2 = floor(length(hrTable)/2) + 940;
% pltInd1 = 1;
% pltInd2 = 211;

pltInd1 = length(hrTable)-210;
pltInd2 = length(hrTable);



for ii = pltInd1:pltInd2
    if strcmp(char(hrTable(ii,1)), 'Io')
        plot([ii-1, ii], [0, 0],  'r', 'LineWidth', 80);
    elseif strcmp(char(hrTable(ii,1)),'Europa')
        plot([ii-1, ii], [0, 0],  'g', 'LineWidth', 80);
    elseif strcmp(char(hrTable(ii,1)), 'Ganymede')
        plot([ii-1, ii], [0, 0],  'b', 'LineWidth', 80);
    elseif strcmp(char(hrTable(ii,1)), 'Callisto')
        plot([ii-1, ii], [0, 0],  'm', 'LineWidth', 80);
    elseif strcmp(char(hrTable(ii,1)), 'Charge')
        plot([ii-1, ii], [0, 0],  'y', 'LineWidth', 80);
    elseif strcmp(char(hrTable(ii,1)), 'Downlink')
        plot([ii-1, ii], [0, 0],  'k', 'LineWidth', 80);
    else
        continue
    end
end
% Legend Creation and plot parameters
h = zeros(6, 1);
h(1) = plot(NaN,NaN,'-r', 'LineWidth', 2);
h(2) = plot(NaN,NaN,'-g', 'LineWidth', 2);
h(3) = plot(NaN,NaN,'-b', 'LineWidth', 2);
h(4) = plot(NaN,NaN,'-m', 'LineWidth', 2);
h(5) = plot(NaN,NaN,'-y', 'LineWidth', 2);
h(6) = plot(NaN,NaN,'-k', 'LineWidth', 2);
legend(h, 'Io', 'Europa', 'Ganymede', 'Callisto', 'Charging', 'Downlink', 'Location', 'best');
ylim([-1 1])
xlim([pltInd1 pltInd2])
title('Orbit Schedule')
yticks(0)
yticklabels({'Moons'})
grid minor
grid on
xlabel('time,hrs')
hold off
end

