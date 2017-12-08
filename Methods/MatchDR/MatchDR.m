function [X_min] = MatchDR(D1, D2, X0, temperature)

% KMax = 20;
% lambda = 0;
alpha = 0.2;
lambda = (mean(D1(:))+mean(D2(:)))/2;
num1 = size(D1, 1);
num2 = size(D2, 1);
D1 = D1 + diag(sum(D1, 2)) + lambda;
D2 = D2 + diag(sum(D2, 2)) + lambda;
X0 = reshape(X0, num1, num2);
Q = @(x) (x' * D1 * x) ./ D2;
% J = @(x) trace((Q(x) - sum(sum(Q(x)))/(sum(x(:))^2))' * (Q(x) - sum(sum(Q(x)))/(sum(x(:))^2)));
% J = @(x) trace((Q(x) - sum(sum(Q(x)))/(sum(x(:))^2).*(Q(x)>0))' * (Q(x) - sum(sum(Q(x)))/(sum(x(:))^2).*(Q(x)>0)));
J = @(x) trace((Q(x) - sum(sum(Q(x)))/(sum(x(:))^2).*(Q(x)>0))' * (Q(x) - sum(sum(Q(x)))/(sum(x(:))^2).*(Q(x)>0))) + alpha * sum(sum(x));

X1 = X0;
Lost = J(X0);
X_min = X0;
J_min = Lost;
T = temperature;
while temperature > 1
    
%     for k = 0:KMax
        
        [X2] = Neighbour(D1,D2,X1,alpha);
        Delta_J = J(X2) - J(X1);
        
%         if J(X2) == 0
%             break;
%         end
        if Delta_J < 0 || rand(1) < exp(-Delta_J / temperature)
            X1 = X2;
%             break;
        end

%     end
    if J(X2) < J_min
        J_min = J(X2);
        X_min = X2;
    end
    if J(X2) <1
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
end




function [X] = Neighbour(D1, D2, X0, alpha)

Q = @(x) (x' * D1 * x) ./ D2;
% J = @(x) trace((Q(x) - sum(sum(Q(x)))/(sum(x(:))^2).*(Q(x)>0))' * (Q(x) - sum(sum(Q(x)))/(sum(x(:))^2).*(Q(x)>0)));
J = @(x) trace((Q(x) - sum(sum(Q(x)))/(sum(x(:))^2).*(Q(x)>0))' * (Q(x) - sum(sum(Q(x)))/(sum(x(:))^2).*(Q(x)>0))) + alpha * sum(sum(x));

if rand(1) < 0.2

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

    
    
    
    t1 =  (D1 * X0);
    t2 = (X0' * D1 * X0)./(D2 .^ 2);
    t3 = D1 * X0 * (1./D2)';
    Q = (X0' * D1 * X0) ./ D2;
    SumQ = sum(Q(:));
    SumX = sum(X0(:));
    
    dX = 4/SumX^2 * t1 * t2 - 2*sum(sum(Q.^2))/SumX^3 * X0 - 2*(size(D1,1)*size(D2,1))*SumQ^2/SumX^7 * X0 ...
        + 4*(size(D1,1)*size(D2,1)-2*SumX^2)*SumQ/SumX^7 * (SumX*t3 - SumQ*X0) + alpha * X0;
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

