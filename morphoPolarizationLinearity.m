function [polarizationIndex,linearity] = morphoPolarizationLinearity(image,Gx,Gy,resolution) 

    [cy,cx]=size(image);
    % Gravity center
    ux=(1:cx);
    uy=(1:cy);
    Gx1=sum(image*ux')/sum(image(:));
    Gx1=round(Gx1);
    Gy1=sum(uy*image)/sum(image(:));
    Gy1=round(Gy1);

    % Difference in x and y between the center of cell body and the gravity center
    deltaImage=Gx-Gx1;
    deltaY=Gy-Gy1;
    vectG=[deltaImage deltaY];
    
    % Distance between the center of cell body and the gravity center
    distance=norm(vectG);
      
    % Distance ratios
    polarizationIndex=distance*resolution/sqrt(sum(image(:))*resolution*resolution); % on the root of the area
    
    %Linearity 
     [listex,listey]=find(image);
     liste(:,1)=listex; 
     liste(:,2)=listey;

        for g=1:length(listey)
            liste(g,2)=abs(listey(g,:)-300);
        end
% figure()
% plot(listex,listey,'+')
     [coefsPCA,scoresPCA,~,~,~]=pca(normalize(liste));
     scoresPCA(:, 1)=-scoresPCA(:, 1);
 % figure()
 % set(gcf, 'Position', get(0, 'Screensize'));
 % biplot(coefsPCA(:,1:2),'scores', scoresPCA(:,1:2))
 % figure()
 % set(gcf, 'Position', get(0, 'Screensize'));
 % biplot(coefsPCA,'scores', scoresPCA)
 % axis equal

 
 
     variance(:,1)=var(scoresPCA(:,1));
     variance(:,2)=var(scoresPCA(:,2));
     linearity=max(variance(:))/min(variance(:));
end