library(meta)
matrix <- read.csv('/home/spc/Projects/brain-age-meta-analysis/database.csv')

matrix_sz = matrix[!is.na(matrix$N_SZ),]
r = metacont(matrix_sz$N_SZ, matrix_sz$E_SZ, matrix_sz$S_SZ, matrix_sz$N_HC, matrix_sz$E_HC, matrix_sz$S_HC, matrix_sz$Study)
forest.meta(r)

#r = metacont(matrix$N_BD, matrix$E_BD, matrix$S_BD, matrix$N_HC, matrix$E_HC, matrix$S_HC, matrix$Study)
#forest.meta(r)
