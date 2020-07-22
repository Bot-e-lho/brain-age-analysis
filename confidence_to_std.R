calculate_std = function (CI, mean, n, name) {
  std = ((CI - mean)/1.96) * sqrt(n)
  CI_lower = mean - 1.96*(std/sqrt(n))
  print(c(name, std, CI_lower))
}
#CI_lower = 1.96*std + mean

n = 120
mean = 2.64
CI = 3.48
calculate_std(CI, mean, n, "Kolenic SZ")

n = 114
mean = 0.14
CI = 1.00
calculate_std(CI, mean, n, "Kolenic HC")

### VAN GESTEL ###
n = 43
mean = 4.96
CI = 6.64
calculate_std(CI, mean, n, "Van Gestel Non-Lithium")

n = 41
mean = 0.83
CI = 2.54
calculate_std(CI, mean, n, "Van Gestel Lithium")

n = 45
mean = -0.15
CI = 1.50
calculate_std(CI, mean, n, "Van Gestel HC")

### VAN GESTEL ###