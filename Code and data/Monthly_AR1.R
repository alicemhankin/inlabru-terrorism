## ---- packages
library(readxl)
library(raster)
library(tidyverse)
library(adehabitatMA)
library(inlabru)
library(INLA)
#######################################
#######################################
#######################################


data <- read_excel("data_iraq.xlsx")

data_iraq <- data %>%
  subset(!is.na(latitude) & !is.na(longitude) & !is.na(iyear) & !is.na(imonth))%>%
  subset(iyear == 2017) %>%
  dplyr::select(c("longitude", "latitude", "imonth"))


data_iraq[data_iraq=="Armed Assault"] <- "Armed_Assault"
data_iraq[data_iraq=="Bombing/Explosion"] <- "Bombing_Explosion"
data_iraq[data_iraq=="Facility/Infrastructure Attack"] <- "Facility_Infrastructure_Attack"
data_iraq[data_iraq=="Hostage Taking (Barricade Incident)"] <- "Hostage_Barricade"
data_iraq[data_iraq=="Hostage Taking (Kidnapping)"] <- "Hostage_Kidnapping"
data_iraq[data_iraq=="Unarmed Assault"] <- "Unarmed_Assault"

points <- as.data.frame(data_iraq)
coordinates(points) <- c("longitude","latitude")
proj4string(points) <- CRS("+proj=longlat +datum=WGS84")

load("pop.RData")
population <- pop
population$pop = scale(population$pop)
coordinates(population) <- ~ x + y
proj4string(population) <- CRS("+proj=longlat +datum=WGS84")
gridded(population) <- TRUE
population = lowres(population,3)

load("road.RData")
road$distance <- scale(abs(road$V3 - max(road$V3)))
road <- as(road, "SpatialPixelsDataFrame")
road$V3 <- NULL

iq <- maps::map("world","iraq",fill = TRUE,plot = FALSE)
iraq <- maptools::map2SpatialPolygons(iq, IDs = "Iraq",
                                      proj4string = CRS("+proj=longlat +datum=WGS84"))


smesh <- inla.mesh.2d(loc.domain = broom::tidy(iraq)[,1:2],
                      max.edge = c(0.50,0.75))

matern <- inla.spde2.pcmatern(mesh = smesh, 
                              prior.sigma = c(0.1, 0.01), 
                              prior.range = c(5, 0.01))

proj4string(road) <- proj4string(iraq)

matern <- inla.spde2.pcmatern(mesh = smesh, alpha=1.5,
                              prior.sigma = c(0.1, 0.01), 
                              prior.range = c(5, 0.01))


formula <- coordinates ~  distance(main = road, model = "linear") + 
  pop(main = population, model = "linear") +
  field(main = coordinates, model = matern, group = imonth, ngroup = 12,
        control.group=list(model="ar1")) +  Intercept(1)

fit <- lgcp(components = formula, data = points, samplers = iraq, 
            domain = list(coordinates = smesh))