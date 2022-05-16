

close all
clear

load mat/createModel.mat m

%m.xip = 10;
% m.kappan = 0.3
m.xip = 100;
m.xiw = 100;
m = solve(m);


%% Load history

h = databank.fromCSV("csv/quasi-history-2.csv");

endHist = qq(2022,1);
startSim = endHist + 1;
endSim = endHist + 5*4;


%% Prepare chartpack

ch = databank.Chartpack();
ch.Range = endHist-8 : endHist+12;
ch.Highlight = endHist-8 : endHist;
ch.Round = 8;

ch < "Inflation, Q/Q PA: 100*(dP^4-1) ";
ch < "Policy rate, PA: 100*(R^4-1) ";
ch < "Output: Y ";
ch < "Output growth: apct(Y) ";
ch < "Hours Worked: N ";
ch < "Real Wage: W/P";
ch < "Capital Price: Pk"; 
ch < "Productivity: A ";
ch < "Real marginal cost: RMC ";
ch < "^100*Ep";
ch < "^100*Ey";
ch < "^100*Ew";
ch < "^100*Er";


%% Run hands-free

s0 = simulate(m, h, startSim:endSim, "prependInput", true);

% draw(ch, s0);


%% Run flat rate track with policy shocks

p1 = Plan.forModel(m, startSim:endSim);
p1 = exogenize(p1, startSim+(0:3), "R");
p1 = endogenize(p1, startSim+(0:3), "Er");

d1 = h;
d1.R(startSim+(0:3)) = d1.R(endHist);

s1 = simulate( ...
    m, d1, startSim:endSim ...
    , "prependInput", true ...
    , "plan", p1 ...
);



p2 = Plan.forModel(m, startSim:endSim, "anticipate", false);
p2 = exogenize(p2, startSim+(0:3), "R");
p2 = endogenize(p2, startSim+(0:3), "Er");

d2 = h;
d2.R(startSim+(0:3)) = d2.R(endHist);

s2 = simulate( ...
    m, d2, startSim:endSim ...
    , "prependInput", true ...
    , "plan", p2 ...
);

% draw(ch, databank.merge("horzcat", s0, s1, s2));
% visual.hlegend("bottom", "Hands-free", "Flat R anticipated", "Flat R unanticipated");



%% Run flat rate track with policy shocks, unexpected cost-push down the road


p3 = Plan.forModel(m, startSim:endSim);
p3 = anticipate(p3, false, "Ep");
p3 = exogenize(p3, startSim+(0:3), "R");
p3 = endogenize(p3, startSim+(0:3), "Er");

d3 = h;
d3.R(startSim+(0:3)) = d3.R(endHist);
d3.Ep(startSim+2) = -0.01;

[s3, info, frames3] = simulate( ...
    m, d3, startSim:endSim ...
    , "prependInput", true ...
    , "plan", p3 ...
    , "window", 20 ...
);

draw(ch, databank.merge("horzcat", s0, s1, s3));
visual.hlegend("bottom", "Hands-free", "Flat R anticipated", "Flat R with cost push shock");


%% The same as before but split manually

p4 = p3;
d4 = h;
d4.R(startSim+(0:3)) = d4.R(endHist);
s4 = simulate( ...
    m, d4, startSim:endSim ...
    , "prependInput", true ...
    , "plan", p3 ...
    , "window", 20 ...
);


p5 = Plan.forModel(m, startSim+2:endSim);
p5 = exogenize(p5, startSim+(2:3), "R");
p5 = endogenize(p5, startSim+(2:3), "Er");


d5 = s4;
d5.Ep(startSim+3) = -0.01;
s5 = simulate( ...
    m, d5, startSim+2:endSim ...
    , "prependInput", true ...
    , "plan", p5 ...
);

draw(ch, databank.merge("horzcat", s0, s3, s5));
visual.hlegend("bottom", "Hands-free", "Flat R with cost push shock", "Flat R with future cost push shock");


%%

figure();
plot(100*[s0.dP, s1.dP, s3.dP, s5.dP]^4, range=endHist:endHist+10, marker="s");
title("Inflation");



%% Flat rates consistent with supply side pressures

p6 = Plan.forModel(m, startSim:endSim);
p6 = exogenize(p6, startSim+(0:3), "R");
p6 = endogenize(p6, startSim+(3), "Ew");
p6 = endogenize(p6, startSim+(0:2), "Er");

d6 = h;
d6.R(startSim+(0:3)) = d6.R(endHist);

s6 = simulate( ...
    m, d6, startSim:endSim ...
    , "prependInput", true ...
    , "plan", p6 ...
);

draw(ch, databank.merge("horzcat", s1, s6));



%% Flat rates consistent with multiple supply side shocks

p7 = Plan.forModel(m, startSim:endSim, method="condition");
p7 = exogenize(p7, startSim+(0:3), "R");
p7 = endogenize(p7, startSim+(0:3), "Ew");
p7 = endogenize(p7, startSim+(0:3), "Ep");  

d7 = h;
d7.R(startSim+(0:3)) = d7.R(endHist);

s7 = simulate( ...
    m, d7, startSim:endSim ...
    , "prependInput", true ...
    , "plan", p7 ...
);

m.std_Ew = 0.50;
p8 = Plan.forModel(m, startSim:endSim, method="condition");
p8 = exogenize(p8, startSim+(0:3), "R");
p8 = endogenize(p8, startSim+(0:3), "Ew");
p8 = endogenize(p8, startSim+(0:3), "Ep");

d8 = d7;
s8 = simulate( ...
    m, d8, startSim:endSim ...
    , "prependInput", true ...
    , "plan", p8 ...
);

draw(ch, databank.merge("horzcat", s7));


