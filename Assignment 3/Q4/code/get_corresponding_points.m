function corrPoints = get_corresponding_points(inpVideo,numFrames)
corrPoints = struct;

if numFrames==0 
    numFrames = inpVideo.nrFramesTotal;
end

for i=1:numFrames-1
    disp(i);
    % get matching point coordinates between 2 frames
    [pts1,pts2] = stripped_match(inpVideo.frames(i).cdata, ...
        inpVideo.frames(i+1).cdata);

    corrPoints(i).points1 = pts1;
    corrPoints(i).points2 = pts2;
end

