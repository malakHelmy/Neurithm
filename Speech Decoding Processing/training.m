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

% Convert cell arrays to matrices if possible
X_data = cat(3, X_data{:}); % Combine across epochs
y_data = string(y_data); % Convert labels to string array

% Print dataset info
fprintf('Total EEG samples: %d\n', size(X_data, 3));
fprintf('Total labels: %d\n', length(y_data));

% Normalize the data (scale between 0 and 1)
X_data_normalized = (X_data - min(X_data(:))) / (max(X_data(:)) - min(X_data(:)));

% Encode labels (convert to numeric values)
[~, ~, y_encoded] = unique(y_data); % Convert categorical labels to numeric values

% One-hot encode the labels
n_classes = length(unique(y_encoded));  % Number of classes
y_one_hot = full(ind2vec(y_encoded', n_classes))';  % One-hot encoding (transpose for consistency)

% Split the data into training & testing sets (80% training, 20% testing)
n_epochs = size(X_data_normalized, 3);
train_ratio = 0.8;
n_train = floor(n_epochs * train_ratio);
n_test = n_epochs - n_train;

% Randomly shuffle the data
rng(42);  % Set random seed for reproducibility
indices = randperm(n_epochs);

% Split the data
X_train = X_data_normalized(:, :, indices(1:n_train));
y_train = y_one_hot(indices(1:n_train), :);
X_test = X_data_normalized(:, :, indices(n_train+1:end));
y_test = y_one_hot(indices(n_train+1:end), :);

% Display the results
fprintf('Training Data Shape: [%d, %d, %d]\n', size(X_train));
fprintf('Testing Data Shape: [%d, %d, %d]\n', size(X_test));
fprintf('Number of Classes: %d\n', n_classes);
