library(meta)
matrix <- read.csv('C:/Users/migue/TCC/brain_age/brain-age-meta-analysis/data_alzheimer.csv', na.strings=c(''), stringsAsFactors=FALSE)
remove_imputed = TRUE

matrix_ad = matrix[!is.na(matrix$N_AD),]
matrix_aa = matrix[!is.na(matrix$N_AA),]
matrix_hc = matrix[!is.na(matrix$N_HC),]

if (remove_imputed) {
  matrix_ad = matrix_ad[is.na(matrix_ad$Imputed),]
  matrix_aa = matrix_aa[is.na(matrix_aa$Imputed),]
  matrix_hc = matrix_hc[is.na(matrix_hc$Imputed),]
}

## Alzheimer x Saudável
r_ad = metacont(matrix_ad$N_AD, matrix_ad$E_AD, matrix_ad$S_AD,
                matrix_ad$N_HC, matrix_ad$E_HC, matrix_ad$S_HC,
                studlab = matrix_ad$Study)

png("C:/Users/migue/TCC/brain_age/brain-age-meta-analysis/images/ad.png", width=1000)
forest(r_ad)
dev.off()

pdf("C:/Users/migue/TCC/brain_age/brain-age-meta-analysis/images/ad.pdf", width=15)
forest(r_ad)
dev.off()

## Envelhecimento Acelerado x Saudável
r_aa = metacont(matrix_aa$N_AA, matrix_aa$E_AA, matrix_aa$S_AA,
                matrix_aa$N_HC, matrix_aa$E_HC, matrix_aa$S_HC,
                studlab = matrix_aa$Study)

png("C:/Users/migue/TCC/brain_age/brain-age-meta-analysis/images/aa.png", width=1000)
forest(r_aa)
dev.off()

pdf("C:/Users/migue/TCC/brain_age/brain-age-meta-analysis/images/aa.pdf", width=15)
forest(r_aa)
dev.off()


## Analise Idade x Brain-PAD

# Gaps = diferenças de Brain-PAD entre os grupos
gaps_ad = matrix_ad$E_AD - matrix_ad$E_HC
gaps_aa = matrix_aa$E_AA - matrix_aa$E_HC
gaps = c(gaps_ad, gaps_aa)

# Idade média dos grupos
ages_ad = matrix_ad$mean_age_ad
ages_aa = matrix_aa$mean_age_aa
ages = c(ages_ad, ages_aa)

# Desvio padrão da idade
ages_stds_ad = matrix_ad$std_age_ad 
ages_stds_aa = matrix_aa$std_age_aa 
ages_stds = c(ages_stds_ad, ages_stds_aa)

xlim=c(40, 90)
ylim=c(-5, 15)
xlab="age"
ylab="Brain-PAD difference(HC)"
plot(ages_ad, gaps_ad, xlim=xlim, ylim=ylim, col="purple", xlab=xlab, ylab=ylab, pch=19)
par(new=TRUE)
plot(ages_aa, gaps_aa, xlim=xlim, ylim=ylim, col="orange", xlab=xlab, ylab=ylab, pch=17)
abline(lm(gaps_ad ~ ages_ad), col="purple", lwd=2)
abline(lm(gaps_aa ~ ages_aa), col="orange", lwd=2)

legend("topleft", legend=c("Alzheimer", "Envelhecimento Acelerado"),
       col=c("purple", "orange"), pch=c(19,17), lty=1, cex=0.8)

arrows(ages_ad - ages_stds_ad, gaps_ad, ages_ad + ages_stds_ad, gaps_ad, 
       length=0.05, angle=90, code=3, col="purple")
arrows(ages_aa - ages_stds_aa, gaps_aa, ages_aa + ages_stds_aa, gaps_aa, 
       length=0.05, angle=90, code=3, col="orange")


cat("Correlação Alzheimer vs Idade:\n")
print(cor.test(ages_ad, gaps_ad))
cat("\nCorrelação AA vs Idade:\n")
print(cor.test(ages_aa, gaps_aa))
cat("\nCorrelação Geral:\n")
print(cor.test(ages, gaps))

## GAP vs Desvio padrão

plot(matrix_ad$E_AD - matrix_ad$E_HC, matrix_ad$S_AD, 
     main="Gap (AD - HC) vs Desvio Padrão (AD)", xlab="Gap Brain-PAD", ylab="Desvio Padrão", col="purple")
abline(lm(matrix_ad$S_AD ~ (matrix_ad$E_AD - matrix_ad$E_HC)), col="darkgray", lwd=2)
