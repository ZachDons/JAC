function [vecMoon] = RM_Obstruct(tbodies, JAC, Jup, degObs)

% Bodies:
% 1)Io 2)Europa 3)Ganymede 4)Callisto 5)JAC 6)Jup
bodies = tbodies(:,2:4,:); %remove time vect for ease of geom calculations
numMoon = 1:4;
lenData = length(JAC);
vecMoon = tbodies;
% Optimum Range for viewing 
% uLim = 1200000; %km
% lLim = 800000; %km
% uLim_Call = 1500000; %km
uLim = 2000000; %km
lLim = 0; %km
uLim_Call = 2000000; %km


for ii = numMoon
    % Pick moon being observed
    iMoon = bodies(:,:,ii);
    % Vector btwn observed moon and JAC over orbit
    JAC2Moon = JAC-iMoon;
    
    % Calc vectors to all other moons
    wallMoon = numMoon;
    wallMoon(wallMoon==ii) = []; %remove observed moon
    %vectors from JAC to obstruction moons
    JAC2wall(:,:,1) = JAC-bodies(:,:,wallMoon(1));
    JAC2wall(:,:,2) = JAC-bodies(:,:,wallMoon(2));
    JAC2wall(:,:,3) = JAC-bodies(:,:,wallMoon(3));
    %vector from JAC to Jup
    JAC2wall(:,:,4) = JAC-Jup;
    
    % Test Obstruction
    for jj = 1:length(JAC)
        cond1 = atan2d(norm(cross(JAC2wall(jj,:,1),JAC2Moon(jj,:))),dot(JAC2wall(jj,:,1),JAC2Moon(jj,:)));
        cond2 = atan2d(norm(cross(JAC2wall(jj,:,2),JAC2Moon(jj,:))),dot(JAC2wall(jj,:,2),JAC2Moon(jj,:)));
        cond3 = atan2d(norm(cross(JAC2wall(jj,:,3),JAC2Moon(jj,:))),dot(JAC2wall(jj,:,3),JAC2Moon(jj,:)));
        cond4 = atan2d(norm(cross(JAC2wall(jj,:,4),JAC2Moon(jj,:))),dot(JAC2wall(jj,:,4),JAC2Moon(jj,:)));
        cond5 = atan2d(norm(cross(Jup(jj,:),JAC2Moon(jj,:))),dot(Jup(jj,:),JAC2Moon(jj,:)));
        
        %degObs = 1; % Obstruction from moon
        if cond1<degObs(1) || cond2<degObs(1) || cond3<degObs(1) %remove possible time point if obstructed
            JAC2Moon(jj,:) = nan;
        end
        
        %degObs = 1; % Obstruction from Jupiter
        if cond4<degObs(2) %remove possible time point if obstructed
            JAC2Moon(jj,:) = nan;
        end
        
        %degObs = 2; % Obstruction from Sun
        if cond5<degObs(3) %remove possible time point if obstructed
           JAC2Moon(jj,:) = nan; 
        end 
    end
    % Available range for each moon that fits "optimum conditions"
    moonDist = vecnorm(JAC2Moon,2,2);
    if ii == 4
        JAC2Moon(moonDist>uLim_Call,:) = nan;
    else
        JAC2Moon(moonDist>uLim,:) = nan;
    end
    JAC2Moon(moonDist<lLim,:) = nan;
    vecMoon(:,2:4,ii) = JAC2Moon;
    tempBod = vecMoon(:,:,ii);
    tempBod(any(isnan(tempBod),2),:) = nan;
    vecMoon(:,:,ii) = tempBod;
end



