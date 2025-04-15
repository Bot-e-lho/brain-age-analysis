# Fórmula: SD = (upper - lower) / (2 * z * sqrt(n))
# z para IC 95% ~ 1.96

convert_ci_to_sd <- function(lower, upper, n) {
  if (is.na(lower) | is.na(upper) | is.na(n)) {
    return(NA)
  }
  sd = (upper - lower) / (2 * 1.96 * sqrt(n))
  return(sd)
}

lower <- 5.8
upper <- 6.8
n <- 30

sd_converted <- convert_ci_to_sd(lower, upper, n)
cat("Desvio padrão estimado:", round(sd_converted, 3), "\n")
