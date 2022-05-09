
close all
clear 
mkdir mat

load ../imf-data/mat/readImfData.mat imfQ imfM

d = struct();

d.ip_u = imfM.AIP_IX;
d.bm = imfM.FDSB_SA_XDC;
d.cpi_u = imfM.PCPI_IX;

d.gdp = imfQ.NGDP_R_SA_XDC;
d.gdp_u = imfQ.NGDP_R_NSA_XDC;

d = databank.clip(d, qq(1995,1), Inf);
d = databank.clip(d, mm(1995,1), Inf);

d.ip = x13.season(d.ip_u, Pickmdl=true);
d.cpi = x13.season(d.cpi_u, Pickmdl=true);

%{
[d.gdp_sa, d.gdp_fct, d.gdp_bct, info] = x13.season( ...
    d.gdp_u ...
    , Forecast_MaxLead=8 ...
    , Forecast_MaxBack=8 ...
    , Pickmdl=true ...
    , Estimate_Save="mdl" ...
    , Output=["d11", "fct", "bct"] ...
);
%}

databank.list(d)

d.pct_gdp =  pct(d.gdp);

d.ip1 = convert(d.ip, Frequency.QUARTERLY, method=@mean, select=1);
d.ip2 = convert(d.ip, Frequency.QUARTERLY, method=@mean, select=[1, 2]);
d.ip = convert(d.ip, Frequency.QUARTERLY, method=@mean);

d.pct_ip1 = 100*(d.ip1 / d.ip{-1} - 1);
d.pct_ip2 = 100*(d.ip2 / d.ip{-1} - 1);
d.pct_ip = 100*(d.ip / d.ip{-1} - 1);

d.bm1 = convert(d.bm, Frequency.QUARTERLY, method=@mean, select=1);
d.bm2 = convert(d.bm, Frequency.QUARTERLY, method=@mean, select=[1, 2]);
d.bm = convert(d.bm, Frequency.QUARTERLY, method=@mean);

d.pct_bm1 = 100*(d.bm1 / d.bm{-1} - 1);
d.pct_bm2 = 100*(d.bm2 / d.bm{-1} - 1);
d.pct_bm = 100*(d.bm / d.bm{-1} - 1);

d.cpi1 = convert(d.cpi, Frequency.QUARTERLY, method=@mean, select=1);
d.cpi2 = convert(d.cpi, Frequency.QUARTERLY, method=@mean, select=[1, 2]);
d.cpi = convert(d.cpi, Frequency.QUARTERLY, method=@mean);

d.pct_cpi1 = 100*(d.cpi1 / d.cpi{-1} - 1);
d.pct_cpi2 = 100*(d.cpi2 / d.cpi{-1} - 1);
d.pct_cpi = 100*(d.cpi / d.cpi{-1} - 1);

list = "pct_" + ["gdp", "cpi"+["","2","1"], "ip"+["","2","1"], "bm"+["","2","1"]];
x = databank.toSeries(d, list, qq(2020,1):qq(2022,4));
spy(x, names=list, markerSize=20, showTrue=true, showFalse=true);

databank.list(d)

save mat/prepareData.mat d

