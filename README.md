# inla-terrorism-project
Code for my honours research project - "Modelling Terrorism Incidents in Iraq as a Log-Gaussian Cox Process". Here, I list the different files I have and what they are :)
Note that INLA needs to first be installed. A high-performance computing system was used for some of the more complex models so some of the code may take a while to run.

### data_iraq.xlsx
This is data from the Global Terrorism Database. It has around 25,000 datapoints, each corresponding to a terrorist attack in Iraq. Data such as time, location and attack type is recorded. 

### pop.RData
Contains information about population in Iraq to be used as a covariate.

### Spatial_All_Covariates.R
This program fits a log-Gaussian Cox model (with population and distance-to-road covariates) to terrorism data from 2017.

### road.RData
Contains information about the distance from each point in Iraq to the nearest primary road, also to be used as a covariate.

### Monthly_AR1.R
This program fits a log-Gaussian Cox model to terrorist attacks each month in 2017. The Gaussian random field is assumed to be autoregressive(1).

### Yearly_AR1.R
This program fits a log-Gaussian Cox model to terrorist attacks each year from 2007-2018. The Gaussian random field is assumed to be autoregressive(1).
