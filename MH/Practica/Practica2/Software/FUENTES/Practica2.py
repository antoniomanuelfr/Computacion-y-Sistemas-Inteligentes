#!/usr/bin/env python3
# -*- coding: utf-8 -*-

from sklearn.neighbors import KNeighborsClassifier,NearestNeighbors

import numpy as np
from time import time
from collection import namedtuple

#Funcion para calcular la distancia con los pesos ponderados al vector w

def DistanciaPesos(x, y, **kwargs):
	aux=(x-y)
	return sum(kwargs["weights"]*(aux*aux))

#Funcion para el cruce BLX-alfa
def BLX(C1,C2,index,alpha):
	h1=np.copy(C1)
	h2=np.copy(C2)
	
	maxi=max([C1[index],C2[index]])
	mini=min([C1[index],C2[index]])
	I=maxi-mini
	
	r=np.random.uniform(low=(mini-(I*alpha)),high=(maxi+(I*alpha)))
	h1[index]=r
	h2[index]=r
	
	return h1,h2

def OpAritmetico(C1,C2):
	r=C1+C2
	return r/2
	
#Ejecucion de la busqueda local
def BL(X_train,Y_train,sigma,alpha):
	
	puntuacion_hijo=-1
	vecinos_generados=0
	total_red=0
	
	n_caracteristicas=X_train.shape[1]
	tamaño=X_train.shape[0]
	
	porcentaje_class=alpha*100
	porcentaje_red=(1-alpha)*100
	
	indices=np.arange(0,n_caracteristicas-1)
	indexes=list(indices)


	tiempo1=time()
	w=np.random.uniform(low=0.0,high=1.0,size=n_caracteristicas)
	
	w[w<0.2]=0
	total_red=n_caracteristicas-np.count_nonzero(w)
				
	KNN = KNeighborsClassifier(n_neighbors=1, metric=DistanciaPesos, metric_params={"weights": w})
	KNN.fit(X_train,Y_train)
	neighbors=KNN.kneighbors(n_neighbors=1,return_distance=False)
	Y_vecinos=Y_train[neighbors]
	tot=0
	for (a,b)in zip(Y_train,Y_vecinos):
		if a==b:
			tot+=1
	
	
	tasa_red=total_red/tamaño
	tasa_clas=tot/tamaño
	puntuacion_padre=(porcentaje_class*tasa_clas)+(porcentaje_red*tasa_red)
	op=np.random.normal(loc=0,scale=sigma,size=n_caracteristicas)
	
	tasa_clas=0
	tasa_red=0
	total_red=0
	
	for i in range(1,15000):
		
		index=indexes.pop()
		w_ant=w[index]

		w[index]=w[index]+op[index]
		if w[index]>1:
			w[index]=1
			
		vecinos_generados+=1

		total_ant=total_red
		if w[index]<0.2:
			total_red+=1
			w[index]=0
		
		neighbors_2=KNN.kneighbors(n_neighbors=1,return_distance=False)
		Y_vecinos=Y_train[neighbors_2]
		tot=0
		for (a,b)in zip(Y_train,Y_vecinos):
			if a==b:
				tot+=1
				
		tasa_clas=tot/tamaño		
		tasa_red=total_red/n_caracteristicas
		puntuacion_hijo=(porcentaje_class*tasa_clas)+(porcentaje_red*tasa_red)
		
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
	
	return tasa_clas,tasa_red,tiempos,w

Datos=namedtuple('Datos',['w','puntuacion'])

def Valoracion(X,Y,w,KNN,porcentaje_clas,porcentaje_red):
	tot=0
	neighbors_2=KNN.kneighbors(n_neighbors=1,return_distance=False)
	Y_vecinos=Y[neighbors_2]
	for (a,b)in zip(Y,Y_vecinos):
		if a==b:
			tot+=1
			
	tasa_clas=tot/X.shape[0]		
	tasa_red=(X.shape[1]-np.count_nonzero(w))/X.shape[1]
	return (porcentaje_clas*tasa_clas)+(porcentaje_red*tasa_red),tasa_clas,tasa_red

def GenerarPoblacionInicial(X,Y,w,KNN,porcentaje_clas,porcentaje_red):
	a=[]
	for i in range (0,50):
		w=np.random.uniform(low=0,high=1,N)
		Y_vecinos=KNN.kneighbors(Y)
		cw,p,q=Valoracion(X,y,w,KNN,porcentaje_clas,porcentaje_red)
		aux=Datos(w=w,puntuacion=cw)
		a.append(aux)
	return a
		

def GN(X_train,Y_train,sigma,alpha):
	
	
	