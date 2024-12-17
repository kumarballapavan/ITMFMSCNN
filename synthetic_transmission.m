clc;
clear all;
close all;

DB = 'F:\Study-2\Journal 4\code\IETE latex\revision 2 resuls\Mod Haze\dehazing result\4x3';
GT = 'F:\DB\GT compressed';

transdir='F:\Study-2\Journal 4\code\synthetic_transmission';
Recdir='F:\Study-2\Journal 4\code\recovered';

if ~isfolder(DB)
  errorMessage = sprintf('Error: The following folder does not exist:\n%s', DB);
  uiwait(warndlg(errorMessage));
  return;
end

if ~isfolder(GT)
  errorMessage = sprintf('Error: The following folder does not exist:\n%s', GT);
  uiwait(warndlg(errorMessage));
  return;
end

% if ~isfolder(transdir)
%   errorMessage = sprintf('Error: The following folder does not exist:\n%s', transdir);
%   uiwait(warndlg(errorMessage));
%   return;
% end

filePattern1 = fullfile(DB, '*.png');
filePattern2 = fullfile(GT, '*.png');

pngFiles1 = dir(filePattern1);
pngFiles2 = dir(filePattern2);count=0;
global_count=0;

for k = 1:length(pngFiles1)
  baseFileName1 = pngFiles1(k).name;
  fullFileName1 = fullfile(DB, baseFileName1);j=0;
  global_count=global_count+1;
  
  for i = 1:length(pngFiles2)
    baseFileName2 = pngFiles2(i).name;
    fullFileName2 = fullfile(GT, baseFileName2);
    %baseFileName1_1 = append(baseFileName1(1:4),'.jpg');
    
    if strcmp(baseFileName1,baseFileName2) && j==0
        
        j=1;
        disp('Both Hazy and GT images are available');
        
        imageArray1 = imread(fullFileName1);
        imageArray2 = imread(fullFileName2);
    
        imageArray1=imresize(imageArray1,[360 480]);
        imageArray2=imresize(imageArray2,[360 480]);
        
        Hazy_image=imageArray1;
        GT_image=imageArray2;
        
        Hazy_d=im2double(Hazy_image);
        GT_d=im2double(GT_image);
            
        [filepath,name,ext] = fileparts(baseFileName1); 
        
        win_size = 15;
        dark_channel=get_dark_channel(Hazy_d,win_size);
        
        % imshow(dark_channel);title('Dark Channel');
        % drawnow;
        
        %pause(2);
        
        Atmospheric_Light=get_atmosphere(Hazy_d,dark_channel);
        
        %Atmospheric_Light=Atmospheric_Light+0.1;
        
         Atmospheric_Light= min( Atmospheric_Light,1);
        
        disp('Atmospheric Light:'); disp(Atmospheric_Light);
        
        [m, n, ~] = size(Hazy_d);

        rep_atmosphere = repmat(reshape(Atmospheric_Light, [1, 1, 3]), m, n);
        
        Hazy_d_gray=im2gray(Hazy_d);GT_d_gray=im2gray(GT_d); rep_atmosphere_gray=im2gray(rep_atmosphere);
        
        rep_atmosphere_gray_1=rep_atmosphere_gray-0.01;
        
        Hazy_d_gray(Hazy_d_gray>rep_atmosphere_gray_1(1,1))=rep_atmosphere_gray_1(Hazy_d_gray>rep_atmosphere_gray_1(1,1));
        GT_d_gray(GT_d_gray>rep_atmosphere_gray_1(1,1))=rep_atmosphere_gray_1(GT_d_gray>rep_atmosphere_gray_1(1,1));
        
        Numerator = (Hazy_d_gray-rep_atmosphere_gray);
        Denominator = (GT_d_gray-rep_atmosphere_gray);
        
%         Numerator2 = (Hazy_d-rep_atmosphere);
%         Denominator2 = (GT_d-rep_atmosphere);
                
        for i = 1:m
            for j=1:n
                %for k=1:3       
                    if (GT_d_gray(i,j))==(rep_atmosphere_gray(i,j))             
                        Denominator(i,j)=0.01;
                    end
                    
%                     if (GT_d_gray(i,j))>(rep_atmosphere_gray(i,j)-0.01)
%                         GT_d_gray(i,j)=rep_atmosphere_gray(i,j)-0.01;
%                     end
                    
                %end
            end
        end
        
        for i = 1:m
            for j=1:n
                %for k=1:3       
                    if (Hazy_d_gray(i,j)==rep_atmosphere_gray(i,j))
                        Numerator(i,j)=0.1;
                    end
                    
%                     if (Hazy_d_gray(i,j)>(rep_atmosphere_gray(i,j)-0.01))
%                         Hazy_d_gray(i,j)=rep_atmosphere_gray(i,j)-0.01;
%                     end
                %end
            end
        end
        
        
        
        Transmission=abs(Numerator./Denominator);  
        
        %Transmission=im2gray(Transmission);
        
        figure(1);
        imshow(Transmission,Colormap=jet);title('Transmission');
        colormap(jet)
        %drawnow;   
        %pause(2);
        
        max_transmission = repmat(max(Transmission, 0.1), [1, 1, 3]);
        %   max_transmission = max(Transmission,0.01);
        
        radiance = ((Hazy_d - rep_atmosphere) ./ max_transmission) + rep_atmosphere;
              
%         imshow(radiance); title('recovered image');
%         drawnow;
        
        %pause(2);

        max_transmission_g=im2gray(max_transmission);
        
        transname = fullfile(transdir,[name, '.png']);
        imwrite(max_transmission,jet,transname);
        
         recname = fullfile(Recdir,[name, '.png']);
        imwrite(radiance,recname);
        
        imwrite(max_transmission,"0418_1_0.04.png");
    
   
    imshow([Hazy_d GT_d radiance]); title('Hazy vs GT vs Recovered');   % Display image.
    drawnow; % Force display to update immediately.
    
    %pause(2);
    %count=count+1;
    end        
  end
  
  if j==0
      
    %disp('global count:'); disp(global_count);
    
    disp('No GT available');
    
    continue;    
      
  end
  
  %close all;
  
  
  
%   break;
  
end