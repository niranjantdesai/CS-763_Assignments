function rewarp_t( rough_t,smooth_t,in,numFrames,filename )
%rewarp_t Rewarps frames of a shaky video to generate a more stable version
%of the video
%   Detailed explanation goes here

% calculate the required motion between consecutive frames
tx = 0;
ty = 0;


if numFrames==0 
    numFrames = in.nrFramesTotal;
end
H = in.height;
W = in.width;
out_array = zeros(H,W*2,numFrames);

required_t = zeros(numFrames-1,2);

for i=2:numFrames-1
    required_t(i,:) = -rough_t(i-1,:)+smooth_t(i-1,:)+required_t(i-1,:);
end

out_array(:,:,1) = appendimages(im2double(rgb2gray(in.frames(1).cdata)), ...
    im2double(rgb2gray(in.frames(1).cdata)));
for i=2:numFrames-1
    b = im2double(rgb2gray(in.frames(i).cdata));
    
    tx = round(required_t(i,2));
    ty = round(required_t(i,1));
    
    d = imtranslate(b,[tx,ty],'FillValues',0);
    out_array(:,:,i) = appendimages(b,d);
end

writevideo(filename,out_array,in.rate);

end

