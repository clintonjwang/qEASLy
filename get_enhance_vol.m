function [tumor_vol, enhancing_vol, enh_mask, nec_mask] = get_enhance_vol(pre,...
    art, tumor_mask, vox_dims, intensity_mode, median_std)
% Given an arterial phase, a pre-contrast phase, a liver tumor mask and a
% threshold, this function returns the volume of tumor that passes the
% threshold.

    % First, calculate the intensity difference image.
    %diff = (art - pre) ./ (pre + 1);
    diff = art - pre;
    diff(tumor_mask == 0) = NaN;
    
    % Calculate the volume of enhancement, we divide by 1000 to get
    % centimeters.
    cutoff = intensity_mode + 2 * median_std;
    tumor_voxels = ~isnan(diff);
    tumor_voxel_values = diff(tumor_voxels);
    passing_cutoff = tumor_voxel_values >= cutoff;
    enh_mask = diff >= cutoff & ~isnan(diff);
    nec_mask = diff < cutoff & ~isnan(diff);
    
    single_voxel_volume = vox_dims(2) * vox_dims(3) * vox_dims(4) / 1000.0;
    enhancing_vol = sum(passing_cutoff(:)) * single_voxel_volume;
    tumor_vol = sum(tumor_voxels(:)) * single_voxel_volume;
end