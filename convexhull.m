function [convexity,solidity,convHullCircularity,convHullRadii,convHullSpanRatio] = convexhull(image,resolution) 
    contourCell=bwmorph(image,'remove');
    convexHull=bwconvhull(image);
    convexHullPerim=bwperim(convexHull);
    solidity=sum(image(:))/sum(convexHull(:));
    convexity=sum(convexHullPerim(:))/sum(contourCell(:));
    convHullCircularity=2*sqrt(pi*(sum(convexHull(:))*resolution*resolution))/(sum(convexHullPerim(:))*resolution);
    centCH=regionprops(convexHull,'Centroid');
    [xCvhp,yCvhp]=find(convexHullPerim);
        for z=1:length(xCvhp)
            distCH(z,:)=norm([xCvhp(z);yCvhp(z)]-[centCH.Centroid(2);centCH.Centroid(1)]);
        end
    largestRadiusCH=max(distCH)*resolution;
    smallestRadiusCH=min(distCH)*resolution;
    lengthAxisCvh=regionprops(convexHull,'MajorAxisLength','MinorAxisLength');
    convHullRadii=largestRadiusCH/smallestRadiusCH; %ratio largest radius CH / smallest
    convHullSpanRatio=(lengthAxisCvh.MajorAxisLength)/(lengthAxisCvh.MinorAxisLength); %ratio axe le plus grand/petit cvh
end