import numpy as np
from sklearn.preprocessing import OneHotEncoder
from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import train_test_split
seed=10
np.random.seed(seed)
"""Preprocesado de datos."""

datos = np.genfromtxt("UCI_Credit_Card.csv", dtype=np.float32, delimiter=',')
Categoricas = datos[:, 2:10:1]
datos = np.delete(datos, np.arange(2, 11), 1)

y = datos[:, datos.shape[1]-1]
datos = np.delete(datos,datos.shape[1]-1, 1)

Categoricas[Categoricas<0]=Categoricas[Categoricas<0]+11

labels = np.unique(datos)


enc = OneHotEncoder(dtype=np.float32, sparse=False)
enc.fit(Categoricas)
Categoricas = enc.transform(Categoricas)

X = np.concatenate([datos, Categoricas], 1)

X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=seed)


clf.fit(X_train,y_train)

print (clf.score(X_test,y_test))