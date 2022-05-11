
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


