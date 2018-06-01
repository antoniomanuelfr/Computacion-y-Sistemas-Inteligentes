#!/usr/bin/env python3
# -*- coding: utf-8 -*-


from Practica3 import SA
from sklearn.model_selection import StratifiedKFold
from sklearn.preprocessing import MinMaxScaler
import numpy as np
np.random.seed(1997)
#Datos
from joblib import Parallel, delayed
import multiprocessing



# Obtenemos el número de nucleos de la CPU

num_cores = multiprocessing.cpu_count()

def main (): 
	X=np.loadtxt('../DATOS/parkinsons.arff',comments='@',delimiter=',')
	Y=X[:,X.shape[1]-1]
	X=X[:,:-1]
	scl=MinMaxScaler()
	fivefold=StratifiedKFold(n_splits=5)
	particiones=fivefold.split(X,Y)

	Parallel(n_jobs=num_cores)(delayed(SA)(scl.fit_transform(X[index[0]]),Y[index[0]],scl.fit_transform(X[index[1]]), Y[index[1]],0.5,0.3,0.3,0.001,0.3,0.1,15000)for index in particiones )
	"""for train_index, test_index in particiones:
		X_train = X[train_index]
		Y_train = Y[train_index]
		X_test=X[test_index]
		Y_test=Y[test_index]
		scl.fit(X_train)
		scl.transform(X_train)
		#tasas, tiempo, w = SimulatedAnnealing(X_train, Y_train, X_test, Y_test, 0.5, 0.3, 0.3, 0.001, 0.3, 0.1,15000)
		# ILS(X_train, Y_train, X_test, Y_test, 0.5, 0.3)

"""

main()