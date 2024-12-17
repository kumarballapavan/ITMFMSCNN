function [Oimgpart, wholeBlockRows, wholeBlockCols] = blocks(rgbImage,block_size)

[rows, columns, numberOfColorBands] = size(rgbImage);
%==========================================================================
% The first way to divide an image up into blocks is by using mat2cell().
blockSizeR = block_size; % Rows in block.
blockSizeC = block_size; % Columns in block.
% Figure out the size of each block in rows. 
% Most will be blockSizeR but there may be a remainder amount of less than that.
% disp('Rows:');disp(rows);
wholeBlockRows = floor(rows / blockSizeR);
blockVectorR = [blockSizeR * ones(1, wholeBlockRows)];
%rem(rows, blockSizeR)
% Figure out the size of each block in columns. 
wholeBlockCols = floor(columns / blockSizeC);
blockVectorC = [blockSizeC * ones(1, wholeBlockCols)];
%, rem(columns, blockSizeC)
% disp('wholeBlockRows:');disp(wholeBlockRows);
% disp('wholeBlockCols:');disp(wholeBlockCols);
% disp('blockVectorR size:');disp(size(blockVectorR));
% disp('blockVectorC size:');disp(size(blockVectorC));
% disp('blockSizeR * ones(1, wholeBlockRows):');disp(size(blockSizeR * ones(1, wholeBlockRows)));
% disp('rem(rows, blockSizeR):');disp((rem(rows, blockSizeR)));
% Create the cell array, ca.  
% Each cell (except for the remainder cells at the end of the image)
% in the array contains a blockSizeR by blockSizeC by 3 color array.
% This line is where the image is actually divided up into blocks.
if numberOfColorBands > 1
  % It's a color image.
  ca = mat2cell(rgbImage, blockVectorR, blockVectorC, numberOfColorBands);
else
  ca = mat2cell(rgbImage, blockVectorR, blockVectorC);
end
% Now display all the blocks.
 Oimgpart= zeros(blockSizeR,blockSizeC,numberOfColorBands,wholeBlockRows*wholeBlockCols);
plotIndex = 1;
numPlotsR = size(ca, 1);
numPlotsC = size(ca, 2);
for r = 1 : numPlotsR
  for c = 1 : numPlotsC
    %fprintf('plotindex = %d,   c=%d, r=%d\n', plotIndex, c, r);
    % Specify the location for display of the image.
    % subplot(numPlotsR, numPlotsC, plotIndex);
    % Extract the numerical array out of the cell
    % just for tutorial purposes.
    rgbBlock = ca{r,c};
    try
    Oimgpart(:,:,:,plotIndex)= rgbBlock;
    % do something with your NonData
  catch
    fprintf('Inconsistent data in iteration %s, skipped.\n', plotIndex);
    plotIndex=plotIndex-1;
  end
    
   % imshow(rgbBlock); % Could call imshow(ca{r,c}) if you wanted to.
    [rowsB, columnsB, numberOfColorBandsB] = size(rgbBlock);
    % Make the caption the block number.
    %caption = sprintf('Block #%d of %d\n%d rows by %d columns', ...
    %  plotIndex, numPlotsR*numPlotsC, rowsB, columnsB);
   % title(caption);
    %drawnow;
    % Increment the subplot to the next location.
    plotIndex = plotIndex + 1;
  end
end
end