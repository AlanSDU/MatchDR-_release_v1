%% MATLAB demo code for image matching by graph matching algorithms
compile

close all; clear ; %clc;
setPath;    % path addition code goes here
setMethods; % algorithms go here (for comparison)

addpath('./utils_FM')

addpath(genpath('./matchData'))

do_FeatureMatching_demo
