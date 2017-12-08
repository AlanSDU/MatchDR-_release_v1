% Curl calculation
%
% Rui Wang, Dong Liang, Wei Zhang, Xiaochun Cao
% Semantic Correspondence with Geometric Structure Analysis,
% TIP under submission

function C = GPatch(IM, X, Y, varargin)
X = round(X);Y = round(Y);C = zeros(size(X));
if isempty(varargin)
    PatchSize = 5; % (11-1)/2
else
    PatchSize = (varargin{1} - 1) / 2;
end
if length(size(IM)) == 3
    IM = rgb2gray(IM);
end
[H, W] = size(IM);
n = length(X);

for i = 1:n
    if X(i) < PatchSize
        Patch_l = 0;
        Patch_r = X(i) + PatchSize;
    else if X(i) > W - PatchSize
            Patch_r = W;
            Patch_l = X(i) - PatchSize;
        else
            Patch_l = X(i) - PatchSize;
            Patch_r = X(i) + PatchSize;
        end
    end
    
    if Y(i) < PatchSize
        Patch_u = 0;
        Patch_d = Y(i) + PatchSize;
    else if Y(i) > H - PatchSize
            Patch_d = H;
            Patch_u = Y(i) -PatchSize;
        else
            Patch_d = Y(i) + PatchSize;
            Patch_u = Y(i) -PatchSize;
        end
    end
%     disp([Patch_l,Patch_r,Patch_u,Patch_d]);
    Patch = IM(Patch_u:Patch_d, Patch_l:Patch_r);imshow(Patch)
    C(i) = GPoint(Patch,[X(i),Y(i)]);
end
% C = sign(C);
end

function [C] = GPoint(Patch, Centre)

Patch = double(Patch);
[m, n] = size(Patch);
C = 0;
for i = 2:n-1
    for j = 2:m-1
        if i ~= Centre(1) || j ~= Centre(2)
            Coo = [i,j] - Centre;
            Rho = sqrt(Coo(1)^2 + Coo(2)^2);
            Theta_tan = 2*atan(Coo(2)/(Rho+Coo(1)));
            if isnan(Theta_tan), Theta_tan = pi; end
            pX = Patch(j-1,i) - Patch(j+1,i);
            pY = Patch(j,i-1) - Patch(j,i+1);
            if pX == 0 && pY == 0, continue; end
            Theta_par = 2*atan(pY/(sqrt(pX^2 + pY^2)+pX));
            if isnan(Theta_par), Theta_par = pi;  end
            Theta = Theta_tan - Theta_par;
%             if Theta > 2*pi, Theta = Theta - 2*pi; elseif Theta <= -2*pi, Theta = Theta + 2*pi; end
            C = C + sqrt(pX^2 + pY^2)*cos(Theta);
%             disp([i,j,pX,pY,Theta_par,C])
        end
    end
end
end