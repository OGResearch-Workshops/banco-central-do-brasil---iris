# Iris Toolbox workshop for the Central Bank of Brazil

## Preliminary program

The workshop is organized in daily three-hour sessions over two weeks

* The main topics will be first introduced at a basic theoretical/conceptual level
* The practical illustrations will be based on a variety of actual models and data

### Week 1 

#### Monday 

Overview of Iris Toolbox functionality

* Structural modeling (`Model`, `Plan`, `Explanatory`, `LinearSystem`)
* Time series modeling (`VAR`, `SVAR`, `+dummy`, `PanelVAR`, `Armani`, `ParArmani`)
* Data and time series management (`Series`, `+databank`, `Dater`)
* Interfaces for external data sources (IMF, Fred, ECB)
* Visualization and reporting (`+databank.Chartpack`, `+rephrase`)
* Estimation (`SystemProperty`, `SystemPrior`, `Posterior`)
* Kalman filtering (`Kalman`)

#### Tuesday

Simulation and forecasting techniques in linear models 

* State space representation 
* Triangular and rectangular forms
* Forward expansion (anticipated events)


#### Wednesday 

Simulation and forecasting techniques in linear models (cont)

* Analytical calculations of deterministic and stochastic properties
* Time domain and frequency domain
* Stochastic simulations

#### Thursday

Simulation and forecasting techniques in linear models (cont)

* Simulating anticipated and unanticipated events
* Conditioning techniques: excatly determined vs underdetermined
* Practical construction of more complex scenarios 
* Analytical error bands: point vs mean conditions

#### Friday

Theoretical introduction to simulation techniques in nonlinear models

* Steady-state vs dynamic simulations
* Stacked time algorithm with first-order terminal condition
* Quasi-Newton-Steepest-Descent solver

### Week 2

#### Monday 

Practical simulation techniques in nonlinear models

* Simulating anticipated and unanticipated events
* Conditioning techniques: excatly determined vs underdetermined
* Stochastic simulations in nonlinear models


#### Tuesday

Kalman filtering in linear models

* Tweaks in the Iris implementation of the Kalman filter
* Practical use of the Kalman filter: Missing observations, anticipated shocks, judgmental conditions, etc

#### Wednesday 

Bayesian estimation with system priors

* Introduction to the system properties and system prior
* Posterior mode maximization and Random-walk based posterior simulator
* Iris implementation

#### Thursday

Practical use of system priors

* Practical advantages and examples of system priors
* Simulation based system priors: Sacrifice ratio, sign restrictions, response duration
* Frequency domain system priors: Business cycle definition, signal-noise ratio

#### Friday

No specific agenda assigned

* Time buffer for the workshop
* On-demand experiments
* Questions and answere

