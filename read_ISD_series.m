function [volDat, volLabels, jsonVolInfo] = read_ISD_series(varargin)

% set default for server URL
ServerAddress = '172.23.202.191';          % ISD instance at Yale

% initialize API key to identfy if value was set by command line argument;
% otherwise, key defined for the server matching one of the above list will
% be used.
myApiKey = [];

% process variable argument list
% argIdx = 1;
% optargin = size(varargin,2);
% while argIdx <= optargin
%     optionName = varargin{argIdx}; % retrieve the option name from argument list
%     if any(strcmp(optionName,{'-h', '--help'}))
%         fprintf('USAGE:\n%s [-h|--help] [-s|--server server] [-k|--key API key]\n', ...
%             mfilename);
%         fprintf('OPTIONAL INPUT:\n');
%         fprintf('\t-h: show this help message and exit\n');
%         fprintf('\t-s: server, i.e. IP address or name (def.: %s)\n', ServerAddress);
%         fprintf('\t-k: API key; contact IS Discovery administrator for your API key (def.: API key of Martin)\n');
%         return;
%     end
%     argIdx = argIdx + 1;
%     if argIdx > optargin
%         % For the time being, all tags come with a single argument. Here,
%         % the argument was not provided.
%         error('DemoISD_HTTP_REST: missing argument to command line argument "%s"!', optionName);
%     end
%     optionValue = varargin{argIdx};
%     argIdx = argIdx + 1;        % increment to next loop
%     % analyse tag (one may introduce type checking here, but for now ...)
%     switch optionName
%         case {'-s' '--server'}
%             ServerAddress = optionValue;
%         case {'-k' '--key'}
%             myApiKey = optionValue;
%         otherwise
%             error('DemoISD_HTTP_REST: unknown command line argument "%s"!', optionName);
%     end
% end

urlServer = ['http://' ServerAddress];
if isempty(myApiKey)
    % set default for API key since user did not supply one as command line
    % argument
    switch ServerAddress
        case {'172.23.202.191'}
            myApiKey = '49eb1753-29bb-465c-8961-226da340b5a9';
        otherwise
            error('no known API key for server %s', ServerAddress);
    end
end

% local folder to store binary data retrieved from server
prefix_data_path = 'd:/DiscoveryData/';

%% select patient

% get patient information
jsonPatientsInfo = isdRestGetPatientsInfo(urlServer,myApiKey);
% convert JSON structs to human readable form for selection dialog
promptStr = 'Patient Name | Date of Birth | Gender | Number of Studies | Patient ID';
nPat = numel(jsonPatientsInfo);
listStrings = cell(nPat,1);
for idx=1:nPat
    DoB = jsonPatientsInfo{idx}.MainDicomTags.PatientBirthDate;
    if length(DoB) == 8
        DoB = [ DoB(1:4) '-' DoB(5:6) '-' DoB(7:8)];
    end
    listStrings{idx} = sprintf('%s | %s | %s | %d | %s', ...
        jsonPatientsInfo{idx}.MainDicomTags.PatientName, DoB, ...
        jsonPatientsInfo{idx}.MainDicomTags.PatientSex, ...
        numel(jsonPatientsInfo{idx}.Studies), ...
        jsonPatientsInfo{idx}.MainDicomTags.PatientID);
end
% let user select the patient
[selPat, ok] = listdlg('ListString',listStrings, ...
                'PromptString', promptStr,...
                'Name', 'Patient List', ...
                'SelectionMode','single',...
                'ListSize', [500, 300] ...
                );
          
%% select study
if ok
    % user did not cancel:
    % continue by retrieving study information of selected patient
    jsonStudiesInfo = isdRestGetStudiesInfo(urlServer,myApiKey,jsonPatientsInfo{selPat});
    
    % convert JSON structs to human readable form for selection dialog
    promptStr = 'Modality | Study Date | Study Description | Number of Series | Study ID';
    nStudies = numel(jsonStudiesInfo);
    listStrings = cell(nStudies,1);
    for idx = 1:nStudies
        % introduce separator string in case of multiple modalities (e.g. PET/CT) 
        modalities = sprintf('%s / ',jsonStudiesInfo{idx}.Modalities{:});
        modalities = modalities(1:end-3);   % strip trailing ' / '
        listStrings{idx} = sprintf('%s | %s | %s | %d | %s',...
            modalities, ...
            regexprep(jsonStudiesInfo{idx}.DateAndTime,'T', ' ', 'once'), ...
            jsonStudiesInfo{idx}.MainDicomTags.StudyDescription, ...
            numel(jsonStudiesInfo{idx}.Series), ...
            jsonStudiesInfo{idx}.MainDicomTags.StudyID);
    end
    [sel, ok] = listdlg('ListString',listStrings, ...
                    'PromptString', promptStr,...
                    'Name', 'Study list', ...
                    'SelectionMode','single',...
                    'ListSize', [500, 300] ...
                    );
end

