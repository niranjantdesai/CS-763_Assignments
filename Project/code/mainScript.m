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
load('../data/pointset/alewife/dataset_.mat'); % #1
load('../data/pointset/banded darter/dataset_.mat'); % #2
load('../data/pointset/highfin carpsucker/dataset_.mat'); % #3



%% Representative points

% ** Note: we use a pointset for each species as representative
% Pointset with moderate number of points is chosen

repIdx1 = 2;
repIdx2 = 4;
repIdx3 = 2;

repSet1 = dataSet1{repIdx1};
repSet2 = dataSet2{repIdx2};
repSet3 = dataSet3{repIdx3};

% ** Using ICP **

%% Species 1 with rep1
L = length(dataSet1);
recog1 = zeros(L,1);
for i=1:L
    if i==repIdx1
        continue
    end
    X = dataSet1{i};
    if size(X,2)==2
        X = [X, ones(size(X,1),1)];
    end
    A = icp(X',repSet1');
    
    alignedpointSet = (A*X').';
    
    figure();
    hold on;
    scatter(X(:,1),X(:,2));
    scatter(repSet1(:,1), repSet1(:,2));
    scatter(alignedpointSet(:,1), alignedpointSet(:,2));

    hold off;
    legend('original pts', 'rep #1 pts', 'aligned pts');
end

%% Species 2 with rep1
L = length(dataSet2);
recog2 = zeros(2,1);
for i=1:L
    if i==repIdx1
        continue
    end
    X = dataSet2{i};
    if size(X,2)==2
        X = [X, ones(size(X,1),1)];
    end
    A = icp(X',repSet1');
    
    alignedpointSet = (A*X').';
    
    figure();
    hold on;
    scatter(X(:,1),X(:,2));
    scatter(repSet1(:,1), repSet1(:,2));
    scatter(alignedpointSet(:,1), alignedpointSet(:,2));

    hold off;
    legend('original pts', 'rep #1 pts', 'aligned pts');
end



% ** Using RPM **

%% Species 1 with rep 1
L = length(dataSet1);
recog1 = zeros(L,1);
for i=1:L
    if i==repIdx1
        continue
    end
    X = dataSet1{i};
    
    [A,t] = rpm(X',repSet1');
    
    alignedpointSet = (A*X' + repmat(t,1,size(X,1))).';
    
    figure();
    hold on;
    scatter(X(:,1),X(:,2));
    scatter(repSet1(:,1), repSet1(:,2));
    scatter(alignedpointSet(:,1), alignedpointSet(:,2));
    hold off;
    legend('original pts', 'rep #1 pts', 'aligned pts');
end

%% Species 2 with rep 1
L = length(dataSet2);
recog1 = zeros(L,1);
for i=1:L
    if i==repIdx1
        continue
    end
    X = dataSet2{i};
    
    [A,t] = rpm(X',repSet1');
    
    alignedpointSet = (A*X' + repmat(t,1,size(X,1))).';
    
    figure();
    hold on;
    scatter(X(:,1),X(:,2));
    scatter(repSet1(:,1), repSet1(:,2));
    scatter(alignedpointSet(:,1), alignedpointSet(:,2));
    hold off;
    legend('original pts', 'rep #1 pts', 'aligned pts');
end
