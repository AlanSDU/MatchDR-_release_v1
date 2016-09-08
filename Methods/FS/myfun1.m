function [ X ] = myfun1(G1, G2, X0)
miter = 5000;
alpha = 0;
lambda = (sum(G1(:))+sum(G1(:)))/(length(G1(:)+length(G1(:))));
smooth_term = 0;

num1 = size(G1, 1);
num2 = size(G2, 1);
X1 = reshape(X0, num1, num2);

%% exchange
% ind = randperm(num2-1);
% for i = 1:0.1*num2
%     tmp = X1(:,ind(i));
%     X1(:,ind(i)) = X1(:,ind(i)+1);
%     X1(:,ind(i+1)) = tmp;
% end

%% replace with zeros
% for i = 1:2
%     X(:,i) = zeros(num, 1);
% end
%% 

X = X1;
L1 = G1;
L2 = G2+.05;
L1 = L1 + diag(sum(L1, 2));
L2 = L2 + diag(sum(L2, 2));

L1 = L1 + lambda;
L2 = L2 + lambda;
L2 = L2 + smooth_term;


for iter = 1:miter
    
    
    t1 =  (L1 * X);
    t2 = (X' * L1 * X)./(L2 .^ 2);
    
    Q = (X' * L1 * X) ./ L2;
    SumQ = sum(Q(:));
    SumX = sum(X(:));
    t3 = L1 * X * (1./L2)';

    cost(iter + 1) = trace(((X' * L1 *X) ./ L2 - SumQ/SumX^2)' * ((X' * L1 *X) ./ L2 - SumQ/SumX^2));
    
    DX = 4/SumX^2 * t1 * t2 - 2*sum(sum(Q.^2))/SumX^3 * X - 2*(num1*num2)*SumQ^2/SumX^7 * X ...
        + 4*(num1*num2-2*SumX^2)*SumQ/SumX^7 * (SumX*t3 - SumQ*X) + alpha * X;
    
    X = X - (.05/norm(DX)) * DX;

    
    X(X>1)=1;
    X(X<0)=0;

%     cost1(iter+1) = corr(X(:),X0(:));
    if abs(cost(iter) - cost(iter + 1)) < 0.0001*norm(DX)
        break;
    end
end

X(X>1)=1;
X(X<0)=0;

X = X > 0.5;
% X=X(:);


% plot(cost(2:end))
% plot(cost1(2:end))