#!/usr/bin/env python3
# -*- coding: utf-8 -*-


from Practica3 import ILS
from sklearn.model_selection import KFold
from sklearn.preprocessing import MinMaxScaler
from sklearn.neighbors import KNeighborsClassifier
import numpy as np

np.random.seed(1997)
# Datos
from joblib import Parallel, delayed
import multiprocessing

# Obtenemos el número de nucleos de la CPU

num_cores = multiprocessing.cpu_count()


def main():
	X = np.loadtxt('../DATOS/spectf-heart.arff', comments='@', delimiter=',')
	Y = X[:, X.shape[1] - 1]
	X = X[:, :-1]
	scl = MinMaxScaler()
	idx = np.arange(0, X.shape[0], dtype=np.int32)
	np.random.shuffle(idx)
	X = X[idx]
	Y = Y[idx]
	fivefold = KFold(n_splits=5)
	particiones = fivefold.split(X, Y)

	Parallel(n_jobs=num_cores)(
		delayed(ILS)(X[index[0]], Y[index[0]], X[index[1]], Y[index[1]], 0.5, 0.3) for index in particiones)


main()
