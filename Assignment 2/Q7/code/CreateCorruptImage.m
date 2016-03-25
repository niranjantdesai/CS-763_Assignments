function outImg = CreateCorruptImage( inpImg,rotationAngle,translation,addNoise)
%CreateCorruptImage rotates and transforms the input image; and then adds noise
% Inp image range in 0-1

imSize = size(inpImg);


sd = 10/255;

if addNoise
    % Noise addition
    % Note: Noise addition done beforhand so as to avoid adding noise in
    % the invalid regions of the transformed images
    inpImg = inpImg+sd*randn(imSize);
end

% Rotation
temp = imrotate(inpImg,rotationAngle,'nearest','crop');

% Translation
outImg = zeros(imSize);

lbound1 = max(1,1+translation);
ubound1 = min(imSize(2),imSize(2)+translation);

lbound2 = max(1,1-translation);
ubound2 = min(imSize(2),imSize(2)-translation);

outImg(:,lbound1:ubound1)=temp(:,lbound2:ubound2);

if addNoise

    % Clipping out of bound values
    outImg(outImg>1)=1;
    outImg(outImg<0)=0;
end


end

