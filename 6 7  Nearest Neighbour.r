## Original Code from Carson Farmer
# http://www.carsonfarmer.com/2009/09/voronoi-polygons-with-r

require(deldir)
require(sp)
voronoipolygons = function(layer) {
  crds <- layer@coords
  z <- deldir(crds[,1], crds[,2])
  w <- tile.list(z)
  polys <- vector(mode='list', length=length(w))
  
  for(i in seq(along=polys)) {
    pcrds <- cbind(w[[i]]$x, w[[i]]$y)
    polys[[i]] <- Polygons(list(Polygon(pcrds)), 
                           ID=as.character(i))
  }
  SP <- SpatialPolygons(polys)
  voronoi <- SpatialPolygonsDataFrame(SP,
      data= data.frame(x=crds[,1],
                       y=crds[,2],
                       layer@data,
                       row.names=sapply(slot(SP, 'polygons'),
                                        function(x) slot(x, 'ID'))))
  return(voronoi)
}

library(gstat)
library(maptools)
data(fulmar)

fulmar.spdf <- SpatialPointsDataFrame(cbind(fulmar$x,
                                            fulmar$y),
                                      fulmar)
fulmar.spdf <- fulmar.spdf[fulmar.spdf$year==1999,]
fulmar.voro <- voronoipolygons(fulmar.spdf)
par(mfrow=c(1,2), mar=c(0.1,0.1,0.1,0.1))

plot(fulmar.spdf, pch=16)
plot(fulmar.voro)

#reset par(mfrow)
par(mfrow=c(1,1))


library(gstat)
library(GISTools)
sh <- shading(breaks=c(5,15,25,35),
              cols <-brewer.pal(5,'Purples'))
par(mar=c(0.1,0.1,0.1,0.1))
choropleth(fulmar.voro, fulmar.voro$fulmar, shading= sh, border=NA)
plot(fulmar.voro, border='lightgray', add=TRUE, lwd=0.5)
choro.legend(px='topright', sh=sh)