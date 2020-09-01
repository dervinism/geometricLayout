% Returns a containers.Map object, which for each channel gives its x,y
% position. The bottommost left-hand side channel is taken as 0,0. In
% addition also provides a simple recording site map and probe configuration.

function [probeMap, siteMap, conf] = CM16LP_A2x2_tet_3mm_150_150_121_probeMap

siteMap = [NaN NaN 004 NaN NaN NaN NaN 012 NaN NaN;
           NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN;
           002 NaN NaN NaN 007 010 NaN NaN NaN 015;
           NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN;
           NaN NaN 005 NaN NaN NaN NaN 013 NaN NaN;
           NaN NaN 003 NaN NaN NaN NaN 011 NaN NaN;
           NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN;
           001 NaN NaN NaN 008 009 NaN NaN NaN 016;
           NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN;
           NaN NaN 006 NaN NaN NaN NaN 014 NaN NaN];
siteMap = flipud(siteMap);
sites = 1:16;
           
tDist = sqrt(25^2 + 25^2)/4; %um
xCoords = zeros(1,16);
yCoords = zeros(1,16);

probeMap = containers.Map('KeyType', 'int32', 'ValueType', 'any'); % a map from contact number to its x,y coordinates
for i = sites
  [row,col] = find(siteMap == i);
  if row > 5
    yCoord = 150;
    row = row-5;
  else
    yCoord = 0;
  end
  yCoord = yCoord + (row-1)*tDist;
  yCoords(i) = yCoord;
  
  if col > 5
    xCoord = 150;
    col = col-5;
  else
    xCoord = 0;
  end
  xCoord = xCoord + (col-1)*tDist;
  xCoords(i) = xCoord;
  
  probeMap(i) = [xCoord yCoord];
end

conf.probe = 'CM16LP-A2x2-tet-3mm-150-150-121';
conf.chanMap = sites;
conf.chanMap0ind = sites-1;
conf.connected = logical(ones(size(sites))); %#ok<LOGL>
conf.shankInd = [ones(1,8) ones(1,8)*2];
conf.xcoords = xCoords;
conf.ycoords = yCoords;