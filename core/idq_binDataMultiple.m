
% fname is a cell array of files that will be binned.
% fname = wildcard('12TimeTags*.mat');
% binLim = 300e3*[-1 1];
% binSize = 800;


function data = idq_binDataMultiple(binLim,binSize)


[fle, dirt] = uigetfile('*.mat', 'MultiSelect','on'); 

if iscell(fle)
    numFile = size(fle,2); 
else
    fle = {fle}; 
    numFile = 1; 
end

time = 0;
avg_c1 = 0;
avg_c2 = 0;

for j=1:numFile
    
    disp(['Importing: ' fle{j}])
    
    %Calculate metrics for normalization
    [p, q, r] = idq_plot_avgcounts(dirt, fle{j}, 0);
    
    time = time + p;
    avg_c1 = avg_c1 + q;
    avg_c2 = avg_c2 + r;
    
    %Bin data
    dataTemp  = idq_bindata([dirt '\' fle{j}],binLim,binSize);
    
    if j==1
        data = dataTemp;
    else
        data.coincidences = data.coincidences + dataTemp.coincidences;
        data.acquisitionTime = data.acquisitionTime + dataTemp.acquisitionTime;
        data.originalFileSizeMb = data.originalFileSizeMb + dataTemp.originalFileSizeMb;
        data.compressedFileSizeBytesMb = data.compressedFileSizeBytesMb + dataTemp.compressedFileSizeBytesMb;
    end
    
end
    
data.total_time = time;
data.avg_c1 = avg_c1/numFile;
data.avg_c2 = avg_c2/numFile;

data.timeTag = [];
data.timeTagZip = [];

fprintf(['Total measurement time (hrs): %f\n Avg cts/s on channel 1: %f' ...
    '\n Avg cts/s on channel 2: %f\n'],time, data.avg_c1, data.avg_c2);

