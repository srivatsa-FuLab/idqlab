%idq_unzipIntegerList
%
% x = idq_unzipIntegerList(xcompressed) uncompresses the integer list 
% xcompressed. This function is the inverse of idq_zipIntegerList
%
%
% Todd Karin
% 03/05/2016
function x = idq_unzipIntegerList(xcompressed)

% 
% x = dunzip(xcompressed);
% x = cumsum([x(1); x(2:end)]);
% 
% 



if ~iscell(xcompressed)
    x = dunzip(xcompressed);
    x = cumsum([x(1); x(2:end)]);
else
    
    x=[];
    for j=1:length(xcompressed)
        disp([ num2str(j/length(xcompressed)*100,'%2.0f') ' %'])
        xunzipTemp = dunzip(xcompressed{j});
        x = [x; xunzipTemp];
    end
    
    x = cumsum([x(1); x(2:end)]);
    
end