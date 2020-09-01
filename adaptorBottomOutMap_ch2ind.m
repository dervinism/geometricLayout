% Returns a containers.Map object, which for each adaptor channel number
% ID gives an output pin location at the bottom connector. Designed for the
% Adpt-A64-OM32x2-sm adaptor
% (see https://neuronexus.com/images/Adaptor_Maps/Adpt-A64-OM32x2-sm.pdf).
% In addition also provides a simple pin map and adaptor configuration.
% Please follow Matlab linear indexing convention.
% Input: adaptorFlip - true if the adaptor was flipped upside-down during
%                      the recording; default is false.

function [adptOMap, adptOPins, conf] = adaptorBottomOutMap_ch2ind(adaptorFlip)

if nargin < 1
  adaptorFlip = false;
end

adptOMap = containers.Map('KeyType', 'int32', 'ValueType', 'any');

adptOPins = [53 51 49 47 45 36 37 38 27 28 29 20 18 16 14 12;
             48 46 44 42 40 39 43 41 24 22 26 25 23 21 19 17];
if adaptorFlip
  adptOPins = fliplr(flipud(adptOPins)); %#ok<FLUDLR>
end

for i = 1:64
  if sum(any(adptOPins == i))
    adptOMap(i) = find(adptOPins == i);
  end
end

conf.adaptor = 'Adpt-A64-OM32x2-sm';
conf.bottomOut = adptOPins;