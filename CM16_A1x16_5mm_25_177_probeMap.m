% Returns a containers.Map object, which for each channel gives its x,y
% position. The bottommost channel is taken as 0,0. In addition also
% provides a simple recording site map and probe configuration.

function [probeMap, siteMap, conf] = CM16_A1x16_5mm_25_177_probeMap

siteMap = [1 16 2 15 3 14 4 13 5 12 6 11 7 10 8 9];
vDist = 25; %um
ycoords = zeros(size(siteMap));

sites = 1:numel(siteMap);

probeMap = containers.Map('KeyType', 'int32', 'ValueType', 'any'); % a map from contact number to its x,y coordinates
for i = sites
  vPos = find(siteMap == i);
  probeMap(i) = (vPos-1)*vDist;
  ycoords(i) = (vPos-1)*vDist;
end

conf.probe = 'CM16-A1x16-5mm-25-177';
conf.chanMap = sites;
conf.chanMap0ind = sites-1;
conf.connected = logical(ones(size(siteMap))); %#ok<LOGL>
conf.shankInd = ones(size(siteMap));
conf.xcoords = zeros(size(siteMap));
conf.ycoords = ycoords;