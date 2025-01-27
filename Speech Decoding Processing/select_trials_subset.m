function [save_subfolder, sufix, events] = select_trials_subset(category, with_tms, with_task)

if with_tms == "True" && with_task == "True"
    if category == "LA"
        save_subfolder = "\tms_true_lip\";
        sufix = "_tla";
        events = {'base_line_tla'}; 
    elseif category == "LB"
        save_subfolder = "\tms_true_lip\";
        sufix = "_tlb";
        events = {'base_line_tlb'}; 
    elseif category == "TA"
        save_subfolder = "\tms_true_tongue\";
        sufix = "_tta";
        events = {'base_line_tta'}; 
    elseif category == "TB"
        save_subfolder = "\tms_true_tongue\";
        sufix = "_ttb";
        events = {'base_line_ttb'}; 
    end
end       
end