#!/usr/bin/env python3
# -*- coding: utf-8 -*-

from sklearn.neighbors import KNeighborsClassifier

import numpy as np
from time import time
from Datos import Datos

#Funcion de valoracion para w
def Valoracion(X,Y,w,KNN,porcentaje_clas,porcentaje_red):
	
	neighbors=KNN.kneighbors(n_neighbors=1,return_distance=False)
	Y_vecinos=Y[neighbors]
	tasa_clas=np.sum(np.transpose(Y_vecinos)==Y)/X.shape[0]
	tasa_red=(X.shape[1]-np.count_nonzero(w))/X.shape[1]
	return (porcentaje_clas*tasa_clas)+(porcentaje_red*tasa_red),tasa_clas,tasa_red

#Torneo
def TorneoBinario(P,ncruces):
	R=[]
	append=R.append
	for i in range(0,ncruces):
		i1=np.random.randint(0,len(P)-1)
		i2=np.random.randint(0,len(P)-1)
		if i1==i2:
			i2=np.random.randint(0,len(P)-1)
			
		w1=P[i1]
		w2=P[i2]
		
		if w1.punt>w2.punt:
			append(w1)
		else:
			append(w2)
	return R

#Funcion para el cruce BLX-alfa con alfa=0.3
def BLX(w,C1,C2,X,Y,KNN,porcentaje_clas,porcentaje_red):
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
	
	np.copyto(w,C1.w)
	punt1,clas1,red1=Valoracion(X,Y,w,KNN,porcentaje_clas,porcentaje_red)
	np.copyto(w,C2.w)
	punt2,clas2,red2=Valoracion(X,Y,w,KNN,porcentaje_clas,porcentaje_red)
	
	C1.actualizar(punt=punt1,clas=clas1,red=red1)
	C2.actualizar(punt=punt2,clas=clas2,red=red2)
	return C1,C2
#Funcion que realiza el cruce BLX a una poblacion
def CruceBLX(w,ncruce,P,X_train,Y_train,KNN,porcentaje_clas,porcentaje_red):
	R=[]	
	evals=0
	a=np.arange(0,ncruce,2)

	b_i=-1
	b_val=-1
	w_i=-1
	w_val=100000
	for i in a :
		c1,c2=BLX(w,P[i],P[i+1],X_train,Y_train,KNN,porcentaje_clas,porcentaje_red)
		
		if c1.punt>c2.punt and c1.punt>b_val:
			b_val=c1.punt
			b_i=i
		elif c2.punt>c1.punt and c2.punt>b_val:
			b_val=c2.punt
			b_i=i+1
		
		if c1.punt<c2.punt and c1.punt<w_val:
			w_val=c1.punt
			w_i=i
		elif c2.punt<c1.punt and c2.punt<w_val:
			w_val=c2.punt
			w_i=i+1
		R.append(c1)
		R.append(c2)
		evals+=2
		
	R=R+P[ncruce:]
		
	return R,b_i,w_i,evals

#Operador aritmetico
def OpAritmetico(w,C1,C2,X,Y,KNN,porcentaje_clas,porcentaje_red):
	r=C1.w+C2.w
	
	C1.w=r/2
	C1.w[C1.w<0.2]=0
	np.copyto(w,C1.w)
	punt1,clas1,red1=Valoracion(X,Y,w,KNN,porcentaje_clas,porcentaje_red)
	
	C1.actualizar(punt=punt1,clas=clas1,red=red1)
	return C1

