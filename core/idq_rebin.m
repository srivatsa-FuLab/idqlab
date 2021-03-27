%idq_rebin
%
% data = idq_rebin(data,rebinTime,rebinOffset) rebins the histogram data
% using a new time bin 'rebinTime' and an offset 'rebinOffset.' The
% rebinTime is the desired length of the new bins. The rebinOffset shifts
% the bins by a positive integer.
%
% The effect of rebin offset can be seen below:
%
% |...|...|...|...|...      rebinOffset=0
% .|...|...|...|...|..      rebinOffset=1
%
% Todd Karin
% 02/18/2016

function data = idq_rebin(data,rebinTime,rebinOffset)
 


%data = idq_importHistogram('TagsHistogram_619.txt');

% new time bin length in s
%rebinTime = 5e-9;

% bin offset in original timesteps
%rebinOffset = 1;

if rebinOffset<0
    error('rebin offset must be >=0')
end

data.time = data.time(rebinOffset+1:end,:);
data.counts = data.counts(rebinOffset+1:end,:);

deltaT = data.time(2)-data.time(1);

binMultiplier = round(rebinTime/deltaT);
if binMultiplier<1
    binMultiplier=1;
    warning(['rebin length cannot be shorter than original bin length' ])
end  

data.newBinTime = binMultiplier*deltaT;
data.rebinOffset = 0;

% remove last data points
numRemove = rem(length(data.time),binMultiplier);
data.time = data.time(1:end-numRemove,:);
data.counts = data.counts(1:end-numRemove,:);

numBins = length(data.time)/binMultiplier;
data.binMultiplier = binMultiplier;

timeMat = reshape(data.time,[binMultiplier, numBins]);
data.time = mean(timeMat,1)';



for j=1:size(data.counts,2)
countsMat = reshape(data.counts(:,j),[binMultiplier, numBins]);

countsTemp(:,j) = sum(countsMat,1);
end


data.counts = countsTemp;
data.countsTotal = sum(data.counts,2);


