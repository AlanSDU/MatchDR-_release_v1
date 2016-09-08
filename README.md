# MatchDR-_release_v1

Image Matching MATLAB demo code of Match Distance Ratio* (MatchDR*)

Dong Liang, Wei Zhang 
Reweighted Random Walks for Graph Matching, 
Proc. European Conference on Computer Vision (ECCV), 2010
http://cv.snu.ac.kr/research/~RRWM/

Please cite our work if you find this code useful in your research. 

written by Minsu Cho & Jungmin Lee, 2010, Seoul National University, Korea
http://cv.snu.ac.kr/~minsucho/
http://cv.snu.ac.kr/~jungminlee/

===================================================================================

1. Overview

This additional code provides the image matching demo in our paper.
The data of 30 image pairs used in our paper are contained in 'matchData' folder.
copy all codes and folders into the root folder of 'RRWM_release_v1.2'

'do_FeatureMatching_demo.m' loads precomputed data (image features, affinity matrix, 
and ground truths) and runs graph matching algorithms on each image pair. 
To visualize image matching results, set bDisplayMatching = 1 in 'do_FeatureMatching_demo.m'

** Since this code uses a different way of measuring the matching accuracy, 
the overall accuracy values would be higher than those of the paper.
For flexible evaluation of matching accuracy, both ground truths and detected matches
are extrapolated among candidate matches, and the accuracy are measured based on them.
The papameter extrapolate_thres (pixels) in 'do_FeatureMatching_demo.m' determines the distance.
(i.e. the higher extrapolate_thres means further extrapolation and more generous true/false decision,
whereas the lower extrapolate_thres means nearer extrapolation and more strict true/false decision)

Based on this code with the data files, any algorithm can be tested on the dataset.
If you want to add your own algorithm for comparison, three steps are required.
1) Create 'YOUR_ALGORITHM_NAME' folder in 'Methods' folder. Then put your code in it.
2) Add the path to 'setPath.m' so that your method can be called.
3) Add the configuration of your method to 'setMethods.m'


2. References 

This MATLAB code includes the NEARESTNEIGHBOUR function written by  Richard Brown:
http://www.mathworks.com/matlabcentral/fileexchange/12574-nearestneighbour-m
