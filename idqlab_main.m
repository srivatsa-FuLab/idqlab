%Ensure that the current folder and sub-folders are in the MATLAB path for
%the current session
addpath(genpath([pwd,'\']))

%User settings
bin_size = 1.5e-9;      % in s
window = 0.5e-6*[-1 1]; % in s
channel_A = 1;          %IDQ input channel#
channel_B = 2;          %IDQ input channel#

fprintf('\n ---------------------------------- \n')
n = input('\n Please choose operation:\n 1. Compress tags\n 2. Plot avg cts/s \n 3. Generate histogram (Normalized)\n 4. Generate histogram (Raw)\n ');
display('---------------------------------- \n')

switch n
   %----------------------------------------------------------------------
    case 1
    % % % Compress data.
   %----------------------------------------------------------------------
   display('Please select the files for processing ...') 
   [fle, dirt] = uigetfile('*.txt', 'MultiSelect','on'); 
    
    if iscell(fle)
        numFile = size(fle,2); 
    else
        fle = {fle}; 
        numFile = 1; 
    end
    
    for n = 1:numFile
        fname = fle{n}; 
        idq_compressTimeTagData([dirt '\' fname], channel_A, channel_B);
    end
    
    %----------------------------------------------------------------------
    case 2
    % % % Calculate avg photon count rates
    %----------------------------------------------------------------------
    display('Please select the files for processing ...') 
    [fle, dirt] = uigetfile('*.mat', 'MultiSelect','on'); 
    
    if iscell(fle)
        numFile = size(fle,2); 
    else
        fle = {fle}; 
        numFile = 1; 
    end
    
    %Initialize variables
    time=0;
    avg_c1=0;
    avg_c2=0;
    
    for n = 1:numFile
        fname = fle{n}; 
        [p, q, r] = idq_plot_avgcounts(dirt, fname, 1);
        time = time + p;
        avg_c1 = avg_c1 + q;
        avg_c2 = avg_c2 + r;
    end
    
    avg_c1 = avg_c1/n;
    avg_c2 = avg_c2/n;
    
    fprintf(['Total measurement time (min): %0.2f\n Avg cts/s on channel A: %0.2f' ...
        '\n Avg cts/s on channel B: %0.2f\n'],time*60, avg_c1, avg_c2);
   
    %----------------------------------------------------------------------
    case 3
    % % % Generate histogram with normalization
    %----------------------------------------------------------------------
    
    % For bkg counts
    display('Please select the files for processing ...') 
    [fle, dirt] = uigetfile('*.mat', 'MultiSelect','on'); 
    
    if iscell(fle)
        numFile = size(fle,2); 
    else
        fle = {fle}; 
        numFile = 1; 
    end
    
    time_bk=0;
    avg_bk_c1=0;
    avg_bk_c2=0;
    
    for n = 1:numFile
        fname = fle{n}; 
        [p, q, r] = idq_plot_avgcounts(dirt, fname, 0);
        time_bk = time_bk + p;
        avg_bk_c1 = avg_bk_c1 + q;
        avg_bk_c2 = avg_bk_c2 + r;
    end
    
    fprintf(['Total measurement time (min): %0.2f\n Avg bkg cts/s on channel A: %0.2f' ...
        '\n Avg bkg cts/s on channel B: %0.2f\n'],time_bk*60, avg_bk_c1, avg_bk_c2);  
    
    data = idq_binDataMultiple(window, bin_size);
    
    total_time = data.total_time; % in hrs
    avg_c1 = data.avg_c1;
    avg_c2 = data.avg_c2;
    
%       avg_bk_c1 = 280;
%       avg_bk_c2 = 350;

    %Normalize data
    C = data.coincidences;
    Cn = C./(bin_size*avg_c1*avg_c2*total_time*60*60);
    rho1 = (avg_c1-avg_bk_c1)/ avg_c1;
    rho2 = (avg_c2-avg_bk_c2)/ avg_c2;
    
    g2 = (Cn - (1-rho1*rho2))./(rho1*rho2);
    %g2 = Cn*rho1*rho2 +1-rho1*rho2;
    mean(g2(1:100))
    
    % plot
    figure
    plot(data.tau, g2)
    xlabel('Time diff (s)')
    ylabel('g2 (Normalized)')
    ylim([0 4.5]);
    %title('D776_s0Xr1c1_500uW_1ns_bin_spcm','interpreter','none')
    
    case 4
    data = idq_binDataMultiple(window, bin_size);

    % plot
    figure
    plot(data.tau, data.coincidences)
    xlabel('Time diff (s)')
    ylabel('coincidences / bin')
    ylim([0 500]);
    %title('D776_s0Xr1c1_500uW_1ns_bin_spcm','interpreter','none')
end