% Sanity check for channel mapping: A64-A4x4-tet-5mm-150-200-121

% Headstage (RHD2164):
 headstage = [46 44 42 40 38 36 34 32 30 28 26 24 22 20 18 16;
              47 45 43 41 39 37 35 33 31 29 27 25 23 21 19 17;
              49 51 53 55 57 59 61 63 01 03 05 07 09 11 13 15;
              48 50 52 54 56 58 60 62 00 02 04 06 08 10 12 14] + 1;
            
            
% Adaptor out:
adaptorOut = [34 35 62 33 60 54 57 55 10 08 11 05 32 03 30 31;
              64 58 63 56 61 59 52 50 15 13 06 04 09 02 07 01;
              53 51 49 47 45 36 37 38 27 28 29 20 18 16 14 12;
              48 46 44 42 40 39 43 41 24 22 26 25 23 21 19 17];


% Adaptor in:
adaptorIn = [24 00 00 41;
             27 00 00 38;
             22 00 00 43;
             28 00 00 37;
             29 26 39 36;
             20 25 40 45;
             18 23 42 47;
             16 21 44 49;
             14 19 46 51;
             12 17 48 53;
             10 00 00 55;
             15 00 00 50;
             08 00 00 57;
             13 00 00 52;
             06 11 54 59;
             04 05 60 61;
             09 32 33 56;
             02 03 62 63;
             07 30 35 58;
             01 31 34 64];


% Probe out (A64):
probeOut = [41 00 00 24;
            38 00 00 27;
            43 00 00 22;
            37 00 00 28;
            36 39 26 29;
            45 40 25 20;
            47 42 23 18;
            49 44 21 16;
            51 46 19 14;
            53 48 17 12;
            55 00 00 10;
            50 00 00 15;
            57 00 00 08;
            52 00 00 13;
            59 54 11 06;
            61 60 05 04;
            56 33 32 09;
            63 62 03 02;
            58 35 30 07;
            64 34 31 01];

% Probe (A64-A4x4-tet-5mm-150-200-121):
 probe = [03 01 16 14 05 02 15 11 07 04 13 10 08 06 12 09;
          19 17 32 30 21 18 31 27 23 20 29 26 24 22 28 25;
          35 33 48 46 37 34 47 43 39 36 45 42 40 38 44 41;
          51 49 64 62 53 50 63 59 55 52 61 58 56 54 60 57];
 
 % Position:
 position = [01:16;
             17:32;
             33:48;
             49:64];


% Probe channels map onto probe recording positions as follows:
probeMap = zeros(1,numel(probeOut));
for i = 1:numel(probeOut)
  if probeOut(i)
    probeMap(probeOut(i)) = find(probe == probeOut(i));
  end
end

% Probe channels map onto the physical space of the probe as follows:
probeMap_temp = probeMap;
for i = 1:numel(probeMap_temp)
  if probeMap_temp(i)
    probeMap(i) = position(probeMap_temp(i));
  end
end

% Adaptor channels map onto adaptor input pins as follows:
adaptorMap = zeros(1,numel(adaptorOut));
for i = 1:numel(adaptorOut)
  adaptorMap(adaptorOut(i)) = find(adaptorIn == adaptorOut(i));
end

% Headstage channels map onto headstage pin positions as follows:
headstage = fliplr(headstage);
headstageMap = zeros(1,numel(headstage));
for i = 1:numel(headstage)
  headstageMap(i) = find(headstage == i);
end

% Execute this line if adaptor was flipped
% adaptorOut = fliplr(flipud(adaptorOut)); %#ok<FLUDLR>

% Headstage channels map onto adaptor channels as follows:
headstageMap_temp = headstageMap;
for i = 1:numel(headstageMap_temp)
  headstageMap(i) = adaptorOut(headstageMap_temp(i));
end

% Headstage channels map onto adaptor input pins as follows:
headstageMap_temp = headstageMap;
for i = 1:numel(headstageMap_temp)
  headstageMap(i) = adaptorMap(headstageMap_temp(i));
end

% Headstage channels map onto probe channels as follows:
probeOut = fliplr(probeOut);
headstageMap_temp = headstageMap;
for i = 1:numel(headstageMap_temp)
  headstageMap(i) = probeOut(headstageMap_temp(i));
end

% Headstage channels map onto the physical space of the probe as follows:
headstageMap_temp = headstageMap;
for i = 1:numel(headstageMap_temp)
  headstageMap(i) = probeMap(headstageMap_temp(i));
end

% Actual swap order:
swapOrder = zeros(size(headstageMap));
for i = 1:numel(headstageMap)
  swapOrder(i) = find(headstageMap == i);
end
swapOrder %#ok<NOPTS>