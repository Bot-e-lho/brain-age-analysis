library(meta)
matrix <- read.csv('/home/ballester/Projects/brain-age-meta-analysis/database.csv')

r = metacont(matrix$N_SZ, matrix$E_SZ, matrix$S_SZ, matrix$N_HC, matrix$E_HC, matrix$S_HC, matrix$Study)
forest.meta(r)

r = metacont(matrix$N_BD, matrix$E_BD, matrix$S_BD, matrix$N_HC, matrix$E_HC, matrix$S_HC, matrix$Study)
forest.meta(r)
