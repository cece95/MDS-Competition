%%%%%%%%%%%%%%% 
clear all; close all; clc;
start_time = cputime;

%% Image reading
img       = imread('c1_2.tif');
PRNU=load('prnu2_Camera1.mat');
PRNUred=PRNU.prnu(:,:,1);
PRNUgreen=PRNU.prnu(:,:,2);
PRNUblue=PRNU.prnu(:,:,3);

red = img(:,:,1); % Red channel
blue = img(:,:,3); % blue channel
green = img(:,:,2); % green channel

ResidualRed(:,:)=red(:,:) - wiener2(red(:,:),[5 5]);
ResidualBlue(:,:)=blue(:,:) - wiener2(blue(:,:),[5 5]);
ResidualGreen(:,:)=green(:,:) - wiener2(green(:,:),[5 5]);
%% save the PRNU block red
count=1;
PRNUblock=zeros(75,100,500);
setGlobalx(count)
setGlobalPRNUblock(PRNUblock)
saveBlock = @(block_struct) test(block_struct.data);
Ired = blockproc(PRNUred,[75 100],saveBlock);
PRNUredBlock=getGlobalPRNUblock();

%% correlazione red
index=1;
setGlobalx(index)
fun = @(block_struct) correlazione(block_struct.data);
I2red = blockproc(ResidualRed,[75 100],fun);


%% save the PRNU block blue
count=1;
PRNUblock=zeros(75,100,500);
setGlobalx(count)
setGlobalPRNUblock(PRNUblock)
saveBlock = @(block_struct) test(block_struct.data);
Iblue = blockproc(PRNUblue,[75 100],saveBlock);
PRNUBlock=getGlobalPRNUblock();
%% correlazione blue
index=1;
setGlobalx(index)
fun = @(block_struct) correlazione(block_struct.data);
I2blue = blockproc(ResidualBlue,[75 100],fun);


%% save the PRNU block green
count=1;
PRNUblock=zeros(75,100,500);
setGlobalx(count)
setGlobalPRNUblock(PRNUblock)
saveBlock = @(block_struct) test(block_struct.data);
Igreen = blockproc(PRNUgreen,[75 100],saveBlock);
PRNUgreenBlock=getGlobalPRNUblock();

%% correlazione green
index=1;
setGlobalx(index)
fun = @(block_struct) correlazione(block_struct.data);
I2green = blockproc(ResidualGreen,[75 100],fun);

%% normalize
I3red=abs(I2red);
I3green=abs(I2green);
I3blue=abs(I2blue);

normalizedImageRed = uint8(255*mat2gray(I2red));
normalizedImageBlue = uint8(255*mat2gray(I2blue));
normalizedImageGreen = uint8(255*mat2gray(I2green));

normalizedImageRedabs = uint8(255*mat2gray(I3red));
normalizedImageBlueabs = uint8(255*mat2gray(I3blue));
normalizedImageGreenabs = uint8(255*mat2gray(I3green));

%% Plot the images
subplot(2,3,1); imshow(normalizedImageRed);
title(sprintf('red '));
subplot(2,3,2); imshow(normalizedImageBlue);
title(sprintf('Blue '));
subplot(2,3,3); imshow(normalizedImageGreen);
title(sprintf('green '));

subplot(2,3,4); imshow(normalizedImageRedabs);
title(sprintf('red abs '));
subplot(2,3,5); imshow(normalizedImageBlueabs);
title(sprintf('Blue abs '));
subplot(2,3,6); imshow(normalizedImageGreenabs);
title(sprintf('green abs '));

%% fun correlazione
function ris=correlazione(x,index)
    index=getGlobalx();
    PRNUBlock=getGlobalPRNUblock();
    temp=PRNUBlock(:,:,index);
    ris=corr2(x,temp);
    index=index+1;
    setGlobalx(index);
end






%% per salvare le sottomatrici
function test(x) 
c=getGlobalx();
t=getGlobalPRNUblock();
t(:,:,c)=x;
setGlobalPRNUblock(t);
c=c+1;
setGlobalx(c);
end

function setGlobalx(val)
global x
x = val;
end

function r = getGlobalx
global x
r = x;
end
function setGlobalPRNUblock(val)
global ris
ris = val;
end

function r = getGlobalPRNUblock
global ris
r = ris;
end