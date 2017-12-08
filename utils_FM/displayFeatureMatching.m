function displayFeatureMatching(cdata, X, GT,TEXT, accurcy, bDisplayLabel, bDisplayCurl)

imgInput = appendimages( cdata.view(1).img, cdata.view(2).img );
imgInput = double(imgInput)./255;
imshow(imgInput);  alpha(0.5);
hold on;
if bDisplayLabel == 1
    text(4,12,TEXT,'Color','red','FontSize',14)
    text(4,40,['Error Rate: ', num2str(accurcy)],'Color','red','FontSize',14)
end
iptsetpref('ImshowBorder','tight');

% draw false matches
curMatchList = cell2mat({cdata.matchInfo(:).match }');
idxFeat1 = curMatchList(:,1);
idxFeat2 = curMatchList(:,2);
feat1 = cdata.view(1).feat(idxFeat1,:);
feat2 = cdata.view(2).feat(idxFeat2,:);
feat2(:,1) = feat2(:,1) + size(cdata.view(1).img,2);
for i = 1:length(X)
    if X(i) && GT(i) == 0
        col1 = 'r';
        col2 = 'r';
    else
        continue;
    end
    plot([ feat1(i,1), feat2(i,1) ]...
    ,[ feat1(i,2), feat2(i,2) ],...
            '-','LineWidth',2,'MarkerSize',50,...
            'color', col1);

        if size(feat1, 2) ~=2
    drawellipse2( feat1(i,1:5), 1, 'r',4);
    drawellipse2( feat1(i,1:5), 1, col2,3);
    drawellipse2( feat2(i,1:5) ,1, 'r',4);
    drawellipse2( feat2(i,1:5) ,1, col2,3);                    
        end
    
%     vl_plotframe( [feat1(i,1:4), feat1(i,4:5)]);
%     vl_plotframe( [feat2(i,1:4), feat2(i,4:5)]);        
end
% draw true matches
for i = 1:length(X)
    if X(i) && GT(i) == 1
%     if GT(i) == 1
        col1 = 'g';
        col2 = 'g';
    else
        continue;
    end
    plot([ feat1(i,1), feat2(i,1) ]...
    ,[ feat1(i,2), feat2(i,2) ],...
            '-','LineWidth',2,'MarkerSize',50,...
            'color', 'r');
    plot([ feat1(i,1), feat2(i,1) ]...
    ,[ feat1(i,2), feat2(i,2) ],...
            '-','LineWidth',2,'MarkerSize',50,...
            'color', col1);

        if size(feat1, 2) ~=2
    drawellipse2( feat1(i,1:5), 1, 'k',5);
    drawellipse2( feat1(i,1:5), 1, col2,4);
    drawellipse2( feat2(i,1:5) ,1, 'k',5);
    drawellipse2( feat2(i,1:5) ,1, col2,4);                    
        end
    
%     [~,e]=eig([feat1(i, 3:4);feat1(i, 4:5)]);
%     l1=1/sqrt(e(1));
%     l2=1/sqrt(e(4));
%     e(1,1)=l2;e(2,2) = l1;
%     pt = R'*e*R';
%     vl_plotframe([feat1(i,1:2),pt(:)'], col);
%     vl_plotframe( [feat2(i,1:4), feat2(i,4:5)]);

end                     


% % col = hsv(length(X));
% % for i = 1:length(X)
% %     if GT(i) == 1
% %         plot(feat1(i,1),feat1(i,2), '.', 'MarkerSize',50, 'color',col(i,:));
% %         plot(feat2(i,1),feat2(i,2), '.', 'MarkerSize',50, 'color',col(i,:));
% %     end
% % end
% % 
% % for i = 1:length(X)
% %     if X(i) == 1
% %         plot(feat1(i,1),feat1(i,2), '.', 'MarkerSize',20, 'color',col(i,:));
% %         plot(feat2(i,1),feat2(i,2), '.', 'MarkerSize',20, 'color',col(i,:));
% %     end
% % end


for i = 1:length(X)
    if X(i) == 1
        plot(feat1(i,1),feat1(i,2), '.', 'color', 'r', 'MarkerSize',40);
        plot(feat2(i,1),feat2(i,2), '.', 'color', 'r', 'MarkerSize',40);
    end
end

for i = 1:length(X)
    if GT(i) == 1 && X(i) == 1
        plot(feat1(i,1),feat1(i,2), '.', 'color', 'g', 'MarkerSize',40);
        plot(feat2(i,1),feat2(i,2), '.', 'color', 'g', 'MarkerSize',40);
    end
end


% Draw Curl

if bDisplayCurl
    DrawCurl(cdata)
    figure(2);hold on;DrawCurl(cdata);axis tight equal % data4-17
end


hold off
end

function DrawCurl(cdata)

SIZE = size(cdata.view(1).img) + size(cdata.view(2).img);
SIZE = SIZE(1:2);
feat{1} = cdata.view(1).feat;
feat{2} = cdata.view(2).feat;
feat{2}(:,1) = feat{2}(:,1) + size(cdata.view(1).img,2);
Coo = cell(2,1);
for i = 1:2
    Coo{i}= mean(feat{i},1);
    for j = 1:cdata.nP1
        pos = [Coo{i}(1,1) - cdata.Tan{i}(j,1), Coo{i}(1,2) - cdata.Tan{i}(j,1), 2 * cdata.Tan{i}(j,1), 2 * cdata.Tan{i}(j,1)];
        rectangle('Position', pos, 'Curvature',[1,1], 'EdgeColor', 'k');
        
%         dis = reshape(cdata.Tan(1,:,:), size(feat{i}));
%         Arrow2(feat{i}(j,:), dis(j,:), SIZE, 'b');
%         dis = reshape(cdata.Par(1,:,:), size(feat{i}));
%         Arrow2(feat{i}(j,:), dis(j,:), SIZE, 'g');
        
    end
    dis = reshape(cdata.Tan(1,:,:), size(feat{i}));
    Arrow3(feat{i}, dis, 'k');
    dis = reshape(cdata.Par(1,:,:), size(feat{i}));
    Arrow3(feat{i}, dis, 'b');
end
end

function Arrow2(p1, dis, SIZE,varargin)

if size(p1,2) ~= 2
    p1 = p1';
end
if size(dis,2) ~= 2
    dis = dis';
end
if size(SIZE,2) ~= 2
    SIZE = SIZE';
end

p2 = p1 + [dis(:,1) .* cos(dis(:,2)), dis(:,1) .* sin(dis(:,2))];
p2 = p2 ./ (ones(size(p2,1),1) * SIZE);
p1 = p1 ./ (ones(size(p1,1),1) * SIZE);

for i = 1:size(p1,1)
    annotation('textarrow',p1, p2, varargin{:});
end
end

function Arrow3(p1, dis, varargin)

if size(p1,2) ~= 2
    p1 = p1';
end
if size(dis,2) ~= 2
    dis = dis';
end

quiver(p1(:,1), p1(:,2), dis(:,1) .* cos(dis(:,2)), dis(:,1) .* sin(dis(:,2)), varargin{:});
end