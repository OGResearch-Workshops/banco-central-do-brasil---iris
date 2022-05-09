

close all
clear

sf0 = databank.fromCSV("data-files/final0.csv");
sf = databank.fromCSV("data-files/final.csv");
load mat/preprocessData.mat startHist endHist
load mat/createModel.mat m
m = m(2);

startForecast = endHist + 1;
endForecast = endHist + 10*4;

% list = access(m, "initials");
% list(~contains(list, "{-1}")) = [];
% list = erase(list, "{-1}");
% 
% for n = list
%     fprintf("\n%s: %.16f", n, rf.(n)(startForecast-1)-sf.(n)(startForecast-1))
% end
% fprintf("\n");
% 
% return

list = access(m, "transition-shocks");
list(~startsWith(list, "rec_")) = [];

p = Plan.forModel(m, startForecast-1:endForecast);
p = exogenize(p, startForecast-1, erase(list, "rec_"));
p = endogenize(p, startForecast-1, list);

%%

rf = simulate( ...
    m, sf, startForecast-1:endForecast ...
    , prependInput=true ...
    , plan=p ...
);
return

%%

global ggg
ggg= {};

test1 = simulate( ...
    m, rf, startForecast:endForecast ...
    , prependInput=true ...
);

test2 = simulate( ...
    m, sf, startForecast:endForecast ...
    , prependInput=true ...
);

return

%% Marginal contribution of all initial conditions

% rf:  initial conditions, shocks, simulated variables
% sf0: initial conditions, shocks, simulated variables

ch = databank.Chartpack();
ch.Range = endHist-3*4 : endForecast;
ch.Round = 8;
ch.Highlight = startForecast : endForecast;
%ch.PlotSettings = {"marker", "none", "color", [0.8500    0.3250    0.0980], {"lineStyle"}, {"-"; "--"}};
ch.PlotSettings = {"marker", "none", {"lineStyle"}, {"-"; "--"}};

ch < ["[dl_cpi]", "[r]", "[l_gdp_gap]", "dl_gdp_tnd", "[dl_gdp]", "[l_rex_gap]", "tune_dl_cpi", "tune_l_gdp"];

draw(ch, databank.merge("horzcat", sf, rf));
