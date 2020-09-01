% Returns a containers.Map object, which for each adaptor input pin gives a
% channel number ID at the probe end. Designed for the
% Adpt-A64-OM32x2-sm adaptor
% (see https://neuronexus.com/images/Adaptor_Maps/Adpt-A64-OM32x2-sm.pdf).
% In addition also provides a simple pin map and adaptor configuration.
% Please follow Matlab linear indexing convention.

function [adptIMap, adptIPins, conf] = adaptorProbeInMap_ind2ch

adptIMap = containers.Map('KeyType', 'int32', 'ValueType', 'any');

adptIPins = [10 00 00 55;
             15 00 00 50;
             08 00 00 57;
             13 00 00 52;
             06 11 54 59;
             04 05 60 61;
             09 32 33 56;
             02 03 62 63;
             07 30 35 58;
             01 31 34 64];

for i = 1:numel(adptIPins)
  adptIMap(i) = adptIPins(i);
end

conf.adaptor = 'Adpt-A64-OM32x2-sm';
conf.probeEndIn = adptIPins;