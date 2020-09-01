% Returns a containers.Map object, which for each channel gives its x,y
% position. In addition also provides a simple recording site map and probe
% configuration.

function [probeMap, siteMap, conf] = Neuropixels_probeMap()

nSites = 384; 
sites = 1:nSites;
connectedSites = ones(size(sites));
% unconnectedSites = [37 76 113 152 189 228 265 304 341 380];
% connectedSites(unconnectedSites) = zeros(size(unconnectedSites));

siteIDs = sites;
siteIDs(~connectedSites) = NaN;
hDim = 4;
vDim = round(nSites/2);
basicMotive = [1 0 1 0 0 1 0 1];
eMapExt = repmat(basicMotive,1,vDim/2);
eMap1(logical(eMapExt)) = siteIDs';
eMap1(~logical(eMapExt)) = NaN;
eMap1 = reshape(eMap1,hDim,vDim);
eMap1 = rot90(eMap1',2);
eMap2 = eMap1(:,[2 1 4 3]);
%   eMap3 = fliplr(eMap1);
%   eMap4 = fliplr(eMap2);
siteMap = eMap2;

hStart = 11; %um
hDist = 16; %um
hMotive = [hStart+2*hDist hStart+0*hDist hStart+3*hDist hStart+1*hDist];
xCoords = repmat(hMotive', round(nSites/hDim), 1);
vDist = 20; %um
vMotive = 1:vDim;
yCoords = zeros(size(sites))';
yCoords(1:2:nSites) = vMotive.*vDist;
yCoords(2:2:nSites) = vMotive.*vDist;

probeMap = containers.Map('KeyType', 'int32', 'ValueType', 'any'); % a map from contact number to its x,y coordinates
for i = 1:nSites
  site = find(sites == i);
  probeMap(site) = [xCoords(i) yCoords(i)]; %#ok<FNDSB>
end

conf.probe = 'Neuropixels';
conf.chanMap = sites;
conf.chanMap0ind = sites-1;
conf.connected = connectedSites;
conf.shankInd = ones(size(sites));
conf.xcoords = xCoords';
conf.ycoords = yCoords';