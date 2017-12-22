function [roi_mode, median_std] = qeasly_func(art, pre, liver_mask)
%QEASLY_FUNC Selects parechyma ROI

    diff = double(art - pre);
    
    diff(liver_mask == 0) = NaN;
    sz = size(diff);
    
    [bin_counts, bin_edges, bin_indices] = histcounts(diff(:), 1000);
    [~, I] = max(bin_counts);

    roi_mode = mean([bin_edges(I) bin_edges(I+1)]);
    s = 5;
    local_stds_index = 1;
    local_stds = zeros(1, bin_counts(I));

    for counter = 1:length(bin_indices)
        bin_index = bin_indices(counter);
        
        if bin_index == I
            [i, j, k] = ind2sub(sz, counter);
            
            if i > s && j > s && k > s && i <= sz(1) - s - 1 && j <= sz(2) - s - 1 && k <= sz(3) - s - 1
                
                local_intensities = diff(i-s:i+s-1,j-s:j+s-1,k-s:k+s-1);
                local_stds(local_stds_index) = std(local_intensities(:));
                local_stds_index = local_stds_index + 1;
            end
        end
    end
    
    local_stds = local_stds(local_stds > 0);
    median_std = median(local_stds);
end