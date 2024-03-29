function [correctedCh, correctedChAbs, conf, nChan] = chGeometricLayoutAcute32_32(probe, adaptorFlip)
% This function maps headstage channels onto recording site coordinates and
% outputs channel geometric correction order for 32-channel acute probes
% connected to 32-channel headstages. At this stage assumes the headstage
% was RHD2132.
% Inputs: probe - probe name, e.g., 'A32-A1x32-Edge-5mm-20-177'
%         adaptorFlip - true if the adaptor was flipped upside-down during
%                      the recording.


% HEADSTAGE TO ADAPTOR
% Arrange headstage pins to correspond to headstage channels 17 to 48
[headstageMap, ~, headstageConf] = RHD2132_32ch_headstageMap_ind2ch;
headstageCh = num2cell(sort(cell2mat(values(headstageMap))));
headstageMap = RHD2132_32ch_headstageMap_ch2ind;
headstagePins = cell2mat(values(headstageMap, headstageCh)); % on which pin of the headstage each channel is found

% Adaptor channels viewed from the headstage
[~, adaptorOutCh, adaptorOutConf] = adaptorTopOutMap_ch2ind(adaptorFlip);
adaptorOutCh = fliplr(adaptorOutCh);

% Transformation
headstage2adaptor = num2cell(adaptorOutCh(headstagePins));


% HEADSTAGE TO PROBE
% Arrange adaptor pins to correspond to headstage channels 17 to 48
[adaptorInMap, ~, adaptorInConf] = adaptorProbeInMap_ch2ind;
adaptorInPins = cell2mat(values(adaptorInMap,headstage2adaptor));

% Probe channels viewed from the adaptor
if strcmp(probe, 'A16-CambridgeNeuroTech')
  [~, probeCh, probeOutConf] = probeAcute16Map_ch2ind;
else
  [~, probeCh, probeOutConf] = probeAcute32Map_ch2ind;
end
probeCh = fliplr(probeCh);

% Transformation
headstage2probe = num2cell(probeCh(adaptorInPins));


% HEADSTAGE TO COORDINATES
if strcmp(probe, 'A32-A1x32-Edge-5mm-20-177')
  [channelMap, ~, probeInConf] = A32_A1x32_Edge_5mm_20_177_probeMap();
elseif strcmp(probe, 'A32-A1x32-5mm-25-177')
  [channelMap, ~, probeInConf] = A32_A1x32_Edge_25_177_probeMap();
elseif strcmp(probe, 'A32-Buzsaki32-5mm-BUZ-200-160')
  [channelMap, ~, probeInConf] = A32_Buzsaki32_5mm_BUZ_200_160_probeMap();
elseif strcmp(probe, 'A32-A1x32-Poly3-5mm-25s-177')
  [channelMap, ~, probeInConf] = CM32_A32_Poly3_5mm_25s_177_probeMap();
  probeInConf.probe = 'A32-A1x32-Poly3-5mm-25s-177';
elseif strcmp(probe, 'A32-A1x32-Poly3-10mm-50-177')
  [channelMap, ~, probeInConf] = A32_A1x32_Poly3_10mm_50_177_probeMap();
elseif strcmp(probe, 'A16-CambridgeNeuroTech')
  [channelMap, ~, probeInConf] = A16_CambridgeNeuroTech_probeMap();
end
chCoords = cell2mat(values(channelMap,headstage2probe));


% CORRECTED HEADSTAGE CHANNEL ORDER
if strcmp(probe, 'A32-Buzsaki32-5mm-BUZ-200-160')
  chCoords = [chCoords(1:2:length(chCoords))' chCoords(2:2:length(chCoords))'];
  [~, sortedInd] = sort(chCoords(:,1),'ascend');
  chCoords = chCoords(sortedInd,:);
  chCoordsSh1 = chCoords(1:8,:);
  sortedIndSh1 = sortedInd(1:8,:);
  chCoordsSh2 = chCoords(9:16,:);
  sortedIndSh2 = sortedInd(9:16,:);
  chCoordsSh3 = chCoords(17:24,:);
  sortedIndSh3 = sortedInd(17:24,:);
  chCoordsSh4 = chCoords(25:32,:);
  sortedIndSh4 = sortedInd(25:32,:);

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
elseif strcmp(probe, 'A32-A1x32-Poly3-5mm-25s-177') || strcmp(probe, 'A32-A1x32-Poly3-10mm-50-177')
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

conf.adaptorConf = adaptorOutConf;
conf.adaptorConf.probeEndIn = adaptorInConf.probeEndIn;

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