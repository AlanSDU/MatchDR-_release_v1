%% Makes current problem into Graph Matching form
% Note: 'cdata' should contain all variables that GM solver needs
%       ex) RRWM solver needs: affineMatrix, group1, group2
function [accuracy score time X Xraw result] = wrapper_FM(method, cdata)
% Make function evaluation script
str = ['feval(@' func2str(method.fhandle)];
for j = 1:length(method.variable), str = [str ',cdata.' method.variable{j} ]; end
if ~isempty(method.param), for i = 1:length(method.param), str = [str, ',method.param{' num2str(i) '}']; end; end
str = [str, ')']; 
% Function evaluation & Excution time Check
tic; XO = eval(str); time = toc;
% standardize result
if size(XO, 2) ~= 1
    Xraw = zeros(length(cdata.matchInfo), 1);
    for i = 1:length(cdata.matchInfo)
        Xraw(i) = XO(cdata.matchInfo(i).match(1)==cdata.match1, cdata.matchInfo(i).match(2)==cdata.match2);
    end
else
    Xraw = XO;
end
    X = greedyMapping(Xraw, cdata.group1, cdata.group2);
    result = zeros(cdata.nP1, cdata.nP2);
    for i = 1:length(cdata.matchInfo)
        result(cdata.matchInfo(i).match(1)==cdata.match1, cdata.matchInfo(i).match(2)==cdata.match2) = X(i);
    end

% Matching Score
score = X'*cdata.affinityMatrix*X; % objective score function

if length(cdata.GTbool) ~= length(cdata.affinityMatrix)
    accuracy = NaN; % Exception for no GT information
else
%     accuracy = (X(:)'*cdata.GTbool(:))/sum(cdata.GTbool);
    
    set = X + cdata.GTbool;
    accuracy = 1 - sum(set == 2) / sum(set ~= 0);
end

% extrapolate the solution for flexible evaluation
X = extrapolateMatchIndicator(cdata.view, cell2mat({cdata.matchInfo.match}'),X,cdata.extrapolate_thres)';