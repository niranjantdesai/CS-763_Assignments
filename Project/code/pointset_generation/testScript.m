% testing curve generating and curvature calculating

clc;
clear;
close all;


%% Processing for species 1

basePath = '../../data/manual/banded darter/';
resultPath = '../../data/pointset/banded darter/';
dirData = dir(basePath);
dirIndex = [dirData.isdir];
fileNames = {dirData(~dirIndex).name}'; % gets the list of all the files
    
L = size(fileNames,1);
dataSet1 = cell(L,1);
    
% looping over the image files
for i=1:1
   inpMask = imread(strcat(basePath,fileNames{i}));
   mask = inpMask(:,:,1)>0;
   
   [pointSet, pointSetImage] = ProcessMask( mask );
   pointSet = PreshapeConvert(pointSet);
   dataSet1{i} = pointSet;
end


imshow(pointSetImage);





    






