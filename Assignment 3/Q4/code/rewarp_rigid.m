function rewarp_rigid( rough_motion,smooth_motion,input,numFrames,filename )
%rewarp_t Rewarps frames of a shaky video to generate a more stable version
%of the video
%   Detailed explanation goes here

% calculate the required motion between consecutive frames
tx = 0;
ty = 0;
theta = 0;


if numFrames==0 
    numFrames = input.nrFramesTotal;
end
H = input.height;
W = input.width;
out_array = zeros(H,W*2,numFrames);

required_motion = zeros(numFrames,3);

for i=2:numFrames
    required_motion(i,:) = -rough_motion(i-1,:)+smooth_motion(i-1,:)+required_motion(i-1,:);
end

out_array(:,:,1) = appendimages(im2double(rgb2gray(input.frames(1).cdata)), ...
    im2double(rgb2gray(input.frames(1).cdata)));
for i=2:numFrames
    b = im2double(rgb2gray(input.frames(i).cdata));
    
    tx = round(required_motion(i,2));
    ty = round(required_motion(i,1));
    theta = required_motion(i,3); % as we have inverse notion of x and y axis
    c = imtranslate(b,[tx,ty],'FillValues',0);
    d = imrotate(c,theta,'bilinear','crop'); 
     
    out_array(:,:,i) = appendimages(b,d);
end

writevideo(filename,out_array,input.rate);

end

