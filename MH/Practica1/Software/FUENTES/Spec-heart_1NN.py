#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sun Apr  1 13:05:10 2018

@author: antoniomanuelfr
"""

from Practica1 import Greedy
from sklearn.model_selection import StratifiedKFold,train_test_split
from sklearn.preprocessing import MinMaxScaler
from sklearn.neighbors import KNeighborsClassifier
import numpy as np
np.random.seed(1997)
#Datos
def main (): 
	X=np.loadtxt('../DATOS/spectf-heart.arff',comments='@',delimiter=',')
	Y=X[:,X.shape[1]-1]
	X=X[:,:-1]
	X_train, X_test, y_train, y_test=train_test_split(X,Y, random_state=1)
	scl=MinMaxScaler()
	X_train=scl.fit_transform(X_train)
	X_test=scl.transform(X_test)
	
	fivefold=StratifiedKFold(n_splits=5)
	particiones=fivefold.split(X_train,y_train)
	list_clas=[]
	list_red=[]
	list_tiempos=[]
	list_w=[]
	for train_index,test_index in particiones: 
		X_trainCV=X_train[train_index]
		y_trainCV=y_train[train_index]
		tasa_clas,tasa_red,tiempo,w=Greedy(X_trainCV,y_trainCV)
		KNN = KNeighborsClassifier(n_neighbors=1, metric='wminkowski',p=2, metric_params={'w': w})
		KNN.fit(X_train,y_train)
		
		list_clas.append(tasa_clas)
		tasa_clas=KNN.score(X_test, y_test)
		list_red.append(tasa_red)
		list_tiempos.append(tiempo)
		list_w.append(w)
		
	print ("El resultado de aplicar Greedy a parkinsons ha sido: ",list_clas)
	print ("El porcentaje de reduccion es: ",list_red)
	print ("\nEn un tiempo de: ",list_tiempos)
	
main()