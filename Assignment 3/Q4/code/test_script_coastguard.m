% Date: 14th March
clear;
clc;
inpVideo = mmread('../data/TranslationOnly/input/coastguard.avi');

%% Finding corresponding points
corrPoints = get_corresponding_points(inpVideo,0);
save('../data/TranslationOnly/corrPoints-coastguard.mat','corrPoints');

% load('../data/TranslationOnly/corrPoints-coastguard.mat');

%% Estimating motion
estimated_motion = estimate_trans_motion(corrPoints,0);

%% Motion smoothing

figure(1);
plot(estimated_motion(:,1));
title('ty estimated');
saveas(gcf,'../results/TranslationOnly/ty-estimates-coastguard.png')

figure(2);
plot(estimated_motion(:,2));
title('tx estimated');
saveas(gcf,'../results/TranslationOnly/tx-estimates-coastguard.png')


% smoothing out motion
smooth_motion = zeros(size(estimated_motion));

% length 4 averaging filter
a = 1;
b = ones(4,1)/4;

smooth_motion(:,1) = filter(b,a,estimated_motion(:,1));
smooth_motion(:,2) = filter(b,a,estimated_motion(:,2));

figure(3);
plot(smooth_motion(:,1));
title('ty smooth');
saveas(gcf,'../results/TranslationOnly/ty-smooth-coastguard.png')

figure(4);
plot(smooth_motion(:,2));
title('tx smooth');
saveas(gcf,'../results/TranslationOnly/tx-smooth-coastguard.png')

%% Rewarping

filename = '../results/TranslationOnly/coastguard.avi';

rewarp_t(estimated_motion,smooth_motion,inpVideo,0,filename);   