#Cruce aritmetico en una poblacion
def CruceArit(w,n_cruces,P,X_train,Y_train,KNN,porcentaje_clas,porcentaje_red):
	R=[]	
	n_vals=0
	a=np.arange(0,n_cruces,2)

	b_i=-1
	b_val=-1
	w_i=-1
	w_val=100000
	for i in a:
		f1=np.random.randint(low=0,high=len(P)-1)
		f2=np.random.randint(low=0,high=len(P)-1)
		c1=(OpAritmetico(w,P[f1],P[f1+1],X_train,Y_train,KNN,porcentaje_clas,porcentaje_red))
		c2=(OpAritmetico(w,P[f2],P[f2+1],X_train,Y_train,KNN,porcentaje_clas,porcentaje_red))
		n_vals+=2
		
		if c1.punt>c2.punt and c1.punt>b_val:
			b_val=c1.punt
			b_i=i
		elif c2.punt>c1.punt and c2.punt>b_val:
			b_val=c2.punt
			b_i=i+1
		
		if c1.punt<c2.punt and c1.punt<w_val:
			w_val=c1.punt
			w_i=i
		elif c2.punt<c1.punt and c2.punt<w_val:
			w_val=c2.punt
			w_i=i+1
		R.append(c1)
		R.append(c2)
	
	R=R+P[n_cruces:]
		
	return R,b_i,w_i,n_vals
#Genetico generacional BLX
def GN_blx(X_train,Y_train,sigma,alpha,pcruce,pmutacion):
	
	P=[]
	n_caracteristicas=X_train.shape[1]
	porcentaje_clas=alpha*100
	porcentaje_red=(1-alpha)*100

	tiempo1=time()
	w=np.random.uniform(low=0,high=1,size=n_caracteristicas)
	#w=np.zeros(n_caracteristicas)
	KNN = KNeighborsClassifier(n_neighbors=1, metric='wminkowski',p=2, metric_params={'w': w})
	KNN.fit(X_train,Y_train)
	np.copyto(w,np.random.uniform(low=0,high=1,size=n_caracteristicas))
	
	#Generar poblacion inicial
	P=[]	
	b_val=-1
	b_index=-1
	w_val=1
	w_i=-1
	for i in range (0,30):	
		puntuacion,c,r=Valoracion(X_train,Y_train,w,KNN,porcentaje_clas,porcentaje_red)
		if b_val<puntuacion:
			b_val=puntuacion
			b_index=i
		if w_val<puntuacion:
			w_val=puntuacion
			w_i=i
		aux=Datos(np.copy(w),clas=c,red=r,punt=puntuacion)
		P.append(aux)
		np.copyto(w,np.random.uniform(low=0.0,high=1.0,size=X_train.shape[1]))
		w[w<0.2]=0
		del puntuacion,c,r
		
		total_evaluaciones=0
	#Poblacion inicial generada
	
	best=P[b_index]
	NumeroMutaciones=int((pmutacion*(30*X_train.shape[1])+0.5))
	mutaciones=np.random.randint(low=0,high=30,size=NumeroMutaciones)

	ind=int((len(P)*pcruce))
	
	if ind%2!=0:
		ind+=1
		
	for iters in range(0,15000):
		
		Psig,best_c,worst_c,evals=CruceBLX(w,ind,TorneoBinario(P,30),X_train,Y_train,KNN,porcentaje_clas,porcentaje_red)	
		total_evaluaciones+=evals
		w_i=worst_c
		if Psig[best_c].punt>best.punt:
			b_index=best_c
			best=Psig[best_c]
		del P
		P=Psig
		for i in mutaciones:
			w1=np.copy(Psig[i].w)
			index=np.random.randint(low=0,high=n_caracteristicas)
			w1[index]=(w1[index]+np.random.normal(loc=0,scale=sigma))
			if w1[index]<0.2:
				w1[index]=0
			elif w1[index]>1:
				w1[index]=1
			
	
			val=Valoracion(X_train,Y_train,w1,KNN,porcentaje_clas,porcentaje_red)
			total_evaluaciones+=1
			Psig[i].w=np.copy(w1)
			Psig[i].actualizar(punt=val[0],clas=val[1],red=val[2])
		P.pop(w_i)
		P.append(best)
		
		if(total_evaluaciones>=15000):
			print (total_evaluaciones)
			break
		
	tiempo2=time()
	print ("Tasa clas: ",best.clas, " Tasa red: ", best.red)
	print ("En un tiempo de: ",tiempo2-tiempo1)


