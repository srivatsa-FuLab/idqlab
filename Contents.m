%idqlab - matlab interface for IDquantique time to digital converter.
% Mar-25-2021 Ver 2.0
%
% DESCRIPTION
%
%   Toolbox for importing data saved by IDQ time tag board and included
%   software
%
% SUMMARY
%
%   IDQLAB contains functions that import data saved by the IDQtdc windows
%   program. These scripts were tested using an ID801 time to digital
%   converter. 
%
%   The most useful and non-trivial part of these scripts is the ability to
%   compress time-tag data into a more manageable file size. The
%   compression is lossless and reduces the file size by a factor of 10 to
%   15. This compression is provided via the dzip and dunzip functions
%   (Mathworks File ID: #8899).
%
%   The files aren't perfectly commented yet, but I thought I would post
%   this anyways. As always, use at your own risk!
%
%	Core functionality developed by Todd Karin (2016)
%
%	Modified by Srivatsa Chakravarthi Mar 2021

% TAGS
%
%   IDQ, IDQtdc, ID, quantique, ID801, time to digital converter, import,
%   data