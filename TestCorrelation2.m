
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
%%%%%%%%%% solo img small 150 * 200

clear all; close all; clc;
start_time = cputime;

%% Image reading
img       = imread('c1_smal.tif');
PRNU=load('prnu_Camera1_blue_small.mat');
PRNUblue=PRNU.a(:,:);
blue = img(:,:,3); % Blue channel

ResidualBlue(:,:)=blue(:,:) - wiener2(blue(:,:),[5 5]);

%% save the PRNU block
count=1;
PRNUblock=zeros(20,15,10);
setGlobalx(count)
setGlobalPRNUblock(PRNUblock)
saveBlock = @(block_struct) test(block_struct.data);
I = blockproc(PRNUblue,[20 15],saveBlock);
PRNUblueBlock=getGlobalPRNUblock();

count=1;
%% correlazione
index=1;
setGlobalx(index)
fun = @(block_struct) correlazione(block_struct.data);
I2 = blockproc(ResidualBlue,[20 15],fun);

%% normalize
normalizedImage = uint8(255*mat2gray(I2));
imshow(normalizedImage)



%% fun correlazione
function ris=correlazione(x,index)
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