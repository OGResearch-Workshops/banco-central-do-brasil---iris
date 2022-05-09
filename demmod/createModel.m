%% Read and Calibrate Model


%% Clear Workspace

clear
close all


%% Load Model Files

% Number of age cohorts
A = 99;

m = Model.fromFile( ...
    'demmod-sx.model' ...
    , 'growth', true ...
    , 'assign', struct('A', A) ...
    , 'allowExogenous', true ...
    , 'savePreparsed', '__preparsed.model' ...
);


%% Calibrate and Solve Model

xr = 1;
sr = 0.965;
br = 1.01 ./( sum(sr.^(0:A)) );
fr = br * (1 + xr);
er = 0.95;
pr = 0.70;
nmr = 0;
lpr = 0.50;

m = assign(m, sprintf('sr0,..,sr%g', A-1), sr);
m = assign(m, sprintf('sr%g', A), 0);
m = assign(m, sprintf('br0,..,br%g', A), br);
m = assign(m, sprintf('fr0,..,fr%g', A), fr);
m = assign(m, sprintf('xr0,..,xr%g', A), xr);
m = assign(m, sprintf('nmr0,..,nmr%g', A), nmr);
m.nmr = nmr;

access(m, 'parameters')

m1 = m;
m.Q = 1;


%% Calculate Steady State

m = steady(  ...
    m ...
    , 'fixLevel', 'Q' ...
    ... , 'solver', {'newton', 'maxFunEvals', 10000, 'specifyObjectiveGradient', true} ...
);

checkSteady(m, 'equationSwitch', 'steady');
checkSteady(m, 'equationSwitch', 'dynamic');

sl = access(m, 'steady-level');
sg = access(m, 'steady-growth');

table( ...
    m, {'SteadyLevel', 'SteadyChange', 'Description'} ...
    , 'Round', 7 ...
);


%% Calculate Solution

m = solve(m);
disp(m)


