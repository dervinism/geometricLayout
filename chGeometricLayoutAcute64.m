function [correctedCh, correctedChAbs, conf, nChan] = chGeometricLayoutAcute64(probe, adaptorFlip)
% This function maps headstage channels onto recording site coordinates and
% outputs channel geometric correction order for 64-channel acute probes
% connected to 64 channel headstages.
% Inputs: probe - probe name, e.g., 'A64-A4x4-tet-5mm-150-200-121'.
%         adaptorFlip - true if the adaptor was flipped upside-down during
%                       the recording.


% HEADSTAGE TO ADAPTOR
% Arrange headstage channels to correspond to headstage pins
[headstageTopMap, ~, headstageTopConf] = RHD2164_headstageTopMap_ind2ch;
[headstageBottomMap, ~, headstageBottomConf] = RHD2164_headstageBottomMap_ind2ch;
headstageTopCh = num2cell(sort(cell2mat(values(headstageTopMap))));
headstageBottomCh = num2cell(sort(cell2mat(values(headstageBottomMap))));
headstageTopMap = RHD2164_headstageTopMap_ch2ind;
headstageBottomMap = RHD2164_headstageBottomMap_ch2ind;
headstageTopPins = cell2mat(values(headstageTopMap, headstageTopCh));
headstageBottomPins = cell2mat(values(headstageBottomMap, headstageBottomCh));

% Adaptor channels viewed from the headstage
[~, adaptorTopOutCh, adaptorTopOutConf] = adaptorTopOutMap_ch2ind;
adaptorTopOutCh = fliplr(adaptorTopOutCh);
[~, adaptorBottomOutCh, adaptorBottomOutConf] = adaptorBottomOutMap_ch2ind;
adaptorBottomOutCh = fliplr(adaptorBottomOutCh);

% Transformation
if adaptorFlip
  adaptorTopOutCh_temp = adaptorTopOutCh;
  adaptorTopOutCh = fliplr(flipud(adaptorBottomOutCh)); %#ok<*FLUDLR>
  adaptorBottomOutCh = fliplr(flipud(adaptorTopOutCh_temp));
  headstage2adaptorTop = num2cell(adaptorTopOutCh(headstageTopPins));
  headstage2adaptorBottom = num2cell(adaptorBottomOutCh(headstageBottomPins));
else
  headstage2adaptorTop = num2cell(adaptorTopOutCh(headstageTopPins));
  headstage2adaptorBottom = num2cell(adaptorBottomOutCh(headstageBottomPins));
end


% HEADSTAGE TO PROBE
% Arrange headstage channels to correspond to adaptor input pins
[adaptorHeadInMap, ~, adaptorHeadInConf] = adaptorHeadInMap_ch2ind;
if adaptorFlip
  adaptorHeadInPins = cell2mat(values(adaptorHeadInMap,headstage2adaptorTop));
else
  adaptorHeadInPins = cell2mat(values(adaptorHeadInMap,headstage2adaptorBottom));
end

[adaptorProbeInMap, ~, adaptorProbeInConf] = adaptorProbeInMap_ch2ind;
if adaptorFlip
  adaptorProbeInPins = cell2mat(values(adaptorProbeInMap,headstage2adaptorBottom));
else
  adaptorProbeInPins = cell2mat(values(adaptorProbeInMap,headstage2adaptorTop));
end

% Probe channels at the top output pin array viewed from the adaptor
[~, probeTopCh, probeTopOutConf] = probeAcute64TopMap_ch2ind;
probeTopCh = fliplr(probeTopCh);

% Probe channels at the bottom output pin array viewed from the adaptor
[~, probeBottomCh, probeBottomOutConf] = probeAcute64BottomMap_ch2ind;
probeBottomCh = fliplr(probeBottomCh);

% Transformation
headstage2probeTop = num2cell(probeTopCh(adaptorHeadInPins));
headstage2probeBottom = num2cell(probeBottomCh(adaptorProbeInPins));
if adaptorFlip
  headstage2probe = [headstage2probeBottom(1:16) headstage2probeTop headstage2probeBottom(17:32)];
else
  headstage2probe = [headstage2probeTop(1:16) headstage2probeBottom headstage2probeTop(17:32)];
end


% HEADSTAGE TO COORDINATES
if strcmp(probe, 'A64-Buzsaki64-5mm-BUZ-200-160')
  [channelMap, ~, probeInConf] = A64_Buzsaki64_5mm_BUZ_200_160_probeMap();
elseif strcmp(probe, 'A64-A4x4-tet-5mm-150-200-121')
  [channelMap, ~, probeInConf] = A64_A4x4_tet_5mm_150_200_121_probeMap();
end
chCoords = cell2mat(values(channelMap,headstage2probe));


