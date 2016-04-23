function [smooth_mask, sorted_idx_x, sorted_idx_y] = GetBoundaryFromMask( mask_img )
%UNTITLED3 Get curvature of the boundary from the mask
% Input arguments:
%   mask_img (1-inside, 0-outside)
% Output arguments:
%   mask_d2: curvature values at the boundary; zero elsewhere
%   idx: index of the boundary points

% ** Getting the boundary
se = strel('disk',1);        
erodedBW = imerode(mask_img,se);
diff = mask_img - erodedBW;

% figure();
% imshow(diff);
% title('Boundary');


% ** generating signed distance transform (inside is negative) **
distance = bwdist(diff);
distance(mask_img) = -distance(mask_img);

% ** smoothing the distance transform **
smooth_distance = imgaussfilt(distance,1);

% figure();
% subplot(121);
% imagesc(distance);
% title('Distance');
% subplot(122);
% imagesc(smooth_distance);
% title('Smoothed Distance');

% ** regenerating the mask **
smooth_mask = smooth_distance<=0;
% figure();
% imshow(smooth_mask);
% title('Smoothed mask');

erodedBW = imerode(smooth_mask,se);
smooth_diff = smooth_mask - erodedBW;

% ** Getting points on the boundary in a clockwise order
[idx_x, idx_y] = find(smooth_diff);
idx = (idx_y-1)*size(mask_img,1) + idx_x;
N = length(idx);

% ** Sorting the points in order **
sorted_idx_x = zeros(N,1);
sorted_idx_y = zeros(N,1);

% ** Variables declaration for ordering points **
not_selected = false(size(mask_img)); % matrix indicating if an index has been selected
not_selected(idx) = true;

search_matrix = false(3,3); % true indicates valid for search
neighbor_submat = false(3,3); % values of immediate neighborhood
final_submatrix = false(3,3); % the final matrix to search for 1s

% selecting a random seed for the first point
seed = unidrnd(N,1);
sorted_idx_x(1) = idx_x(seed);
sorted_idx_y(1) = idx_y(seed);

next_x = idx_x(seed);
next_y = idx_y(seed);

not_selected(sorted_idx_x(1), sorted_idx_y(1)) = false;



% 2nd point to the left/bottom of the 1st point in the immediate neighborhood
prev_x = next_x;
prev_y = next_y;
search_matrix(:,1) = true;
search_matrix(3,2) = true;

neighbor_submat = not_selected(prev_x-1:prev_x+1, prev_y-1:prev_y+1);
final_submatrix = search_matrix.*neighbor_submat;

[pos_x, pos_y] = find(final_submatrix, 1);
next_x = prev_x + pos_x - 2;
next_y = prev_y + pos_y - 2;
sorted_idx_x(2) = next_x;
sorted_idx_y(2) = next_y;
not_selected(next_x, next_y) = false;

prev_x = next_x;
prev_y = next_y;

% defining a search matrix for a 4-neighborhood
search_matrix = false(3,3);
search_matrix(1,2) = true;
search_matrix(2,1) = true;
search_matrix(2,3) = true;
search_matrix(3,2) = true;

for i=3:N
    neighbor_submat = not_selected(prev_x-1:prev_x+1, prev_y-1:prev_y+1);
    if(sum(sum(neighbor_submat))>1)
        % pick only from the 4-neighborhood
        neighbor_submat = search_matrix.*neighbor_submat;
        if(sum(sum(neighbor_submat))>1)
            disp('>1 available');
            disp(i);
        end
    end
    final_submatrix = neighbor_submat;
    
    [pos_x, pos_y] = find(final_submatrix);
    next_x = prev_x + pos_x - 2;
    next_y = prev_y + pos_y - 2;
    sorted_idx_x(i) = next_x;
    sorted_idx_y(i) = next_y;
    not_selected(next_x, next_y) = false;

    prev_x = next_x;
    prev_y = next_y;

end

end
