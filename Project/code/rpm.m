% 18th April, 2016
% Authors: Ayush Baid, Niranjan Thakurdesai, Jainesh Doshi

function [ A ] = rpm( X,Y )
%rpm This function registers two point sets using robust point matching
%   @params:
%   Inputs:
%       Y = Point set to be registered
%       X = Model shape
%   Output:
%       A = The estimated Affine transformation between the two point sets
% P and X may have a different number of points

Nj = size(X,2);
Nk = size(Y,2);

% Initialization
theta = 0;
t1 = 0;
t2 = 0;
a = 0;
b = 0;
c = 0;
beta0 = 0.00091;
ep = 1e-5;
ep1 = 5e-3;
ep2 = 0.05;
gamma0 = 0.44;
beta = beta0;
mHat = (1+ep)*ones(Nj+1,Nk+1);    
gamma = gamma0;
betaf = 0.2;
I0 = 4;
I1 = 30;
alpha = 0.03;
iters1 = 0;
iters2 = 0;

% Begin A
while (beta<betaf)
    a0 = a;
    b0 = b;
    c0 = c;
    t10 = t1;
    t20 = t2;
    theta0 = theta;
    % Begin B
    while((abs(a0-a)+abs(b0-b)+abs(c0-c)+sqrt((t10-t1)^2+(t20-t2)^2)+abs(theta0-theta))<ep1 && iters1<I0)
        % Begin C (update correspondence parameters by softassign)
        t = [t1;t2];
        A = getA(a,b,c,theta);
        tmp11 = X(1,:)';
        tmp11 = repmat(tmp11,1,Nk);
        tmp12 = (A*Y)(1,:);
        tmp12 = repmat(tmp12,Nj,1);
        tmp1 = tmp11 - tmp12;
        tmp21 = X(2,:)';
        tmp21 = repmat(tmp21,1,Nk);
        tmp22 = (A*Y)(2,:);
        tmp22 = repmat(tmp22,Nj,1);
        tmp2 = tmp21 - tmp22;
        tmp1 = tmp1 - t1;
        tmp2 = tmp2 - t2;
        Q = -(tmp1.^2 + tmp2.^2 - alpha);
        mHat0 = mHat; 
        mHat0(1:Nj,1:Nk) = exp(beta*Q);
        % Begin D
        while(sum(sum(abs(mHat0(1:Nj,1:Nk)-mHat(1:Nj,1:Nk))))<ep2 && iters2<I1)
            sumMat = repmat(sum(mHat0,2),1,Nk+1);
            mHat1 = mHat0./sumMat;  % Normalize across all rows
            sumMat = repmat(sum(mHat0,1),Nj+1,1);
            mHat0 = mHat1./sumMat;  % Normalize across all columns
            mHat = mHat0;
            iters2 = iters2+1;
        end
        % End D
        % End C
        
        % Begin E (update pose parameters by coordinate descent)
        
        % Update theta using analytical solution
        tmp1 = repmat(X(1,:)',1,Nk) - t1;
        tmp2 = repmat(X(2,:)',1,Nk) - t2;
        W = getW(a,b,c);
        tmpW = W*Y;
        tmpW1 = repmat(tmpW(1,:),Nj,1);
        tmpW2 = repmat(tmpW(2,:),Nj,1);
        num = sum(sum(mHat(1:Nj,1:Nk).*(tmp2.*tmpW1 - tmp1.*tmpW2)));
        denom = sum(sum(mHat(1:Nj,1:Nk).*(tmp1.*tmpW1 - tmp2.*tmpW2)));
        theta = atan(num/denom);
        
        % Update t using analytical solution
        tmp1 = tmp1 + t1;
        tmp2 = tmp2 + t2;
        A = getA(a,b,c,theta);
        tmpY = A*Y;
        tmpY1 = repmat(tmpY(1,:),Nj,1);
        tmpY2 = repmat(tmpY(2,:),Nj,1);
        num = sum(sum(mHat(1:Nj,1:Nk).*(tmp1-tmpY1)));
        denom = sum(sum(mHat(1:Nj,1:Nk)));
        t1 = num/denom;
        num = sum(sum(mHat(1:Nj,1:Nk).*(tmp2-tmpY2)));
        t2 = num/denom;
        
        % Update a using Newton's method
        
        iters1 = iters1+1;
    end
end 
% End A
end

