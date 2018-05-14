function data = load_niis(filename_map)
%LOAD_NIFTI_LIVER Loads pre/art phases and liver/tumor segs.

    nii_ext = {'*.nii; *.hdr; *.img; *.nii.gz'};

%     data.pre = load_nii(try_find_file(data_dir, filename_map('pre'),...
%                         'Select the pre-contrast nifti file', nii_ext));
    data.pre = load_nii(filename_map('pre'));
    data.dim = data.pre.hdr.dime.pixdim;
    data.pre = double(flip_image(data.pre.img));

%     data.art = load_nii(try_find_file(data_dir, filename_map('art'),...
%                         'Select the 20s post-contrast nifti file', nii_ext));
    data.pre = load_nii(filename_map('art'));
    data.art = double(flip_image(data.art.img));

%     f=try_find_file(data_dir, filename_map('liver_seg'),...
%                     'Select the whole liver segmentation', '*.ids');
    f=filename_map('liver_seg');
    data.liver_mask = get_mask(f(1:end-4));
    data.liver_mask = data.liver_mask>0;

%     f=try_find_file(data_dir, filename_map('tumor_seg'),...
%                     'Select the tumor segmentation', '*.ids');
    f=filename_map('tumor_seg');
    data.tumor_mask = get_mask(f(1:end-4));
    data.tumor_mask = data.tumor_mask > 0;
return
