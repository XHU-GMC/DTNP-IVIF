close all;
clear all
clc
%%
[imagename1, imagepath1]=uigetfile('IV_images\*.jpg;*.bmp;*.png;*.tif;*.tiff;*.pgm;*.gif','Please choose the first input image');
A=imread(strcat(imagepath1,imagename1)); 
[imagename2,imagepath2]=uigetfile('IV_images\*.jpg;*.bmp;*.png;*.tif;*.tiff;*.pgm;*.gif','Please choose the first input image'); 
B=imread(strcat(imagepath2,imagename2));
[imagename2,imagepath2]=uigetfile('fused\*.jpg;*.bmp;*.png;*.tif;*.tiff;*.pgm;*.gif','Please choose the fused image'); 
F=imread(strcat(imagepath2,imagename2));
result = analysis_Reference(F,A,B);



