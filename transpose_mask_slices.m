%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function mask1 = transpose_mask_slices(mask)%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[N1,N2,N3] = size(mask);

mask1 = zeros(N1,N2,N3);

for k=1:N3
    for i=1:N1
        for j=1:N2
            if(mask(i,j,k)==1)
                mask1(j,i,k)=1;
            end
        end
    end
end

return