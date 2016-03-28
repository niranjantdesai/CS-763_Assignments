function idx = match(image1, image2)

% Find SIFT keypoints for each image
[des1, loc1] = sift(image1);
[des2, loc2] = sift(image2);

% For efficiency in Matlab, it is cheaper to compute dot products between
%  unit vectors rather than Euclidean distances.  Note that the ratio of 
%  angles (acos of dot products of unit vectors) is a close approximation
%  to the ratio of Euclidean distances for small angles.
%
% distRatio: Only keep matches in which the ratio of vector angles from the
%   nearest to second nearest neighbor is less than distRatio.
distRatio = 0.6;   

% For each descriptor in the first image, select its match to second image.
des2t = des2';                          % Precompute matrix transpose
idx = zeros(size(des1,1),1);    % array storing the indices of the keypoints in the second image corresponding to those in the first image
for i = 1 : size(des1,1)
   dotprods = des1(i,:) * des2t;        % Computes vector of dot products
   [vals,indx] = sort(acos(dotprods));  % Take inverse cosine and sort results

   % Check if nearest neighbor has angle less than distRatio times 2nd.
   if (vals(1) < distRatio * vals(2))
      idx(i) = indx(1);
   end
end

% % Create a new image showing the two images side by side.
im3 = appendimages(image1,image2);
 
% Show a figure with lines joining the accepted matches.
figure('Position', [100 100 size(im3,2) size(im3,1)]);
colormap('gray');
imagesc(im3);
hold on;
cols1 = size(image1,2);
for i = 1: 60
%for i = 1: size(des1,1)
    if (idx(i) > 0)
         line([loc1(i,2) loc2(idx(i),2)+cols1], ...
         [loc1(i,1) loc2(idx(i),1)], 'Color', 'c');

    end
end
hold off;
num = sum(idx > 0);
fprintf('Found %d matches.\n', num);
