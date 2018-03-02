library(maptools)
library(GISTools)
library(gstat)

s.grid <- spsample(fulmar.voro, type='regular', n=6000)
idw.est <- gstat::idw(fulmar~1, fulmar.spdf, newdata=s.grid, idp=1.0) 

ux <- unique(coordinates(idw.est)[,1])
uy <- unique(coordinates(idw.est)[,2])
predmat <- matrix(idw.est$var1.pred, length(ux), length(uy))