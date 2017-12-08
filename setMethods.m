%% Methods & Settings
% Script for setting algorithms to run
%
% Rui Wang, Dong Liang, Wei Zhang, Xiaochun Cao
% Semantic Correspondence with Geometric Structure Analysis,
% TIP under submission


% You can add an algorithm following the script below
%nMethods = 1;
%methods(nMethods).fhandle = @fhandle;                         % Function of the algorithm
%methods(nMethods).variable = {'var1', 'var2', 'var3'};        % Input variables that the algorithm requires
%methods(nMethods).param = {'name1', 'val1', 'name2', 'val2'}; % Default parameter values
%methods(nMethods).strName = 'algorithm name';                 % Algorithm name tag
%methods(nMethods).color = 'color';                            % Color for plots
%methods(nMethods).lineStyle = 'line style';                   % Line style for plots
%methods(nMethods).marker = 'marker';                          % Marker for plots

nMethods = 0;
%% Random
if 1
    nMethods = nMethods + 1;
    methods(nMethods).fhandle = @Random;
    methods(nMethods).variable = {'X0'};
    methods(nMethods).param = {};
    methods(nMethods).strName = 'Random';
    methods(nMethods).color = 'r';
    methods(nMethods).lineStyle = '--';
    methods(nMethods).marker = 'o';
end
%% MatchDR
if 1
    nMethods = nMethods + 1;
    methods(nMethods).fhandle = @MatchDR;
    methods(nMethods).variable = {'G1', 'G2', 'X0', 'temperature'};
    methods(nMethods).param = {};
    methods(nMethods).strName = 'random init DR';
    methods(nMethods).color = 'r';
    methods(nMethods).lineStyle = '-';
    methods(nMethods).marker = 'o';
end
%% myfun
if 1
    nMethods = nMethods + 1;
    methods(nMethods).fhandle = @myfun;
    methods(nMethods).variable = {'G1', 'G2', 'X0', 'C', 'temperature'};
    methods(nMethods).param = {};
    methods(nMethods).strName = 'random init FDR';
    methods(nMethods).color = 'r';
    methods(nMethods).lineStyle = '-';
    methods(nMethods).marker = 'o';
end
%% pairfeat
if 1
    nMethods = nMethods + 1;
    methods(nMethods).fhandle = @pairfeat;
    methods(nMethods).variable = {'W', 'stateDims'};
    methods(nMethods).param = {};
    methods(nMethods).strName = 'Kuhn-Munkres';
    methods(nMethods).color = 'b';
    methods(nMethods).lineStyle = '--';
    methods(nMethods).marker = 'p';
end
%% MatchDR
if 1
    nMethods = nMethods + 1;
    methods(nMethods).fhandle = @MatchDR;
    methods(nMethods).variable = {'G1', 'G2', 'X0', 'temperature'};
    methods(nMethods).param = {};
    methods(nMethods).strName = 'Kuhn�CMunkres+MatchDR';
    methods(nMethods).color = 'r';
    methods(nMethods).lineStyle = '-';
    methods(nMethods).marker = 'o';
end
%% myfun
if 1
    nMethods = nMethods + 1;
    methods(nMethods).fhandle = @myfun;
    methods(nMethods).variable = {'G1', 'G2', 'X0', 'C', 'temperature'};
    methods(nMethods).param = {};
    methods(nMethods).strName = 'Kuhn-Munkres + FDR';
    methods(nMethods).color = 'b';
    methods(nMethods).lineStyle = '-';
    methods(nMethods).marker = 'p';
end
%% ALS
if 1
    nMethods = nMethods + 1;
    methods(nMethods).fhandle = @MatchALS;
    methods(nMethods).variable = {'W', 'stateDims'};
    methods(nMethods).param = {};
    methods(nMethods).strName = 'MatchALS';
    methods(nMethods).color = 'b';
    methods(nMethods).lineStyle = '--';
    methods(nMethods).marker = 'o';
