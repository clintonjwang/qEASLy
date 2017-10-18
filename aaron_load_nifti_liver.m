function [data, seg_used] = aaron_load_nifti_liver(dest, patient)

data.patID = patient;

data.pre = load_nii([dest,patient,'/nii_files/pre.nii.gz']);
data.dim = data.pre.hdr.dime.pixdim;
data.pre = double(flip_image(data.pre.img));

data.art = load_nii([dest,patient,'/nii_files/20s.nii.gz']);
[N1,N2,N3] = size(double(flip_image(data.art.img)));
data.art = double(flip_image(data.art.img));

data.liver_mask = get_mask([dest, patient, '/segs/whole_liver.ids'], N1,N2,N3);
data.liver_mask = data.liver_mask>0;

% We check if a "tumor2" file exists, otherwise use tumor1.
if exist([dest, patient, '/segs/tumor2.ids'], 'file') == 2
    data.tumor_mask = get_mask([dest, patient, '/segs/tumor2.ids'], N1,N2,N3);
    seg_used = 'tumor2';
else
    data.tumor_mask = get_mask([dest, patient, '/segs/tumor.ids'], N1,N2,N3); 
    seg_used = 'tumor';
end
data.tumor_mask = data.tumor_mask > 0;

% See if there is an automatic tumor mask.
if exist([dest, patient, '/segs/Autom_liver.ids'], 'file') == 2
    data.automatic_liver_mask = get_mask([dest, patient, '/segs/Autom_liver.ids'], N1,N2,N3);
    data.automatic_liver_mask = data.automatic_liver_mask > 0;
end

% See if there is a 70s automatic tumor mask.
if exist([dest, patient, '/segs/Autom_liver_70s.ids'], 'file') == 2
    data.automatic_liver_mask_70 = get_mask([dest, patient, '/segs/Autom_liver_70s.ids'], N1,N2,N3);
    data.automatic_liver_mask_70 = data.automatic_liver_mask_70 > 0;
end

return
