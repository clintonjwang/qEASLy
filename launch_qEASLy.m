function launch_qEASLy(nogui)
%launch_qEASLy entry point for qEASLy.
% Aaron Abajian. Minutes to seconds: A fully automated method for quantitative 3D tumor
% enhancement analysis based on contrast-enhanced MR imaging.
% Requires registered pre-contrast nifti, arterial nifti, whole liver mask,
% and tumor mask.

    addpath(genpath('../subroutines'));

    if nargin < 1
        nogui = false;
    end
    
    filename_map = load_config(try_find_file(pwd(), '**/config.txt', ...
        'Select the config file.', {'.txt'}));
    
%     switch button
%         case 'NIFTI'
%             filename_map('pre') = '**/pre_reg.nii*';
%             filename_map('art') = '**/20s.nii*';
%             filename_map('liver_seg') = '**/*liver.ids';
%             filename_map('tumor_seg') = '**/*tumor*.ids';
%         case 'DICOM'
%             filename_map('pre') = '**/T1_BL';
%             filename_map('art') = '**/T1_AP';
%             filename_map('liver_seg') = '**/*liver.ids';
%             filename_map('tumor_seg') = '**/*tumor*.ids';
%         case ''
%             return
%     end

    % Obtain MRIs and masks
%     if nogui
%         search_path = 'Z:\Isa';
%     else
%         search_path = uigetdir('', 'Select patient folder to search in');
%     end
    if contains(filename_map('pre'), '.nii')
        data = load_niis(filename_map);
    else
        data = load_dcms(filename_map);
    end
    % Run qEASLy
    [roi_mode, median_std] = qeasly_func(data.art, data.pre, data.liver_mask);
    % Get enhancing tumor volume
    [tumor_volume, std_median_enh_vol, enh_mask, nec_mask] = get_enhance_vol(data.pre,...
        data.art, data.tumor_mask, data.dim, roi_mode, median_std);

    % Save mask
    [~,~,~] = mkdir(filename_map('output'));
%     if nogui
%         save_dir = '.';
%     else
%         save_dir = uigetdir('', 'Select folder to save tumor masks in');
%     end

    write_ids_mask(enh_mask, filename_map('liver_seg'), filename_map('output'), 'viable_tumor');
    write_ids_mask(nec_mask, filename_map('liver_seg'), filename_map('output'), 'necrosis');

    % Print results to screen.
    if nogui
        disp([num2str(std_median_enh_vol), ' cm^3 enhancing tumor / ',...
            num2str(tumor_volume), ' cm^3 total tumor (', ...
            num2str(std_median_enh_vol*100/tumor_volume), '%)']);
    else
        msgbox([num2str(std_median_enh_vol), ' cm^3 enhancing tumor / ',...
            num2str(tumor_volume), ' cm^3 total tumor (', ...
            num2str(std_median_enh_vol*100/tumor_volume), '%)'], 'Results');
    end

    fclose('all');
    % if ~fast_ver
%     mask_names = {'viable_tumor', 'necrosis'};
%     mask_display_names = {'viable tumor', 'necrosis'};
%     display_scrolling_mask('20s', search_path, save_dir, mask_names, mask_display_names);
    % end

end