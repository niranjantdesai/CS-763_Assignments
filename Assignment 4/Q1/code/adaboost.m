function [ decision ] = adaboost( X_training,X_test,T,y )
%adaboost Implements the adaboost algorithm
%   @params:
%   X -> dataset
%   T -> Number of learning rounds

dist = (1/size(X,1))*ones(size(X_training,1),1); % Weight distribution; we give equal weights to all points initially
alpha = zeros(T,1);     % Array which stores the weight of each classifier
h_training = zeros(size(X_training,1),T);     % Labels given to the training set by weak learners
h_test = -1*ones(size(X_test,1),T);     % Labels given to the training set by weak learners
H_training = zeros(size(X_training,1),1);  % Output labels given to the training set by the strong classifier
H_test = zeros(size(X_test,1),1);  % Output labels given to the training set by the strong classifier
sum_cfs_training = zeros(size(X_training,1),1);
sum_cfs_test = zeros(size(X_test,1),1);

for i=1:T
   [ i_opt,p_opt,theta_opt,error_training,h_training(:,i) ] = choose_learner( X_training,y,dist );    % Train a learner from the dataset using distribution dist 
   alpha(i) = 1/2*log((1-error_training)/error_training);    % Weight of the current classifier
   dist = dist*exp(-alpha*(y.*h_training(:,i)));
   dist = dist/sum(dist);   % Update the distribution
   sum_cfs_training = sum_cfs_training + alpha(i)*h_training(:,i); 
   h_test(p_opt*(X_test(:,i_opt)-theta_opt)>0,i) = 1;
   sum_cfs_test = sum_cfs_test + alpha(i)*h_test(:,i);
   H_training(sum_cfs_training>0) = 1;
   H_test(sum_cfs_test>0) = 1;
end


end

