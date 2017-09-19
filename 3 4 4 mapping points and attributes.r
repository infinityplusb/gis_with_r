plot(blocks)
plot(breach, add=TRUE, pch=1, col='red')

# examine the Brewer "Reds" colour palette
brewer.pal(5, "Reds")
# add a 50% transparency
add.alpha(brewer.pal(5, "Reds"), .50)

par(mar= c(0,0,0,0))
# plot the blocks and then breaches of the peace
plot(blocks, lwd=0.7, border = "grey40")
plot(breach, add=TRUE, pch=1, col="#DE2D2680")



# Quakes
#load the data
data(quakes)
head(quakes)
coord.tmp <- cbind(quakes$long, quakes$lat)
# create the SpatialPointsDataFrame
quakes.spdf <- SpatialPointsDataFrame(coord.tmp, data=data.frame(quakes))
# set the plot parameters to show 2 maps 
par(mar = c(0,0,0,0))
par(mfrow = c(1,2))
# 1st plot the default plot character
plot(quakes.spdf)
# then with a transparency term
plot(quakes.spdf, pch=1, col="#FB6A4A80")
# reset par frow
par(mfrow=c(1,1))


# Georgia
data(georgia)
# select the polys of interest
tmp <- georgia.polys[c(1,2,151,113)]
# convert to Polygon and the Polygons object
t1 <- Polygon(tmp[1]); t1 <- Polygons(list(t1), "1")
t2 <- Polygon(tmp[2]); t2 <- Polygons(list(t2), "2")
t3 <- Polygon(tmp[3]); t3 <- Polygons(list(t3), "3")
t4 <- Polygon(tmp[4]); t4 <- Polygons(list(t4), "4")
# create a SpatialPolygons object
tmp.Sp <- SpatialPolygons(list(t1, t2, t3, t4), 1:4)
plot(tmp.Sp, col = 2:15)
# create an attribute
names <- c("Appling", "Bacan", "Wayne", "Pierce")
# now create an SPDF object
tmp.spdf <- SpatialPolygonsDataFrame(tmp.Sp, data=data.frame(names))
# set some plot parameters
par(mfrow = c(2,2))
par(mar=c(0,0,0,0)) # set margins
## 1. Plot using choropleth
choropleth(quakes.spdf, quakes$mag)
## 2. Plot with a different shading scheme & pch
shades = auto.shading(quakes$mag, n=6, 
   cols=brewer.pal(6, 'Greens'))
choropleth(quakes.spdf, quakes$mag, shades, pch = 1)
## 3. Plot with a transparency
shades$cols <- add.alpha(shades$cols, 0.5)
choropleth(quakes.spdf, quakes$mag, shading = shades, pch = 20)
## 4. Plot character size determined by attribute magnitude
tmp <- quakes$mag         # assign magnitude to tmp
tmp <- tmp - min(tmp)     # remove minimum
tmp <- tmp / max(tmp)     # divide by maximum
plot(quakes.spdf, cex = tmp*3, pch =1, col ='#FB6A4A80')


# set the plot parameters
par(mfrow= c(1,2))
par(mar= c(0,0,0,0))
## 1. Apply a threshold to categorise the data
tmp2 <- cut(quakes$mag, fivenum(quakes$mag), include.lowest=T)
class <- match(tmp2, levels(tmp2))
# specify 4 plot characters to use
pch.var <- c(0,1,2,5)
# Plot the classes
plot(quakes.spdf, pch = pch.var[class], cex = 0.7, col = "#252525B3")
## 2. Thresholds for classes can be specified
# logical operations help to define 3 classes
# note the terms such as '+0' convert TRUE/FALSE to numbers
index.1 <- (quakes$mag >= 4 & quakes$mag < 5) + 0
index.2 <- (quakes$mag >= 5 & quakes$mag < 5.5) * 2
index.3 <- (quakes$mag >= 5.5) * 3
class <- index.1 + index.2 + index.3
# specify 3 plot colours to use
col.var <- (brewer.pal(3, "Blues"))
plot(quakes.spdf, col = col.var[class], cex = 1.4, pch = 20)
# reset par(mfrow)
par(mfrow=c(1,1))

library(RgoogleMaps)
Lat <- as.vector(quakes$lat)
Long <- as.vector(quakes$long)
MyMap <- MapBackground(lat=Lat, lon=Long, zoom=10)
# note the use of the tmp variable defined earlier to set the cex value
PlotOnStaticMap(MyMap, Lat, Long, cex=tmp+0.3, pch=1, col='#FB6A4A80')
MyMap <- MapBackground(lat=Lat, lon=Long, zoom=10, maptype="satellite")
PlotOnStaticMap(MyMap, Lat, Long, cex=tmp+0.3, pch=1, col="#FB6A4A80")