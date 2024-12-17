clc;
close all;
clear all;

%% For new technique

temp=1;

DB = '.\hazy images';
% DB = 'F:\Study-2\Journal 4\code\hazy sample\temp2';


if temp==1


output_folder = 'training st\maps st';
filePattern1 = fullfile(DB, '*.png');
pngFiles1 = dir(filePattern1);
extention='.mat';

transDir='.\transResult';
refinedTransDir='.\refinedTransResult';
dehazedDir='.\Dehazed Result';
refinedDehazedDir='.\Refined Dehazed Result';

 %% Train the Network

doTraining = false;
if doTraining
    net = trainNetwork(dsTrain,layers,options);
    modelDateTime = string(datetime("now",Format="yyyy-MM-dd-HH-mm-ss"));
    save("trainedtransmapmet-"+modelDateTime+".mat","net");
else
    load("trainedtransmapmet-all-sample_CNN 5+5+5 add fusion.mat");
    %load("cnn-new-sample70 3L 20ep.mat");
end

for k = 1:length(pngFiles1)
    baseFileName1 = pngFiles1(k).name;
    fullFileName1 = fullfile(DB, baseFileName1);
    
    imageArray1 = imread(fullFileName1);

    imageArray1=imresize(imageArray1,[360 480]);

    % hazyTestRGB =   im2double(imageArray1);
    hazyTestRGB =   imageArray1;
       
    [filepath,name,ext] = fileparts(baseFileName1);
    outputFileName = fullfile(output_folder, [name, '.png']);

%      HDE=new_indicator_v5_opt(imageArray1);
% %     
%             if HDE<0.4
%                 imageArray1 = im2double(imageArray1);
%                 imageArray1 = im2gray(imageArray1);
%                 imageArray3 = imageArray1;
%                 imageArray3(imageArray3>=0) = 0;
%                 imageArray4(:,:,1)=imageArray1;
%                 imageArray4(:,:,2)=imageArray1;
%                 imageArray4(:,:,3)=imageArray3;
%                 disp("Low-Hazy");
%             elseif HDE<0.6
%                 imageArray1 = im2double(imageArray1);
%                 imageArray1 = im2gray(imageArray1);
%                 imageArray3 = imageArray1;
%                 imageArray3(imageArray3>=0) = 0.5;
%                 disp("Moderate-Hazy");
%                 imageArray4(:,:,1)=imageArray1;
%                 imageArray4(:,:,2)=imageArray1;
%                 imageArray4(:,:,3)=imageArray3;
%             else
%                 imageArray1 = im2double(imageArray1);
%                 imageArray1 = im2gray(imageArray1);
%                 imageArray3 = imageArray1;
%                 imageArray3(imageArray3>=0) = 1;
%                 disp("High-Hazy");
%                 imageArray4(:,:,1)=imageArray1;
%                 imageArray4(:,:,2)=imageArray1;
%                 imageArray4(:,:,3)=imageArray3;
%             end

 
           imageArray3=Image_Classification(imageArray1);
            % imageArray1 = im2double(imageArray1);
            imageArray1 = im2gray(imageArray1);
            imageArray1 = im2uint8(imageArray1);
            % imageArray3=im2double(imageArray3);
            imageArray3=im2gray(imageArray3);
            imageArray3=im2uint8(imageArray3);
            imageArray4(:,:,1)=imageArray1;
            imageArray4(:,:,2)=imageArray1;
            imageArray4(:,:,3)=imageArray3;
                    
%            imwrite(imageArray4,outputFileName);

            close all;

            figure;
            imshow([im2uint8(hazyTestRGB) imageArray4]);
            % drawnow;
            % matname = fullfile(output_folder, [name extention]);
            % save(matname, 'imageArray3');

           

