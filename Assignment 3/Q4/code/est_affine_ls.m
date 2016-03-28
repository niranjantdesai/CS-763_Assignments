function [ A ] = est_affine_ls( p1,p2 )
%est_affine_ls Estimates Affine motion between 2 frames
%   Detailed explanation goes here

A = p2*p1'*inv(p1*p1');

end

