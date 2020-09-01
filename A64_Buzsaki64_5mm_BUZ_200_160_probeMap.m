% Returns a containers.Map object, which for each channel gives its x,y
% position. The bottommost left-hand side channel is taken as 0,0. In
% addition also provides a simple recording site map and probe configuration.

function [probeMap, siteMap, conf] = A64_Buzsaki64_5mm_BUZ_200_160_probeMap

siteMap = [001 NaN 009 NaN 017 NaN 025 NaN;
           NaN 008 NaN 016 NaN 024 NaN 032;
           002 NaN 010 NaN 018 NaN 026 NaN;
           NaN 007 NaN 015 NaN 023 NaN 031;
           003 NaN 011 NaN 019 NaN 027 NaN;
           NaN 006 NaN 014 NaN 022 NaN 030;
           004 NaN 012 NaN 020 NaN 028 NaN;
           NaN 005 NaN 013 NaN 021 NaN 029];
siteMap = [siteMap 32+siteMap];
siteMap = flipud(siteMap);
sites = 1:64;

xCoords = [0 2 4 6 14.5 23 25 27];
xCoords = [xCoords 200+xCoords 400+xCoords 600+xCoords];
xCoords = [xCoords 800+xCoords];
yCoords = [140 100 60 20 0 40 80 120];
yCoords = [yCoords yCoords yCoords yCoords];
yCoords = [yCoords yCoords];

probeMap = containers.Map('KeyType', 'int32', 'ValueType', 'any'); % a map from contact number to its x,y coordinates
for i = sites
  probeMap(i) = [xCoords(i) yCoords(i)];
end

conf.probe = 'A64-Buzsaki64-5mm-BUZ-200-160';
conf.chanMap = sites;
conf.chanMap0ind = sites-1;
conf.connected = logical(ones(size(sites))); %#ok<LOGL>
conf.shankInd = [ones(1,8) ones(1,8)*2 ones(1,8)*3 ones(1,8)*4];
conf.shankInd = [conf.shankInd 4+conf.shankInd];
conf.xcoords = xCoords;
conf.ycoords = yCoords;