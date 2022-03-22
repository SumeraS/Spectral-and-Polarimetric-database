clc;
clear all;
close all;
warning off
addpath(genpath('../Toolbox/'))

%% Global parameters
folder_path = '../';


load('scene.mat');

scene = 'colorchecker';

load('Data/norm_factors.mat')

%% Load images
load([folder_path 'Geometric_corrected_database/bg_' scene])
load([folder_path 'Geometric_corrected_database/y_' scene])

%% Montage of the images
ms = cat(3,bg,y);
ms(isinf(ms))=1;
ms = ms./reshape(norm_factors,1,1,6);
MS = reshape(ms,size(ms,1)*size(ms,2),6,4);
MS = permute(MS,[2 1 3]);

figure;
for i=1:6
    subplot(2,3,i);imshow(ms(:,:,i,1));
end
colormap('jet');

scale = [0 1];

%% Stokes computation
S0 = (ms(:,:,:,1) + ms(:,:,:,3));
% S0 = (S0)*(scale(2)-scale(1))/(scale(2)) + scale(1);

% S01=imcrop(S0(:,:,3),[1163.5 47.5 1161 1290]);
figure;montage((S0),'DisplayRange',[0 2]);
colormap('jet');colorbar;
% title('S0 images');
% imwrite((S0*255),jet(255),[folder_path 'Color_Result/S0' scene 'S01.png']);


S1 = ms(:,:,:,1) - ms(:,:,:,3);
% S1 = (S1)*(scale(2)-scale(1))/(scale(2)) + scale(1);

% S11=imcrop(S1(:,:,3),[1163.5 47.5 1161 1290]);
figure;montage(S1,'DisplayRange',[-1 1]);colormap('hsv');colorbar;
% title('S1 images');

S2 = ms(:,:,:,2,:) - ms(:,:,:,4,:);
% S2 = (S2)*(scale(2)-scale(1))/(scale(2)) + scale(1);

% S21=imcrop(S2(:,:,3),[1163.5 47.5 1161 1290]);

figure;montage(S2,'DisplayRange',[-1 1]);colormap('hsv');colorbar;
% title('S2 images');

% scale = [0 1];
% S0_scaled = (S01)*(scale(2)-scale(1))/(scale(2)) + scale(1);
% S1_scaled = (S1+scale(2))*(scale(2)-scale(1))/(2*scale(2)) + scale(1);
% S2_scaled = (S2+scale(2))*(scale(2)-scale(1))/(2*scale(2)) + scale(1);


%% Polarization parameters estimation
DOLP = sqrt(S1.^2+S2.^2)./S0;
% dolp=imcrop(DOLP(:,:,3),([1163.5 47.5 1161 1290]));

% DOLP_scaled = ((dolp)*(scale(2)-scale(1))/(2) + scale(1));



figure;montage((DOLP),'DisplayRange',[0 1]);colormap('jet');colorbar;
 title('DOLP');
% imwrite((DOLP*255),jet(255),[folder_path 'Color_Result/dolp' scene '_dolp.png']);
% imwrite((dolp,[1181.5 86.5 1140 1473]*255),jet(255),[folder_path 'Results/_dolp' scene '_dolp.png']);
% imwrite(srgb,[1181.5 86.5 1140 1473]),[folder_path 'Color_Result/srgb_' scene '_unpol.png']);

aolp = 0.5*atan2d(S2,S1);
% aolp=imcrop(aolp(:,:,3),([1163.5 47.5 1161 1290]));

figure;montage(aolp,'DisplayRange',[-90 90]);colormap('hsv');colorbar;
title('AOLP');

% imwrite(ind2rgb(aolp*255),hsv(255),[folder_path 'Color_Results/aolp' scene 'aolp.tiff']);
% imwrite(ind2rgb(uint8(aolp+pi/2/pi*255),hsv(256)),[folder_path 'Color_Result/aolp' scene  'aolp.png'] );




I_unpol = S0-sqrt(S1.^2+S2.^2);
figure;montage(I_unpol(:,:,2),'DisplayRange',[0 2]);
title('I_unpol');

%% Save
% save([folder_path 'Results/S0_' scene '.mat'],'S0');
% save([folder_path 'Results/S1_' scene '.mat'],'S1');
% save([folder_path 'Results/S2_' scene '.mat'],'S2');
save([folder_path 'Stokes_Result/DOLP_' scene '.mat'],'DOLP');
% save([folder_path 'Results/AOLP_' scene '.mat'],'AOLP');
% save([folder_path 'Results/I_unpol_' scene '.mat'],'I_unpol');

save([folder_path 'Stokes_Result/S0'  '.mat'],'S0');
% save([folder_path 'Results/S1'  '.mat'],'S1');
% save([folder_path 'Results/S2'  '.mat'],'S2');
save([folder_path 'Stokes_Result/DOLP'  '.mat'],'DOLP');
% save([folder_path 'Results/AOLP'  '.mat'],'AOLP');
save([folder_path 'Stokes_Result/I_unpol'  '.mat'],'I_unpol');