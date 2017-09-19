data(newhaven)

plot(blocks, lwd=3, border="grey50")
plot(roads, add=TRUE, col='blue', lwd=2)
plot(breach, add=TRUE, col="red", pch=1)
map.scale(534750, 152000, miles2ft(2), "Miles", 4,0.5)
