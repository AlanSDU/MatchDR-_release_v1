function [X] = pairfeat(X_in, dimGroup)

dimGroup = dimGroup(:);

set = cumsum(dimGroup);
set = set + 1;
set = [1;set];

X_in = X_in(set(1):set(2)-1, set(2):set(3)-1);

X = KM(X_in);

