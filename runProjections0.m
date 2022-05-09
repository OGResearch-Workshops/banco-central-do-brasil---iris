%% Run model based projections from initial conditions


%% Clear workspace

close all
clear
%#ok<*VUNUS>

load mat/createModel.mat m
load mat/preprocessData0.mat h startHist endHist


m = m(2);

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
d1.dl_cpi(startForecast) = 4;

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
d2.dl_gdp(startForecast) = 2.5;

s2 = simulate( ...
    m, d2, startForecast:endForecast ...
    , prependInput=true ...
    , plan=p2 ...
);


%% Auxiliary simulation for fiscal impulse

z = zerodb(m, 1:20);

pz = Plan.forModel(m, 1:20, anticipate=true);
pz = anticipate(pz, true, ["shocka_l_gdp_gap", "l_gdp_gap"]);
pz = anticipate(pz, true, "shocka_l_gdp_gap");
pz = exogenize(pz, 6:9, "l_gdp_gap");
pz = endogenize(pz, 6:9, "shocka_l_gdp_gap");


z.l_gdp_gap(6:9) = [0.5;1;1;0.2] / 2;
z1 = simulate(m, z, 1:20, deviation=true, plan=pz, prependInput=true);


%% Fiscal impulse

p3 = p2;

fiscalDates = startForecast + (5:8);

d3 = d2;
d3.shocka_l_gdp_gap = Series();
d3.shocka_l_gdp_gap(fiscalDates) = z1.shocka_l_gdp_gap(6:9);

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

s = databank.merge("horzcat", s0, s1, s2, s3);


%% Report results

ch = databank.Chartpack();
ch.Range = endHist-3*4 : endForecast;
ch.Round = 8;
ch.Highlight = startForecast : endForecast;
ch.PlotSettings = {"marker", "s"};

% ch < ["[dl_cpi_ww]", "[r_ww]", "[l_gdp_ww_gap]", "l_ex_cross"];  
% ch < "//";
% ch < ["[dl_gdp_tnd]", "[dl_rex_tnd]", "[rr_tnd]", "[rr_ww_tnd]", "[prem_tnd]"];
% ch < "//";
ch < ["[dl_cpi]", "[r]", "[l_gdp_gap]", "dl_gdp_tnd", "[dl_gdp]", "[l_rex_gap]", "tune_dl_cpi", "tune_l_gdp"];

draw(ch, s3);

% visual.hlegend("bottom", "Hands-free", "NTF CPI", "NTF CPI, GDP", "All NTF and Fiscal");

databank.toCSV(sf, "data-files/final0.csv", decimals=16);

