% Returns a containers.Map object, which for each channel gives its x,y
% position. The bottommost left-hand side channel is taken as 0,0. In
% addition also provides a simple recording site map and probe configuration.

function [probeMap, siteMap, conf] = CM16LP_A4x4_3mm_100_125_177_probeMap

siteMap = [1; 4; 2; 3];
siteMap = [siteMap (4*1)+siteMap (4*2)+siteMap (4*3)+siteMap];
siteMap = flipud(siteMap);
sites = 1:16;
           
xDist = 125; %um
yDist = 50; %um
xCoords = zeros(1,16);
yCoords = zeros(1,16);

probeMap = containers.Map('KeyType', 'int32', 'ValueType', 'any'); % a map from contact number to its x,y coordinates
for i = sites
  [row,col] = find(siteMap == i);
  xCoord = (col-1)*xDist;
  xCoords(i) = xCoord;
  yCoord = (row-1)*yDist;
  yCoords(i) = yCoord;
  
  probeMap(i) = [xCoord yCoord];
end

conf.probe = 'CM16LP-A4x4-3mm-100-125-177';
conf.chanMap = sites;
conf.chanMap0ind = sites-1;
conf.connected = logical(ones(size(sites))); %#ok<LOGL>
conf.shankInd = [ones(1,4) ones(1,4)*2 ones(1,4)*3 ones(1,4)*4];
conf.xcoords = xCoords;
conf.ycoords = yCoords;