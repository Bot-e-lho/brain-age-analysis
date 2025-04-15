import math
import matplotlib.pyplot as plt
import seaborn as sns
import pandas as pd

sns.set_style('whitegrid')

def convert_ci_to_sd(lower, upper, n):
    if lower is None or upper is None or n is None or n <= 0:
        return None
    return (upper - lower) / (2 * 1.96 * math.sqrt(n)) 


df = pd.read_csv('C:/Users/migue/TCC/brain_age/brain-age-meta-analysis/data_alzheimer.csv')
print(df)

df['gaps_ad'] = df['E_AD'] - df['E_HC']
df['gaps_aa'] = df['E_AA'] - df['E_HC']


plt.figure(figsize=(10, 6))
plt.errorbar(x=df['mean_age_ad'], y=df['gaps_ad'], xerr=df["std_age_ad"],
             fmt='o', alpha=0.7, color="purple", label='Alzheimer')
plt.errorbar(x=df['mean_age_aa'], y=df['gaps_aa'], xerr=df["std_age_aa"],
             fmt='^', alpha=0.7, color="orange", label='Envelhecimento Acelerado')


sns.regplot(x='mean_age_ad', y='gaps_ad', data=df, truncate=False,
            color="purple", scatter=False, ci=None)
sns.regplot(x='mean_age_aa', y='gaps_aa', data=df, truncate=False,
            color="orange", scatter=False, ci=None)

plt.xlabel('Idade')
plt.ylabel('Diferença Brain-PAD (Grupo - HC)')
plt.xlim(40, 90)
plt.ylim(-5, 15)

leg = plt.legend()
for lh in leg.legendHandles:
    lh.set_alpha(1)

sns.despine()
plt.tight_layout()

plt.savefig('images/age.png')
plt.savefig('images/age.pdf')
plt.show()
