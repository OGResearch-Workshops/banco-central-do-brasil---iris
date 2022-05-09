
close all
clear


load mat/createModel.mat m


x1 = solutionMatrices(m);


x2 = solutionMatrices(m, triangular=false);


figure()
spy(abs(x1.T(:,:,1))>1e-10);

figure()
spy(abs(x2.T(:,:,1))>1e-10);