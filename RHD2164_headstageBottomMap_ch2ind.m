% Returns a containers.Map object, which for each headstage channel number
% ID gives an input pin location at the bottom connector. Designed for the
% RHD2164 amplifier board (see http://intantech.com/RHD2164_amp_board.html).
% In addition returns a simple headstage pin map and configuration.
% Please follow Matlab linear indexing convention.

function [headstageMap, headstageCh, conf] = RHD2164_headstageBottomMap_ch2ind

headstageMap = containers.Map('KeyType', 'int32', 'ValueType', 'any');

headstageCh = [49 51 53 55 57 59 61 63 01 03 05 07 09 11 13 15;
               48 50 52 54 56 58 60 62 00 02 04 06 08 10 12 14] + 1;

for i = min(min(headstageCh)):max(max(headstageCh))
  if sum(any(headstageCh == i))
    headstageMap(i) = find(headstageCh == i);
  end
end

conf.headstage = 'Intan_RHD2164';
conf.bottomIn = headstageCh;