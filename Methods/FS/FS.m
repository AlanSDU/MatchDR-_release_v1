function [X] = FS(dist1, dist2, X_in, dimGroup, varargin)

dimGroup = dimGroup(:);
dist = {dist1; dist2};

str = 'feval(@mmatch_CVX_ALS, X_in, dimGroup';
for j = 1:length(varargin), str = [str ', ' mat2str(varargin{j}) ]; end
str = [str, ')']; 

% run multiple matching
X = eval(str); 
set = cumsum(dimGroup);
set = set + 1;
set = [1;set];

X = myfun1(dist{1}, dist{2}, X(set(1):set(1+1)-1, set(2):set(2+1)-1));
