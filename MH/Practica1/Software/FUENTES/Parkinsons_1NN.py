#!/usr/bin/env python3
# -*- coding: utf-8 -*-
from sklearn.neighbors import KNeighborsClassifier
from sklearn.model_selection import StratifiedKFold,train_test_split
from sklearn.preprocessing import MinMaxScaler
import numpy as np
from time import time
np.random.seed(1997)
#Datos
def main (): 
	
	X=np.loadtxt('../DATOS/parkinsons.arff',comments='@',delimiter=',')
	Y=X[:,X.shape[1]-1]
	X=X[:,:-1]
	X_train, X_test, y_train, y_test=train_test_split(X,Y, random_state=123)
	scl=MinMaxScaler()
	X_train=scl.fit_transform(X_train)
	X_test=scl.transform(X_test)
	
	fivefold=StratifiedKFold(n_splits=5)
	particiones=fivefold.split(X_train,y_train)
	
	list_clas=[]
	list_red=[]
	list_tiempos=[]
	
	for train_index,test_index in particiones: 
		time1=time()
		X_trainCV=X_train[train_index]
		y_trainCV=y_train[train_index]

		KNN=KNeighborsClassifier(n_neighbors=1,metric="minkowski")
		KNN.fit(X_trainCV,y_trainCV)
		tasa_clas=KNN.score(X_test,y_test)
		time2=time()
		tasa_red=0
		tiempo=(time2-time1)
		list_clas.append(tasa_clas)
		list_red.append(tasa_red)
		list_tiempos.append(tiempo)
		
	print ("El resultado de aplicar 1NN a parkinsons ha sido: ",list_clas)
	print ("El porcentaje de reduccion es: ",list_red)
	print ("\nEn un tiempo de: ",list_tiempos)
	
main()
