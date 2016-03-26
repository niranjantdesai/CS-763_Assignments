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

% Testing choose_learner
dist = (1/size(X_training,1))*ones(size(X_training,1),1); % Weight distribution; we give equal weights to all points initially
[ i_opt,p_opt,theta_opt ] = choose_learner( X_training,y_training,dist )
% h = -1*ones(size(X,1),1); % vector of labels assigned by the weak classifier
% theta = linspace(0,1,10);   % search range for theta
% p = [-1,1];     % search range for p
% error_curr = 1;
% error_min = 1;
% error = zeros(size
% 
% for i=1:size(X,2)
%    for j=1:size(theta)
%       for k=1:size(p)
%           h(p(k)*(X(:,i)-theta(j))>0) = 1;
%           idx = y~=h;
%           error_curr = w'.*idx;
%           if error_curr<error_min
%              error_min = error_curr;
%              i_opt = i;
%              p_opt = p(k);
%              theta_opt = theta(j);
%           end
%       end
%    end
% end