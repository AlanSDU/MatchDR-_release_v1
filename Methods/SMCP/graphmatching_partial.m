function [X,sco,conf] = graphmatching_partial(M,group1,group2,L12,e1,Xinit)
    if(isempty(Xinit))
        Xinit = ones(length(M),1)/length(M);
    end
    if(all(e1==0))
        X = [];
        sco = -inf;
        conf = ones(length(M),1);
        return;
    end
    n1 = size(group1,2);
    n2 = size(group2,2);
    id1 = find(e1);
    partial = ismember(L12(:,1),id1);
    Mpartial = M(partial,partial);
    L12_ = L12(partial,:);
    E12_ = ones(sum(e1),n2);
    [group1_,group2_] = make_group12(L12_);

    Xraw = RRWM(Mpartial,group1_,group2_);
    X_ = zeros(size(E12_)); X_(find(E12_)) = Xraw;
    X_ = discretisationMatching_hungarian(X_,E12_); X_ = X_(find(E12_));
    
    X = zeros(n1*n2,1);
    X(L12_(logical(X_),1) + (L12_(logical(X_),2)-1)*n1) = 1;
    sco = X(:)'*M*X(:);
    conf = zeros(n1*n2,1); conf(partial) = Xraw;
end