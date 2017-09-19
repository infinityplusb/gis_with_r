data(meuse.grid)
class(meuse.grid)
summary(meuse.grid)

plot(meuse.grid$x, meuse.grid$y, asp = 1)
meuse.grid = SpatialPixelsDataFrame(points = meuse.grid[c("x", "y")], data = meuse.grid)

par(mfrow = c(1,2)) # set plot order
par(mar = c(0.25, 0.25, 0.25, 0.25)) # set margins
# map the dist attribute using the image function
image(meuse.grid, "dist", col = rainbow(7))
image(meuse.grid, "dist", col = heat.colors(7))

# Using spplot from the sp package
par(mar = c(0.25, 0.25, 0.25, 0.25)) # set margin
p1 <- spplot(meuse.grid, "dist", col.regions=terrain.colors(20))

# position in c(xmin, ymin, xmax, ymax)
print(p1, position = c(0,0,0.5,0.5), more = T)
p2 <- spplot(meuse.grid, c("part.a", "part.b", "soil", "ffreq"), col.regions=topo.colors(20))
print(p2, position = c(0.5,0,1,0.5), more = T)