% MATLAB demo code of Semantic Correspondence with Geometric Structure Analysis
%
% Rui Wang, Dong Liang, Wei Zhang, Xiaochun Cao
% Semantic Correspondence with Geometric Structure Analysis,
% TIP under submission

%% Options & parameters for experiment
bDisplayMatching = 0;            % Display image feature matching results or not
bDisplayCurl = 0;                      % Display curl or not
bDisplayLabel = 0;                    % Display label or not
extrapolate_thres = 15;          % Extrapolation of matches for flexible evaluation
affinity_max = 50;               % maximum value of affinity
matchDataPath = './matchData/matchTest/';  % Path for 'mat' files
% 3. building;
% 4. willow;
% Test. Test data;
% Face. willow.face;
% CM. application with outlier

%% Storage for Matching Results
fileList = dir([matchDataPath '*.mat']);      % Load all 'mat' files
accuracy = zeros(length(fileList), nMethods); % Matching accuracy
score = zeros(length(fileList), nMethods);    % Objective score
time = zeros(length(fileList), nMethods);     % Running time
X = cell(length(fileList), nMethods);         % Soft assignment
Xraw = cell(length(fileList), nMethods);      % Hard assignmen

%% Image Matching Loop
for cImg = 1:length(fileList)
    
    clear cdata GT; close all
    %% Load match data (cdata)
    matchDataPathnFile = [matchDataPath fileList(cImg).name];
    load(matchDataPathnFile);
    
    %% Perform MATCHING
    % Make affinity matrix
    cdata.affinityMatrix = max(affinity_max - cdata.distanceMatrix,0); % dissimilarity -> similarity conversion
    %cdata.affinityMatrix = exp(-cdata.distanceMatrix/25); % dissimilarity -> similarity conversion
    cdata.affinityMatrix(1:(length(cdata.affinityMatrix)+1):end) = 0; % diagonal zeros
    % Extrapolate the given ground truths for flexible evaluation
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
    
    Pts = cell(1,2);
    Pts{1} = cdata.view(1).feat';
    Pts{2} = cdata.view(2).feat';
    parG.link = 'del';
    cdata.gphs = newGphUs(Pts, parG);
    
    parKnl.alg = 'cmum';
    [cdata.KP, cdata.KQ] = conKnlGphPQU(cdata.gphs, parKnl);
    cdata.Ct = ones(size(cdata.KP));
    cdata.gphDs = gphU2Ds(cdata.gphs);
    cdata.KQD = [cdata.KQ, cdata.KQ; cdata.KQ, cdata.KQ];
    cdata.parFGM_U.nItMa = 100; cdata.parFGM_U.nAlp = 101; cdata.parFGM_U.thAlp = 0; cdata.parFGM_U.deb = 'n'; cdata.parFGM_U.ip = 'n';
    cdata.parFGM_G.nItMa = 100; cdata.parFGM_G.nAlp = 101; cdata.parFGM_G.lamQ = 0.5; cdata.parFGM_G.deb = 'n'; cdata.parFGM_G.ip = 'n';
    
    
    cdata.temperature = length(cdata.GTbool);
    
    cdata.C = cell(1,2);
    if bDisplayCurl
        cdata.Par = cell(1,2); % [Rho, Theta]
        cdata.Tan = cell(1,2); % zeros(2, size(cdata.view(1).feat,1), 2);
        for i = 1:2
            [cdata.C{i}, cdata.Par{i}, cdata.Tan{i}] = GPosition(round(cdata.view(i).feat(:,1)), round(cdata.view(i).feat(:,2)));
            cdata.C{i}(cdata.C{i} > 1) = 1; cdata.C{i}(cdata.C{i} < -1) = -1;
        end
    else
        for i = 1:2
            [cdata.C{i}, ~, ~] = GPosition(round(cdata.view(i).feat(:,1)), round(cdata.view(i).feat(:,2)));
            cdata.C{i}(cdata.C{i} > 1) = 1; cdata.C{i}(cdata.C{i} < -1) = -1;
        end
    end
    
    tmp = 0:cdata.nP2:cdata.nP2*(cdata.nP1-1);
    ind = randperm(cdata.nP2,cdata.nP1);
    tmp = tmp  + ind;
    cdata.X0 = zeros(cdata.nP2,cdata.nP1);
    cdata.X0(tmp) = 1;
    cdata.X0 = cdata.X0';
    
    % Algorithm evaluation
    for cMethod = 1:nMethods
        
        if sum(cdata.X0(:)) < cdata.nP1 || ~strcmp(func2str(methods(cMethod).fhandle), 'MatchDR')
            tmp = 0:cdata.nP2:cdata.nP2*(cdata.nP1-1);
            ind = randperm(cdata.nP2,cdata.nP1);
            tmp = tmp  + ind;
            cdata.X0 = zeros(cdata.nP2,cdata.nP1);
            cdata.X0(tmp) = 1;
            cdata.X0 = cdata.X0';
        end

        [accuracy(cImg,cMethod) score(cImg,cMethod) time(cImg,cMethod) X{cImg,cMethod} Xraw{cImg,cMethod} TO_X0] ...
            = wrapper_FM(methods(cMethod), cdata);
        cdata.X0 = TO_X0;
        
        % Display feature matching results
        if bDisplayMatching
            str = [methods(cMethod).strName ...
                '  Error rate: ' num2str(accuracy(cImg, cMethod)) ...
                ' (' num2str(accuracy(cImg,cMethod)*sum(cdata.GTbool)) '/' num2str(sum(cdata.GTbool)) ')' ...
                '  Score: ' num2str(score(cImg, cMethod)) ];
            figure('NumberTitle', 'off', 'Name', str);
            displayFeatureMatching(cdata, X{cImg,cMethod}, cdata.GTbool, methods(cMethod).strName, ...
                accuracy(cImg,cMethod), bDisplayLabel, bDisplayCurl);
            
            print(gcf,'-depsc', ['./pic/',methods(cMethod).strName,'.eps']);
            saveas(gcf, ['./pic/',methods(cMethod).strName, '.fig'])
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
fprintf('|%10s\t\tError-rate(%%)\tScore(%%)\tTime(s)   |\n', 'Methods');
for cMethod = 1:nMethods
    fprintf('|%10s\t\t%3.2f\t\t%3.2f\t\t%3.2f      |\n', ...
        methods(cMethod).strName, meanAccuracy(cMethod), meanScore(cMethod), meanTime(cMethod));
end
fprintf('---------------------------------------------------\n');
