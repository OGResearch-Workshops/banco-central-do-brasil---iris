function p = local(p)

% Output gap
p.c0_l_gdp_gap = 0.75;
p.c1_l_gdp_gap = 0.05; 0.01;
p.c2_l_gdp_gap = 0.05;
p.c3_l_gdp_gap = 0.02;
p.c4_l_gdp_gap = 0.05;
p.c5_l_gdp_gap = 0.20;
p.cx_l_gdp_gap = 1.00;


% GDP deflator
p.c0_dl_pgdp = 0.5;
p.ss_dl_pgdp_minus_dl_cpi = 0;


% Discounted future income
p.c1_l_gdp_fws = 0.90;


% CPI inflation
p.c0_dl_cpi = 0.60;
p.c1_dl_cpi = 0.08;
p.c2_dl_cpi = 0.02;
p.c3_dl_cpi = 0.01;
p.c4_dl_cpi = 0.50;


% Short-term inflation expectations
p.c1_dl_cpi_ste = 0.80;
p.c2_dl_cpi_ste = 0.80;


end%

