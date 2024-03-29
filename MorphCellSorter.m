clear variables
clc
close all


%% Get binary image files
% path ='C:/Users/march/Documents/MorphCellSorter_Tests/Dataset_Ischemie_fix�';
% path = 'C:/Users/march/Documents/MorphCellSorter_Tests/Dataset_Tamara';
% path ='C:/Users/march/Documents/MorphCellSorter_Tests/Alzeimer';
% path ='C:/Users/march/Documents/MorphCellSorter_Tests/Ischemia_in_vivo';
path = uigetdir('Select Folder containing the images');
saving_path = path;
[files, nFiles, fileNo, fileNames, images]= Open_Microglia_Images(path);
filePattern = fullfile(path,'*.tif');
theFiles = dir(filePattern);

answerParameters=questdlg('Do you want to compute the morphological parameters? If no, you will have to select the table with the parameters','Parameters','Yes','No','Yes');

if strcmpi('Yes',answerParameters)

    answerResolution=inputdlg({'Please enter the value of 1 pixel (in micrometer):'},'Resolution',[1 35]);
    resolution=str2num(answerResolution{1});
    
    %% Pre-allocating the variables
    somaArea=zeros(1, nFiles);
    perimAreaRatio=zeros(1, nFiles);
    circularity=zeros(1, nFiles);
    density=zeros(1, nFiles);
    roundFactor=zeros(1, nFiles);
    ramificationIndex=zeros(1, nFiles);
    convexity=zeros(1, nFiles);
    solidity=zeros(1, nFiles);
    convHullCircularity=zeros(1, nFiles);
    convHullRadii=zeros(1, nFiles);
    convHullSpanRatio=zeros(1, nFiles);
    cellArea=zeros(1, nFiles);
    cellPerimeter=zeros(1, nFiles);
    processesArea=zeros(1, nFiles);
    ratioProcessSomaArea=zeros(1, nFiles);
    ratioProcessCellArea=zeros(1, nFiles);
    fractalDimension=zeros(1, nFiles);
    nbBranchpoints=zeros(1, nFiles);
    nbEndpoints=zeros(1, nFiles);
    ratioSkeletonProcessArea=zeros(1, nFiles);
    ratioEndpointsBranchpoints=zeros(1, nFiles);
    totalIntersections=zeros(1, nFiles);
    criticalRadius=zeros(1, nFiles);
    dendriticMax=zeros(1, nFiles);
    branchingIndex=zeros(1, nFiles);
    polarizationIndex=zeros(1, nFiles);
    linearity=zeros(1, nFiles);
    inertiaCell=zeros(1, nFiles);
    lacunaritySlope=zeros(1, nFiles);
    lacunarityMean=zeros(1, nFiles);
    %%
    for n = 1:nFiles
    disp(n)
    X = images(n).R(:,:, 1);
    X = double(X);
    X = X/max(X(:));%X is the binarized microglia  

    %% soma Detection
    [somaArea(n), Gx, Gy, soma]= Cell_Body(X,resolution);

    %% Parameters computation
    contourCell=fftContour(X);
    cellPerimeter(n)=sum(contourCell(:))*resolution;                        % perimetre cellule
    cellArea(n)=sum(X(:))*resolution*resolution;                            % Surface cellule
    processesArea(n)= cellArea(n) - somaArea(n);
    perimAreaRatio=(sum(contourCell(:))*resolution).^2./(sum(image(:))*resolution*resolution);
    perimAreaRatio=log(perimAreaRatio)/log(10);

     circularity(n)=2*sqrt(pi*cellArea(n))/cellPerimeter(n);
     density(n)=cellArea(n)/(size(X,1)*size(X,2)*resolution*resolution);
     roundFactor(n)=roundnessFactor(X,somaArea(n),resolution);
     ramificationIndex(n)=(cellPerimeter(n)/cellArea(n))/(2*sqrt(pi/cellArea(n)));
    [convexity(n),solidity(n),convHullCircularity(n),convHullRadii(n),convHullSpanRatio(n)]=convexhull(X,resolution);
     processesArea(n)=cellArea(n)-somaArea(n);
     ratioProcessSomaArea(n)=processesArea(n)/somaArea(n);
     ratioProcessCellArea(n)=processesArea(n)/cellArea(n);
    [processSkeleton,nbBranchpoints(n),nbEndpoints(n),ratioSkeletonProcessArea(n),ratioEndpointsBranchpoints(n)]=morphoSkeleton(X,soma,processesArea(n),resolution);
    [totalIntersections(n),criticalRadius(n),dendriticMax(n),branchingIndex(n)]=Sholl2pixels(X,processSkeleton,soma,Gx,Gy,resolution);
     fractalDimension(n)=hausDim(X);
    [lacunaritySlope(n),lacunarityMean(n)]=lacunarity_glbox(X);
    [polarizationIndex(n),linearity(n)]=morphoPolarizationLinearity(X,Gx,Gy,resolution);
     inertiaCell(n)=inertia(X);
    end


    %% Save data in xls file
    % Set parameter names
    header ={'microglia','PerimeterAreaRatio','ModifiedCircularity','RoundnessFactor','RamificationIndex','Solidity','Convexity',...
    'ConvexHullRadiiRatio','SpanRatio','ConvexHullCircularity','ProcessesSomaAreasRatio','ProcessesCellAreasRatio','Density','BranchingIndex',...
    'EndpointsBranchpointsRatio','SkeletonProcessesRatio','FractalDimension','LacunaritySlope','PolarizationIndex','Linearity','Inertia'};

    % Set table values
    allParameters = table(fileNames', perimAreaRatio', circularity',roundFactor', ramificationIndex', solidity', convexity',...
     convHullRadii',convHullSpanRatio',convHullCircularity',ratioProcessSomaArea',ratioProcessCellArea',density', branchingIndex',...
     ratioEndpointsBranchpoints', ratioSkeletonProcessArea',fractalDimension',lacunaritySlope',polarizationIndex',linearity', inertiaCell','VariableNames', header);
    
    % Delete old output file if exists and save file
     if exist([saving_path './allparametersMATLAB.xlsx'],'file')== 2
        delete([saving_path './allparametersMATLAB.xlsx']);
     end
    writetable(allParameters,[saving_path './allparametersMATLAB.xlsx'],'WriteRowNames', true);

    clearvars -except fileNames fileNo filePattern files nFiles path saving_path theFiles allParameters

elseif strcmpi('No',answerParameters)
    
    [xlsFile,xlsPath]=uigetfile('*.xlsx','Select a table');
    allParameters=readtable(fullfile(xlsPath,xlsFile));
    
end
%%
% Get microglia names/ids
microgliaIds = string(allParameters.microglia);


%% PCA
% Compute PCA to get correlations with PCs
headers=allParameters.Properties.VariableNames(:,2:end);
[coefsPCA,scoresPCA,~,~,explainedPCA]=pca(normalize(allParameters{:,2:end}));
 figure()
 set(gcf, 'Position', get(0, 'Screensize'));
 biplot(coefsPCA(:,1:2),'scores', scoresPCA(:,1:2),'varlabels',headers);
 title('Correlation between Parameters and Principal Components - PCA with all parameters','FontSize', 20);
 grid on;



 figure()
 pareto(explainedPCA);
 xlabel('Principal Component','FontSize', 15);
 ylabel('Variance Explained(%)','FontSize', 15);
 title({'Explained Variance of Principal Components' 'PCA with all parameters'},'FontSize', 12);
 grid on;

 % Selection des parametres, poids selon les axes
 projectionAxe1=(coefsPCA(:, 1)).^2;

 sumAxe1=sum(projectionAxe1);
 coeffAxe1=projectionAxe1./sumAxe1*100;
 descendAxe1=sort(coeffAxe1,'descend');
 indexAxe1=zeros(length(descendAxe1),1);
 ascendAxe1=sort(coeffAxe1,'ascend');
 for i=1:length(descendAxe1)
     indexAxe1(i,1)=find(coeffAxe1==descendAxe1(i,1));
 end

allParamOrderedAxe1=allParameters(:,[1; indexAxe1+1]);
figure
plot(descendAxe1)
% hold on
% yyaxis right
% plot(listepar+1,xxx)
% yyaxis right
% plot(listepar,line0)
% legend("Parameters'relative weight on PC1","y_n - _n-1","Threshold")
% for i=1:19
%     t=i+1;
%     xxx(i,:)=descendAxe1(t-1,1)-descendAxe1(t,1)
% end

keep=2;
differenceKeep=0;

while differenceKeep<=0.2
    keep=keep+1;
    differenceKeep=descendAxe1(keep,1)-descendAxe1(keep+1,1);
end

if keep>6
    keep=6;
end
allParamOrderedAxe1(:,keep+2:end)=[];
for j=1:20
nom(j,1)=headers(1,indexAxe1(j,1));
end
clear headers coefsPCA scoresPCA explainedPCA 
headers=allParamOrderedAxe1.Properties.VariableNames(:,2:end);

%% Second PCA with selected parameters
 [coefsPCA,scoresPCA,~,~,explainedPCA]=pca(normalize(allParamOrderedAxe1{:,2:end}));
 % coefsPCA(:,1)=-coefsPCA(:,1);% MATLAB 2018a
 % scoresPCA(:, 1)=-scoresPCA(:, 1);% MATLAB 2018a
 coefsPCA = -coefsPCA;  % INVERSER TOUT LE MONDE (pas que pc1)
 scoresPCA = -scoresPCA;


% Plot of two principal components and categories
 figure()
 set(gcf, 'Position', get(0, 'Screensize'));
 biplot(coefsPCA(:,1:2),'scores', scoresPCA(:,1:2),'varlabels',headers);
 title('Correlation between selected Parameters and final Principal Components','FontSize', 20);
 grid on;

 figure()
 pareto(explainedPCA);
 xlabel('Principal Component','FontSize', 15);
 ylabel('Variance Explained(%)','FontSize', 15);
 title({'Explained Variance of final Principal Components'},'FontSize', 12);
 grid on;


%% Andrews Plots
x =-pi:0.01:pi;
% allParamOrderedAxe1{:,2:end} = normalize(allParamOrderedAxe1{:,2:end});
andrewsValues = scoresPCA(:, 1).*cos(x) ;%*explainedPCA(1);
% andrewsValues = scoresPCA(:, 1).*(cos(x)+sin(x))
k=1;
for n = 2:size(scoresPCA(:,:), 2)
    if rem(n,2)
        andrewsValues = andrewsValues + scoresPCA(:, n).*sin(k*x) ;%*explainedPCA(n);
        k=k+1;
    else
        andrewsValues = andrewsValues + scoresPCA(:, n).*cos(k*x) ;%*explainedPCA(n);
    end
end

% andrewsValuesVar=var(andrewsValues,1);% Get variance for all x
% [maxAndrewsValuesVar,maxAndrewsValuesVarIdx]=max(andrewsValuesVar);% Get the index of the x with the max variance
% andrewsValuesMaxVar=andrewsValues(:,maxAndrewsValuesVarIdx);% Get andrews values for which the variance is maximal

andrewsValuesMaxVar= - mean(andrewsValues(:,158:472),2); % opposite of the mean value between -pi/2 and pi/2
% andrewsValuesMaxVar= - trapz(andrewsValues(:,158:472),2);  % area under the curve
% andrewsValuesMaxVar= - sum(scoresPCA(:,:),2);  % sum of parameters

[andrewsValuesSortedMaxVar,andrewsValuesSortedIdxMaxVar]=sort(andrewsValuesMaxVar,1);% Sort andrews values of microglia
microgliaIdsSorted=fileNames(andrewsValuesSortedIdxMaxVar);% Get microglia ranking with sort

figure
plot(x,andrewsValues)
xlabel('x','FontSize',15)
ylabel('Andrews values','FontSize',15)
title('Andrews Plot','FontSize',20)

%% Display ranking
answerCondition=inputdlg({'Please enter the number of conditions:'},'Number of conditions',[1 35]);
nbConditions=str2num(answerCondition{1});
clear answerCondition

for t=1:nbConditions
    nameCond{1,t}=['Name Condition',num2str(t)];
end

nameConditions=inputdlg(nameCond,'Conditions name',[1 35]);
classes=zeros(1,nFiles);

for t=1:nbConditions
    findPattern=contains(fileNames,nameConditions{t,1});
    findidx=find(findPattern);
    classes(findidx)=t;
    clear findPattern findidx
end

classesIdsSorted=zeros(nFiles,1);

for i=1:nFiles
    numero(i,:)=find(fileNames(1,:)==microgliaIdsSorted(:,i));
    classesIdsSorted(i,1)=classes(:,numero(i,:));
end

%%
defaultColors=[0.4 0.7608 0.6470 ; 0.9882 0.5529 0.3843 ; 0.5529 0.6275 0.7961 ; 0.9059 0.5412 0.7647 ; 0.651 0.8471 0.3294 ; 1 0.851 0.1843 ; 0.8980 0.7686 0.5804 ; 1 1 1];

if nbConditions<=8
    answerColors=questdlg('Do you want to chose the display colors for your conditions?','Color display','Yes','No','No');
    if strcmpi('Yes',answerColors)
        for t=1:nbConditions
          colors(t,:)=uisetcolor(defaultColors(t,:),['Select color for Condition',num2str(t),' ',nameConditions{t,1}]);
        end
    elseif strcmpi('No',answerColors)
       colors=defaultColors;
    end
else
    for t=1:nbConditions
      colors(t,:)=uisetcolor([1 1 1],['Select color for Condition',num2str(t),' ',nameConditions{t,1}]);
    end
end
DisplayImages(path,colors, microgliaIdsSorted', classesIdsSorted)

%% Distributions
 for t=1:nbConditions
     groupe(t).R=find(classes(1,:)==t);
         for i=1:length(groupe(t).R)
             groupList(t).R(i,1)=andrewsValuesMaxVar((groupe(t).R(1,i)),1);
         end
 end
% Graphes distributions separes NORMALISE
 minCombined=zeros(1, nbConditions);
 maxCombined=zeros(1, nbConditions);
for t=1:nbConditions
    [minCombined(t), maxCombined(t)]= bounds(groupList(t).R);
end
 minC=min(minCombined(:));
 maxC=max(maxCombined(:));

 clear minCombined maxCombined

BE = linspace(minC, maxC, 20);

 for t=1:nbConditions
    bincounts(t).R = histcounts(groupList(t).R, BE,'Normalization','probability');
 end

% Distributions display

nbRows=round(nbConditions/2);
nbCols=round(nbConditions/nbRows);

figure()
set(gcf, 'Position', get(0, 'Screensize'));
 for t=1:nbConditions
     subplot(nbRows,nbCols,t)
     histogram('BinCounts', bincounts(t).R,'FaceColor',colors(t,:),'Facealpha',0.4,'BinEdges', BE)
     ylim([0,1])
     legend(nameConditions{t,1})
     xlabel('Andrews score','FontSize',15)
     ylabel('Normalized number of microglia','FontSize',15)
 end

figure()
 for t=1:nbConditions
    histogram('BinCounts', bincounts(t).R,'FaceColor',colors(t,:),'Facealpha',0.4,'BinEdges', BE)
    hold on
    legend(nameConditions)
    xlabel('Andrews score','FontSize',15)
    ylabel('Normalized number of microglia','FontSize',15)
    hold on
    legend
 end


%% Save all open figures in the saving file
FigList = findobj(allchild(0),'flat','Type','figure');
for iFig = 1:length(FigList)
 FigHandle = FigList(iFig);
 FigName =['Fig' num2str(iFig)];
 saveas(FigHandle, fullfile(saving_path,[FigName '.png']));
 saveas(FigHandle, fullfile(saving_path,[FigName '.fig']));
end

%% Save the ranking in the saving file

% Set algorithm names
tableHeader ={'rank','microglia'};

% Set table values
ranking=table((1:size(microgliaIdsSorted, 2))', microgliaIdsSorted','VariableNames', tableHeader);

% Delete old output file if exists and save file
if exist([saving_path './pca_andrews_rankings.xlsx'],'file')== 2
 delete([saving_path './pca_andrews_rankings.xlsx']);
end
writetable(ranking,[saving_path './pca_andrews_rankings.xlsx'],'WriteRowNames', true);

