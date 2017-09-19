data(newhaven)
hist(blocks$P_VACANT, breaks = 20, col = "cyan",
     border="salmon", main = "The distribution of vacant property percentages",
     xlab = "percentage vacant", xlim = c(0,40))
dev.off()