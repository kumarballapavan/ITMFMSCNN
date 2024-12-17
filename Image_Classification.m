function tallimage=Image_Classification(I)

I=im2uint8(I);
%I=im2double(I);
%figure;imshow(I);

[rows, columns, channels]=size(I);

block_size=20;

% row_length=rows/block_size;
% column_length=columns/block_size;

I2=I;



for i=1:rows
    for j=1:columns
        if I(i,j,1)<115 && I(i,j,2)<115 && I(i,j,3)<115
            I2(i,j,:)=[255,0,0];
        end
    end
end


% figure;imshow(I2);
[Oimgpart, OimgR, OimgC]=blocks(I2,block_size);
Oimgpart=im2uint8(Oimgpart);
parts=OimgR*OimgC;
%I2=I;
% disp('size of Oimgpart'); disp(size(Oimgpart));
Odiff2= zeros(size(Oimgpart));

part=1:parts;Red_blocks=0;ctr=1;Red_buffer=zeros(1,parts);all_count=0;

for i=1:parts
    count=0;all_count=all_count+1;
    for j=1:block_size        
        for k=1:block_size
            if Oimgpart(j,k,1,i)==255 && Oimgpart(j,k,2,i)==0 && Oimgpart(j,k,3,i)==0
                count=count+1;
            end
            
        end
    end
        if count==(block_size*block_size)
            for k=1:block_size
                for l=1:block_size
                    Odiff2(k,l,:,i)=[0.4,0.4,0.4];
                end
            end
%             disp('The dark region block number is:');disp(i);
            %Red_blocks=Red_blocks+1;
            Red_buffer(ctr)=all_count;
            ctr=ctr+1;
            %disp('full red block');
        end
%         if i==384
%             disp('Oimgpart:');disp(Oimgpart(:,:,:,i));
%         end
%disp('i:');disp(i);
end

% disp('Red Blocks:'); disp(Red_blocks);

Contrast1Oimg= zeros(3,parts);
%  Contrast2Oimg= zeros(3,parts);
 MeanOimg= zeros(3,parts);
%  CMratioOimg=zeros(3,parts);
%  Contrast1OGT= zeros(3,parts);
%  Contrast2OGT= zeros(3,parts);
%  MeanOGT= zeros(3,parts);
%  CMratioOGT=zeros(3,parts);
%  Odiff=zeros(3,parts);
 

count=0;
 for i=1:parts
    %figure; imshow(Oimgpart(:,:,:,i));
    %disp('I am in iteration No:');disp(i);
        
    if i~=Red_buffer
        
    count=count+1;
    
    Contrast1Oimg(:,i)=max(max(Oimgpart(:,:,:,i)))-min(min(Oimgpart(:,:,:,i)));
%     Contrast2Oimg(1,i)=max(max(Oimgpart(:,:,1,i)))/min(min(Oimgpart(:,:,1,i)));
%     Contrast2Oimg(2,i)=max(max(Oimgpart(:,:,2,i)))/min(min(Oimgpart(:,:,2,i)));
%     Contrast2Oimg(3,i)=max(max(Oimgpart(:,:,3,i)))/min(min(Oimgpart(:,:,3,i)));
    MeanOimg(:,i) = mean(mean(Oimgpart(:,:,:,i)));
%     CMratioOimg(:,i)=Contrast1Oimg(:,i)./MeanOimg(:,i);  
    
     if (Contrast1Oimg(1,i)<20 && Contrast1Oimg(2,i)<20 && Contrast1Oimg(3,i)<20) && (MeanOimg(1,i)>150 || MeanOimg(2,i)>150 || MeanOimg(3,i)>150)
        %disp('In old blue');
        if i>400
