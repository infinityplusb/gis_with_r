library(GISTools)
library(raster)
data(tornados)

# Points
r = raster(nrow = 180, ncols = 360, ext = extent(us_states2))
t2 <- as(torn2, "SpatialPoints")
r <- rasterize(t2, r, fun=sum)

# set the plot extent by specifying the plot colour 'white'
plot(r, col='white')
plot(us_states2, add=T, border = "grey")
plot(r, add = T)


# Lines
us_outline <- as(us_states2, "SpatialLinesDataFrame")
r <- raster(nrow=180, ncols=360, ext=extent(us_states2))
r <- rasterize(us_outline, r, "STATE_FIPS")
plot(r)


# Polygons
r <- raster(nrows = 180, ncols = 360, ext = extent(us_states2))
r <- rasterize(us_states2, r, "POP1997")
plot(r)

