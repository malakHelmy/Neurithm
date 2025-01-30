clear; clc;
eeglab; % Start EEGLAB

% Define root path
root_dir = 'C:\Users\Dell\Documents\Speech Decoding\Study2\Data Descriptors\EEG_Data';

% Define participant IDs
participants = {'P01', 'P02', 'P04', 'P05', 'P06'};

% Initialize data storage
X_data = [];
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
    num_epochs = size(epochs_data, 3);
    
    % Initialize phoneme group mapping
    phoneme_groups = containers.Map();
    
    % Iterate over epochs to group by phonemes
    for e = 1:num_epochs
        if isfield(EEG.epoch(e), 'eventphoneme')
            epoch_phonemes = EEG.epoch(e).eventphoneme;
            unique_phoneme = unique(epoch_phonemes); % Get unique phonemes in epoch
            key = strjoin(unique_phoneme, '_'); % Create a unique key for the group
            
            if ~isKey(phoneme_groups, key)
                phoneme_groups(key) = [];
            end
            phoneme_groups(key) = [phoneme_groups(key), e]; % Store epoch indices
        end
    end

    % Store EEG epochs in X_data
    fprintf('Processing participant: %s\n', participant);
    fprintf('Number of epochs: %d\n', num_epochs);

    if isempty(X_data)
        X_data = epochs_data; % Initialize with first participant's data
    else
        X_data = cat(3, X_data, epochs_data); % Concatenate epochs along the 3rd dimension
    end
    fprintf('Total stored epochs so far: %d\n', size(X_data, 3));

    % Assign correct phoneme label to each epoch
    for e = 1:num_epochs
        assigned_phoneme = "unknown"; % Default label

        % Find the epoch's corresponding phoneme group
        phoneme_keys = keys(phoneme_groups);
        for k = 1:length(phoneme_keys)
            key = phoneme_keys{k};
            if ismember(e, phoneme_groups(key)) % Check if epoch e belongs to this group
                assigned_phoneme = key;
                break;
            end
        end
        y_data{end+1} = assigned_phoneme; % Store label

        % Debugging print statements
        fprintf('Epoch %d assigned to phoneme group: %s\n', e, assigned_phoneme);
    end
    fprintf('Total stored labels in y_data: %d\n', length(y_data));


    % Display grouped epochs info
    disp("Grouped Epochs:");
    for k = 1:length(phoneme_keys)
        disp(['Group ', phoneme_keys{k}, ': Epoch Count = ', num2str(length(phoneme_groups(phoneme_keys{k}))) ]);
    end
end


% Convert y_data to string array
y_data = string(y_data);

% Print dataset summary
fprintf('Total EEG epochs: %d\n', size(X_data, 3));
fprintf('Total phonemes: %d\n', length(y_data));

% Normalize the EEG data (scale between 0 and 1)
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