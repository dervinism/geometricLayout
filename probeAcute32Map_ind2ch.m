% Returns a containers.Map object, which for each probe output pin gives a
% correspong electrode channel number ID. Designed for an acute 32 channel
% probe (see https://neuronexus.com/images/Electrode%20Site%20Map/A32Maps_2013_11_22.pdf).
% In addition returns a simple probe pin map and configuration.
% Please follow Matlab linear indexing convention.

function [probeMap, probeOutputPins, conf] = probeAcute32Map_ind2ch

probeMap = containers.Map('KeyType', 'int32', 'ValueType', 'any');

probeOutputPins = [32 00 00 11;
                   30 00 00 09;
                   31 00 00 07;
                   28 00 00 05;
                   29 26 01 03;
                   27 24 04 02;
                   25 20 13 06;
                   22 19 14 08;
                   23 18 15 10;
                   21 17 16 12];

for i = 1:numel(probeOutputPins)
  probeMap(i) = probeOutputPins(i); 
end

conf.probe = 'Acute_32';
conf.out = probeOutputPins;