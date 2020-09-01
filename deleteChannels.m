 function outputFilename = deleteChannels(filename, nChans, chansToDelete, delOriginal)
% The function deletes channels in the recording producing a dat file with
% a fewer number of channels.
%
% Input: filename should include the full path and the extension.
%        nChans is the total number of channels in the recording.
%        chansToDelete is the vector containing channels to be deleted.
%        delOriginal is true if the original file is to be deleted.
%          Otherwise it is false.
%
% Output: outputFilename is the name of the data file with fewer channels.

if nargin < 4
  delOriginal = false;
end

chunkSize = 1000000;

fid = []; fidOut = [];

d = dir(filename);
nSampsTotal = d.bytes/nChans/2;
nChunksTotal = ceil(nSampsTotal/chunkSize);

chansToKeep = 1:nChans;
for i = 1:numel(chansToDelete)
  chansToKeep = chansToKeep(chansToKeep ~= chansToDelete(i));
end

try
  
  [pathstr, name, ext] = fileparts(filename);
  fid = fopen(filename, 'r');
  
  outputFilename  = [pathstr filesep name '_reduced' ext];
  fidOut = fopen(outputFilename, 'w');
  
  chunkInd = 1;
  while 1
    fprintf(1, 'chunk %d/%d\n', chunkInd, nChunksTotal);
    dat = fread(fid, [nChans chunkSize], '*int16');
    if ~isempty(dat)
      dat = dat(chansToKeep,:);
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
