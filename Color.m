clc;
clear all;
close all;
warning off
addpath(genpath('../Toolbox/'))

%% Global parameters
folder_path = '../';
range = 380:10:730;
load('scene.mat');
scene = 'colorchecker';

%% Load images
radiance = load([folder_path 'Spectral_Result/spectral_' scene '.mat']);
load('Data/M_s.mat');
load([folder_path 'Geometric_corrected_database/bg_' scene]);


p = radiance.R;


%% XYZ
cmf_r = readmatrix('Data/ciexyz31.csv');% From CVRL website
C = cmf_r(5:75,2:4);
C = interp1(380:5:730,C,range);
xyz = (C'*p)*100/sum(C(:,2));
xyz = xyz./max(max(xyz));
rgb = xyz2rgb(xyz','ColorSpace','linear-rgb','WhitePoint','e');
rgb_3D = reshape(rgb,size(bg,1),size(bg,2),3);
rgb2 = double(rgb)./squeeze((double(rgb_3D(883+40,394+1080,:))))'*0.01; 
srgb = lin2rgb(rgb2); % to srgb
%%
srgb = reshape(srgb,size(bg,1),size(bg,2),3);
figure;imshow(srgb(:,:,:));
im = reshape(srgb,size(bg,1),size(bg,2),3);

imwrite(imcrop(srgb,[1181.5 86.5 1140 1473]),[folder_path 'Color_Result/srgb_' scene '_unpol.tiff']);

%% Saving...
% save([folder_path 'Color_Result/srgb_' scene '.mat'],'srgb');

