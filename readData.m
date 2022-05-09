
close all
clear

d1q = databank.fromCSV( ...
    "data-files/all_data_nowcasting_Nov12.csv" ...
    , "dateFormat", @iso ...
    , "enforceFrequency", Frequency.Monthly ...
);

d1q = databank.apply( ...
    d1q, @(x) convert(x, Frequency.Quarterly, "removeMissing", true) ...
);


dq2 = databank.fromCSV("data-files/data2003Q1_raw.csv");

% 
% d2m = databank.fromCSV( ...
%     "data-files/interest_rates.csv" ...
%     , dateFormat="dd/mm/yyyy" ...
%     , enforceFrequency=Frequency.Monthly ...
% );


% d2q = databank.apply(d2m, @(x) convert(x, Frequency.Quarterly));

d3m = databank.fromFred("TB3MS -> r_us");
d3q = databank.apply(d3m, @(x) convert(x, Frequency.Quarterly));

dq = databank.merge("error", d1q, d3q);

save mat/readData.mat dq dq2
databank.toCSV(dq, "data-files/quarterly-databank.csv");
databank.toCSV(dq, "data-files/quarterly-databank2.csv");
