cd utils
mex assignmentoptimal.cpp
cd ..

% RRWM
cd Methods
cd RRWM
mex mexBistocNormalize_match_slack.cpp 
cd ..
cd ..

path0 = cd;

% MPM
cd 'Methods/MPM';
mex -largeArrayDims RMP_mult.cpp 
cd(path0);

cd 'lib/cell';
mex cellss.cpp;
mex oness.cpp;
mex zeross.cpp;
cd(path0);

cd 'src/asg/fgm/matrix';
mex multGXH.cpp;
mex multGXHS.cpp;
mex multGXHSQ.cpp;
mex multGXHSQTr.cpp;
cd(path0);

cd 'src/asg/hun';
mex mex_normalize_bistochastic.cpp;
cd(path0);
