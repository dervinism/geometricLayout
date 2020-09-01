function [correctedCh, correctedChAbs, conf, nChan] = chGeometricLayoutChronic16(probe, probeFlip)
% This function maps headstage channels onto recording site coordinates and
% outputs channel geometric correction order for 16-channel chronic probes
% connected to 16-channel headstages.
% Inputs: probe - probe name, e.g., 'CM16LP-A2x2-tet-3mm-150-150-121'.
%         probeFlip - true if the probe was flipped upside-down during the
%                     recording.


% HEADSTAGE TO PROBE
% Arrange headstage pins to correspond to headstage channels 1 to 16
[headstageMap, ~, headstageConf] = RHD2132_16ch_headstageMap_ind2ch;
headstageCh = num2cell(sort(cell2mat(headstageMap.values)));
headstageMap = RHD2132_16ch_headstageMap_ch2ind;
headstagePins = cell2mat(headstageMap.values(headstageCh)); % on which pin of the headstage each channel is found

% Probe channels viewed from the headstage
[~, probeCh, probeOutConf] = probeChronic16Map_ch2ind(probeFlip);
probeCh = fliplr(probeCh);

% Transformation
headstage2probe = num2cell(probeCh(headstagePins));


% HEADSTAGE TO COORDINATES
if strcmpi(probe, 'CM16LP-A2x2-tet-3mm-150-150-121')
  [channelMap, ~, probeInConf] = CM16LP_A2x2_tet_3mm_150_150_121_probeMap();
elseif strcmpi(probe, 'CM16LP-A4x4-3mm-100-125-177')
  [channelMap, ~, probeInConf] = CM16LP_A4x4_3mm_100_125_177_probeMap();
elseif strcmpi(probe,'CM16LP-A1x16-Poly2-5mm-50s-177')
  [channelMap, ~, probeInConf] = CM16LP_A1x16_Poly2_5mm_50s_177_probeMap();
elseif strcmpi(probe,'CM16-A1x16-5mm-25-177')
  [channelMap, ~, probeInConf] = CM16_A1x16_5mm_25_177_probeMap();
end
chCoords = cell2mat(values(channelMap,headstage2probe));


% CORRECTED HEADSTAGE CHANNEL ORDER
if strcmp(probe, 'CM16LP-A2x2-tet-3mm-150-150-121')
  chCoords = [chCoords(1:2:length(chCoords))' chCoords(2:2:length(chCoords))'];
  [~, sortedInd] = sort(chCoords(:,1),'ascend');
  chCoords = chCoords(sortedInd,:);
  chCoordsSh1 = chCoords(1:8,:);
  sortedIndSh1 = sortedInd(1:8,:);
  chCoordsSh2 = chCoords(9:16,:);
  sortedIndSh2 = sortedInd(9:16,:);
  
  [~, sortedInd] = sort(chCoordsSh1(:,2),'ascend');
  chCoordsSh1 = chCoordsSh1(sortedInd,:);
  sortedIndSh1 = sortedIndSh1(sortedInd);
  
  [~, sortedInd] = sort(chCoordsSh2(:,2),'ascend');
  chCoordsSh2 = chCoordsSh2(sortedInd,:);
  sortedIndSh2 = sortedIndSh2(sortedInd);
  
  sortedInd = [sortedIndSh1; sortedIndSh2];
  chCoords = [chCoordsSh1; chCoordsSh2];
elseif strcmp(probe, 'CM16LP-A4x4-3mm-100-125-177')
  chCoords = [chCoords(1:2:length(chCoords))' chCoords(2:2:length(chCoords))'];
  [~, sortedInd] = sort(chCoords(:,1),'ascend');
  chCoords = chCoords(sortedInd,:);
  chCoordsSh1 = chCoords((13:16)-4*3,:);
  sortedIndSh1 = sortedInd((13:16)-4*3,:);
  chCoordsSh2 = chCoords((13:16)-4*2,:);
  sortedIndSh2 = sortedInd((13:16)-4*2,:);
  chCoordsSh3 = chCoords((13:16)-4*1,:);
  sortedIndSh3 = sortedInd((13:16)-4*1,:);
  chCoordsSh4 = chCoords((13:16)-4*0,:);
  sortedIndSh4 = sortedInd((13:16)-4*0,:);
  
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
elseif strcmpi(probe,'CM16LP-A1x16-Poly2-5mm-50s-177')
  chCoords = [chCoords(1:2:length(chCoords))' chCoords(2:2:length(chCoords))'];
  [~, sortedInd1] = sort(chCoords(:,1),'ascend');
  chCoords = chCoords(sortedInd1,:);
  [~, sortedInd2] = sort(chCoords(:,2),'ascend');
  sortedInd = sortedInd1(sortedInd2);
  chCoords = chCoords(sortedInd2,:);
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
conf.probeConf.out = probeOutConf.out;
if size(chCoords,2) == 2
  conf.probeConf.xcoords = torow(chCoords(:,1));
  conf.probeConf.ycoords = torow(chCoords(:,2));
elseif size(chCoords,2) == 1
  conf.probeConf.ycoords = torow(chCoords);
else
  error('Erroneous probe recording site coordinates');
end