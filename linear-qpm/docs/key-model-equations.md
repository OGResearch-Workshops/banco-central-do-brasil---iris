# Key model equations

## Long-term trends module
#### GDP trend assumptions

$$
\Delta y^\mathrm{tnd}_{t}=c_{0}\,\Delta y^\mathrm{tnd}_{t-1}+\left(1-c_{0}\right)\,\Delta y_{\mathrm{ss}}+c_{1}\,y^\mathrm{gap}_{t}+\varepsilon_t+\omega_t
$$

---

#### Real exchange rate trend assumptions

$$
\Delta rex^\mathrm{tnd}_{t}=c_{0}\,\Delta rex^\mathrm{tnd}_{t-1}+\left(1-c_{0}\right)\,\Delta rex_{\mathrm{ss}}+c_{1}\,rex^\mathrm{gap}_{t}+\omega_t+\varepsilon_t
$$

---

#### Real short-term rate trend assumptions

$$
rr^\mathrm{tnd}_{t}=c_{0}\,rr^\mathrm{tnd}_{t-1}+\left(1-c_{0}\right)\,rr_{\mathrm{ss}}+\varepsilon_t+\omega_t
$$

---

#### Real unconvered interest parity

$$
rr^\mathrm{tnd}_{t}-prem^\mathrm{tnd}_{t}=rr^\mathrm{ww,tnd}_{t}+\Delta rex^\mathrm{tnd}_{t+1}
$$

---

#### Foreign real short-term rate trend, FCY

$$
rr^\mathrm{ww,tnd}_{t}=c_{0}\,rr^\mathrm{ww,tnd}_{t-1}+\left(1-c_{0}\right)\,rr^\mathrm{ww}_{\mathrm{ss}}+\omega_t+\varepsilon_t
$$

---

#### Fisher identity for long-term trends

$$
r^\mathrm{tnd}_{t}=rr^\mathrm{tnd}_{t}+\Delta p_{\mathrm{ss}}
$$

---

## Local economy module
#### Aggregate demand equation

$$
y^\mathrm{gap}_{t}=c_{0}\,y^\mathrm{gap}_{t-1}+c_{1}\,\left(y^\mathrm{fws}_{t}-y_{t}\right)-c_{2}\,rr^\mathrm{gap}_{t}-c_{3}\,rlc_{t}+c_{4}\,rex^\mathrm{gap}_{t}+c_{5}\,y^\mathrm{ww, gap}_{t}+\varepsilon_t+\omega_t
$$

---

#### Phillips curve

$$
\Delta p_{t}=c_{0}\,\Delta p_{t-1}+\left(1-c_{0}\right)\,\Delta p^\mathrm{ste}_{t}+c_{1}\,y^\mathrm{gap}_{t}+c_{2}\,rex^\mathrm{gap}_{t}+c_{3}\,\left(\Delta ex^\mathrm{gap}_{t}-c_{4}\,\Delta ex^\mathrm{gap}_{t-1}\right)+\varepsilon_t+\omega_t
$$

---

#### Short-term inflation expectations

$$
\Delta p^\mathrm{ste}_{t}=c_{1}\,\Delta p_{t+1}+\left(1-c_{1}\right)\,\Delta p_{t-1}
$$

---

#### Short-term rate target reaction function

$$
r^\mathrm{tar}_{t}=c_{0}\,r_{t-1}+\left(1-c_{0}\right)\,\left[r^\mathrm{tnd}_{t}+c_{1}\,\left(\Delta_4 p_{t+3}-\Delta p_{\mathrm{ss}}\right)+c_{2}\,y^\mathrm{gap}_{t}+c_{3}\,\Delta ex^\mathrm{gap}_{t}\right]+\varepsilon_t+\omega_t
$$

---

#### Fisher equation

$$
rr_{t}=r_{t}-\Delta p^\mathrm{ste}_{t}
$$

---

#### Uncovered interest parity

$$
r_{t}-prem_{t}+int_{t}=r^\mathrm{ww}_{t}+4\,\left(ex^\mathrm{ste}_{t}-ex_{t}\right)+\varepsilon_t
$$

---

#### Short-term exchange rate expectations

$$
ex^\mathrm{ste}_{t}=c_{1}\,ex_{t+1}+\left(1-c_{1}\right)\,\left[ex_{t-1}+2\,\left(\Delta rex^\mathrm{tnd}_{t}+\Delta_4 p_{t}-\Delta_4 p^\mathrm{ww}_{t}\right)/4\right]
$$

---

## World economy module
#### Foreign demand gap

$$
y^\mathrm{ww, gap}_{t}=c_{0}\,y^\mathrm{ww, gap}_{t-1}+\omega_t+\varepsilon_t
$$

---

#### Short-term foreign rate, FCY

$$
r^\mathrm{ww}_{t}=c_{0}\,r^\mathrm{ww}_{t-1}+\left(1-c_{0}\right)\,\left(rr^\mathrm{ww}_{\mathrm{ss}}+\Delta p^\mathrm{ww}_{\mathrm{ss}}\right)+\omega_t+\varepsilon_t
$$

---

#### Foreign CPI inflation

$$
\Delta p^\mathrm{ww}_{t}=c_{0}\,\Delta p^\mathrm{ww}_{t-1}+\left(1-c_{0}\right)\,\Delta p^\mathrm{ww}_{\mathrm{ss}}+\omega_t+\varepsilon_t
$$

---
