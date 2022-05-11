

close all
clear

load mat/createModel.mat m


%% Set up simulation assumptions

% range = qq(2021,1):qq(2025,4);
range = 1 : 20;

d = steadydb(m, range);

d.Ey(1) = log(1.01);


%% Simulate

s = simulate( ...
    m, d, range ....
    , "prependInput", true ...
);


%% Chart results

ch = databank.Chartpack();
ch.Range = 0 : 20;
ch.Round = 8;

ch < "Output: Y";
ch < "CPI inflation: dP";
ch < "Policy rate: R";
ch < "Nominal wage rate: W";

draw(ch, s);
