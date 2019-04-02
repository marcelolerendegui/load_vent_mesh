%% CleanUP
close all
clear all
clc

%% Load Mesh
[points, type, base, apex, lat, Z, T] = load_vent_mesh('');

%% Plot
% use only the first frame
R = squeeze(points(1,:,:));

% convert to cartesian coords
[x,y,z] = pol2cart(T, R, Z);

% plot black markers on each mesh node
plot3(x,y,z,'ok');
zlen = sum((apex(1,:)-base(1,:)).^2).^0.5;