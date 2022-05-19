%% Kalman filter with contributions of prediction errors

%% Clear workspace

close all
clear
%#ok<*CLARRSTR> 
%#ok<*EV2IN> 

load mat/estimateParams.mat mest
load mat/prepareDataFromFred.mat c

startHist = qq(1990,1);
endHist = qq(2022,1);
d = databank.clip(c, -Inf, endHist);

databank.list(c)
databank.list(d)


%% Contributions of prediction erros in measurement variables

f2 = kalmanFilter( ...
    mest, d, startHist:endHist ...
    , "contributions", true ...
    , "outputData", ["predict", "update", "smooth"] ...
);


%% Chart results


figure();
plot([f2.Predict.Mean.log_A, f2.Update.Mean.log_A], range=qq(2015,1):endHist);
visual.highlight(qq(2020,2));
legend("Prediction", "Updating")'
title("Log productivity");

figure();
plot(f2.Update.Contribs.log_A);
legend([access(mest, "measurement-variables"), "Fixed"]);
title("Log productivity");

figure();
plot(f2.Update.Contribs.log_A{:,1:end-1});
legend(access(mest, "measurement-variables"));
visual.highlight(qq(2020,2));
title("Log productivity");

figure();
plot(d.Wage, range=qq(2015,1):endHist);
visual.highlight(qq(2020,2));
title("Wage inflation Q/Q PA");


