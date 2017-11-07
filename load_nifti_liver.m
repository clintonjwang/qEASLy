function data = load_nifti_liver(dest, patient, segs_dir)
if nargin < 3
    segs_dir = '/new segs';
end

data.patID = patient;

data.pre = try_load_file([dest,patient,'/nii_files/pre.nii.gz'], 'Select the pre-contrast nifti file');
data.dim = data.pre.hdr.dime.pixdim;
data.pre = double(flip_image(data.pre.img));

data.art = try_load_file([dest,patient,'/nii_files/20s.nii.gz'], 'Select the 20s post-contrast nifti file');
[N1,N2,N3] = size(double(flip_image(data.art.img)));
data.art = double(flip_image(data.art.img));

f=dir(fullfile([dest, patient, segs_dir], '**/whole*liver.ids'));
data.liver_mask = get_mask([f.folder, '/', f.name], N1,N2,N3);
data.liver_mask = data.liver_mask>0;

% We check if a "tumor2" file exists, otherwise use tumor1.
f=dir(fullfile([dest, patient, segs_dir], '**/*tumor2.ids'));

if ~isempty(f)
    data.tumor_mask = get_mask([f.folder, '/', f.name], N1,N2,N3);
else
    f=dir(fullfile([dest, patient, segs_dir], '**/*tumor*.ids'));
    data.tumor_mask = get_mask([f.folder, '/', f.name], N1,N2,N3);
end
data.tumor_mask = data.tumor_mask > 0;

% See if there is an automatic tumor mask.
f=dir(fullfile([dest, patient, segs_dir], '**/Autom*liver.ids'));
if ~isempty(f)
    data.automatic_liver_mask = get_mask([f.folder, '/', f.name], N1,N2,N3);
    data.automatic_liver_mask = data.automatic_liver_mask > 0;
end

% See if there is a 70s automatic tumor mask.
f=dir(fullfile([dest, patient, segs_dir], '**/Autom*liver*70s.ids'));
if ~isempty(f)
    data.automatic_liver_mask_70 = get_mask([f.folder, '/', f.name], N1,N2,N3);
    data.automatic_liver_mask_70 = data.automatic_liver_mask_70 > 0;
end

return
