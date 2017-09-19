library(GISTools)
data("georgia")

plot(georgia, col="red", bg="wheat")

# do a merge
georgia.outline <- gUnaryUnion(georgia, id=NULL)

# plot the layers
plot(georgia, col="red", bg="wheat", lty=2, border="blue")
plot(georgia.outline, lwd=3, add=TRUE)

# add titles
title(main = "The State of Georgia", font.main = 2, 
      cex.main = 1.5, sub="and its counties", 
      font.sub= 3, col.sub="blue")

# set some plot parameters
par(mfrow=c(1,2))
par(mar = c(2,0,3,0))

# 1st plot
plot(georgia, col="red", bg="wheat")
title("georgia")

# 2nd plot
plot(georgia2, col="orange", bg="lightyellow")
title("georgia2")

#reset par(mfrow)
par (mfrow=c(1,1))

county.tmp <- c(81, 82, 83, 150, 62, 53, 21, 16, 124, 121, 17)
georgia.sub <- georgia[county.tmp,]

# assign some coordinates
Lat <- data.frame(georgia)[,1]
Lon <- data.frame(georgia)[,2]

Names <- data.frame(georgia)[,13]

par(mar = c(0,0,0,0))
plot(georgia, col = NA)
pl <- pointLabel(Lon, Lat, Names, offset=0, cex= 0.5)

library("OpenStreetMap")
ul <- as.vector(cbind(bbox(georgia.sub)[2,2],
                      bbox(georgia.sub)[1,1]))
lr <- as.vector(cbind(bbox(georgia.sub)[2,1],
                      bbox(georgia.sub)[1,2]))
# download the map file
MyMap <- openmap(ul, lr, 9, 'esri')

#now plot the layer and the backdrop
par(mar = c(0,0,0,0))
plot(MyMap, removeMargin=FALSE)
plot(spTransform(georgia.sub, osm()), add=TRUE, lwd=2)

library(PBSmapping)
library(RgoogleMaps)

# convert the subset
shp <- SpatialPolygons2PolySet(georgia.sub)
# determine the extent of the subset
bb <- qbbox(lat = shp[,"Y"], lon = shp[,"X"])
# download the map data and store it
MyMap2 <- GetMap.bbox(bb$lonR, bb$latR, destfile = "DC.jpg")
# now plot the layer and the backdrop
par(mar=c(0,0,0,0))
PlotPolysOnStaticMap(MyMap2, shp, lwd=2, 
         col=rgb(0.25,0.25,0.25,0.025), add = F)
# reset the plot margins
par(mar=c(5,4,4,2))