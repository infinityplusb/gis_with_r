torn.count <- poly.counts(torn, us_states)
head(torn.count)
names(torn.count)


### Area Calculations
proj4string(us_states2) 
poly.areas(us_states2)

# hectares
poly.areas(us_states2) / (100 * 100)
# square kilometers
poly.areas(us_states2) / (1000 * 1000)

data(newhaven)
ft2miles(ft2miles(poly.areas(blocks)))


### Point and Areas Analysis
data(newhaven)
densities= poly.counts(breach, blocks) /
  ft2miles(ft2miles(poly.areas(blocks)))
cor(blocks$P_OWNEROCC, densities)

plot(blocks$P_OWNEROCC, densities)

### breaches ~ Poisson(exp(a + b *blocks$P_OWNEROCC + log(AREA)))
# load the data
data(newhaven)
attach(data.frame(blocks))
# calculate the breaches of the peace in each block
n.breaches = poly.counts(breach, blocks)
area = ft2miles(ft2miles(poly.areas(blocks)))
# fit the model
model1 = glm(n.breaches ~ P_OWNEROCC, offset=log(area), family=poisson)
# detach the data
detach(data.frame(blocks))

model1
summary(model1)

s.resids = rstandard(model1)
resid.shades = shading(c(-2,2),c("red", "grey", "blue"))
par(mar=c(0,0,0,0))
choropleth(blocks, s.resids, resid.shades)
# reset the plot margins
par(mar=c(5,4,4,2))

attach(data.frame(blocks))
n.breaches = poly.counts(breach,blocks)
area = ft2miles(ft2miles(poly.areas(blocks)))
model2 = glm(n.breaches ~ P_OWNEROCC+P_VACANT, offset=log(area), family=poisson)
s.resids.2 = rstandard(model2)
detach(data.frame(blocks))

model2
summary(model2)

s.resids.2 = rstandard(model2)
par(mar=c(0,0,0,0))
choropleth(blocks, s.resids.2, resid.shades)
#reset the plot margins
par(mar=c(5,4,4,2))