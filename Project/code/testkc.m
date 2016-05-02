clear all;
clc;
close all;

data = rand(30,2)*5; 
A = [.2*randn(1,6)+[1 0 0 1 0 0]]
% affine transformation
sample = TransformPoint(A,data); 

figure;
plot(data(:,1),data(:,2),'r+');
hold on;
plot(sample(:,1),sample(:,2),'bo');
title('Initial Condition');
drawnow;
axis equal;
hold off;

Estimated_A = KCPRegistration(data,sample,0.18)

Estimated_sample = TransformPoint(Estimated_A, data);

figure;
plot(data(:,1),data(:,2),'r+');
hold on;
plot(Estimated_sample(:,1),Estimated_sample(:,2),'bo');
title('Estimated matching');
drawnow;
axis equal;
hold off;
