%%%%%%%%%%%%%%% solo su un singolo canale ora settato sul verde



%%%%%%%%%%%% STAI ATTENTO A COME HAI DEFINITO IL CALCOLO DELLA CORRELAZIONE
%%%%%%%%%%%% LE SLIDE DELLA PROF NON UNSANO corr2 ma usano una formulina! verificala

clear all; close all; clc;
start_time = cputime;

%% Image reading
img       = imread('c1_2.tif');
PRNU=load('prnu_Camera1.mat');
PRNUblue=PRNU.prnu(:,:,2);

blue = img(:,:,2); % Blue channel
ResidualBlue(:,:)=blue(:,:) - wiener2(blue(:,:),[5 5]);

%% save the PRNU block
count=1;
PRNUblock=zeros(15,20,100);
setGlobalx(count)
setGlobalPRNUblock(PRNUblock)
saveBlock = @(block_struct) test(block_struct.data);
I = blockproc(PRNUblue,[15 20],saveBlock);
PRNUblueBlock=getGlobalPRNUblock();



count=1;
%% correlazione
index=1;
setGlobalx(index)
fun = @(block_struct) correlazione(block_struct.data);
I2 = blockproc(ResidualBlue,[15 20],fun);

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