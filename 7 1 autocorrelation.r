require(SpatialEpi)
require(GISTools)
require(rgdal)
require(sp)
# Read in the Penn lung cancer data
data(pennLC)

# Extract the Spatial Polygon info
penn.state.latlong <- pennLC$spatial.polygon

# Convert to UTM zone 17N
penn.state.utm <- spTransform(penn.state.latlong, 
                              CRS("+init=epsg:3724 +units=km"))

# Obtain the smoking rates
smk <- pennLC$smoking$smoking * 100

# Set up a shading object, draw and choropleth and legend
shades <- auto.shading(smk, n=6, cols=brewer.pal(5, 'Blues'))
choropleth(penn.state.utm, smk, shades)
choro.legend(538.5336, 4394, shades, 
             title="Smoking uptake (% of popn.)")