end
%% MatchDR
if 1
    nMethods = nMethods + 1;
    methods(nMethods).fhandle = @MatchDR;
    methods(nMethods).variable = {'G1', 'G2', 'X0', 'temperature'};
    methods(nMethods).param = {};
    methods(nMethods).strName = 'MatchALS + MatchDR';
    methods(nMethods).color = 'r';
    methods(nMethods).lineStyle = '-';
    methods(nMethods).marker = 'o';
end
%% myfun
if 1
    nMethods = nMethods + 1;
    methods(nMethods).fhandle = @myfun;
    methods(nMethods).variable = {'G1', 'G2', 'X0', 'C', 'temperature'};
    methods(nMethods).param = {};
    methods(nMethods).strName = 'MatchALS + FDR';
    methods(nMethods).color = 'r';
    methods(nMethods).lineStyle = '-';
    methods(nMethods).marker = 'o';
end
%% Spectral Matching Leordeanu et al. ICCV 2005
if 1
    nMethods = nMethods + 1;
    methods(nMethods).fhandle = @SM;
    methods(nMethods).variable = {'affinityMatrix'};
    methods(nMethods).param = {};
    methods(nMethods).strName = 'SM';
    methods(nMethods).color = 'k';
    methods(nMethods).lineStyle = '--';
    methods(nMethods).marker = 'x';
end
%% MatchDR
if 1
    nMethods = nMethods + 1;
    methods(nMethods).fhandle = @MatchDR;
    methods(nMethods).variable = {'G1', 'G2', 'X0', 'temperature'};
    methods(nMethods).param = {};
    methods(nMethods).strName = 'SM + MatchDR';
    methods(nMethods).color = 'r';
    methods(nMethods).lineStyle = '-';
    methods(nMethods).marker = 'o';
end
%% myfun
if 1
    nMethods = nMethods + 1;
    methods(nMethods).fhandle = @myfun;
    methods(nMethods).variable = {'G1', 'G2', 'X0', 'C', 'temperature'};
    methods(nMethods).param = {};
    methods(nMethods).strName = 'SM + FDR';
    methods(nMethods).color = 'y';
    methods(nMethods).lineStyle = '-';
    methods(nMethods).marker = 'p';
end
%% IPFP 2009
if 1
    nMethods = nMethods + 1;
    methods(nMethods).fhandle = @ipfp_gm;
    methods(nMethods).variable = {'affinityMatrix', 'L12'};
    methods(nMethods).strName = 'IPFP';
    methods(nMethods).param = {};
    methods(nMethods).color = 'm';
    methods(nMethods).lineStyle = '-';
    methods(nMethods).marker = 'x';
end
%% MatchDR
if 1
    nMethods = nMethods + 1;
    methods(nMethods).fhandle = @MatchDR;
    methods(nMethods).variable = {'G1', 'G2', 'X0', 'temperature'};
    methods(nMethods).param = {};
    methods(nMethods).strName = 'IPFP + MatchDR';
    methods(nMethods).color = 'r';
    methods(nMethods).lineStyle = '-';
    methods(nMethods).marker = 'o';
end
%% myfun
if 1
    nMethods = nMethods + 1;
    methods(nMethods).fhandle = @myfun;
    methods(nMethods).variable = {'G1', 'G2', 'X0', 'C', 'temperature'};
    methods(nMethods).param = {};
    methods(nMethods).strName = 'IPFP + FDR';
    methods(nMethods).color = 'y';
    methods(nMethods).lineStyle = '-';
    methods(nMethods).marker = 'p';
end
%% RRWM Cho et al. ECCV2010
if 1
    nMethods = nMethods + 1;
    methods(nMethods).fhandle = @RRWM;
    methods(nMethods).variable = {'affinityMatrix', 'group1', 'group2'};
    methods(nMethods).param = {};
    methods(nMethods).strName = 'RRWM';
    methods(nMethods).color = 'b';
    methods(nMethods).lineStyle = '--';
    methods(nMethods).marker = 'x';
