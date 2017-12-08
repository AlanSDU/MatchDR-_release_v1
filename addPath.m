function addPath
% Add folders of predefined functions into matlab searching paths.
%


global footpath;
footpath = cd;

addpath(genpath([footpath '/src']));
addpath(genpath([footpath '/lib']));

% random seed generation
% RandStream.setDefaultStream(RandStream('mt19937ar', 'seed', sum(100 * clock)));
