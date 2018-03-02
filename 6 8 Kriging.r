par(mfrow=c(1,2), mar=c(0,0,2,0))
persp(predmat,box=FALSE)
persp(predmat2,box=FALSE)

evgm <- variogram(fulmar~1, fulmar.spdf, 
                  boundaries=seq(0,250000, l=51))
fvgm <- fit.variogram(evgm, vgm(3,"Mat", 100000,1))
plot(evgm, model=fvgm)

krig.est <- krige(fulmar~1, fulmar.spdf, newdata=s.grid, model=fvgm)
predmat3 <- matrix(krig.est$var1.pred, length(ux), length(uy))
par(mar=c(0.1,0.1,0.1,0.1), mfrow=c(1,2))
plot(fulmar.voro, border=NA, col=NA)
.filled.contour(ux, uy, pmax(predmat3, 0), col=brewer.pal(5, 'Purples'), levels=c(0,8,16,24,32,40))
sh <- shading(breaks=c(8,16,24,32), cols=brewer.pal(5,'Purples'))
choro.legend(px='topright', sh=sh, bg='white')
errmat3 <- matrix(krig.est$var1.var, length(ux), length(uy))
plot(fulmar.voro, border=NA, col=NA)
.filled.contour(ux, uy, errmat3, col=rev(brewer.pal(5, 'Purples')), levels=c(0,3,6,9,12,15))
sh <- shading(breaks=c(3,6,9,12), cols=rev(brewer.pal(5, 'Purples')))
choro.legend(px='topright', sh=sh, bg='white')

persp(predmat3, box=FALSE)
#dev.off()