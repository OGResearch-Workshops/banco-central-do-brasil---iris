

close all
clear

load mat/createModel.mat m


%% Set up simulation assumptions

range = 1 : 20;
d = steadydb(m, range);
d.Ey(1) = log(1.01);


%% Simulate

s = simulate( ...
    m, d, range ....
    , "prependInput", true ...
);


%% Chart results

smcDb = databank.minusControl(m, s, d);

% chartDb = databank.merge("horzcat", d, s);

ch = databank.Chartpack();
ch.Range = 0 : 20;
ch.Round = 8;

ch < "Output: 100*(Y-1)";
ch < "CPI inflation, Q/Q PA: 100*(dP^4-1)";
ch < "Policy rate, PA: 100*(R^4-1)";
ch < "Nominal wage rate: 100*(W-1)";

draw(ch, smcDb);
