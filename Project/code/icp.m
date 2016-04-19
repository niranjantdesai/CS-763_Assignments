% 18th April, 2016
% Authors: Ayush Baid, Niranjan Thakurdesai, Jainesh Doshi

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

% Initialization
P_iter = P;
A = eye(3);
i=0;    % Iteration count
threshold = 0.1;    % Threshold for mse; stop iterating when mse falls below this
maxIters = 25;
mse = NaN;

while (i<maxIters && mse>threshold)
    % Compute closest points
    [idx,~] = knnsearch(X',P_iter');
    Y = X(:,idx);
    
    % Compute the registration
    A = Y*P'*inv(P*P');
    
    % Apply the registration
    P_iter = A*P;
    
    % Compute mse
    mse = sumsqr(Y-P_iter)/Np;
    
    i = i+1;
end

end

