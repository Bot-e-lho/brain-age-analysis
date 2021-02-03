library(meta)
matrix <- read.csv('/home/spc/Projects/brain-age-meta-analysis/database.csv', na.strings=c(''))
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
#pdf("/home/spc/Projects/brain-age-meta-analysis/images/sz.pdf")
forest.meta(r)
#dev.off()


#r = metacont(matrix_bd$N_BD, matrix_bd$E_BD, matrix_bd$S_BD, matrix_bd$N_HC, matrix_bd$E_HC, matrix_bd$S_HC, matrix_bd$Study)
#forest.meta(r)


#r = metacont(matrix_mdd$N_MDD, matrix_mdd$E_MDD, matrix_mdd$S_MDD, matrix_mdd$N_HC, matrix_mdd$E_HC, matrix_mdd$S_HC, matrix_mdd$Study)
#forest.meta(r)
