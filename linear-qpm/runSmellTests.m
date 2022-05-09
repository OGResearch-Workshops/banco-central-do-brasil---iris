
close all
clear

load mat/createModel.mat m

m = alter(m, 2);

m.c2_dl_cpi_ste = [1, 0.8];

m.c1_int = [0, 1500];
m.c1_r = [0, 2.5];

m.c1_r_tar = [2.5, 2];
m.c2_r_tar = [0, 1];
m.c4_r_tar = [0, 0];
m.c4_r_tar = [0, -2];

m = solve(m);


%% Prepare chartpack

ch = databank.Chartpack();
ch.Range = 0 : 40;
ch.Round = 8;

ch < ["dl_cpi", "l_cpi", "l_gdp_gap", "cumsum(l_gdp_gap)/4", "r", "dl_ex", "l_rex_gap"];
ch < ["l_gdp_fws-l_gdp", "l_ex-l_ex_tar", "int"];


%% Disinflation 

% {
m1 = m;
m1.ss_dl_cpi = m1.ss_dl_cpi - 1;
m1 = steady(m1);
m1 = solve(m1);

d = steadydb(m, 0:40);
s = simulate( ...
    m1, d, 1:40 ...
    , prependInput=true ...
);
draw(ch, s);
% }


%% Delayed policy reaction 

d = zerodb(m, 0:40);
d.shock_l_gdp_gap(1:1) = 1;
s1 = simulate( ...
    m, d, 1:40 ...
   , deviation=true ...
   , prependInput=true ...
);

T = 6;
p2 = Plan.forModel(m, 1:40);
p2 = exogenize(p2, 1:T, "r");
p2 = endogenize(p2, 1:T, "shock_r");
d.r(1:T) = 0;
s2 = simulate( ...
    m, d, 1:40 ...
   , deviation=true ...
   , plan=p2 ...
   , prependInput=true ...
);

draw(ch, s1);
draw(ch, databank.merge("horzcat", s1, s2));

% {
%% Future cost-push shock 

d = zerodb(m, 0:40);
d.shock_dl_cpi(5) = 1;
s = simulate( ...
    m, d, 1:40 ...
    , deviation=true ...
    , prependInput=true ...
);
draw(ch, s);
% }

