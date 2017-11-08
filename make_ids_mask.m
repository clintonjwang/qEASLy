function make_ids_mask( enh_mask )
%MAKE_IDS_MASK Summary of this function goes here
%   Detailed explanation goes here

fpath = try_find_file('.', '**/whole*liver.ics',...
            'Select any .ics file for this study', '*.ics');
ids_filename = 'enhancing_tumor.ids';
fileID = fopen(fpath);
A = fscanf(fileID,'%c');
ics_text = replace(A, A(regexp(A, '\nfilename')+1:regexp(A, '.ids')+3),...
    [sprintf('filename\t'), pwd(), '\', ids_filename]);

fileID = fopen('enhancingtumor.ics','w');
fwrite(fileID, ics_text);

enh_mask = transpose_mask_slices(enh_mask, 'w');
fileID = fopen(ids_filename,'w');
fwrite(fileID, enh_mask);

end

