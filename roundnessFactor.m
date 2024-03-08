function roundFactor = roundnessFactor(image,somaArea,resolution)
    % Axis
    [y,x] = find(image);
    y = y - mean(y);
    x = x - mean(x);
    M = [x y]'*[x y];
    [V, v] = eig(M);
    pXY = [x y]*V;
    axisLength = 2*std(pXY);
    roundFactor = 4*somaArea/(pi*((max(axisLength)*resolution)^2));
end