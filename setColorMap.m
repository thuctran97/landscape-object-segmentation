function cmap = setColorMap()
cmap = [
    128 128 128   % Sky
    128 0 0       % Building
    192 192 192   % Pole
    128 64 128    % Road
    128 128 0     % Tree
    64 0 128      % Car
    64 64 0       % Pedestrian
    ];
cmap = cmap ./ 255;
end