%         disp('blue parts:');disp(i);
        end
        
        for k=1:block_size
            for l=1:block_size
                Odiff2(k,l,:,i)=[1,1,1];
                %disp("Block Number of high haze:");disp(count);
            end            
        end
    
      elseif Contrast1Oimg(1,i)>100 && Contrast1Oimg(2,i)>100 && Contrast1Oimg(3,i)>100
          
         for k=1:block_size
            for l=1:block_size
                Odiff2(k,l,:,i)=[0.4,0.4,0.4];
            end
         end
         
       else
         for k=1:block_size
            for l=1:block_size
                Odiff2(k,l,:,i)=[0.7,0.7,0.7];
                % disp("Block Number of moderate haze:");disp(count);
            end
          end
     end
    end
 end
 
 wideimage1=[Odiff2(:,:,:,1), Odiff2(:,:,:,2),Odiff2(:,:,:,3), Odiff2(:,:,:,4),Odiff2(:,:,:,5), Odiff2(:,:,:,6),Odiff2(:,:,:,7), Odiff2(:,:,:,8),Odiff2(:,:,:,9), Odiff2(:,:,:,10),Odiff2(:,:,:,11), Odiff2(:,:,:,12),Odiff2(:,:,:,13), Odiff2(:,:,:,14),Odiff2(:,:,:,15), Odiff2(:,:,:,16),Odiff2(:,:,:,17), Odiff2(:,:,:,18),Odiff2(:,:,:,19), Odiff2(:,:,:,20),Odiff2(:,:,:,21), Odiff2(:,:,:,22),Odiff2(:,:,:,23), Odiff2(:,:,:,24)];
