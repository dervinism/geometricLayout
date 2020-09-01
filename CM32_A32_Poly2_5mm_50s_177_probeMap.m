% Returns a containers.Map object, which for each channel gives its x,y
% position. The bottommost channel is taken as 0,0. In addition also
% provides a simple recording site map and probe configuration.

function [probeMap, siteMap, conf] = CM32_A32_Poly2_5mm_50s_177_probeMap

siteMap = [16 15 14 13 12 11 01 02 03 04 05 06 07 08 09 10;
           17 18 19 20 21 22 32 31 30 29 28 27 26 25 24 23];
sites = 1:numel(siteMap);
       
vDist = 50; %um
hDist = 50; %um

ycoords = zeros(1,numel(siteMap));
xcoords = zeros(1,numel(siteMap));

probeMap = containers.Map('KeyType', 'int32', 'ValueType', 'any'); % a map from contact number to its x,y coordinates
for i = sites
  [hPos, vPos] = find(siteMap == i);
  ycoords(i) = (hPos-1)*(vDist/2) + (vPos-1)*vDist;
  xcoords(i) = (hPos-1)*hDist;
  probeMap(i) = [xcoords(i) ycoords(i)];
end

conf.probe = 'CM32-A32-Poly2-5mm-50s-177';
conf.chanMap = sites;
conf.chanMap0ind = sites-1;
conf.connected = logical(ones(1,numel(siteMap))); %#ok<LOGL>
conf.shankInd = ones(1,numel(siteMap));
conf.xcoords = xcoords;
conf.ycoords = ycoords;