% CORRECTED HEADSTAGE CHANNEL ORDER
if strcmp(probe, 'A64-Buzsaki64-5mm-BUZ-200-160')
  chCoords = [chCoords(1:2:length(chCoords))' chCoords(2:2:length(chCoords))'];
  [~, sortedInd] = sort(chCoords(:,1),'ascend');
  chCoords = chCoords(sortedInd,:);
  chCoordsSh1 = chCoords((57:64)-7*8,:);
  sortedIndSh1 = sortedInd((57:64)-7*8,:);
  chCoordsSh2 = chCoords((57:64)-6*8,:);
  sortedIndSh2 = sortedInd((57:64)-6*8,:);
  chCoordsSh3 = chCoords((57:64)-5*8,:);
  sortedIndSh3 = sortedInd((57:64)-5*8,:);
  chCoordsSh4 = chCoords((57:64)-4*8,:);
  sortedIndSh4 = sortedInd((57:64)-4*8,:);
  chCoordsSh5 = chCoords((57:64)-3*8,:);
  sortedIndSh5 = sortedInd((57:64)-3*8,:);
  chCoordsSh6 = chCoords((57:64)-2*8,:);
  sortedIndSh6 = sortedInd((57:64)-2*8,:);
  chCoordsSh7 = chCoords((57:64)-1*8,:);
  sortedIndSh7 = sortedInd((57:64)-1*8,:);
  chCoordsSh8 = chCoords((57:64)-0*8,:);
  sortedIndSh8 = sortedInd((57:64)-0*8,:);

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
  
  [~, sortedInd] = sort(chCoordsSh5(:,2),'ascend');
  chCoordsSh5 = chCoordsSh5(sortedInd,:);
  sortedIndSh5 = sortedIndSh5(sortedInd);
  
  [~, sortedInd] = sort(chCoordsSh6(:,2),'ascend');
  chCoordsSh6 = chCoordsSh6(sortedInd,:);
  sortedIndSh6 = sortedIndSh6(sortedInd);
  
  [~, sortedInd] = sort(chCoordsSh7(:,2),'ascend');
  chCoordsSh7 = chCoordsSh7(sortedInd,:);
  sortedIndSh7 = sortedIndSh7(sortedInd);
  
  [~, sortedInd] = sort(chCoordsSh8(:,2),'ascend');
  chCoordsSh8 = chCoordsSh8(sortedInd,:);
  sortedIndSh8 = sortedIndSh8(sortedInd);

  sortedInd = [sortedIndSh1; sortedIndSh2; sortedIndSh3; sortedIndSh4; sortedIndSh5; sortedIndSh6; sortedIndSh7; sortedIndSh8];
  chCoords = [chCoordsSh1; chCoordsSh2; chCoordsSh3; chCoordsSh4; chCoordsSh5; chCoordsSh6; chCoordsSh7; chCoordsSh8];
elseif strcmp(probe, 'A64-A4x4-tet-5mm-150-200-121')
  chCoords = [chCoords(1:2:length(chCoords))' chCoords(2:2:length(chCoords))'];
  [~, sortedInd] = sort(chCoords(:,1),'ascend');
  chCoords = chCoords(sortedInd,:);
  chCoordsSh1 = chCoords((49:64)-3*16,:);
  sortedIndSh1 = sortedInd((49:64)-3*16,:);
  chCoordsSh2 = chCoords((49:64)-2*16,:);
  sortedIndSh2 = sortedInd((49:64)-2*16,:);
  chCoordsSh3 = chCoords((49:64)-1*16,:);
  sortedIndSh3 = sortedInd((49:64)-1*16,:);
  chCoordsSh4 = chCoords((49:64)-0*16,:);
  sortedIndSh4 = sortedInd((49:64)-0*16,:);

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
end

headstageCh = cell2mat([headstageBottomCh(1:16) headstageTopCh headstageBottomCh(17:32)]);
correctedCh = headstageCh(sortedInd);
correctedChAbs = 1:numel(headstageCh);
correctedChAbs = correctedChAbs(sortedInd);

nChan = numel(correctedChAbs);


% CONFIGURATION
conf.headstageConf = headstageTopConf;
conf.headstageConf.bottomIn = headstageBottomConf.bottomIn;

conf.adaptorConf = adaptorTopOutConf;
if adaptorFlip
  conf.adaptorConf.bottomOut = conf.adaptorConf.topOut;
  conf.adaptorConf.topOut = adaptorBottomOutConf.bottomOut;
else
  conf.adaptorConf.bottomOut = adaptorBottomOutConf.bottomOut;
end
conf.adaptorConf.headstageEndIn = adaptorHeadInConf.headstageEndIn;
conf.adaptorConf.probeEndIn = adaptorProbeInConf.probeEndIn;

conf.probeConf = probeInConf;
conf.probeConf.topOut = probeTopOutConf.topOut;
conf.probeConf.bottomOut = probeBottomOutConf.bottomOut;
if size(chCoords,2) == 2
  conf.probeConf.xcoords = torow(chCoords(:,1));
  conf.probeConf.ycoords = torow(chCoords(:,2));
elseif size(chCoords,2) == 1
  conf.probeConf.ycoords = torow(chCoords);
else
  error('Erroneous probe recording site coordinates');
end