wideimage2=[Odiff2(:,:,:,25), Odiff2(:,:,:,26),Odiff2(:,:,:,27), Odiff2(:,:,:,28),Odiff2(:,:,:,29), Odiff2(:,:,:,30),Odiff2(:,:,:,31), Odiff2(:,:,:,32),Odiff2(:,:,:,33), Odiff2(:,:,:,34),Odiff2(:,:,:,35), Odiff2(:,:,:,36),Odiff2(:,:,:,37), Odiff2(:,:,:,38),Odiff2(:,:,:,39), Odiff2(:,:,:,40),Odiff2(:,:,:,41), Odiff2(:,:,:,42),Odiff2(:,:,:,43), Odiff2(:,:,:,44),Odiff2(:,:,:,45), Odiff2(:,:,:,46),Odiff2(:,:,:,47), Odiff2(:,:,:,48)];
wideimage3=[Odiff2(:,:,:,49), Odiff2(:,:,:,50),Odiff2(:,:,:,51), Odiff2(:,:,:,52),Odiff2(:,:,:,53), Odiff2(:,:,:,54),Odiff2(:,:,:,55), Odiff2(:,:,:,56),Odiff2(:,:,:,57), Odiff2(:,:,:,58),Odiff2(:,:,:,59), Odiff2(:,:,:,60),Odiff2(:,:,:,61), Odiff2(:,:,:,62),Odiff2(:,:,:,63), Odiff2(:,:,:,64),Odiff2(:,:,:,65), Odiff2(:,:,:,66),Odiff2(:,:,:,67), Odiff2(:,:,:,68),Odiff2(:,:,:,69), Odiff2(:,:,:,70),Odiff2(:,:,:,71), Odiff2(:,:,:,72)];
wideimage4=[Odiff2(:,:,:,73), Odiff2(:,:,:,74),Odiff2(:,:,:,75), Odiff2(:,:,:,76),Odiff2(:,:,:,77), Odiff2(:,:,:,78),Odiff2(:,:,:,79), Odiff2(:,:,:,80),Odiff2(:,:,:,81), Odiff2(:,:,:,82),Odiff2(:,:,:,83), Odiff2(:,:,:,84),Odiff2(:,:,:,85), Odiff2(:,:,:,86),Odiff2(:,:,:,87), Odiff2(:,:,:,88),Odiff2(:,:,:,89), Odiff2(:,:,:,90),Odiff2(:,:,:,91), Odiff2(:,:,:,92),Odiff2(:,:,:,93), Odiff2(:,:,:,94),Odiff2(:,:,:,95), Odiff2(:,:,:,96)];
wideimage5=[Odiff2(:,:,:,97), Odiff2(:,:,:,98),Odiff2(:,:,:,99), Odiff2(:,:,:,100),Odiff2(:,:,:,101), Odiff2(:,:,:,102),Odiff2(:,:,:,103), Odiff2(:,:,:,104),Odiff2(:,:,:,105), Odiff2(:,:,:,106),Odiff2(:,:,:,107), Odiff2(:,:,:,108),Odiff2(:,:,:,109), Odiff2(:,:,:,110),Odiff2(:,:,:,111), Odiff2(:,:,:,112),Odiff2(:,:,:,113), Odiff2(:,:,:,114),Odiff2(:,:,:,115), Odiff2(:,:,:,116),Odiff2(:,:,:,117), Odiff2(:,:,:,118),Odiff2(:,:,:,119), Odiff2(:,:,:,120)];
wideimage6=[Odiff2(:,:,:,121), Odiff2(:,:,:,122),Odiff2(:,:,:,123), Odiff2(:,:,:,124),Odiff2(:,:,:,125), Odiff2(:,:,:,126),Odiff2(:,:,:,127), Odiff2(:,:,:,128),Odiff2(:,:,:,129), Odiff2(:,:,:,130),Odiff2(:,:,:,131), Odiff2(:,:,:,132),Odiff2(:,:,:,133), Odiff2(:,:,:,134),Odiff2(:,:,:,135), Odiff2(:,:,:,136),Odiff2(:,:,:,137), Odiff2(:,:,:,138),Odiff2(:,:,:,139), Odiff2(:,:,:,140),Odiff2(:,:,:,141), Odiff2(:,:,:,142),Odiff2(:,:,:,143), Odiff2(:,:,:,144)];
wideimage7=[Odiff2(:,:,:,145), Odiff2(:,:,:,146),Odiff2(:,:,:,147), Odiff2(:,:,:,148),Odiff2(:,:,:,149), Odiff2(:,:,:,150),Odiff2(:,:,:,151), Odiff2(:,:,:,152),Odiff2(:,:,:,153), Odiff2(:,:,:,154),Odiff2(:,:,:,155), Odiff2(:,:,:,156),Odiff2(:,:,:,157), Odiff2(:,:,:,158),Odiff2(:,:,:,159), Odiff2(:,:,:,160),Odiff2(:,:,:,161), Odiff2(:,:,:,162),Odiff2(:,:,:,163), Odiff2(:,:,:,164),Odiff2(:,:,:,165), Odiff2(:,:,:,166),Odiff2(:,:,:,167), Odiff2(:,:,:,168)];
wideimage8=[Odiff2(:,:,:,169), Odiff2(:,:,:,170),Odiff2(:,:,:,171), Odiff2(:,:,:,172),Odiff2(:,:,:,173), Odiff2(:,:,:,174),Odiff2(:,:,:,175), Odiff2(:,:,:,176),Odiff2(:,:,:,177), Odiff2(:,:,:,178),Odiff2(:,:,:,179), Odiff2(:,:,:,180),Odiff2(:,:,:,181), Odiff2(:,:,:,182),Odiff2(:,:,:,183), Odiff2(:,:,:,184),Odiff2(:,:,:,185), Odiff2(:,:,:,186),Odiff2(:,:,:,187), Odiff2(:,:,:,188),Odiff2(:,:,:,189), Odiff2(:,:,:,190),Odiff2(:,:,:,191), Odiff2(:,:,:,192)];
wideimage9=[Odiff2(:,:,:,193), Odiff2(:,:,:,194),Odiff2(:,:,:,195), Odiff2(:,:,:,196),Odiff2(:,:,:,197), Odiff2(:,:,:,198),Odiff2(:,:,:,199), Odiff2(:,:,:,200),Odiff2(:,:,:,201), Odiff2(:,:,:,202),Odiff2(:,:,:,203), Odiff2(:,:,:,204),Odiff2(:,:,:,205), Odiff2(:,:,:,206),Odiff2(:,:,:,207), Odiff2(:,:,:,208),Odiff2(:,:,:,209), Odiff2(:,:,:,210),Odiff2(:,:,:,211), Odiff2(:,:,:,212),Odiff2(:,:,:,213), Odiff2(:,:,:,214),Odiff2(:,:,:,215), Odiff2(:,:,:,216)];
wideimage10=[Odiff2(:,:,:,217), Odiff2(:,:,:,218),Odiff2(:,:,:,219), Odiff2(:,:,:,220),Odiff2(:,:,:,221), Odiff2(:,:,:,222),Odiff2(:,:,:,223), Odiff2(:,:,:,224),Odiff2(:,:,:,225), Odiff2(:,:,:,226),Odiff2(:,:,:,227), Odiff2(:,:,:,228),Odiff2(:,:,:,229), Odiff2(:,:,:,230),Odiff2(:,:,:,231), Odiff2(:,:,:,232),Odiff2(:,:,:,233), Odiff2(:,:,:,234),Odiff2(:,:,:,235), Odiff2(:,:,:,236),Odiff2(:,:,:,237), Odiff2(:,:,:,238),Odiff2(:,:,:,239), Odiff2(:,:,:,240)];
wideimage11=[Odiff2(:,:,:,241), Odiff2(:,:,:,242),Odiff2(:,:,:,243), Odiff2(:,:,:,244),Odiff2(:,:,:,245), Odiff2(:,:,:,246),Odiff2(:,:,:,247), Odiff2(:,:,:,248),Odiff2(:,:,:,249), Odiff2(:,:,:,250),Odiff2(:,:,:,251), Odiff2(:,:,:,252),Odiff2(:,:,:,253), Odiff2(:,:,:,254),Odiff2(:,:,:,255), Odiff2(:,:,:,256),Odiff2(:,:,:,257), Odiff2(:,:,:,258),Odiff2(:,:,:,259), Odiff2(:,:,:,260),Odiff2(:,:,:,261), Odiff2(:,:,:,262),Odiff2(:,:,:,263), Odiff2(:,:,:,264)];
wideimage12=[Odiff2(:,:,:,265), Odiff2(:,:,:,266),Odiff2(:,:,:,267), Odiff2(:,:,:,268),Odiff2(:,:,:,269), Odiff2(:,:,:,270),Odiff2(:,:,:,271), Odiff2(:,:,:,272),Odiff2(:,:,:,273), Odiff2(:,:,:,274),Odiff2(:,:,:,275), Odiff2(:,:,:,276),Odiff2(:,:,:,277), Odiff2(:,:,:,278),Odiff2(:,:,:,279), Odiff2(:,:,:,280),Odiff2(:,:,:,281), Odiff2(:,:,:,282),Odiff2(:,:,:,283), Odiff2(:,:,:,284),Odiff2(:,:,:,285), Odiff2(:,:,:,286),Odiff2(:,:,:,287), Odiff2(:,:,:,288)];
wideimage13=[Odiff2(:,:,:,289), Odiff2(:,:,:,290),Odiff2(:,:,:,291), Odiff2(:,:,:,292),Odiff2(:,:,:,293), Odiff2(:,:,:,294),Odiff2(:,:,:,295), Odiff2(:,:,:,296),Odiff2(:,:,:,297), Odiff2(:,:,:,298),Odiff2(:,:,:,299), Odiff2(:,:,:,300),Odiff2(:,:,:,301), Odiff2(:,:,:,302),Odiff2(:,:,:,303), Odiff2(:,:,:,304),Odiff2(:,:,:,305), Odiff2(:,:,:,306),Odiff2(:,:,:,307), Odiff2(:,:,:,308),Odiff2(:,:,:,309), Odiff2(:,:,:,310),Odiff2(:,:,:,311), Odiff2(:,:,:,312)];
wideimage14=[Odiff2(:,:,:,313), Odiff2(:,:,:,314),Odiff2(:,:,:,315), Odiff2(:,:,:,316),Odiff2(:,:,:,317), Odiff2(:,:,:,318),Odiff2(:,:,:,319), Odiff2(:,:,:,320),Odiff2(:,:,:,321), Odiff2(:,:,:,322),Odiff2(:,:,:,323), Odiff2(:,:,:,324),Odiff2(:,:,:,325), Odiff2(:,:,:,326),Odiff2(:,:,:,327), Odiff2(:,:,:,328),Odiff2(:,:,:,329), Odiff2(:,:,:,330),Odiff2(:,:,:,331), Odiff2(:,:,:,332),Odiff2(:,:,:,333), Odiff2(:,:,:,334),Odiff2(:,:,:,335), Odiff2(:,:,:,336)];
wideimage15=[Odiff2(:,:,:,337), Odiff2(:,:,:,338),Odiff2(:,:,:,339), Odiff2(:,:,:,340),Odiff2(:,:,:,341), Odiff2(:,:,:,342),Odiff2(:,:,:,343), Odiff2(:,:,:,344),Odiff2(:,:,:,345), Odiff2(:,:,:,346),Odiff2(:,:,:,347), Odiff2(:,:,:,348),Odiff2(:,:,:,349), Odiff2(:,:,:,350),Odiff2(:,:,:,351), Odiff2(:,:,:,352),Odiff2(:,:,:,353), Odiff2(:,:,:,354),Odiff2(:,:,:,355), Odiff2(:,:,:,356),Odiff2(:,:,:,357), Odiff2(:,:,:,358),Odiff2(:,:,:,359), Odiff2(:,:,:,360)];
wideimage16=[Odiff2(:,:,:,361), Odiff2(:,:,:,362),Odiff2(:,:,:,363), Odiff2(:,:,:,364),Odiff2(:,:,:,365), Odiff2(:,:,:,366),Odiff2(:,:,:,367), Odiff2(:,:,:,368),Odiff2(:,:,:,369), Odiff2(:,:,:,370),Odiff2(:,:,:,371), Odiff2(:,:,:,372),Odiff2(:,:,:,373), Odiff2(:,:,:,374),Odiff2(:,:,:,375), Odiff2(:,:,:,376),Odiff2(:,:,:,377), Odiff2(:,:,:,378),Odiff2(:,:,:,379), Odiff2(:,:,:,380),Odiff2(:,:,:,381), Odiff2(:,:,:,382),Odiff2(:,:,:,383), Odiff2(:,:,:,384)];
wideimage17=[Odiff2(:,:,:,385), Odiff2(:,:,:,386),Odiff2(:,:,:,387), Odiff2(:,:,:,388),Odiff2(:,:,:,389), Odiff2(:,:,:,390),Odiff2(:,:,:,391), Odiff2(:,:,:,392),Odiff2(:,:,:,393), Odiff2(:,:,:,394),Odiff2(:,:,:,395), Odiff2(:,:,:,396),Odiff2(:,:,:,397), Odiff2(:,:,:,398),Odiff2(:,:,:,399), Odiff2(:,:,:,400),Odiff2(:,:,:,401), Odiff2(:,:,:,402),Odiff2(:,:,:,403), Odiff2(:,:,:,404),Odiff2(:,:,:,405), Odiff2(:,:,:,406),Odiff2(:,:,:,407), Odiff2(:,:,:,408)];
wideimage18=[Odiff2(:,:,:,409), Odiff2(:,:,:,410),Odiff2(:,:,:,411), Odiff2(:,:,:,412),Odiff2(:,:,:,413), Odiff2(:,:,:,414),Odiff2(:,:,:,415), Odiff2(:,:,:,416),Odiff2(:,:,:,417), Odiff2(:,:,:,418),Odiff2(:,:,:,419), Odiff2(:,:,:,420),Odiff2(:,:,:,421), Odiff2(:,:,:,422),Odiff2(:,:,:,423), Odiff2(:,:,:,424),Odiff2(:,:,:,425), Odiff2(:,:,:,426),Odiff2(:,:,:,427), Odiff2(:,:,:,428),Odiff2(:,:,:,429), Odiff2(:,:,:,430),Odiff2(:,:,:,431), Odiff2(:,:,:,432)];

tallimage=[wideimage1;wideimage2;wideimage3;wideimage4;wideimage5;wideimage6;wideimage7;wideimage8;wideimage9;wideimage10;wideimage11;wideimage12;wideimage13;wideimage14;wideimage15;wideimage16;wideimage17;wideimage18];
 

% disp('non-red blocks:');disp(count);
 % figure;imshow(tallimage);

 % imshow(tallimage);
 %            title("Categorization");
 %            pause(1);
 %            drawnow;

end

