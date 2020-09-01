% Returns a containers.Map object, which for each channel number
% ID  (1-32) gives an output pin location at the top connector. Designed
% for H32 probes (see http://neuronexus.com/wp-content/uploads/2018/07/H32-Maps-20150121.pdf )
% In addition returns a simple probe pin map and configuration.
% Please follow Matlab linear indexing convention.

function [H32OMap, probeOutputPins, conf] = probeChronicH32Map_ch2ind(probeFlip)

if nargin < 1
  probeFlip = false;
end

H32OMap = containers.Map('KeyType', 'int32', 'ValueType', 'any');

probeOutputPins = [ ...
  18 27 28 29 17 30 31 32 01 02 03 16 04 05 06 15;
  20 21 22 23 19 24 25 26 07 08 09 14 10 11 12 13];
if probeFlip
  probeOutputPins = fliplr(flipud(probeOutputPins)); %#ok<FLUDLR>
end

for i = 1:32
    H32OMap(i) = find(probeOutputPins == i);
end

conf.probe = 'H32';
conf.out   = probeOutputPins;