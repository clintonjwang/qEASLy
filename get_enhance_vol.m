function [tumor_volume, enhancing_volume, enh_mask] = get_enhance_vol(pre,...
    art, tumor_mask, dimension, intensity_mode, median_std, draw, out_file_name, slice)
% Given an arterial phase, a pre-contrast phase, a liver tumor mask and a
% threshold, this function returns the volume of tumor that passes the
% threshold.

    % First, calculate the intensity difference image.
    %diff = (art - pre) ./ (pre + 1);
    diff = art - pre;
    
    % Restrict the difference to voxels within the tumor.
    original_image = diff;
    diff(tumor_mask == 0) = NaN;
    %diff(tumor_mask = 0) = 0;
    
    % Calculate the volume of enhancement, we divide by 1000 to get
    % centimeters.
    cutoff = intensity_mode + 2 * median_std;
    tumor_voxels = ~isnan(diff);
    tumor_voxel_values = diff(tumor_voxels);
    passing_cutoff = tumor_voxel_values >= cutoff;
    enh_mask = diff >= cutoff;
    
    single_voxel_volume = dimension(2) * dimension(3) * dimension(4) / 1000.0;
    enhancing_volume = sum(passing_cutoff(:)) * single_voxel_volume;
    tumor_volume = sum(tumor_voxels(:)) * single_voxel_volume;

    % Optionally draw the image.
    if draw == 1
        max_intensity  = max(original_image(:));
        
        if ~isempty(out_file_name)
            figure('Position', [1024 300 800 800], 'Visible', 'off');
        else
            figure('Position', [1024 300 800 800]);
        end

        c_dat = 255 * original_image / max_intensity;
        colormap(gray);
        
        draw_sliver(diff, c_dat, slice, median_std, intensity_mode);
        
        if ~isempty(out_file_name)
            saveas(gcf,strcat(out_file_name, '_slice_', int2str(slice), '.png'));
        else
            max_z = length(original_image(1,1,:));
            while(true)
                draw_sliver(diff, c_dat, slice, median_std, intensity_mode);
                waitforbuttonpress;
                c = get(gcf,'CurrentCharacter');
                if(strcmp(c,'u'))
                    slice = min(slice+1, max_z);

                elseif(strcmp(c,'d'))
                    slice = max(slice-1,1);

                elseif(strcmp(c,'c'))
                    close all
                    return
                end
            end
        end
        
    end
end