function [ H_training,H_test,i_opt,p_opt,theta_opt ] = adaboost( X_training,X_test,T,y_training,y_test )
%adaboost Implements the adaboost algorithm
%   @params:
%   X -> dataset
%   T -> Number of learning rounds

dist = (1/size(X_training,1))*ones(size(X_training,1),1); % Weight distribution; we give equal weights to all points initially
alpha = zeros(T,1);     % Array which stores the weight of each classifier
h_training = -1*ones(size(X_training,1),T);     % Labels given to the training set by weak learners
h_test = -1*ones(size(X_test,1),T);     % Labels given to the training set by weak learners
sum_cfs_training = zeros(size(X_training,1),1);
sum_cfs_test = zeros(size(X_test,1),1);
i_opt = zeros(T,1);
p_opt = zeros(T,1);
theta_opt = zeros(T,1);

for i=1:T
    H_training = -1*ones(size(X_training,1),1);  % Output labels given to the training set by the strong classifier
    H_test = -1*ones(size(X_test,1),1);  % Output labels given to the training set by the strong classifier
   [ i_opt(i),p_opt(i),theta_opt(i),error_training,h_training(:,i) ] = choose_learner( X_training,y_training,dist );    % Train a learner from the dataset using distribution dist 
   alpha(i) = 1/2*log((1-error_training)/error_training);    % Weight of the current classifier
   dist = dist.*exp(-alpha(i)*(y_training.*h_training(:,i)));
   dist = dist/sum(dist);   % Update the distribution
   sum_cfs_training = sum_cfs_training + alpha(i)*h_training(:,i); 
   h_test(p_opt(i)*(X_test(:,i_opt(i))-theta_opt(i))>0,i) = 1;
   sum_cfs_test = sum_cfs_test + alpha(i)*h_test(:,i);
   H_training(sum_cfs_training>0) = 1;
   H_test(sum_cfs_test>0) = 1;
   error_training_strong = sum(y_training~=H_training)/size(y_training,1);  % Training error of the strong classifier
   error_test_strong = sum(y_test~=H_test)/size(y_test,1);      % Error of the strong classifier on the test set
   fprintf('Training error of the strong classifier = %f \n',error_training_strong);
   fprintf('Error of the strong classifier on the test set = %f \n\n',error_test_strong);
   
   % Plot test points
   figure()
   scatter(X_test(H_test>0,1),X_test(H_test>0,2),'o');
   hold on
   scatter(X_test(H_test<0,1),X_test(H_test<0,2),'+');
   hold off
   str = sprintf('Test points with their associated labels after round %d',i);
   title(str);
end


end

