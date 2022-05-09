%% S/S comparative static

close all
clc

load mat/createModel.mat m


%% Change steady state assumptions

m = alter(m, 3);

% m.ss_dl_cpi_ww = [2, 3];
m.ss_dl_rex = [-1, 0, 0];

m(1:2) = steady( ...
    m(1:2) ...
    , solver={"qnsd", "display", false} ...
);

m(3).prem = 4;
m(3).r = 8;

m(3) = steady( ...
    m(3) ...
    , solver={"qnsd", "display", false} ...
    , exogenize=["prem", "r"] ...
    , endogenize=["ss_rr", "ss_dl_cpi"] ...
);

checkSteady(m);


%% Report results

t = table( ...
    m, ["steadyLevel", "compareSteadyLevel", "description"] ...
    , round=8 ...
);

list = [
    "ss_rr_ww"
    "ss_dl_cpi_ww"
    "ss_dl_cpi"
    "ss_rr"
    "ss_dl_rex"
    "rr_ww"
    "r_ww"
    "rr"
    "r"
    "dl_cpi"
    "dl_ex"
    "dl_rex"
    "prem"
];

t2 = t(list, :)
