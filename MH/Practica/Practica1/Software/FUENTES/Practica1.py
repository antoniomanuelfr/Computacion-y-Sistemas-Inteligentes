#!/usr/bin/env python3
# -*- coding: utf-8 -*-

from sklearn.neighbors import KNeighborsClassifier,NearestNeighbors

import numpy as np
from time import time


#Greedy para crear el vector de pesos w.
def RELIEF(X,Y,w):
	
	neighbors=NearestNeighbors(n_neighbors=X.shape[0],metric="euclidean")
	neighbors.fit(X,Y)
	amigo=-1
	enemigo=-1
	suma=0
	for i,j in zip(X,Y):
		distancias,indices=neighbors.kneighbors(i.reshape(1,-1))
		indices_clase1=indices[Y[indices]==1]
		indices_clase2=indices[Y[indices]==2]
		if j==1:
			amigo=indices_clase1[0]
			enemigo=indices_clase2[0]
		elif j==2:
			amigo=indices_clase2[0]
			enemigo=indices_clase1[0]
				
		w=w+np.abs(i-X[enemigo])-np.abs(i-X[amigo])
	wm = w.max()

	w[w<0]=0
	w=w/wm
	suma=X.shape[1]-np.count_nonzero(w)
	return w,suma
#Ejecucion del greedy
def Greedy(X_train,Y_train):
	w=np.zeros((X_train.shape[1]),dtype=np.float64)
		
	time1=time()
	suma=0
	
	KNN = KNeighborsClassifier(n_neighbors=1, metric='wminkowski',p=2, metric_params={'w': w})
	KNN.fit(X_train,Y_train)
	w,cambios=RELIEF(X_train,Y_train,w)
	
	
	neighbors=KNN.kneighbors(n_neighbors=1,return_distance=False)
	Y_vecinos=Y_train[neighbors]
	suma=(Y_train==Y_vecinos.transpose()).sum()
	
	tasa_class=suma/Y_vecinos.shape[0]
	tasa_red=cambios/w.shape[0]
	time2=time()
	tiempos=time2-time1
	return tasa_class,tasa_red,tiempos,w
	
#Ejecucion de la busqueda local
def BL(X_train,Y_train,sigma,alpha):
	
	puntuacion_hijo=-1
	vecinos_generados=0
	n_caracteristicas=X_train.shape[1]
	tamanio=X_train.shape[0]
	total_red=0
	porcentaje_clas=alpha
	porcentaje_red=(1-alpha)
	indices=np.arange(0,n_caracteristicas-1)
	indexes=list(indices)


	tiempo1=time()
	w=np.random.uniform(low=0.0,high=1.0,size=n_caracteristicas)
	w[w<0.2]=0
	total_red=n_caracteristicas-np.count_nonzero(w)
				
	KNN = KNeighborsClassifier(n_neighbors=1, metric='wminkowski',p=2, metric_params={'w': w})
	KNN.fit(X_train,Y_train)
	
	neighbors_2=KNN.kneighbors(n_neighbors=1,return_distance=False)
	Y_vecinos=Y_train[neighbors_2]
	tot=sum(np.reshape(Y_vecinos,tamanio)==Y_train)
	w[w<0.2]=0
	tasa_clas=tot/tamanio

	tasa_red=(n_caracteristicas-np.count_nonzero(w))/n_caracteristicas
	puntuacion_padre=(porcentaje_clas*tasa_clas)+(porcentaje_red*tasa_red)
	op=np.random.normal(loc=0,scale=sigma,size=n_caracteristicas)
	
	for i in range(1,15000):
		
		index=indexes.pop()
		w_ant=w[index]

		w[index]=w[index]-op[index]
		vecinos_generados+=1

		total_ant=total_red
		if w[index]<0.2:
			total_red+=1
			w[index]=0
	
		neighbors_2=KNN.kneighbors(n_neighbors=1,return_distance=False)
		Y_vecinos=Y_train[neighbors_2]
		tot=sum(np.reshape(Y_vecinos,tamanio)==Y_train)
		w[w<0.2]=0
		tasa_clas=tot/tamanio
	
		tasa_red=(n_caracteristicas-np.count_nonzero(w))/n_caracteristicas
		puntuacion_hijo=(porcentaje_clas*tasa_clas)+(porcentaje_red*tasa_red)
		
		if puntuacion_hijo>puntuacion_padre:
			puntuacion_padre=puntuacion_hijo
			vecinos_generados=0
		else:
			w[index]=w_ant
			total_red=total_ant

		if not indexes:
			op=np.random.normal(loc=0,scale=sigma,size=n_caracteristicas)
			indexes=list(indices)
			total_red=n_caracteristicas-np.count_nonzero(w)
		
		if vecinos_generados==20*n_caracteristicas:
			break
	tiempo2=time()
	tiempos=tiempo2-tiempo1
	tasa_red=n_caracteristicas-np.count_nonzero(w)
	
	return tasa_clas,tasa_red/n_caracteristicas,tiempos,w
