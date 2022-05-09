

close all
clear


load mat/createModel.mat m

m = alter(m, 3);
m.c2_dl_cpi_ste = [1, 1, 0.8];

m1 = m;
m1.ss_dl_cpi = m1.ss_dl_cpi - 1;
m1 = steady(m1);
m1 = solve(m1);

d = steadydb(m, 1:40);

s = simulate(m1, d, 1:40, prependInput=true);

ch = databank.Chartpack();
ch.Range = 0:40;
ch.Round = 8;
ch.TitleSettings = {"fontSize", 20};
ch.AxesSettings = {"fontSize", 20};

ch < ["dl_cpi", "r", "l_gdp_gap", "dl_ex", "l_rex_gap", "rr_gap"];
ch < "cumsum(l_gdp_gap)/4";

draw(ch, s);

h = visual.hlegend("bottom", "IT", "FixedXR", "FixedXR with ss_dl_cpi_ste")
set(h, "interpreter", "none", "fontSize", 20);
