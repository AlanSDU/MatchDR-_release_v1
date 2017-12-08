% MATLAB demo code of Semantic Correspondence with Geometric Structure Analysis
%
% Rui Wang, Dong Liang, Wei Zhang, Xiaochun Cao
% Semantic Correspondence with Geometric Structure Analysis,
% TIP under submission


function [X_min] = myfun(D1, D2, X0, C, temperature)

C = [C{1},C{2}];
beta = 1;
alpha = 0.2;
rho = 0.2;
lambda1 = mean(D1(:));
lambda2 = mean(D2(:));
num1 = size(D1, 1);
num2 = size(D2, 1);
D1 = D1 + diag(sum(D1, 2)) + lambda1;
D2 = D2 + diag(sum(D2, 2)) + lambda2;
X0 = reshape(X0, num1, num2);X0 = X0';
Q = @(x) (x' * D1 * x) ./ D2;
J = @(x) trace((Q(x) - sum(sum(Q(x)))/(sum(x(:))^2).*(Q(x)>0))' * (Q(x) - sum(sum(Q(x)))/(sum(x(:))^2).*(Q(x)>0))) + alpha * sum(sum(x)) ...
    + beta * norm(x*C(:,1) - C(:,2))^2;

X1 = X0;
Lost = J(X0);
X_min = X0;
J_min = Lost;
T = temperature;
D1xx2 = D1*D1;
D2_xx2 = D2.^2;

while temperature > 1
% for i = temperature:-0.1:0
    
%     for k = 0:KMax
        JX1 = J(X1);
        [X2] = Neighbour(D1,D2,D1xx2,D2_xx2,X1,C,alpha,beta,rho);
	JX2 = J(X2); 
        Delta_J = JX2 - JX1;
        
%         if J(X2) == 0
%             break;
%         end
        if Delta_J < 0 || rand(1) < exp(-Delta_J / temperature)
            X1 = X2;
%             break;
        end

%     end
% disp(['JX2=',num2str(JX2)])
    if JX2 < J_min
        J_min = JX2;
        X_min = X2;
    end
    if JX2 <1
        break;
    end
    temperature = temperature-T/1000;
    
end

% 
% n = size(X_min, 1);
% Inv_num = zeros(n,1);
% T1 = Tran_coordinate(view(1).feat);
% T2 = Tran_coordinate(view(2).feat);
% X = T1' * X_min * T2;
% Ind = find(X'==1);
% temp = 1:n:size(X(:), 1);
% Ind = Ind' - temp + 1;
%     
% for i = 1:n
%     Ind = [Ind(2:end), Ind(1)];
%     Inv_num(i) = MergeSort(Ind);
% end
% 
% if mean(Inv_num) >= sum(1:n-1)/2
%     X = fliplr(X);
%     
%     J_min = inf;
%     for i = 1:n
%         X = [X(:,2:end), X(:,1)];
%         J_t = J(X);
%         if J_min > J_t
%             J_min = J_t;
%             X_min = X;
%         end
%     end
%     
%     X_min = T1 * X_min * T2';
% end
X_min = X_min';
end


function [T] = Tran_coordinate(Site)

n = size(Site, 1);
Origin = mean(Site, 1);
OSite = Site - repmat(Origin, n, 1);
Dist = sqrt(sum(OSite.^2, 2));
Rho = 2 * atan(OSite(:, 2)./(Dist + OSite(:, 1)));
[~, Ind] = sort(Rho);
T = zeros(n);
for i = 1:n
    T(Ind(i), i) = 1;
end

end


function [X] = Neighbour(D1, D2, D1xx2, D2_xx2, X0, C, alpha, beta,rho)

Q = @(x) (x' * D1 * x) ./ D2;
% J = @(x) trace((Q(x) - sum(sum(Q(x)))/(sum(x(:))^2).*(Q(x)>0))' * (Q(x) - sum(sum(Q(x)))/(sum(x(:))^2).*(Q(x)>0)));
J = @(x) trace((Q(x) - sum(sum(Q(x)))/(sum(x(:))^2).*(Q(x)>0))' * (Q(x) - sum(sum(Q(x)))/(sum(x(:))^2).*(Q(x)>0))) + alpha * sum(sum(x)) ...
    +beta * norm(x*C(:,1) - C(:,2))^2;

if rand(1) < rho

    J_t = inf;
    
    for i = 1:size(D1,1)
        p = randperm(size(X0,1));
        X_t = X0;
        t = X_t(p(1),:);
        X_t(p(1),:) = X_t(p(2),:);
        X_t(p(2),:) = t;
        if J_t > J(X_t)
            J_t = J(X_t);
            X = X_t;
        end
    end
else
%     if rand(1) < 0.001
%         num2 = size(D2,1);
%         num1 = size(D1,1);
%         tmp = 0:num2:num2*(num1-1);
%         ind = randperm(num2,num1);
%         tmp = tmp  + ind;
%         X = zeros(num2,num1);
%         X(tmp) = 1;
%         X = X';
%         flag = 0;
%     else
    
%     Q = @(x) (x' * D1 * x) ./ D2;
%     J = @(x) trace((Q(x) - sum(sum(Q(x)))/(sum(x(:))^2).*(Q(x)>0))' * (Q(x) - sum(sum(Q(x)))/(sum(x(:))^2).*(Q(x)>0)));

    
    
    
    t1 = (D1xx2 * X0)./D2_xx2;
    t3 = D1 * X0 * (1./D2)';
    Q = (X0' * D1 * X0) ./ D2;
    SumQ = sum(Q(:));
    SumX = sum(X0(:));
    t4 = repmat(C(:,1)', size(C,1), 1);
    
    dX = 4/SumX^2 * t1 - 2*sum(sum(Q.^2))/SumX^3 * X0 - 2*(size(D1,1)*size(D2,1))*SumQ^2/SumX^7 * X0 ...
        + 4*(size(D1,1)*size(D2,1)-2*SumX^2)*SumQ/SumX^7 * (SumX*t3 - SumQ*X0) + alpha * X0 ...
        +beta * repmat((X0*C(:,1)-C(:,2)), 1, size(C,1)) .* t4;
%     disp(beta * repmat((X0*C(:,1)-C(:,2)), 1, size(C,1)) .* t4);
%     beta * repmat((X0*C(:,1)-C(:,2)), 1, size(C,1)) .* t4;
%     disp(norm(X0*C(:,1) - C(:,2))^2)
    
    
%     dX = zeros(size(X0));
%     for i = 1:size(X0,1)
%         
%         for j = 1:size(X0,2)
%             mode = zeros(size(D2));
%             temp = D1*X0; mode(j,:) = temp(i,:);
%             temp = X0'*D1; mode(:,j) = temp(:,i);
%             dX(i,j) = DJ_ij(mode,X0);
%         end
%         
%     end
    
    
    

    [Min, Row] = min(dX);
    [~,Col] = min(Min);
    Row = Row(Col);
    ind = 2;
    while X0(Row,Col) == 1
            [~,I] = sort(dX(:));
            Col = ceil(I(ind)/size(X0,1));
            Row = mod(I(ind), size(X0,1));
            if Row == 0
                Row = size(X0,1);
            end
            ind = ind+1;
    end
    To_Row = find(X0(:,Col));
%     To_Col = find(X0(Row, :));
    if isempty(To_Row)
        X = X0;
        X(Row, Col) = 1;
    else
        X = X0;
        t = X(Row,:);
        X(Row,:) = X(To_Row,:);
        X(To_Row,:) = t;
    end
    
    J_t = J(X);
    
    
    
    [Max, Row] = max(dX);
    [~,Col] = max(Max);
    Row = Row(Col);
    ind = 2;
    while X0(Row,Col) == 0
        [~,I] = sort(dX(:));I = rot90(I,2);
        Col = ceil(I(ind)/size(X0,1));
        Row = mod(I(ind), size(X0,1));
        if Row == 0
            Row = size(X0,1);
        end
        ind = ind+1;
    end

    for i = 1:size(X,1)-1
        
        if i == Row
%             X_t = X0;
%             X_t(i,:) = 0;
%             disp('Add a zero.');
            continue;
        else
            X_t = X0;
            t = X_t(i,:);
            X_t(i,:) = X_t(Row,:);
            X_t(Row,:) = t;
        end
        
        if J(X_t) < J_t
            X = X_t;
            J_t = J(X_t);
        end
        
    end
    
end
end

