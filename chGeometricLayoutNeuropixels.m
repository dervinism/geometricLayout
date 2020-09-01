function [correctedCh, correctedChAbs, conf, nChan] = chGeometricLayoutNeuropixels
% This function outputs channel geometric correction order and
% configuration details for the Neuropixels probe.

% CHANNEL MAP AND COORDINATES
[probeMap, correctedCh, probeInConf] = Neuropixels_probeMap();
correctedCh = sort(correctedCh(~isnan(correctedCh)));
correctedChAbs = correctedCh;
nChan = size(probeMap,1);

% CONFIGURATION
conf.headstageConf = [];

conf.adaptorConf = [];
conf.adaptorConf.probeEndIn = [];

conf.probeConf = probeInConf;
conf.probeConf.out = [];