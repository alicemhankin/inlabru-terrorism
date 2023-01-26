# inla-terrorism-project
Code and other files related to my honours research project - "Modelling Terrorism Incidents in Iraq as a Log-Gaussian Cox Process". Here, I list the different files I have and what they are :)

Note that to run the code, INLA needs to first be installed. A high-performance computing system was used for some of the more complex models so be warned that the code may take a while to run!

### Things you might want to see

- 📒 **Final Report.pdf** - this is the final report for this project. It describes the mathematical concepts underlying log-Gaussian Cox processes and INLA, as well as giving the results of my analysis. 

- 🗣 **Talk.mp4** - a 17-minute talk which summarises the entire project. This is a lot easier to parse than the full 50 page report!

- 👩‍🏫 **Slideshow.pdf** - the slideshow for the talk above.

### Code
All other files are related to the code itself:

- **data_iraq.xlsx** - this is data from the Global Terrorism Database. It has around 25,000 datapoints, each corresponding to a terrorist attack in Iraq. Data such as time, location and attack type is recorded. 

- **pop.RData** - contains information about population in Iraq to be used as a covariate.

- **Spatial_All_Covariates.R** - this program fits a log-Gaussian Cox model (with population and distance-to-road covariates) to terrorism data from 2017.

- **road.RData** - contains information about the distance from each point in Iraq to the nearest primary road, also to be used as a covariate.

- **Monthly_AR1.R** - this program fits a log-Gaussian Cox model to terrorist attacks each month in 2017. The Gaussian random field is assumed to be autoregressive(1).

- **Yearly_AR1.R** - this program fits a log-Gaussian Cox model to terrorist attacks each year from 2007-2018. The Gaussian random field is assumed to be autoregressive(1).
