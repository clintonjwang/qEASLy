function data = load_dcms(filename_map)
%LOAD_NIFTI_LIVER Loads pre/art phases and liver/tumor segs.

%     path = uigetdir(data_dir, 'Select the folder containing the pre-contrast series.');
%     [V,spatial,~] = dicomreadVolume(path);
    [V,~,~] = dicomreadVolume(filename_map('pre'));
    data.pre = double(squeeze(V)); %flip_image(squeeze(V)));

    [V,spatial,~] = dicomreadVolume(filename_map('art'));
    data.art = double(squeeze(V)); %double(flip_image(squeeze(V)));
    data.dim = [1, spatial.PixelSpacings(1:2), abs(spatial.PatientPositions(2,3) - spatial.PatientPositions(1,3))];

%     f=try_find_file(data_dir, filename_map('liver_seg'),...
%                     'Select the whole liver segmentation', '*.ids');
    f=filename_map('liver_seg');
    data.liver_mask = get_mask(f(1:end-4), [], size(data.art), spatial);
    data.liver_mask = data.liver_mask > 0;
    data.liver_mask = flip(data.liver_mask,3);

%     f=try_find_file(data_dir, filename_map('tumor_seg'),...
%                     'Select the tumor segmentation', '*.ids');
    f=filename_map('tumor_seg');
    data.tumor_mask = get_mask(f(1:end-4), [], size(data.art), spatial);
    data.tumor_mask = data.tumor_mask > 0;
    data.tumor_mask = flip(data.tumor_mask,3);
return
