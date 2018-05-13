# -*- coding: utf-8 -*-
######################################################################
## A parte de las funciones aquí implementadas, necesitareis        ##
## np.random.uniform(rango[0], rango[1], size=(N, dim0, dim1, ...)) ## 
## que se corresponde con simula_unif(N, dim, rango)                ##              
######################################################################

import numpy as np
import matplotlib.pyplot as plt


# Función que devuelve un vector de forma <size> con valores aleatorios 
# extraídos de una normal de media <media> y varianza <sigma>.
# Se corresponde con simula_gaus(N, dim, sigma), en caso de llamarla
# con simula_gaus((N, dim0, dim1, ...), sigma).
def simula_gaus(size, sigma, media=None):
    media = 0 if media is None else media
    
    if len(size) >= 2:
        N = size[0]
        size_sub = size[1:]
        
        out = np.zeros(size, np.float64)
        
        for i in range(N):
            out[i] = np.random.normal(loc=media, scale=np.sqrt(sigma), size=size_sub)
    
    else:
        out = np.random.normal(loc=media, scale=sigma, size=size)
    
    return out


# Función que devuelve los parámetros a y b de una recta aleatoria,
# y = a*x + b, tal que dicha recta corta al cuadrado definido por 
# por los puntos (intervalo[0], intervalo[0]) y 
# (intervalo[1], intervalo[1]).
def simula_recta(intervalo=(-1,1), ptos = None):
    if ptos is None: 
        m = np.random.uniform(intervalo[0], intervalo[1], size=(2, 2))
    
    a = (m[0,1]-m[1,1])/(m[0,0]-m[1,0]) # Calculo de la pendiente.
    b = m[0,1] - a*m[0,0]               # Calculo del termino independiente.
    
    return a, b

'''
    Transforma los parámetros de una recta 2d a los coeficientes de w.
    a: Pendiente de la recta.
    b: Término independiente de la recta.
'''
def line2coef(a, b):
    w = np.zeros(3, np.float64)
    #w[0] = a/(1-a-b)
    #w[2] = (b-b*w[0])/(b-1)
    #w[1] = 1 - w[0] - w[2]
    
    #Suponemos que w[1] = 1
    w[0] = -a
    w[1] = 1.0
    w[2] = -b
    
    return w


'''
    Pinta los datos con su etiqueta y la recta definida por a y b.
    X: Datos (Intensidad promedio, Simetría).
    y: Etiquetas (-1, 1).
    a: Pendiente de la recta.
    b: Término independiente de la recta.
'''
def plot_datos_recta(X, y, a, b, title='Point clod plot', xaxis='x axis', yaxis='y axis'):
    #Preparar datos
    w = line2coef(a, b)
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
       xlabel=xaxis, ylabel=yaxis)
    ax.legend()
    plt.title(title)
    plt.show()

 
