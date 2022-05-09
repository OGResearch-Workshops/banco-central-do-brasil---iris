%% Create model object 


%% Clear workspace 

close all
clear
 

%% Read source files and create model object 

% Create a model object based on a subset of modules

modelFiles = [...
  "model-source/world.model"
  "model-source/macro.model"
  "model-source/bankCapital.model"
  "model-source/creditCreation.model"
  "model-source/creditRisk.model"
  "model-source/interestRates.model"  
  "model-source/loanPerformance.model"  
  "model-source/prudentialProvisions.model"
  "model-source/financialProvisions.model"
  "model-source/postprocessor.model"
  "model-source/preprocessor.model"
];

m = Model.fromFile( ...
    modelFiles ...
    , growth=true...
    , assign=struct("segments", ["HH", "MG", "NFC"]) ...
    , savePreparsed="model-source/__preparsed.model" ...
);

