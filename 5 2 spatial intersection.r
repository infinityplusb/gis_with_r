library(GISTools)
data(tornados)

# set plot parameters and initial plot for map extent
par(mar=c(0,0,0,0))
plot(us_states)

# plot the data using a shading with a transparency term 
# see the add.alpha() function for this
plot(torn, add=T, pch=1, col="#FB6A4A4C", cex=0.4)
plot(us_states, add=T)

summary(torn)
index <- us_states$STATE_NAME == "Texas" |
  us_states$STATE_NAME == "New Mexico" |
  us_states$STATE_NAME == "Oklahoma" |
  us_states$STATE_NAME == "Arkansas"
AoI <- us_states[index,]
plot(torn, add=T, pch=1, col="#FB6A4A4C")

AoI.torn <-gIntersection(AoI, torn)
par(mar=c(0,0,0,0))
plot(AoI)
plot(AoI.torn, add=T, pch=1, col="#FB6A4A4C")
head(AoI.torn)

# don't lose the info
AoI.torn2 <-gIntersection(AoI, torn, byid=TRUE)
head(AoI.torn2)

# assign rownames to tmp and split the data by spaces
tmp <- rownames(data.frame(AoI.torn2))
tmp <- strsplit(tmp," ")
# assign the first and second parts of the split
torn.id <- (sapply(tmp, "[[",2))
state.id <- (sapply(tmp, "[[",1))
# use torn.id to subset the torn data and assign to df1
torn.id <- as.numeric(torn.id)
df1 <- data.frame(torn[torn.id,])

df2 <- us_states$STATE_NAME[as.numeric(state.id)]
df <- cbind(df2, df1)
names(df)[1] <- "State"

AoI.torn2 <- SpatialPointsDataFrame(AoI.torn2, data=df)
# write out as a shapefile if you wish
writePointsShape(AoI.torn2, "/home/brian/Documents/Data/Geo/AoItorn.shp")