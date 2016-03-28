function motion = est_rigid_robust(points1,points2)
%estimate_rigid_motion Estimates the motion between each pair of consecutive
%frames (tx, ty, and theta)
% params:
%   corrPoints: coordinates of corresponding points as a struct
%   N: num of frames to analyse; (0 -> all frames)
%frames

N = size(points1,1);

numIters = 50;
k = 5; % subset size
threshold = [3 3];

motion_estimate = zeros(N,3);

for i=1:numIters
    mask = ones(N,1);
    idx = unidrnd(N,k,1);
    mask(idx) = 0;
    estimate = est_rigid_ls(points1(idx,:),points2(idx,:));
    
    residual_error = points1(mask,:)*R+t



