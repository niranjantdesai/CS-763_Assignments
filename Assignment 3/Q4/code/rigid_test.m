% Date: 14th March
clear;
clc;
% inpVideo = mmread('../data/RigidOnly/input/coastguard.avi');
% 
% b = rgb2gray(inpVideo.frames(1).cdata);
% 
% [H,W] = size(b);
% tx=0;
% ty=0;
% theta=30;
% c = imrotate(b,theta,'bilinear','crop');    
% d = c; d(:,:) = 0;
% d(ty+1:H,tx+1:W) = c(1:H-ty,1:W-tx);
%  
% [pts1,pts2] = stripped_match(b,d);
% [tx,ty,theta] = est_rigid_ls(pts1,pts2);
% 
% 
% 
% c = imtranslate(d,[-tx,-ty],'FillValues',0);
% b_ = imrotate(c,-theta,'bilinear','crop');  


pts1 = [50 70; 100 30; 20 30; 33 45; 55 71; 68 93; 15 19];
theta = 5*pi/180;
R = [cos(theta) -sin(theta); sin(theta), cos(theta)];

for i=1:size(pts1,1)
    pts2(i,:) = (pts1(i,:)*R) + [5 -3];
end
[tx,ty,theta] = est_rigid_ls(pts1,pts2);




