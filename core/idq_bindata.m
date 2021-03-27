%idq_bindata - bin time tagged data
%
% data = idq_bindata(fname,binLim,binSize) bins data in the mat file fname.
% The mat file must be saved from idq_compressTimeTagData
%
% fname - filename of mat file to process
% binLim - time axis bin limits in s.
% binSize - bin size in s.
%
% In the returned data, the time coincidences histogram is t2-t1, where t1
% is the time click on channel 1 and t2 is the time click on channel 2.
% This is equivalent to doing histogram data with ch1 triggering.
%
% Todd Karin
% 02/24/2016

function data = idq_bindata(fname,binLim,binSize)


% limits of time bin in ps.
%fname = '06TimeTags_1.mat';
%binLim = [-500e-9, 500e-9];
%binSize = 1000e-12; % s


% Load data, unbin
data = idq_importTimeTagData(fname);

timeUnit = data.timeUnitps*1e-12;
timeLimUnitless = binLim/timeUnit;
timeBinUnitless = binSize/timeUnit;

% Offset by time origin, allows use of data format with smaller number of
% bits.
timeOrigin = min([data.timeTag{1}(1), data.timeTag{2}(1)]);

% Switch to doulbe if the size of the numbers fits in double precision. It
% likely always does, but good to check. :)
if max([data.timeTag{1}(end) data.timeTag{2}(end)])-timeOrigin<2^53
    t1 = double(data.timeTag{1} - timeOrigin);
    t2 = double(data.timeTag{2} - timeOrigin);
    
else
    t1 = data.timeTag{1} - timeOrigin;
    t2 = double(data.timeTag{2}) - timeOrigin;

    disp('Big numbers! need int precision (this will take longer)')
end


% 
% t1rep = repmat(t1,[1, length(t2)]);
% t2rep = repmat(t2',[length(t1),1]);
% 
% t1rep-t2rep

timeDiff = [];

tic
%timeDiffTemp = zeros([1, 1e2]); % faster without preallocation.
kloopmin = 1;
kloopmax = length(t2);
n=1;

fracDoneLim = 0;
for j=1:length(t1)
    
    % Display progress bar.
    fracDone = j/length(t1);
    if fracDone>fracDoneLim
        disp(['[' repmat('.',[1, round(fracDone*10)]) repmat(' ',[1, round((1-fracDone)*10)])  ']'])
        fracDoneLim = fracDoneLim + 0.1;
    end
    
    
    %disp(num2str(j))
    
    %k = kloopmin;
    %cont = 1;
    for k=kloopmin:kloopmax
        timeDiffTemp = t2(k)-t1(j);
        
        % increase loop min if difference is less than limit range.
        if timeDiffTemp<timeLimUnitless(1)-timeBinUnitless
            kloopmin=k;
        elseif timeDiffTemp>timeLimUnitless(2)+timeBinUnitless
            % break loop if difference is greater than limit range.
                break
        else 
            % We have found a good value
            timeDiff(n) = timeDiffTemp;
            n=n+1;

        end
    end
    
%    disp(['t2 loop: ' num2str(kloopmin) '-' num2str(k)])
    
end
%timeDiff(n:end) = [];
toc

data.timeDiffUnitless = timeDiff;
data.binSize = binSize;
data.numbins = round(range(binLim)/binSize);
data.tauUnitless = linspace(timeLimUnitless(1), timeLimUnitless(2),data.numbins);
data.tau = data.tauUnitless*timeUnit;

% Do the bin
data.coincidences = hist(timeDiff, ...
    [data.tauUnitless(1)-timeBinUnitless, data.tauUnitless, data.tauUnitless(end)+timeBinUnitless;]);
data.coincidences(1) = [];
data.coincidences(end) = [];




%plot(data.tau, data.coincidences)
