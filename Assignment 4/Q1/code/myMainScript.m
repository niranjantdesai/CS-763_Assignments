% CS 763: Assignment 4
% 24th March, 2016
% Authors: Ayush Baid, Niranjan Thakurdesai, Jainesh Doshi

clc;
clear all;
close all;

%% a] Dataset 1

% Generate dataset
N = 2000;   % Total number of points
X = rand(N,2);   % Each row of X corresponds to a point

% Label points
y = zeros(N,1);
y_training = zeros(N/2,1);
y_test = zeros(N/2,1);
for i=1:size(X,1)
   if X(i,1)>=0.3 && X(i,1)<=0.7 && X(i,2)>=0.3 && X(i,2)<=0.7
       y(i) = 1;    % Point lies inside the rectangle bounded by x=0.3, x=0.7, y=0.3 and y=0.7
   else
       y(i) = -1;
   end
end

% Divide the dataset into training set and test set
seq = randperm(N);
X_training = zeros(N/2,2);
X_test = zeros(N/2,2);
for i=1:N/2
   X_training(i,:) = X(seq(i),:);
   y_training(i,:) = y(seq(i),:);
   X_test(i,:) = X(seq(N/2+i),:);
   y_test(i,:) = y(seq(N/2+i),:);
end

% Plotting the dataset
figure()
scatter(X(y>0,1),X(y>0,2),'o');
hold on;
scatter(X(y<0,1),X(y<0,2),'+');
hold off

% Adaboost
T = 35;
[ H_training,H_test,i_opt,p_opt,theta_opt ] = adaboost( X_training,X_test,T,y_training,y_test );