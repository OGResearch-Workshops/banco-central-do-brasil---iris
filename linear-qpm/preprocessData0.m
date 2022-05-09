%% Create historical databank with model consistent names


%% Clear workspace

close all
clear

load mat/createModel.mat m
load mat/readData.mat dq dq2

startHist = qq(2003,1);
endHist = qq(2021, 1);
startForecast = endHist + 1;

dq = databank.clip(dq, -Inf, endHist);
dq2 = databank.clip(dq2, -Inf, endHist);


%% List of necessary initial conditions

access(m, "initials")'


%% Build the historical databank

h = struct();

h.l_gdp_tot = 100*log(x13.season(dq.rgdp));
h.l_gdp_ww = 100*log(dq.rus_gdp_sa);


h.l_ngdp = 100*log(dq2.gdp_nom_noil_sa);
h.l_pgdp = 100*log(dq2.gdp_noil_def_sa);
h.l_gdp = h.l_ngdp - h.l_pgdp;

h.l_cpi0 = 100*log(dq.cpi);
x = 1+Series(getRange(h.l_cpi0), @randn)/5000;
h.l_cpi = h.l_cpi0 * x;

h.r = dq.interbank_rate;
h.l_ex = 100*log(dq2.neer_sa/100);
h.l_ex_usd = 100*log(dq.azn_usd);
h.l_ex_cross = h.l_ex - h.l_ex_usd;


h.r_ww = dq.r_us;
h.l_cpi_ww = 100*log(dq2.tp_cpi_sa);
h.l_rex = h.l_ex + h.l_cpi_ww - h.l_cpi;
h.l_gdp_ww = 100*log(dq.rus_gdp_sa);


list = ["l_cpi", "l_gdp", "l_ngdp", "l_pgdp", "l_cpi_ww", "l_ex", "l_rex", "l_cpi_ww", "l_ex"];

h = databank.apply( ...
    h, @(x) 4*diff(x) ...
    , sourceNames=list ...
    , targetNames=@(n) "d"+n ...
);

h = databank.apply( ...
    h, @(x) diff(x, -4) ...
    , sourceNames=list ...
    , targetNames=@(n) "d4"+n ...
);

h.rr = h.r - h.d4l_cpi;
h.rr_ww = h.r_ww - h.d4l_cpi_ww;


%% Prepare chartpack

ch = databank.Chartpack();
ch.Range = endHist-40:endHist+20;
ch.Highlight = endHist-40:endHist;
ch.AxesExtras = {@(h) visual.zeroline(h)};


%% Non-oil GDP trend-cycle


changeTune = Series();
changeTune(endHist+20) = m(1).ss_dl_gdp/4;
% changeTune(qq(2020,4)) = 1/4;

gap = Series();
% gap(qq(2021,2)) = 2.52;
gap(qq(2021,1)) = 1.09;
gap(qq(2020,4)) = -1.39;
gap(qq(2020,3)) = -3.42;
gap(qq(2020,2)) = -5.68;
gap(qq(2020,1)) = 2.89;
gap(qq(2019,4)) = 1.50;

levelTune = h.l_gdp - gap;

[h.l_gdp_tnd, h.l_gdp_gap] = hpf( ...
    h.l_gdp, Inf ...
    , "level", levelTune ...
    , "change", changeTune ...
    , "lambda", 100 ...
);

h.ss_dl_gdp = m.ss_dl_gdp;
h.dl_gdp_tnd = 4*diff(h.l_gdp_tnd);
h.d4l_gdp_tnd = diff(h.l_gdp_tnd, -4);

clear(ch);
ch < "Nonoil: [l_gdp, l_gdp_tnd]";
ch < "Nonoil Q/Q PA: [4*diff([l_gdp, l_gdp_tnd]), ss_dl_gdp]";
ch < "Nonoil Y/Y: [diff([l_gdp, l_gdp_tnd], -4), ss_dl_gdp]";
ch < "Nonoil gap: [NaN, l_gdp_gap]";
% draw(ch, h);


%% Real exchange rate trend-cycle


