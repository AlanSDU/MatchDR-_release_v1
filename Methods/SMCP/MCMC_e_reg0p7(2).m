%% Solve matching by MCMC sampling
% Data Driven Markov Chain Monte Carlo Sampling for matching
% by Jungmin Lee
function [X,currentW] = MCMC_e_reg1( M, group1, group2, E12,L12 )

lambda = 0.7;

[list(:,1), list(:,2)] = find(E12);
n1 = size(E12,1);
n2 = size(E12,2);

%% parameters
startTemperature = 10;
finishTemperature = 5;
nSamplePerTemp = 5;
TempDecreasingFactor = 0.9;

%% initial state
numMatch = length(unique(list(:,1)));
e = zeros(n1,1);
currentE = e;
[Xcurr, currentEnergy] = graphmatching(M.*repmat(currentE*currentE',n2,n2),group1,group2,E12);
currentEnergy = currentEnergy - lambda*sum(currentE)^2;

temperature = startTemperature;
count = 0;

bestE = currentE;
bestEnergy = currentEnergy;
nUpdateE = 0;
nBestUpdateE = 0;

if(all(e))
    X = Xcurr;
    return;
end
iter = 0;

%% Sampling Loop
while temperature > finishTemperature 
    iter = iter + 1;
    proposeE = currentE;
    k = 1;    
    sel = randperm(n1,k);
    proposeE(sel) = 1-proposeE(sel);

    probGo = 1;
    probBack = 1;

    [Xprop,proposeEnergy] = graphmatching_partial(M,group1,group2,L12,proposeE,Xcurr);
    proposeEnergy = proposeEnergy - lambda*sum(proposeE)^2;
    
    deltaEnergy = proposeEnergy - currentEnergy;
    acceptRatio = exp(deltaEnergy/temperature)*probBack/probGo;
    count = count + 1;

    % Apply MH rule
    if rand < min(acceptRatio, 1)
        currentEnergy = proposeEnergy;
        currentE = proposeE;
        nUpdateE = nUpdateE + 1;
        Xcurr = Xprop;

        if currentEnergy > bestEnergy
            tmpscore = Xprop'*(M.*repmat(currentE*currentE',n2,n2))*Xprop;
            fprintf('temperature: %f, #nodes = %d, score: %f, scoreReg1: %f\n',temperature,sum(currentE), tmpscore,tmpscore-lambda*sum(currentE)^2);
            bestE = currentE;
            bestEnergy = currentEnergy;
            nBestUpdateE = nBestUpdateE + 1;
        end
    end
           
    if count > nSamplePerTemp*sqrt(numMatch)
        temperature = temperature*TempDecreasingFactor;
        count = 0;
    end
    
%     pause
end
if(bestEnergy==0)
    [X, scoIn] = graphmatching(M.*repmat(bestE*bestE',n2,n2),group1,group2,E12);
    return;
end
[X,scoIn] = graphmatching_partial(M,group1,group2,L12,bestE,[]); %f, scoreOut: %f\n', scoreTot, scoreIn,scoreInOut,scoreOut));
fprintf(sprintf('[DDMCMCE] scoreIn: %f, #iter: %d\n', scoIn,iter));
