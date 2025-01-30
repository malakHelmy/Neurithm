clear; clc;
eeglab; % Start EEGLAB

% Define root path
root_dir = 'C:\Users\User\Documents\Speech Decoding 1\Study 2\Data Descriptors\EEG_Data';

% Define participant IDs
participants = {'P01', 'P02', 'P04', 'P05', 'P06'};

% Initialize data storage
X_data = {};
y_data = {};

% Loop through each participant
for i = 1:length(participants)
    participant = participants{i};
    preprocess_path = fullfile(root_dir, participant, 'Preprocess_and_analysis');
    
    % Find the .set file inside the folder
    set_files = dir(fullfile(preprocess_path, [participant, '_*_ica_and_trials_cleaned.set']));
    
    if isempty(set_files)
        fprintf('No .set file found for %s\n', participant);
        continue;
    end
    
    % Load EEG file
    set_file = fullfile(preprocess_path, set_files(1).name);
    EEG = pop_loadset('filename', set_file);

    % Extract EEG data
    epochs_data = EEG.data; % Shape: (n_channels, n_times, n_epochs)
    
    % Extract event info
    labels = cell(1, length(EEG.event));

    % Loop through each event to extract the phoneme
    disp('All events created:');
    for j = 1:length(EEG.event)
        if isfield(EEG.event(j), 'phoneme') && ~isempty(EEG.event(j).phoneme)
            labels{j} = EEG.event(j).phoneme; % Access the concatenated phoneme
        else
            labels{j} = 'unknown';  % If no phoneme, mark as 'unknown'
        end

        % Display event info for debugging
        disp(['Event ', num2str(j), ': Type = ', EEG.event(j).type, ', Latency = ', num2str(EEG.event(j).latency), ', Phoneme = ', labels{j}]);
    end

    for i = 1:length(EEG.epoch)
        disp(['Epoch ' num2str(i) ':'])
        disp(EEG.epoch(i).eventtype)
        disp(EEG.epoch(i).eventlatency)
        disp(EEG.epoch(i).eventphoneme)
    end

    % Group epochs based on phonemes
    phoneme_groups = containers.Map();
    for e = 1:length(EEG.epoch)
        if isfield(EEG.epoch(e), 'eventphoneme')
            epoch_phonemes = EEG.epoch(e).eventphoneme;
            unique_phoneme = unique(epoch_phonemes); % Get unique phonemes in epoch
            key = strjoin(unique_phoneme, '_'); % Create a unique key for the group
            
            if ~isKey(phoneme_groups, key)
                phoneme_groups(key) = [];
            end
            phoneme_groups(key) = [phoneme_groups(key), e];
        end
    end

    % Store the data
    X_data{end+1} = epochs_data;
    y_data = [y_data, labels];

    % Debugging: Print sample phonemes
    disp("Sample phoneme labels:");
    disp(labels(1:min(10, length(labels))));

    % Display grouped epochs
    disp("Grouped Epochs:");
    phoneme_keys = keys(phoneme_groups);
    for k = 1:length(phoneme_keys)
        disp(['Group ', phoneme_keys{k}, ': Epochs = ', num2str(phoneme_groups(phoneme_keys{k}))]);
    end
end