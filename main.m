fast_ver = true;

if ~fast_ver
    uiwait(msgbox(['This program performs qEASL with automatic selection '...
        'of the parenchyma volume of interest (also known as qEASLy). '...
        'It requires registered pre-contrast and arterial phase abdominal '...
        'MRIs (in nifti format) along with the whole liver and tumor masks '...
        '(in .ics/.ids format). It outputs a mask of the enhancing tumor (in '...
        '.ics/.ids format) as well as its volume. Only ICS version 1 is supported. '...
        'The program asks you to select a patient folder to look for the '...
        'MRIs/masks in. If it cannot find a file automatically, it will '...
        'prompt you for it.'], 'qEASLy utility', 'modal'));
end
    
addpath(genpath('./utils'));

% Obtain MRIs and masks
search_path = '../data/5989645';
% search_path = uigetdir('', 'Select patient folder to search in');
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
    save_dir = uigetdir('', 'Select folder to save enhancing tumor mask in');
end

write_ids_mask(enh_mask, search_path, 'enh', 'viable_tumor');
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