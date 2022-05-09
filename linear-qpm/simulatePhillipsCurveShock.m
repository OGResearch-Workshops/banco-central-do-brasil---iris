

load mat/createModel.mat m

m = m(2);

d = zerodb(m, 1:40, numColumns=2);
d.tune_dl_cpi(1, 1) = 1;
d.tune_dl_cpi_short(1, 2) = 1;
s = simulate(m, d, 1:40, prependInput=true, deviation=true);

ch = databank.Chartpack();
ch.Range = 0:40;
ch < ["dl_cpi", "l_gdp_gap", "r", "l_rex"];
draw(ch, s);