end
%% MatchDR
if 1
    nMethods = nMethods + 1;
    methods(nMethods).fhandle = @MatchDR;
    methods(nMethods).variable = {'G1', 'G2', 'X0', 'temperature'};
    methods(nMethods).param = {};
    methods(nMethods).strName = 'RRWM + MatchDR';
    methods(nMethods).color = 'r';
    methods(nMethods).lineStyle = '-';
    methods(nMethods).marker = 'o';
end
%% myfun
if 1
    nMethods = nMethods + 1;
    methods(nMethods).fhandle = @myfun;
    methods(nMethods).variable = {'G1', 'G2', 'X0', 'C', 'temperature'};
    methods(nMethods).param = {};
    methods(nMethods).strName = 'RRWM + FDR';
    methods(nMethods).color = 'y';
    methods(nMethods).lineStyle = '-';
    methods(nMethods).marker = 'p';
end
%% SMCM Suh et al. ECCV 2012
if 0
    nMethods = nMethods + 1;
    methods(nMethods).fhandle = @SMCM;
    methods(nMethods).variable = {'affinityMatrix', 'group1', 'group2'};
    methods(nMethods).param = {'nParticles', 2000, 'tau', 2};
    methods(nMethods).postProcess = 'none';
    methods(nMethods).strName = 'SMCM';
    methods(nMethods).color = 'k';
    methods(nMethods).lineStyle = '-';
    methods(nMethods).marker = 'p';
end
%% MatchDR
if 0
    nMethods = nMethods + 1;
    methods(nMethods).fhandle = @MatchDR;
    methods(nMethods).variable = {'G1', 'G2', 'X0', 'temperature'};
    methods(nMethods).param = {};
    methods(nMethods).strName = 'SMCM + MatchDR';
    methods(nMethods).color = 'r';
    methods(nMethods).lineStyle = '-';
    methods(nMethods).marker = 'o';
end
%% myfun
if 0
    nMethods = nMethods + 1;
    methods(nMethods).fhandle = @myfun;
    methods(nMethods).variable = {'G1', 'G2', 'X0', 'C', 'temperature'};
    methods(nMethods).param = {};
    methods(nMethods).strName = 'SMCM + FDR';
    methods(nMethods).color = 'y';
    methods(nMethods).lineStyle = '-';
    methods(nMethods).marker = 'p';
end
%% MPM 2014
if 1
    nMethods = nMethods + 1;
    methods(nMethods).fhandle = @MPM;
    methods(nMethods).variable = {'affinityMatrix', 'group1', 'group2'};
    methods(nMethods).param = {};
    methods(nMethods).strName = 'MPM';
    methods(nMethods).color = 'r';
    methods(nMethods).lineStyle = '-';
    methods(nMethods).marker = 'p';
end
%% MatchDR
if 1
    nMethods = nMethods + 1;
    methods(nMethods).fhandle = @MatchDR;
    methods(nMethods).variable = {'G1', 'G2', 'X0', 'temperature'};
    methods(nMethods).param = {};
    methods(nMethods).strName = 'MPM + MatchDR';
    methods(nMethods).color = 'r';
    methods(nMethods).lineStyle = '-';
    methods(nMethods).marker = 'o';
end
%% myfun
if 1
    nMethods = nMethods + 1;
    methods(nMethods).fhandle = @myfun;
    methods(nMethods).variable = {'G1', 'G2', 'X0', 'C', 'temperature'};
    methods(nMethods).param = {};
    methods(nMethods).strName = 'MPM + FDR';
    methods(nMethods).color = 'y';
    methods(nMethods).lineStyle = '-';
    methods(nMethods).marker = 'p';
end
%% Proposed. SMCP Suh et al. CVPR 2015
if 1
    nMethods = nMethods + 1;
    methods(nMethods).fhandle = @MCMC_e_reg0p7;
    methods(nMethods).variable = {'affinityMatrix','group1','group2','E12','L12'};
    methods(nMethods).param = {};
    methods(nMethods).postProcess = 'hungarian';
    methods(nMethods).strName = 'SMCP';
    methods(nMethods).color = 'r';
    methods(nMethods).lineStyle = '-';
    methods(nMethods).marker = 'x';
