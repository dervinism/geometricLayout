% Returns a containers.Map object, which for each headstage input pin gives
% channel number ID at the top connector. Designed for the
% RHD2164 amplifier board (see http://intantech.com/RHD2164_amp_board.html).
% In addition returns a simple headstage pin map and configuration.
% Please follow Matlab linear indexing convention.

function [headstageMap, headstageCh, conf] = RHD2164_headstageTopMap_ind2ch

headstageMap = containers.Map('KeyType', 'int32', 'ValueType', 'any');

headstageCh = [46 44 42 40 38 36 34 32 30 28 26 24 22 20 18 16;
               47 45 43 41 39 37 35 33 31 29 27 25 23 21 19 17] + 1;

for i = 1:numel(headstageCh)
  headstageMap(i) = headstageCh(i);
end

conf.headstage = 'Intan_RHD2164';
conf.topIn = headstageCh;