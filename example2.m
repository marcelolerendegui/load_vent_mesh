%% CleanUP
close all
clear all
clc

%% Find File
[file, path, indx] = uigetfile('*.vnt');
filename = [path, file];

%% Load Mesh
[points, type, base, apex, lat, Z, T] = load_vent_mesh(filename);


%% Get Data
% use only the first frame
R = squeeze(points(1,:,:));

r_sz = size(R);

%% Plot Original Mesh

% convert to cartesian coords
[x,y,z] = pol2cart(T, R, Z);

% plot mesh
hf1 = figure("Name", "Original Mesh");
hm1 = mesh(x,y,z);
set(hm1, 'FaceAlpha', 0.1)
set(hm1, 'EdgeColor', [0.5, 0.5, 0.5]);
set(hm1, 'EdgeAlpha', 0.5)
set(hm1, 'EdgeColor', [0, 0, 0]);


%% Apply Median Filter

median_size = 5;

% turn array into torus for filtering
pa_r = padarray(R, [median_size, median_size], 'circular');

% median filter
med_out = medfilt2(pa_r, [median_size, median_size]);

% turn back into array
R = med_out(    median_size+1 : median_size+r_sz(1), ...
                median_size+1 : median_size+r_sz(2));

%% Apply Gaussian Filter

gaussian_size = 5;
gaussian_sgm = 1;

% turn array into torus for filtering
pa_r = padarray(R, [gaussian_size gaussian_size], 'circular');

% gaussian filter

GF = fspecial('gaussian', [gaussian_size, gaussian_size], gaussian_sgm);
gauss_out = conv2(GF, pa_r);

% turn back into array
R = gauss_out(  gaussian_size+1:gaussian_size+r_sz(1), ...
                gaussian_size+1:gaussian_size+r_sz(2));



%% Plot Filtered Mesh

% convert to cartesian coords
[x,y,z] = pol2cart(T, R, Z);

% plot mesh
hf2 = figure("Name", "Filtered Mesh");
hm2 = mesh(x,y,z);
set(hm2, 'FaceAlpha', 0.1)
set(hm2, 'EdgeColor', [0.5, 0.5, 0.5]);
set(hm2, 'EdgeAlpha', 0.5)
set(hm2, 'EdgeColor', [0, 0, 0]);