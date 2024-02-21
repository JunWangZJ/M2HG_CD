clc;
close all;
clear all;
%% 1-data input
addpath(genpath(pwd));
X = imread('Ottawa_t1.png');
Y = imread('Ottawa_t2.png');
ref = imread('Ottawa_ref.png');
X = double(X(:,:,1))+0.1;
Y = double(Y(:,:,1))+0.1;
ref = ref(:,:,1);
% X = image_normlized(X,'sar')+0.01;  % Data standardisation only for Yellow river dataset
% Y = image_normlized(Y,'sar')+0.01;

%% 2-Heterogeneous graph construction
para.patch = 3;                    % For the weight calculation.
para.localpixel = 25;            % The number of local neighbours for each vertex.
para.win = 15;                     % The size of search window for nonlocal edge constrcution.

% para.localpixel = 50;               % Only for Yellow river dataset
% para.win = 21;                         % Only for Yellow river dataset

para.nonlocalpixel = para.localpixel*2;    % The number of nonlocal neighbours for each vertex. Must be less than (para.win^2/4).
para.globalpixel = para.localpixel*2;        % The number of global neighbours for each vertex.

% Heterogeneous graph construction.
[Gx, Gy] = HGraph_construction(X, Y, para);

%% 3-Attributes aggregation

% non-local neighbours aggregation
X_NL1 = aggregatorNL(Gx, X);              % One-order aggregation  (Pn*f)
Y_NL1 = aggregatorNL(Gy, Y);           
X_NL2 = aggregatorNL(Gx, X_NL1);      % Two-order aggregation  (Pn^2*f)=(Pn*(Pn*f))
Y_NL2 = aggregatorNL(Gy, Y_NL1);             

% local neighbours aggregation
X_L1 = aggregatorL(Gx, X);          
Y_L1 = aggregatorL(Gy, Y);             
X_L2 = aggregatorL(Gx, X_L1);          
Y_L2 = aggregatorL(Gy, Y_L1);            

% global neighbours aggregation
X_G1 = aggregatorG(Gx, X);            
Y_G1 = aggregatorG(Gy, Y);            
X_G2 = aggregatorG(Gx, X_G1);            
Y_G2 = aggregatorG(Gy, Y_G1);            

% local and non-local neighbours cross-aggregation
X_L_NL = aggregatorL(Gx, X_NL1);            
Y_L_NL = aggregatorL(Gy, Y_NL1);         
X_NL_L = aggregatorNL(Gx, X_L1);           
Y_NL_L = aggregatorNL(Gy, Y_L1);            

% non-local and global neighbours cross-aggregation
X_G_NL = aggregatorG(Gx, X_NL1);          
Y_G_NL = aggregatorG(Gy, Y_NL1);            
X_NL_G = aggregatorNL(Gx, X_G1);            
Y_NL_G = aggregatorNL(Gy, Y_G1);            

% local and global neighbours cross-aggregation
X_L_G = aggregatorL(Gx, X_G1);           
Y_L_G = aggregatorL(Gy, Y_G1);           
X_G_L = aggregatorG(Gx, X_L1);           
Y_G_L = aggregatorG(Gy, Y_L1);        

%% 4-DI generation
HS1 =  X_NL1 + X_L1 + X_G1 + X_NL2 + X_L2 + X_G2 + X_L_NL + X_NL_L + X_G_NL + X_NL_G + X_L_G + X_G_L;
HS2 =  Y_NL1 + Y_L1 + Y_G1 + Y_NL2 + Y_L2 + Y_G2 + Y_L_NL + Y_NL_L + Y_G_NL + Y_NL_G + Y_L_G + Y_G_L;
DI = abs(log(HS1./HS2));
DI = DI./max(DI(:));

indexedImage = gray2ind(DI, 256); 
colormap(jet); 
rgbImage = ind2rgb(indexedImage, jet(256));
imshow(rgbImage); % Pseudo-colour image for DI.
% imwrite(rgbImage,'Y1_PC_M2HG.png');

figure, imshow(DI);
% imwrite(DI,'Y1_DI_M2HG.png');
%% 5-Otsu thresholding
level = graythresh(DI)
CM_map = im2bw(DI, level);

%% 6-Visualisation and quantitative analysis of results
ref = ref/max(ref(:));
[TPR, FPR]= Roc_plot(DI,ref, 500);
[AUC, Ddist] = AUC_Diagdistance(TPR, FPR);
[tp,fp,tn,fn,fplv,fnlv,~,~,pcc,kappa,imw]=performance(CM_map,1*ref);
F1 = 2*tp/(2*tp + fp + fn);
result = 'FN is %d; FP is %d; AUC is %4.4f; PCC is %4.4f; F1 is %4.4f; KC is %4.4f \n';
fprintf(result,fn,fp,AUC,pcc,F1,kappa)
figure; plot(FPR,TPR);title('ROC curves');
ROC_M2HG = [FPR; TPR];
% save('Y1_ROC_M2HG.mat', 'ROC_M2HG');

[FP_x, FP_y] = find(imw==0);
[FN_x, FN_y] = find(imw==255);
CM_map_RGB(:,:,1) = uint8(CM_map)*255;
CM_map_RGB(:,:,2) = uint8(CM_map)*255;
CM_map_RGB(:,:,3) = uint8(CM_map)*255;
for i = 1 : max(size(FP_x))
    CM_map_RGB(FP_x(i), FP_y(i), 1:3) = [255 0 0];
end
for i = 1 : max(size(FN_x))
    CM_map_RGB(FN_x(i), FN_y(i), 1:3) = [0 255 0];
end
figure,imshow(CM_map_RGB);
% imwrite(CM_map_RGB,'Y1_CD_M2HG.png');

% Find the Optimal threshold
ii = 1;
for i = 0.0001 : 0.001 : 1
    CM_map1 = im2bw(DI, i); 
    [~,~,~,~,~,~,~,~,~,kap(ii),~]=performance(CM_map1,1*ref);
    ii = ii+1;
end
figure; 
plot(kap);title('KTC curves');
[K_max, id_max] = max(kap);
hold on;
plot(id_max,K_max,'b.','MarkerSize',20)
fprintf('Optimal threshold is %4.4f;  Optimal kappa is %4.4f \n',id_max./1000, K_max);



