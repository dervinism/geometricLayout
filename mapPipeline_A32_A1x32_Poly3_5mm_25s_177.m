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
probeOut = [00 00 00 00;
            00 00 00 00;
            00 00 00 00;
            00 00 00 00;
            00 00 00 00;
            00 00 00 00;
            00 00 00 00;
            00 00 00 00;
            00 00 00 00;
            00 00 00 00;
            32 00 00 11;
            30 00 00 09;
            31 00 00 07;
            28 00 00 05;
            29 26 01 03;
            27 24 04 02;
            25 20 13 06;
            22 19 14 08;
            23 18 15 10;
            21 17 16 12];

% Probe (A32-A1x32-Poly3-5mm-25s-177):
probe{1} = [01 02 03 04 05 06 07 08 09 10];
probe{2} = [11 22 12 21 13 20 14 19 15 18 16 17];
probe{3} = [32 31 30 29 28 27 26 25 24 23];
 
% Position:
position = 1:32;


% Probe channels map onto probe recording positions as follows:
probeMap = zeros(1,numel(probeOut));
for i = 1:numel(probeOut)
  for sh = 1:numel(probe)
    iCh = find(probe{sh} == probeOut(i));
    if ~isempty(iCh)
      if sh == 2
        if iCh == 12
          probeMap(probeOut(i)) = 32;
        else
          probeMap(probeOut(i)) = 3*(iCh-1) + 1;
        end
      elseif sh == 1
        probeMap(probeOut(i)) = 1 + 3*(iCh-1) + 1;
      elseif sh == 3
        probeMap(probeOut(i)) = 2 + 3*(iCh-1) + 1;
      end
    end
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
adaptorOut = fliplr(flipud(adaptorOut)); %#ok<FLUDLR>

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
  if headstageMap_temp(i)
    headstageMap(i) = probeMap(headstageMap_temp(i));
  end
end

% Actual swap order:
swapOrder = zeros(size(headstageMap));
for i = 1:numel(headstageMap)
  swapOrder(i) = find(headstageMap == i);
end
swapOrder %#ok<NOPTS>