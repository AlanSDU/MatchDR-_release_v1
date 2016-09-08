function [X,sco,conf] = graphmatching(M,group1,group2,E12)
    
    [L12(:,1),L12(:,2)] = find(E12);
    Xraw = RRWM(M,group1,group2);
    X = zeros(size(E12)); X(find(E12)) = Xraw;
    X = discretisationMatching_hungarian(X,E12); X = X(find(E12));    
    sco = X(:)'*M*X(:);
    conf = Xraw;
end