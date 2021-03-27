% Todd Karin
% 02/24/2016

% Modified by Srivatsa
% 01/13/2020

function [time, avg_ch1, avg_ch2] = idq_plot_avgcounts(dirt, fname, vis)

% Load data, uncompress
data = idq_importTimeTagData([dirt '\' fname]);

timeUnit = data.timeUnitps*1e-12; %in s
binSize = 1; %in s

% Offset by time origin, allows use of data format with smaller number of
% bits.
timeOrigin = min([data.timeTag{1}(1), data.timeTag{2}(1)]);

% Switch to double if the size of the numbers fits in double precision. It
% likely always does, but good to check. :)
if max([data.timeTag{1}(end) data.timeTag{2}(end)])-timeOrigin<2^53
    t1 = double(data.timeTag{1} - timeOrigin);
    t2 = double(data.timeTag{2} - timeOrigin);
    
else
    t1 = data.timeTag{1} - timeOrigin;
    t2 = double(data.timeTag{2}) - timeOrigin;

    disp('Big numbers! need int precision (this will take longer)')
end


numbins_t1 = round(range(t1)*timeUnit/binSize);
numbins_t2 = round(range(t2)*timeUnit/binSize);

% Do the bin
[counts_t1,~] = histcounts(t1,numbins_t1);
[counts_t2,~] = histcounts(t2,numbins_t2); 

time = length(counts_t2)/3600;
avg_ch1 = mean(counts_t1);
avg_ch2 = mean(counts_t2);

if vis>0
%    plot the cts/s
    figure
    plot((1:length(counts_t1))/3600,counts_t1)
    title(fname, 'interpreter', 'none');
    xlabel('Time (hrs)')
    ylabel('cts/s')

    hold on
    plot((1:length(counts_t2))/3600,counts_t2)
    savefig(gcf,[dirt '\' fname(1:end-4) '_avgcts.fig']);
end

%plot(data.tau, data.coincidences)
