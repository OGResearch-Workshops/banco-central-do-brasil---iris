


close all
clear

load mat/createModel.mat m

%% Stochastic simulations

rng(0);

m.std_Er = 0.001;

d = steadydb(m, 1:40, "shockFunc", @randn, "numColumns", 1000);

s = simulate(m, d, 1:40, "anticipate", false);


%% Asymptotic covariance matrix

c = acf(m);

sqrt(c("log_dP", "log_dP"))

log(real(m.dP))

figure();
plot(log(s.dP));

figure();
histogram(log(s.dP(40, :)));

%% 

ch = databank.Chartpack();
ch.Range = 1:40;
% ch.Transform = @(x) 100*(x-1);
ch.Round = 8;

ch < "Inflation, Q/Q PA: 100*(dP^4-1) ";
ch < "Policy rate, PA: 100*(R^4-1) ";
ch < "Output: Y ";
ch < "Hours Worked: N ";
ch < "Real Wage: W/P ";
ch < "Capital Price: Pk"; 
ch < "Productivity: A ";

draw(ch, databank.retrieveColumns(s, 1));


%% Create "historical" databank

h = databank.retrieveColumns(s, 1);
h = databank.redate(h, 40, qq(2022,1));

mkdir csv
% databank.toCSV(h, "csv/quasi-history.csv", "decimals", 16);