%transResult = activations(net,hazyTest,'regressionoutput');
   % transResult = activations(net, imageArray4,'FinalRegressionLayer');
    %transResult = activations(net, im2uint8(imageArray1),'FinalRegressionLayer');
     transResult = activations(net, im2uint8(imageArray1),'regressionoutput');
    % transResult = activations(net, im2uint8(imageArray4),'regressionoutput');
     transResult=transResult/255;
     actualResult=transResult;
    imshow(im2uint8(transResult));
    title("Transmap");
    drawnow;
    % break;
    %transResult = forward(net,hazyTest);
    transResult = double(transResult);

    %gpuDevice(1);
    sortdata = sort(transResult(:), 'ascend');
        idx = round(0.01 * length(sortdata));
        val = sortdata(idx); 
        id_set = find(transResult <= val);
        BrightPxls = imageArray1 (id_set);
        iBright = BrightPxls >= max(BrightPxls);
        id = id_set(iBright);
        Itemp=reshape(hazyTestRGB,size(hazyTestRGB,1)*size(hazyTestRGB,2),size(hazyTestRGB,3));
        A = mean(Itemp(id, :),1);
        A=reshape(A,1,1,3);
        A=A./255;

        %% Color correction

        %disp('Átmospheric Light:');disp(A);

        A_temp=squeeze(A)';

        n_channel = size(hazyTestRGB,3);
        if n_channel == 3
            if std(A) >  0.2
            disp ('Color biased');
            A = norm(A_temp,3)*ones(size(A_temp)) ./ sqrt(3);
%             else
%             A2 = 1*A;
            end
        end

        A=reshape(A,1,1,3);

    transName = fullfile(transDir,[name, '.png']);
        imwrite(transResult,transName);

    sprintf('The hazy image number is %d',k)
    %     disp('For dehazing');
    % imshow(transResult,[]);
    % title("Transmap");

    J=bsxfun(@minus,im2double(hazyTestRGB),A);
%         imshow(J,[]);
%         title("J1");

        J=bsxfun(@rdivide,J,transResult);
        J=bsxfun(@plus,J,A);
        dehaze=J;

        dehazeName = fullfile(dehazedDir,[name, '.png']);
        imwrite(dehaze,dehazeName);


%% Evaluate the dehazing image from the transResult


r0 = 50;
eps = 10^-3;

F4 = guidedfilter(im2double(imageArray1), transResult, r0, eps);
% F4 =imsharpen(transResult);

transName = fullfile(refinedTransDir,[name, '.png']);
        imwrite(F4,transName);

% imshow(F4,[]);
% title("Refined Transmap");




        %F4 = guidedfilter(hazyTest, F4, r0, eps);

        J=bsxfun(@minus,im2double(hazyTestRGB),A);
%         imshow(J,[]);
%         title("J1");

        J=bsxfun(@rdivide,J,F4);
        J=bsxfun(@plus,J,A);
        dehaze=J;

        refdehazeName = fullfile(refinedDehazedDir,[name, '.png']);
        imwrite(dehaze,refdehazeName);
        %         refdehazeName = fullfile(refinedDehazedDir,[name, '.png']);
        % imwrite(actualResult,refdehazeName);
        % imwrite(im2uint8(transResult),refdehazeName);

        %imwrite(dehaze,[name, '.png']);

        imshow([im2double(hazyTestRGB) im2double(dehaze)]);
        title("Input Hazy image vs Final Dehazed Outcome");
        drawnow;

        %break;




end

DB2='F:\Study-2\Journal 4\code\training st\maps st';

close all;

end




%% Create Sample Low-Resolution Image

%DB = 'F:\Study-2\Journal 4\code\hazy sample';

% if ~isfolder(DB2)
%   errorMessage = sprintf('Error: The following folder does not exist:\n%s', DB);
%   uiwait(warndlg(errorMessage));
%   return;
% end
% 
% 
% 
% 
% % filePattern1 = fullfile(DB, '*.png');
% filePattern2 = fullfile(DB2, '*.mat');
% pngFiles2 = dir(filePattern2);


% for k = 1:length(pngFiles2)
% 
%     baseFileName2 = pngFiles2(k).name;
%     fullFileName2 = fullfile(DB2, baseFileName2);
%     [filepath,name,ext] = fileparts(baseFileName2); 
% 
%     for i = 1:length(pngFiles1)
%         baseFileName1 = pngFiles1(i).name;
%         fullFileName1 = fullfile(DB, baseFileName1);
%         [filepath,name2,ext] = fileparts(baseFileName1); 
%     if (strcmp(name,name2)) 
% 
% 
%     hazyTestRGB = imread(fullFileName1);
% %      hazyTestRGB = imresize( hazyTestRGB, [360 480]);
% %     hazyTest = im2gray(hazyTestRGB);
% %     hazyTest = imresize(hazyTest, [360 480]);
%     % hazyTest = im2double(hazyTestRGB);
%     % hazyTest = load(fullFileName2);
% 
%     hazyTestimage(:,:,1) = im2gray(hazyTest.imageArray3(:,:,1));
% 
%     hazyTestimage(:,:,2) = im2gray(hazyTest.imageArray3(:,:,2));
% 
% 
% 
% 
% 
%     end
% 
%     end
% 
% end

