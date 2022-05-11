
close all
clear


load mat/createModel.mat m



[C, R] = acf(m, order=1);

access(m, "measurement-vector")'
access(m, "transition-vector")'

size(C)
size(R)

C

R

disp("Covariance submatrices for log_N, log_dP, log_R")
C(["log_N", "log_dP", "log_R"], ["log_N", "log_dP", "log_R"], :)

disp("Correlation submatrices for log_N, log_dP, log_R")
R(["log_N", "log_dP", "log_R"], ["log_N", "log_dP", "log_R"], :)


freq = linspace(0, pi, 1000);
[S, D] = xsf(m, freq);

s1 = S("log_Y", "log_Y", :);
plot(freq, s1);
title("Power spectrum for output");
set(gca(), 'XLim', [2*pi/40, pi]);


% ACF for a band of frequencies betwen 4 and 40 quarters
[C1, R1] = acf(m, order=1, filter='per>=4 & per<=40');

% ACF for all model variables subjected to a 1,600 Hp
[C2, R2] = acf(m, order=1, filter='1600/(1600 + 1/abs((1-L)^2)^2)');


