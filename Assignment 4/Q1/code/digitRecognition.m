%digitRecognition Digit recognition using Adaboost

%% Reading the dataset

[I,labels,I_test,labels_test] = readMNIST;

%% Generating training and test set
sample_img = I_test{1};

vecSize = size(sample_img,1)*size(sample_img,2);

N = length(I_test);

% Label points
y = -1*ones(N,1);
y(labels_test==2)=1;

y_training = zeros(N/2,1);
y_test = zeros(N/2,1);


% Divide the dataset into training set and test set
seq = randperm(N);
X = zeros(N,vecSize);

for i=1:N
    sample_img = I_test{i};
    X(i,:) = sample_img(:);
end
X_training = zeros(N/2,vecSize);
X_test = zeros(N/2,vecSize);

for i=1:N/2
   X_training(i,:) = X(seq(i),:);
   y_training(i,:) = y(seq(i),:);
   X_test(i,:) = X(seq(N/2+i),:);
   y_test(i,:) = y(seq(N/2+i),:);
end

%% Performing adaboost

T = 40;

disp('****** Adaboost for MNIST dataset *****');

[ error_training,error_test,i_opt,p_opt,theta_opt,alpha ] = ...
    adaboost( X_training,X_test,T,y_training,y_test );

% get final classification
H = strong_classifier(X,i_opt,p_opt,theta_opt,alpha);

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
