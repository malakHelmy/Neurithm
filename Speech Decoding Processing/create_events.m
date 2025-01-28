function EEG = create_events(EEG, info_table, tms, target, category)

    if tms == "True"
        info_table = info_table(info_table.TMS == 1,:);
        sufix = '_t';
    elseif tms == "False"
        info_table = info_table(info_table.TMS == 0,:);
        sufix = '_f';
    end

    if target == "BAO6"
        info_table = info_table(strcmpi(info_table.TMStarget, 'BAO6'),:);
        sufix = [sufix 'b'];
    elseif target == "control_BAO6"
        info_table = info_table(strcmpi(info_table.TMStarget, 'control_BAO6'),:);
        sufix = [sufix 'c'];
    elseif target == "Lip"
        info_table = info_table(strcmpi(info_table.TMStarget, 'lip'),:);
        sufix = [sufix 'l'];
    elseif target == "Tongue"
        info_table = info_table(strcmpi(info_table.TMStarget, 'tongue'),:);
        sufix = [sufix 't'];
    end
    
    if category == "real"
        info_table = info_table(strcmpi(info_table.Category, 'real'),:);
        sufix = [sufix 'r'];
    elseif category == "nonce"
        info_table = info_table(strcmpi(info_table.Category, 'nonce'),:);
        sufix = [sufix 'n'];
    elseif category == "Alveolar"
        info_table = info_table(strcmpi(info_table.Category, 'alveolar'),:);
        sufix = [sufix 'a'];
    elseif category == "Bilabial"
        info_table = info_table(strcmpi(info_table.Category, 'bilabial'),:);
        sufix = [sufix 'b'];
    end

    table_size = size(info_table);
    number_events = table_size(1);

    events = {};
    events.base_line = info_table.Base_Line;
    events.task_onset = info_table.Onset_TSidx;
    events.tms_1 = info_table.TMS0_TSidx;
    events.tms_2 = info_table.TMS_TSidx;
    events.stim_1 = info_table.P1_TSidx;
    events.stim_2 = info_table.P2_TSidx;
    events.task_final = info_table.Final_TSidx;

    events_types = fieldnames(events);

    for type = 1:length(events_types)
        for index = 1:number_events
            EEG.event(end+1).latency = events.(events_types{type})(index);
            EEG.event(end).type = string(events_types{type}) + sufix;
            
            % Concatenate phonemes (Phoneme1, Phoneme2, Phoneme3)
            phoneme = '';
            
            % Debugging: Print the current index and phoneme column values
            disp(['Processing event ', num2str(index)]);
            disp(['Phoneme1: ', num2str(info_table.Phoneme1{index})]);
            disp(['Phoneme2: ', num2str(info_table.Phoneme2{index})]);
            disp(['Phoneme3: ', categorical(info_table.Phoneme3(index))])


            % Add Phoneme1 if available
            if ~isempty(info_table.Phoneme1{index})
                phoneme = strcat(phoneme, info_table.Phoneme1{index});
            end

            % Add Phoneme2 if available
            if ~isempty(info_table.Phoneme2{index})
                phoneme = strcat(phoneme, info_table.Phoneme2{index});
            end

            % Add Phoneme3 if available
            if ~isempty(info_table.Phoneme3{index})
                phoneme = strcat(phoneme, info_table.Phoneme3{index});
            end

            % If phoneme is not empty, assign it to the event
            if ~isempty(phoneme)
                disp(['Concatenated Phoneme for event ', num2str(index), ': ', phoneme]);
                EEG.event(end).phoneme = phoneme; % Assign the concatenated phoneme to the event
            else
                disp(['No phoneme for event ', num2str(index)]);
            end
        end
    end

    EEG = eeg_checkset(EEG, 'eventconsistency'); % Check all events for consistency
end