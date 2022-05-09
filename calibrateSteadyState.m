
close all
clear

load mat/createModel.mat m
load mat/readData.mat dq
laod mat/preprocessData.mat h


chartRange = qq(2005,1) : qq(2021,4);



%% UV filter

hp = struct();

hp.r_ww1 = hpf(h.r_ww{-Inf:qq(2014,4)}, lambda=36000);
hp.r_ww2 = hpf(h.r_ww{-Inf:qq(2014,4)}, change=Series(qq(2014,4), 0));



%% Steady state databank

ss = steadydb(m, chartRange);


%% Basic charts


ch = databank.Chartpack();
ch.Range = chartRange;

ch < "CPI Q/Q: dl_cpi";
ch < "Interest rate: r";
ch < "Real GDP Q/Q: dl_gdp";
ch < "Nominal exchange rate Q/Q: dl_ex";
ch < "Real exchange rate Q/Q: dl_rex";
ch < "Real interest rate: rr";

ch < "World CPI Q/Q: dl_cpi_ww";
ch < "World interest rate: r_ww";

draw(ch, databank.merge("horzcat", h, ss, MissingField=NaN));

