# Create conditional forecast scenarios



## Clear workspace

```matlab
close all
clear
```


## Load model and databank

```matlab
load mat/estimateParams.mat mest
load mat/filterHistData.mat f
```


## Define dates and clip the input databank

```matlab
endHist = qq(2010,4);
startFcast = endHist + 1;
endFcast = endHist + 40;
chartRange = endHist-30 : endHist+30;
d = databank.clip(f.mean, -Inf, endHist);
```


## Prepare a databank.Chartpack object

```matlab
ch = databank.Chartpack();
ch.Range = chartRange;
ch.Highlight = startFcast : endFcast;
ch.PlotSettings = {"marker", "s"};
ch.Tiles = [2, 4];

ch < "Short-term rate: Short";
ch < "PCE inflation: Infl";
ch < "GDP growth: Growth";
ch < "Nominal wage growth: Wage";
ch < "Short-term rate shocks: Er";
ch < "Consumer utility shocks: Ey";
ch < "Productivity shocks: Ea";
ch < "PCE inflation shocks: Ep";
```


## Hands-free scenario

```matlab
g0 = simulate( ...
    mest, d, startFcast:endFcast ...
    , "prependInput", true ...
);

chartDb = databank.merge("horzcat", d, databank.clip(g0, startFcast-1, Inf));
draw(ch, chartDb);

visual.hlegend( ...
    "bottom" ...
    , "Historical data" ...
    , "Hands-free" ...
);
```


## Exogenize policy rate, endogenize policy shocks

```matlab
p1 = Plan.forModel(mest, startFcast:endFcast);
p1 = exogenize(p1, startFcast+(0:3), "R");
p1 = endogenize(p1, startFcast+(0:3), "Er");

d.R(startFcast+(0:3)) = d.R(endHist);

g1 = simulate( ...
    mest, d, startFcast:endFcast ...
    , "plan", p1 ...
    , "prependInput", true ...
);

chartDb = databank.merge( ...
    "horzcat" ...
    , d ...
    , databank.clip(g0, startFcast-1, Inf) ...
    , databank.clip(g1, startFcast-1, Inf) ...
);

draw(ch, chartDb);

visual.hlegend( ...
    "bottom" ...
    , "Historical data" ...
    , "Hands-free" ...
    , "Exogenize R<->Er" ...
);
```


## Exogenize policy rate, endogenize demand shocks

```matlab
p2 = Plan.forModel(mest, startFcast:endFcast);
p2 = exogenize(p2, startFcast+(0:3), "R");
p2 = endogenize(p2, startFcast+(0:3), "Ey");

g2 = simulate( ...
    mest, d, startFcast:endFcast ...
    , "plan", p2 ...
    , "prependInput", true ...
);

chartDb = databank.merge( ...
    "horzcat" ...
    , d ...
    , databank.clip(g0, startFcast-1, Inf) ...
    , databank.clip(g1, startFcast-1, Inf) ...
    , databank.clip(g2, startFcast-1, Inf) ...
);
draw(ch, chartDb);

visual.hlegend( ...
    "bottom" ...
    , "Historical data" ...
    , "Hands-Free" ...
    , "Exogenize R<->Er" ...
    , "Exogenize R<->Ey" ...
);
```


## Conditioning with multiple shocks

```matlab
p3 = Plan.forModel(mest, startFcast:endFcast, "anticipate", true, "method", "condition");
p3 = exogenize(p3, startFcast+(0:3), "R");
p3 = endogenize(p3, startFcast+(0:3), ["Ey", "Ep", "Ea"]);

g3 = simulate( ...
    mest, d, startFcast:endFcast ...
    , "plan", p3 ...
    , "prependInput", true ...
);
```

Run the same but turn off the Ea shocks in the first two periods

```matlab
p4 = p3;
p4 = assignSigma(p4, startFcast+(0:1), "Ea", 0);
g4 = simulate( ...
    mest, d, startFcast:endFcast ...
    , "plan", p4 ...
    , "prependInput", true ...
);

chartDb = databank.merge( ...
    "horzcat" ...
    , d ...
    , databank.clip(g0, startFcast-1, Inf) ...
    , databank.clip(g1, startFcast-1, Inf) ...
    , databank.clip(g2, startFcast-1, Inf) ...
    , databank.clip(g3, startFcast-1, Inf) ...
    , databank.clip(g4, startFcast-1, Inf) ...
);
draw(ch, chartDb);

visual.hlegend( ...
    "Bottom" ...
    , "Historical data" ...
    , "Hands-Free" ...
    , "R<->Er" ...
    , "R<->Ey" ...
    , "R<->(Ey, Ep, Ea)" ...
    , "R<->(Ey, Ep, Ea) with Ea turned off in 2 periods" ...
);
```


## Forecast bands: Matching the mean(s)
 
* Run a Kalman filter on the forecast range to produce forecast bands and
  conditional forecast bands
 
* Tune the interest rate in expectations but keep forecast risks
  (dispersion)
 
* Implement this by moving the means of the shock distributions to the values calculated in the
  previous simulations to reproduce the mean path for the interest rate
 
* Treat initial conditions as given (fixed)


```matlab bands

[~, f0] = filter( ...
    mest, d, startFcast:endFcast ...
    , "init", d ...
    , "anticipate", true ...
    , "relative", false ...
);
```


```matlab bands
expectedMeans = struct();
expectedMeans.Ey = g3.Ey;
expectedMeans.Ep = g3.Ep;
expectedMeans.Ea = g3.Ea;

[~, f3] = filter( ...
    mest, d, startFcast:endFcast ...
    , "init", d ...
    , "override", expectedMeans ...
    , "anticipate", true ...
    , "relative", false ...
);

figure();
title("Short-term rate");
hold on;
plot(chartRange, d.Short);
errorbar(chartRange, [f0.mean.Short, f0.std.Short]);
errorbar(chartRange, [f3.mean.Short, f3.std.Short]);
visual.hlegend( ...
    "bottom" ...
    , "Historical data" ...
    , "Hands-Free" ...
    , "Conditional - Match the mean value" ...
);
```


## Forecast bands: Removing (part of) dispersion
 
* Tune the interest rate forecast to a single point without any risks
(dispersion)
 
* Implement this by delivering exact values for a measurement variable


```matlab bands
d.Short(startFcast+(0:3)) = d.Short(endHist);

[~, f5] = filter( ...
    mest, d, startFcast:endFcast ...
    , "init", d ...
    , "override", expectedMeans ...
    , "relative", false ...
    , "anticipate", true ...
);

figure();
title("Short-term rate");
hold on;
plot(chartRange, d.Short);
errorbar(chartRange, [f0.mean.Short, f0.std.Short]);
errorbar(chartRange, [f3.mean.Short, f3.std.Short]);
errorbar(chartRange, [f5.mean.Short, f5.std.Short]);
visual.hlegend( ...
    "bottom" ...
    , "Historical data" ...
    , "Hands-Free" ...
    , "Conditional - Match the mean value" ...
    , "Conditional - Remove dispersion" ...
);

figure();
title("PCE inflation");
hold on;
plot(chartRange, d.Infl);
errorbar(chartRange, [f0.mean.Infl, f0.std.Infl]);
errorbar(chartRange, [f3.mean.Infl, f3.std.Infl]);
errorbar(chartRange, [f5.mean.Infl, f5.std.Infl]);
visual.hlegend( ...
    "bottom" ...
    , "Historical data" ...
    , "Hands-Free" ...
    , "Conditional - Match the mean value" ...
    , "Conditional - Remove dispersion" ...
);
```

