function launch_qEASLy(fast_ver)
%launch_qEASLy entry point for qEASLy.
% Requires registered pre-contrast nifti, arterial nifti, whole liver mask,
% and tumor mask.

if nargin < 1
    fast_ver = true;
end

if ~fast_ver
    uiwait(msgbox(['This program performs qEASL with automatic selection '...
        'of the parenchyma volume of interest (also known as qEASLy). '...
        'It requires registered pre-contrast and arterial phase abdominal '...
        'MRIs (in nifti format) along with the whole liver and tumor masks '...
        '(in .ics/.ids format). It outputs masks of the enhancing tumor '...
        'and necrosis and displays enhancing volume. Only ICS version 1 is supported. '...
        'The program asks you to select a patient folder to look for the '...
        'MRIs/masks in. If it cannot find a file automatically, it will '...
        'prompt you for it.'], 'qEASLy utility', 'modal'));
end
    
addpath(genpath('./utils'));

% Obtain MRIs and masks
if fast_ver
    search_path = 'Z:\Isa\3';
else
    search_path = uigetdir('', 'Select patient folder to search in');
end

data = load_nifti_liver(search_path);
% Run qEASLy
[roi_mode, median_std] = qeasly_func(data.art, data.pre, data.liver_mask);
% Get enhancing tumor volume
[tumor_volume, std_median_enh_vol, enh_mask, nec_mask] = get_enhance_vol(data.pre,...
    data.art, data.tumor_mask, data.dim, roi_mode, median_std, 0,...
    'output', int8(length(data.art(1,1,:)) / 2));

% Save mask
if fast_ver
    save_dir = '.';
else
    save_dir = uigetdir('', 'Select folder to save tumor masks in');
end

write_ids_mask(enh_mask, search_path, save_dir, 'viable_tumor');
write_ids_mask(nec_mask, search_path, save_dir, 'necrosis');

% Print results to screen.
if fast_ver
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
mask_names = {'viable_tumor', 'necrosis'};
mask_display_names = {'viable tumor', 'necrosis'};
display_scrolling_mask('20s', search_path, save_dir, mask_names, mask_display_names);
% end

end