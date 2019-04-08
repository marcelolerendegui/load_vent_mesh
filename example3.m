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
hf1 = figure("Name", "Filtered Mesh");
ha1 = axes();
hm1 = mesh(ha1, x,y,z);
set(hm1, 'FaceAlpha', 0.1)
set(hm1, 'EdgeColor', [0.5, 0.5, 0.5]);
set(hm1, 'EdgeAlpha', 0.5)
set(hm1, 'EdgeColor', [0, 0, 0]);


%% Plot Centroid

% calculate centroid
xc = mean(x(:));
yc = mean(y(:));
zc = mean(z(:));

% plot centroid
hold(ha1, 'on');
plot3(ha1, xc, yc, zc, '*r');


%% Plot 
xyz = [x(:), y(:), x(:)];
xyz_c = repmat([xc, yc, zc], [size(xyz,1), 1]);
rad = vecnorm((xyz-xyz_c).');

hf2 = figure("Name", "Distance to centroid");
ha2 = axes();
plot(ha2, rad);

hf3 = figure("Name", "Distance to centroid Histogram");
ha3 = axes();
hist(ha3, rad);

avg_rad = mean(rad);
MSE = sum((rad-avg_rad).^2);

disp(["Average radius:", avg_rad]);
disp(["MSE:", MSE]);