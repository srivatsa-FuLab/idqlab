% Same functionality as idq_rebin, except the binOffsets are averaged over.
function data = idq_rebinAverage(data,rebinTime)

%rebinTime = 0.8e-9;
%data = idq_combinefiles('02correlationData_');

datatemp = idq_rebin(data,rebinTime,0);

binMultiplier = datatemp.binMultiplier;

for j=1:binMultiplier-1
    datatemp = idq_rebin(data,rebinTime,j);
    
    counts(:,:,j) = datatemp.counts;
    time(:,j) = datatemp.time;
    
end
    
    
data.time = mean(time,2);
data.counts = mean(counts,3);
data.countsTotal = sum(data.counts,2);