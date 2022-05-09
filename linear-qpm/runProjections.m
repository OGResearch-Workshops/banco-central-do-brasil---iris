%% Run model based projections from initial conditions


%% Clear workspace

close all
clear
%#ok<*VUNUS>

load mat/createModel.mat m
load mat/preprocessData.mat h startHist endHist

m = m(2);

    
% m.cx_l_gdp_gap = 0.1;
% m.cx_dl_gdp_tnd = 1;
% checkSteady(m);
% m = solve(m);


startForecast = endHist + 1;
endForecast = endHist + 10*4;


%% Hands-free projection

d0 = h;

s0 = simulate( ...
    m, d0, startForecast:endForecast ...
    , prependInput=true ...
);

% Inflation NTF explained by supply side shock

d1 = h;
d1.dl_cpi(startForecast) = 1.2;

p1 = Plan.forModel(m, startForecast:endForecast);
p1 = anticipate(p1, false, "shocku_l_gdp_gap");

p1 = exogenize(p1, startForecast, "dl_cpi");
p1 = endogenize(p1, startForecast, "tune_dl_cpi");

s1 = simulate( ...
    m, d1, startForecast:endForecast ...
    , prependInput=true ...
    , plan=p1 ...
);

% GDP NTF

p2 = p1;
p2 = exogenize(p2, startForecast, "dl_gdp");
p2 = endogenize(p2, startForecast, "tune_l_gdp");

d2 = d1;
d2.dl_gdp(startForecast) = -3;

s2 = simulate( ...
    m, d2, startForecast:endForecast ...
    , prependInput=true ...
    , plan=p2 ...
);


%% Fiscal impuls

z = zerodb(m, 1:20);

pz1 = Plan.forModel(m, 1:20, anticipate=true);
pz1 = anticipate(pz1, true, ["shocka_l_gdp_gap", "l_gdp_gap"]);
pz1 = anticipate(pz1, true, "shocka_l_gdp_gap");
pz1 = exogenize(pz1, 5:8, "l_gdp_gap");
pz1 = endogenize(pz1, 5:8, "shocka_l_gdp_gap");

pz2 = Plan.forModel(m, 1:20, anticipate=false);
pz2 = anticipate(pz2, true, "shocka_l_gdp_gap");
pz2 = anticipate(pz2, false, ["shocku_l_gdp_gap", "l_gdp_gap"]);
pz2 = exogenize(pz2, 5:8, "l_gdp_gap");
pz2 = endogenize(pz2, 5:8, "shocku_l_gdp_gap");

z.l_gdp_gap(5:8) = [0.5;1;1;0.2];

z1 = simulate(m, z, 1:20, deviation=true, plan=pz1, prependInput=true);
z2 = simulate(m, z, 1:20, deviation=true, plan=pz2, prependInput=true);


e1 = zerodb(m, 1:20);
e2 = zerodb(m, 1:20);

pd = Plan.forModel(m, 1:20);
pd = anticipate(pd, false, "shocku_l_gdp_gap");

e1.shocka_l_gdp_gap(5:8) = z1.shocka_l_gdp_gap(5:8);
u1 = simulate(m, e1, 1:20, deviation=true, plan=pd, prependInput=true);

e2.shocku_l_gdp_gap(5:8) = z2.shocku_l_gdp_gap(5:8);
u2 = simulate(m, e2, 1:20, deviation=true, plan=pd, prependInput=true);


%{
z = zerodb(m, 1:20);
pz1 = Plan.forModel(m, 1:20, anticipate=true);
pz1 = exogenize(pz1, 5:8, "l_gdp_gap");
pz1 = endogenize(pz1, 5:8, "shock_l_gdp_gap");

pz2 = Plan.forModel(m, 1:20, anticipate=false);
pz2 = exogenize(pz2, 5:8, "l_gdp_gap");
pz2 = endogenize(pz2, 5:8, "shock_l_gdp_gap");

z.l_gdp_gap(5:8) = [0.5;1;1;0.2];

z1 = simulate(m, z, 1:20, deviation=true, plan=pz1, prependInput=true);
z2 = simulate(m, z, 1:20, deviation=true, plan=pz2, prependInput=true);
%}


ch = databank.Chartpack();
ch.Range = 0:20;
ch.Highlight = 5:8;
ch.PlotSettings = {"marker", "s"};

ch < ["l_gdp_gap", "dl_cpi", "r", "l_ex", "shocka_l_gdp_gap", "shocku_l_gdp_gap"];

