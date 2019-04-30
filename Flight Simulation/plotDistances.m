function plotDistances(data,name)

time = data(:,1);
distXYZ = data(:,2:4);
dist = vecnorm(distXYZ,2,2);

figure
hold on
plot(time, dist, 'DisplayName', name)
xlabel('Time from Epoch, hrs')
ylabel('\Delta from JAC to moon, km')
legend('show', 'Location', 'best')
str1 = 'Distance from JAC to ';
title1 = [str1, name];
title({title1,'Optimal Range'})
xlim([0 length(time)])
hold off

end

