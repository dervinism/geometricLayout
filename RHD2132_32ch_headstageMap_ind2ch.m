% Returns a containers.Map object, which for each headstage input pin gives
% channel number ID at the connector. Designed for the RHD2132 amplifier
% board (see http://intantech.com/RHD2132_RHD2216_amp_board.html).
% In addition returns a simple headstage pin map and configuration.
% Please follow Matlab linear indexing convention.

function [headstageMap, headstageCh, conf] = RHD2132_32ch_headstageMap_ind2ch

headstageMap = containers.Map('KeyType', 'int32', 'ValueType', 'any');

headstageCh = [23 22 21 20 19 18 17 16 15 14 13 12 11 10 09 08;
               24 25 26 27 28 29 30 31 00 01 02 03 04 05 06 07] + 1;

for i = 1:numel(headstageCh)
  headstageMap(i) = headstageCh(i);
end

conf.headstage = 'Intan_RHD2132_32ch';
conf.topIn = headstageCh;