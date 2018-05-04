#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sun Apr  1 13:05:10 2018

@author: antoniomanuelfr
"""

from Practica1 import BL
from sklearn.model_selection import StratifiedKFold
import numpy as np
np.random.seed(7)
#Datos

from joblib import Parallel, delayed
import multiprocessing



# Obtenemos el número de nucleos de la CPU

num_cores = multiprocessing.cpu_count()

#Paralelizamos la ejecución de los ficheros
def main (): 
	X=np.loadtxt('../DATOS/parkinsons.arff',comments='@',delimiter=',')
	Y=X[:,X.shape[1]-1]
	X=X[:,:-1]
	minimo=X.min()
	maximo=X.max()
	
	X=(X-minimo)/(maximo -minimo)
	idx=np.arange(0,X.shape[0],dtype=np.int32)
	np.random.shuffle(idx)
	X=X[idx]
	Y=Y[idx]
	fivefold=StratifiedKFold(n_splits=5)
	particiones=fivefold.split(X,Y)

	Parallel(n_jobs=num_cores)(delayed(BL)(X[index[0]],Y[index[0]],0.3,0.5)for index in particiones )
	
main()