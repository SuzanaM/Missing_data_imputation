import numpy as np
import pandas as pd
import collections
import random
from scipy.stats import norm
import math
df_missing = pd.read_csv(r"C:\Users\Suzana\Desktop\Iris\NMAR_30.csv")

# Pronadji sve one instance koje imaju poznate sve parametre

features = df_missing.iloc[:, 1:]
df_validation = features.dropna()
df_validation_missing = features.dropna()
df_validation.to_csv(r"C:\Users\Suzana\Desktop\Iris\iris_validation_nmar.csv")
'''
# Sada na validacionom setu generisi 10% nedostajucih vrijednosti
#df_validation_missing = df_validation_missing.iloc[:, 0:4]
replaced = collections.defaultdict(set)
ix = [(row, col) for row in range(df_validation_missing.shape[0]) for col in range(df_validation_missing.shape[1])]
random.shuffle(ix)
to_replace = int(round(.1*len(ix)))
for row, col in ix:
    if len(replaced[row]) < df_validation_missing.shape[1] - 1:
        df_validation_missing.iloc[row, col] = np.nan
        to_replace -= 1
        # Ovo je dict, i u njemu je upisano koliko kolona fali za svaku vrstu
        replaced[row].add(col)
        if to_replace == 0:
            break

print(df_validation_missing.isna().sum().sum())
'''

# Sada na validacionom setu generisi 10% nedostajucih vrijednosti
df_validation_missing = df_validation_missing.iloc[:, 0:4]
# Get the number of features (#columns)
n_features = df_validation_missing.shape[1]

# For each feature get the threshold value
thresholds = df_validation_missing.quantile(q=0.1, axis=0)
#print(thresholds)

# Find std for every features
stds = df_validation_missing.std(axis=0)
#print(stds)
# Find probabilities
probabilities = 1 - norm.cdf(thresholds, df_validation_missing, stds)
#print(probabilities)

# Generate zeros and ones
m = np.random.binomial(n=1, size=df_validation_missing.shape, p=probabilities)
# print(m)


# Generate nans based on zeroes
full = np.where(m == 0, np.nan, df_validation_missing)
# Na osnovu poznatog broja parametara odredi koliko tacno vrijdnosti ja smijem da izbrise
Num_features = 4
N_values = round(df_validation_missing.shape[0]*Num_features*0.1)

# Ukoliko svi atributi imaju nan vrijednosti, onda izabrati random jedan koji ce da ima neku vrijednost:
for i in range(0, full.shape[0]):
    if np.isnan(full[i, :]).all():
        full[i, 0] = df_validation_missing.iloc[i, 0]
br = 0
for i in range(0, full.shape[1]):
    for j in range(0, full.shape[0]):
        if math.isnan(full[j,i]):
            br = br+1
            if br > 20:
                full[j, i] = df_validation.iloc[j, i]
                print(df_validation.iloc[j, i])

print(df_validation_missing.shape[0])
df1 = pd.DataFrame(full, columns=df_validation_missing.columns)
print(df1.isna().sum().sum())
df1.to_csv(r"C:\Users\Suzana\Desktop\Iris\iris_validation_missing_nmar.csv")
