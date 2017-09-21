data(newhaven)
proj4string(places) <- CRS(proj4string(blocks))
centroids. <- gCentroid(blocks, byid=T, id= rownames(blocks))
distances <- ft2miles(gDistance(places, centroids., byid = T))

distances2 <- gWithinDistance(places, blocks, byid = T, dist=miles2ft(1.2))

min.dist <- as.vector(apply(distances,1,min))
access <- min.dist < 1 
# and this can be plotted
plot(blocks, col = access)

# extract the ethnicity data from the blocks variable
ethnicity <- as.matrix(data.frame(blocks[,14:18])/100)
ethnicity <- apply(ethnicity, 2, function(x) (x*blocks$POP1990))
ethnicity <- matrix(as.integer(ethnicity), ncol=5)
colnames(ethnicity) <- c("White", "Black", "Native American", "Asian", "Other")

# use xtab to generate a crosstabulation
mat.access.tab = xtabs(ethnicity~access)
# then transpose the data
data.set = as.data.frame(mat.access.tab)
# set the column names
colnames(data.set) = c("Access", "Ethnicity", "Freq")

modelethnic = glm(Freq ~ Access * Ethnicity, data=data.set,family=poisson)
summary(modelethnic)
summary(modelethnic)$coef

mod.coefs = summary(modelethnic)$coef
tab <- 100*(exp(mod.coefs[,1]) -1)
tab <- tab[7:10]
names(tab) <- colnames(ethnicity)[2:5]
tab

mosaicplot(t(mat.access.tab), xlab='', ylab='Access to Supply',
           main="Mosaic Plot of Access", shade=TRUE, las=3, cex=0.8)

