% MATLAB demo code of Reweighted Random Walks Graph Matching of ECCV 2010
% 
% Minsu Cho, Jungmin Lee, and Kyoung Mu Lee, 
% Reweighted Random Walks for Graph Matching, 
% Proc. European Conference on Computer Vision (ECCV), 2010
% http://cv.snu.ac.kr/research/~RRWM/

%% MATLAB demo code for image matching by graph matching algorithms
close all; clear ; clc;
setPath;    % path addition code goes here
setMethods; % algorithms go here (for comparison)

addpath('./utils_FM')

%% Options & parameters for experiment
bDisplayMatching = 1;            % Display image feature matching results or not
bDisplayCurl = 0;                      % Display curl or not
bDisplayLabel = 1;                    % Display label or not
extrapolate_thres = 15;          % Extrapolation of matches for flexible evaluation
affinity_max = 50;               % maximum value of affinity 
matchDataPath = '.\matchData\';  % Path for 'mat' files  


%% Storage for Matching Results
fileList = dir([matchDataPath '*.mat']);      % Load all 'mat' files
accuracy = zeros(length(fileList), nMethods); % Matching accuracy
score = zeros(length(fileList), nMethods);    % Objective score
time = zeros(length(fileList), nMethods);     % Running time
X = cell(length(fileList), nMethods);         % Soft assignment
Xraw = cell(length(fileList), nMethods);      % Hard assignment

