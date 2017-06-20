% create legacy mex function for control
clc

% High Pass Filter
specs_hpf = legacy_code('initialize');
specs_hpf.SourceFiles = {'MATLAB.C', 'filter.c'};
specs_hpf.SrcPaths={'..\poxi.sdk\poxi\src\dsp\'};
specs_hpf.HeaderFiles = {'MATLAB.H', 'filter.h'};
specs_hpf.IncPaths={'..\poxi.sdk\poxi\src\dsp\'};
specs_hpf.SFunctionName = 'High_Pass_Filter';
specs_hpf.OutputFcnSpec = 'double y1 = high_pass_filter_wrapper(double u1)';
legacy_code('sfcn_cmex_generate', specs_hpf)
legacy_code('compile', specs_hpf)
%legacy_code('slblock_generate', specs_hpf)  % Comment out this line


% LOw Pass Filter
specs_lpf = legacy_code('initialize');
specs_lpf.SourceFiles = {'MATLAB.C', 'filter.c'};
specs_lpf.SrcPaths={'..\poxi.sdk\poxi\src\dsp\'};
specs_lpf.HeaderFiles = {'MATLAB.H', 'filter.h'};
specs_lpf.IncPaths={'..\poxi.sdk\poxi\src\dsp\'};
specs_lpf.SFunctionName = 'Low_Pass_Filter';
specs_lpf.OutputFcnSpec = 'double y1 = low_pass_filter_wrapper(double u1)';
legacy_code('sfcn_cmex_generate', specs_lpf)
legacy_code('compile', specs_lpf)
%legacy_code('slblock_generate', specs_lpf) % Comment out this line

disp('Poxi filter C legacy... Done')
