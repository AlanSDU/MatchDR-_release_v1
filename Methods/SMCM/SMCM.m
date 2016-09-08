function X = SMCM(M, group1, group2, varargin)
% MATLAB demo code of Sequential Monte Carlo Graph Matching of ECCV 2012
% 
% Yumin Suh, Minsu Cho, and Kyoung Mu Lee, 
% Graph Matching via Sequential Monte Carlo, 
% Proc. European Conference on Computer Vision (ECCV), 2012
% http://cv.snu.ac.kr/research/~SMCM/
% Computer Vision Lab, Seoul National University, Korea
%
% Please cite our work if you find this code useful in your research. 
%
% written by Yumin Suh & Minsu Cho & Jungmin Lee, 2010, Seoul National University, Korea
% http://cv.snu.ac.kr/~ysuh/
% http://cv.snu.ac.kr/~minsucho/
% http://cv.snu.ac.kr/~jungminlee/
%
%
% Date: 02/08/2013
% Version: 1.0
%
% ==================================================================================================
%
% input
%       M: affinity matrix
%       group1: conflicting match groups in domain 1 (size(M,1) x nGroup1)
%       group2: conflicting match groups in domain 2 (size(M,1) x nGroup2)
%                 
%       e.g. find(group1(:,3)) represents the third goup of matches  
%                               sharing the same feature in domain1   
%
% output
%       X: graph matching solution of SMCM

%% Default Parameters
param = struct( ...
    'nParticles', 2000, ...     % Number of particles
    'tau', 2, ...               % Scaling constant in Equation (5)
    'alpha_', 0.1 ...           % Approximation ratio. See Section 3.4. 
     ...                        %  Transition Kernel for detailed description
);
param = parseargs(param, varargin{:});

%% parameter structure -> parameter value
strField = fieldnames(param);
for i = 1:length(strField), eval([strField{i} '=param.' strField{i} ';']); end

%% Check Input
sizeM = size(M,1);
group1 = int32(full(group1));
group2 = int32(full(group2));
nParticles = int32(nParticles);

% if(sizeM ~= size(group1,1))
%     error('error in SMCM');
% end
% if(sizeM ~= size(group2,1))
%     error('error in SMCM');
% end

%%
nWindow = ceil( sizeM * alpha_ );
rankM = zeros(nWindow, sizeM, 'int32');
for i = 1 : sizeM
    [~,idxM] = sort(M(:,i),'descend');
    rankM(:,i) = int32(idxM(1:nWindow));
end
rankM = rankM - 1;

%%
[X,~,~] = SMC_eccv(M, group1, group2, rankM, nParticles, tau);