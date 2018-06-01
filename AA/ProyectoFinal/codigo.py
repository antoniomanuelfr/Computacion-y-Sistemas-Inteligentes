import numpy as np
from sklearn.preprocessing import OneHotEncoder
from sklearn.preprocessing import StandardScaler
from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import train_test_split
seed = 10
np.random.seed(seed)

#Inicio de preprocesado de datos

datos = np.genfromtxt("UCI_Credit_Card.csv", dtype=np.float32, delimiter=',')
y = datos[:, datos.shape[1]-1]
datos = np.delete(datos, datos.shape[1]-1, 1)

X_train, X_test, y_train, y_test = train_test_split(datos, y, test_size=0.2, random_state=seed)

CategoricasTrain = X_train[:, 2:10:1]
CategoricasTest = X_test[:, 2:10:1]
X_train = np.delete(X_train, np.arange(2, 11), 1)
X_test = np.delete(X_test, np.arange(2, 11), 1)

CategoricasTrain[CategoricasTrain < 0] = CategoricasTrain[CategoricasTrain < 0]+11
CategoricasTest[CategoricasTest < 0] = CategoricasTest[CategoricasTest < 0]+11
labels = np.unique(datos)


enc = OneHotEncoder(dtype=np.float32, sparse=False)
CategoricasTrain = enc.fit_transform(CategoricasTrain)
CategoricasTest = enc.transform(CategoricasTest)

scl = StandardScaler()
X_train = scl.fit_transform(X_train)
X_test = scl.transform(X_test)
X_train = np.concatenate([X_train, CategoricasTrain], 1)
X_test = np.concatenate([X_test, CategoricasTest], 1)

## Fin preprocesado de datos
