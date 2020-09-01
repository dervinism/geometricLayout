% Returns a containers.Map object, which for each electrode channel number
% ID gives an output pin location. Designed for a chronic 32-channel probe
% (CM32; see http://neuronexus.com/wp-content/uploads/2018/07/CM32-Maps-20150126.pdf).
% In addition returns a simple probe pin map and configuration.
% Please follow Matlab linear indexing convention.

function [probeMap, probeOutputPins, conf] = probeChronic32Map_ch2ind(probeFlip)

if nargin < 1
  probeFlip = false;
end

probeMap = containers.Map('KeyType', 'int32', 'ValueType', 'any');

probeOutputPins = [21 22 24 26 28 30 20 19 14 13 03 05 07 09 11 12;
                   23 25 27 29 31 32 18 17 16 15 01 02 04 06 08 10];
if probeFlip
  probeOutputPins = fliplr(flipud(probeOutputPins)); %#ok<FLUDLR>
end

for i = 1:numel(probeOutputPins)
  probeMap(i) = find(probeOutputPins == i); 
end

conf.probe = 'Chronic_32';
conf.out = probeOutputPins;