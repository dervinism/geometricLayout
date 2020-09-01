% Returns a containers.Map object, which for each probe output pin gives a
% correspong electrode channel number ID. Designed for a chronic 16-channel probe
% (CM16/CM16LP; see https://drive.google.com/file/d/1Gp0va6F1HoZy5Q8d_yMV6s5IofnXyMe9/view).
% In addition returns a simple probe pin map and configuration.
% Please follow Matlab linear indexing convention.

function [probeMap, probeOutputPins, conf] = probeChronic16Map_ind2ch(probeFlip)

if nargin < 1
  probeFlip = false;
end

probeMap = containers.Map('KeyType', 'int32', 'ValueType', 'any');

probeOutputPins = [12 11 10 09 08 07 06 05;
                   16 15 14 13 04 03 02 01];
if probeFlip
  probeOutputPins = fliplr(flipud(probeOutputPins)); %#ok<FLUDLR>
end

for i = 1:numel(probeOutputPins)
  probeMap(i) = probeOutputPins(i); 
end

conf.probe = 'Chronic_16';
conf.out = probeOutputPins;