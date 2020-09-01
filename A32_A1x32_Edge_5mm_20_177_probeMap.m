% Returns a containers.Map object, which for each channel gives its x,y
% position. The bottommost channel is taken as 0,0. In addition also
% provides a simple recording site map and probe configuration.

function [probeMap, siteMap, conf] = A32_A1x32_Edge_5mm_20_177_probeMap

siteMap = 1:32;
vDist = 20; %um

probeMap = containers.Map('KeyType', 'int32', 'ValueType', 'any'); % a map from contact number to its x,y coordinates
for i = siteMap
  vPos = find(siteMap == i);
  probeMap(i) = (vPos-1)*vDist; 
end

conf.probe = 'A32-A1x32-Edge-5mm-20-177';
conf.chanMap = siteMap;
conf.chanMap0ind = siteMap-1;
conf.connected = logical(ones(size(siteMap))); %#ok<LOGL>
conf.shankInd = ones(size(siteMap));
conf.xcoords = zeros(size(siteMap));
conf.ycoords = (siteMap-1)*vDist;