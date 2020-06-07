clear all;
close all;
clc;
%% NSST tool box
addpath(genpath(cd));
% addpath(genpath('NSST'));
% addpath(genpath('DTNP_toolbox'));
% addpath(genpath('morvanli_evaluation'));
%%
[imagename1, imagepath1]=uigetfile('IV_images\*.jpg;*.bmp;*.png;*.tif;*.tiff;*.pgm;*.gif','Please choose the first input image');
image1=imread(strcat(imagepath1,imagename1));
[imagename2,imagepath2]=uigetfile('IV_images\*.jpg;*.bmp;*.png;*.tif;*.tiff;*.pgm;*.gif','Please choose the first input image'); 
image2=imread(strcat(imagepath2,imagename2));
if size(image1,3)>1
    image1 = rgb2gray(image1);
    image2 = rgb2gray(image2);
end
A=double(image1)/255;
B=double(image2)/255;
tic
imgf=fuse_NSST_DTNP(A,B); 
toc
F=uint8(imgf*255);
figure,imshow(F);
result = analysis_Reference(uint8(F),uint8(image1),uint8(image2));