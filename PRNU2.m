%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %%
%% Extract PRNU 
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %%

clear all; close all; clc;
start_time = cputime;

%% Image reading
directory='C:\Users\Antonio\Desktop\Multimedia data security\Forencies\LAB\project\dev-dataset\flat-camera-1';
images=dir(directory);

Blue=uint8(zeros(1500,2000));
Red=uint8(zeros(1500,2000));
Green=uint8(zeros(1500,2000));
%% run over all imges
first=0;
for i=1:size(images)
    singleName=images(i).name;
    if (numel(singleName)>4)
        extension=singleName(end-3:end);
        if (strcmp(extension,'.tif'))
                if (first~=0)
                file_name=strcat(directory,'\',images(i).name);
                disp(file_name);
                img       = imread(file_name);
                [imH,imW] = size(img);
                red = img(:,:,1); % Red channel
                green = img(:,:,2); % Green channel
                blue = img(:,:,3); % Blue channel

                DenoiseBlue=wiener2(blue(:,:),[5 5]);
                ResidualBlue(:,:)=blue(:,:) - DenoiseBlue;
                Blue=Blue+(((ResidualBlue).*blue)./(blue.*blue));
                
                
                DenoiseRed=wiener2(red(:,:),[5 5]);
                ResidualRed(:,:)=red(:,:) - DenoiseRed;
                Red=Red+(((ResidualRed).*red)./(red.*red));
                
                DenoiseGreen=wiener2(green(:,:),[5 5]);
                ResidualGreen(:,:)=green(:,:) - DenoiseGreen;
                Green=Green+(((ResidualGreen).*green)./(green.*green));
                end
                first=1;
        end
    end    
end


prnu(:,:,1)=Red;
prnu(:,:,2)=Green;
prnu(:,:,3)=Blue;

save('prnu2_Camera1','prnu');










%% Time evaluation
stop_time = cputime;
fprintf('Execution time = %0.5f sec\n',abs( start_time - stop_time));