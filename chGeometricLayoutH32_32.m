function [correctedCh, correctedChAbs, conf, nChan] = chGeometricLayoutH32_32(probe, probeFlip)
% This function maps headstage channels onto recording site coordinates and
% outputs channel geometric correction order for H32 chronic probes
% connected to 32-channel headstages. At this stage assumes the headstage
% was RHD2132.
% Inputs: probe - probe name, e.g., 'H32_A1x32_Edge_5mm_20_177'.
%         probeFlip is either true or false.


% HEADSTAGE TO PROBE
% Arrange headstage pins to correspond to headstage channels 1 to 16
[headstageMap, ~, headstageConf] = RHD2132_32ch_headstageMap_ind2ch;
headstageCh = num2cell(sort(cell2mat(values(headstageMap))));
headstageMap = RHD2132_32ch_headstageMap_ch2ind;
headstagePins = cell2mat(values(headstageMap, headstageCh)); % on which pin of the headstage each channel is found

% Probe channels viewed from the headstage
[~, probeCh, probeOutConf] = probeChronicH32Map_ch2ind(probeFlip);
probeCh = fliplr(probeCh);

% Transformation
headstage2probe = num2cell(probeCh(headstagePins));


% HEADSTAGE TO COORDINATES
if strcmp(probe, 'H32-A1x32-Edge-5mm-20-177')
  [channelMap, ~, probeInConf] = A32_A1x32_Edge_5mm_20_177_probeMap(); % same as H32...
elseif strcmp(probe, 'H32-Buzsaki32-5mm-BUZ-200-160')
  [channelMap, ~, probeInConf] = A32_Buzsaki32_5mm_BUZ_200_160_probeMap(); % same as H32...
end
chCoords = cell2mat(values(channelMap,headstage2probe));


% CORRECTED HEADSTAGE CHANNEL ORDER
if strcmp(probe, 'H32-Buzsaki32-5mm-BUZ-200-160')
  chCoords = [chCoords(1:2:length(chCoords))' chCoords(2:2:length(chCoords))'];
  [~, sortedInd] = sort(chCoords(:,1),'ascend');
  chCoords = chCoords(sortedInd,:);
  chCoordsSh4 = chCoords(25:32,:);
  sortedIndSh4 = sortedInd(25:32,:);
  chCoordsSh3 = chCoords(17:24,:);
  sortedIndSh3 = sortedInd(17:24,:);
  chCoordsSh2 = chCoords(9:16,:);
  sortedIndSh2 = sortedInd(9:16,:);
  chCoordsSh1 = chCoords(1:8,:);
  sortedIndSh1 = sortedInd(1:8,:);

  [~, sortedInd] = sort(chCoordsSh1(:,2),'ascend');
  chCoordsSh1 = chCoordsSh1(sortedInd,:);
  sortedIndSh1 = sortedIndSh1(sortedInd);

  [~, sortedInd] = sort(chCoordsSh2(:,2),'ascend');
  chCoordsSh2 = chCoordsSh2(sortedInd,:);
  sortedIndSh2 = sortedIndSh2(sortedInd);
  
  [~, sortedInd] = sort(chCoordsSh3(:,2),'ascend');
  chCoordsSh3 = chCoordsSh3(sortedInd,:);
  sortedIndSh3 = sortedIndSh3(sortedInd);
  
  [~, sortedInd] = sort(chCoordsSh4(:,2),'ascend');
  chCoordsSh4 = chCoordsSh4(sortedInd,:);
  sortedIndSh4 = sortedIndSh4(sortedInd);

  sortedInd = [sortedIndSh1; sortedIndSh2; sortedIndSh3; sortedIndSh4];
  chCoords = [chCoordsSh1; chCoordsSh2; chCoordsSh3; chCoordsSh4];
else
  [~, sortedInd] = sort(chCoords,'ascend');
  chCoords = chCoords(sortedInd)';
end

headstageCh = cell2mat(headstageCh);
correctedCh = headstageCh(sortedInd);
correctedChAbs = 1:numel(headstageCh);
correctedChAbs = correctedChAbs(sortedInd);

nChan = numel(correctedChAbs);


% CONFIGURATION
conf.headstageConf = headstageConf;

conf.probeConf = probeInConf;
conf.probeConf.probe = probe;
conf.probeConf.out = probeOutConf.out;
if size(chCoords,2) == 2
  conf.probeConf.xcoords = torow(chCoords(:,1));
  conf.probeConf.ycoords = torow(chCoords(:,2));
elseif size(chCoords,2) == 1
  conf.probeConf.ycoords = torow(chCoords);
else
  error('Erroneous probe recording site coordinates');
end