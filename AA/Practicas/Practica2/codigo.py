#!/usr/bin/env python3
# -*- coding: utf-8 -*-


import Funciones_necesarias_p2 as p2 
import ejemplo_pintar_frontera_decision as p21
import numpy as np
import matplotlib.pyplot as plt

np.random.seed(312321)

'''
    Transforma los coeficientes de w a los parámetros de una recta 2d.
    w: Lista o array de numpy (1d) con 3 valores. w[2] ha de ser el témino 
       independiente.
'''
def coef2line(w):
    if(len(w)!= 3):
        raise ValueError('Solo se aceptan rectas para el plano 2d. Formato: [<a0>, <a1>, <b>].')
    
    a = -w[0]/w[1]
    b = -w[2]/w[1]
    
    return a, b


'''
    Pinta los datos con su etiqueta y la solución definida por w.
    X: Datos
    y: Etiquetas (-1, 1).
    w: Lista o array de numpy (1d) con 3 valores. w[2] ha de ser el témino 
       independiente.
'''
def plot_data(X, y, w,title='Point clod plot',x_l='x axis',y_l='y axis'):
    #Preparar datos
    a, b = coef2line(w)
    min_xy = X.min(axis=0)
    max_xy = X.max(axis=0)
    border_xy = (max_xy-min_xy)*0.01
    
    #Generar grid de predicciones
    xx, yy = np.mgrid[min_xy[0]-border_xy[0]:max_xy[0]+border_xy[0]+0.001:border_xy[0], 
                      min_xy[1]-border_xy[1]:max_xy[1]+border_xy[1]+0.001:border_xy[1]]
    grid = np.c_[xx.ravel(), yy.ravel(), np.ones_like(xx).ravel()]
    pred_y = grid.dot(w)
    pred_y = np.clip(pred_y, -1, 1).reshape(xx.shape)
    
    #Plot
    f, ax = plt.subplots(figsize=(8, 6))
    contour = ax.contourf(xx, yy, pred_y, 50, cmap='RdBu',
                      vmin=-1, vmax=1)
    ax_c = f.colorbar(contour)
    ax_c.set_label('$w^tx$')
    ax_c.set_ticks([-1, -0.75, -0.5, -0.25, 0, 0.25, 0.5, 0.75, 1])
    ax.scatter(X[:, 0], X[:, 1], c=y, s=50, linewidth=2, 
                cmap="RdYlBu", edgecolor='white', label='Datos')
    ax.plot(grid[:, 0], a*grid[:, 0]+b, 'black', linewidth=2.0, label='Solucion')
    ax.set(
       xlim=(min_xy[0]-border_xy[0], max_xy[0]+border_xy[0]), 
       ylim=(min_xy[1]-border_xy[1], max_xy[1]+border_xy[1]),
       xlabel=x_l, ylabel=y_l)
    ax.legend()
    plt.title(title)
    plt.show()
	
"""Funcion para generar los datos que se van a usar en la practica"""
def genera_datos(N,dim,rango):
	X_u=simula_unif(N,dim,rango)
	Y_u=np.zeros(X_u.shape[0])
	a,b=p2.simula_recta()

	for i in range(X_u.shape[0]):
		Y_u[i]=f(X_u[i][0],X_u[i][1],a,b)

	Y_u[Y_u<0]=-1
	Y_u[Y_u>=0]=1
	
	return X_u,Y_u,a,b

"""Funcion que modifica el 10 por ciento de los datos, tiene como entrada X_u el vector de la muestra,
Y_u las etiquetas correspondientes e idx que es el vector para indexar X_u e Y_u para cambiar ese 10 por ciento
de forma aleatoria."""
def modifica_datos(X_u,Y_u,idx):

	X_u[idx]
	Y_u[idx]
	indices=np.arange(0,Y_u.shape[0])
	indices_negativos=indices[Y_u==-1]
	indices_positivos=indices[Y_u==1]
	
	indices_negativos=indices_negativos[:int((indices_negativos.shape[0]*0.1)+0.5)]
	indices_positivos=indices_positivos[:int((indices_positivos.shape[0]*0.1)+0.5)]
	
	for i in indices_negativos:
		Y_u[i]=1

	for j in indices_positivos:
		Y_u[j]=-1
	
#Ejercicio1
		
def f(x,y,a,b):
	return y-a*x-b

def simula_unif(N,dim,rango):
	
	out=[]
	
	for i in range(N):
		out.append(np.random.uniform(low=rango[0], high=rango[1], size=dim))
		
	return np.asanyarray(out,np.float64)
