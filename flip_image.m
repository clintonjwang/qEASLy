%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function image_o = flip_image(image)%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for k=1:size(image,3)
    image_o(:,:,k) = fliplr(fliplr(image(:,:,k))');
end