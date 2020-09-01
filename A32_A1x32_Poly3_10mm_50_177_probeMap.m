% Returns a containers.Map object, which for each channel gives its x,y
% position. The bottommost channel is taken as 18,0. In addition also
% provides a simple recording site map and probe configuration.

function [probeMap, siteMap, conf] = A32_A1x32_Poly3_10mm_50_177_probeMap

siteMap{1} = [10 09 08 07 06 05 04 03 01 02];
siteMap{2} = [11 22 12 21 13 20 14 19 15 18 16 17];
siteMap{3} = [23 24 25 26 27 28 29 30 32 31];
nSites = 0;
for iMap = 1:numel(siteMap)
  nSites = nSites + numel(siteMap{iMap});
end
sites = 1:nSites;
       
vDist = 50; %um
hDist = 50; %um

ycoords = zeros(1,nSites);
xcoords = zeros(1,nSites);

probeMap = containers.Map('KeyType', 'int32', 'ValueType', 'any'); % a map from contact number to its x,y coordinates
for i = sites
  for iMap = 1:numel(siteMap)
    hPos = iMap;
    vPos = find(siteMap{iMap} == i);
    if vPos
      break
    end
  end
  ycoords(i) = (vPos-1)*vDist;
  if hPos == 1 || hPos == 3
    ycoords(i) = ycoords(i) + vDist;
  end
  xcoords(i) = (hPos-1)*hDist;
  probeMap(i) = [xcoords(i) ycoords(i)];
end

conf.probe = 'A32-A32-Poly3-10mm-50-177';
conf.chanMap = sites;
conf.chanMap0ind = sites-1;
conf.connected = logical(ones(1,nSites)); %#ok<LOGL>
conf.shankInd = ones(1,nSites);
conf.xcoords = xcoords;
conf.ycoords = ycoords;