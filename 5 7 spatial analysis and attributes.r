data(newhaven)
# define sample grid in polygons
bb <-bbox(tracts)
grd <- GridTopology(cellcentre.offset=
                    c(bb[1,1]-200, bb[2,1]-200),
                    cellsize = c(10000,10000), cells.dim = c(5,5))
int.layer <- SpatialPolygonsDataFrame(
  as.SpatialPolygons.GridTopology(grd),
  data=data.frame(c(1:25)), match.ID = FALSE
)
names(int.layer) <- "ID"

# check for interaction between layers
proj4string(int.layer)
proj4string(tracts)

int.res <- gIntersection(int.layer, tracts, byid = T)

# set some plot parameters
par(mfrow= c(1,2))
par(mar=c(0,0,0,0))

# plot and label the zones
plot(int.layer, lty =2)
Lat <- as.vector(coordinates(int.layer)[,2])
Lon <- as.vector(coordinates(int.layer)[,1])
Names <- as.character(data.frame(int.layer)[,1])
# plot the tracts
plot(tracts, add = T, border = "red", lwd =2)
pl <- pointLabel(Lon, Lat, Names, offset = 0, cex = 0.7)
# set the plot extent
plot(int.layer, border = "White")
# plot the intersection
plot(int.res, col= blues9, add = T)

names(int.res)

tmp <- strsplit(names(int.res), " ")
tracts.id <- (sapply(tmp, "[[", 2))
intlayer.id <- (sapply(tmp, "[[", 1))

# generate area and proportions
int.areas <- gArea(int.res, byid = T)
tract.areas <- gArea(tracts, byid = T)
# match this to the new layer
index <- match(tracts.id, row.names(tracts))
tract.areas <- tract.areas[index]
tract.prop <-zapsmall(int.areas/tract.areas,3)
# and create data frame for the new layer
df <- data.frame(intlayer.id, tract.prop)
houses <- zapsmall(tracts$HSE_UNITS[index] * tract.prop, 1)
df <- data.frame(df, houses, int.areas)

int.layer.houses <- xtabs(df$houses~df$intlayer.id)
index <- as.numeric(gsub("g", "", names(int.layer.houses)))
# create temporary variable
tmp <- vector("numeric", length = dim(data.frame(int.layer))[1])
tmp[index] <- int.layer.houses
i.houses <- tmp

int.layer <- SpatialPolygonsDataFrame(int.layer, 
                data = data.frame(data.frame(int.layer),
                i.houses), match.ID = FALSE)

# set the plot parameters and the shading variables
par(mar=c(0,0,0,0))
shades = auto.shading(int.layer$i.houses,
                      n = 6, cols = brewer.pal(6, "Greens"))
# map the data
choropleth(int.layer, int.layer$i.houses, shades)
plot(tracts, add = T)
choro.legend(530000, 159115, bg = "white", shades, title = "No. of houses", under = "")
# reset the plot margins
par(mar=c(0,0,0,0))