import pandas as pd
from scipy.stats import norm
import numpy as np

# Read dataframe with all features, but without ID_Numbers etc.
#df = pd.read_csv(r"C:\Users\Suzana\Desktop\Iris\iris2.csv")
'''
# Get the number of features (#columns)
n_features = df.shape[1]

# For each feature get the threshold value
thresholds = df.quantile(q=0.3, axis=0)
print(thresholds)

# Find std for every features
stds = df.std(axis=0)
print(stds)
# Find probabilities
probabilities = 1 - norm.cdf(thresholds, df, stds)
print(probabilities)

# Generate zeros and ones
m = np.random.binomial(n=1, size=df.shape, p=probabilities)
# print(m)


# Generate nans based on zeroes
full = np.where(m==0, np.nan, df)

# Ukoliko svi atributi imaju nan vrijednosti, onda izabrati random jedan koji ce da ima neku vrijednost:
for i in range(0, full.shape[0]):
    if (np.isnan(full[i,:]).all()):
        full[i,0] = df.iloc[i,0]

df1 = pd.DataFrame(full, columns=df.columns)'''

df1 = pd.read_csv(r"C:\Users\Suzana\Desktop\Iris\NMAR_30.csv")
print(df1.isna().sum())
print(df1.isna().sum().sum())
print(df1.shape[0]*df1.shape[1]*0.3)
#df1.to_csv(r"C:\Users\Suzana\Desktop\Iris\NMAR_30.csv")