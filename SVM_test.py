import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
from sklearn.model_selection import train_test_split
# Importing the classification report and confusion matrix
from sklearn.metrics import classification_report, confusion_matrix, accuracy_score
from sklearn.svm import SVC

# Import the dataset using Seaborn library
iris = pd.read_csv(r"C:\Users\Suzana\Desktop\Iris\KNN_imputed_NMAR.csv")
iris = iris.iloc[:, 1:]
# Checking the dataset
iris.head()

# Creating a pairplot to visualize the similarities and especially difference between the species
sns.pairplot(data=iris, hue='class', palette='Set2')
plt.show()


# Separating the independent variables from dependent variables
x = iris.iloc[:, :-1]
y = iris.iloc[:, 4]
s = 0
for i in range(0, 100):
    x_train, x_test, y_train, y_test = train_test_split(x, y, test_size=0.30)

    model = SVC()

    model.fit(x_train, y_train)

    y_pred = model.predict(x_test)
    acc = accuracy_score(y_test, y_pred)
    s = s + acc
    #print(confusion_matrix(y_test, pred))
    #print(classification_report(y_test, pred))
print(s/100)