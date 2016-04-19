% Reading data and converting to patches

tic

% NOTE: the code takes ~15 minutes to run


%% Init
inpImg = im2double(imresize(imread('../data/barbara256.png'),0.25));
temp = zeros(size(inpImg));

patchSize = 8;

x = im2col(inpImg,[patchSize patchSize],'sliding');

% generating phi matrix
n = 64;
phi = randn(n,n);

% 2D dct matrix
U = kron(dctmtx(8)' , dctmtx(8)');

% possible f values
f_array = [0.9, 0.8, 0.7, 0.6, 0.5, 0.4, 0.3, 0.2, 0.1, 0.05]';

L = length(f_array);

mspe_omp = zeros(L,1);
msie_omp = zeros(L,1);

mspe_pinv = zeros(L,1);
msie_pinv = zeros(L,1);

%% Calc
for i=1:L
   % Calculating y and A
   f = f_array(i);
   m = ceil(f*n);
   
   phi_m = phi(1:m,:);
   
   y = phi_m*x;
   noise_sd = 0.05*mean(mean((abs(y))));
   y = y + noise_sd*randn(size(y));
   
   A = phi_m*U;
   theta = zeros(size(x));
   
   cols = size(y,2);
   
   % Using OMP
   parfor j=1:cols
       [S,~] = PerformOMP(y(:,j),A);
       theta(:,j) = S;
   end
   x_est = U*theta;
   img_est = mexCombinePatches(x_est,temp,patchSize,1,1,1);
   
   mspe_omp(i) = sumsqr(x-x_est)/length(x_est);
   msie_omp(i) = sumsqr(inpImg - img_est)/length(inpImg);
   
   % Using pinv
   x_est = A\y;
   img_est = mexCombinePatches(x_est,temp,patchSize,1,1,1);
   
   mspe_pinv(i) = sumsqr(x-x_est)/length(x_est);
   msie_pinv(i) = sumsqr(inpImg - img_est)/length(inpImg);
   
end

%% Plotting
figure(1)
plot(f_array,mspe_omp);
title('Mean squared patch error (OMP)');

figure(2)
plot(f_array,msie_omp);
title('Mean squared image error (OMP)');

figure(3)
plot(f_array,mspe_pinv);
title('Mean squared patch error (PINV)');

figure(4)
plot(f_array,msie_pinv);
title('Mean squared image error (PINV)');

toc

% save('workspace.mat');

