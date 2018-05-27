import numpy as np
from sklearn.preprocessing import OneHotEncoder


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
