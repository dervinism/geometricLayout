% Returns a containers.Map object, which for each channel gives its x,y
% position. The bottommost channel is taken as 0,0. In addition also
% provides a simple recording site map and probe configuration.

function [probeMap, siteMap, conf] = CM16LP_A1x16_Poly2_5mm_50s_177_probeMap

siteMap = [08 07 06 05 04 03 01 02;
           09 10 11 12 13 14 16 15];
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

conf.probe = 'CM16LP-A1x16-Poly2-5mm-50s-177';
conf.chanMap = sites;
conf.chanMap0ind = sites-1;
conf.connected = logical(ones(1,numel(siteMap))); %#ok<LOGL>
conf.shankInd = ones(1,numel(siteMap));
conf.xcoords = xcoords;
conf.ycoords = ycoords;