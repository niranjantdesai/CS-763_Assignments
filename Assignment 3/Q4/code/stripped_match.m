function [points1,points2] = stripped_match(image1, image2)
% points1, points2 are 2d arrays such that each column is a x-y coordinate

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

numMatchingPoints = sum(idx > 0);
points1 = zeros(numMatchingPoints,2);
points2 = zeros(numMatchingPoints,2);


count=1;

% generating 2d arrays of corresponding point's pixel location
for i=1:length(idx)
    if idx(i)>0 
        points1(count,:) = loc1(i,1:2);
        points2(count,:) = loc2(idx(i),1:2);
        count = count+1;
    end
end
