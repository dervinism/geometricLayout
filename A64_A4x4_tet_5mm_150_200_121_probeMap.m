% Returns a containers.Map object, which for each channel gives its x,y
% position. The bottommost left-hand side channel is taken as 0,0. In
% addition also provides a simple recording site map and probe configuration.

function [probeMap, siteMap, conf] = A64_A4x4_tet_5mm_150_200_121_probeMap

siteMap = [NaN NaN 009 NaN NaN;
           NaN NaN NaN NaN NaN;
           006 NaN NaN NaN 012;
           NaN NaN NaN NaN NaN;
           NaN NaN 008 NaN NaN;
           NaN NaN 010 NaN NaN;
           NaN NaN NaN NaN NaN;
           004 NaN NaN NaN 013;
           NaN NaN NaN NaN NaN;
           NaN NaN 007 NaN NaN;
           NaN NaN 011 NaN NaN;
           NaN NaN NaN NaN NaN;
           002 NaN NaN NaN 015;
           NaN NaN NaN NaN NaN;
           NaN NaN 005 NaN NaN;
           NaN NaN 014 NaN NaN;
           NaN NaN NaN NaN NaN;
           001 NaN NaN NaN 016;
           NaN NaN NaN NaN NaN;
           NaN NaN 003 NaN NaN];
siteMap = [siteMap 16+siteMap 32+siteMap 48+siteMap];
siteMap = flipud(siteMap);
sites = 1:64;
           
tDist = sqrt(25^2 + 25^2)/4; %um
xCoords = zeros(1,numel(sites));
yCoords = zeros(1,numel(sites));

probeMap = containers.Map('KeyType', 'int32', 'ValueType', 'any'); % a map from contact number to its x,y coordinates
for i = sites
  [row,col] = find(siteMap == i);
  if row > 15
    yCoord = 3*150;
    row = row-15;
  elseif row > 10
    yCoord = 2*150;
    row = row-10;
  elseif row > 5
    yCoord = 150;
    row = row-5;
  else
    yCoord = 0;
  end
  yCoord = yCoord + (row-1)*tDist;
  yCoords(i) = yCoord;
  
  if col > 15
    xCoord = 3*200;
    col = col-15;
  elseif col > 10
    xCoord = 2*200;
    col = col-10;
  elseif col > 5
    xCoord = 200;
    col = col-5;
  else
    xCoord = 0;
  end
  xCoord = xCoord + (col-1)*tDist;
  xCoords(i) = xCoord;
  
  probeMap(i) = [xCoord yCoord];
end

conf.probe = 'A64-A4x4-tet-5mm-150-200-121';
conf.chanMap = sites;
conf.chanMap0ind = sites-1;
conf.connected = logical(ones(size(sites))); %#ok<LOGL>
conf.shankInd = [ones(1,16) ones(1,16)*2 ones(1,16)*3 ones(1,16)*4];
conf.xcoords = xCoords;
conf.ycoords = yCoords;