% 18th April, 2016
% Authors: Ayush Baid, Niranjan Thakurdesai, Jainesh Doshi
% Reference: Gold, Steven, et al. "New algorithms for 2D and 3D point
% matching: Pose estimation and correspondence." Pattern recognition 31.8
% (1998): 1019-1031.

function [ A,t ] = rpm( X,Y )
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
betar = 1.075;
ep = 1e-1;
ep1 = 0.005;
ep2 = 0.05;
gamma0 = 40;
beta = beta0;
mHat = (1+ep)*ones(Nj+1,Nk+1);    
gamma = gamma0;
betaf = 0.2;
I0 = 4;
I1 = 30;
alpha = 0.03;
iters1 = 0;
iters2 = 0;
maxItersNewton = 25;    % Maximum number of iterations for Newton's method

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
        tmpX1 = repmat(X(1,:)',1,Nk) - t1;
        tmpX2 = repmat(X(2,:)',1,Nk) - t2;
        A = getA(a,b,c,theta);
        tmpY = A*Y;
        tmpY1 = repmat(tmpY(1,:),Nj,1);
        tmpY2 = repmat(tmpY(2,:),Nj,1);
        Q = -((tmpX1-tmpY1).^2 + (tmpX2-tmpY2).^2 - alpha);
        mHat(1:Nj,1:Nk) = exp(beta*Q);
        mInit = mHat;
        % Begin D
        while(sum(sum(abs(mInit(1:Nj,1:Nk)-mHat(1:Nj,1:Nk))))<ep2 && iters2<I1)
            sumMat = repmat(sum(mHat,2),1,Nk+1);
            mHat = mHat./sumMat;  % Normalize across all rows
            sumMat = repmat(sum(mHat,1),Nj+1,1);
            mHat = mHat./sumMat;  % Normalize across all columns
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
        tmp1 = repmat(X(1,:)',1,Nk);
        tmp2 = repmat(X(2,:)',1,Nk);
        A = getA(a,b,c,theta);
        tmpY = A*Y;
        tmpY1 = repmat(tmpY(1,:),Nj,1);
        tmpY2 = repmat(tmpY(2,:),Nj,1);
        num = sum(sum(mHat(1:Nj,1:Nk).*(tmp1-tmpY1)));
        denom = sum(sum(mHat(1:Nj,1:Nk)));
        t1 = num/denom;
        num = sum(sum(mHat(1:Nj,1:Nk).*(tmp2-tmpY2)));
        t2 = num/denom;
        
        % Update a, b and c using Newton's method
        tmpX1 = repmat(X(1,:)',1,Nk) - t1;
        tmpX2 = repmat(X(2,:)',1,Nk) - t2;
        
        % Update a
        itersNewton = 0;
        sc = [exp(a) 0; 0 exp(a)];    % Scaling matrix 1
        rot = [cos(theta) -sin(theta); sin(theta) cos(theta)];  % Rotation matrix
        sh1 = [exp(b) 0; 0 exp(-b)];    % Shear matrix 1
        sh2 = [cosh(c) sinh(c); sinh(c) cosh(c)];   % Shear matrix 2
        while (itersNewton < maxItersNewton)
            A = getA(a,b,c,theta);
            tmpY = A*Y;
            tmpY1 = repmat(tmpY(1,:),Nj,1);
            tmpY2 = repmat(tmpY(2,:),Nj,1);
            % Find the value of the first derivative of the objective function wrt a
            scDer1 = [exp(a) 0; 0 exp(a)]; % First derivative of the scaling matrix wrt a
            A_der1_a = scDer1*rot*sh1*sh2;    % First derivative of A wrt a
            tmpYDer1 = A_der1_a*Y;
            tmpYDer11 = repmat(tmpYDer1(1,:),Nj,1);
            tmpYDer12 = repmat(tmpYDer1(2,:),Nj,1);
            num = 2*sum(sum(mHat(1:Nj,1:Nk).*((tmpY1-tmpX1).*tmpYDer11 + (tmpY2-tmpX2).*tmpYDer12))) + 2*gamma*a;
            
            % Find the value of the second derivative of the objective
            % function wrt a
            scDer2 = [exp(a) 0; 0 exp(a)]; % Second derivative of the scaling matrix wrt a
            A_der2_a = scDer2*rot*sh1*sh2;    % Second derivative of A wrt a
            tmpYDer2 = A_der2_a*Y;
            tmpYDer21 = repmat(tmpYDer2(1,:),Nj,1);
            tmpYDer22 = repmat(tmpYDer2(2,:),Nj,1);
            denom = 2*sum(sum(mHat(1:Nj,1:Nk).*((tmpY1-tmpX1).*tmpYDer21 + (tmpYDer11-tmpX1).*tmpYDer11 + (tmpY2-tmpX2).*tmpYDer22 + (tmpYDer21-tmpX2).*tmpYDer21))) + 2*gamma;
            
            a = a - num/denom;
            itersNewton = itersNewton + 1;
        end
        
        % Update b
        itersNewton = 0;
        sc = [exp(a) 0; 0 exp(a)];    % Scaling matrix 1
        rot = [cos(theta) -sin(theta); sin(theta) cos(theta)];  % Rotation matrix
        sh1 = [exp(b) 0; 0 exp(-b)];    % Shear matrix 1
        sh2 = [cosh(c) sinh(c); sinh(c) cosh(c)];   % Shear matrix 2
        while (itersNewton < maxItersNewton)
            A = getA(a,b,c,theta);
            tmpY = A*Y;
            tmpY1 = repmat(tmpY(1,:),Nj,1);
            tmpY2 = repmat(tmpY(2,:),Nj,1);
            % Find the value of the first derivative of the objective
            % function wrt b
            sh1Der1 = [exp(b) 0; 0 -exp(b)]; % First derivative of the scaling matrix wrt a
            A_der1_b = sc*rot*sh1Der1*sh2;    % First derivative of A wrt b
            tmpYDer1 = A_der1_b*Y;
            tmpYDer11 = repmat(tmpYDer1(1,:),Nj,1);
            tmpYDer12 = repmat(tmpYDer1(2,:),Nj,1);
            num = 2*sum(sum(mHat(1:Nj,1:Nk).*((tmpY1-tmpX1).*tmpYDer11 + (tmpY2-tmpX2).*tmpYDer12))) + 2*gamma*b;
            
            % Find the value of the second derivative of the objective
            % function wrt b
            sh1Der2 = [exp(b) 0; 0 exp(b)]; % Second derivative of the scaling matrix wrt a
            A_der2_b = sc*rot*sh1Der2*sh2;    % Second derivative of A wrt b
            tmpYDer2 = A_der2_b*Y;
            tmpYDer21 = repmat(tmpYDer2(1,:),Nj,1);
            tmpYDer22 = repmat(tmpYDer2(2,:),Nj,1);
            denom = 2*sum(sum(mHat(1:Nj,1:Nk).*((tmpY1-tmpX1).*tmpYDer21 + (tmpYDer11-tmpX1).*tmpYDer11 + (tmpY2-tmpX2).*tmpYDer22 + (tmpYDer21-tmpX2).*tmpYDer21))) + 2*gamma;
            
            b = b - num/denom;
            itersNewton = itersNewton + 1;
        end
        
        % Update c
        itersNewton = 0;
        sc = [exp(a) 0; 0 exp(a)];    % Scaling matrix 1
        rot = [cos(theta) -sin(theta); sin(theta) cos(theta)];  % Rotation matrix
        sh1 = [exp(b) 0; 0 exp(-b)];    % Shear matrix 1
        sh2 = [cosh(c) sinh(c); sinh(c) cosh(c)];   % Shear matrix 2
        while (itersNewton < maxItersNewton)
            
            % Find the value of the first derivative of the objective
            % function wrt c
            sh2Der1 = [sinh(c) cosh(c); cosh(c) sinh(c)]; % First derivative of the scaling matrix wrt a
            A_der1_c = sc*rot*sh1*sh2Der1;    % First derivative of A wrt c
            tmpYDer1 = A_der1_c*Y;
            tmpYDer11 = repmat(tmpYDer1(1,:),Nj,1);
            tmpYDer12 = repmat(tmpYDer1(2,:),Nj,1);
            num = 2*sum(sum(mHat(1:Nj,1:Nk).*((tmpY1-tmpX1).*tmpYDer11 + (tmpY2-tmpX2).*tmpYDer12))) + 2*gamma*c;
            
            % Find the value of the second derivative of the objective
            % function wrt c
            sh2Der2 = [cosh(c) sinh(c); sinh(c) cosh(c)]; % Second derivative of the scaling matrix wrt a
            A_der2_c = sc*rot*sh1*sh2Der2;    % Second derivative of A wrt c
            tmpYDer2 = A_der2_c*Y;
            tmpYDer21 = repmat(tmpYDer2(1,:),Nj,1);
            tmpYDer22 = repmat(tmpYDer2(2,:),Nj,1);
            denom = 2*sum(sum(mHat(1:Nj,1:Nk).*((tmpY1-tmpX1).*tmpYDer21 + (tmpYDer11-tmpX1).*tmpYDer11 + (tmpY2-tmpX2).*tmpYDer22 + (tmpYDer21-tmpX2).*tmpYDer21))) + 2*gamma;
            
            c = c - num/denom;
            itersNewton = itersNewton + 1;
        end
        % End E
        
        iters1 = iters1+1;
    end
    % End B
    
    beta = betar*beta;
    gamma = gamma/betar;
    
%     A = getA(a,b,c,theta);
%     figure()
%     alignedY_rpm = A*Y;
%     figure()
%     hold on
%     scatter(X(1,:),X(2,:));
%     scatter(alignedY_rpm(1,:),alignedY_rpm(2,:));
%     hold off
end 
% End A

A = getA(a,b,c,theta);
t = [t1;t2];

end