def f1(X):
	return ((X[:, 0]-10)**2) + ((X[:, 1]-20)**2)-400

def f2(X):
	return (0.5*(X[:, 0]-10)**2) + ((X[:, 1]-20)**2)-400

def f3(X):
	return (0.5*(X[:, 0]-10)**2) - ((X[:, 1]+20)**2)-400

def f4(X):
	return X[:, 1]-20*(X[:, 0]**2)-5*X[:, 0]+3

def fz1(x0):
	return np.sqrt(400-x0-10**2)+20

def fz2(x0):
	return np.sqrt(400-0.5*(x0+10**2))+20

def fz3(x0):
	a=(0.5*(x0-10)**2)-400
	"""He comentado la linea 57 del script ejemplo_pintar_frontera_de_decision
	   para que no salga el warning de la raiz cuadrada negativa. La linea en
	   cuestion es:
		   ax.plot(grid[:, 0], fx1(grid[:, 0]), 'black', linewidth=2.0, label='Solucion') """
	return np.sqrt(a)-20



def fz4(x0):
	return 20*(x0**2)+5*x0+3

"""Funcion para realizar el ejercicio 1a del apartado 1"""
def Apartado1_1a(X):
	
	plt.title("Distribucion uniforme")
	plt.xlabel("Eje_x")
	plt.ylabel("Eje_y")
	plt.scatter(X[:,0],X[:,1])
	plt.show()
	
"""Funcion para realizar el ejercicio 1b del apartado 1"""
def Apartado1_1b():
		
	X_g=p2.simula_gaus([50,2],[5,7])
	
	plt.title("Distribucion gausiana")
	plt.xlabel("Eje_x")
	plt.ylabel("Eje_y")
	plt.scatter(X_g[:,0],X_g[:,1])
	plt.show()

"""Funcion para realizar el ejercicio 2 del apartado 1"""
def Apartado1_2(X_u,Y_u,a,b,idx):
	
	p2.plot_datos_recta(X_u,Y_u,a,b,'Gráfica EJ1 apartado2a')
	X_m=np.copy(X_u)
	Y_m=np.copy(Y_u)
	modifica_datos(X_m,Y_m,idx)
	print ("\n\nDATOS MODIFICADOS\n\n")

	p2.plot_datos_recta(X_m,Y_m,a,b,'Gráfica EJ1 apartado2b')

"""Funcion para realizar el ejercicio 3 del apartado 1"""
def Apartado1_3(X,y,idx):
	X_m=np.copy(X)
	y_m=np.copy(y)
	modifica_datos(X_m,y_m,idx)
	p21.plot_datos_cuad(X_m, y_m, f1, fz1,'Gráfica funcion1')
	p21.plot_datos_cuad(X_m, y_m, f2, fz2,'Gráfica funcion2')	
	p21.plot_datos_cuad(X_m, y_m, f3, fz3,'Gráfica funcion3')
	p21.plot_datos_cuad(X_m, y_m, f4, fz4,'Gráfica funcion4')
	
"""Funcion para realizar el apartado 1"""
def Apartado1(X,Y,a,b,idx):
	
	Apartado1_1a(X)
	Apartado1_1b()
	
	Apartado1_2(X,Y,a,b,idx)
	Apartado1_3(X,Y,idx)
	

#Apartado 2

"""Funcion para el algoritmo PLA
"""
def PLA(datos,label,max_iter,wini):
	total_iters=0
	cambios=True
	ncambios=0
	w=np.copy(wini)
	for i in range (0,max_iter):
		cambios=False
		total_iters+=1
		
		for x,y in zip(datos,label):
			if np.sign(np.dot(np.transpose(w),x))!=np.sign(y):
				w=w+(y*x)
				ncambios+=1
		if (ncambios>0):
			ncambios=0
			cambios=True
		
		if not cambios:
			break
	return w,total_iters

"""Funcion para realizar el ejercicio 1a del apartado 2"""
def Apartado2_1a(X,Y):
	print ("\n\nDATOS NO MODIFICADOS\n\n")
	X=np.concatenate((X,np.zeros((X.shape[0],1),dtype=np.float64)),1)
	a=np.zeros(X.shape[1])
	w,iters=PLA(X,Y,1000,a)
	plot_data(X,Y,w,'Perceptron con datos 2a (W iniciado a 0)')
	print ("Total de iteraciones para vector iniciado a 0: ",iters)
	total=0
	for i in range (0,10):
		w=np.random.uniform(0,1,X.shape[1])
		w,iters=PLA(X,Y,1000,w)
		total+=iters
	plot_data(X,Y,w,'Perceptron con datos 2a (W iniciado a aleatorio)')
	print ("Media de iteraciones para vector iniciado a valores aleatoros: ",total/10)
	
	
