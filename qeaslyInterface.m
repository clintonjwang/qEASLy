function [ status, message, outputVolumes ] = qeaslyInterface( inputVolumes )
%QEASLYINTERFACE Summary of this function goes here
%   Detailed explanation goes here

status = false;
dims = inputVolumes{1}{1}.NumberOfVoxels';
data = struct;
data.dim = [1; inputVolumes{1}{1}.VolumeExtent ./ double(inputVolumes{1}{1}.NumberOfVoxels)];
data.pre = reshape(inputVolumes{1}{3}, dims);
data.art = reshape(inputVolumes{2}{3}, dims);
data.liver_mask = reshape(inputVolumes{3}{3}, dims);
data.tumor_mask = reshape(inputVolumes{4}{3}, dims);

% search_path = inputParams.search_path; %path to look for template mask file
% save_dir = inputParams.save_dir; %path to save mask file

% Run qEASLy
[roi_mode, median_std] = qeasly_func(data.art, data.pre, data.liver_mask);

% Get enhancing tumor volume
[tumor_volume, std_median_enh_vol, enh_mask, nec_mask] = get_enhance_vol(data.pre,...
    data.art, data.tumor_mask, data.dim, roi_mode, median_std);

% write_ids_mask(enh_mask, search_path, save_dir, 'viable_tumor');
% write_ids_mask(nec_mask, search_path, save_dir, 'necrosis');

outputVolumes = cell(2,4);
outputHeader = inputVolumes{4}{1};
outputMetaDataDict = inputVolumes{4}{2};
for i = 1:2
    outputVolumes{1}{1} = outputHeader;
    outputVolumes{1}{2} = outputMetaDataDict;
end
outputVolumes{1}{3} = enh_mask;
outputVolumes{2}{3} = nec_mask;
outputVolumes{1}{1}.Description = 'Viable Tumor Mask';
outputVolumes{2}{1}.Description = 'Necrosis Mask';

status = true;
% Print results to screen.
message = [num2str(std_median_enh_vol), ' cm^3 enhancing tumor / ',...
        num2str(tumor_volume), ' cm^3 total tumor (', ...
        num2str(std_median_enh_vol*100/tumor_volume), '%)'];
end