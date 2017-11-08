% Takes in a nifti file and outputs the qEASL segmentation, VOI chosen and qEASL values 
input = questdlg('Does the image need to be downloaded from ISD?');
% listdlg('ListString','hi', ...
%         'PromptString','there',...
%         'Name', 'ok', ...
%         'SelectionMode','single',...
%         'ListSize', [500, 300]);

if strcmpi(input, 'Cancel')
    return
    
elseif strcmpi(input, 'Yes')
    [volDat, volLabels, jsonVolInfo] = read_ISD_series();
    save('volDat.mat', 'volDat')
    save('volLabels.mat', 'volLabels')
    save('volLabels.mat', 'jsonVolInfo')
    
    [tumor_volume, std_median_enh_vol] = get_enhance_vol(data.pre,...
            data.art, data.tumor_mask, data.dim, roi_mode, median_std, 1,...
            strcat(patient_id, '_median'), slice);
        
else
    image_dir = './data/';
    patient_ids = {'0347479'};
    % cd(image_dir);
    addpath(genpath('./utils'));
    %[status, patient_ids] = system('dir /B');
    % patient_ids = ls;
    % patient_ids = textscan( patient_ids, '%s', 'delimiter', '\t' );
    % patient_ids = patient_ids{1};
    fprintf('PatID\tMode\tSTD_Min\tSTD_Max\tSTD_Mean\tSTD_Med\tTumor_Vol\tSTD_Mean_Enh_Vol\tSTD_Med_Enh_Vol\n');
    for k=1:length(patient_ids)
        patient_id = patient_ids{k};
        % Load masks.
        data = load_nifti_liver(image_dir, patient_id);
        % Run qEASLy.
        [roi_mode, min_std, max_std, mean_std, median_std] = ...
                qeasly_func(data.art, data.pre, data.liver_mask);

        % For now, just choose the middle slice.
        slice = int8(length(data.art(1,1,:)) / 2);

        % We calculate the tumor volume for each of the qEASLy discovered
        % parameters. Note that the mode is always the same.
        [~, std_min_enh_vol] = get_enhance_vol(data.pre,...
            data.art, data.tumor_mask, data.dim, roi_mode, min_std, 1,...
            strcat(patient_id, '_min'), slice);
        [~, std_max_enh_vol] = get_enhance_vol(data.pre,...
            data.art, data.tumor_mask, data.dim, roi_mode, max_std, 1,...
            strcat(patient_id, '_max'), slice);
        [~, std_mean_enh_vol] = get_enhance_vol(data.pre,...
            data.art, data.tumor_mask, data.dim, roi_mode, mean_std, 1,...
            strcat(patient_id, '_mean'), slice);
        [tumor_volume, std_median_enh_vol] = get_enhance_vol(data.pre,...
            data.art, data.tumor_mask, data.dim, roi_mode, median_std, 1,...
            strcat(patient_id, '_median'), slice);

        % Print the results to screen.
        disp([patient_id, sprintf('\t'), num2str(roi_mode), sprintf('\t'),...
            num2str(min_std), sprintf('\t'), num2str(max_std), sprintf('\t'),...
            num2str(mean_std), sprintf('\t'), num2str(median_std), sprintf('\t'),...
            num2str(tumor_volume), sprintf('\t'), num2str(std_mean_enh_vol), sprintf('\t'),...
            num2str(std_median_enh_vol) ]);

        % Export the enhancing tumor mask to ISD
        % The parenchyma VOI mask is not exported
        export_ISD_series(data)

        clear patient_id parameters roi_mode std_min std_max std_mean std_median data;
        %break
    end
end