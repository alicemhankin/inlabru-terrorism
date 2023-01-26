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

## ---- data -- note that we are only looking at 2017 here
data_iraq <- data %>%
  subset(!is.na(latitude) & !is.na(longitude) & !is.na(iyear) & !is.na(imonth))%>%
  subset(iyear == 2017) %>%
  dplyr::select(c("longitude", "latitude", "imonth", "attacktype1_txt"))

points <- as.data.frame(data_iraq)
coordinates(points) <- c("longitude","latitude")
proj4string(points) <- CRS("+proj=longlat +datum=WGS84")

## covariates

## population
load("pop.RData")
population <- pop
population$pop = scale(population$pop)
coordinates(population) <- ~ x + y
proj4string(population) <- CRS("+proj=longlat +datum=WGS84")
gridded(population) <- TRUE
population = lowres(population,3)

## road network
load("road.RData")
road$distance <- scale(abs(road$V3 - max(road$V3)))
road <- as(road, "SpatialPixelsDataFrame")
road$V3 <- NULL

## SPDF of country
iq <- maps::map("world","iraq",fill = TRUE,plot = FALSE)
iraq <- maptools::map2SpatialPolygons(iq, IDs = "Iraq",
                                      proj4string = CRS("+proj=longlat +datum=WGS84"))

## ---- model_prep
smesh <- inla.mesh.2d(loc.domain = broom::tidy(iraq)[,1:2],
                      max.edge = c(0.50,0.75))
locs <- data.frame(x = data_iraq$longitude, y = data_iraq$latitude,
                   t = data_iraq$iyear) 
matern <- inla.spde2.pcmatern(mesh = smesh, 
                              prior.sigma = c(0.1, 0.01), 
                              prior.range = c(5, 0.01))
proj4string(road) <- proj4string(iraq)


matern <- inla.spde2.pcmatern(mesh = smesh, alpha=1.5,
                              prior.sigma = c(0.1, 0.01), 
                              prior.range = c(5, 0.01))


formula <- coordinates ~  distance(main = road, model = "linear") + 
  pop(main = population, model = "linear") +
  field(main = coordinates, model = matern) + 
  Intercept(1)
#if you want to not include covariates, just take the relevant terms out of the formula above



#fit object
fit <- lgcp(components = formula, data = points, samplers = iraq, 
            domain = list(coordinates = smesh))


summary(fit)

#see the field, pop, dist components on a log scale
field_pred = predict(fit, model, ~ field)
pop_pred = predict(fit, model, ~ pop)
dist_pred = predict(fit, model, ~ distance)

#plots eg field_pred
raster = raster(field_pred)
masked <- raster::mask(raster, iraq)
masked = as(masked, "SpatialPixelsDataFrame")
plot(masked)
