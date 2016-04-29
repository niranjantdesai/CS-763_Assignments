% Align pointsets using the Iterated Closest Point and Robust Point
% Matching algorithms
% Authors: Ayush Baid, Jainesh Doshi, Niranjan Thakurdesa

clc;
clear;
close all;

%% Load data
load('../data/ellipsePointsets.mat');
X = pointSets(:,:,1);
Y = pointSets(:,:,2);
figure()
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
hold on
scatter(X(1,:),X(2,:));
scatter(alignedY_icp(1,:),alignedY_icp(2,:));
hold off

%% Alignment using RPM
[A_rpm,t] = rpm(X,Y);
alignedY_rpm = A_rpm*Y + repmat(t,1,size(Y,2));
figure()
hold on
scatter(X(1,:),X(2,:));
scatter(alignedY_rpm(1,:),alignedY_rpm(2,:));
hold off