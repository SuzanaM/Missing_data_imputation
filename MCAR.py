import pandas as pd
import numpy as np
import random
import collections


df = pd.read_csv(r"C:\Users\Suzana\Desktop\Iris\iris2.csv")
df = df.iloc[:, 0:4]
print(df)

replaced = collections.defaultdict(set)
print(replaced)
print(replaced)
ix = [(row, col) for row in range(df.shape[0]) for col in range(df.shape[1])]
print(ix)
random.shuffle(ix)
print(ix)
to_replace = int(round(.075*len(ix)))
print(to_replace)
for row, col in ix:
    print(len(replaced[row]))
    if len(replaced[row]) < df.shape[1] - 1:
        df.iloc[row, col] = np.nan
        to_replace -= 1
        # Ovo je dict, i u njemu je upisano koliko kolona fali za svaku vrstu
        replaced[row].add(col)
        if to_replace == 0:
            break

print(df.isna().sum().sum())

print(df)
df.to_csv(r"C:\Users\Suzana\Desktop\Iris\MCAR_7_5.csv")
