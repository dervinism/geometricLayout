 function outputFilename = splitFile(filename, splitTime, nChans, sr, delOriginal)
% The function splits dat recording file into two separate dat files.
%
% Input: filename should include the full path and the extension of the dat
%          file you want to split.
%        splitTime is the time in seconds where you want the split to
%          occur.
%        nChans is the total number of channels in the recording.
%        sr is the sampling frequency. The default is 3e4.
%        delOriginal is true if the original file is to be deleted.
%          Otherwise it is false.
%
% Output: outputFilename is the cell array with output filenames all being
%           smaller than the original file.

if nargin < 4
  sr = 3e4;
end
if nargin < 5
  delOriginal = false;
end

chunkSize = 1000000;

fid = []; fidOut = [];

d = dir(filename);
nSampsTotal = d.bytes/nChans/2;
nChunksTotal = ceil(nSampsTotal/chunkSize);

splitChunkSize = splitTime*sr;
splitChunks = ceil(splitChunkSize/chunkSize);
lastSplitChunkSize = round((splitChunkSize - chunkSize*(splitChunks-1)));

nFiles = 2;
try
  
  [pathstr, name, ext] = fileparts(filename);
  fid = fopen(filename, 'r');
  
  for iFile = 1:nFiles
    outputFilename{iFile} = [pathstr filesep name '_part' num2str(iFile) ext]; %#ok<*AGROW>
    fidOut{iFile} = fopen(outputFilename{iFile}, 'w');
  end
  
  chunkInd = 1;
  while 1
    fprintf(1, 'chunk %d/%d\n', chunkInd, nChunksTotal);
    dat = fread(fid, [nChans chunkSize], '*int16');
    if ~isempty(dat)
      if chunkInd < splitChunks
        fwrite(fidOut{1}, dat, 'int16');
      elseif chunkInd == splitChunks
        fwrite(fidOut{1}, dat(:,1:lastSplitChunkSize), 'int16');
        fwrite(fidOut{2}, dat(:,lastSplitChunkSize+1:end), 'int16');
      elseif chunkInd > splitChunks
        fwrite(fidOut{2}, dat, 'int16');
      end
    else
      break
    end
    chunkInd = chunkInd+1;
  end
  
  fclose(fid);
  for iFile = 1:nFiles
    fclose(fidOut{iFile});
  end
  
  if delOriginal
    delete(filename);
  end
  
catch me
  
  if ~isempty(fid)
    fclose(fid);
  end
  
  if ~isempty(fidOut)
    for iFile = 1:nFiles
      fclose(fidOut{iFile});
    end
  end
  
  rethrow(me)
  
end
