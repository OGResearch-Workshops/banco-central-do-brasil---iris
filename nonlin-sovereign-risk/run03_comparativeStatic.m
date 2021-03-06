%% Simple comparative static 


%% Clear workspace 

close all
clear

load mat/createModel.mat m


%% Create multiple parameter variants 

m = alter(m, 50);

m.ss_nga_to_4ny = linspace(0.50, -1.5, 50);

m = steady(m);

table( ...
    m, ["steadyLevel", "compareSteadyLevel", "form", "description"] ...
    , "writeTable", "xlsx/comparativeStatic.xlsx" ...
)


%% Chart the implied sovereign risk 

figure();

subplot(1, 2, 1);
plot(100*real(m.ss_nga_to_4ny), 400*real(m.q));

title("Expected sovereign loss as a function of government debt to GDP ratio [pp PA]");
xlabel("Net government assets to GDP ratio [% PA]")
ylabel("Expected sovereign loss, % PA");

subplot(1, 2, 2);
plot(100*real(m.ss_nga_to_4ny), 400*real(m.r));

title("Interest rate as a function of government debt to GDP ratio [pp PA]");
xlabel("Net government assets to GDP ratio [% PA]")
ylabel("Interest rate, % PA");

