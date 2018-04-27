#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sun Apr  1 13:05:10 2018

@author: antoniomanuelfr
"""

from Practica2 import GN
from sklearn.model_selection import StratifiedKFold
import numpy as np
np.random.seed(452345)
#Datos
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
	list_clas=[]
	list_red=[]
	list_tiempos=[]
	list_w=[]
	for train_index,test_index in particiones: 
		X_train=X[train_index]
		Y_train=Y[train_index]
		print (GN(X_train,Y_train,0.3,0.5,0.7,0.1))
		break
		
main()