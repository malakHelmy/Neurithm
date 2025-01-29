%% EEG DATA ANALYSIS FOR MULTIPLE PARTICIPANTS

clear;  % Clear workspace variables
clc;    % Clear command window

% Define the main folder containing participant data
main_folder = "C:\Users\User\Documents\Speech Decoding 1\Study 2\Data Descriptors\EEG_Data\";  % Main folder path
layout_file = 'C:\Users\User\Documents\Speech Decoding 1\Study 2\Data Descriptors\Sensors\sensors_layout_eeglab_without_bad_ch.ced';
participants = ["P01","P02","P04", "P05","P06","P08","P09","P10"];  % List of participant IDs

% MUST FIRST run eeglab command in command window
% File > Import Data > EEGLAB functions and plugins > From ANT EEProbe .CNT
% Choose .cnt file for each participant
% Name .set files as (ex: S01.set for P01,...)

% Open EEGLAB before the loop to ensure the GUI initializes
% ALLEEG contains all EEG datasets
% EEG has currently active dataset to be processed
% CURRENTSET is index of current dataset in ALLEEG
% ALLCOM has history of all commands done in EEGLAB
[ALLEEG, EEG, CURRENTSET, ALLCOM] = eeglab;

% Loop through each participant to process their data
for i = 1:length(participants)
    subject = participants(i);  % Get the current participant ID
    main_folder_subject = main_folder + subject + "\\";  % Construct the subject's main folder (ex: P01,P02,... folders)
    save_folder = main_folder_subject + "Preprocess_and_Analysis\\";  % Construct the save folder for the subject (preprocess_and_analysis folder in each of ex: P01,P02 folders)

    disp(['Processing subject: ', char(subject)]);  % Display which subject is being processed

    %% Load EEG Data
    try
        % Opens a pop-up to select the .set file for the current participant
        [file_name, path_name] = uigetfile({'*.set', 'EEGLAB Set Files (*.set)'}, ['Select recording for ' char(subject)], main_folder_subject);

        % Check if the user canceled the file selection
        if isequal(file_name, 0) || isequal(path_name, 0)
            disp(['User canceled the file selection for ' char(subject)]);
            continue;  % Skip to the next participant if no file is selected
        end

        % Load the .set file using EEGLAB
        EEG = pop_loadset('filename', file_name, 'filepath', path_name);  % Load the .set file
        [ALLEEG, EEG, CURRENTSET] = eeg_store(ALLEEG, EEG, 0);  % Store the .set file into an EEGLAB dataset
        EEG = eeg_checkset(EEG);  % Check the current dataset for any issues

        % Verify that data is loaded and display a confirmation message
        if ~isempty(EEG.data)
            disp(['EEG data successfully loaded for subject: ' char(subject)]);

            % Get the length of the EEG data
            eeg_length = size(EEG.data, 2);  % For EEG data, size(EEG.data, 2) gives the number of time points
            disp(['Length of EEG data: ' num2str(eeg_length)]);  % Display the length of the data
        else
            disp(['EEG data is empty for subject: ' char(subject)]);
            continue;  % Skip to the next participant if the data is empty
        end

        eeglab redraw;  % Redraw EEGLAB GUI

        %% REMOVE BAD CHANNELS
        EEG = pop_editeventvals(EEG, 'delete', 1:length(EEG.event));  % Deletes all previously assigned events from the EEG data
        [ALLEEG, EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);  % Stores the modified file into an EEGLAB dataset

        % Removes the bad channels
        % EOG used to monitor eye movements (not needed)
        % M1 & M2 reference channels for masteroid electrodes
        % BIP are bipolar channels that are considered bad or unnecessary
        EEG = pop_select(EEG, 'nochannel', {'EOG','M1','M2','BIP1','BIP2','BIP3','BIP4','BIP5','BIP6','BIP7',...
            'BIP8','BIP9','BIP10','BIP11','BIP12','BIP13','BIP14','BIP15',...
            'BIP16','BIP17','BIP18','BIP19','BIP20','BIP21','BIP22','BIP23','BIP24'});

        EEG = pop_chanedit(EEG, 'load', {layout_file, 'filetype','autodetect'});
        [ALLEEG, EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);  % Stores the modified file into an EEGLAB dataset

        disp(['Bad channels removed for subject: ' char(subject)]);  % Confirmation message for bad channels removal

        %% Save the Dataset with Removed Bad Channels

        % Create new .set file after removing bad channels
        [ALLEEG, EEG, ~] = pop_newset(ALLEEG, EEG, 1, 'setname', ...
            'Remove bad channels', 'savenew', char(save_folder + subject + "_0_remove_bad_channels.set"), 'gui', 'off'); % Save .set file inside Preprocess_and_Analysis folder of each participant

        eeglab redraw;  % Updates the EEGLAB interface

        disp(['Dataset saved for subject: ' char(subject) ' after removing bad channels.']);  % Confirmation message for saving the dataset

        %% EVENTS SETTINGS AND DATA REJECTION

        sample_frequency = EEG.srate;                                               % Gets the sampling frequency in Hz (indicates how many times the EEG signal was measured in one second)
        info_table_file = main_folder_subject + subject +"_Tab.csv";                % info table file path (ex: P01_Tab.csv in P01 folder)

        opts = detectImportOptions(info_table_file); % Detect options for the input file
        opts = setvartype(opts, {'Phoneme1', 'Phoneme2', 'Phoneme3'}, 'char'); % Set specific columns to char
        info_table = readtable(info_table_file, opts); % Read the table with updated options

        info_table.Base_Line = info_table.P1_TSidx - 0.5*sample_frequency;          % The base line interval is 500ms before the first audiotry stimulus (P1_TSidx)
        info_table.Onset_TSidx = info_table.P1_TSidx - 0.2*sample_frequency;        % The onset is 200ms before the first audiotry stimulus (P1_TSidx)
        info_table.TMS0_TSidx = info_table.P1_TSidx - 0.1*sample_frequency;         % The first TMS is 100ms the first audiotry stimulus (P1_TSidx)
        info_table.TMS_TSidx = info_table.P1_TSidx - 0.05*sample_frequency;         % The first TMS is 100ms the first audiotry stimulus (P1_TSidx)
        info_table.Final_TSidx = info_table.P1_TSidx + sample_frequency;            % Each trial ends 1 second after the first audiotry stimulus (P1_TSidx)

        EEG = create_events(EEG, info_table, 'True', 'BA06', 'real');               % Creates events: TMS on TONGUE target to "bilabial" tasks
        EEG = create_events(EEG, info_table, 'True', 'BA06', 'nonce');              % Creates events: TMS on TONGUE target to "alveolar" tasks

        EEG = create_events(EEG, info_table, 'True', 'Lip', 'Bilabial');           % Creates events: TMS on LIP target to "bilabial" tasks
        EEG = create_events(EEG, info_table, 'True', 'Lip', 'Alveolar');           % Creates events: TMS on tongue target to "alveolar" tasks

        EEG = create_events(EEG, info_table, 'True', 'Tongue', 'Bilabial');           % Creates events: TMS on TONGUE target to "bilabial" tasks
        EEG = create_events(EEG, info_table, 'True', 'Tongue', 'Alveolar');           % Creates events: TMS on TONGUE target to "alveolar" tasks


        % Create new .set file after creating events
        [ALLEEG, EEG, ~] = pop_newset(ALLEEG, EEG, 2, 'setname', ...
            'Set Events', 'savenew', char(save_folder + subject + "_1_set_events.set"), 'gui', 'off');  % Save .set file inside Preprocess_and_Analysis folder of each participant

        disp(['Events set for subject: ' char(subject)]);                           % (ex: "Events set for subject: S01")

        % Print all the created events with latencies and decoded phonemes
        disp('All events created:');
        for i = 1:length(EEG.event)
            % Access the concatenated phoneme from the event
            if isfield(EEG.event(i), 'phoneme') && ~isempty(EEG.event(i).phoneme)
                decoded_phoneme = EEG.event(i).phoneme;  % Get the concatenated phoneme
            else
                decoded_phoneme = 'N/A';  % In case phoneme is not available
            end

            % Display the event type, latency, and decoded phoneme
            disp(['Event ', num2str(i), ': Type = ', EEG.event(i).type, ', Latency = ', num2str(EEG.event(i).latency), ', Decoded Phoneme = ', decoded_phoneme]);
        end
        % Display the event type, latency, and decoded phoneme
        disp(['Event ', num2str(i), ': Type = ', EEG.event(i).type, ', Latency = ', num2str(EEG.event(i).latency), ', Decoded Phoneme = ', decoded_phoneme]);
       end



        eeglab redraw;   % Updates the EEGLAB interface

        %% BAD TMS SEGMENTS INTERPOLATION
        % Interpolates a part of the signal (relatives to setted events)



        if isempty(tms_true_index) || any(tms_true_index <= 0)
            error('No valid TMS indices to process.');
        end

        for index = tms_true_index'  % Runs through all TMS events
            tms_interval = max(1, index - 0.005 * sample_frequency) : min(size(EEG.data, 2), index + 0.025 * sample_frequency);

            if any(tms_interval < 1) || any(tms_interval > size(EEG.data, 2))
                error('Invalid tms_interval: ' + mat2str(tms_interval));
            end

            EEG.data(:, tms_interval) = nan;  % Fills with NaNs
        end

        for channel = 1:EEG.nbchan
            disp("Bad TMS ringing/step artifect removed from channel " + string(channel));
            EEG.data(channel,:) = fillgaps(double(EEG.data(channel,:)), 0.25*sample_frequency, 25);
        end

        [ALLEEG, EEG, ~] = pop_newset(ALLEEG, EEG, 3,'setname','Interpolate TMS true','savenew', char(save_folder + subject + "_2_tms_interpolated.set"),'gui','off');

        eeglab redraw;

        %% RESAMPLE, NOTCH FILTER, AND BANDPASS FILTER
        % Applies filters and resample the data

        EEG = pop_resample( EEG, 256);                                              % Resample the data to 256Hz
        sample_frequency = EEG.srate;                                               % Gets the sampling frequency

        %EEG = pop_eegfiltnew(EEG, 'locutoff',59,'hicutoff',61,'revfilt',1);
        EEG = pop_eegfiltnew(EEG, 'locutoff',0.1,'hicutoff',40);

        % Print all the created events with latencies and decoded phonemes
        disp('All events created after resampling: ');
        for i = 1:length(EEG.event)
            % Access the concatenated phoneme from the event
            if isfield(EEG.event(i), 'phoneme') && ~isempty(EEG.event(i).phoneme)
                decoded_phoneme = EEG.event(i).phoneme;  % Get the concatenated phoneme
            else
                decoded_phoneme = 'N/A';  % In case phoneme is not available
            end

            % Display the event type, latency, and decoded phoneme
            disp(['Event ', num2str(i), ': Type = ', EEG.event(i).type, ', Latency = ', num2str(EEG.event(i).latency), ', Decoded Phoneme = ', decoded_phoneme]);
        end


        [ALLEEG, EEG, ~] = pop_newset(ALLEEG, EEG, 4,'setname','Resampled data','savenew', char(save_folder + subject + "_3_resampled.set"),'gui','off');
        EEG = eeg_checkset( EEG );

        eeglab redraw;

        %% SAVE STAGE FIGURE

        disp(['Resampling done for subject: ' char(subject)]);  % Confirmation message for resampling

        % Inspect the dataset
        [EEGOUT, changes] = eeg_checkset(EEG);  % Check the integrity of the dataset

        % Display any changes or warnings
        if ~isempty(changes)
            disp('Changes made during consistency check:');
            disp(changes);
        else
            disp('No changes were made during consistency check.');
        end

        %% TRIAL SEGMENTATION

        available_events = {EEG.event.type};
        disp(['Available events in EEG: ', strjoin(available_events, ', ')]);
        disp(['Epoching for events: ', strjoin(available_events, ', ')]);

        % Perform epoching and baseline removal
        EEG = pop_epoch(EEG, available_events, [0 1], 'newname', 'Epochs', 'epochinfo', 'yes');
        EEG = pop_rmbase(EEG, [], []);

        % Print all the created events with latencies and decoded phonemes
        disp('All events created after trials segmentation: ');
        for i = 1:length(EEG.event)
            % Access the concatenated phoneme from the event
            if isfield(EEG.event(i), 'phoneme') && ~isempty(EEG.event(i).phoneme)
                decoded_phoneme = EEG.event(i).phoneme;  % Get the concatenated phoneme
            else
                decoded_phoneme = 'N/A';  % In case phoneme is not available
            end

            % Display the event type, latency, and decoded phoneme
            disp(['Event ', num2str(i), ': Type = ', EEG.event(i).type, ', Latency = ', num2str(EEG.event(i).latency), ', Decoded Phoneme = ', decoded_phoneme]);
        end

        disp(EEG);

        % Save the dataset
        [ALLEEG, EEG, ~] = pop_newset(ALLEEG, EEG, 5,'setname','Set trials','savenew', char(save_folder + subject + "_4_set_trials"+".set"),'gui','off');
        original_file = EEG;             % Copy the original structure
        EEG = eeg_checkset(EEG);        % Run eeg_checkset to possibly update the structure

        % Check if fields are the same
        if isequal(original_file, EEG)
            disp('No changes were made.');
        else
            disp('The file was updated by eeg_checkset.');
        end
        disp(['Saved dataset for participant ', subject, ' at: ', fullfile(save_folder, subject + "_4_set_trials" + ".set")]);

        %%  ICA DECOMPOSITION
        %% Perform ICA decomposition on the EEG data
        ICAfile = pop_runica(EEG, 'icatype', 'runica', 'extended', 1, 'interrupt', 'on');

        % Check if ICA was successful by inspecting the ICA weights and sphere matrices
        if isempty(ICAfile.icaweights) || isempty(ICAfile.icasphere)
            disp('ICA decomposition failed. The icaweights or icasphere matrices are empty.');
        else
            disp('ICA decomposition was successful. The icaweights and icasphere matrices are populated.');
            disp(['icaweights size: ', mat2str(size(ICAfile.icaweights))]);
            disp(['icasphere size: ', mat2str(size(ICAfile.icasphere))]);

            %% Apply ICLabel to classify components
            ICLabelFile = iclabel(ICAfile);
            % Set threshold to retain only "Brain" components
            brainThreshold = 0.5;  % Adjust this if needed

            % Loop through each component and mark for rejection
            for i = 1:size(ICLabelFile.icaweights, 1)
                classification = ICLabelFile.etc.ic_classification.ICLabel.classifications(i, :);
                if classification(1) >= brainThreshold
                    ICLabelFile.reject.gcompreject(i) = 0;  % Keep component
                else
                    ICLabelFile.reject.gcompreject(i) = 1;  % Mark component for rejection
                end
            end

            %% Now, remove bad trials based on rejected ICA components

            % Convert data to double precision
            double_icaweights = double(ICLabelFile.icaweights);
            double_data = double(ICAfile.data);

            % Ensure ICAfile.data is 3D: [channels x samples x trials]
            disp(['Size of ICAfile.data: ', mat2str(size(ICAfile.data))]);
            disp(['Size of ICLabelFile.icaweights: ', mat2str(size(ICLabelFile.icaweights))]);

            % Reshape or process data2D as needed
            % Average across time (samples) to get [channels x trials]
            data2D = squeeze(mean(double_data, 2));  % [channels x trials]

            % Verify the dimensions
            disp(['Size of data2D: ', mat2str(size(data2D))]);

            % Ensure the correlation is computed between ICA components and trials
            % Transpose data2D so it has components (rows) and trials (columns)
            data2D = data2D';  % Now it's [trials x channels], transpose to [channels x trials]

            % Compute correlation between ICA components and EEG data
            correlations = corr(double_icaweights', data2D');  % [components x trials] correlation matrix

            % Initialize trial rejection flags
            trialRejection = false(1, size(ICAfile.data, 3));  % [1 x trials]

            % Set a correlation threshold for trial rejection
            trialCorrelationThreshold = 0.3;  % reject trials with >30% correlation to rejected components

            % Loop through remaining components and mark trials for rejection based on correlation
            for i = 1:size(ICLabelFile.icaweights, 1)  % Loop through remaining components
                if ICLabelFile.reject.gcompreject(i) == 1  % If this component is rejected
                    badTrials = abs(correlations(i, :)) > trialCorrelationThreshold;
                    trialRejection = trialRejection | badTrials;  % Mark trials affected by this component
                end
            end

            % Validate that the input files are correctly loaded
            disp('Initial checks for ICAfile and ICLabelFile:');
            disp(['Size of ICAfile.data: ', mat2str(size(ICAfile.data))]);
            disp(['Size of ICLabelFile.icaweights: ', mat2str(size(ICLabelFile.icaweights))]);

            % Step 1: Remove bad trials from the EEG data
            % Assuming trialRejection is already defined ( trialRejection = bad_trials)
            TrialsCleanedFile = pop_rejepoch(ICAfile, trialRejection);  % Reject the identified bad trials

            % Step 3: Ensure the number of trials is properly defined after rejection
            num_trials = size(TrialsCleanedFile.data, 3);  % Number of remaining trials
            disp('Number of trials remaining after automatic rejection:');
            disp(num_trials);  % Display remaining trials

            % Step 4: Automatically remove marked components based on rejection in ICLabelFile
            TrialsandComponentsCleanedFile = pop_subcomp(TrialsCleanedFile, find(ICLabelFile.reject.gcompreject));  % Reject bad components in nonlabelled file
            ICLabelCleanedFile = pop_subcomp(ICLabelFile, find(ICLabelFile.reject.gcompreject));  % Reject bad components in labelled file but no trials

            % Print all the eventss
            disp('All events after removing bad trials and components:');
            for i = 1:length(TrialsandComponentsCleanedFile.event)
                % Access the concatenated phoneme from the event
                if isfield(TrialsandComponentsCleanedFile.event(i), 'phoneme') && ~isempty(TrialsCleanedFile.event(i).phoneme)
                    decoded_phoneme = TrialsandComponentsCleanedFile.event(i).phoneme;  % Get the concatenated phoneme
                else
                    decoded_phoneme = 'N/A';  % In case phoneme is not available
                end

                % Display the event type, latency, and decoded phoneme
                disp(['Event ', num2str(i), ': Type = ', TrialsandComponentsCleanedFile.event(i).type, ', Latency = ', num2str(TrialsandComponentsCleanedFile.event(i).latency), ', Decoded Phoneme = ', decoded_phoneme]);
            end
            % Final checks: Print the sizes of the cleaned dataset and ICA fields
            disp(['Size of TrialsandComponentsCleanedFile.data: ', mat2str(size(TrialsandComponentsCleanedFile.data))]);
            disp(['Size of TrialsandComponentsCleanedFile.icaweights: ', mat2str(size(TrialsandComponentsCleanedFile.icaweights))]);
            disp(['Size of TrialsandComponentsCleanedFile.icasphere: ', mat2str(size(TrialsandComponentsCleanedFile.icasphere))]);

            EEG = TrialsandComponentsCleanedFile;

            % Check and verify the dataset
            original_file = EEG;             % Copy the original structure
            EEG = eeg_checkset(EEG);        % Run eeg_checkset to possibly update the structure

            % Check if fields are the same
            if isequal(original_file, EEG)
                disp('No changes were made.');
            else
                disp('The file was updated by eeg_checkset.');
            end

            for i = 1:length(EEG.epoch)
                disp(['Epoch ' num2str(i) ':'])
                disp(EEG.epoch(i).eventtype)
                disp(EEG.epoch(i).eventlatency)
                disp(EEG.epoch(i).eventphoneme)
            end

            [ALLEEG, ICLabelCleanedFile, CURRENTSET] = pop_newset(ALLEEG,ICLabelCleanedFile, 7,'setname','Removed ICA bad components','savenew', char(save_folder + subject + "_5_ica_cleaned" + ".set"),'gui','off');

            [ALLEEG, EEG, CURRENTSET] = pop_newset(ALLEEG,EEG, 8,'setname','Removed ICA bad components and trials','savenew', char(save_folder + subject + "_6_ica_and_trials_cleaned"+ ".set"),'gui','off');

        end





        % Print final details about EEG to confirm everything is correct
        disp('=== Final EEG Details ===');
        disp(['Total number of epochs in EEG: ', num2str(length(EEG.epoch))]);  % Total number of epochs in EEG
        disp(['EEG data size: ', num2str(size(EEG.data))]);  % Size of EEG data (channels x time points x epochs)
        disp(['Number of channels: ', num2str(EEG.nbchan)]);  % Number of channels
        disp(['Number of trials (epochs): ', num2str(EEG.trials)]);  % Number of trials
        disp(['Event types in EEG: ', strjoin({EEG.event.type}, ', ')]);  % Event types in EEG
        disp(['Epochs details (first 5 epochs):']);
        disp(EEG.epoch(1:min(5, length(EEG.epoch))));  % Print details of the first 5 epochs

        % Print all the created events with latencies and decoded phonemes
        disp('All events created:');
        for i = 1:length(EEG.event)
            % Access the concatenated phoneme from the event
            if isfield(EEG.event(i), 'phoneme') && ~isempty(EEG.event(i).phoneme)
                decoded_phoneme = EEG.event(i).phoneme;  % Get the concatenated phoneme
            else
                decoded_phoneme = 'N/A';  % In case phoneme is not available
            end

            % Display the event type, latency, and decoded phoneme
            disp(['Event ', num2str(i), ': Type = ', EEG.event(i).type, ', Latency = ', num2str(EEG.event(i).latency), ', Decoded Phoneme = ', decoded_phoneme]);
        end

    catch ME
        disp(['Error processing subject ' char(subject) ': ' ME.message]);  % Display any error messages
    end
end

msgbox("All participants processed successfully!", "Done", "help");  % Show a message when all subjects are done