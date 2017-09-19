library(GISTools)

# load and list the data
data(newhaven)
ls()
# have a look at the attributes
summary(blocks)
summary(breach)
summary(tracts)

data.frame(blocks)
head(data.frame(blocks))

attach(data.frame(blocks))
hist(P_VACANT)
detach(data.frame(blocks))

# use kde.points to create a kernel density surface
breach.dens = kde.points(breach, lims=tracts)
summary(breach.dens)

head(data.frame(breach.dens))

# use 'as' to coerce this to a SpatialGridDataFrame
breach.dens.grid <- as(breach.dens, "SpatialGridDataFrame")
summary(breach.dens.grid)


vacant.shades = auto.shading(blocks$P_VACANT, n=7, cols=brewer.pal(7, "Blues"), cutter=rangeCuts)
choropleth(blocks, blocks$P_VACANT, shading=vacant.shades)
choro.legend(533000, 161000, vacant.shades)