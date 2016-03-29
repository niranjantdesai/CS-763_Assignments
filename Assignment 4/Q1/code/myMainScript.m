% CS 763: Assignment 4
% 24th March, 2016
% Authors: Ayush Baid, Niranjan Thakurdesai, Jainesh Doshi

clc;
clear;
close all;


%% a] generating Dataset 1

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
scatter(X_test(y_test>0,1),X_test(y_test>0,2),'b*');
hold on;
scatter(X_test(y_test<0,1),X_test(y_test<0,2),'r+');
hold off
title('Test points in dataset 1');

%% a] Adaboost for Dataset 1
% close all;
T = 40;

disp('****** Adaboost for Dataset 1 *****');

[ error_training,error_test,i_opt,p_opt,theta_opt,alpha ] = ...
    adaboost( X_training,X_test,T,y_training,y_test );

% get final classification
H = strong_classifier(X_test,i_opt,p_opt,theta_opt,alpha);


%% a] Plotting for dataset 1
% Plotting the result
figure()
scatter(X_test(H>0,1),X_test(H>0,2),'b*');
hold on;
scatter(X_test(H<0,1),X_test(H<0,2),'r+');
hold off
title('Adaboost result for test points in dataset 1');


figure()
hold on;
plot(error_training);
plot(error_test);
hold off;
xlabel('iters');
ylabel('error');
legend('Training set error','Test set error');
title('Adaboost for Dataset 1');

%% b] Generating Dataset 2

N = 2000;   % Total number of points
X = rand(N,2);   % Each row of X corresponds to a point

% Label points
y = zeros(N,1);
y_training = zeros(N/2,1);
y_test = zeros(N/2,1);
for i=1:size(X,1)
   if X(i,1)>=0.3 && X(i,1)<=0.7 && X(i,2)>=0.3 && X(i,2)<=0.7
       y(i) = 1;    % Point lies inside the rectangle bounded by x=0.3, x=0.7, y=0.3 and y=0.7
   elseif (X(i,1)>0.15 && X(i,1)<0.25) || (X(i,1)>0.75 && X(i,1)<0.85)
       y(i) = 1;   
   elseif (X(i,2)>0.15 && X(i,2)<0.25) || (X(i,2)>0.75 && X(i,2)<0.85)
       y(i) = 1;
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
scatter(X_test(y_test>0,1),X_test(y_test>0,2),'b*');
hold on;
scatter(X_test(y_test<0,1),X_test(y_test<0,2),'r+');
hold off
title('Test points in dataset 2');

%% b] Adaboost for Dataset 2
% close all;
T = 40;

disp('****** Adaboost for Dataset 2 *****');

[ error_training,error_test,i_opt,p_opt,theta_opt,alpha ] = ...
    adaboost( X_training,X_test,T,y_training,y_test );

% get final classification
H = strong_classifier(X_test,i_opt,p_opt,theta_opt,alpha);


%% b] Plotting for dataset 2
% Plotting the result
figure()
scatter(X_test(H>0,1),X_test(H>0,2),'b*');
hold on;
scatter(X_test(H<0,1),X_test(H<0,2),'r+');
hold off
title('Adaboost result for test points in dataset 2');


figure()
hold on;
plot(error_training);
plot(error_test);
hold off;
xlabel('iters');
ylabel('error');
legend('Training set error','Test set error');
title('Adaboost for Dataset 3');

%% c] Generating Dataset 3

N = 2000;   % Total number of points
X = 2*randn(N,2);   % Each row of X corresponds to a point

dist = sqrt(sum(X.^2,2));

% Label points
y = -1*ones(N,1);
y_training = zeros(N/2,1);
y_test = zeros(N/2,1);

idx = dist<2;

y(idx) = 1;


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
scatter(X_test(y_test>0,1),X_test(y_test>0,2),'b*');
hold on;
scatter(X_test(y_test<0,1),X_test(y_test<0,2),'r+');
hold off
title('Test points in dataset 3');

