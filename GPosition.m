function [C, Par, Tan] = GPosition(X, Y)

Par = zeros(length(X(:)), 2);
Tan = zeros(length(X(:)), 2);
C = zeros(size(X(:)));
n = length(X);X = X(:);Y = Y(:);
for i = 1:n
    Coo = zeros(size(X));
    Coo(:,1) = X - X(i);
    Coo(:,2) = Y - Y(i);
    Coo(i,:) = [];
    [~, Theta_tan] = rec2pol(Coo);
    L = sum(Theta_tan<-3*pi/4) + sum(Theta_tan>3*pi/4);
    R = sum(Theta_tan<pi/4)-sum(Theta_tan<-pi/4);
    U = sum(Theta_tan<3*pi/4)-sum(Theta_tan<pi/4);
    D = sum(Theta_tan<-pi/4)-sum(Theta_tan<-3*pi/4);
    pX = L - R;pY = U - D;
    [Rho_par, Theta_par] = rec2pol([pX, pY]);
    Coo = [X(i) - mean(X), Y(i) - mean(Y)];
    if sum(abs(Coo), 2) == 0, C(i) = 0; continue; end
    
    [Rho_tan, Theta_tan] = rec2pol(Coo);
    Theta = Theta_tan +pi/2 - Theta_par;
    C(i) = sqrt(pX^2 + pY^2)*cos(Theta);
    Par(i, :) = [Rho_par, Theta_par];
    Tan(i, :) = [Rho_tan+pi/2, Theta_tan+pi/2];
end
end

function [Rho, Theta] = rec2pol(Rec)
if size(Rec, 2) ~= 2
    Rec = Rec';
end
Rho = sqrt(Rec(:,1).^2 + Rec(:,2).^2);
Theta = 2*atan(Rec(:,2)./(Rho+Rec(:,1)));
Theta(isnan(Theta)) = pi;
end