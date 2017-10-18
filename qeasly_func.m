function [roi_mode, min_std, max_std, mean_std, median_std] = qeasly_func(art, pre, liver_mask)
    diff = art - pre;
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
    min_std = min(local_stds);
    max_std = max(local_stds);
    mean_std = mean(local_stds);
    median_std = median(local_stds);
    %disp(sprintf('Mode\tSTD_Minimum\tSTD_Maximum\tSTD_Mean\tSTD_Median'));
    %disp([num2str(roi_mode), sprintf('\t'), num2str(min_std), sprintf('\t'), num2str(max_std), sprintf('\t'), num2str(mean_std), sprintf('\t'), num2str(median_std) ]);
end