%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function mask = get_mask(fpath, N1, N2, N3)%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fileID = fopen(fpath);
A = fread(fileID);
ind = find(A);
[i, j, k]=ind2sub([N2,N1,N3],ind);
fclose('all');

mask = zeros(N1,N2,N3);
for count=1:length(i)
    if i(count) > N1 || j(count) > N2 || k(count) > N3
        continue
    end
    mask(i(count),j(count),k(count))=1;
end

mask = transpose_mask_slices(mask);

return