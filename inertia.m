function inertia = inertia(image) 
    % Whole microglia inertia
    [y, x] = find(image);
    N = length(x);
    y = y./N;
    x = x/N;
    y = y - mean(y);
    x = x - mean(x);
    M = [x y]'*[x y];
    [~, vC] = eig(M);
    inertia = vC(2,2)/vC(1,1);
        if isnan(inertia)
            inertia = 0;
        end
        
end