%
%
% data = idq_importTimeTagData(fname) loads the compressed time tag data in
% the file fname, and decompresses the time tag data.
function data = idq_importTimeTagData(fname)

% Load data.
load(fname)

for j=1:length(data.timeTagZip)
   data.timeTag{j} = idq_unzipIntegerList(data.timeTagZip{j});
end