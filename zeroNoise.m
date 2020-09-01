 function outputFilename = zeroNoise(filename, nChans, chans2zero, times2zero, sr, delOriginal)
% The function zeroes out the noise in the recording by replacing the noisy
% parts with the median of the recording data. It should be used in cases
% where there are periods of large amplitude noise in the recording that
% severely compromises spike sorting by introdusing unwanted periodicity in
% spike autocorrelograms.
%
% Input: data filename should include the full path and the extension.
%        nChans is the total number of channels in the recording.
%        chans2zero is a vector of channels for which zeroing should be
%          applied. You are supposed to leave the pupil data channel out.
%        times2zero is a cell array with entries corresponding to time
%          periods to be zeroed out. Specify periods by giving the
%          beginning and ending of the time period in seconds.
%        sr is the sampling frequency. The default is 3e4.
%        delOriginal is true if the original file is to be deleted.
%          Otherwise it is false.
%
% Output: outputFilename is a string with the name of the file containing
%           the zeroed out data.

if nargin < 6
  delOriginal = false;
end

chunkSize = 1000000;

fid = []; fidOut = [];

d = dir(filename);
nSampsTotal = d.bytes/nChans/2;
nChunksTotal = ceil(nSampsTotal/chunkSize);

chans2zeroInd = zeros(nChans,1);
chans2zeroInd(chans2zero) = ones(numel(chans2zero),1);

startChunks = zeros(1,numel(times2zero));
endChunks = zeros(1,numel(times2zero));
startTimes = zeros(1,numel(times2zero));
endTimes = zeros(1,numel(times2zero));
for iTimes = 1:numel(times2zero)
  startTimes(iTimes) = times2zero{iTimes}(1)*sr;
  endTimes(iTimes) = times2zero{iTimes}(2)*sr;
  startChunks(iTimes) = ceil(startTimes(iTimes)/chunkSize);
  endChunks(iTimes) = ceil(endTimes(iTimes)/chunkSize);
  startTimes(iTimes) = round((startTimes(iTimes) - chunkSize*(startChunks(iTimes)-1)));
  endTimes(iTimes) = round((endTimes(iTimes) - chunkSize*(endChunks(iTimes)-1)));
end

try
  
  [pathstr, name, ext] = fileparts(filename);
  fid = fopen(filename, 'r');
  outputFilename = [pathstr filesep name '_zeroedOut' ext]; %#ok<*AGROW>
  fidOut = fopen(outputFilename, 'w');
  
  chunkInd = 1;
  timeInd = 1;
  while 1
    fprintf(1, 'chunk %d/%d\n', chunkInd, nChunksTotal);
    dat = fread(fid, [nChans chunkSize], '*int16');
    if ~isempty(dat)
      tm = median(median(dat,1));
      if chunkInd == startChunks(timeInd)
        if chunkInd == endChunks(timeInd)
          dat(logical(chans2zeroInd),startTimes(timeInd):endTimes(timeInd)) = tm*int16(ones(sum(chans2zeroInd),numel(startTimes(timeInd):endTimes(timeInd))));
          timeInd = min([numel(times2zero) timeInd + 1]);
        else
          dat(logical(chans2zeroInd),startTimes(timeInd):chunkSize) = tm*int16(ones(sum(chans2zeroInd),numel(startTimes(timeInd):chunkSize)));
        end
      elseif chunkInd > startChunks(timeInd)
        if chunkInd == endChunks(timeInd)
          dat(logical(chans2zeroInd),1:endTimes(timeInd)) = tm*int16(ones(sum(chans2zeroInd),numel(1:endTimes(timeInd))));
          timeInd = min([numel(times2zero) timeInd + 1]);
        elseif chunkInd < endChunks(timeInd)
          dat(logical(chans2zeroInd),1:chunkSize) = tm*int16(ones(sum(chans2zeroInd),numel(1:chunkSize)));
        end
      end
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
