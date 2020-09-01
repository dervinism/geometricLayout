 function outputFilename = reorderChannels(filename, nChans, newOrder, delOriginal)
% The function reorders channels in the recording producing a new dat file.
%
% Input: filename should include the full path and the extension.
%        nChans is the total number of channels in the recording.
%        newOrder is the vector containing the new channel order.
%        delOriginal is true if the original file is to be deleted.
%          Otherwise it is false.
%
% Output: outputFilename is the name of the data file with fewer channels.

chunkSize = 1000000;

fid = []; fidOut = [];

d = dir(filename);
nSampsTotal = d.bytes/nChans/2;
nChunksTotal = ceil(nSampsTotal/chunkSize);

try
  
  [pathstr, name, ext] = fileparts(filename);
  fid = fopen(filename, 'r');
  
  if isempty(pathstr)
    outputFilename  = [name '_reordered' ext];
  else
    outputFilename  = [pathstr filesep name '_reordered' ext];
  end
  fidOut = fopen(outputFilename, 'w');
  
  chunkInd = 1;
  while 1
    fprintf(1, 'chunk %d/%d\n', chunkInd, nChunksTotal);
    dat = fread(fid, [nChans chunkSize], '*int16');
    if ~isempty(dat)
      dat = dat(newOrder,:);
      fwrite(fidOut, dat, 'int16');
    else
      break
    end
    chunkInd = chunkInd+1;
  end
  
  fclose(fid);
  fclose(fidOut);
  
  if delOriginal
    delete(filename);
  end
  
catch me
  
  if ~isempty(fid)
    fclose(fid);
  end
  
  if ~isempty(fidOut)
    fclose(fidOut);
  end
  
  rethrow(me)
  
end
