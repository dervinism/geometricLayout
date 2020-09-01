function outputFilename = splitChannelsReverse(filename, nChans, chans2join, outputDir, delOriginal)
% The function stacks files back together after the original file being
% split into separate dat files separating channels. For more information
% see the function splitChannels.
%
% Input: filename is a cell array containing full path of files to be
%          concatenated.
%        nChans is a cell array containing the total number of channels in
%          each of the files.
%        chans2join is a cell array of channels to be included of each
%          separate file.
%        delOriginal is true if the original files are to be deleted.
%          Otherwise it is false.
%        outputDir is an output folder name string.
%
% Output: outputFilename is the full path to the concatenated file.

if nargin < 5
  delOriginal = false;
end

chunkSize = 1000000;
nFiles = numel(filename);

fid = {}; fidOut = [];

for iFile = 1:nFiles
  d{iFile} = dir(filename{iFile}); %#ok<*AGROW>
  nSampsTotal{iFile} = d{iFile}.bytes/nChans{iFile}/2;
  nChunksTotal{iFile} = ceil(nSampsTotal{iFile}/chunkSize);
  if iFile > 1
    assert(nSampsTotal{iFile-1} == nSampsTotal{iFile}, 'Input files are of unequal length.');
  end
end

try
  
  for iFile = 1:nFiles
    fid{iFile} = fopen(filename{iFile}, 'r');
  end
  
  outputFilename = [outputDir filesep 'concatenatedData.dat'];
  fidOut = fopen(outputFilename, 'w');
  
  chunkInd = 1;
  while 1
    fprintf(1, 'chunk %d/%d\n', chunkInd, nChunksTotal{1});
    dat = [];
    for iFile = 1:nFiles
      initDat = fread(fid{iFile}, [nChans{iFile} chunkSize], '*int16');
      if ~isempty(initDat)
        dat = [dat; initDat(chans2join{iFile},:)];
      end
    end
    if ~isempty(dat)
      fwrite(fidOut, dat, 'int16');
    else
      break
    end
    chunkInd = chunkInd+1;
  end
  
  for iFile = 1:nFiles
    fclose(fid{iFile});
  end
  fclose(fidOut);
  
  if delOriginal
    for iFile = 1:nFiles
      delete(filename{iFile});
    end
  end
  
catch me
  
  if ~isempty(fid)
    for iFile = 1:nFiles
      fclose(fid{iFile});
    end
  end
  
  if ~isempty(fidOut)
    fclose(fidOut);
  end
  
  rethrow(me)
  
end