#!/usr/bin/env python3
# -*- coding: utf-8 -*-

from sklearn.neighbors import KNeighborsClassifier

import numpy as np
from time import time
from collections import namedtuple

datos=namedtuple('Datos',['w','punt','flag'])
#Funcion para el cruce BLX-alfa con alfa=0.3
def BLX(C1,C2,X,Y,KNN,porcentaje_clas,porcentaje_red):
	alpha=0.3
	index=np.random.randint(C1.w.shape[0])
	maxi=max([C1.w[index],C2.w[index]])
	mini=min([C1.w[index],C2.w[index]])
	I=maxi-mini
	
	r=np.random.uniform(low=(mini-(I*alpha)),high=(maxi+(I*alpha)))
	if r<0.2:
		r=0
	
	C1.w[index]=r
	C2.w[index]=r
	punt1=Valoracion(X,Y,C1.w,KNN,porcentaje_clas,porcentaje_red)
	punt2=Valoracion(X,Y,C2.w,KNN,porcentaje_clas,porcentaje_red)
	
	C2=C1._replace(flag=False)
	C1=C1._replace(flag=False)
	C1=C1._replace(punt=punt1)
	C2=C2._replace(punt=punt2)
	return C1,C2

def OpAritmetico(C1,C2):
	r=C1+C2
	return r/2
	
def Valoracion(X,Y,w,KNN,porcentaje_clas,porcentaje_red):
	tot=0
	neighbors_2=KNN.kneighbors(n_neighbors=1,return_distance=False)
	Y_vecinos=Y[neighbors_2]
	for (a,b)in zip(Y,Y_vecinos):
		if a==b:
			tot+=1
			
	w[w<0.2]=0
	tasa_clas=tot/X.shape[0]

	tasa_red=(X.shape[1]-np.count_nonzero(w))/X.shape[1]
	return (porcentaje_clas*tasa_clas)+(porcentaje_red*tasa_red)

def Valoracion1(X,Y,w,KNN,porcentaje_clas,porcentaje_red):
	neighbors_2=KNN.kneighbors(n_neighbors=1,return_distance=False)
	Y_vecinos=Y[neighbors_2]
	tot=sum(np.reshape(Y_vecinos,Y.shape)==Y)
	w[w<0.2]=0
	tasa_clas=tot/X.shape[0]

	tasa_red=(X.shape[1]-np.count_nonzero(w))/X.shape[1]
	return (porcentaje_clas*tasa_clas)+(porcentaje_red*tasa_red)

def GenerarPoblacionInicial(X,Y,w,KNN,porcentaje_clas,porcentaje_red):
	a=[]
	prev_val=-1
	prev_index=-1
	for i in range (0,30):	
		puntuacion=Valoracion(X,Y,w,KNN,porcentaje_clas,porcentaje_red)
		if prev_val<puntuacion:
			prev_val=puntuacion
			prev_index=i
			
		aux=datos(w=np.copy(w),punt=puntuacion,flag=True)
		a.append(aux)
		np.copyto(w,np.random.uniform(low=0.0,high=1.0,size=X.shape[1]))
		w[w<0.2]=0
		
	return a,prev_index

def TorneoBinario (P):
	R=[]
	for i in range(0,len(P)):
		i1=np.random.randint(0,len(P)-1)
		i2=np.random.randint(0,len(P)-1)
		w1=P[i1]
		w2=P[i2]
		
		if w1.punt>w2.punt:
			R.append(w1)
		else:
			R.append(w2)
	return R

def Cruce(pcruce,P,X_train,Y_train,KNN,porcentaje_clas,porcentaje_red):
	R=[]	
	best=-1
	prev_val=-1
	for i in range (0,pcruce,2):
		c1,c2=(BLX(P[i],P[i+1],X_train,Y_train,KNN,porcentaje_clas,porcentaje_red))
		
		if c1.punt>c2.punt and c1.punt>prev_val:
			prev_val=c1.punt
			best=i
		elif c2.punt>c1.punt and c2.punt>prev_val:
			prev_val=c2.punt
			best=i+1
		R.append(c1)
		R.append(c2)
		
	return R,best

def GN(X_train,Y_train,sigma,alpha,pcruce,pmutacion):
	
	P=[]
	n_caracteristicas=X_train.shape[1]

	porcentaje_clas=alpha*100
	porcentaje_red=(1-alpha)*100

	tiempo1=time()
	w=np.random.uniform(low=0.0,high=1.0,size=n_caracteristicas)
	w[w<0.2]=0
	KNN = KNeighborsClassifier(n_neighbors=1, metric='wminkowski',p=2, metric_params={'w': w})
	KNN.fit(X_train,Y_train)
	
	P,best=GenerarPoblacionInicial(X_train,Y_train,w,KNN,porcentaje_clas,porcentaje_red)
	a=P[best]

	ind=int((len(P)*pcruce))
	
	for i in range(0,100):
		
		Psig,best2=Cruce(ind,TorneoBinario(P),X_train,Y_train,KNN,porcentaje_clas,porcentaje_red)	
		if Psig[best2].punt>a.punt:
			best=best2
			del a
			a=Psig[best]
			
		Psig=Psig+P[ind+1:]
		P=Psig
	tiempo2=time()
	
	print (tiempo2-tiempo1)
	return (tiempo2-tiempo1)
	