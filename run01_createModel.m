%% Read and Solve Models with Optimal Policy
%
% Load the model file |optimal_policy.model| and create three different
% versions of it: a model with a simple policy rule, an optimal
% discretionary (time-consistent) policy model, and an optimal commitment
% policy model. Calibrate, solve and save the model objects for further
% use.

%% Clear Workspace
%
% Clear workspace, close all graphics figures, clear command window, and
% check the IRIS version.

close all
clear
mkdir mat

%% Load Three Versions of the Model
%
% Create a parameter database, |P|, before loading the model file. The same
% parameter database will be reused in all versions of the model.
%
% Load the model file three times, using different combinations of the
% switch |optimal_policy| (a user-defined switch used in the model file to
% distinguish a model with a simple rule versus models with optimal policy
% defined by a loss function), and the option |Optimal=|, which controls
% the details of the optimal policy calculated.
%
% # Set |optimal_policy=false| in the model file to load the model with a
% simple inflation-targeting rule.
% # Set |optimal_policy=true| in the model file to load the model with a loss function, 
% and then  set |Optimal='discretion'| when calling the function |model( )|
% telling IRIS to calculate equations that describe discretionary optimal
% policy. Under discretion, the expectations (leads of variables) are taken
% as given, and not differentiated with respect to.
% # Set |optimal_policy=true| to load the model file with a loss function, 
% and set |optimal=' 'commitment'| when calling the functin |model( )|
% telling IRIS to calculate equations that describe optimal commitment
% policy. Under commitment, the expectations (leads of variables) used by
% the policymaker to optimize the loss function.

P = struct(); % [^Parameter database]
P.del1 = 0.7; 0.5;
P.del2 = 0.1;
P.sgm = 0.05;
P.alp = 0.65; 0.5;
P.gam = 0.1;
P.bet = 0.9; 0.99;
P.lmb1 = 0.1;
P.lmb2 = 0.1;
P.lmb3 = 0;
P.rho = 0.8;
P.mu = 5;
P.targ = 2;
P.cutoff = 2;

P

m1 = Model.fromFile( ...
    "model-source/optimal-policy.model" ...
    , "assign", struct("optimal_policy", false) ...
); 
m1 = assign(m1, P);



m2 = Model.fromFile( ...
    "model-source/optimal-policy.model" ...
    , "assign", P ... 
    , "assign", struct("optimal_policy", true) ...
    , "optimal", {"type", "discretion"} ...
); 
m2 = assign(m2, P);


m3 = Model.fromFile( ...
    "model-source/optimal-policy.model" ...
    , "assign", P ... 
    , "assign", struct("optimal_policy", true) ...
    , "optimal", {"type", "commitment"} ...
);
m3 = assign(m3, P);


%% Show newly created equations
%
% In model objects |m2| and |m3|, IRIS calculates the equations
% corresponding to the derivatives of the Lagrangian (i.e. the loss
% function and the model equations) wrt individual variables, and adds
% these equations to the model, together with the corresponding number of
% newly created variables, the Lagrange mutlipliers associated with
% individual equations (see below). Under discretion, |m2|, the
% expectations (leads) are taken as given (#eqtnDiscret), and hence the
% terms relating to the expectations are missing from the equations
% compared with commitment, |m3| (#eqtnCommit).

eqtn1 = access(m1, "equations")'

eqtn2 = access(m2, "equations")'

eqtn3 = access(m3, "equations")'


%% Initial conditions needed

initials1 = access(m1, "initials")'

initials2 = access(m2, "initials")'

initials3 = access(m3, "initials")'


%% Solve Models and Compute Steady State
%
% All the three models are linear (in the case of optimal policy models, a
% linear model with a quadratic loss function always results in a linear
% model). Calculate first their first-order solutions (#solve) (steady
% state does need to be known in linear models), and then, based on the
% dynamic solution, determine the steady state (#sstate). Use the function
% |get| to retrieve a database with the steady-state values (#getSstate).
% The steady state values are identical for all three models. In the
% optimal policy models, |m2| and |m3|, the steady-state databases also
% include the newly created Lagrange multipliers, |Mu_Eq1| and |Mu_Eq2|.

m1 = steady(m1); %(#sstate)
m1 = solve(m1); %(#solve)
ss1 = access(m1, "steady") %(#getSstate)

m2 = steady(m2); %(#sstate)
m2 = solve(m2); %(#solve)
ss2 = access(m2, "steady") %(#getSstate)

m3 = steady(m3);  %(#sstate)
m3 = solve(m3); %(#solve)
ss3 = access(m3, "steady") %(#getSstate)


%% Verify Steady State
%
% Verify that the steady state databases are identical for all three
% models, (#verifySstate).

maxabs(ss1, ss2) %(#verifySstate)
maxabs(ss3, ss2) %(#verifySstate)

%% Save Model Objects for Further Use
%
% Save the solved model objects to a mat-file (binary file) for further
% use.

save mat/createModel.mat m1 m2 m3

