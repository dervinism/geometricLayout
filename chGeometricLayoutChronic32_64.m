function [correctedCh, correctedChAbs, conf, nChan] = chGeometricLayoutChronic32_64(probe, probeFlip, headstage)
% This function maps headstage channels onto recording site coordinates and
% outputs channel geometric correction order for CM32 chronic probes
% connected to 64-channel headstages.
% Inputs: probe - probe name, e.g., 'CM32-A32-Poly2-5mm-50s-177'.
%         probeFlip - true or false.
%         headtsage - which headstage was used. At this stage presumes it
%                     was RHD2164, thus the value should be 'top' if the
%                     32ch probe was recorded using RHD2164's top bank, or
%                     'bottom' otherwise.


% HEADSTAGE TO PROBE
% Arrange headstage pins to correspond to headstage channels 1 to 16
if strcmpi(headstage, 'top')
  [headstageMap, ~, headstageConf] = RHD2164_headstageTopMap_ind2ch;
  headstageCh = num2cell(sort(cell2mat(values(headstageMap))));
  headstageMap = RHD2164_headstageTopMap_ch2ind;
elseif strcmpi(headstage, 'bottom')
  [headstageMap, ~, headstageConf] = RHD2164_headstageBottomMap_ind2ch;
  headstageCh = num2cell(sort(cell2mat(values(headstageMap))));
  headstageMap = RHD2164_headstageBottomMap_ch2ind;
else
  error('Wrong input')
end
headstagePins = cell2mat(values(headstageMap, headstageCh)); % on which pin of the headstage each channel is found

% Probe channels viewed from the headstage
[~, probeCh, probeOutConf] = probeChronic32Map_ch2ind(probeFlip);
probeCh = fliplr(probeCh);

% Transformation
headstage2probe = num2cell(probeCh(headstagePins));


% HEADSTAGE TO COORDINATES
if strcmp(probe, 'CM32-A32-Poly2-5mm-50s-177')
  [channelMap, ~, probeInConf] = CM32_A32_Poly2_5mm_50s_177_probeMap();
elseif strcmp(probe, 'CM32-A32-Poly3-5mm-25s-177')
  [channelMap, ~, probeInConf] = CM32_A32_Poly3_5mm_25s_177_probeMap();
elseif strcmp(probe, 'CM32-A1x32-6mm-100-177')
  [channelMap, ~, probeInConf] = CM32_A1x32_6mm_100_177_probeMap();
elseif strcmp(probe, 'CM32-A1x32-Edge-5mm-100-177')
  [channelMap, ~, probeInConf] = CM32_A1x32_Edge_5mm_100_177_probeMap();
end
chCoords = cell2mat(values(channelMap,headstage2probe));


% CORRECTED HEADSTAGE CHANNEL ORDER
if strcmp(probe, 'CM32-A32-Poly2-5mm-50s-177') || strcmp(probe, 'CM32-A32-Poly3-5mm-25s-177')
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