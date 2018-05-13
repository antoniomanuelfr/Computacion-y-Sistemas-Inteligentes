#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import numpy as np
np.random.seed(17021997)
import funciones_utils as func
import matplotlib.pyplot as plt
 #Funcion para el gradiente descendiente. Devuelve la evolucion del 
 #valor de error y el historial de coordenadas por las que ha pasado.

def GD(X,W,learning_rate,function,iterations,epsilon): 
	loss_history=np.zeros((iterations,1),dtype=np.float64)
	w_history=np.zeros((iterations,2),dtype=np.float64)
	new_w=np.zeros((2,1),dtype=np.float64)
	for i in range(iterations):
		
		new_w,value=function(X,W)
		W=W-(learning_rate*new_w)
		loss_history[i]=value
		w_history[i]=W
		
		if value<epsilon:
			break
		
	print ("Numero de iteraciones: "+str(i))
	return loss_history,w_history
#Funcion que calcula el gradiente para la funcion del apratado 2.
#Devuelve el gradiente evaluado en w y la funcion evaluada en w
def funcion_apartado_2(x,w):
	
	w_return=np.zeros((2,),dtype=np.float64)
	u=w[0]
	v=w[1]
	w_return[0]=2*((np.exp(v-2)*(u**3))-(4*(v**3)*np.exp(-u)))*((4*(v**3)*np.exp(-u))+(3*np.exp(v-2)*u**2))
	w_return[1]=2*((u**3)*np.exp(v-2)-(12*np.exp(-u)*v**2))*((u**3)*np.exp(v-2)-(4*np.exp(-u)*v**3))
	
	return w_return,(((w[0]**3)*np.exp(w[1]-2))-(4*np.exp(-w[0])*w[1]**3))**2 #La funcion devuelve el vector W y el error 
#Funcion que calcula el gradiente para la funcion del apratado 2.
#Devuelve el gradiente evaluado en w y la funcion evaluada en w
def funcion_apartado_3(x,w):
	
	w_return=np.zeros((2,),dtype=np.float64)
	
	w_return[0]=4*(np.pi*np.sin(2*np.pi*w[1])*np.cos(2*np.pi*w[0]))+2*(w[0]-2)
	w_return[1]=4*((np.pi*np.sin(2*np.pi*w[0])*np.cos(2*np.pi*w[1]))+w[1]+2)
	
	return w_return,2*(np.sin(2*np.pi*w[0])*np.sin(2*np.pi*w[1])+(w[1]+2)**2)+(w[0]-2)**2

#Comienzo del ejercicio 1
iterations=38
coordenada_apartado_2=np.ones((2,),dtype=np.float64)
print ("\nPunto de inicio: "+str(coordenada_apartado_2))
loss_values2b,w_values_2b=GD(0,coordenada_apartado_2,0.05,funcion_apartado_2,iterations,10**(-14))
print ("Coordenadas del minimo: "+str(w_values_2b[np.argmin(loss_values2b)]))
print ("Valor del minimo: "+str(loss_values2b[np.argmin(loss_values2b)]))


print("\n\nAPARTADO 3 Introduzca algo por teclado")
input()
iterations=50	
coordenada_apartado_3_a=np.ones((2,),dtype=np.float64)
coordenada_apartado_3_a=np.ones((2,),dtype=np.float64)

print ("Punto de inicio: "+str(coordenada_apartado_3_a))
print ("\nCon el learning rate como 0.01: ")
loss_values3_1,w_values_3_1=GD(0,coordenada_apartado_3_a,0.01,funcion_apartado_3,iterations,-12)
print ("\nCon el learning rate como 0.1")
loss_values3_2,w_values_3_2=GD(0,coordenada_apartado_3_a,0.1,funcion_apartado_3,iterations,-12)
print("Introduzca algo por teclado.")
input()
plt.plot(loss_values3_1[:],label='Learning rate=0.01')
plt.plot(loss_values3_2[:],label='learning rate=0.1')
plt.xlabel('Numero de iteraciones')
plt.ylabel('Valor del error')
plt.title('Evolucion del valor de la funcion')
plt.legend()
plt.show()

#Apartado 3b
coordenada_apartado_3b1=np.array([2.1,-2.1],dtype=np.float64)
coordenada_apartado_3b2=np.array([3,-3],dtype=np.float64)
coordenada_apartado_3b3=np.array([1.5,1.5],dtype=np.float64)
coordenada_apartado_3b4=np.array([1,-1],dtype=np.float64)

