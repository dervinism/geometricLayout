% Sanity check for channel mapping: CM16LP-A16-Poly2-5mm-50s-177

% Headstage (RHD2132_16):
 headstage = [19 18 17 16 15 14 13 12;
              20 21 22 23 08 09 10 11] - 7;

% Probe out (CM16):
probeOut = [12 11 10 09 08 07 06 05;
            16 15 14 13 04 03 02 01];

% Probe (CM16LP-A16-Poly2-5mm-50s-177):
 probe = [1 16 2 15 3 14 4 13 5 12 6 11 7 10 8 9];
 
 % Position:
 position = 1:16;

% Execute this line if probe was flipped
%probeOut = fliplr(flipud(probeOut)); %#ok<FLUDLR>
           
% Probe channels map onto probe recording positions as follows:
probeMap = zeros(1,numel(probeOut));
for i = 1:numel(probeOut)
  probeMap(probeOut(i)) = find(probe == probeOut(i));
end

% Probe channels map onto the physical space of the probe as follows:
for i = 1:numel(probeOut)
  probeMap(i) = position(probeMap(i));
end

% Headstage channels map onto headstage pin positions as follows:
headstage = fliplr(headstage);
headstageMap = zeros(1,numel(headstage));
for i = 1:numel(probeOut)
  headstageMap(i) = find(headstage == i);
end

% Headstage channels map onto probe channels as follows:
for i = 1:numel(probeOut)
  headstageMap(i) = probeOut(headstageMap(i));
end

% Headstage channels map onto the physical space of the probe as follows:
for i = 1:numel(probeOut)
  headstageMap(i) = probeMap(headstageMap(i));
end

% Actual swap order:
swapOrder = zeros(size(headstageMap));
for i = 1:numel(headstageMap)
  swapOrder(i) = find(headstageMap == i);
end
swapOrder %#ok<NOPTS>