
close all
clear


load mat/createModel.mat m


m = m(1);

d = zerodb(m, 1:40);
d.shock_dl_cpi(5) = 1;

s1 = simulate(m, d, 1:40, prependInput=true, deviation=true);

d = zerodb(m, 1:40);
d.shock_dl_cpi(5) = 1 - 1i;

s2 = simulate(m, d, 1:40, prependInput=true, deviation=true);



%% Plot results


ch = databank.Chartpack();
ch.Range = 0:40;
ch.Round = 8;
ch.TitleSettings = {"fontSize", 20};
ch.AxesSettings = {"fontSize", 20};
ch.Highlight = 1:4;

ch < ["dl_cpi", "r", "l_gdp_gap", "dl_ex", "l_rex_gap", "rr_gap", "l_ex"];

draw(ch, databank.merge("horzcat", s1, s2));
