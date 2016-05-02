clc;
clear;
close all;

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


% ** Using RPM **

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
