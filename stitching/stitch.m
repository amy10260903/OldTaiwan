clear all; close all; clc;
%% first image
Image1 = imread('1.png');
imshow(Image1);

%% Mouse input
xlabel ('Select at most 100 points along the outline', 'FontName', '微軟正黑體', 'FontSize', 14);
[ ctrlPointX, ctrlPointY ] = ginput(100);
ctrlPointList1 = [ctrlPointX ctrlPointY];
clickedN = size(ctrlPointList1,1);

promptStr = sprintf('%d points selected', clickedN);
xlabel (promptStr, 'FontName', '微軟正黑體', 'FontSize', 14);


%% Draw control points
imshow(Image1);
ctrlPointColor = [0.4 0.7 1.0]; %Blue
axis equal
hold on
scatter( ctrlPointList1(:,1), ctrlPointList1(:,2), 25, 'MarkerEdgeColor', ctrlPointColor, 'LineWidth',3 );

%% second image
Image2 = imread('1.jpg');
figure;
imshow(Image2);

%% Mouse input
xlabel ('Select the same number of points along the outline', 'FontName', '微軟正黑體', 'FontSize', 14);
[ ctrlPointX, ctrlPointY ] = ginput(clickedN);
ctrlPointList2 = [ctrlPointX ctrlPointY];

promptStr = sprintf('%d points selected', clickedN);
xlabel (promptStr, 'FontName', '微軟正黑體', 'FontSize', 14);


%% Draw control points
imshow(Image2);
ctrlPointColor = [0.4 0.7 1.0]; %Blue
axis equal
hold on
scatter( ctrlPointList2(:,1), ctrlPointList2(:,2), 25, 'MarkerEdgeColor', ctrlPointColor, 'LineWidth',3 );

%% Transformation
maxIter = 200;
maxInlierErrorPixels = .05*size(Image2,1);
a = (1:clickedN).';
M = [a a];
seedSetSize = max(3, ceil(0.1 * size(M, 1)));
minInliersForAcceptance = ceil(0.3 * size(M, 1));
H = RANSACFit(ctrlPointList2, ctrlPointList1, M, maxIter, seedSetSize, maxInlierErrorPixels, minInliersForAcceptance);

%% Make Panoramic image
saveFileName = 'uttower_pano.png';
PairStitch(Image1, Image2, H, saveFileName);
disp(['Panorama was saved as uttower_pano.png' saveFileName]);
figure;
imshow(imread(saveFileName));