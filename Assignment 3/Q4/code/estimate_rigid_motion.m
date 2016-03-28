function motion = estimate_rigid_motion(corrPoints,N,centerX,centerY)
%estimate_rigid_motion Estimates the motion between each pair of consecutive
%frames (tx, ty, and theta)
% params:
%   corrPoints: coordinates of corresponding points as a struct
%   N: num of frames to analyse; (0 -> all frames)
%   centerX: center of the image along horizontal axis)
%   centerY: center of the image along horizontal axis
%frames
if N==0
    N = length(corrPoints);
end
motion = zeros(N,3); % each row(i) is a motion between ith frame and (i+1)th frame
% (ty, tx, theta)

for i=1:N
    points1 = corrPoints(i).points1;
    points2 = corrPoints(i).points2;
    
    % Shifting the origin to the image center
    points1(:,1) = points1(:,1)-centerX;
    points2(:,1) = points2(:,1)-centerX;
    points1(:,2) = points1(:,2)-centerY;
    points2(:,2) = points2(:,2)-centerY;
    
    [tx,ty,theta] = est_rigid_ls(points1,points2);
    motion(i,:) = [tx,ty,theta];
end

