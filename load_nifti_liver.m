function data = load_nifti_liver(dest)
%LOAD_NIFTI_LIVER Loads pre/art phases and liver/tumor segs.

nii_ext = {'*.nii; *.hdr; *.img; *.nii.gz'};

data.pre = load_nii(try_find_file(dest, '**/pre.nii.gz',...
                    'Select the pre-contrast nifti file', nii_ext));
data.dim = data.pre.hdr.dime.pixdim;
data.pre = double(flip_image(data.pre.img));

data.art = load_nii(try_find_file(dest, '**/20s.nii.gz',...
                    'Select the 20s post-contrast nifti file', nii_ext));
[N1,N2,N3] = size(double(flip_image(data.art.img)));
data.art = double(flip_image(data.art.img));

f=try_find_file(dest, '**/*liver.ids',...
                'Select the whole liver segmentation', '*.ids');
data.liver_mask = get_mask(f, N1,N2,N3);
data.liver_mask = data.liver_mask>0;

f=try_find_file(dest, '**/*whole tumor.ids',...
                'Select the tumor segmentation', '*.ids');
data.tumor_mask = get_mask(f, N1,N2,N3);
data.tumor_mask = data.tumor_mask > 0;

% See if there is an automatic tumor mask.
% f=dir(fullfile([dest, patient, segs_dir], '**/Autom*liver.ids'));
% if ~isempty(f)
%     data.automatic_liver_mask = get_mask([f.folder, '/', f.name], N1,N2,N3);
%     data.automatic_liver_mask = data.automatic_liver_mask > 0;
% end

% See if there is a 70s automatic tumor mask.
% f=dir(fullfile([dest, patient, segs_dir], '**/*liver*70s.ids'));
% if ~isempty(f)
%     data.automatic_liver_mask_70 = get_mask([f.folder, '/', f.name], N1,N2,N3);
%     data.automatic_liver_mask_70 = data.automatic_liver_mask_70 > 0;
% end

return
