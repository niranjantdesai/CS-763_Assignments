% Date: 14th March
clear;
clc;
inpVideo = mmread('../data/RigidOnly/input/coastguard.avi');

%% Finding corresponding points
% corrPoints = get_corresponding_points(inpVideo,0);
% save('../data/RigidOnly/corrPoints-coastguard.mat','corrPoints');

load('../data/RigidOnly/corrPoints-coastguard.mat');

%% Estimating motion
sampleFrame = inpVideo.frames(1).cdata;
estimated_motion = estimate_rigid_motion(corrPoints,0,size(sampleFrame,2)/2,size(sampleFrame,1)/2);

%% Motion smoothing

figure(1);
plot(estimated_motion(:,1));
title('ty estimated');
saveas(gcf,'../results/RigidOnly/ty-estimates-coastguard.png')

figure(2);
plot(estimated_motion(:,2));
title('tx estimated');
saveas(gcf,'../results/RigidOnly/tx-estimates-coastguard.png')

figure(3);
plot(estimated_motion(:,3));
title('theta estimated');
saveas(gcf,'../results/RigidOnly/theta-estimates-coastguard.png')


% smoothing out motion
smooth_motion = zeros(size(estimated_motion));

% averaging filter
a = 1;
b = ones(4,1)/4;

smooth_motion(:,1) = conv(estimated_motion(:,1),b,'same');
smooth_motion(:,2) = conv(estimated_motion(:,2),b,'same');
smooth_motion(:,3) = conv(estimated_motion(:,3),b,'same');

figure(4);
plot(smooth_motion(:,1));
title('ty smooth');
saveas(gcf,'../results/RigidOnly/ty-smooth-coastguard.png')

figure(5);
plot(smooth_motion(:,2));
title('tx smooth');
saveas(gcf,'../results/RigidOnly/tx-smooth-coastguard.png')

figure(6);
plot(smooth_motion(:,3));
title('theta smooth');
saveas(gcf,'../results/RigidOnly/theta-smooth-coastguard.png')

%% Rewarping

filename = '../results/RigidOnly/coastguard.avi';

rewarp_rigid(estimated_motion,smooth_motion,inpVideo,0,filename);   

