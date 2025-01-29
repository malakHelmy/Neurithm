clear; clc;
eeglab; % Start EEGLAB

% Define root path
root_dir = 'C:\Users\Dell\Documents\Speech Decoding\Study2\Data Descriptors\EEG_Data';

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
    events = EEG.event;
    labels = cell(1, length(events));

    % Loop through each event to extract the phoneme
    for j = 1:length(events)
        if isfield(events(j), 'eventphoneme')
            labels{j} = events(j).eventphoneme;
        else
            labels{j} = 'unknown';
        end
    end

    % Store the data
    X_data{end+1} = epochs_data;
    y_data = [y_data, labels];

    % Debugging: Print sample phonemes
    disp("Sample phoneme labels:");
    disp(labels(1:min(10, length(labels))));
end

% Convert cell arrays to matrices if possible
X_data = cat(3, X_data{:}); % Combine across epochs
y_data = string(y_data); % Convert labels to string array

% Print dataset info
fprintf('Total EEG samples: %d\n', size(X_data, 3));
fprintf('Total labels: %d\n', length(y_data));
