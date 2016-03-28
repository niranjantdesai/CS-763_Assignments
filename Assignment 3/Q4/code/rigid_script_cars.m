% Date: 14th March
clear;
clc;
inpVideo = mmread('../data/RigidOnly/input/cars.avi');

%% Finding corresponding points
% corrPoints = get_corresponding_points(inpVideo,0);
% save('../data/RigidOnly/corrPoints-cars.mat','corrPoints');

load('../data/RigidOnly/corrPoints-cars.mat');

%% Estimating motion
sampleFrame = inpVideo.frames(1).cdata;
estimated_motion = estimate_rigid_motion(corrPoints,0,size(sampleFrame,2)/2,size(sampleFrame,1)/2);

%% Motion smoothing

figure(1);
plot(estimated_motion(:,1));
title('ty estimated');
saveas(gcf,'../results/RigidOnly/ty-estimates-cars.png')

figure(2);
plot(estimated_motion(:,2));
title('tx estimated');
saveas(gcf,'../results/RigidOnly/tx-estimates-cars.png')

figure(3);
plot(estimated_motion(:,3));
title('theta estimated');
saveas(gcf,'../results/RigidOnly/theta-estimates-cars.png')


% smoothing out motion
smooth_motion = zeros(size(estimated_motion));

% length 4 averaging filter
a = 1;
b = ones(6,1)/6;

smooth_motion(:,1) = filter(b,a,estimated_motion(:,1));
smooth_motion(:,2) = filter(b,a,estimated_motion(:,2));
smooth_motion(:,3) = filter(b,a,estimated_motion(:,3));

figure(4);
plot(smooth_motion(:,1));
title('ty smooth');
saveas(gcf,'../results/RigidOnly/ty-smooth-cars.png')

figure(5);
plot(smooth_motion(:,2));
title('tx smooth');
saveas(gcf,'../results/RigidOnly/tx-smooth-cars.png')

figure(6);
plot(smooth_motion(:,3));
title('theta smooth');
saveas(gcf,'../results/RigidOnly/theta-smooth-cars.png')

%% Rewarping

filename = '../results/RigidOnly/cars.avi';

rewarp_rigid(estimated_motion,smooth_motion,inpVideo,0,filename);   

