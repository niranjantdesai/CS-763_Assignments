function [ t ] = est_tonly_ls( p1,p2 )
%est_tonly_ls Estimates the motion in case of translation only
%   Detailed explanation goes here

d = p2-p1;  % array storing the translation between corresponding points
t = mean(d,1);    % least squares estimate is the mean of the translations for the given set of points

end

