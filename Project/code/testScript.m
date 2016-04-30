% Align pointsets using the Iterated Closest Point and Robust Point
% Matching algorithms
% Authors: Ayush Baid, Jainesh Doshi, Niranjan Thakurdesa

clc;
clear;
close all;

%% Load ellipse pointset data
load('../data/ellipsePointsets.mat');
X = pointSets(:,:,1);
Y = pointSets(:,:,2);
figure()
title('Original pointsets');
hold on
scatter(X(1,:),X(2,:));
scatter(Y(1,:),Y(2,:));
hold off

%% Alignment using ICP
homX = vertcat(X,ones(1,size(X,2)));    % Pointset X expressed in terms of homogeneous coordinates
homY = vertcat(Y,ones(1,size(Y,2)));    % Pointset X expressed in terms of homogeneous coordinates
A_icp = icp(homY,homX);
alignedY_icp = A_icp*homY;
figure()
title('Pointsets aligned using ICP');
hold on
scatter(X(1,:),X(2,:));
scatter(alignedY_icp(1,:),alignedY_icp(2,:));
hold off

%% Alignment using RPM
[A_rpm,t] = rpm(X,Y);
alignedY_rpm = A_rpm*Y + repmat(t,1,size(Y,2));
figure()
title('Pointsets aligned using RPM');
hold on
scatter(X(1,:),X(2,:));
scatter(alignedY_rpm(1,:),alignedY_rpm(2,:));
hold off

%% Load fish pointset data
load('');

%% Compute mean shapes
initIndex = unidrnd(numSets,1);
mean = preshapePointSets(:,:,initIndex);
newMean = mean;

% params for iteration 
diffThreshold = 1e-6;
maxIters = 25;

iter = 1;
diff = 1e3;
while(diff>diffThreshold && iter<maxIters)
    mean = newMean;
    for i=1:numSets
        R = procrustes(mean,preshapePointSets(:,:,i));
        preshapePointSets(:,:,i) = R*preshapePointSets(:,:,i);
    end
    
    % Finding optimal mean shape within each iteration
    newMean = sum(preshapePointSets,3)/numSets;
    
    % normalizing mean to bring it into preshape space; centroid already at
    % origin
    l2_norm = sqrt(sumsqr(newMean));
    newMean = newMean./l2_norm;
    
    
    % calculate the difference between the means
    diff = sqrt(sumsqr(mean-newMean));
    % disp(diff);
    iter = iter+1;
end