AoI.merge <- gUnaryUnion(us_states)
# plot
par(mar=c(0,0,0,0))
plot(us_states, border= "darkgreen", lty =3)
plot(AoI.merge , add= T, lwd = 1.5)