changeTune = Series();
changeTune(endHist+20) = m(1).ss_dl_rex/4;

[h.l_rex_tnd, h.l_rex_gap] = hpf(h.l_rex, Inf, "change", changeTune);
h.dl_rex_tnd = 4*diff(h.l_rex_tnd);

h.ss_dl_rex = m(1).ss_dl_rex;
h.dl_l_rex_tnd = 4*diff(h.l_rex_tnd);
h.d4l_l_rex_tnd = diff(h.l_rex_tnd, -4);

clear(ch);
ch < "REER: [l_rex, l_rex_tnd]";
ch < "REER Q/Q PA: [4*diff([l_rex, l_rex_tnd]), ss_dl_rex]";
ch < "REER Y/Y: [diff([l_rex, l_rex_tnd], -4), ss_dl_rex]";
ch < "REER gap: [NaN, l_rex_gap]";
% draw(ch, h);


%% Real interest rate trend-cycle


[h.rr_tnd, h.rr_gap] = hpf(...
    h.rr, Inf ...
    , change=Series(endHist+5*4, 0) ...
    , level=Series(endHist+5*4, m(2).rr) ...
);

clear(ch);
ch < "IR: r";
ch < "Inflation: diff(l_cpi, -4)";
ch < "RIR: [rr, rr_tnd]";
ch < "RIR gap: [NaN, rr_gap]";
% draw(ch, h);


%% Foreign real interest rate trend-cycle

[h.rr_ww_tnd, h.rr_ww_gap] = hpf(...
    h.rr_ww, Inf ...
    , change=Series(endHist+5*4, 0) ...
    , level=Series(endHist+5*4, m(2).rr_ww) ...
);

h.ss_dl_cpi_ww = m(1).dl_cpi_ww;
h.ss_r_ww = m(1).r_ww;

clear(ch);
ch < "World IR: [r_ww, ss_r_ww]";
ch < "World inflation: [4*diff(l_cpi_ww), diff(l_cpi_ww, -4), ss_dl_cpi_ww]";
ch < "RIR: [rr_ww, rr_ww_tnd]";
ch < "RIR gap: [NaN, rr_ww_gap]";
% draw(ch, h);


%% Implied UIP disparity


h.prem_tnd = h.rr_tnd - h.rr_ww_tnd - h.dl_rex_tnd{+1};

% figure();
% plot(h.prem_tnd);
% title("Implied UIP disparity trend");


%% Foreign demand trend-cycle


[h.l_gdp_ww_tnd, h.l_gdp_ww_gap] = hpf(h.l_gdp_ww, Inf, lambda=1600);

clear(ch);
ch < "Foreign GDP: [l_gdp_ww, l_gdp_ww_tnd]";
ch < "Foreign GDP gap: [NaN, l_gdp_ww_gap]";
ch < "Foreign CPI, Q/Q PA, Y/Y: [dl_cpi_ww, d4l_cpi_ww, ss_dl_cpi_ww]";
% draw(ch, h);



%% Exchange rate target


h.l_ex_usd_tar = h.l_ex_usd;


%% Time-varying policy parameters

h.q1 = Series(startHist:endHist, m(2).ss_q1);
h.q2 = Series(startHist:endHist, m(2).ss_q2);
h.q3 = Series(startHist:endHist, m(2).ss_q3);
h.q4 = Series(startHist:endHist, m(2).ss_q4);
h.q5 = Series(startHist:endHist, m(2).ss_q5);

% figure();
% plot(startHist:endHist+5*4, [h.l_gdp, h.l_gdp_tnd0,  h.l_gdp_tnd1, h.l_gdp_tnd2]);

%% 

h.prem_gap = Series(startHist:endHist, 0);
h.aux_tune_dl_cpi_short = Series(startHist:endHist, 0);
h.dl_ex_gap = h.dl_ex - (h.dl_rex_tnd + m(2).ss_dl_cpi - m(2).ss_dl_cpi_ww);


%% Check if all initial conditions are included

checkInitials(m, h, startForecast);


%% Save historical databank to mat file

save mat/preprocessData0.mat h startHist endHist
