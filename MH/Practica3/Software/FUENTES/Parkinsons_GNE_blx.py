#!/usr/bin/env python3
# -*- coding: utf-8 -*-


from Practica3 import SimulatedAnnealing
from sklearn.model_selection import KFold
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
	idx=np.arange(0,X.shape[0],dtype=np.int32)
	np.random.shuffle(idx)
	X=X[idx]
	Y=Y[idx]
	fivefold=KFold(n_splits=5)
	particiones=fivefold.split(X,Y)

	#Parallel(n_jobs=num_cores)(delayed(GNE_blx)(X[index[0]],Y[index[0]],0.3,0.5,0.7,0.001)for index in particiones )
	for train_index, test_index in particiones:
		X_train = X[train_index]
		Y_train = Y[train_index]
		scl.fit(X_train)
		scl.transform(X_train)
		tasas, tiempo, w = SimulatedAnnealing(X_train, Y_train, 0.5, 0.3, 0.3, 0.001, 0.3, 0.1,15000)
		print("Clas: ", tasas[0], " red: ", tasas[1], " tiempo: ", tiempo)


		break


main()