function [channelMedian, medianTrace, nChansTotal, probeConfFile, outputFilename, outputFilenameReduced, nChans, swapOrder,...
  probe2headstageConf] = swapCAR(filename, probe, probeFlip, headstage, reorder, subtractMedian, chanMapFile, outputDir, deleteChans, nChansTotal)
% Subtracts median of each channel, then subtracts median of each time
% point, and finally swaps channels in the recording dat file so they are
% ordered geometrically with the tip of the electrode corresponding to the
% bottommost trace. Will also delete channels if instructed so. The new dat
% file is saved under the old name but appended with _swappedCAR or
% _swappedNoCAR. The median trace is saved in a mat file with the name
% appended _medianTrace. The same file also contains the channel swap order
% and the probe-to-headstage configuration. Finally, an extra mat file is
% saved under the name forPRB_*probe name*.mat. This file specifically
% stores channel map information later used by the AnPSD.m data analysis
% script.
%
% Input: filename should include the extension.
%        probe is a string specifying the probe type. Currently
%          supported probes are Neuropixels, A32-A1x32-Edge-5mm-20-177,
%          A32-A1x32-5mm-25-177, A32-Buzsaki32-5mm-BUZ-200-160,
%          A32-A1x32-Poly3-5mm-25s-177, A32-A1x32-Poly3-10mm-50-177,
%          A64-Buzsaki64-5mm-BUZ-200-160, A64-A4x4-tet-5mm-150-200-121,
%          CM16LP-A2x2-tet-3mm-150-150-121, CM16LP-A4x4-3mm-100-125-177,
%          CM16LP-A1x16-Poly2-5mm-50s-177, CM16-A1x16-5mm-25-177,
%          CM32-A32-Poly2-5mm-50s-177, CM32-A32-Poly3-5mm-25s-177,
%          CM32-A1x32-6mm-100-177, CM32-A1x32-Edge-5mm-100-177,
%          H32-A1x32-Edge-5mm-20-177, H32-Buzsaki32-5mm-BUZ-200-160, and
%          A16-CambridgeNeuroTech.
%        probeFlip - a logical that is true if the probe was connected
%          to the headstage upside-down during the recording session (the
%          labels on the headstage and probe connectors facing opposite
%          sides); default is false.
%        headstage is a string specifying the type of headstage used in
%          combination with the probe. Currently supported headstages are
%          RHD2132_16ch, RHD2132_32ch, RHD2164_top, RHD2164_bottom,
%          RHD2164, and Neuropixels.
%        reorder is either true or false for re-ordering channels.
%        subtractMedian is a logical with true for subtracting the median
%          and false otherwise.
%        chanMapFile a logical that if true, creates a channel map file
%          (forPRB...).
%        outputDir is optional, by default will write to the directory of
%          the input file.
%        deleteChans is optional. It is a vector with channels to be
%          deleted (specified according to the original order).
%        nChansTotal is optional. It is a cell array with the first element
%          being an EEG data channel configuration vector indicating which
%          channels from the original file are contained within the current
%          data file. If full original file is used, then the vector simply
%          corresponds to the original channels (1:end). The second element
%          in the array corresponds to the number of extra input channels
%          that are not electrode recordings. If the cell array is left
%          empty, the default number of EEG recording sites will be assumed
%          based on the probe configuration (probe). If only a single
%          element is supplied, it will be assumed to correspond to the EEG
%          channels only.
%
% Output: channelMedian is channel medians for each data chunk.
%         medianTrace is a median trace vector that is also written to a
%           mat file.
%         nChansTotal is the total number of recorded channels including
%           extra ones that are not on the probe.
%         probeConfFile is the name of the file containing probe
%           configuration details.
%         outputFilename is the name of the data file with swapped
%           channels.
%         outputFilenameReduced is the name of the data file with swapped
%           channels with extra input channels being excluded.
%         nChans is the number of recording sites on the probe.
%         swapOrder is the channel swapping order.
%         probe2headstageConf is the structure variable containing info on
%           probe-to-headstage configuration.
%
% Should make chunk size as big as possible so that the medians of the
% channels differ little from chunk to chunk.

if strcmp(probe, 'Neuropixels')
  [~, swapOrder, probe2headstageConf, nChans] = chGeometricLayoutNeuropixels;
elseif strcmpi(probe(1:3), 'A64')
  [~, swapOrder, probe2headstageConf, nChans] = chGeometricLayoutAcute64(probe, probeFlip);
elseif strcmpi(probe(1:3), 'A32') || strcmpi(probe(1:3), 'A16')
  if strcmpi(headstage, 'RHD2164_top')
    [~, swapOrder, probe2headstageConf, nChans] = chGeometricLayoutAcute32_64(probe, false, 'top');
  elseif strcmpi(headstage, 'RHD2164_bottom')
    [~, swapOrder, probe2headstageConf, nChans] = chGeometricLayoutAcute32_64(probe, true, 'bottom');
  elseif strcmpi(headstage, 'RHD2164')
    if ~probeFlip
      [~, swapOrder, probe2headstageConf, nChans] = chGeometricLayoutAcute32_64(probe, false, 'top');
    else
      [~, swapOrder, probe2headstageConf, nChans] = chGeometricLayoutAcute32_64(probe, true, 'bottom');
    end
  elseif strcmpi(headstage, 'RHD2132_32ch')
    [~, swapOrder, probe2headstageConf, nChans] = chGeometricLayoutAcute32_32(probe, probeFlip);
  end
