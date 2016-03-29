%digitRecognition Digit recognition using Adaboost

clc;
clear all;
close all;

%% Reading the dataset

[I,labels,I_test,labels_test] = readMNIST;

%% Generating training and test sets
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

%% Performing adaboost

T = 40;

disp('****** Adaboost for MNIST dataset *****');

[ error_training,error_test,i_opt,p_opt,theta_opt,alpha ] = ...
    adaboost( X_training,X_test,T,y_training,y_test );

% get final classification
H = strong_classifier(X_test,i_opt,p_opt,theta_opt,alpha);

%% Plotting

figure()
hold on;
plot(error_training);
plot(error_test);
hold off;
xlabel('iters');
ylabel('error');
legend('Training set error','Test set error');
title('Adaboost for MNIST');
