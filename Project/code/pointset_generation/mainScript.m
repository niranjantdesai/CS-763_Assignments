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
dataSet = cell(L);
    
% looping over the image files
for i=1:L
   inpMask = imread(strcat(basePath,fileNames{i}));
   mask = inpMask(:,:,1)>0;
   
   [pointSet, pointSetImage] = ProcessMask( mask );
   
   dataSet{i} = pointSet;
   imwrite(pointSetImage,strcat(resultPath,num2str(i),'.png'));
   
end

save(strcat(resultPath,'dataset.mat'),'dataSet');


%% Processing for species 2

basePath = '../../data/manual/alewife/';
resultPath = '../../data/pointset/alewife/';
dirData = dir(basePath);
dirIndex = [dirData.isdir];
fileNames = {dirData(~dirIndex).name}'; % gets the list of all the files
    
L = size(fileNames,1);
dataSet = cell(L);
    
% looping over the image files
for i=1:L
   inpMask = imread(strcat(basePath,fileNames{i}));
   mask = inpMask(:,:,1)>0;
   
   [pointSet, pointSetImage] = ProcessMask( mask );
   
   dataSet{i} = pointSet;
   imwrite(pointSetImage,strcat(resultPath,num2str(i),'.png'));
   
end

save(strcat(resultPath,'dataset.mat'),'dataSet');


%% Processing for species 3

basePath = '../../data/manual/highfin carpsucker/';
resultPath = '../../data/pointset/highfin carpsucker/';
dirData = dir(basePath);
dirIndex = [dirData.isdir];
fileNames = {dirData(~dirIndex).name}'; % gets the list of all the files
    
L = size(fileNames,1);
dataSet = cell(L);
    
% looping over the image files
for i=1:L
   inpMask = imread(strcat(basePath,fileNames{i}));
   mask = inpMask(:,:,1)>0;
   
   [pointSet, pointSetImage] = ProcessMask( mask );
   
   dataSet{i} = pointSet;
   imwrite(pointSetImage,strcat(resultPath,num2str(i),'.png'));
   
end

save(strcat(resultPath,'dataset.mat'),'dataSet');




    