elseif strcmpi(probe(1:4), 'CM16')
  [~, swapOrder, probe2headstageConf, nChans] = chGeometricLayoutChronic16(probe, probeFlip);
elseif strcmpi(probe(1:4), 'CM32')
  if strcmpi(headstage, 'RHD2164_top')
    [~, swapOrder, probe2headstageConf, nChans] = chGeometricLayoutChronic32_64(probe, probeFlip, 'top');
  elseif strcmpi(headstage, 'RHD2164_bottom')
    [~, swapOrder, probe2headstageConf, nChans] = chGeometricLayoutChronic32_64(probe, probeFlip, 'bottom');
  elseif strcmpi(headstage, 'RHD2132_32ch')
    [~, swapOrder, probe2headstageConf, nChans] = chGeometricLayoutChronic32_32(probe, probeFlip);
  end
elseif strcmpi(probe(1:3), 'H32')
  if strcmpi(headstage, 'RHD2164_top')
    [~, swapOrder, probe2headstageConf, nChans] = chGeometricLayoutH32_64(probe, probeFlip, 'top');
  elseif strcmpi(headstage, 'RHD2164_bottom')
    [~, swapOrder, probe2headstageConf, nChans] = chGeometricLayoutH32_64(probe, probeFlip, 'bottom');
  elseif strcmpi(headstage, 'RHD2132_32ch')
    [~, swapOrder, probe2headstageConf, nChans] = chGeometricLayoutH32_32(probe, probeFlip);
  end
end
if nargin < 9
  deleteChans = [];
end
if nargin < 10
  nChansTotal = nChans;
  chanConf = 1:nChans;
  chansIgnore = 0;  % channels to ignore when extra input is recorded.
else
  nChans = numel(nChansTotal{1});
  chanConf = nChansTotal{1};
  if numel(nChansTotal) == 2
    chansIgnore = nChansTotal{2};
  else
    chansIgnore = 0;
  end
  nChansTotal = nChans + chansIgnore;
end
if ~reorder
  swapOrder = 1:nChans;
end
if deleteChans
  deleteChansProbe = zeros(size(deleteChans));
  deleteChansProbeLogical = zeros(size(swapOrder));
  for iChan = 1:numel(deleteChans)
    deleteChansProbe(iChan) = find(swapOrder == deleteChans(iChan));
    deleteChansProbeLogical(deleteChans(iChan)) = 1;
    swapOrder(deleteChansProbe(iChan)) = [];
  end
end
chunkSize = 1000000;

fid = []; fidOut = []; fidOutReduced = [];

d = dir(filename);
nSampsTotal = d.bytes/nChansTotal/2;
nChunksTotal = ceil(nSampsTotal/chunkSize);
try
  
  [pathstr, name, ext] = fileparts(filename);
  fid = fopen(filename, 'r');
  if nargin < 8
    if subtractMedian
      if reorder
        outputFilename  = [pathstr filesep name '_swappedCAR' ext];
        outputFilenameReduced  = [pathstr filesep name '_swappedCAR_reduced' ext];
      else
        outputFilename  = [pathstr filesep name '_CAR' ext];
        outputFilenameReduced  = [pathstr filesep name '_CAR_reduced' ext];
      end
    else
      if reorder
        outputFilename  = [pathstr filesep name '_swappedNoCAR' ext];
        outputFilenameReduced  = [pathstr filesep name '_swappedNoCAR_reduced' ext];
      else
        outputFilename  = filename;
        outputFilenameReduced  = [pathstr filesep name '_reduced' ext];
      end
    end
    mdTraceFilename = [pathstr filesep name '_medianTrace.mat'];
  else
    if subtractMedian
      if reorder
        outputFilename  = [outputDir filesep name '_swappedCAR' ext];
        outputFilenameReduced  = [outputDir filesep name '_swappedCAR_reduced' ext];
      else
        outputFilename  = [outputDir filesep name '_CAR' ext];
        outputFilenameReduced  = [outputDir filesep name '_CAR_reduced' ext];
      end
    else
      if reorder
        outputFilename  = [outputDir filesep name '_swappedNoCAR' ext];
        outputFilenameReduced  = [outputDir filesep name '_swappedNoCAR_reduced' ext];
      else
        outputFilename  = filename;
        outputFilenameReduced  = [outputDir filesep name '_reduced' ext];
      end
    end
    mdTraceFilename = [outputDir filesep name '_medianTrace.mat'];
  end
  if reorder || subtractMedian
    fidOut = fopen(outputFilename, 'w');
    if chansIgnore
      %       fidOutReduced = fopen(outputFilenameReduced, 'w');
    else
      outputFilenameReduced = outputFilename;
    end
  end
  
  chunkInd = 1;
  channelMedian = [];
  if subtractMedian
