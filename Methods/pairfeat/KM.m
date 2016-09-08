function [ X ] = KM(M)

% data : cell array that contain location of landmark points. Each cell
% array should be 2xn matrix
% scf : cell array that contain feature representation of all landmark

%-----------------------------------------
% load house.mat
% data = data(1:2);
% scf{2} = [scf{2};scf{2}(1,:)];
% data{2} = [data{2};data{2}(1,:)];

% nodes = 1:length(data{1}); % consider same number of landmarks
% n2 = 1:length(data{2});
% N = 2;

[nodes, n2] = size(M);
m = min(nodes, n2);
nodes = 1:nodes;
n2 = 1:n2;
n = m;


% Pairwise matching using given feature representation
base = 1:n;


% i = 1;j = 2;
% M = scf{i}*scf{j}';
M = M(1:m,1:m);
cormat = 1./M;
c = munkres(cormat);
% Unmatched nodes are matched randomly
confused = find(c);


cr = setdiff(base,c(confused));
br = setdiff(base,base(confused));
kf = randperm(length(cr));
c(br)=cr(kf);


X = zeros(length(nodes), length(n2));

set = [0, 1:m-1];
X(length(nodes) * set + c) = 1;


