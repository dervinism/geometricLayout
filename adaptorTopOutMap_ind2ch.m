% Returns a containers.Map object, which for each adaptor output pin gives
% a channel number ID at the top connector. Designed for the
% Adpt-A64-OM32x2-sm adaptor
% (see https://neuronexus.com/images/Adaptor_Maps/Adpt-A64-OM32x2-sm.pdf).
% In addition also provides a simple pin map and adaptor configuration.
% Please follow Matlab linear indexing convention.
% Input: adaptorFlip - true if the adaptor was flipped upside-down during
%                      the recording; default is false.

function [adptOMap, adptOPins, conf] = adaptorTopOutMap_ind2ch(adaptorFlip)

if nargin < 1
  adaptorFlip = false;
end

adptOMap = containers.Map('KeyType', 'int32', 'ValueType', 'any');

adptOPins = [34 35 62 33 60 54 57 55 10 08 11 05 32 03 30 31;
             64 58 63 56 61 59 52 50 15 13 06 04 09 02 07 01];
if adaptorFlip
  adptOPins = fliplr(flipud(adptOPins)); %#ok<FLUDLR>
end

for i = 1:numel(adptOPins)
  adptOMap(i) = adptOPins(i);
end

conf.adaptor = 'Adpt-A64-OM32x2-sm';
conf.topOut = adptOPins;