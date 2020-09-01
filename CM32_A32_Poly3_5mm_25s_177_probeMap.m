% Returns a containers.Map object, which for each channel gives its x,y
% position. The bottommost channel is taken as 18,0. In addition also
% provides a simple recording site map and probe configuration.

function [probeMap, siteMap, conf] = CM32_A32_Poly3_5mm_25s_177_probeMap

siteMap{1} = [01 02 03 04 05 06 07 08 09 10];
siteMap{2} = [11 22 12 21 13 20 14 19 15 18 16 17];
siteMap{3} = [32 31 30 29 28 27 26 25 24 23];
nSites = 0;
for iMap = 1:numel(siteMap)
  nSites = nSites + numel(siteMap{iMap});
end
sites = 1:nSites;
       
vDist = 25; %um
hDist = 18; %um

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
    ycoords(i) = ycoords(i) + vDist/2;
  end
  xcoords(i) = (hPos-1)*hDist;
  probeMap(i) = [xcoords(i) ycoords(i)];
end

conf.probe = 'CM32-A32-Poly3-5mm-25s-177';
conf.chanMap = sites;
conf.chanMap0ind = sites-1;
conf.connected = logical(ones(1,nSites)); %#ok<LOGL>
conf.shankInd = ones(1,nSites);
conf.xcoords = xcoords;
conf.ycoords = ycoords;