end
%% MatchDR
if 1
    nMethods = nMethods + 1;
    methods(nMethods).fhandle = @MatchDR;
    methods(nMethods).variable = {'G1', 'G2', 'X0', 'temperature'};
    methods(nMethods).param = {};
    methods(nMethods).strName = 'SMCP + MatchDR';
    methods(nMethods).color = 'r';
    methods(nMethods).lineStyle = '-';
    methods(nMethods).marker = 'o';
end
%% myfun
if 1
    nMethods = nMethods + 1;
    methods(nMethods).fhandle = @myfun;
    methods(nMethods).variable = {'G1', 'G2', 'X0', 'C', 'temperature'};
    methods(nMethods).param = {};
    methods(nMethods).strName = 'SMCP + FDR';
    methods(nMethods).color = 'y';
    methods(nMethods).lineStyle = '-';
    methods(nMethods).marker = 'p';
end
%% fgmU
if 0
    nMethods = nMethods + 1;
    methods(nMethods).fhandle = @fgmU;
    methods(nMethods).variable = {'KP', 'KQ', 'Ct', 'gphs', 'parFGM_U'};
    methods(nMethods).param = {};
    methods(nMethods).strName = 'fgmU';
    methods(nMethods).color = 'k';
    methods(nMethods).lineStyle = '--';
    methods(nMethods).marker = 'o';
end
%% MatchDR
if 0
    nMethods = nMethods + 1;
    methods(nMethods).fhandle = @MatchDR;
    methods(nMethods).variable = {'G1', 'G2', 'X0', 'temperature'};
    methods(nMethods).param = {};
    methods(nMethods).strName = 'fgmU + MatchDR';
    methods(nMethods).color = 'r';
    methods(nMethods).lineStyle = '-';
    methods(nMethods).marker = 'o';
end
%% myfun
if 0
    nMethods = nMethods + 1;
    methods(nMethods).fhandle = @myfun;
    methods(nMethods).variable = {'G1', 'G2', 'X0', 'C', 'temperature'};
    methods(nMethods).param = {};
    methods(nMethods).strName = 'fgmU + FDR';
    methods(nMethods).color = 'k';
    methods(nMethods).lineStyle = '-';
    methods(nMethods).marker = 'o';
end
%% fgmD
if 0
    nMethods = nMethods + 1;
    methods(nMethods).fhandle = @fgmD;
    methods(nMethods).variable = {'KP', 'KQD', 'Ct', 'gphDs', 'parFGM_G'};
    methods(nMethods).param = {};
    methods(nMethods).strName = 'fgmG';
    methods(nMethods).color = 'm';
    methods(nMethods).lineStyle = '--';
    methods(nMethods).marker = 'p';
end
%% MatchDR
if 0
    nMethods = nMethods + 1;
    methods(nMethods).fhandle = @MatchDR;
    methods(nMethods).variable = {'G1', 'G2', 'X0', 'temperature'};
    methods(nMethods).param = {};
    methods(nMethods).strName = 'fgmD + MatchDR';
    methods(nMethods).color = 'r';
    methods(nMethods).lineStyle = '-';
    methods(nMethods).marker = 'o';
end
%% myfun
if 0
    nMethods = nMethods + 1;
    methods(nMethods).fhandle = @myfun;
    methods(nMethods).variable = {'G1', 'G2', 'X0', 'C', 'temperature'};
    methods(nMethods).param = {};
    methods(nMethods).strName = 'fgmD + FDR';
    methods(nMethods).color = 'm';
    methods(nMethods).lineStyle = '-';
    methods(nMethods).marker = 'p';
end

%% Show the algorithms to run
disp('* Algorithms to run *');
for k = 1:nMethods, disp([methods(k).strName ' : @' func2str(methods(k).fhandle)]); end; disp(' ')
clear k
