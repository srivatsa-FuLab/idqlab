%idq_compressTimeTagData
%
% data = idq_compressTimeTagData(fname) reads in the time tag data file and
% saves as a mat with the same filename. This compresses the file about 11
% times and takes around 8 seconds for a 340 mb file.
%
%   idq_compressTimeTagData('TimeTags_0.txt') saves the file
%   'TimeTags_0.mat';
%
%
% data structure returned with fields:
%
%   countrate - counts per second on each channel
%   clockTime - clock time that the scan was started
%   timeUnitps
%
% Todd Karin
% 02/18/2016
%
% Modified by Srivatsa
% 01/13/2020

function data = idq_compressTimeTagData(fname, channel_A, channel_B)

fid = fopen(fname,'r');

data.compressTimeTagDataVer = '1.0';
data.headerName = fgetl(fid);
if ~strcmp('# Time Tags',data.headerName)
    error('Must be a time tag data file')
end

data.headerDateTaken = fgetl(fid);
data.headerUnitTime = fgetl(fid);
data.headerUnitChannel = fgetl(fid);
data.headerParamNames = fgetl(fid);


data.clockTime = sscanf(data.headerDateTaken,'# %f-%f-%f %f:%f:%f')';
data.serialTime = datenum(data.clockTime);

data.timeUnitps = sscanf(data.headerUnitTime,'# Unit Time Tag: %fps');


% Predict time it takes
d=dir(fname);
originalFileSizeMb = d.bytes/1e6;

predictedImportTime = 8/340*originalFileSizeMb;

disp(['Reading file. Predicted time: ' num2str(predictedImportTime,'%4.0f') ' seconds'])
tic
% Read the data in
rawdata = textscan(fid,'     %d64 ;                    %d8');
runtime = toc;
disp(['Read time: ' num2str(runtime,'%5.f') ' s'])
%data.timeTag = rawdata{1};

% Sort
channel = rawdata{2};
timeTag{1} = rawdata{1}(channel==channel_A);
timeTag{2} = rawdata{1}(channel==channel_B);

data.acquisitionTime = double(rawdata{1}(end)-rawdata{1}(1))/1e12*data.timeUnitps;


disp('Compressing ...')
for j=1:2
    data.countrate(j) = double(length(timeTag{j})/data.acquisitionTime);
    if timeTag{j}(end)>2^62
        warning('Time tag precision exceeds integer precision')
    end
    % Compress
    data.timeTagZip{j} = idq_zipIntegerList(timeTag{j});
end
disp('Validating ...')
for j=1:2
    % Check compression
    timeTagUnzip{j} = idq_unzipIntegerList(data.timeTagZip{j});
    
    if ~prod(timeTagUnzip{j}==timeTag{j})
        warning('Zip error, saving unzipped data')
        data.timeTag{j} = timeTag{j};
    end
    
end

%disp(['Sort time: ' num2str(toc,'%5.f') ' s'])

disp('Saving ...')
fnameSave =  [ strrep(fname,'.txt','') '.mat'];
save(fnameSave,'data')

% Original file size
d=dir(fname);
data.originalFileSizeMb = (d.bytes)/1e6;
d=dir(fnameSave);
data.compressedFileSizeBytesMb = d.bytes/1e6;

data.compressedMbPerMin = data.compressedFileSizeBytesMb/data.acquisitionTime*60;
data.compressionAmount = data.originalFileSizeMb/data.compressedFileSizeBytesMb;

disp('Saving again ...')
save(fnameSave,'data')
disp('Done.')
%disp('Compression finished')
% Get compression of around 11 times when saved as mat.

