function H = strong_classifier( X,i,p,theta,alpha )
%strong_classifier performs the classification using the weak

T = length(i);

H = -1*ones(size(X,1),1);
sum = zeros(size(X,1),1);


for j=1:T
    weak_classification = -1*ones(size(X,1),1);
    weak_classification(p(j)*(X(:,i(j))-theta(j))>0) = 1;
    sum = sum+alpha(j).*weak_classification;

end

H(sum>0)=1;

