clear
x = int64(randi(1e4,[1e7,1]));

xcompressed = idq_zipIntegerList(x);

xUncompressed = idq_unzipIntegerList(xcompressed);

% They are the same!
max(abs(x-xUncompressed))