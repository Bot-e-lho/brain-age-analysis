import matplotlib.pyplot as plt
import seaborn as sns
import pandas as pd

sns.set_style('white')
df = pd.read_csv('/home/spc/Projects/brain-age-meta-analysis/database.csv')
print(df)

df['gaps_sz'] = df['E_SZ']-df['E_HC']
df['gaps_bd'] = df['E_BD']-df['E_HC']
df['gaps_mdd'] = df['E_MDD']-df['E_HC']

plt.errorbar(x=df['mean_age_sz'], y=df['gaps_sz'], xerr=df["std_age_sz"], fmt='o', alpha=0.2, color="red")
plt.errorbar(x=df['mean_age_bd'], y=df['gaps_bd'], xerr=df["std_age_bd"], fmt='o', alpha=0.2, color="green", marker="^")
plt.errorbar(x=df['mean_age_mdd'], y=df['gaps_mdd'], xerr=df["std_age_mdd"], fmt='o', alpha=0.2, color="blue", marker="x")
leg = plt.legend(['SCZ - r(8)=0.697', 'BD - r(4)=0.213', 'MDD - r(4)=0.815'])
for lh in leg.legendHandles:
    lh.set_alpha(1)

plt.xlim(0, 100)
sns.regplot(x='mean_age_sz', y='gaps_sz', data=df, truncate=False, color="red", scatter_kws={'alpha': 0.4}, ci=None)
sns.regplot(x='mean_age_bd', y='gaps_bd', data=df, truncate=False, color="green", scatter_kws={'alpha': 0.4}, ci=None, marker="^")
sns.regplot(x='mean_age_mdd', y='gaps_mdd', data=df, truncate=False, color="blue", scatter_kws={'alpha': 0.4}, ci=None, marker="x")
plt.xlim(15, 75)
plt.ylim(-2, 8)
plt.xlabel('Age')
plt.ylabel('Brain-PAD difference')

sns.despine()
plt.tight_layout()
plt.savefig('images/age.png')
plt.savefig('images/age.pdf')
plt.show()

# gaps_sz = matrix_sz$E_SZ-matrix_sz$E_HC
# gaps_bd = matrix_bd$E_BD-matrix_bd$E_HC
# gaps_mdd = matrix_mdd$E_MDD-matrix_mdd$E_HC
# gaps = c(
#   gaps_sz,
#   gaps_bd,
#   gaps_mdd
# )
# ages_sz = matrix_sz$mean_age_sz
# ages_bd = matrix_bd$mean_age_bd
# ages_mdd = matrix_mdd$mean_age_mdd
# ages = c(
#   ages_sz,
#   ages_bd,
#   ages_mdd
# )
# ages_stds_sz = matrix_sz$std_age_sz
# ages_stds_bd = matrix_bd$std_age_bd
# ages_stds_mdd = matrix_mdd$std_age_mdd
# ages_stds = c(
#   ages_stds_sz,
#   ages_stds_bd,
#   ages_stds_mdd
# )
