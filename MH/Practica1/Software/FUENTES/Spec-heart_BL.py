#!/usr/bin/env python3
# -*- coding: utf-8 -*-


from Practica1 import BL
from sklearn.model_selection import StratifiedKFold
import numpy as np
np.random.seed(1997)
#Datos
def main (): 
	X=np.loadtxt('../DATOS/spectf-heart.arff',comments='@',delimiter=',')
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
		tasa_clas,tasa_red,tiempo,w=BL(X_train,Y_train,0.3,0.5)

		
		list_clas.append(tasa_clas)
		list_red.append(tasa_red)
		list_tiempos.append(tiempo)
		list_w.append(w)
		
	print ("El resultado de aplicar BL a spec-heart ha sido: ",list_clas)
	print ("El porcentaje de reduccion es: ",list_red)
	print ("\nEn un tiempo de: ",list_tiempos)
	
main()