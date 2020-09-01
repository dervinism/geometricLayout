 function outputFilename = writeBinary(data, fileName, format)
% The function writes a short binary file.
%
% Input: data is the data vector to write.
%        fileName is the name of the binary file when saved.
%        format is the saved data format (i.e., 'int16', 'double', etc).
%           Default is 'int16'.
%
% Output: outputFilename is the name of the binary file when saved.

if nargin < 3
    format = 'int16';
end

chunkSize = 1000000;
data = int16(data);

fidOut = [];

w = whos('data');
nSampsTotal = w.bytes/2;
nChunksTotal = ceil(nSampsTotal/chunkSize);

try
  outputFilename  = fileName;
  fidOut = fopen(outputFilename, 'w');
  
  chunkInd = 1;
  while 1
    fprintf(1, 'chunk %d/%d\n', chunkInd, nChunksTotal);
    inds = (1:chunkSize) + (chunkInd-1)*chunkSize;
    if inds(1) > numel(data)
      break
    elseif inds(end) > numel(data)
      inds = inds(1):numel(data);
    end
    dat = int16(data(inds));
    fwrite(fidOut, dat, format);
    chunkInd = chunkInd+1;
  end
  
  fclose(fidOut);
  
catch me
  if ~isempty(fidOut)
    fclose(fidOut);
  end
  
  rethrow(me)
  
end
