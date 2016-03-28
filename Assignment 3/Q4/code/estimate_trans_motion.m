function motion = estimate_trans_motion(corrPoints,N)
%estimate_trans_motion Estimates the motion between each pair of consecutive
% params:
%   corrPoints: coordinates of corresponding points as a struct
%   N: num of frames to analyse; (0 -> all frames)
%frames
if N==0
    N = length(corrPoints);
end
motion = zeros(N,2); % each row(i) is a motion between ith frame and (i+1)th frame

for i=1:N
    points1 = corrPoints(i).points1;
    points2 = corrPoints(i).points2;
    
    motion(i,:) = est_tonly_ls(points1,points2);
end

