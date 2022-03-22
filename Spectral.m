clc;
clear all;
close all;
warning off
addpath(genpath('../Toolbox/'))

%% Global parameters
folder_path = '../';
load('scene.mat');
scene = 'colorchecker';


%% Load images
load([folder_path 'Stokes_Result/S0'])
load([folder_path 'Stokes_Result/I_unpol'])

%% Montage of the images
ms = S0;
MS = reshape(ms,size(ms,1)*size(ms,2),6);
MS = permute(MS,[2 1]);
figure;
montage(ms(:,:,2,1)./2);colormap('jet');

ms_S0 = S0; ms_I_unpol = I_unpol;
MS_S0 = reshape(ms_S0,size(ms_S0,1)*size(ms_S0,2),6);
MS_I_unpol = reshape(ms_I_unpol,size(ms_I_unpol,1)*size(ms_I_unpol,2),6);
MS_S0 = permute(MS_S0,[2 1]);MS_I_unpol = permute(MS_I_unpol,[2 1]);

figure;
imshow(ms_S0(:,:,2,1)./2);colormap('jet');


%% Load calibration matrix (N->M transformation)
load('Data/M_s.mat')

%% Generate radiance images by polarization channel
display('Saving...');

R = M_s*MS(:,:);R(find(R<0)) = 0;
% save([folder_path 'Spectral_Result/spectral_' scene '.mat'],'R','-v7.3','-nocompression');
save([folder_path 'Spectral_Result/Spectral_' scene '.mat'],'R','-v7.3','-nocompression');


R_S0 = M_s*MS_S0(:,:);R_S0(find(R_S0<0)) = 0;R_S0(find(R_S0>1)) = 1;
R_I_unpol = M_s*MS_I_unpol(:,:);R_I_unpol(find(R_I_unpol<0)) = 0;R_I_unpol(find(R_I_unpol>1)) = 1;

% save([folder_path 'Spectral_Result/spectral_' scene '.mat'],'R','-v7.3','-nocompression');
save([folder_path 'Spectral_Result/spectral_S0.mat'],'R_S0','-v7.3','-nocompression');
save([folder_path 'Spectral_Result/spectral_I_unpol.mat'],'R_I_unpol','-v7.3','-nocompression');

%% Save for visualization 
radiance_S0 = reshape(R_S0',size(ms_S0,1),size(ms_S0,2),size(R_S0,1));
radiance_I_unpol = reshape(R_I_unpol',size(ms_S0,1),size(ms_S0,2),size(R_I_unpol,1));
% imcrop(radiance_I_unpol,[1091.5 56.5 1275 1812]);

% spec_cube_S0 = hypercube(RemoveSpecials(rescale(radiance_S0,'InputMax',1)),380:10:730);
% spec_cube_I_unpol = hypercube(RemoveSpecials(rescale(radiance_I_unpol,'InputMax',1)),380:10:730)
% enviwrite(spec_cube_S0,[folder_path 'Spectral_Result/spec_cube_S0']);
% enviwrite(spec_cube_I_unpol,[folder_path 'Spectral_Result/spec_cube_I_unpol']);

%% Visu
figure;
montage(uint8(real(255*(log10(radiance_S0./2+1)./log10(2)))));

%% Write tiff for radiance
%write_tiff_radiance(uint8(real(255*log10(radiance_2+1)./log10(2))),[folder_path 'Spectral_Result/radiance_0deg']);