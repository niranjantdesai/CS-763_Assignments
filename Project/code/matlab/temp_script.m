% testing curve generating and curvature calculating

clc;
clear;
close all;

%% Get boundary
temp_img = imread('../../data/manual/banded darter/1_mask.png');
mask_img = temp_img(:,:,1)>0;

[smooth_mask, x, y] = GetBoundaryFromMask(mask_img);
N = length(x);

%% Check point ordering
color_list=jet(5);
order_img = zeros(size(mask_img,1),size(mask_img,2),3);
for i=1:N
    num = mod(floor(i/50),5) + 1;
    order_img(x(i),y(i),:) = color_list(num,:);
end

figure()
imshow(order_img)


%% Calculate surprisal map

surprisalmap = contourinfoplot(x,y,1,2);


idx = (y-1)*size(mask_img,1) + x;

baseVal = min(min(surprisalmap));

curvature_img = ones(size(mask_img))*baseVal;
curvature_img(idx) = surprisalmap;




%%  find max in each 20 point interval
max_x = [];
max_y = [];
for i=1:20:length(idx)-20;
    [~,index] = max(surprisalmap(i:i+19));
    max_x = [max_x; y(i+index)];
    max_y = [max_y; x(i+index)];
end
max_y = size(mask_img,1) - max_y;
    
%% Plots
figure();
hold on;
imagesc(curvature_img);
colorbar;
hold off;

figure();
hold on;
imshow(mask_img);
scatter(max_x,max_y);
hold off;





