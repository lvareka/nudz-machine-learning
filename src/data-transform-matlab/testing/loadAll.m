% Script for connecting raw and preprocessed events
% and/or for epoch extraction
% 11. 11. 2020, Lukas Vareka

% config
dir_raw = 'E:\eeg_data\NUDZ\';
dir_preprocessed = 'E:\eeg_data\NUDZ\Preprocessed\';
raw_files = ls([dir_raw, '*.mff']);
pre_files = ls([dir_preprocessed, '*.mat']);
nfiles = size(raw_files, 1);
featureCollector = FeatureCollector(2000);

% number of raw and preprocessed files must match
if size(pre_files, 1) ~= nfiles
    return;
end

% Counter of events for all participants datasets
resultsCounts = zeros(nfiles, 2);

for i = 1:nfiles
    % Check if filenames are in line with expectations
    if ~contains(raw_files(i, :), ['0', num2str(i)])
        return;
    end
    if ~contains(pre_files(i, :), ['0', num2str(i)])
        return;
    end
   
    % Copy events from raw to preprocessed data
    input_file = [dir_raw, raw_files(i, :), '\'];
    EEG = pop_readegimff(input_file);
    mat_file = load([dir_preprocessed, pre_files(i, :)]);
    mat_file.dataRaw.event = EEG.event;
    dataRaw = {mat_file.dataRaw};
    % save([dir_preprocessed, 'out\we_', pre_files(i, :)], 'dataRaw',  '-v7.3');
    
    % Count stimuli (and store extracted epochs/trials)
    [countHouse, countFace, countHRep, countFRep] = countStimuli(dataRaw, featureCollector);
    resultsCounts(i, 1) = countHouse;
    resultsCounts(i, 2) = countFace;
    
end
