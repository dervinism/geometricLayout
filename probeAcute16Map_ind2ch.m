% Returns a containers.Map object, which for each probe output pin gives a
% correspong electrode channel number ID. Designed for an acute 16 channel
% probe (see the manuals folder:
% R:\Neuropix\Shared\Code\sortingPipeline\geometric_layout\manuals\CambridgeNeuroTech.png).
% In addition returns a simple probe pin map and configuration.
% Please follow Matlab linear indexing convention.

function [probeMap, probeOutputPins, conf] = probeAcute16Map_ind2ch

probeMap = containers.Map('KeyType', 'int32', 'ValueType', 'any');

probeOutputPins = fliplr([00 00 00 16;
                          00 00 00 14;
                          07 00 00 15;
                          05 00 00 12;
                          03 01 00 13;
                          02 04 10 11;
                          06 00 00 09;
                          08 00 00 00;
                          00 00 00 00;
                          00 00 00 00]);

for i = 1:numel(probeOutputPins)
  probeMap(i) = probeOutputPins(i); 
end

conf.probe = 'Acute_16';
conf.out = probeOutputPins;