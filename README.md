# Feature-Extraction
With data collected every minute over a year across five classes, extracting time-domain features is essential to convert raw temporal data into structured, pattern-rich inputs suitable for machine learning.
Using this set of formula to calculate the 15 features
function  [SFeatures]= statisticalFeatures(x)

N = size(x,1);
    %T1. Mean
    FeaturesVector(1) = mean(x);
    %T2. Maxim value
    FeaturesVector(2) = max(x);
    %T3. Root mean square
    FeaturesVector(3) = sqrt(sum(x.^2)/N);
    %T4. Square Root mean
    FeaturesVector(4) = (sum(sqrt(abs(x)))/N)^2;
    %T5. Standard deviation
    FeaturesVector(5) = std(x,1);
    %T6. Variance
    FeaturesVector(6) = var(x,1);
    %T7. Shape factor (with RMS)
    FeaturesVector(7) = FeaturesVector(3)/((sum(abs(x)))/N);
    %T8. Shape factor (with SRM)
    FeaturesVector(8) = FeaturesVector(4)/((sum(abs(x)))/N);
    %T9. Crest factor
    FeaturesVector(9) = FeaturesVector(2)/FeaturesVector(3);
    %T10. Latitude factor
    FeaturesVector(10) = FeaturesVector(2)/FeaturesVector(4);
    %T11. Impulse factor
    FeaturesVector(11) = FeaturesVector(2)/((sum(abs(x)))/N);
    %T12. Skewness
    FeaturesVector(12) = skewness(x);
    %T13. Kurtosis
    FeaturesVector(13) = kurtosis(x);
    %T14. Normalised 5th central moment
    FeaturesVector(14) = moment(x,5)/((std(x,1)^5));
    %T15. Normalised 6th central moment
    FeaturesVector(15) = moment(x,6)/((std(x,1)^6));
    SFeatures = FeaturesVector;
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
% === STEP 1: Standardize FAULT_TYPE column to string format ===
Combine.FAULT_TYPE = string(Combine.FAULT_TYPE)

% === STEP 2: Get all unique fault types ===
faultTypes = unique(Combine.FAULT_TYPE)

% === STEP 3: Identify numeric variables (exclude FAULT_TYPE and datetime) ===
numericVarIdx = varfun(@isnumeric, Combine, 'OutputFormat', 'uniform')
numericVarNames = Combine.Properties.VariableNames(numericVarIdx)
numericVarNames = setdiff(numericVarNames, {'FAULT_TYPE'})  % Exclude FAULT_TYPE

% === STEP 4: Define 15 statistical feature names ===
featureNames = {
    'Mean', 'Max', 'RMS', 'SRM', 'StdDev', 'Variance', ...
    'ShapeFactor_RMS', 'ShapeFactor_SRM', 'CrestFactor', ...
    'LatitudeFactor', 'ImpulseFactor', 'Skewness', ...
    'Kurtosis', 'Norm5thMoment', 'Norm6thMoment'
}

% === STEP 5: Initialize results container ===
results = {}

% === STEP 6: Loop through each fault type and each variable ===
for f = 1:length(faultTypes)
    currentFault = faultTypes(f)
    subTable = Combine(Combine.FAULT_TYPE == currentFault, :)  % Filter rows
    
    for v = 1:length(numericVarNames)
        varName = numericVarNames{v}
        data = subTable.(varName)
        
        % Skip if data is all NaN or constant
        if all(isnan(data)) || std(data, 'omitnan') == 0
            continue
        end
        
        % Remove NaNs for processing
        data = data(~isnan(data))
        
        % Compute statistical features
        features = statisticalFeatures(data)  % Your provided function
        
        % Append to results: {FaultType, VariableName, Feature1...Feature15}
        results(end+1, :) = [{currentFault}, {varName}, num2cell(features)] %#ok<SAGROW>
    end
end

% === STEP 7: Convert to table ===
allFeatureNames = [{'FaultType', 'Variable'}, featureNames]
SFeaturesByFault = cell2table(results, 'VariableNames', allFeatureNames)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Visulizing the 15 features more clearly for all the fault types
selectedFeature = 'Mean';

% Get feature values
meanValues = [];
labels = [];

for f = 1:length(faultTypes)
    currentFault = faultTypes(f);
    subTable = SFeaturesByFault(SFeaturesByFault.FaultType == currentFault, :);
    
    % Take average across variables
    val = mean(subTable.(selectedFeature), 'omitnan');
    meanValues(end+1) = val;
    labels{end+1} = currentFault;
end

% Plot
figure;
bar(meanValues);
xticks(1:length(labels));
xticklabels(labels);
xtickangle(45);
ylabel(selectedFeature + " ", 'FontWeight', 'bold');
title(selectedFeature + " of Each Fault Type", 'FontWeight', 'bold');
grid on;
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
