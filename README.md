MATLAB demo code of Semantic Correspondence with Geometric Structure Analysis

The test environment of the codes is Matlab R2015b Windows 8.1. We cannot guarantee the normal operation in other encironments. 

Rui Wang, Dong Liang, Wei Zhang, Xiaochun Cao
Semantic Correspondence with Geometric Structure Analysis,
TIP under submission

written by Dong Liang, 2017

* Update
	1. The code was updated to run on linux.
	    Note that the algorithm SMCM under comparison is not avaliable in linux as the auther only release their work in a .mexw way. However, you can test it in windows.
    2. The method FGM is off in the default setting. You can turn it on in setMethods.m if your linux support libstdc++.

Date: 25/09/2017
Version: 0.2

1. Overview

run.m   : main script for feature matching demo
dataset : there is an example mat data in matchData4, you can replace it with data provided.

If you want to add your own algorithm for comparison, three steps are required:
1. Create 'YOUR_ALGORITHM_NAME' folder in 'Methods' folder. Then put your code in it.
2. Add the folder in the script 'setPath.m' so that your method can be called.
3. Modify 'setMethods.m' for your method. Note that you should follow the 'methods' structure. 


2. References

Thanks for the framwork of RRWM. (http://cv.snu.ac.kr/research/~RRWM/)

Reweighted Random Walks Matching by Cho et al. ECCV2010

Spectral Matching by Leordeanu and Hebert. ICCV2005

Multi-image Matching via Fast Alternating Minimization. ICCV2015

Subgraph matching using compactness prior for robust feature correspondence by Suh et al. ECCV2015

Sequential Monte Carlo Matching by Suh et al. ECCV2012

Max-Pooling Matching by Cho et al. CVPR2014

Integer Projected Fixed Point Method by Leordeanu et al. NIPS 200