def GN_arit(X_train,Y_train,sigma,alpha,pcruce,pmutacion):
	
	P=[]
	n_caracteristicas=X_train.shape[1]
	porcentaje_clas=alpha*100
	porcentaje_red=(1-alpha)*100

	tiempo1=time()
	w=np.random.uniform(low=0,high=1,size=n_caracteristicas)
	#w=np.zeros(n_caracteristicas)
	KNN = KNeighborsClassifier(n_neighbors=1, metric='wminkowski',p=2, metric_params={'w': w})
	KNN.fit(X_train,Y_train)
	np.copyto(w,np.random.uniform(low=0,high=1,size=n_caracteristicas))
	
	#Generar poblacion inicial
	P=[]	
	b_val=-1
	b_index=-1
	w_val=1
	w_i=-1
	for i in range (0,30):	
		puntuacion,c,r=Valoracion(X_train,Y_train,w,KNN,porcentaje_clas,porcentaje_red)
		if b_val<puntuacion:
			b_val=puntuacion
			b_index=i
		if w_val<puntuacion:
			w_val=puntuacion
			w_i=i
		aux=Datos(np.copy(w),clas=c,red=r,punt=puntuacion)
		P.append(aux)
		np.copyto(w,np.random.uniform(low=0.0,high=1.0,size=X_train.shape[1]))
		w[w<0.2]=0
		del puntuacion,c,r
		
		total_evaluaciones=0
	#Poblacion inicial generada
	
	best=P[b_index]
	NumeroMutaciones=int((pmutacion*(30*X_train.shape[1])+0.5))
	mutaciones=np.random.randint(low=0,high=30,size=NumeroMutaciones)

	ind=int((len(P)*pcruce))
	
	if ind%2!=0:
		ind+=1
		
	for iters in range(0,15000):
		
		Psig,best_c,worst_c,evals=CruceArit(w,ind,TorneoBinario(P,30),X_train,Y_train,KNN,porcentaje_clas,porcentaje_red)	
		total_evaluaciones+=evals
		w_i=worst_c
		if Psig[best_c].punt>best.punt:
			b_index=best_c
			best=Psig[best_c]
		del P
		P=Psig
		for i in mutaciones:
			w1=np.copy(Psig[i].w)
			index=np.random.randint(low=0,high=n_caracteristicas)
			w1[index]=(w1[index]+np.random.normal(loc=0,scale=sigma))
			if w1[index]<0.2:
				w1[index]=0
			elif w1[index]>1:
				w1[index]=1
			
	
			val=Valoracion(X_train,Y_train,w1,KNN,porcentaje_clas,porcentaje_red)
			total_evaluaciones+=1
			Psig[i].w=np.copy(w1)
			Psig[i].actualizar(punt=val[0],clas=val[1],red=val[2])
		P.pop(w_i)
		P.append(best)
		
		if(total_evaluaciones>=15000):
			print (total_evaluaciones)
			break
		
	tiempo2=time()
	print ("Tasa clas: ",best.clas, " Tasa red: ", best.red)
	print ("En un tiempo de: ",tiempo2-tiempo1)

