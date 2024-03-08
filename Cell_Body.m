function [somaArea, Gx, Gy, soma] = Cell_Body(image,resolution)
    %%%% Cell_Body locates the cell body of a microglia (or cell having 
    %%%%    a similar structure)
    %%%%
    %%%% Inputs:
    %%%%    image: a segmented and binarized square image of the cell
    %%%%    resolution: number of micrometers in one pixel
    %%%% Outputs:
    %%%%    somaArea: number of pixels in the cell body
    %%%%    xop: image coordinate of the center of the cell body
    %%%%    yop: y coordinate of the center of the cell body
    %%%%    soma: image of the cell body
    
    %% Preprocessing

    [Wy, Wx] = size(image);

    Z = image;


    %% Compute the cell's center
    h = ones(3, 3);
    s = Inf;
    k = 1;
    while s > 0
        Zold = Z;
        Z = imerode(Z, h);
        s = sum(Z(:));
        Surface(k) = s;
        k = k+1;
    end

    Z = Zold;
    if max(Z(:))~=1
     indexv=find(Z>0);
     Z(indexv)=1;
    end
    [uy, ux] = find(Z == 1);
    xo = round(mean(ux));
    yo = round(mean(uy));
    

    %% Compute the Inertia Momentum
    [uy, ux] = find(image == 1);

    I = ((xo-ux).^2+(uy-yo).^2);
    I = sum(I(:));
    

    %% Morphological Growing
    h = [0 1 0; 1 1 1; 0 1 0];
    W = zeros(Wy, Wx);
    W(yo, xo) = 1;
    sto = 0;
    stn = 10000;
    Surf(1) = 1;
    k = 1;

    while stn ~= sto || sum(sum(W.*image)) ~= sum(image(:))
        k = k+1;
        sto = stn;
        W = imdilate(W, h);
        Wt = W.*image;
        stn = sum(Wt(:));
        Surf(k) = stn;
    end
    

    %% Build back the cell body
    NN = find(Surface<Surf(1:length(Surface)), 1, 'first');

    h1 = [1 0 1; 0 1 0; 1 0 1];
    h2 = [0 1 0; 1 1 1; 0 1 0];
    Xp = image;
    soma = image;

    if (I>50000)
        for n = 1:NN+2
            if sum(sum(imerode(Xp, h1))) > 0
                Xp = imerode(Xp, h1);
            end
            if sum(sum(imerode(soma, h2))) > 0
                soma = imerode(soma, h2);
            end
%             imshow(soma);
        end
        for n = 1:NN+1
            Xp = imdilate(Xp, h1);
            Xp = Xp.*image;
            soma = imdilate(soma, h2);
            soma = soma.*image;
%             imshow(soma);
        end
    else
        for n = 1:NN+1
            if sum(sum(imerode(Xp, h1))) > 0
                Xp = imerode(Xp, h1);
            end
            if sum(sum(imerode(soma, h2))) > 0
                soma = imerode(soma, h2);
            end
%             imshow(soma);
        end
        for n = 1:NN
            Xp = imdilate(Xp, h1);
            Xp = Xp.*image;
            soma = imdilate(soma, h2);
            soma = soma.*image;
%             imshow(soma);
        end
    end

    soma = (.5*(Xp+soma))>0.25;
    somaArea = sum(soma(:));
    [uy, ux] = find(soma>0);
    
    xop = round(mean(ux));
    yop = round(mean(uy));
    
    %% Postprocessing
    
    
     %   Remove checkboards
    [yXpp, xXpp] = find(soma);
    SOMA = soma;
    for n = 1:length(yXpp)
        for m = 1:length(xXpp)
            if soma(yXpp(n), xXpp(m)) ~= 0
                if soma(yXpp(n)+1, xXpp(m)) == 0 && soma(yXpp(n)-1, xXpp(m)) == 0 && soma(yXpp(n), xXpp(m)+1) == 0 && soma(yXpp(n), xXpp(m)-1) == 0
                    SOMA(yXpp(n), xXpp(m)) = 0;
                elseif soma(yXpp(n)+1, xXpp(m)) == 0 && soma(yXpp(n)-1, xXpp(m)) == 0 && soma(yXpp(n), xXpp(m)+1) == 0 ...
                    || soma(yXpp(n)-1, xXpp(m)) == 0 && soma(yXpp(n), xXpp(m)+1) == 0 && soma(yXpp(n), xXpp(m)-1) == 0 ...
                    || soma(yXpp(n)+1, xXpp(m)) == 0 && soma(yXpp(n)-1, xXpp(m)) == 0 && soma(yXpp(n), xXpp(m)-1) == 0 ...
                    || soma(yXpp(n)+1, xXpp(m)) == 0 && soma(yXpp(n), xXpp(m)+1) == 0 && soma(yXpp(n), xXpp(m)-1) == 0
                    SOMA(yXpp(n), xXpp(m)) = 0;
                end
            end
        end
    end
    soma = SOMA;
    
    % If more than one cell body are detected, select the one that has the biggest area
    props = regionprops(soma);

    if length(props) > 1        
        best = 0;
        score = -Inf;
        for reg = 1:length(props)
            regScore = props(reg).Area;
            if regScore > score
                best = reg;
                score = regScore; 
            end
        end

        for reg = 1:length(props)
            if reg ~= best
                soma(fix(props(reg).BoundingBox(2)):fix(props(reg).BoundingBox(2)+props(reg).BoundingBox(4)), ...
                    fix(props(reg).BoundingBox(1)):fix(props(reg).BoundingBox(1)+props(reg).BoundingBox(3))) = 0;
            end
        end

        xop = round(props(best).Centroid(1));
        yop = round(props(best).Centroid(2));
    end
    

    

    
    labCC=bwlabel(soma);
    propsCC=regionprops(labCC,'Area'); 
    areasoma= cat(1,propsCC.Area);
    if length(propsCC)>1
        surfCCmax=max(areasoma);
        Xpp2=bwareaopen(soma,surfCCmax);
        soma=image&Xpp2;
    end
    
        somaArea = sum(soma(:));
        
    if somaArea < 100
        XppEr=imerode(soma,strel('disk',1));
        indice=1;
    elseif somaArea > 300
        XppEr=imerode(soma,strel('disk',5));
        indice=2;
    else
        XppEr=imerode(soma,strel('disk',3));
        indice=3;
    end
    labCC2=bwlabel(XppEr);
    propsCC2=regionprops(labCC2,'Area'); 
    areasoma2 = cat(1,propsCC2.Area);
    if length(propsCC2)>1
        surfCCmax2=max(areasoma2);
        Xpp22=bwareaopen(XppEr,surfCCmax2); 
        if indice==1
            Xpp2n=imdilate(Xpp22,strel('disk',1));
        elseif indice==2
            Xpp2n=imdilate(Xpp22,strel('disk',2));
        else
            Xpp2n=imdilate(Xpp22,strel('disk',3));
        end
         soma=image&Xpp2n;
    end
    
    clear uy ux
    somaArea = sum(soma(:))*resolution*resolution;
    [uy, ux] = find(soma>0);
    
    Gx = round(mean(ux));
    Gy = round(mean(uy));
%     figure()
%     imagesc(image+soma)
%     hold on
%     plot(Gx,Gy,'r+')
%     pause

end
