% Load the data
dat = load('data1.mat'); 

% Extract data from the struct
lat = dat.Position.latitude;
lon = dat.Position.longitude;
positionDatetime = dat.Position.Timestamp;

%%
Xacc = dat.Acceleration.X;
Yacc = dat.Acceleration.Y;
Zacc = dat.Acceleration.Z;
accelDatetime = dat.Acceleration.Timestamp;

% Convert datetime to time in seconds relative to the first timestamp
positionTime = seconds(positionDatetime - positionDatetime(1));
accelTime = seconds(accelDatetime - accelDatetime(1));

% Display some parts of the data
disp('Position Data Sample:');
disp(table(lat(1:5), lon(1:5), positionDatetime(1:5)));

disp('Acceleration Data Sample:');
disp(table(Xacc(1:5), Yacc(1:5), Zacc(1:5), accelDatetime(1:5)));
%% 
function distance_miles = haversine(lat1, lon1, lat2, lon2)
    % Convert degrees to radians
    lat1 = deg2rad(lat1);
    lon1 = deg2rad(lon1);
    lat2 = deg2rad(lat2);
    lon2 = deg2rad(lon2);
    
    % Haversine formula
    dlat = lat2 - lat1;
    dlon = lon2 - lon1;
    a = sin(dlat/2)^2 + cos(lat1) * cos(lat2) * sin(dlon/2)^2;
    c = 2 * atan2(sqrt(a), sqrt(1-a));
    
    % Earth's radius in miles
    earthRadius_miles = 3958.8; % average radius of Earth in miles
    
    % Calculate distance in miles
    distance_miles = c * earthRadius_miles;
end
%% 
%disp(['The total distance traveled is: ', num2str(totaldis),' miles'])
%disp(['You took ', num2str(steps) ' steps'])
earthCirc = 24901; % Earth's circumference in miles
stride = 2.5; % Average stride length in feet

% Initialize total distance
totaldis = 0;

% Loop through each pair of points
for i = 1:(length(lat)-1)
    lat1 = lat(i);     % The first latitude
    lat2 = lat(i+1);   % The second latitude
    lon1 = lon(i);     % The first longitude
    lon2 = lon(i+1);   % The second longitude
    degDis = haversine(lat1, lon1, lat2, lon2);
    totaldis = totaldis + degDis;
end

% Convert total distance to feet
totaldis_ft = totaldis * 5280;

% Calculate the total number of steps
steps = totaldis_ft / stride;

% Display the results
disp(['The Total Distance Traveled is: ', num2str(totaldis), ' Miles'])
disp(['You Took ', num2str(steps), ' Steps'])