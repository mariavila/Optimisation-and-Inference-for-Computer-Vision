clear all;
close all;
clc;

im_name='3_12_s.bmp';

% TODO: Update library path
% Add  library paths
basedir='~/UGM/';
addpath(basedir);



%Set model parameters
%cluster color
K=4; % Number of color clusters (=number of states of hidden variables)

%Pair-wise parameters
smooth_term=[0.0 2]; % Potts Model

%Load images
im = double(imread(im_name));
x=reshape(im,[size(im,1)*size(im,2) size(im,3)]);


NumFils = size(im,1);
NumCols = size(im,2);

%Convert to LAB colors space
% TODO: Uncomment if you want to work in the LAB space
%
% im = RGB2Lab(im);



%Preparing data for GMM fiting
gmm_color = gmdistribution.fit(x,K);
mu_color=gmm_color.mu;
% TODO: define the unary energy term: data_term
% nodePot = P( color at pixel 'x' | Cluster color 'c' )
data_term=gmm_color.posterior(x);
nodePot = data_term;

%Building 4-grid
%Build UGM Model for 4-connected segmentation
disp('create UGM model');

% Create UGM data
[edgePot,edgeStruct] = CreateGridUGMModel(NumFils, NumCols, K ,smooth_term);


if ~isempty(edgePot)

    % color clustering
    [~,c] = max(reshape(data_term,[NumFils*NumCols K]),[],2);
    im_c= reshape(mu_color(c,:),size(im));
    
    % Call different UGM inference algorithms
    display('Loopy Belief Propagation'); tic;
    [nodeBelLBP,edgeBelLBP,logZLBP] = UGM_Infer_LBP(nodePot,edgePot,edgeStruct);
    [~,c_loopy] = max(nodeBelLBP,[],2);
    im_lbp = reshape(mu_color(c_loopy,:),size(im));toc;
    
    % Max-sum
    display('Max-sum'); tic;
    decodeLBP = UGM_Decode_LBP(nodePot,edgePot,edgeStruct);
    im_bp= reshape(mu_color(decodeLBP,:),size(im));
    toc;
    
    
    % TODO: apply other inference algorithms and compare their performance
    % - Graph Cut
    %display('Graph Cut'); tic;
    %decodeGraphCut = UGM_Decode_GraphCut(nodePot,edgePot,edgeStruct); 
    %im_dgc= reshape(mu_color(decodeGraphCut,:),size(im));
    %toc;
    % - Linear Programing Relaxation
    %display('Graph Cut'); tic;
    %decodeLinProg = UGM_Decode_LinProg(nodePot,edgePot,edgeStruct); 
    %im_lp= reshape(mu_color(decodeLinProg,:),size(im));
    %toc;
    
    
    figure
    subplot(2,3,1),imshow(im/255,[]);xlabel('Original');
    subplot(2,3,2),imshow(im_c/255, []);xlabel('Clustering without GM');
    subplot(2,3,3),imshow(im_bp/255, []);xlabel('Max-Sum');
    subplot(2,3,4),imshow(im_lbp/255, []);xlabel('Loopy Belief Propagation');
    %subplot(2,3,5),imshow(im_dgc/255, []);xlabel('Graph Cut');
    %subplot(2,3,6),imshow(im_lp/255, []);xlabel('Linear Programming');
    %figure
    %subplot(2,2,1),imshow(Lab2RGB(im));xlabel('Original');
    %subplot(2,2,2),imshow(Lab2RGB(im_c),[]);xlabel('Clustering without GM');
    %subplot(2,2,3),imshow(Lab2RGB(im_bp),[]);xlabel('Max-Sum');
    %subplot(2,2,4),imshow(Lab2RGB(im_lbp),[]);xlabel('Loopy Belief Propagation');
    
else
   
    error('You have to implement the CreateGridUGMModel.m function');

end
