image_dir = './all_segmentations/';
cd(image_dir);
%[status, patient_ids] = system('dir /B');
% patient_ids = ls;
% patient_ids = textscan( patient_ids, '%s', 'delimiter', '\t' );
% patient_ids = patient_ids{1};
patient_ids = {'3507684', '3630810', '3754594', '3932511', '4187895', '4287734', '4735186', '5028146', '5339277', '5878171', '0651494', '1653967', '2965221', '3580616', '3668700', '3790816', '3998062', '4221740', '4403148', '4925860', '5068285', '5373499', '5989645', '0909877', '1376533', '2252177', '3175464', '3594147', '3704286', '3850576', '4009266', '4231650', '4430467', '4933246', '5093069', '5425659'};
disp(sprintf('PatID\tTumor_Seg\tMode\tSTD_Minimum\tSTD_Maximum\tSTD_Mean\tSTD_Median\tTumor_Vol\tSTD_Minimum_Enh_Vol\tSTD_Maximum_Enh_Vol\tSTD_Mean_Enh_Vol\tSTD_Median_Enh_Vol'));
for patient_index=1:length(patient_ids)
    
    % Get the patient's ID.
    patient_id = patient_ids{patient_index};
    
    %if ~strcmp(patient_id, '0651494')
    %    continue
    %end
    
    %{
    if patient_id == '0651494'
        disp('');
        continue
    end
    %}
    
    % Load the patient.
    [data, seg_used] = aaron_load_nifti_liver(image_dir, patient_id);

    % Run qEASLy.
    [roi_mode, min_std, max_std, mean_std, median_std] = qeasly_func(data.art, data.pre, data.automatic_liver_mask_70);
    
    % For now, just choose the middle slice.
    slice = int8(length(data.art(1,1,:)) / 2);
    
    % We calculate the tumor volume for each of the qEASLy discovered
    % parameters. Note that the mode is always the same.
    [~, std_min_enh_vol] = qeasly_enhancing_tumor_volume(data.pre, data.art, data.tumor_mask, data.dim, roi_mode, min_std, 0, strcat(patient_id, '_min'), slice);
    [~, std_max_enh_vol] = qeasly_enhancing_tumor_volume(data.pre, data.art, data.tumor_mask, data.dim, roi_mode, max_std, 0, strcat(patient_id, '_max'), slice);
    [~, std_mean_enh_vol] = qeasly_enhancing_tumor_volume(data.pre, data.art, data.tumor_mask, data.dim, roi_mode, mean_std, 0, strcat(patient_id, '_mean'), slice);
    [tumor_volume, std_median_enh_vol] = qeasly_enhancing_tumor_volume(data.pre, data.art, data.tumor_mask, data.dim, roi_mode, median_std, 0, strcat(patient_id, '_median'), slice);
    %[tumor_volume, std_median_enh_vol] = qeasly_enhancing_tumor_volume(data.pre, data.art, data.tumor_mask, data.dim, roi_mode, median_std, 1, '', slice);

    % Finally, we output the results.
    disp([patient_id, sprintf('\t'), seg_used, sprintf('\t'), num2str(roi_mode), sprintf('\t'), num2str(min_std), sprintf('\t'), num2str(max_std), sprintf('\t'), num2str(mean_std), sprintf('\t'), num2str(median_std), sprintf('\t'), num2str(tumor_volume), sprintf('\t'), num2str(std_min_enh_vol), sprintf('\t'), num2str(std_max_enh_vol), sprintf('\t'), num2str(std_mean_enh_vol), sprintf('\t'), num2str(std_mean_enh_vol) ]);
    
    clear patient_id parameters roi_mode std_min std_max std_mean std_median data seg_used;
    %break
end