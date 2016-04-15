function [ S,A_ ] = PerformOMP( y,A )
% Single column vector for y
    
% initializing for OMP
r = y;

eps = 1e-3;
index_selected = false(size(A,2),size(y,2));

iter=1;
while (sumsqr(r)>eps && sum(~index_selected)~=0)
    corr = abs(r'*A);
    norm_A = repmat(sum(A.^2),size(corr,1),1);
    
    corr = corr./norm_A;
    
    [maxVal,idx_A] = max(corr,[],2);
    if maxVal==0
        break;
    end
    
    index_selected(idx_A) = true;
    A_ = zeros(size(A));
    A_(:,index_selected) = A(:,index_selected);
    
    S = pinv(A_)*y;
    
    r = y-A_*S;
    iter=iter+1;
    residue = sumsqr(r);

end

