clear;

a = mmread('../data/SampleVideos/cars.avi');
framerate = a.rate;
vid = zeros(a.height,a.width,a.nrFramesTotal);

for i=1:a.nrFramesTotal 
    b = rgb2gray(a.frames(i).cdata); 
    [H,W] = size(b);
    if i > 1, tx = round(rand(1)*3); else tx = 0; end;
    ty=0;

    d = b; d(:,:) = 0;
    d(ty+1:H,tx+1:W) = b(1:H-ty,1:W-tx);
        
    vid(:,:,i) = d;
end
  
filename = '../data/xOnly/input/cars.avi';
writevideo(filename,vid/max(vid(:)),framerate);
