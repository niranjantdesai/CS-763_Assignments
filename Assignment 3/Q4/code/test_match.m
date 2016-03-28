% Testing 2 frames where 2nd frame is a x-shift of 1st frame

inp_video = mmread('../data/xOnly/input/cars.avi');

frame1 = rgb2gray(inp_video.frames(1).cdata);
frame2 = zeros(size(frame1));

[H,W] = size(frame1);

% x only transloation for frame 2
tx = 3;
ty = 0;

frame2(ty+1:H,tx+1:W) = frame1(1:H-ty,1:W-tx);

frame2_ = uint8(frame2);


match(frame1,frame2_);
[pts1,pts2] = stripped_match(frame1,frame2_); % x coordinate is along rows
diff = pts1-pts2;
motion = est_tonly_ls(pts1,pts2);


