%idq_importHistogram
%
% data = idq_importHistogram(fname) imports histogram data saved from the
% idq time tagger.
%
% Todd Karin
% 02/18/2016
function data = idq_importHistogram(fname)

%fname = 'TagsHistogram_619.txt';

fid = fopen(fname,'r');

data.header = fgetl(fid);
data.dateTaken = fgetl(fid);

data.clockTime = sscanf(data.dateTaken,'# %f-%f-%f %f:%f:%f')';
data.serialTime = datenum(data.clockTime);


data.unitTime = fgetl(fid);
data.unitCount = fgetl(fid);
data.timeDiff = fgetl(fid);



j=1;
while ~feof(fid)
    temp = fscanf(fid,'%f ;  %f',[1 2]);
    
    if ~isempty(temp)
        p(j,:) = temp;
        j=j+1;
    end
end

data.time = p(:,1);
data.counts = p(:,2);