%% c] Adaboost for Dataset 3
% close all;
T = 40;

disp('****** Adaboost for Dataset 3 *****');

[ error_training,error_test,i_opt,p_opt,theta_opt,alpha ] = ...
    adaboost( X_training,X_test,T,y_training,y_test );

% get final classification
H = strong_classifier(X_test,i_opt,p_opt,theta_opt,alpha);


%% c] Plotting for dataset 3
% Plotting the result
figure()
scatter(X_test(H>0,1),X_test(H>0,2),'b*');
hold on;
scatter(X_test(H<0,1),X_test(H<0,2),'r+');
hold off
title('Adaboost result for test points in dataset 3');


figure()
hold on;
plot(error_training);
plot(error_test);
hold off;
xlabel('iters');
ylabel('error');
legend('Training set error','Test set error');
title('Adaboost for Dataset 3');

%% d] Generating Dataset 4

N = 2000;   % Total number of points
X = 2*randn(N,2);   % Each row of X corresponds to a point

dist = sqrt(sum(X.^2,2));

% Label points
y = -1*ones(N,1);
y_training = zeros(N/2,1);
y_test = zeros(N/2,1);

idx = dist<2 | (dist>2.5 & dist<3);
y(idx) = 1;


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
scatter(X_test(y_test>0,1),X_test(y_test>0,2),'b*');
hold on;
scatter(X_test(y_test<0,1),X_test(y_test<0,2),'r+');
hold off
title('Test points in dataset 4');


%% d] Adaboost for Dataset 4
% close all;
T = 40;

disp('****** Adaboost for Dataset 4 *****');

[ error_training,error_test,i_opt,p_opt,theta_opt,alpha ] = ...
    adaboost( X_training,X_test,T,y_training,y_test );

% get final classification
H = strong_classifier(X_test,i_opt,p_opt,theta_opt,alpha);


%% d] Plotting for dataset 4
% Plotting the result
figure()
scatter(X_test(H>0,1),X_test(H>0,2),'b*');
hold on;
scatter(X_test(H<0,1),X_test(H<0,2),'r+');
hold off
title('Adaboost result for test points in dataset 4');


figure()
hold on;
plot(error_training);
plot(error_test);
hold off;
xlabel('iters');
ylabel('error');
legend('Training set error','Test set error');
title('Adaboost for Dataset 4');

% TODO: Do you notice something peculiar with the fourth dataset? Explain
% what you would you do to remedy that situation (there is no need to implement). 

%% e] Reading the MNIST database
[I,labels,I_test,labels_test] = readMNIST;

%% e] Generating training and test sets from the MNIST database
sample_img = I_test{1};
vecSize = size(sample_img,1)*size(sample_img,2);

N_test = length(I_test);    % Total number of test images
N_training = 5000;          % Total number of training images

% Label test points
y_test = -1*ones(N_test,1);
y_test(labels_test==2)=1;
% Label training points
y_training = -1*ones(N_training,1);
y_training(labels(1:N_training)==2)=1;

% Divide the dataset into training set and test set
X_training = zeros(N_training,vecSize);
X_test = zeros(N_test,vecSize);

for i=1:N_test
    sample_img = I_test{i};
    X_test(i,:) = sample_img(:)';
end
for i=1:N_training
    sample_img = I{i};
    X_training(i,:) = sample_img(:)';
end

%% e] Adaboost for MNIST database
T = 40;

disp('****** Adaboost for MNIST dataset *****');

[ error_training,error_test,i_opt,p_opt,theta_opt,alpha ] = ...
    adaboost( X_training,X_test,T,y_training,y_test );

% get final classification
H = strong_classifier(X_test,i_opt,p_opt,theta_opt,alpha);

%% e] Plotting for MNIST database
figure()
hold on;
plot(error_training);
plot(error_test);
hold off;
xlabel('iters');
ylabel('error');
legend('Training set error','Test set error');
title('Adaboost for MNIST');
