% File paths for the activity log .mat files
runFile = "running.mat";
sitFile = "sitting.mat";
walkFile = "walking.mat";

% Load running data
runData = load(runFile);
runLogs = runData.Acceleration;
runLogs.Activity = repmat("running", size(runLogs, 1), 1); % Add activity label

% Load sitting data
sitData = load(sitFile);
sitLogs = sitData.Acceleration;
sitLogs.Activity = repmat("sitting", size(sitLogs, 1), 1); % Add activity label

% Load walking data
walkData = load(walkFile);
walkLogs = walkData.Acceleration;
walkLogs.Activity = repmat("walking", size(walkLogs, 1), 1); % Add activity label

% Combine all logs into a single structure or table
allLogs = [runLogs; sitLogs; walkLogs];

% Save combined data to a single .mat file
save("combinedActivityLogs.mat", "allLogs");

% Alternatively, you can continue to work with allLogs for further analysis
%% 
% Load data into MATLAB workspace (assuming allLogs contains the data)
load("combinedActivityLogs.mat", "allLogs");
disp(allLogs)
% Assuming allLogs is structured with fields like 'Acceleration', 'Timestamp', etc.
% Extract data for sitting, walking, and running
sitAcceleration = allLogs(allLogs.Activity == "sitting", :);
walkAcceleration = allLogs(allLogs.Activity == "walking", :);
runAcceleration = allLogs(allLogs.Activity == "running", :);

% Define activity labels
sitLabel = 'sitting';
walkLabel = 'walking';
runLabel = 'running';

% Convert labels to cell array of character vectors
sitLabel = cellstr(repmat(sitLabel, size(sitAcceleration, 1), 1));
walkLabel = cellstr(repmat(walkLabel, size(walkAcceleration, 1), 1));
runLabel = cellstr(repmat(runLabel, size(runAcceleration, 1), 1));

% Assign categorical labels to each subset of data
sitAcceleration.Activity = categorical(sitLabel);
walkAcceleration.Activity = categorical(walkLabel);
runAcceleration.Activity = categorical(runLabel);

% Combine all data into one table
allAcceleration = [sitAcceleration; walkAcceleration; runAcceleration];
% Remove 'Timestamp' variable (if it exists)
if ismember('Timestamp', allAcceleration.Properties.VariableNames)
    allAcceleration.Timestamp = [];
end

% Convert timetable to table (if needed)
allAcceleration = timetable2table(allAcceleration, "ConvertRowTimes", false);
% Now the data is ready to be used for training
disp("Data preparation complete.");
disp("Size of allAcceleration table:");
disp(size(allAcceleration));

%% 
% Load the test data
data = load("data1.mat");

% Display the contents of the loaded data
%disp(data);

% Extract the acceleration data from the test data
testAcceleration = data.Acceleration;
disp(testAcceleration)

% Convert the timetable to a table and remove the 'Timestamp' variable (if it exists)
testTable = timetable2table(testAcceleration, "ConvertRowTimes", false);

% Ensure the table has the same structure as the training data (excluding the response variable)
% For example, if the training data had columns 'X', 'Y', 'Z' for acceleration
predictorVars = {'X', 'Y', 'Z'};

% Select the necessary predictors from the test table
testPredictors = testTable(:, predictorVars);

% Display the prepared test predictors to verify
disp("Prepared test predictors:");
disp(testPredictors);

% Load the trained model (assuming trainedModel is already in the workspace or load it from a file)
% load('trainedModel.mat'); % Uncomment if you need to load the model from a file
% Use the trained model to make predictions on the test data
predictions = trainedModel.predictFcn(testPredictors);

% Display the predictions
disp("Predictions for the test data:");
disp(predictions);


%% 
plot(accelTime,Xacc);
hold on;
plot(accelTime,Yacc); 
plot(accelTime,Zacc);
xlim([0 50])
hold off
%% 
plot(accelTime,Xacc);
hold on;
plot(accelTime,Yacc); 
plot(accelTime,Zacc);
xlim([0 50])
legend('X Acceleration','Y Acceleration','Z Aceeleration');
xlabel('Time (s)')
ylabel('Acceleration (m/s^2)');
title('Acceleration Data Vs. Time');
hold off
%% 
% Convert predictions to categorical array for plotting
yfitcat = categorical(predictions);

% Plot the predictions using a pie chart
figure;
pie(yfitcat);
title('Activity Predictions Pie Chart');

