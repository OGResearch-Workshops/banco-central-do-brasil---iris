
close all
clear


load mat/createModel.mat m


m.c0_q5
m = rescaleStd(m, 0);

%m.std_shock_dl_cpi_ww = 3;
m.std_shock_dl_rex_tnd = 0.2;
%m.std_shock_prem_gap = 1;

d = steadydb(m(2), 1:100, shockFunc=@randn, numDraws=2);

p = Plan.forModel(m(1), 1:100);

p = exogenize(p, 1:20, "q"+string(1:5));
p = endogenize(p, 1:20, "shocke_q"+string(1:5));

p = swap(p, 21:100, ["q5", "shocku_q5"], "anticipate", false);

table(p)

% p = exogenize(p, 60:100, "q5");
% p = endogenize(p, 60:100, "shock_q5");
% d.q5(60:100,:) = 0;

d.q5 = arf(d.q5, [1, -0.8], 0, 21:100, prependInput=true);

[s, info, frameDb] = simulate( ...
    m(1), d, 1:100 ...
    , method="stacked" ...
    , prependInput=true ...
    , plan=p ...
    ... , blocks=true ...
);


% Evolution of information sets
h = plot(0:100,[frameDb{1}.q5, s.q5]);
set(h(end), color="black", lineWidth=5, marker="s");


%%

ch = databank.Chartpack();
ch.Range = 0:100;
ch.Round = 8;

ch < "q" + string(1:5);

ch < ["dl_cpi", "l_ex", "r", "r_tar", "l_gdp_gap", "int", "l_rex_tnd"];

draw(ch, s);
