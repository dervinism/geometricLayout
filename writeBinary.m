function outputFilename = writeBinary(data, fileName)
% The function writes a short binary file.
%
% Input: data is the data vector to write.
%        fileName is the name of the binary file when saved.
%
% Output: outputFilename is the name of the binary file when saved.

chunkSize = 1000000;

fidOut = [];

w = whos('data');
format = w.class;
if strcmp(format, 'int8') || strcmp(format, 'uint8')
  nSampsTotal = format;
elseif strcmp(format, 'int16') || strcmp(format, 'uint16')
  nSampsTotal = w.bytes/2;
elseif strcmp(format, 'int32') || strcmp(format, 'uint32') || strcmp(format, 'single')
  nSampsTotal = w.bytes/4;
elseif strcmp(format, 'int64') || strcmp(format, 'uint64') || strcmp(format, 'double')
  nSampsTotal = w.bytes/8;
else
  error(['Unsupported data format. '...
    'Supported formats are double, single, int8, int16, int32, int64, uint8, uint16, uint32, uint64']);
end
  
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
    dat = data(inds);
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