% file_prefix is the filename before the number.
% e.g. for the data serial '02correlationData_#.text', fileprefix =
% '02correlationData_'.


function data = idq_combinefiles(file_prefix)

prefix = [file_prefix '*'];
filenametotal = dir(prefix);

histdata = idq_importHistogram(filenametotal(1).name);
data.counts = zeros(length(histdata.counts),length(filenametotal));

for j = 1:length(filenametotal)
data.filename{j} = filenametotal(j).name;
histdata = idq_importHistogram(data.filename{j});
data.counts(:,j) = histdata.counts(:);
data.filecreate_time(j) = histdata.serialTime;


end

[~,sortindex] = sort(data.filecreate_time);
data.filename = data.filename(sortindex); 
data.filecreate_time = data.filecreate_time(sortindex);
data.counts = data.counts(:,sortindex);
data.time = histdata.time;


end