library(meta)
matrix <- read.csv('/home/spc/Projects/brain-age-meta-analysis/database.csv')

matrix_sz = matrix[!is.na(matrix$N_SZ),]
r = metacont(matrix_sz$N_SZ, matrix_sz$E_SZ, matrix_sz$S_SZ, matrix_sz$N_HC, matrix_sz$E_HC, matrix_sz$S_HC, matrix_sz$Study)
#pdf("/home/spc/Projects/brain-age-meta-analysis/images/sz.pdf")
forest.meta(r)
#dev.off()

matrix_bd = matrix[!is.na(matrix$N_BD),]
r = metacont(matrix_bd$N_BD, matrix_bd$E_BD, matrix_bd$S_BD, matrix_bd$N_HC, matrix_bd$E_HC, matrix_bd$S_HC, matrix_bd$Study)
#forest.meta(r)
