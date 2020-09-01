 function outputFilename = splitChannels(filename, nChans, chans2split, delOriginal)
% The function splits channels into separate dat files. It should be used
% when more than one probe was used during the recording. The files are
% then processed separately in the spikeSortingPipeline.
%
% Input: data filename should include the full path and the extension.
%        nChans is the total number of channels in the recording.
%        chans2split is a cell array of channels corresponding to separate
%          files.
%        delOriginal is true if the original file is to be deleted.
%          Otherwise it is false.
%
% Output: outputFilename is the cell array with output filenames all having
%           fewer channels than the original file.

if nargin < 4
  delOriginal = false;
end

chunkSize = 1000000;

fid = []; fidOut = [];

d = dir(filename);
nSampsTotal = d.bytes/nChans/2;
nChunksTotal = ceil(nSampsTotal/chunkSize);

nFiles = numel(chans2split);
try
  
  [pathstr, name, ext] = fileparts(filename);
  fid = fopen(filename, 'r');
  
  for iFile = 1:nFiles
    outputFilename{iFile} = [pathstr filesep name '_probe' num2str(iFile) ext]; %#ok<*AGROW>
    fidOut{iFile} = fopen(outputFilename{iFile}, 'w');
  end
  
  chunkInd = 1;
  while 1
    fprintf(1, 'chunk %d/%d\n', chunkInd, nChunksTotal);
    dat = fread(fid, [nChans chunkSize], '*int16');
    if ~isempty(dat)
      for iFile = 1:nFiles
        fwrite(fidOut{iFile}, dat(chans2split{iFile},:), 'int16');
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
