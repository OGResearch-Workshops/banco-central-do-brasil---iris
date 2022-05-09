function p = world(p)


% Steady-state parameters

p.ss_rr_ww = NaN;
p.ss_dl_cpi_ww = 5;


% Reverse engineer ss_rr_ww
p.r_ww = 2;


% Dynamic parameters

p.c0_l_gdp_ww_gap = 0.8;
p.c0_r_ww = 0.8;
p.c0_dl_cpi_ww = 0.8;
p.c1_rr_ww = 0.5;

end%

