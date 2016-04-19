img = im2double(imread('../../data/temp/1.jpg'));

% getting the stats for the background
windowX = floor(min(50,size(img,1)/8));
windowY = floor(min(50,size(img,2)/8));

color_mask = false(size(img));
color_mask(1:windowX,1:windowY,:) = 1;
color_mask(1:windowX,end-windowY:end,:) = 1;
color_mask(end-windowX:end,1:windowY,:) = 1;
color_mask(end-windowX:end,end-windowY:end,:) = 1;

mask = color_mask(:,:,1);
numMask = sum(sum(mask));

imR = img(:,:,1);
imG = img(:,:,2);
imB = img(:,:,3);

bg = [imR(mask), imG(mask), imB(mask)];

% getting the mean color of the background using the window
mean = squeeze(sum(bg))/(numMask);
variance = squeeze(sum(bg.^2))/(numMask) - mean.^2;

% Evaluating mask using a guassian pdf
W = exp(-((imR-mean(1)).^2)/(2*variance(1))).*...
    exp(-((imG-mean(2)).^2)/(2*variance(2))).*exp(-((imB-mean(3)).^2)/(2*variance(3)));
W = W/sqrt(8*(pi^3)*variance(1)*variance(2)*variance(3));

W = 1-W;
W(mask) = 0;
thresh = 0.3;

BW = imsegfmm(W,mask,thresh);
imshow(BW);


