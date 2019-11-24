import pandas as pd
import numpy as np
from sklearn.impute import SimpleImputer
from sklearn.metrics import mean_absolute_error, mean_squared_error
from math import sqrt

df_original = pd.read_csv(r"C:\Users\Suzana\Desktop\Iris\iris2.csv")
df_missing = pd.read_csv(r"C:\Users\Suzana\Desktop\Iris\MCAR_30.csv")

# Potrebni su mi samo features-i
features_original = df_original.iloc[:, 0:4]
features_missing = df_missing.iloc[:, 1:5]

imp_mean = SimpleImputer(missing_values=np.nan, strategy='mean')
imp_mean.fit(features_missing)
features_estimated = imp_mean.transform(features_missing)

# Nadji indekse vrijednosti za validaciju
indices_missing = np.argwhere(features_missing.isna().values)
indices_missing_hashable = map(tuple, indices_missing)
indices_set = set(indices_missing_hashable)
indices = list(indices_set)
print(indices)
print(len(indices))
s = 0
r = 0
for i in indices:
    s = s + abs(features_original.values.item(i) - features_estimated.item(i))
    r = r + (features_original.values.item(i) - features_estimated.item(i))**2
print('Prava MAE =', s/len(indices))
print('Fake MAE =', mean_absolute_error(features_original.values, features_estimated))
print('Prava RMSE =', sqrt(r/len(indices)))
print('Fake MAE =', sqrt(mean_squared_error(features_original.values, features_estimated)))
df_estimated = pd.DataFrame(features_estimated)
df_estimated.to_csv(r"C:\Users\Suzana\Desktop\Iris\Mean_imputed_MCAR.csv")


