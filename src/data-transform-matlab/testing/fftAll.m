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

channel_id = 147;
% channel_id = [133:138, 145:149, 156:158, 165:169, 174:176];
% channel_id = [1:256];

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
    dataRaw = dataRaw{1, 1};
    for j = 1:length(dataRaw.event)
        if strcmp(dataRaw.event(j).type,'begi')
            beginningLatency = dataRaw.event(j).latency;
        end
        if strcmp(dataRaw.event(j).type, 'RFix')
            stopTrainingLatency = dataRaw.event(j).latency;
        end
        if strcmp(dataRaw.event(j).type,'StFL')
            testingPhase = 1;
            testingLatency = dataRaw.event(j).latency;
     
        end
    end
    
    EEG_data = mat_file.dataRaw.trial{1,1};
    pre_data_all = EEG_data(channel_id,beginningLatency:stopTrainingLatency);
    post_data_all = EEG_data(channel_id,testingLatency:end);
          
    pre_data  = mean(pre_data_all, 1);
    post_data = mean(post_data_all,1);
    Y = fft(pre_data);
    %Y_post = fft(post_data);
    
    L = size(Y, 2);
    P2 = abs(Y/L);
    P1 = P2(1:L/2+1);
    P1(2:end-1) = 2*P1(2:end-1);

    
    Fs = EEG.srate;
    f = Fs *(0:(L/2))/L;
    
    
    % plot(f,P1) 
    
    
    
    %hold on
    moving_avg = smoothdata(P1,'gaussian',50);
    plot(f,  moving_avg')
    title('Single-Sided Amplitude Spectrum of X(t)')
    xlabel('f (Hz)')
    ylabel('|P1(f)|')
    
    xlim([5 20])
    hold on
    
end
