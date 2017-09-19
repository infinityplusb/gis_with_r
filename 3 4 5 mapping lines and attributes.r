data(newhaven)
# 1. create a clip area
xmin <- bbox(roads)[1,1]
ymin <- bbox(roads)[2,1]
xmax <- xmin + diff(bbox(roads)[1,]) / 2
ymax <- ymin + diff(bbox(roads)[2,]) / 2
xx = as.vector(c(xmin, xmin, xmax, xmax, xmin))
yy = as.vector(c(ymin, ymax, ymax, ymin, ymin))
# 2. create a spacial polygon from this
crds <- cbind(xx, yy)
P1 <- Polygon(crds)
ID <- "clip"
Pls <- Polygons(list(P1), ID=ID)
SPls <- SpatialPolygons(list(Pls))
df <- data.frame(value=1, row.names=ID)
clip.bb <- SpatialPolygonsDataFrame(SPls, df)
# 3. clip out the roads and the data frame
roads.tmp <- gIntersection(clip.bb, roads, byid = T)
tmp <- as.numeric(gsub("clip", "", names(roads.tmp)))
tmp <- data.frame(roads)[tmp,]
# 4. finally create the SLDF object
roads.tmp <- SpatialLinesDataFrame(roads.tmp, data= tmp, match.ID = F)

par(mfrow= c(1,3)) # set plot order
par(mar = c(0,0,0,0)) # set margins
# 1. simple map
plot(roads.tmp)
# 2. mapping an attribute variable
road.class <- unique(roads.tmp$AV_LEGEND)
# specify a shading scheme from the road types
shades <- rev(brewer.pal(length(road.class), "Spectral"))
tmp <- roads.tmp$AV_LEGEND
index <- match(tmp, as.vector(road.class))
plot(roads.tmp, col= shades[index], lwd = 3)
# 3. using an attribute to specify the line width
plot(roads.tmp, lwd = roads.tmp$LENGTH_MI * 10)
# reset par(mfrow)
par(mfrow=c(1,1))