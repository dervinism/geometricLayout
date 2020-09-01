% Returns a containers.Map object, which for each electrode channel number
% ID gives an output pin location. Designed for the bottom output pin array
% of an acute 64 channel probe (see
% https://drive.google.com/file/d/1hIO4GQzeN4RhHQgu_0icUSWFfC5p5dp0/view).
% In addition returns a simple probe pin map and configuration.
% Please follow Matlab linear indexing convention.

function [probeMap, probeOutputPins, conf] = probeAcute64BottomMap_ch2ind

probeMap = containers.Map('KeyType', 'int32', 'ValueType', 'any');

probeOutputPins = [55 00 00 10;
                   50 00 00 15;
                   57 00 00 08;
                   52 00 00 13;
                   59 54 11 06;
                   61 60 05 04;
                   56 33 32 09;
                   63 62 03 02;
                   58 35 30 07;
                   64 34 31 01];

for i = 1:32
  probeMap(i) = find(probeOutputPins == i); 
end

conf.probe = 'Acute_64';
conf.bottomOut = probeOutputPins;