%% Image Matching Loop
for cImg = 1:length(fileList)

    clear cdata GT; close all
    %% Load match data (cdata)
    matchDataPathnFile = [matchDataPath fileList(cImg).name];
    disp ([matchDataPathnFile ' file loading.']); load(matchDataPathnFile);
    
    %% Perform MATCHING
    % Make affinity matrix
    cdata.affinityMatrix = max(affinity_max - cdata.distanceMatrix,0); % dissimilarity -> similarity conversion
    cdata.affinityMatrix(1:(length(cdata.affinityMatrix)+1):end) = 0; % diagonal zeros
    % Calculate the necessory parameters for some other methods
    if ~isfield(cdata, 'GTbool')
    cdata.GTbool = extrapolateGT(cdata.view, cell2mat({cdata.matchInfo.match}'), cdata.GT, extrapolate_thres)';
    end
    cdata.extrapolate_thres = extrapolate_thres;
    cdata.match1 = zeros(length(cdata.matchInfo)+1, 1); cdata.match2 = cdata.match1;
    for i = 1:length(cdata.matchInfo)
        cdata.match1(i) = cdata.matchInfo(i).match(1);
        cdata.match2(i) = cdata.matchInfo(i).match(2);
    end
    cdata.match1 = unique(cdata.match1);cdata.match1(1) = [];
    cdata.match2 = unique(cdata.match2);cdata.match2(1) = [];
    cdata.nP1 = length(cdata.match1);
    cdata.nP2 = length(cdata.match2);
    cdata.stateDims = [cdata.nP1, cdata.nP2];
    loc_x1 = cdata.view(1).frames(1,:);
    loc_y1 = cdata.view(1).frames(2,:);
    loc_x2 = cdata.view(2).frames(1,:);
    loc_y2 = cdata.view(2).frames(2,:);
    cdata.G1 = sqrt((repmat(loc_x1', 1, length(loc_x1))-repmat(loc_x1, length(loc_x1), 1)).^2 + (repmat(loc_y1', 1, length(loc_x1))-repmat(loc_y1, length(loc_y1), 1)).^2);
    cdata.G2 = sqrt((repmat(loc_x2', 1, length(loc_x2))-repmat(loc_x2, length(loc_x2), 1)).^2 + (repmat(loc_y2', 1, length(loc_x2))-repmat(loc_y2, length(loc_y2), 1)).^2);
    cdata.G1 = cdata.G1(cdata.match1, cdata.match1);
    cdata.G2 = cdata.G2(cdata.match2, cdata.match2);
    cdata.X0 = zeros(sum(cdata.stateDims), sum(cdata.stateDims));
    W = cdata.view(1).descrs' * cdata.view(2).descrs;
    cdata.W = cdata.X0;
    for i = 1:length(cdata.matchInfo)
        cdata.W(cdata.matchInfo(i).match(1), cdata.matchInfo(i).match(2)) = W(cdata.matchInfo(i).match(1), cdata.matchInfo(i).match(2));
    end
    cdata.W = [eye(cdata.nP1), cdata.W(cdata.match1, cdata.match2);
        cdata.W(cdata.match1, cdata.match2)', eye(cdata.nP2)];
    cdata.group1 = sparse(cdata.group1 ~= 0);
    cdata.group2 = sparse(cdata.group2 ~= 0);
    
    % Set the iteration parameter
    cdata.temperature = length(cdata.GTbool);
    
    % Calculate the flip-term
    cdata.C = cell(1,2);
    if bDisplayCurl
        cdata.Par = cell(1,2); 
        cdata.Tan = cell(1,2);
        for i = 1:2
            [cdata.C{i}, cdata.Par{i}, cdata.Tan{i}] = GPosition(round(cdata.view(i).feat(:,1)), round(cdata.view(i).feat(:,2)));
        end
    else
        for i = 1:2
            [cdata.C{i}, ~, ~] = GPosition(round(cdata.view(i).feat(:,1)), round(cdata.view(i).feat(:,2)));
        end
    end


    % Algorithm evaluation
    for cMethod = 1:nMethods
        
        % Initialization
        if sum(cdata.X0(:)) < cdata.nP1 || (~strcmp(func2str(methods(cMethod).fhandle), 'MatchDR') && ~strcmp(func2str(methods(cMethod).fhandle), 'myfun'))
            tmp = 0:cdata.nP2:cdata.nP2*(cdata.nP1-1);
            ind = randperm(cdata.nP2,cdata.nP1);
            tmp = tmp  + ind;
            cdata.X0 = zeros(cdata.nP2,cdata.nP1);
            cdata.X0(tmp) = 1;
            cdata.X0 = cdata.X0';
            X0 = cdata.X0;
        elseif strcmp(func2str(methods(cMethod).fhandle), 'MatchDR')
            X0 = cdata.X0;
        elseif  strcmp(func2str(methods(cMethod).fhandle), 'myfun')
            cdata.X0 = X0;
        end
        
        [accuracy(cImg,cMethod) score(cImg,cMethod) time(cImg,cMethod) X{cImg,cMethod} Xraw{cImg,cMethod} cdata.X0] ...
            = wrapper_FM(methods(cMethod), cdata);
        
        % Display feature matching results
        if bDisplayMatching
            str = [methods(cMethod).strName ...
                '  Error rate: ' num2str(accuracy(cImg, cMethod)) ...
                ' (' num2str(accuracy(cImg,cMethod)*sum(cdata.GTbool)) '/' num2str(sum(cdata.GTbool)) ')'];
            figure('NumberTitle', 'off', 'Name', str);
            displayFeatureMatching(cdata, X{cImg,cMethod}, cdata.GTbool, methods(cMethod).strName, ...
                accuracy(cImg,cMethod), bDisplayLabel, bDisplayCurl);
        end
    end
    if bDisplayMatching, drawnow; if cImg ~= length(fileList), pause; end; end
end
%% Calculate performance
% Average of accuracy
meanAccuracy = 100*mean(accuracy,1); % avg. of (# of correct match) / (# of GT match)
% Average of relative score
maxScore = max(score,[],2); relScore = score./repmat(maxScore, 1, nMethods);
meanScore = 100*mean(relScore,1); % avg. of relative score
% Average of time
meanTime = mean(time,1); % avg. of computation time
%% Display
fprintf('---------------------------------------------------\n');
fprintf('|%10s\t\tError-rate(%%)\tTime(s)   |\n', 'Methods');
for cMethod = 1:nMethods
    fprintf('|%10s\t\t%3.2f\t\t%3.2f      |\n', ...
        methods(cMethod).strName, meanAccuracy(cMethod), meanTime(cMethod));
end
fprintf('---------------------------------------------------\n');
