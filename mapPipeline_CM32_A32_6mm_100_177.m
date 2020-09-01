% Sanity check for channel mapping: CM32-A32-Poly2-5mm-50s-177

% Headstage (RHD2132_32):
% headstage = [46 44 42 40 38 36 34 32 30 28 26 24 22 20 18 16;
%              47 45 43 41 39 37 35 33 31 29 27 25 23 21 19 17] - 15; % Top
headstage = [49 51 53 55 57 59 61 63 01 03 05 07 09 11 13 15;
             48 50 52 54 56 58 60 62 00 02 04 06 08 10 12 14]; % Bottom
headstage(:, 1:8) = headstage(:, 1:8) - 31;
headstage(:, 9:16) = headstage(:, 9:16) + 1;

% Probe out (CM32):
probeOut = [21 22 24 26 28 30 20 19 14 13 03 05 07 09 11 12;
            23 25 27 29 31 32 18 17 16 15 01 02 04 06 08 10];

% Probe (CM32-A32-6mm-100-177):
 probe = [1 32 2 31 3 30 4 29 5 28 6 27 7 26 8 25 9 24 10 23 11 22 12 21 13 20 14 19 15 18 16 17];
 
 % Position:
 position = 01:32;

% Execute this line if probe was flipped
probeOut = fliplr(flipud(probeOut)); %#ok<FLUDLR>
           
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