#!/usr/bin/env python3
# -*- coding: utf-8 -*-

from sklearn.neighbors import KNeighborsClassifier,NearestNeighbors

import numpy as np
from time import time
import Datos

#Funcion de valoracion para w
def Valoracion(X,Y,w,KNN,porcentaje_clas,porcentaje_red):
	
	neighbors=KNN.kneighbors(n_neighbors=1,return_distance=False)
	Y_vecinos=Y[neighbors]
	tasa_clas=np.sum(np.transpose(Y_vecinos)==Y)/X.shape[0]
	tasa_red=(X.shape[1]-np.count_nonzero(w))/X.shape[1]
	return (porcentaje_clas*tasa_clas)+(porcentaje_red*tasa_red),tasa_clas,tasa_red


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
def BL(P,best,X_train,Y_train,sigma,alpha,KNN):

	puntuacion_hijo=-1
	vecinos_generados=0
	n_caracteristicas=X_train.shape[1]
	total_red=0
	porcentaje_clas=alpha
	porcentaje_red=(1-alpha)
	indices=np.arange(0,n_caracteristicas-1)
	indexes=list(indices)
	w=best.w
	puntuacion_padre=best.punt
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
		
		puntuacion_hijo,tasa_clas,tasa_red=Valoracion(X_train,Y_train,w,KNN,porcentaje_clas,porcentaje_red)
		
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
		
		if vecinos_generados==2*n_caracteristicas:
			break
	tasa_red=(n_caracteristicas-np.count_nonzero(w))/n_caracteristicas
	
	best.w=np.copy(w)
	best.actualizar(tasa_clas,tasa_red,puntuacion_hijo)
	return i,best
