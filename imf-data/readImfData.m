%% Read Brazil's data from IMF portal

close all
clear

mkdir mat
mkdir csv


tic
imfQ = databank.fromIMF.data( ...
    "IFS", Frequency.QUARTERLY, "BR", [] ...
    , applyMultiplier=false ...
    , includeArea=false ...
);
toc

tic
imfM = databank.fromIMF.data( ...
    "IFS", Frequency.MONTHLY, "BR", [] ...
    , applyMultiplier=false ...
    , includeArea=false ...
);
toc

databank.list(imfQ)
databank.list(imfM)

databank.toCSV(imfQ, "csv/imf-quarterly.csv");
databank.toCSV(imfM, "csv/imf-monthly.csv");


save mat/readImfData.mat imfQ imfM

