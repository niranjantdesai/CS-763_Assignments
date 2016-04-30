function [ mse ] = getMse( X,alignedY )
%getMSE Calculates the mean squared error between the reference pointset and
%the aligned pointset by computing nearest neighbours and sum of squared
%differences of the corresponding points

numOfPoints = size(alignedY,2);
[idx,~] = knnsearch(X',alignedY');
Y = X(:,idx);
mse = sumsqr(Y-X)/numOfPoints;

end

