%% CleanUP
close all
clear all
clc

%% Find File
[file, path, indx] = uigetfile('*.vnt');
filename = [path, file];

%% Load Mesh
[points, type, base, apex, lat, Z, T] = load_vent_mesh(filename);

%% Plot
% use only the first frame
R = squeeze(points(1,:,:));

% convert to cartesian coords
[x,y,z] = pol2cart(T, R, Z);

% downsample
ds = 4;
x = x(1:ds:end,1:ds:end);
y = y(1:ds:end,1:ds:end);
z = z(1:ds:end,1:ds:end);

% plot ventricle mesh
hm = mesh(x,y,z);
set(hm, 'FaceAlpha', 0)
set(hm, 'EdgeAlpha', 0.5)
set(hm, 'EdgeColor', 'k')