library(meta)
matrix <- read.csv('/home/spc/Projects/brain-age-meta-analysis/database.csv', na.strings=c(''), stringsAsFactors=FALSE)
remove_imputed = TRUE

matrix_sz = matrix[!is.na(matrix$N_SZ),]
matrix_bd = matrix[!is.na(matrix$N_BD),]
matrix_mdd = matrix[!is.na(matrix$N_MDD),]
if (remove_imputed) {
  matrix_sz = matrix_sz[is.na(matrix_sz$Imputed),]
  matrix_bd = matrix_bd[is.na(matrix_bd$Imputed),]
  matrix_mdd = matrix_mdd[is.na(matrix_mdd$Imputed),]
}
r = metacont(matrix_sz$N_SZ, matrix_sz$E_SZ, matrix_sz$S_SZ, matrix_sz$N_HC, matrix_sz$E_HC, matrix_sz$S_HC, matrix_sz$Study)
png("/home/spc/Projects/brain-age-meta-analysis/images/sz.png", width=1000)
forest.meta(r)
dev.off()

r = metacont(matrix_bd$N_BD, matrix_bd$E_BD, matrix_bd$S_BD, matrix_bd$N_HC, matrix_bd$E_HC, matrix_bd$S_HC, matrix_bd$Study)
png("/home/spc/Projects/brain-age-meta-analysis/images/bd.png", width=1000)
forest.meta(r)
dev.off()


r = metacont(matrix_mdd$N_MDD, matrix_mdd$E_MDD, matrix_mdd$S_MDD, matrix_mdd$N_HC, matrix_mdd$E_HC, matrix_mdd$S_HC, matrix_mdd$Study)
png("/home/spc/Projects/brain-age-meta-analysis/images/mdd.png", width=1000)
forest.meta(r)
dev.off()

# Test age association with brain-PAD
gaps_sz = matrix_sz$E_SZ-matrix_sz$E_HC
gaps_bd = matrix_bd$E_BD-matrix_bd$E_HC
gaps_mdd = matrix_mdd$E_MDD-matrix_mdd$E_HC
gaps = c(
  gaps_sz,
  gaps_bd,
  gaps_mdd
)
ages_sz = matrix_sz$mean_age_sz
ages_bd = matrix_bd$mean_age_bd
ages_mdd = matrix_mdd$mean_age_mdd
ages = c(
  ages_sz,
  ages_bd,
  ages_mdd
)
ages_stds_sz = matrix_sz$std_age_sz 
ages_stds_bd = matrix_bd$std_age_bd
ages_stds_mdd = matrix_mdd$std_age_mdd 
ages_stds = c(
  ages_stds_sz,
  ages_stds_bd,
  ages_stds_mdd
)
xlim=c(10, 80)
ylim=c(-1, 10)
xlab="Age"
ylab="Brain-PAD difference"
plot(ages_sz, gaps_sz, xlim=xlim, ylim=ylim, col="red", xlab=xlab, ylab=ylab)
par(new=TRUE)
plot(ages_bd, gaps_bd, xlim=xlim, ylim=ylim, col="green", xlab=xlab, ylab=ylab)
par(new=TRUE)
plot(ages_mdd, gaps_mdd, xlim=xlim, ylim=ylim, col="blue", xlab=xlab, ylab=ylab)
abline(lm(gaps_sz ~ ages_sz, data = mtcars), col = "red")
abline(lm(gaps_bd ~ ages_bd, data = mtcars), col = "green")
abline(lm(gaps_mdd ~ ages_mdd, data = mtcars), col = "blue")
legend("topleft", legend=c("SCZ", "BD", "MDD"),
       col=c("red", "green", "blue"), lty=1:1, cex=0.8)

arrows(ages_sz-ages_stds_sz, gaps_sz, ages_sz+ages_stds_sz, gaps_sz, length=0.05, angle=90, code=3, col="red")
arrows(ages_bd-ages_stds_bd, gaps_bd, ages_bd+ages_stds_bd, gaps_bd, length=0.05, angle=90, code=3, col="green")
arrows(ages_mdd-ages_stds_mdd, gaps_mdd, ages_mdd+ages_stds_mdd, gaps_mdd, length=0.05, angle=90, code=3, col="blue")

cor.test(ages_sz, gaps_sz)
cor.test(ages_bd, gaps_bd)
cor.test(ages_mdd, gaps_mdd)
cor.test(ages, gaps)


