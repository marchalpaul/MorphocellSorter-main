function [processSkeleton,nbBranchpoints,nbEndpoints,ratioSkeletonProcessArea,ratioEndpointsBranchpoints] = morphoSkeleton(image,soma,processArea,resolution) 
 
    skel=bwskel(logical(image));
    skelClean=bwareaopen(skel,4);
    skeleton=soma+skelClean;
    skeleton=skeleton-(skelClean&soma);
    processSkeleton=skeleton-soma;
    labelObj=bwlabel(skeleton);
    propsObj=regionprops(labelObj);

    %Branchpoints
    bp=bwmorph(skelClean,'branchpoints');
    bp=bp-(bp&soma);
    [xbp,ybp]=find(bp);
    for i=1:length(xbp)
        if bp(xbp(i)-1,ybp(i)-1)==1 || bp(xbp(i),ybp(i)-1)==1 || bp(xbp(i)+1,ybp(i)-1)==1 || bp(xbp(i)-1,ybp(i))==1 || bp(xbp(i)+1,ybp(i))==1 || bp(xbp(i)-1,ybp(i)+1)==1 || bp(xbp(i)+1,ybp(i)+1)==1 || bp(xbp(i),ybp(i)+1)==1
            bp(xbp(i),ybp(i))=0;
        end
    end

    %Endpoints
    ep=bwmorph(skelClean,'endpoints');
    ep=ep-(ep&soma);
    
    maxBout=max([propsObj.Area]);
    refineSkel=bwareaopen(skeleton,maxBout);

    
    flyingProc=refineSkel-soma;
    liste=find(flyingProc==-1);
    flyingProc(liste)=0;        
    
    labelProc=bwlabel(flyingProc);
    propsProc=regionprops(labelProc);
    
    %Variables
    if length(propsProc)>1
        nbEndpoints=sum(ep(:))-(length(propsProc)-1);
    else
        nbEndpoints=sum(ep(:));
    end
    nbBranchpoints=sum(bp(:));
    
   lengthSkel=sum(processSkeleton(:))*resolution;
   ratioSkeletonProcessArea=lengthSkel^2/processArea;
   if nbBranchpoints>0
        ratioEndpointsBranchpoints=nbEndpoints/nbBranchpoints;
   else
       ratioEndpointsBranchpoints=0;
   end
end
   