#Cuando llamo a GD el valor de epsilon se lo paso como -12 para que nunca salga del bucle de la funcion GD
print ("Apartado 3b: Coordenada de inicio: "+str(coordenada_apartado_3b1))
loss_values_3b1,w_values_3b1=GD(0,coordenada_apartado_3b1,0.01,funcion_apartado_3,iterations,-12)
print ("Coordenadas del minimo: "+str(w_values_3b1[np.argmin(loss_values_3b1)]))
print ("Valor del minimo: "+str(loss_values_3b1[np.argmin(loss_values_3b1)]))

print ("\nApartado 3b: Coordenada de inicio: "+str(coordenada_apartado_3b2))
loss_values_3b2,w_values_3b2=GD(0,coordenada_apartado_3b2,0.01,funcion_apartado_3,iterations,-12)
print ("Coordenadas del minimo: "+str(w_values_3b2[np.argmin(loss_values_3b2)]))
print ("Valor del minimo: "+str(loss_values_3b2[np.argmin(loss_values_3b2)]))


print ("\nApartado 3b: Coordenada de inicio: "+str(coordenada_apartado_3b3))
loss_values_3b3,w_values_3b3=GD(0,coordenada_apartado_3b3,0.01,funcion_apartado_3,iterations,-12)
print ("Coordenadas del minimo: "+str(w_values_3b3[np.argmin(loss_values_3b3)]))
print ("Valor del minimo: "+str(loss_values_3b3[np.argmin(loss_values_3b3)]))

print ("\nApartado 3b: Coordenada de inicio: "+str(coordenada_apartado_3b4))
loss_values_3b4,w_values_3b4=GD(0,coordenada_apartado_3b4,0.01,funcion_apartado_3,iterations,-12)
print ("Coordenadas del minimo: "+str(w_values_3b3[np.argmin(loss_values_3b4)]))
print ("Valor del minimo: "+str(loss_values_3b4[np.argmin(loss_values_3b4)]))
print("Introduzca algo por teclado.")
input()

print ("\n\n\n\n\nApartado 2 \n\n\n\n")

def coef2line(w):
    if(len(w)!= 3):
        raise ValueError('Solo se aceptan rectas para el plano 2d. Formato: [<a0>, <a1>, <b>].')
    
    a = -w[0]/w[1]
    b = -w[2]/w[1]
    
    return a, b


'''
    Pinta los datos con su etiqueta y la solución definida por w.
    X: Datos (Intensidad promedio, Simetría).
    y: Etiquetas (-1, 1).
    w: Lista o array de numpy (1d) con 3 valores. w[2] ha de ser el témino 
       independiente.
'''
def plot_data(X, y, w):
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
       xlabel='Intensidad promedio', ylabel='Simetria')
    ax.legend()
    plt.title('Solucion ejercicio 2.1')
    plt.show()
 

#Funcion que calcula el error a la hora de clasificar
def Error(X,Y,W):
	sumatory=0
	
	for i in range(X.shape[0]):
		a=W.dot(X[i])
		if a*Y[i]<0:
			sumatory=sumatory+1
			
	sumatory=sumatory/X.shape[0]
	return sumatory

def SGD(X,Y,learning_rate,function,iterations,epsilon,batch):
	#Funcion para el gradiente descendiente estocastico. Devuelve el vector de pesos
	w=np.ones((1,X.shape[1]),dtype=np.float64)
	ein=1
	for n in range(iterations):
		minibatch=X[n:n+batch,:]		
		for i in range (minibatch.shape[0]): 
			sumatory=function(X[i],Y[i],w)
			w=w-(learning_rate*sumatory)
		if epsilon!=0:
			ein=Error(X,Y,w)
			if ein<epsilon:
				break
	return w,ein
#Funcion que se encarga de hacer la sumatoria de cada xnj*wX
def function (X,Y,w):
	sumatory=np.array((1,X.shape[0]),dtype=np.float64)	
	a=w.dot(X)-Y
	sumatory=(X*a)
	
	return sumatory
		
