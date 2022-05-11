%% Investigate the effect of rhoa on eigenvalues

close all
clear

load mat/createModel.mat m


sr = access(m, "stable-roots");


m1 = m;
m1.rhoa = 0;
checkSteady(m1);
m1 = solve(m1);

sr1 = access(m1, "stable-roots");

figure();
hold on
visual.eigen(sr);
visual.eigen(sr1, plotSettings={"marker", "*", "lineStyle", "none", "markerSize", 20});