%% select series           
if ok
    % user did not cancel:
    % continue by retrieving series information of selected study
    jsonSeriesInfo = isdRestGetSeriesInfo(urlServer,myApiKey,jsonStudiesInfo{sel});
    
    % convert JSON structs to human readable form for selection dialog
    promptStr = 'Modality | Series Number | Series Description | Series Time | Number of Images | Series Date';
    nSeries = numel(jsonSeriesInfo);
    listStrings = cell(nSeries,1);
    for idx = 1:nSeries
        % introduce separator string in case of multiple modalities (e.g. PET/CT) 
        seriesTime = jsonSeriesInfo{idx}.MainDicomTags.SeriesTime;
        if length(seriesTime) >= 6
            if length(seriesTime) > 6
                splitSecond = ['.' seriesTime(7:end)];
            else
                splitSecond = '';
            end
            seriesTime = [seriesTime(1:2) ':' seriesTime(3:4) ':' seriesTime(5:6) splitSecond];
        end
        seriesDate = jsonSeriesInfo{idx}.MainDicomTags.SeriesDate;
        if length(seriesDate) == 8
            seriesDate = [seriesDate(1:4) '-' seriesDate(5:6) '-' seriesDate(7:8)];
        end
        listStrings{idx} = sprintf('%s | %s | %s | %s | %d | %s',...
            jsonSeriesInfo{idx}.MainDicomTags.Modality, ...
            jsonSeriesInfo{idx}.MainDicomTags.SeriesNumber, ...
            jsonSeriesInfo{idx}.MainDicomTags.SeriesDescription, ...
            seriesTime, ...
            jsonSeriesInfo{idx}.ExpectedNumberofInstances, ...
            seriesDate);
    end
    [sel, ok] = listdlg('ListString',listStrings, ...
                    'PromptString', promptStr,...
                    'Name', 'Series list', ...
                    'SelectionMode','single',...
                    'ListSize', [500, 300] ...
                    );
end


%% select VOIs
if size(varargin,2) > 0 & varargin{1} == 'mask'
    % user did not cancel:
    % continue by retrieving series information of selected study
    jsonVOIsInfo = isdRestGetVOIsInfo(urlServer,myApiKey, jsonSeriesInfo{sel});
   
    % convert JSON structs to human readable form for selection dialog
    promptStr = 'Name | CreationTime | ModificationTime | NumberOfVoxels';
    nVOIs = numel(jsonVOIsInfo);
    listStrings = cell(nVOIs,1);
    for idx = 1:nVOIs
        listStrings{idx} = sprintf('%s | %s | %s | %dx%dx%d',...
            jsonVOIsInfo{idx}.Name, ...
            jsonVOIsInfo{idx}.CreationTime, ...
            jsonVOIsInfo{idx}.ModificationTime, ...
            jsonVOIsInfo{idx}.NumberOfVoxels.X, ...
            jsonVOIsInfo{idx}.NumberOfVoxels.Y, ...
            jsonVOIsInfo{idx}.NumberOfVoxels.Z);
    end
    [sel, ok] = listdlg('ListString',listStrings, ...
                    'PromptString', promptStr,...
                    'Name', 'Series list', ...
                    'SelectionMode','single',...
                    'ListSize', [500, 300] ...
                    );

    % user did not cancel:
    % continue by retrieving series information of selected study
    [volDat, jsonVolInfo] = isdRestReadVOI (urlServer, myApiKey,...
                                jsonVOIsInfo{sel}, 'D:\DiscoveryData');

    volLabels = 'None';
    % disp(volDat)
    % showVolumeData(volDat);

%% select selected series
else
    % user did not cancel: now load the volume
    [volDat, jsonVolInfo] = isdRestReadSeries (urlServer, myApiKey,...
                                jsonSeriesInfo{sel}, 'D:\DiscoveryData');
    if size(volDat,4) > 1
        % for 4D data, subtract first image
        sizeVol = size(volDat);
        subVol = zeros([sizeVol(1:3) (sizeVol(4)-1)]);
        for idx=1:size(subVol,4)
            subVol(:,:,:,idx) = volDat(:,:,:,idx+1) - volDat(:,:,:,1);
        end
        volDat = {volDat subVol};
        volLabels = cell(2,1);
        volLabels{1} = sprintf('%s (SN: %s)', ...
            jsonSeriesInfo{sel}.MainDicomTags.SeriesDescription, ...
            jsonSeriesInfo{sel}.MainDicomTags.SeriesNumber);
        volLabels{2} = sprintf('sub-%s (SN: %s)', ...
            jsonSeriesInfo{sel}.MainDicomTags.SeriesDescription, ...
            jsonSeriesInfo{sel}.MainDicomTags.SeriesNumber);
    else
        % for 3D data, create inverted image
        volDat = {volDat, (-1)*volDat};
        volLabels = cell(2,1);
        volLabels{1} = sprintf('%s (SN: %s)', ...
            jsonSeriesInfo{sel}.MainDicomTags.SeriesDescription, ...
            jsonSeriesInfo{sel}.MainDicomTags.SeriesNumber);
        volLabels{2} = sprintf('inv-%s (SN: %s)', ...
            jsonSeriesInfo{sel}.MainDicomTags.SeriesDescription, ...
            jsonSeriesInfo{sel}.MainDicomTags.SeriesNumber);
    end
    
 %   showVolumeData(volDat, ...
 %       'figureTitle', sprintf('%s (DoB: %s) on %s', ...
 %           jsonPatientsInfo{selPat}.MainDicomTags.PatientName, ...
 %           jsonPatientsInfo{selPat}.MainDicomTags.PatientBirthDate, ...
 %           jsonSeriesInfo{sel}.MainDicomTags.SeriesDate), ...
 %       'volLabels', volLabels);
end
end % function