def PIA(X,Y):
	#Pseudo-inverse algorithm
	#calculo la transpuesta de X
	x_t = X.transpose()

	pseudo_inverse=np.linalg.inv(x_t.dot(X))
	pseudo_inverse=pseudo_inverse.dot(x_t)
	pseudo_inverse=pseudo_inverse.dot(Y)
	
	return pseudo_inverse
	

def separar_clases(x,y):
	#Me quedo con los datos de los numeros 1 y 5
	X_class1 = [x[y==1]]
	X_class5 = [x[y==5]]
	#Me quedo con las etiquetas de 1 y 5
	Y_class1=[y[y==1]]
	Y_class5=[y[y==5]]
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
	#Cambio la etiqueta del 5 a -1
	aux2[aux2==5]=-1
	
	Y=np.concatenate((aux1,aux2))
	
	#Aleatorizo la muestra
	idx = np.arange(0, X.shape[0], dtype=np.int32)
	np.random.shuffle(idx)
	X = X[idx]
	Y = Y[idx]
	return X,Y

#Preparacion de los datos: Leo los datos del directorio
x_learn=np.load("datos/X_train.npy")
y_learn=np.load("datos/y_train.npy")
x_test=np.load("datos/X_test.npy")
y_test=np.load("datos/y_test.npy")

X_train,Y_train=separar_clases(x_learn,y_learn)
X_test,Y_test=separar_clases(x_test,y_test)

w_sgd,error=SGD(X_train,Y_train,0.01,function,100,0.000001,32)
w_pia=PIA(X_train,Y_train)

print ("Vector de pesos para el SGD: "+str(w_sgd))
print ("Error del train para el SGD: "+str(error))
print ("Error del test para el SGD: "+str(Error(X_test,Y_test,w_sgd)))

print ("\nVector de pesos para la pseudo-inversa: "+str(w_pia))
print ("Error del train para la pseudo-inversa: "+str(Error(X_train,Y_train,w_pia)))
print ("Error del test para la pseudo-inversa: "+str(Error(X_test,Y_test,w_pia)))
input()
#Paso el vector de numpy a una lista para poder usar la funcion plot_data
W_pia=w_pia.tolist()	
print("Grafica para TRAIN usando SGD")
#A la funcion le paso w_sgd[0] porque tiene dimension (1,3) y la funcion no funciona  
plot_data(X_train,Y_train,w_sgd.reshape(-1))
print("\nGrafica para TRAIN usando PSEUDOINVERSA")
plot_data(X_train,Y_train,W_pia)
print("\nGrafica para TEST usando SGD")
plot_data(X_test,Y_test,w_sgd.reshape(-1))
print("\nGrafica para TEST usando PSEUDOINVERSA")
plot_data(X_test,Y_test,W_pia)

##Apartado 2
print ("\n\n\nApartado 2 \n\n\n")
#Generacion de la muestra
X = func.simula_unif(N=1000, dims=2, size=(-1, 1))
y = func.label_data(X[:, 0], X[:, 1])
plt.scatter(X[:, 0], X[:, 1], c=y)
plt.show()
#Llamada al SGD para la muestra generada
w_apartado2,error=SGD(X,y,0.01,function,100,0,32)
print ("\nEl error en el apartado 2c es: ")
print (Error(X,y,w_apartado2))

print ("\n\n\n Apartado 2d\n\n\n")
iterations = 1000
Ein=0
X_train=0
Eout=0
for i in range (iterations):
	X= func.simula_unif(N=1000, dims=2, size=(-1, 1))
	y= func.label_data(X[:, 0], X[:, 1])
	X=np.c_[X,np.ones((X.shape[0],1))]
		
	w=np.zeros((1,3),dtype=np.float64)
	w,error_in=SGD(X, y,0.01,function,10,0,100)
	error_in=Error(X,y,w)
	Ein=Ein+error_in
	
	x_test=func.simula_unif(N=1000, dims=2, size=(-1, 1))
	x_test=np.c_[x_test,np.ones((x_test.shape[0],1))]

	y_test = func.label_data(x_test[:, 0], x_test[:, 1])

	error_out=Error(x_test,y_test,w)
	Eout=Eout+error_out
	if i == iterations/40:
		plot_data(x_test,y_test,w.reshape(-1))
	
Ein=Ein/iterations
Eout=Eout/iterations

print ("El error medio para el train es de: "+str(Ein))
print ("El error medio para el test es de: "+str(Eout))

	
	

	
	
	


