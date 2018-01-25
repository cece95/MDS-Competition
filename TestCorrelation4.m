%%%%%%%%%%%%%%% media del PRNU
clear all; close all; clc;
start_time = cputime;

%% mena prnu
PRNU=load('prnu_Camera1.mat');
PRNUblue=PRNU.prnu(:,:,3);
PRNUgreen=PRNU.prnu(:,:,2);
PRNUred=PRNU.prnu(:,:,1);

PRNUmean=(PRNUblue + PRNUgreen + PRNUred)/3 ;

%% Image reading
img       = imread('c1_3.tif');

red = img(:,:,1); % Red channel
green = img(:,:,2); % Green channel
blue = img(:,:,3); % Blue channel
ResidualBlue(:,:)=blue(:,:) - wiener2(blue(:,:),[5 5]);
ResidualGreen(:,:)=green(:,:) - wiener2(green(:,:),[5 5]);
ResidualRed(:,:)=red(:,:) - wiener2(red(:,:),[5 5]);

ResidualMean=(ResidualBlue+ResidualGreen+ResidualRed)/3;
%% save the PRNU block
count=1;
PRNUblock=zeros(15,20,100);
setGlobalx(count)
setGlobalPRNUblock(PRNUblock)
saveBlock = @(block_struct) test(block_struct.data);
I = blockproc(PRNUmean,[15 20],saveBlock);
PRNUblueBlock=getGlobalPRNUblock();

count=1;
%% correlazione
index=1;
setGlobalx(index)
fun = @(block_struct) correlazione(block_struct.data);
I2 = blockproc(ResidualMean,[15 20],fun);

%% normalize


normalizedImage = uint8(255*mat2gray(I2));
imshow(normalizedImage)



%% fun correlazione
function ris=correlazione(x)
    index=getGlobalx();
    PRNUblueBlock=getGlobalPRNUblock();
    temp=PRNUblueBlock(:,:,index);
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