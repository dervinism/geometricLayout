% Returns a containers.Map object, which for each channel gives its x,y
% position. The bottommost channel is taken as 0,0. In addition also
% provides a simple recording site map and probe configuration.

function [probeMap, siteMap, conf] = A32_A1x32_5mm_25_177_probeMap

siteMap = [1 32 2 31 3 30 4 29 5 28 6 27 7 26 8 25 9 24 10 23 11 22 12 21 13 20 14 19 15 18 16 17];
vDist = 25; %um
ycoords = zeros(size(siteMap));

probeMap = containers.Map('KeyType', 'int32', 'ValueType', 'any'); % a map from contact number to its x,y coordinates
for i = 1:numel(siteMap)
  vPos = find(siteMap == i);
  probeMap(i) = (vPos-1)*vDist;
  ycoords(i) = (vPos-1)*vDist;
end

conf.probe = 'A32-A1x32-5mm-25-177';
conf.chanMap = siteMap;
conf.chanMap0ind = siteMap-1;
conf.connected = logical(ones(size(siteMap))); %#ok<LOGL>
conf.shankInd = ones(size(siteMap));
conf.xcoords = zeros(size(siteMap));
conf.ycoords = ycoords;