% draw(ch, databank.merge("horzcat", u1, u2));

%{
visual.hlegend("bottom", "Anticipated", "Unanticipated");

d1 = zerodb(m, 1:20);
d1.shock_l_gdp_gap(5:8) = z1.shock_l_gdp_gap(5:8);

d2 = zerodb(m, 1:20);
d2.shock_l_gdp_gap(5:8) = 1i*z2.shock_l_gdp_gap(5:8);

d3 = zerodb(m, 1:20);
d3.shock_l_gdp_gap(5:8) = ...
    0.5*z1.shock_l_gdp_gap(5:8) ...
    + 0.5i*z2.shock_l_gdp_gap(5:8);

u1 = simulate(m, d1, 1:20, deviation=true, prependInput=true, anticipate=true);
u2 = simulate(m, d2, 1:20, deviation=true, prependInput=true, anticipate=true);
u3 = simulate(m, d3, 1:20, deviation=true, prependInput=true, anticipate=true);
% u2 = simulate(m, d2, 1:20, deviation=true, prependInput=true, anticipate=false);

draw(ch, databank.merge("horzcat", u1, u2, u3));
%}

%%

p3 = p2;

d3 = d2;
d3.shocka_l_gdp_gap = Series();
d3.shocka_l_gdp_gap(startForecast+(4:7)) = z1.shocka_l_gdp_gap(5:8);

s3 = simulate( ...
    m, d3, startForecast:endForecast ...
    , prependInput=true ...
    , plan=p3 ...
);

sf = simulate( ...
    m, s3, startForecast:endForecast ...
    , prependInput=true ...
);

maxabs(s3, sf)



%%

%{
% Inflation explained by demand side shock

d2 = d1;

p2 = Plan.forModel(m, startForecast:endForecast);
p2 = exogenize(p2, startForecast, "dl_cpi");
p2 = endogenize(p2, startForecast, "tune_l_gdp_gap");

s2 = simulate( ...
    m, d2, startForecast:endForecast ...
    , prependInput=true ...
    , plan=p2 ...
);

%}

% Inflation explained by both supply side and demand side shocks

%{
d3 = d1;


m.std_tune_dl_cpi = 1;
m.std_tune_l_gdp_gap = 10;

% m = alter(m, 2);
% m.c1_dl_cpi(2) = 0.50;
% checkSteady(m);
% m = solve(m);

p3 = Plan.forModel(m, startForecast:endForecast, method="condition");
p3 = exogenize(p3, startForecast, "dl_cpi");
p3 = endogenize(p3, startForecast, ["tune_dl_cpi", "tune_l_gdp_gap"]);

s3 = simulate( ...
    m, d3, startForecast:endForecast ...
    , prependInput=true ...
    , plan=p3 ...
);


% Inflation explained by long-lived and short-lived supply side shocks

m.std_tune_dl_cpi_short = 3;

p4 = Plan.forModel(m, startForecast:endForecast, method="condition");
p4 = exogenize(p4, startForecast, "dl_cpi");
p4 = endogenize(p4, startForecast, ["tune_dl_cpi", "tune_dl_cpi_short"]);

s4 = simulate( ...
    m, d3, startForecast:endForecast ...
    , prependInput=true ...
    , plan=p4 ...
);

%}



% Run postprocessing equations
% s0 = postprocess(m, s0, startHist:endForecast);

% s  = databank.merge("horzcat", s0, s1, s2, s3);
% s  = databank.merge("horzcat", s1, s4);
% s = s3;


%% Report results

sf0 = databank.fromCSV("data-files/final0.csv");

ch = databank.Chartpack();
ch.Range = endHist-3*4 : endForecast;
ch.Round = 8;
ch.Highlight = startForecast : endForecast;
ch.PlotSettings = {"marker", "s"};

ch < ["[dl_cpi_ww]", "[r_ww]", "[l_gdp_ww_gap]", "l_ex_cross"];  
ch < "//";
ch < ["[dl_gdp_tnd]", "[dl_rex_tnd]", "[rr_tnd]", "[rr_ww_tnd]", "[prem_tnd]"];
ch < "//";
ch < ["[dl_cpi]", "[r]", "[l_gdp_gap]", "dl_gdp_tnd", "[dl_gdp]", "[l_rex_gap]", "tune_dl_cpi", "tune_l_gdp"];

draw(ch, databank.merge("horzcat", sf0, sf));

visual.hlegend("bottom", "Previous", "Current");

databank.toCSV(sf, "data-files/final.csv", decimals=16);

