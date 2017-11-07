function data = try_load_file(path_guess, msg, allowed_extensions)
if nargin < 3
    allowed_extensions = {'*.nii; *.hdr; *.img; *.nii.gz'};
end

try
    data = load_nii(path_guess);
catch
    [fname,path] = uigetfile(allowed_extensions, msg);
    data = load_nii([path,fname]);
end
end