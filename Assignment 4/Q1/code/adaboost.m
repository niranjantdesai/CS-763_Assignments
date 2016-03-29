function [ error_training_strong,error_test_strong,...
    i_opt,p_opt,theta_opt,alpha ] = adaboost( X_training,X_test,T,y_training,y_test )
%adaboost Implements the adaboost algorithm
%   @params:
%   X -> dataset
%   T -> Number of learning rounds
%   error_training_strong -> error on training set at each round
%   error_test_strong -> error on test set at each round
%
%   i_opt,p_opt,theta_opt -> params for each weak classifier

% Weight distribution; we give equal weights to all points initially
dist = (1/size(X_training,1))*ones(size(X_training,1),1);
% Array which stores the weight of each classifier
alpha = zeros(T,1);     


% Training and test error of the strong classifier at each iteration
error_training_strong = NaN(size(X_test,1),1);
error_test_strong = NaN(size(X_test,1),1);

% Sum of weak learners
sum_cfs_training = zeros(size(X_training,1),1);
sum_cfs_test = zeros(size(X_test,1),1);
i_opt = zeros(T,1);
p_opt = zeros(T,1);
theta_opt = zeros(T,1);

% Labels given to the training set by weak learners
h_training = -1*ones(size(X_training,1),T);
% Labels given to the training set by weak learners
h_test = -1*ones(size(X_test,1),T);

for i=1:T
    
    % Train a learner from the dataset using distribution dist 
    [ i_opt(i),p_opt(i),theta_opt(i),error_training,h_training(:,i) ] = ...
        choose_learner( X_training,y_training,dist );
    % Weight of the current classifier
    alpha(i) = 1/2*log((1-error_training)/error_training);    
    
    % Updating the distribution
    dist = dist.*exp(-alpha(i)*(y_training.*h_training(:,i)));
    dist = dist/sum(dist);   % Update the distribution
    
    
    % Updating strong classifier output 
    sum_cfs_training = sum_cfs_training + alpha(i)*h_training(:,i); 
    h_test(p_opt(i)*(X_test(:,i_opt(i))-theta_opt(i))>0,i) = 1;
    sum_cfs_test = sum_cfs_test + alpha(i)*h_test(:,i);
    
    % Output labels given to the training set by the strong classifier
    H_training = -1*ones(size(X_training,1),1);
    % Output labels given to the test set by the strong classifier
    H_test = -1*ones(size(X_test,1),1);

    H_training(sum_cfs_training>0) = 1;
    H_test(sum_cfs_test>0) = 1;
    
    % Calculating error in training and test
    error_training_strong(i) = sum(y_training~=H_training)/size(y_training,1);  % Training error of the strong classifier
    error_test_strong(i) = sum(y_test~=H_test)/size(y_test,1);      % Error of the strong classifier on the test set
    fprintf('Training error of the strong classifier = %f \n',error_training_strong(i));
    fprintf('Error of the strong classifier on the test set = %f \n\n',error_test_strong(i));
    
%     % Plot test points for current weak classifier
%     figure(i)
%     scatter(X_test(h_test(:,i)>0,1),X_test(h_test(:,i)>0,2),'b*');
%     hold on
%     scatter(X_test(h_test(:,i)<0,1),X_test(h_test(:,i)<0,2),'r+');
%     hold off
%     str = sprintf('Test points with their associated labels at round %d',i);
%     title(str);

%     % Plot test points for strong classifier
%     figure(i)
%     scatter(X_test(H_test>0,1),X_test(H_test>0,2),'b*');
%     hold on
%     scatter(X_test(H_test<0,1),X_test(H_test<0,2),'r+');
%     hold off
%     str = sprintf('Test points with their associated labels at round %d',i);
%     title(str);
end



end