"""Funcion para realizar el ejercicio 1b del apartado 2"""
def Apartado2_1b(X_u,Y_u,idx):
	print ("\n\nDATOS MODIFICADOS\n\n")
	X_m=np.copy(X_u)
	Y_m=np.copy(Y_u)
	modifica_datos(X_m,Y_m,idx)
	X_m=np.concatenate((X_m,np.zeros((X_m.shape[0],1),dtype=np.float64)),1)
	a=np.zeros(X_m.shape[1])
	w,iters=PLA(X_m,Y_m,1000,a)
	plot_data(X_m,Y_m,w,'Perceptron con datos 2a (W iniciado a 0)')
	print ("Total de iteraciones para vector iniciado a 0: ",iters)
	total=0
	for i in range (0,10):
		w=np.random.uniform(0,1,X_m.shape[1])
		w,iters=PLA(X_m,Y_m,1000,w)
		total+=iters
	plot_data(X_m,Y_m,w,'Perceptron con datos 2a (W iniciado a aleatorio)')
	print ("Media de iteraciones para vector iniciado a valores aleatoros: ",total/10)

"""Funcion para calcular la funcion sigmoide"""
def sigmoid (x):
	return 1/(1+np.exp(-x))

"""Funcion para calcular Ein"""
def errorRL(X,Y,w):
	suma=0
	
	for xi,yi in zip(X,Y):
		a=1+np.exp(yi*np.dot(w,xi))
		suma+=np.log(a)
	return a/X.shape[0]

"""Funcion para calcular el error de clasificacion para los datos
X y las etiquetas usando w"""
def ErrorClasificacion(X,Y,W):
	sumatory=0
	y_return=[]
	Y[Y<0]=0
	for xi,yi in zip (X,Y):
		a=sigmoid(yi*W.transpose().dot(xi))
		y_return.append(a)
		if a<=0.5 and yi==1:
			sumatory+=1
		elif a>0.5 and yi==0:
			sumatory+=1
			
	sumatory=sumatory/X.shape[0]
	return sumatory,y_return

def RL(xi,yi,w,n):
	a=-np.dot(xi,yi)*sigmoid(-yi*np.dot(xi,w.transpose()))
	
	return a/n
		
"""Funcion del SGD de la practica 1"""  
def SGD(X,Y,learning_rate,function,iterations,epsilon,batch):
	w=np.zeros((X.shape[1]),dtype=np.float64)
	w_anterior=np.copy(w)
	idx=np.arange(0,X.shape[0])
	for n in range(iterations):
		np.random.shuffle(idx)
		X[idx]
		Y[idx]
		minibatch=X[0:batch,:]		
		w_anterior=np.copy(w)
		for i in range (minibatch.shape[0]): 
			sumatory=function(X[i],Y[i],w,X.shape[0])
			w=w-(learning_rate*sumatory)
		
		if np.linalg.norm((w_anterior-w),1)<epsilon:
			break
		
	return w,n

"""Funcion para realizar el ejercicio 2 del apartado 2"""
def Apartado2_2():
	X_train,Y_train,a,b=genera_datos(100,2,[-50,50])
	idx=np.arange(0,X_train.shape[0])
	np.random.shuffle(idx)
	X_train=np.concatenate((X_train,np.ones((X_train.shape[0],1),dtype=np.float64)),1)
	w,n=SGD(X_train,Y_train,0.01,RL,10000000000,0.01,40)
	Ein_clas,y2=ErrorClasificacion(X_train,Y_train,w)
	Ein_log=errorRL(X_train,Y_train,w)
	X_test,Y_test,a,b=genera_datos(3000,2,[-50,50])
	X_test=np.concatenate((X_test,np.ones((X_test.shape[0],1),dtype=np.float64)),1)
	
	Eout,y3=ErrorClasificacion(X_test,Y_test,w)
	err_log=errorRL(X_test,Y_test,w)
	print ("Error de clasif dentro de la muestra: ",Ein_clas)
	print("Error logistico dentro de la muestra: ",Ein_log)
	print ("Error de clasif fuera de la muestra: ",Eout)
	print ("Error logistico fuera de la muestra: ",err_log)
	
	
"""Funcion para realizar el apartado 2"""
def Apartado2(X,Y,idx):
	Apartado2_1a(X,Y)
	Apartado2_1b(X,Y,idx)
	Apartado2_2()