# Test looser fit larger gap
out = boxplot.stats(matrix_sz$S_SZ)$out
out_ind <- which(matrix_sz$S_SZ %in% c(out))
matrix_sz = matrix_sz[-out_ind,]

plot(matrix_sz$E_SZ-matrix_sz$E_HC, matrix_sz$S_SZ)
shapiro.test(matrix_sz$E_SZ-matrix_sz$E_HC)
shapiro.test(matrix_sz$S_SZ)
shapiro.test(matrix_sz$S_HC)

cor.test(matrix_sz$E_SZ-matrix_sz$E_HC, matrix_sz$S_HC)
cor.test(matrix_sz$E_SZ-matrix_sz$E_HC, matrix_sz$S_SZ)
cor.test(matrix_bd$E_BD-matrix_bd$E_HC, matrix_bd$S_HC)
cor.test(matrix_bd$E_BD-matrix_bd$E_HC, matrix_bd$S_BD)
cor.test(matrix_mdd$E_MDD-matrix_mdd$E_HC, matrix_mdd$S_HC)
cor.test(matrix_mdd$E_MDD-matrix_mdd$E_HC, matrix_mdd$S_MDD)

errors = c(matrix_sz$E_SZ-matrix_sz$E_HC, matrix_bd$E_BD-matrix_bd$E_HC, matrix_mdd$E_MDD-matrix_mdd$E_HC)
stds = c(matrix_sz$S_SZ, matrix_bd$S_BD, matrix_mdd$S_MDD)
plot(errors, stds)
cor.test(errors, stds)
stds = c(matrix_sz$S_HC, matrix_bd$S_HC, matrix_mdd$S_HC)
plot(errors, stds)
cor.test(errors, stds)

# Section 2: First option: StatsToDo formula
Calc1 <- function(myDat) # myDat is matrix with 3 cols of n, mean, and SD
{
  m = nrow(myDat)  # number of groups
  tn = 0
  tx = 0
  txx = 0
  for(i in 1:m)
  {
    n = myDat[i,1]
    mean = myDat[i,2]
    sd = myDat[i,3]
    x = n * mean
    xx = sd^2*(n - 1) + x^2 / n 
    out<-cat("grp",i," n=",n," mean=",mean," SD=", sd, " Ex=", x, " Exx=",xx, "\n")
    tn = tn + n
    tx = tx + x
    txx = txx + xx
  }
  tmean = tx / tn
  tsd = sqrt((txx - tx^2/tn) / (tn - 1))
  out <- cat("Combined","n=",tn," mean=",tmean," SD=", tsd, " Ex=", tx, " Exx=",txx,"\n")
  c(tn,tmean,tsd)
}

# Kaufmann paper SZ
g1 = c(52, 30.9, 8.4) #n mean,sd of grp 1
g2 = c(48, 36.6, 9.0) #n mean,sd of grp 2
g3 = c(92,  41.6, 7.6) #n mean,sd of grp 3
g4 = c(37, 28.5, 7.5)
g5 = c(221, 36.3, 13.0)
g6 = c(153, 34.2, 11.7)
g7 = c(428, 31.2, 9.3)
g8 = c(79, 33.7, 7.5)
ar <- Calc1(matrix(data=c(g1,g2,g3,g4,g5,g6,g7,g8), ncol=3, byrow=TRUE)) # combine 3 groups entry data into matrix and call function

  
# Kaufmann paper BD
g1 = c(48, 35.6, 8.9)
g2 = c(43, 34.3, 7.4)
g3 = c(368, 33.5, 11.2)
ar <- Calc1(matrix(data=c(g1,g2,g3), ncol=3, byrow=TRUE)) # combine 3 groups entry data into matrix and call function

# Kaufmann paper MDD
g1 = c(189, 39.2, 13.3)
g2 = c(19, 33.5, 13.7)
ar <- Calc1(matrix(data=c(g1,g2), ncol=3, byrow=TRUE)) # combine 3 groups entry data into matrix and call function

# Shahab paper 1st sample
g1 = c(24+35, 33.10, 8.58)
g2 = c(9+13, 64.18, 8.52)
ar <- Calc1(matrix(data=c(g1,g2), ncol=3, byrow=TRUE)) # combine 3 groups entry data into matrix and call function

# Shahab paper 1st sample BD
g1 = c(13+18, 27.10, 6.01)
g2 = c(12+10, 62.68, 8.02)
ar <- Calc1(matrix(data=c(g1,g2), ncol=3, byrow=TRUE)) # combine 3 groups entry data into matrix and call function

