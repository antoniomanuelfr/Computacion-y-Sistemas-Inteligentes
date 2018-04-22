#!/usr/bin/env python3
# -*- coding: utf-8 -*-
from sklearn.neighbors import KNeighborsClassifier
from sklearn.model_selection import StratifiedKFold
import numpy as np
from time import time
np.random.seed(1997)
#Datos
def main (): 
	X=np.loadtxt('../DATOS/ozone-320.arff',comments='@',delimiter=',')
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
	
	for train_index,test_index in particiones: 
		time1=time()
		X_train=X[train_index]
		Y_train=Y[train_index]

		KNN=KNeighborsClassifier(n_neighbors=1,metric="euclidean")
		KNN.fit(X_train,Y_train)
		Y_vecinos=KNN.kneighbors(n_neighbors=1,return_distance=False)
		neighbors=KNN.kneighbors(n_neighbors=1,return_distance=False)
		Y_vecinos=Y_train[neighbors]
		tot=0
		for (a,b)in zip(Y_train,Y_vecinos):
			if a==b:
				tot+=1
		time2=time()
		tasa_clas=tot/X_train.shape[0]
		tasa_red=0
		tiempo=(time2-time1)
		list_clas.append(tasa_clas)
		list_red.append(tasa_red)
		list_tiempos.append(tiempo)
		
	print ("El resultado de aplicar 1NN a ozone ha sido: ",list_clas)
	print ("El porcentaje de reduccion es: ",list_red)
	print ("\nEn un tiempo de: ",list_tiempos)
	
main()
