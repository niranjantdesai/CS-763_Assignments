function [pointSet, pointImage] = ProcessMask( mask )
%ProcessMask generate point set data from mask
% Input arguments:
%   - mask - binary image with 1 for interior
%   - pointSet - N*2 points matrix
%   - pointImage - image depicting selected points

%% Get boundary points and a smooth smask

[smooth_mask, x, y] = GetBoundaryFromMask(mask);
N = length(x);

% %% Check point ordering
% color_list=jet(5);
% order_img = zeros(size(mask_img,1),size(mask_img,2),3);
% for i=1:N
%     num = mod(floor(i/50),5) + 1;
%     order_img(x(i),y(i),:) = color_list(num,:);
% end
% 
% figure()
% imshow(order_img)


%% Calculate surprisal map

surprisalmap = contourinfoplot(x,y,1,2);

idx = (y-1)*size(mask,1) + x;

baseVal = mean(surprisalmap)*1.05;




%%  find max in each 20 point interval
numBoundaryPoints = length(x);

numPoints = floor(length(x)/20); % one point selected out of every 20

count = 1;
pointSet = [];
noSelectCount = 0;

noSelectThres = 4;

for i=1:numPoints
    startIdx = (i-1)*20 + 1;
    [val,index] = max(surprisalmap(startIdx:startIdx+19));
    
    if val<baseVal
        % reject points if we have not rejected so many of them
        if noSelectCount<noSelectThres
            noSelectCount = noSelectCount+1;
            continue;
        end
    end
    pointSet = [pointSet;y(startIdx+index), x(startIdx+index)];
    noSelectCount = 0;
    count = count+1;
end


%% Generate image
maskImg = +mask;
pointImage = insertMarker(maskImg,pointSet,'o','Color','red');


end

