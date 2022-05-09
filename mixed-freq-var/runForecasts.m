
close all
clear
mkdir mat

load mat/prepareData.mat d
load mat/estimateVARs.mat v1 v2 v3

endBalanced = qq(2021,4);
startFcast = endBalanced + 1;
endFcast = endBalanced + 8;

x = databank.toSeries(d, v1.EndogenousNames, qq(2020,1):qq(2022,4));
spy(x, names=v1.EndogenousNames, markerSize=40, showTrue=true, showFalse=true);
visual.highlight(qq(2020,1):endBalanced);

db = databank.clip(d, -Inf, endBalanced);

[~, fb1] = filter(v1, db, startFcast:endFcast, meanOnly=true);
fb1 = databank.merge("vertcat", db, fb1);

du = d;
[~, fu1] = filter(v1, du, startFcast:endFcast, meanOnly=true);
fu1 = databank.merge("vertcat", db, fu1);

save mat/runForecasts.mat db du fb1 fu1 endBalanced startFcast endFcast