def GNE_blx(X_train,Y_train,sigma,alpha,pcruce,pmutacion):
		
	P=[]
	n_caracteristicas=X_train.shape[1]
	porcentaje_clas=alpha*100
	porcentaje_red=(1-alpha)*100

	tiempo1=time()
	#w=np.random.uniform(low=0,high=1,size=n_caracteristicas)
	w=np.zeros(n_caracteristicas)
	KNN = KNeighborsClassifier(n_neighbors=1, metric='wminkowski',p=2, metric_params={'w': w})
	KNN.fit(X_train,Y_train)
	np.copyto(w,np.random.uniform(low=0,high=1,size=n_caracteristicas))
	
	#Generar poblacion inicial
	P=[]	
	b_val=-1
	b_index=-1
	w_val=1
	w_index=-1
	for i in range (0,30):	
		puntuacion,c,r=Valoracion(X_train,Y_train,w,KNN,porcentaje_clas,porcentaje_red)
		
		if b_val<puntuacion:
			b_val=puntuacion
			b_index=i
		if w_val<puntuacion:
			w_val=puntuacion
			w_index=i
		aux=Datos(np.copy(w),clas=c,red=r,punt=puntuacion)
		P.append(aux)
		np.copyto(w,np.random.uniform(low=0.0,high=1.0,size=X_train.shape[1]))
		w[w<0.2]=0
		del puntuacion,c,r
	total_evaluaciones=30

	#Poblacion inicial generada
	
	best=P[b_index]
	NumeroMutaciones=int((pmutacion*(30*X_train.shape[1])+0.5))
	mutaciones=np.random.randint(low=0,high=30,size=NumeroMutaciones)
	
	for i in range(0,15000):
		Psig,best_c,worst_c,evals=CruceBLX(w,2,TorneoBinario(P,30),X_train,Y_train,KNN,porcentaje_clas,porcentaje_red)	
		total_evaluaciones+=evals
		if Psig[best_c].punt>best.punt:
			best=Psig[best_c]
		w_index=worst_c
		
		del P
		P=Psig
		for i in mutaciones:
			w1=np.copy(Psig[i].w)
			index=np.random.randint(low=0,high=w.shape[0])
			w1[index]=(w1[index]+np.random.normal(loc=0,scale=sigma))
			if w1[index]<0.2:
				w1[index]=0
			elif w1[index]>1:
				w1[index]=1
		
			val=Valoracion(X_train,Y_train,w1,KNN,porcentaje_clas,porcentaje_red)
			total_evaluaciones+=1
			Psig[i].w=w=np.copy(w1)
			Psig[i].actualizar(punt=val[0],clas=val[1],red=val[2])
			
		P.pop(w_index)
		P.append(best)
		
		if(total_evaluaciones>=15000):
			break
		
	tiempo2=time()
	print ("Tasa clas: ",best.clas, " Tasa red: ", best.red)
	print ("En un tiempo de: ",tiempo2-tiempo1)
	
def GNE_arit(X_train,Y_train,sigma,alpha,pcruce,pmutacion):
		
	P=[]
	n_caracteristicas=X_train.shape[1]
	porcentaje_clas=alpha*100
	porcentaje_red=(1-alpha)*100

	tiempo1=time()
	#w1=np.random.uniform(low=0,high=1,size=n_caracteristicas)
	w=np.zeros(n_caracteristicas)
	
	KNN = KNeighborsClassifier(n_neighbors=1, metric='wminkowski',p=2, metric_params={'w': w})
	KNN.fit(X_train,Y_train)
	np.copyto(w,np.random.uniform(low=0,high=1,size=n_caracteristicas))
	
	#Generar poblacion inicial
	P=[]	
	b_val=-1
	b_index=-1
	w_val=1
	w_index=-1
	for i in range (0,30):	
		puntuacion,c,r=Valoracion(X_train,Y_train,w,KNN,porcentaje_clas,porcentaje_red)
		
		if b_val<puntuacion:
			b_val=puntuacion
			b_index=i
		if w_val<puntuacion:
			w_val=puntuacion
			w_index=i
		aux=Datos(np.copy(w),clas=c,red=r,punt=puntuacion)
		P.append(aux)
		np.copyto(w,np.random.uniform(low=0.0,high=1.0,size=X_train.shape[1]))
		w[w<0.2]=0
		del puntuacion,c,r
	total_evaluaciones=30

	#Poblacion inicial generada
	
	best=P[b_index]
	NumeroMutaciones=int((pmutacion*(30*X_train.shape[1])+0.5))
	mutaciones=np.random.randint(low=0,high=30,size=NumeroMutaciones)
	
	for i in range(0,15000):
		Psig,best_c,worst_c,evals=CruceBLX(w,4,TorneoBinario(P,30),X_train,Y_train,KNN,porcentaje_clas,porcentaje_red)	
		w_index=worst_c
		total_evaluaciones+=evals
		if Psig[best_c].punt>best.punt:
			b_index=best_c
			best=Psig[best_c]
		
		del P
		P=Psig
		for i in mutaciones:
			w1=np.copy(Psig[i].w)
			index=np.random.randint(low=0,high=w.shape[0])
			w1[index]=(w1[index]+np.random.normal(loc=0,scale=sigma))
			if w1[index]<0.2:
				w1[index]=0
			elif w1[index]>1:
				w1[index]=1
		
			val=Valoracion(X_train,Y_train,w1,KNN,porcentaje_clas,porcentaje_red)
			total_evaluaciones+=1
			Psig[i].w=w=np.copy(w1)
			Psig[i].actualizar(punt=val[0],clas=val[1],red=val[2])
			
		P.pop(w_index)
		P.append(best)
		
		if(total_evaluaciones>=15000):
			break
		
	tiempo2=time()
	print ("Tasa clas: ",best.clas, " Tasa red: ", best.red)
	print ("En un tiempo de: ",tiempo2-tiempo1)
	
