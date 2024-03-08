function [totalIntersections,criticalRadius,dendriticMax,branchingIndex] = Sholl2pixels(image,processSkeleton,soma,Gx,Gy,resolution) 
    
    [xbd,ybd]=find(bwmorph(soma,'remove'));
    
        for m=1:length(xbd) %boucle qui calcule la distance entre chaque point et centroide
         distCentroid(m,:)=norm([xbd(m);ybd(m)]-[Gy;Gx]);
        end

      distMaxCentroid=max(distCentroid);
      radius=round(distMaxCentroid)+1;

      [xsq,ysq]=find(processSkeleton);
       if length(xsq)>0

              for m=1:length(xsq) %boucle qui calcule la distance entre chaque point et centroide
                 distSkel(m,:)=round(norm([xsq(m);ysq(m)]-[Gy;Gx]));
              end

          [cy, cx] = size(image);
          N2 = max([Gx Gy (cx-Gx) (cy-Gy)]);
          nbRadius=round((N2-radius)/2)-2;
              for t=1:nbRadius
                  nbIntersections(:,t)=length(find(distSkel==radius)); 
                  radius=radius+2; 
              end

          totalIntersections=sum(nbIntersections);
          BI=0;

              for t=2:nbRadius
                  diffIntersections=nbIntersections(t)-nbIntersections(t-1);
                  if diffIntersections>0
                      BI=BI+((diffIntersections*(t*resolution)/sqrt(cx*cy)));
                  end
              end

          maxIntersections=find(nbIntersections==max(nbIntersections));
          criticalRadius=maxIntersections(1,1);
          dendriticMax=max(nbIntersections);
          branchingIndex=BI;  
       else
          totalIntersections=0;
          dendriticMax=0;
          criticalRadius=0;
          branchingIndex=0;
       end
end