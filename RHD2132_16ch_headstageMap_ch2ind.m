% Returns a containers.Map object, which for each headstage channel number ID
% gives an input pin location at the connector. Designed for the RHD2132 amplifier
% board (see http://intantech.com/RHD2132_16channel_amp_board.html).
% In addition returns a simple headstage pin map and configuration.
% Please follow Matlab linear indexing convention.

function [headstageMap, headstageCh, conf] = RHD2132_16ch_headstageMap_ch2ind

headstageMap = containers.Map('KeyType', 'int32', 'ValueType', 'any');

headstageCh = [19 18 17 16 15 14 13 12;
               20 21 22 23 08 09 10 11] - 7;

for i = 1:numel(headstageCh)
  if sum(any(headstageCh == i))
    headstageMap(i) = find(headstageCh == i);
  end
end

conf.headstage = 'Intan_RHD2132_16ch';
conf.topIn = headstageCh;