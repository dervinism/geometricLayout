% Sanity check for channel mapping: CM32-A32-Poly2-5mm-50s-177

% Headstage (RHD2132_32):
 headstage = [24 23 22 21 20 19 18 17 16 15 14 13 12 11 10 09;
              25 26 27 28 29 30 31 32 01 02 03 04 05 06 07 08];

% Probe out (CM32):
probeOut = [21 22 24 26 28 30 20 19 14 13 03 05 07 09 11 12;
            23 25 27 29 31 32 18 17 16 15 01 02 04 06 08 10];

% Probe (CM32-A32-Poly2-5mm-50s-177):
 probe = [16 15 14 13 12 11 01 02 03 04 05 06 07 08 09 10;
          17 18 19 20 21 22 32 31 30 29 28 27 26 25 24 23];
 
 % Position:
 position = [01 03 05 07 09 11 13 15 17 19 21 23 25 27 29 31;
             02 04 06 08 10 12 14 16 18 20 22 24 26 28 30 32];

% Execute this line if probe was flipped
% probeOut = fliplr(flipud(probeOut)); %#ok<FLUDLR>
           
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