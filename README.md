# inla-terrorism-project
Code for my honours research project - "Modelling Terrorism Incidents in Iraq as a Log-Gaussian Cox Process". Here I will list the different files I have and what they are :)

### data_iraq.xlsx
This is data from the Global Terrorism Database. It has around 25,000 datapoints, each corresponding to a terrorist attack in Iraq. Data such as time, location and attack type is recorded. 

### pop.RData
Contains information about population in Iraq to be used as a covariate.

### road.RData
Contains information about the distance from each point in Iraq to the nearest primary road, also to be used as a covariate.

### Monthly_AR1.R
This program fits a log-Gaussian Cox model to terrorist attacks each month in 2017. The Gaussian random field is assumed to be autoregressive(1). Note that high-performance computer systems may be required to run this code!

### Yearly_AR1.R
This program fits a log-Gaussian Cox model to terrorist attacks each year from 2007-2018. The Gaussian random field is assumed to be autoregressive(1).
