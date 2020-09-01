% Returns a containers.Map object, which for each electrode channel number
% ID gives an output pin location. Designed for the top output pin array of
% an acute 64 channel probe (see
% https://drive.google.com/file/d/1hIO4GQzeN4RhHQgu_0icUSWFfC5p5dp0/view).
% In addition returns a simple probe pin map and configuration.
% Please follow Matlab linear indexing convention.

function [probeMap, probeOutputPins, conf] = probeAcute64TopMap_ch2ind

probeMap = containers.Map('KeyType', 'int32', 'ValueType', 'any');

probeOutputPins = [41 00 00 24;
                   38 00 00 27;
                   43 00 00 22;
                   37 00 00 28;
                   36 39 26 29;
                   45 40 25 20;
                   47 42 23 18;
                   49 44 21 16;
                   51 46 19 14;
                   53 48 17 12];

for i = 1:32
  probeMap(i) = find(probeOutputPins == i); 
end

conf.probe = 'Acute_64';
conf.topOut = probeOutputPins;