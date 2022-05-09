
close all
clear


%% Prepare model

load mat/createModel.mat m

m = alter(m, 3);
m.c2_dl_cpi_ste = [1, 1, 0.8];
checkSteady(m);
m = solve(m);


%% Plot stable eigenvalues

e = access(m, "stableRoots");

visual.eigen(e);

h = visual.hlegend("bottom", "IT", "FXR", "FXR with ss_dl_cpi");
set(h, "fontSize", 22, "interpreter", "none");
title("Stable eigenvalues");


%% Plot unstable eigenvalue

u = access(m, "unstableRoots");
ui = 1 ./ u;

visual.eigen(ui);

h = visual.hlegend("bottom", "IT", "FXR", "FXR with ss_dl_cpi");
set(h, "fontSize", 22, "interpreter", "none");
title("Unstable eigenvalues");



%% Solution matrices


s = solutionMatrices(m(2));

[n, nb] = size(s.T);
nf = n - nb;

T2 = s.T(nf+1:end, :);
T2 = round(T2, 8);


% xb = U * alpha
U = round(s.U, 8);

s.U(:, ["alpha19", "alpha20"])

