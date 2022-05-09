
close all
clear


%% Prepare model

load mat/createModel.mat m

m = alter(m, 3);
m.c2_dl_cpi_ste = [1, 1, 0.8];
checkSteady(m);
m = solve(m);


%% Prepare chartpack

ch = databank.Chartpack();
ch.Range = 0:80;
ch.Round = 8;
ch.TitleSettings = {"fontSize", 20};
ch.AxesSettings = {"fontSize", 20};

ch < ["dl_cpi", "r", "l_gdp_gap", "dl_ex", "l_rex_gap", "rr_gap", "l_ex"];


%% Simulate plain-vanilla demand shock

d = zerodb(m, 1:80);
d.shock_l_gdp_gap(1) = 1;

s1 = simulate(m, d, 1:80, prependInput=true, deviation=true);

draw(ch, s1);
return

%% Simulate delayed policy - anticipated

p2 = Plan.forModel(m, 1:40);
p2 = exogenize(p2, 1:6, "r");
p2 = endogenize(p2, 1:6, "shock_r");

s2 = simulate( ...
    m, d, 1:40 ...
    , plan=p2 ...
    , prependInput=true ...
    , deviation=true ...
);


%% Simulate delayed policy - unanticipated

p3 = Plan.forModel(m, 1:40, anticipate=false);

p3 = exogenize(p3, 1:6, "r");
p3 = endogenize(p3, 1:6, "shock_r");

s3 = simulate( ...
    m, d, 1:40 ...
    , plan=p3 ...
    , prependInput=true ...
    , deviation=true ...
);


%% Plot results

draw(ch, databank.merge("horzcat", s1, s2, s3));
