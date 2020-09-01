% Sanity check for channel mapping: A32-A1x32-Poly3-5mm-25s-177

% Headstage (RHD2132_32):
 headstage = [24 23 22 21 20 19 18 17 16 15 14 13 12 11 10 09;
              25 26 27 28 29 30 31 32 01 02 03 04 05 06 07 08];

% Probe out (CM32):
probeOut = [21 22 24 26 28 30 20 19 14 13 03 05 07 09 11 12;
            23 25 27 29 31 32 18 17 16 15 01 02 04 06 08 10];

% Probe (A32-A1x32-Poly3-5mm-25s-177):
 probe{1} = [01 02 03 04 05 06 07 08 09 10];
 probe{2} = [11 22 12 21 13 20 14 19 15 18 16 17];
 probe{3} = [32 31 30 29 28 27 26 25 24 23];
 
 % Position:
 position = 1:32;

% Execute this line if probe was flipped
%probeOut = fliplr(flipud(probeOut)); %#ok<FLUDLR>
           
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