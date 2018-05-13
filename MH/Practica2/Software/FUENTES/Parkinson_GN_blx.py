#!/usr/bin/env python3
# -*- coding: utf-8 -*-


from Practica2 import GN_blx
from sklearn.model_selection import KFold
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
	minimo=X.min()
	maximo=X.max()
	
	X[:]=(X[:]-minimo)/(maximo -minimo)
	idx=np.arange(0,X.shape[0],dtype=np.int32)
	np.random.shuffle(idx)
	X=X[idx]
	Y=Y[idx]
	fivefold=KFold(n_splits=5)
	particiones=fivefold.split(X,Y)
	"""list_hijos=[]
	list_tiempos=[]
	for train_index,test_index in particiones: 
		X_train=X[train_index]
		Y_train=Y[train_index]
		X_test=X[test_index]
		Y_test=Y[test_index]
		GN_blx(X_train,Y_train,0.3,0.5,0.7,0.001)

		break
	"""
	Parallel(n_jobs=num_cores)(delayed(GN_blx)(X[index[0]],Y[index[0]],0.3,0.5,0.7,0.001)for index in particiones )
main()