% 18th April, 2016
% Authors: Ayush Baid, Niranjan Thakurdesai, Jainesh Doshi
% Reference: Besl, Paul J., and Neil D. McKay. "Method for registration of 3-D shapes." Robotics-DL tentative. International Society for Optics and Photonics, 1992.

function [ A ] = icp( P,X )
%icp This function registers two point sets using the iterated closest
%point algorithm
%   @params:
%   Inputs:
%       P = Point set to be registered
%       X = Model shape
%   Output:
%       A = The estimated Affine transformation between the two point sets
% P and X may have a different number of points
% NOTE: Points should be represented in the form of homogeneous coordinates

Np = size(P,2);
Nx = size(X,2);

% ** Converting to homogenous coordinates**
if size(P,1)==2
    P = [P; ones(1,Np)];
end
if size(X,1)==2
    X = [X; ones(1,Nx)];
end

% Initialization
P_iter = P;
A = eye(3);
i=0;    % Iteration count
threshold = 1e-4;    % Threshold for mse; stop iterating when mse falls below this
maxIters = 25;
mse = 1e6;

while (i<maxIters && mse>threshold)
    % Compute closest points
    [idx,~] = knnsearch(X(1:2,:)',P_iter(1:2,:)');
    Y = X(:,idx);
    
    % Compute the registration
    A = (Y*P')/(P*P');
    
    % Apply the registration
    P_iter = A*P;
    
    % Compute mse
    mse = sumsqr(Y-P_iter)/Np;
    
    i = i+1;
end

end

