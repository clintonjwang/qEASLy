function [] = draw_sliver(overlay, c_dat, sliver, intensity_mode, std_overall)
clf
image(overlay(:,:,sliver), 'CData', c_dat(:, :, sliver));
title(int2str(sliver));
hold on;
std_map = overlay > intensity_mode +  2 * std_overall;
[row,col] = find(std_map(:,:,sliver)' .* (overlay(:,:,sliver)' > 0));
plot(row, col, '.', 'Color', 'red');
colorbar;
end