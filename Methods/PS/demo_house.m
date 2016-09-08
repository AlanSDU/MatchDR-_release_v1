function demo_house(data,scf)
% function demo_house(N)
% Author - Deepti Pachauri 05/31/2013
% load house.mat
% This function runs the Permutation Synchronization on
% on CMU house data. This code can also be used for any other
% dataset. Data needs to prepared as follows:
% data : cell array that contain location of landmark points. Each cell
% array should be 2xn matrix
% scf : cell array that contain feature representation of all landmark
% This data is arranged such that GROUND TRUTH assignment between any two
% images is identity permutation.
% points in an image. Each cell is nxfeature_dim
% Outputs are saved in a mat file.
% Error made by Kuhn-munkres algorithm is saved as errorP.
% Error made by Permutation Synchronization is saved as errorGS.
%-----------------------------------------
load house.mat
data = data(1:20);

nodes = 1:length(data{1}); % consider same number of landmarks
N = length(data);

%(x,y) location of interest points
rw ={};
cl = {};
n = length(nodes);
for i = 1:N
    rw{i} = data{i}(nodes,1);
    cl{i} = data{i}(nodes,2);
end



% Pairwise matching using given feature representation
P = {};
base = 1:n;
for i = 1:N
    for j = i:N
        m1=[rw{i}';cl{i}'];
        m2=[rw{j}';cl{j}'];

        if i==j
            c = base;
        else
%             for k1 = 1:n
%                 for k2 = 1:n
%                     cormat(k1,k2)=norm(scf{i}(k1,:)-scf{j}(k2,:));
%                 end
%             end

            cormat = 1./(scf{i}*scf{j}');
            c = munkres(cormat);
        end
        % Unmatched nodes are matched randomly
        confused = find(c);
     

        cr = setdiff(base,c(confused));
        br = setdiff(base,base(confused));
        kf = randperm(length(cr));
        c(br)=cr(kf);



        clear nullnodes kf br br confused cormat

        [foo,ind]=sort(c);

        P{i}{j}=c;
       

        P{j}{i}=base(ind);
        clear c
    end
end

% Error made by Kuhn-munkres algorithm (just using features)
errorP = cRerror(P,N,n);

%Permutation Synchronization
gs = {};
clrow = [];
for i = 1:N
    for j = 1:N
        I = eye(n);
        foo = I(:,P{i}{j});
        clrow = [clrow;foo];
    end
end
Snoise = [];
ss = [];
for j = 1:N*n:N*N*n
    for i=1:n:n*N
        c = clrow(j+[i-1:i+n-2],:);
        ss = [ss c];
    end
    Snoise = [Snoise;ss];
    ss = [];
end
[unoise,snoise,vnoise] = svd(Snoise);
un_noise = unoise(:,1:n);
Bnoise={};
for i = 1:n:N*n
    Bnoise{(i+(n-1))/n} = un_noise(i:(i+n)-1,:);
end
evnoise = diag(snoise);

% Recovered permutation
recPM={};
for i = 1:N
    tmp =  Bnoise{i}*Bnoise{1}'*N;
    [tmpU,tmpS,tmpV]=svd(tmp);
    recPM{i} = tmpU*tmpV';
end

% Recovered pairwise assignments after Permutation Synchronization
for i = 1:N
    for j = i+1:N
        tmpp = recPM{i}*recPM{j}';
        [c,cost] = munkres(-tmpp');
        gs{i}{j} = c;
        clear c
    end
end
% Error made by Permutation Synchronization
errorGS = cRerror(gs,N,n);

str = strcat('demo','.mat');
save(str)