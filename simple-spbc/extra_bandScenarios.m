%% Create conditional forecast scenarios 



%% Clear workspace 


close all
clear



%% Load model and databank 


load mat/estimateParams.mat mest
load mat/prepareDataFromFred.mat c



%% Define dates and clip the input databank 

startHist = qq(1990,1);
endHist = qq(2010,4);
startFcast = endHist + 1;
endFcast = endHist + 40;
chartRange = endHist-30 : endHist+30;

d = databank.clip(c, -Inf, endHist);

f = kalmanFilter(mest, d, startHist:endHist);



%% Prepare a databank.Chartpack object 


ch = databank.Chartpack();
ch.Range = chartRange;
ch.Highlight = startFcast : endFcast;
ch.Tiles = [2, 2];

ch < "Short-term rate: Short";
ch < "PCE inflation: Infl";
ch < "GDP growth: Growth";
ch < "Nominal wage growth: Wage";



%% Hands-free scenario 


init0 = f.Median;

g0 = simulate( ...
    mest, init0, startFcast:endFcast ...
    , "prependInput", true ...
);


g0 = databank.clip(g0, startFcast-1, Inf);


chartDb = databank.merge("horzcat", c, g0);
draw(ch, chartDb);

visual.hlegend( ...
    "bottom" ...
    , "Historical data" ...
    , "Hands-free" ...
);




%% Baseline: Conditioning with multiple shocks 


p3 = Plan.forModel(mest, startFcast:endFcast, "anticipate", true, "method", "condition");
p3 = exogenize(p3, startFcast+(0:3), "R");
p3 = endogenize(p3, startFcast+(0:3), ["Ey", "Ep", "Ea"]);

init3 = f.Median;
init3.R(startFcast+(0:3)) = init3.R(endHist);


g3 = simulate( ...
    mest, init3, startFcast:endFcast ...
    , "plan", p3 ...
    , "prependInput", true ...
);

g3 = databank.clip(g3, startFcast-1, Inf);


chartDb = databank.merge("horzcat", c, g0, g3);
draw(ch, chartDb);

visual.hlegend( ...
    "bottom" ...
    , "Historical data" ...
    , "Hands-free" ...
);


%% Reproduce baseline with Kalman filter, no modification of uncertainty


j3 = struct();
j3.Ey = g3.Ey{startFcast+(0:3)};
j3.Ep = g3.Ep{startFcast+(0:3)};
j3.Ea = g3.Ea{startFcast+(0:3)};

f3 = kalmanFilter( ...
    mest, struct(), startFcast:endFcast ...
    , "initials", {f.Median, f.MSE} ...
    , "override", j3 ...
    , "anticipate", true ...
);


ch.PlotFunc = @errorbar;
chartDb = databank.merge("horzcat", f3.Mean, f3.Std);
draw(ch, chartDb);


%% Reproduce baseline with Kalman filter, no modification of uncertainty

j4 = struct();
j4.Ey = g3.Ey{startFcast+(0:3)};
j4.Ep = g3.Ep{startFcast+(0:3)};
j4.Ea = g3.Ea{startFcast+(0:3)};

d4 = struct();
d4.Short = g3.Short{startFcast+(0:3)};

f4 = kalmanFilter( ...
    mest, d4, startFcast:endFcast ...
    , "initials", {f.Median, f.MSE} ...
    , "override", j4 ...
    , "anticipate", true ...
);


ch.PlotSettings = {"color", [0.5, 0, 0]};
ch.PlotFunc = @errorbar;
chartDb = databank.merge("horzcat", f4.Mean, f4.Std);
draw(ch, chartDb);




