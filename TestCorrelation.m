clear all; close all; clc;
start_time = cputime;

%% Image reading
camera1='C:\Users\Antonio\Desktop\Multimedia data security\Forencies\LAB\project\dev-dataset\flat-camera-1\flat_c1_050.tif';
camera2='C:\Users\Antonio\Desktop\Multimedia data security\Forencies\LAB\project\dev-dataset\flat-camera-2\flat_c2_007.tif';
img       = imread(camera2);
[imH,imW] = size(img);

red = img(:,:,1); % Red channel
green = img(:,:,2); % Green channel
blue = img(:,:,3); % Blue channel

DenoiseBlue=wiener2(blue(:,:),[5 5]);
ResidualBlue(:,:)=blue(:,:) - DenoiseBlue;

DenoiseRed=wiener2(red(:,:),[5 5]);
ResidualRed(:,:)=red(:,:) - DenoiseRed;

DenoiseGreen=wiener2(green(:,:),[5 5]);
ResidualGreen(:,:)=green(:,:) - DenoiseGreen;

PRNU=load('prnu_Camera1.mat');

PRNUred=PRNU.prnu(:,:,1);
PRNUgreen=PRNU.prnu(:,:,2);
PRNUblue=PRNU.prnu(:,:,3);
cRed=xcorr2(PRNUred,ResidualRed);
disp(corr2(PRNUred,ResidualRed));
disp(corr2(PRNUgreen,ResidualGreen));
disp(corr2(PRNUblue,ResidualBlue));

