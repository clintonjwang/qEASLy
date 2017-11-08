function output_path = try_find_file( path, pattern, msg, allowed_extensions )
%TRY_FIND_FILE Tries to find a file matching a given pattern in path.
%   Otherwise, prompts the user to select a file matching
%   allowed_extensions, with a dialog box containing msg.

if nargin < 4
    allowed_extensions = '*';
end

f=dir(fullfile(path, pattern));

if length(f) == 1
    output_path = [f.folder, '\', f.name];
else
    cwd=pwd();
    cd(path);
    [fname,outpath] = uigetfile(allowed_extensions, msg);
    output_path = [outpath,fname];
    cd(cwd);
end
end