#BONUS
"""Error lineal para calcular el mejor Ein para el pla pocket"""
def Error_lineal(X,Y,W):
	sumatory=0
	
	for i in range(X.shape[0]):
		a=W.dot(X[i])
		if a*Y[i]<0:
			sumatory=sumatory+1
			
	sumatory=sumatory/X.shape[0]
	return sumatory

def PLA_pocket(datos,label,max_iter,wini):
	total_iters=0
	cambios=True
	ncambios=0
	w=np.copy(wini)
	best_w=np.copy(w)
	best_ein=1
	for i in range (0,max_iter):
		cambios=False
		total_iters+=1
		
		for x,y in zip(datos,label):
			if np.sign(np.dot(np.transpose(w),x))!=np.sign(y):
				w=w+(y*x)
				ncambios+=1
		if (ncambios>0):
			ncambios=0
			cambios=True
		err=Error_lineal(datos,label,w)
		if err<best_ein:
			best_ein=err
			best_w=np.copy(w)
			
		if not cambios:
			break
		
	return best_w,total_iters

def PIA(X,Y):
	#Pseudo-inverse algorithm
	#calculo la transpuesta de X
	x_t = X.transpose()

	pseudo_inverse=np.linalg.inv(x_t.dot(X))
	pseudo_inverse=pseudo_inverse.dot(x_t)
	pseudo_inverse=pseudo_inverse.dot(Y)
	
	return pseudo_inverse
	
def separar_clases(x,y):
	#Me quedo con los datos de los numeros 8 y 4
	X_class1 = [x[y==4]]
	X_class5 = [x[y==8]]
	#Me quedo con las etiquetas de 4 y 8
	Y_class1=[y[y==4]]
	Y_class5=[y[y==8]]
	#Convierto a un array de numpy
	aux1=np.asarray(X_class1[0],np.float64)	
	aux2=np.asarray(X_class5[0],np.float64)
	
	#Concateno los dos arrays
	X=np.concatenate((aux1,aux2))
	#Le añado la columna de unos
	a=np.ones((X.shape[0],1),dtype=np.float64)
	X=np.concatenate((X,a),1)

	#Hago lo mismo para las etiquetas
	aux1=np.asarray(Y_class1[0],np.float64)
	aux2=np.asarray(Y_class5[0],np.float64)
	#Cambio la etiqueta del 8 a -1
	aux2[aux2==8]=1
	aux1[aux1==4]=-1
	
	
	Y=np.concatenate((aux1,aux2))
	
	#Aleatorizo la muestra
	idx = np.arange(0, X.shape[0], dtype=np.int32)
	np.random.shuffle(idx)
	X = X[idx]
	Y = Y[idx]
	return X,Y

def bonus():
	#Preparacion de los datos: Leo los datos del directorio
	#Estos datos son los de la practica 1
	x_learn=np.load("datos/X_train.npy")
	y_learn=np.load("datos/y_train.npy")
	x_test=np.load("datos/X_test.npy")
	y_test=np.load("datos/y_test.npy")
	
	X_train,Y_train=separar_clases(x_learn,y_learn)
	X_test,Y_test=separar_clases(x_test,y_test)
	w_pia=PIA(X_train,Y_train)
	w_pla,iters=PLA_pocket(X_train,Y_train,1000,np.zeros(X_train.shape[1]))
	print ("\n\n\nALGORITMO PLA-POCKET")
	print ("\n\n\nEin: ",Error_lineal(X_train,Y_train,w_pla))
	print ("Eout: ",Error_lineal(X_test,Y_test,w_pla))
	print ("\n\n\nALGORITMO PSEUDO-INVERSA")
	print ("\n\n\nEin: ",Error_lineal(X_train,Y_train,w_pia))
	print ("Eout: ",Error_lineal(X_test,Y_test,w_pia))
	
	plot_data(X_train,Y_train,w_pla,title="PLA pocket para datos del train",x_l="Intensidad promedio.",y_l="Simetria")
	plot_data(X_test,Y_test,w_pla,title="PLA pocket para datos del test",x_l="Intensidad promedio.",y_l="Simetria")
	plot_data(X_train,Y_train,w_pia,title="Pseudo-inversa para datos del train",x_l="Intensidad promedio.",y_l="Simetria")
	plot_data(X_test,Y_test,w_pia,title="Pseudo-inversa para datos del test",x_l="Intensidad promedio.",y_l="Simetria")
	

def main ():
	X,Y,a,b=genera_datos(50,2,[-50,50])
	idx=np.arange(0,X.shape[0])
	np.random.shuffle(idx)

	Apartado1(X,Y,a,b,idx)
	Apartado2(X,Y,idx)
	bonus()


main()