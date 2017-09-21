# select an Area of Interest and apply a buffer
AoI <- us_states2[us_states2$STATE_NAME == "Texas",]
AoI.buf <- gBuffer(AoI, width = 25000)
#map the buffer and the original area
par(mar=c(0,0,0,0))
plot(AoI.buf)
plot(AoI, add=T, border = "blue")

data(georgia)
# apply a buffer to each object
buf.t <- gBuffer(georgia2, width = 5000, byid = T, id=georgia2$Name)
# plot the data
plot(buf.t)
plot(georgia2, add=T, border="blue")

plot(buf.t[1,])
plot(georgia2[1,], add=T, col="blue")