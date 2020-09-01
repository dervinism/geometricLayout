 function filenameReversed = swapCARreverse(filename, medianFile, nChans, addMedian)
% Reverses channel reordering and adds median to each channel (if
% previously subtracted). The reversed dat file is saved under the old name
% but appended with _reversed.
%
% Input: filename should include the extension.
%        medianFile is a mat file containing the median trace and the swap
%          order.
%        nChans is optional. It should be specified only when there are
%          extra input channels in the recording file. This helps to
%          disambiguate electrode recordings from other input data.
%        addMedian - true or false for adding subtracted median. Default is
%          true.
%
% Output: filenameReversed is the name of the data file with reversed
%           channels.
%
% Should make chunk size as big as possible so that the medians of the
% channels differ little from chunk to chunk.

load(medianFile); %#ok<LOAD>

if nargin < 3
  nChans = numel(probe2headstageConf.probeConf.chanMap);
end

if nargin < 4
  addMedian = true;
end

swapOrder_temp = swapOrder;
for i = 1:numel(swapOrder_temp)
  swapOrder(i) = find(swapOrder_temp == i); %#ok<AGROW>
end
if numel(swapOrder) < nChans
  swapOrder = [swapOrder numel(swapOrder)+1:nChans];
end

chunkSize = 1000000;

fid = []; fidOut = [];

d = dir(filename);
nSampsTotal = d.bytes/nChans/2;
nChunksTotal = ceil(nSampsTotal/chunkSize);
try
  
  fid = fopen(filename, 'r');
  [pathstr, name, ext] = fileparts(filename);
  filenameReversed = [pathstr filesep name '_reversed' ext];
  fidOut = fopen(filenameReversed, 'w');
  
  chunkInd = 1;
  sampleCount = 0;
  while 1
    fprintf(1, 'chunk %d/%d\n', chunkInd, nChunksTotal);
    dat = fread(fid, [nChans chunkSize], '*int16');
    if ~isempty(dat)
      datSamples = size(dat,2);
      if addMedian && (exist('medianTrace','var') && ~isempty(medianTrace))
        median2Add = int16(repmat(medianTrace(sampleCount+1:sampleCount+datSamples),numel(swapOrder_temp),1));
      else
        median2Add = int16(repmat(zeros(size(sampleCount+1:sampleCount+datSamples)),numel(swapOrder_temp),1));
      end
      if addMedian && (exist('channelMedian','var') && ~isempty(channelMedian)) %#ok<*USENS,*NODEF>
        median2Add = median2Add + repmat(channelMedian(:,chunkInd),1,size(median2Add,2));
      end
      if numel(swapOrder_temp) < nChans
        median2Add = [median2Add; int16(zeros(1,size(median2Add,2)))]; %#ok<AGROW>
      end
      swappedDat = dat(swapOrder,:)+median2Add;
      fwrite(fidOut, swappedDat, 'int16');
      chunkInd = chunkInd+1;
      sampleCount = sampleCount + datSamples;
    else
      break
    end
  end
  if ~isempty(fid)
    fclose(fid);
  end
  if ~isempty(fidOut)
    fclose(fidOut);
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