def MEM(X_train,Y_train,sigma,alpha,pcruce,pmutacion,BL):
		
	P=[]
	n_caracteristicas=X_train.shape[1]
	porcentaje_clas=alpha*100
	porcentaje_red=(1-alpha)*100

	tiempo1=time()
	w=np.zeros(n_caracteristicas)
	KNN = KNeighborsClassifier(n_neighbors=1, metric='wminkowski',p=2, metric_params={'w': w})
	KNN.fit(X_train,Y_train)
	np.copyto(w,np.random.uniform(low=0,high=1,size=n_caracteristicas))
	
	#Generar poblacion inicial
	P=[]	
	b_val=-1
	b_index=-1
	w_val=1
	w_index=-1
	for i in range (0,10):	
		puntuacion,c,r=Valoracion(X_train,Y_train,w,KNN,porcentaje_clas,porcentaje_red)
		
		if b_val<puntuacion:
			b_val=puntuacion
			b_index=i
		if w_val<puntuacion:
			w_val=puntuacion
			w_index=i
		aux=Datos(np.copy(w),clas=c,red=r,punt=puntuacion)
		P.append(aux)
		np.copyto(w,np.random.uniform(low=0.0,high=1.0,size=X_train.shape[1]))
		w[w<0.2]=0
		del puntuacion,c,r
	total_evaluaciones=30

	#Poblacion inicial generada
	
	best=P[b_index]
	NumeroMutaciones=int((pmutacion*(30*X_train.shape[1])+0.5))
	mutaciones=np.random.randint(low=0,high=30,size=NumeroMutaciones)
	
	for i in range(0,15000):
		Psig,best_c,worst_c,evals=CruceBLX(w,2,TorneoBinario(P,30),X_train,Y_train,KNN,porcentaje_clas,porcentaje_red)	
		total_evaluaciones+=evals
		if Psig[best_c].punt>best.punt:
			best=Psig[best_c]
		w_index=worst_c
		
		del P
		P=Psig
		for i in mutaciones:
			w1=np.copy(Psig[i].w)
			index=np.random.randint(low=0,high=w.shape[0])
			w1[index]=(w1[index]+np.random.normal(loc=0,scale=sigma))
			if w1[index]<0.2:
				w1[index]=0
			elif w1[index]>1:
				w1[index]=1
		
			val=Valoracion(X_train,Y_train,w1,KNN,porcentaje_clas,porcentaje_red)
			total_evaluaciones+=1
			Psig[i].w=w=np.copy(w1)
			Psig[i].actualizar(punt=val[0],clas=val[1],red=val[2])
			
		P.pop(w_index)
		P.append(best)
		
		if(total_evaluaciones>=15000):
			break
		
	tiempo2=time()
	print ("Tasa clas: ",best.clas, " Tasa red: ", best.red)
	print ("En un tiempo de: ",tiempo2-tiempo1)