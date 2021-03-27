%idq_zipIntegerList
%
% xcompressed = idq_zipIntegerList(x) compresses a list of integers x using
% the dzip package. If the list of numbers has more than 1e6 elements, the
% numbers are compressed in a for loop so that no out of memory error
% occurs in dzip. 
%
%
% Todd Karin
% 03/05/2016
function xcompressed = idq_zipIntegerList(x)

% %xcompressed = dzip(diff(x));
% %xstart = x(1);
% dx = [x(1);diff(x(:))];
% xcompressed = dzip(dx);
% 



dx = [x(1);diff(x(:))];
Nzip = 5e5;
if length(x)<Nzip
    xcompressed = dzip(dx);
else
    for j=1:ceil( length(x)/Nzip)
        disp([ num2str(j/ceil( length(x)/Nzip)*100,'%2.0f') ' %'])
        cmin = (j-1)*Nzip+1;
        cmax = min([j*Nzip,length(x)]);        
        
        % Compress each set of numbers individually.
        xcompressed{j} =  dzip(dx(cmin:cmax));
        
    end
    
    
    
end
