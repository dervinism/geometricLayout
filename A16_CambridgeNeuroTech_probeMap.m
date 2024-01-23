% Returns a containers.Map object, which for each channel gives its x,y
% position. The bottommost channel is taken as 0,0. In addition also
% provides a simple recording site map and probe configuration.

function [probeMap, siteMap, conf] = A16_CambridgeNeuroTech_probeMap

% Real map:                        these are dummy channels
siteMap = [11 15 06 08 14 12 13 09 17 18 19 20 21 22 23 24;
           10 16 02 03 07 05 01 04 25 26 27 28 29 30 31 32];
sites = unique(siteMap)';

% OpenEphys-converted map              these are dummy channels
convSiteMap = [02 07 25 22 09 05 03 06 01 08 10 12 13 14 15 16;
               04 11 27 29 31 28 26 24 17 18 19 20 21 23 30 32];
convertedSites = unique(convSiteMap)';
       
vDist = 25; %um
hDist = 22.5; %um

ycoords = zeros(1,numel(siteMap));
xcoords = zeros(1,numel(siteMap));

probeMap = containers.Map('KeyType', 'int32', 'ValueType', 'any'); % a map from contact number to its x,y coordinates
for i = sites
  [hPos, vPos] = find(convSiteMap == convertedSites(i));
  ycoords(i) = (hPos-1)*(vDist/2) + (vPos-1)*vDist;
  xcoords(i) = (hPos-1)*hDist;
  probeMap(i) = [xcoords(i) ycoords(i)];
end

conf.probe = 'A16-CambridgeNeuroTech';
conf.chanMap = convertedSites;
conf.chanMap0ind = convertedSites-1;
conf.connected = logical(ones(1,numel(siteMap))); %#ok<LOGL>
conf.shankInd = ones(1,numel(siteMap));
conf.xcoords = xcoords;
conf.ycoords = ycoords;