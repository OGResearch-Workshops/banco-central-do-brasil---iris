

close all
clear

load mat/createModel.mat m


%% Set up simulation assumptions

range = 1 : 20;
d1 = steadydb(m, range, "numColumns", 2);
% d = zerodb(m, range);

d1.Ey(4, 1) = log(1.01);
d1.Ey(4, 2) = log(1.01) - log(1.01)*1i;


%% Simulate shock

s1 = simulate( ...
    m, d1, range ....
    , "prependInput", true ...
);


%% Find the size of the shock to get Y up by 1%

d2 = steadydb(m, range);

p = Plan.forModel(m, range);
p = exogenize(p, 1, "Y");
p = endogenize(p, 1, "Ey");

d2.Y(1) = d2.Y(1) * 1.01;

s2 = simulate( ...
    m, d2, range ....
    , "prependInput", true ...
    , "plan", p ...
);


%% Chart results

smcDb1 = databank.minusControl(m, s1);
smcDb2 = databank.minusControl(m, s2);

% chartDb = databank.merge("horzcat", d, s);

ch = databank.Chartpack();
ch.Range = 0 : 20;
ch.Round = 8;
ch.Highlight = 4;

ch < "Output: 100*(Y-1)";
ch < "CPI inflation, Q/Q PA: 100*(dP^4-1)";
ch < "Policy rate, PA: 100*(R^4-1)";
ch < "Nominal wage rate: 100*(W-1)";
ch < "Demand shock: 100*Ey";

draw(ch, databank.merge("horzcat", smcDb1, smcDb2));