%     medianTrace = zeros(1, nSampsTotal);
    % maybe needs to be 
    medianTrace = zeros(1, int32(nSampsTotal));
  else
    medianTrace = [];
  end
  if reorder || subtractMedian
    while 1
      fprintf(1, 'chunk %d/%d\n', chunkInd, nChunksTotal);
      dat = fread(fid, [nChansTotal chunkSize], '*int16');
      if ~isempty(dat)
        if chansIgnore
          extraChans = (size(dat,1)-chansIgnore+1):size(dat,1);
          datExtra = dat(end-chansIgnore+1:end,:); % separate extra input channels
          dat = dat(1:end-chansIgnore,:);
        else
          datExtra = [];
        end
        if subtractMedian
          if deleteChans
            chans2include = ones(1,size(dat,1));
            chans2include(deleteChans) = zeros(1,numel(deleteChans));
            chm = zeros(size(dat,1),1);
            chm(logical(chans2include)) = median(dat(logical(chans2include),:),2);
            dat = bsxfun(@minus, dat, int16(chm)); % subtract median of each channel
            tm = int16(median(dat(logical(chans2include),:),1));
          else
            chm = median(dat,2);
            dat = bsxfun(@minus, dat, chm); % subtract median of each channel
            tm = median(dat,1);
          end
          dat = bsxfun(@minus, dat, tm); % subtract median of each time point
        end
        swappedDat = dat(swapOrder,:);
        if chansIgnore
          %           fwrite(fidOutReduced, swappedDat(keepChansReduced,:), 'int16');
          swappedDat = [swappedDat; datExtra]; %#ok<AGROW> % add extra input channels
        end
        fwrite(fidOut, swappedDat, 'int16');
        if subtractMedian
          channelMedian = [channelMedian chm]; %#ok<AGROW>
          medianTrace((chunkInd-1)*chunkSize+1:(chunkInd-1)*chunkSize+numel(tm)) = tm;
        end
      else
        break
      end
      chunkInd = chunkInd+1;
    end
  end
  
  if reorder || subtractMedian
    save(mdTraceFilename, 'chunkSize', 'channelMedian', 'medianTrace', 'swapOrder', 'probe2headstageConf', '-v7.3');
  end
  chanMap = probe2headstageConf.probeConf.chanMap(1:nChans);
  chanMap0ind = probe2headstageConf.probeConf.chanMap0ind(1:nChans);
  connected = logical(probe2headstageConf.probeConf.connected(chanConf));
  shankInd = probe2headstageConf.probeConf.shankInd(chanConf);
  xcoords = probe2headstageConf.probeConf.xcoords(chanConf);
  ycoords = probe2headstageConf.probeConf.ycoords(chanConf);
  kcoords = probe2headstageConf.probeConf.shankInd(chanConf);
  if deleteChans
    chanMap = probe2headstageConf.probeConf.chanMap(1:numel(swapOrder));
    chanMap0ind = probe2headstageConf.probeConf.chanMap0ind(1:numel(swapOrder));
    connected = logical(probe2headstageConf.probeConf.connected(~deleteChansProbeLogical));
    shankInd = probe2headstageConf.probeConf.shankInd(~deleteChansProbeLogical);
    xcoords = probe2headstageConf.probeConf.xcoords(~deleteChansProbeLogical);
    ycoords = probe2headstageConf.probeConf.ycoords(~deleteChansProbeLogical);
    kcoords = probe2headstageConf.probeConf.shankInd(~deleteChansProbeLogical);
  end
  if chansIgnore
    chanMap = [chanMap zeros(1,chansIgnore)]; %#ok<*NASGU>
    chanMap0ind = [chanMap0ind zeros(1,chansIgnore)];
    connected = logical([connected zeros(1,chansIgnore)]);
    shankInd = [shankInd zeros(1,chansIgnore)];
    xcoords = [xcoords NaN(1,chansIgnore)];
    ycoords = [ycoords NaN(1,chansIgnore)];
    kcoords = [kcoords NaN(1,chansIgnore)];
    %     xcoords = [xcoords ones(1,chansIgnore)*(xcoords(end)-xcoords(end-1))];
    %     ycoords = [ycoords ones(1,chansIgnore)*(ycoords(end)-ycoords(end-1))];
  end
  if chanMapFile
    probeConfFile = [pathstr filesep 'forPRB_' probe2headstageConf.probeConf.probe '.mat'];
    save(probeConfFile, 'chanMap', 'chanMap0ind', 'connected', 'shankInd', 'xcoords', 'ycoords', 'kcoords', '-v7.3');
  else
    probeConfFile = [];
  end
  if ~isempty(fid)
    fclose(fid);
  end
  if ~isempty(fidOut)
    fclose(fidOut);
  end
  if ~isempty(fidOutReduced)
    fclose(fidOutReduced);
  end
  
catch me
  if ~isempty(fid)
    fclose(fid);
  end
  if ~isempty(fidOut)
    fclose(fidOut);
  end
  if ~isempty(fidOutReduced)
    fclose(fidOutReduced);
  end
  
  rethrow(me)
end

nChansTotal = nChansTotal - numel(deleteChans);
nChans = nChans - numel(deleteChans);
