
close all
clear

load mat/prepareData.mat d

monthlyNames = "pct_" + ["cpi", "ip", "bm"];
list = ["pct_gdp", monthlyNames, monthlyNames+"2", monthlyNames+"1"];

p = 1;


% Unconstrained VAR 

v1 = VAR(list, order=p, intercept=true);
v1 = estimate(v1, d, qq(2000,1):qq(2022,4));



% VAR with parameter constraints

A = nan(10, 10, p);
A(:, 5:end, :) = 0;

v2 = VAR(list, order=p, intercept=true);
v2 = estimate(v2, d, qq(2000,1):qq(2022,4), "A", A);


% VAR with prior dummy observations

u = dummy.Litterman(0, sqrt(40), 0);

v3 = VAR(list, order=p, intercept=true, standardize=true);
v3 = estimate(v3, d, qq(2000,1):qq(2022,4), dummy=u);


save mat/estimateVARs.mat v1 v2 v3
