# -*- coding: utf-8 -*-
import numpy as np
import matplotlib.pyplot as plt


# Función que devuelve un vector de forma <size> con valores aleatorios 
# extraídos de una normal de media <media> y varianza <sigma>.
# Se corresponde con simula_gaus(N, dim, sigma), en caso de llamarla
# con simula_gaus((N, dim0, dim1, ...), sigma).
def simula_gaus(size, sigma, media=None):
    media = 0 if media is None else media
    
    if len(size) > 2:
        N = size[0]
        size_sub = size[1:]
        
        out = np.zeros(size, np.float64)
        
        for i in range(N):
            out[i] = np.random.normal(loc=media, scale=sigma, size=size_sub)
    
    else:
        out = np.random.normal(loc=media, scale=sigma, size=size)
    
    return out


'''
    Pinta los datos con su etiqueta y la recta definida por a y b.
    X: Datos (Intensidad promedio, Simetría).
    y: Etiquetas (-1, 1).
    fz: Devuelve el valor de la altura de la función de etiquetado (z).
    fy: Dada x0, devuelve el valor de x1 para el hiperplano fz=0.
'''
def plot_datos_cuad(X, y, fz, fx1, title='Point clod plot', xaxis='x axis', yaxis='y axis'):
    #Preparar datos
    min_xy = X.min(axis=0)
    max_xy = X.max(axis=0)
    border_xy = (max_xy-min_xy)*0.01
    
    #Generar grid de predicciones
    xx, yy = np.mgrid[min_xy[0]-border_xy[0]:max_xy[0]+border_xy[0]+0.001:border_xy[0], 
                      min_xy[1]-border_xy[1]:max_xy[1]+border_xy[1]+0.001:border_xy[1]]
    grid = np.c_[xx.ravel(), yy.ravel(), np.ones_like(xx).ravel()]
    pred_y = fz(grid)
    pred_y = np.clip(pred_y, -1, 1).reshape(xx.shape)
    
    #Plot
    f, ax = plt.subplots(figsize=(8, 6))
    contour = ax.contourf(xx, yy, pred_y, 50, cmap='RdBu',
                      vmin=-1, vmax=1)
    ax_c = f.colorbar(contour)
    ax_c.set_label('$f(x, y)$')
    ax_c.set_ticks([-1, -0.75, -0.5, -0.25, 0, 0.25, 0.5, 0.75, 1])
    ax.scatter(X[:, 0], X[:, 1], c=y, s=50, linewidth=2, 
                cmap="RdYlBu", edgecolor='white', label='Datos')
    #ax.plot(grid[:, 0], fx1(grid[:, 0]), 'black', linewidth=2.0, label='Solucion')
    ax.set(
       xlim=(min_xy[0]-border_xy[0], max_xy[0]+border_xy[0]), 
       ylim=(min_xy[1]-border_xy[1], max_xy[1]+border_xy[1]),
       xlabel=xaxis, ylabel=yaxis)
    ax.legend()
    plt.title(title)
    plt.show()


def fz_cuad(X):
    return 0.01*X[:, 0]**2 - 0.1*X[:, 1] - 0.25


def fx1_cuad(x0):
    return 0.1*x0**2 - 2.5


#X = simula_gaus((500, 2), (5, 5))
#y = np.sign(fz_cuad(X))

#plot_datos_cuad(X, y, fz_cuad, fx1_cuad)
 
