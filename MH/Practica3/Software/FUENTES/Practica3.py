# !/usr/bin/env python3
# -*- coding: utf-8 -*-

from sklearn.neighbors import KNeighborsClassifier

import numpy as np
from time import time


# Funcion de valoracion para w
def Valoracion(X, Y, w, KNN, porcentaje_clas, porcentaje_red):
	neighbors = KNN.kneighbors(n_neighbors=1, return_distance=False)
	Y_vecinos = Y[neighbors]
	tasa_clas = np.sum(np.transpose(Y_vecinos) == Y) / X.shape[0]
	tasa_red = (X.shape[1] - np.count_nonzero(w)) / X.shape[1]
	return (porcentaje_clas * tasa_clas) + (porcentaje_red * tasa_red), tasa_clas, tasa_red


def SimulatedAnnealing(X_train, y_train, alpha, max_vecinos, T0, Tfinal, B, sigma, pmaxaciertos):
	porcentaje_clas = alpha
	porcentaje_red = 1 - alpha
	aciertos_maximos = pmaxaciertos * max_vecinos
	n_caracteristicas = X_train.shape[1]
	w = np.random.uniform(0, 1, n_caracteristicas)
	KNN = KNeighborsClassifier(n_neighbors=1, metric='wminkowski', p=2, metric_params={'w': w})
	KNN.fit(X_train, y_train)
	T = T0
	best_w = np.copy(w)
	best_punt = Valoracion(X_train, y_train, KNN, porcentaje_clas, porcentaje_red)
	indexes = list(range(0, n_caracteristicas - 1))
	op = np.random.normal(loc=0, scale=sigma, size=n_caracteristicas)
	aciertos = 0
	tinicial = time()
	while T >= Tfinal:
		T_ant = T
		for i in range(0, max_vecinos):
			index = indexes.pop()
			w_ant = w[index]

			w[index] = w[index] + op[index]
			if w[index] < 0.2:
				w[index] = 0

			puntuacion = Valoracion(X_train, y_train, w, KNN, porcentaje_clas, porcentaje_red)
			df = best_punt - puntuacion[0]

			if df < 0 or np.random.uniform(0, 1) <= np.exp(-df / i * T):
				aciertos += 1
				if puntuacion > best_punt:
					best_punt = puntuacion
					best_w[index] = w[index]

			else:
				w[index] = w_ant
		if aciertos >= aciertos_maximos or aciertos == 0:
			break

		T = T_ant / (1 + B * T_ant)
		tfinal = time()

	return w, puntuacion, tfinal - tinicial
