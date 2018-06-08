#!/usr/bin/env python3
# -*- coding: utf-8 -*-


import Practica3 as p3
from sklearn.model_selection import StratifiedKFold,train_test_split
from sklearn.preprocessing import MinMaxScaler
from sklearn.neighbors import KNeighborsClassifier
import numpy as np
np.random.seed(1997)

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
	
	#Parallel(n_jobs=num_cores)(delayed(ILS)(scl.fit_transform(X[index[0]]),Y[index[0]],scl.fit_transform(X[index[1]]), Y[index[1]])for index in particiones )
	for train_index, test_index in particiones:
		X_trainCV = X_train[train_index]
		y_trainCV = y_train[train_index]
		X_valCV=X_train[test_index]
		y_valCV= y_train[test_index]
		w=p3.SA(X_trainCV, y_trainCV, X_valCV, y_valCV, 0.5, 0.3, 0.3,10e-3,0.4,0.1,15000)
		KNN = KNeighborsClassifier(n_neighbors=1, metric='wminkowski', p=2, metric_params={'w': w})
		KNN.fit(X_train, y_train)
		print("Error de test:_ ", KNN.score(X_test, y_test))

main()