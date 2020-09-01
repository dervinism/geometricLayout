% Returns a containers.Map object, which for each adaptor input pin gives a
% channel number ID at the headstage end. Designed for the
% Adpt-A64-OM32x2-sm adaptor
% (see https://neuronexus.com/images/Adaptor_Maps/Adpt-A64-OM32x2-sm.pdf).
% In addition also provides a simple pin map and adaptor configuration.
% Please follow Matlab linear indexing convention.

function [adptIMap, adptIPins, conf] = adaptorHeadInMap_ind2ch

adptIMap = containers.Map('KeyType', 'int32', 'ValueType', 'any');

adptIPins = [24 00 00 41;
             27 00 00 38;
             22 00 00 43;
             28 00 00 37;
             29 26 39 36;
             20 25 40 45;
             18 23 42 47;
             16 21 44 49;
             14 19 46 51;
             12 17 48 53];

for i = 1:numel(adptIPins)
  adptIMap(i) = adptIPins(i);
end

conf.adaptor = 'Adpt-A64-OM32x2-sm';
conf.headstageEndIn = adptIPins;