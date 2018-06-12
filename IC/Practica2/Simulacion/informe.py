#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import numpy as np

Tramites=np.loadtxt('DatosT.txt',comments='@',delimiter='\n')
Espera=np.loadtxt('DatosE.txt',comments='@',delimiter='\n')

mediaTramites=np.mean(Tramites)
mediaEspera=np.mean(Espera)
desviacionTramites=np.std(Tramites)
desviacionEspera=np.std(Espera)
numeroTramitesAtendidos=Tramites.shape[0]
f=open("Informe1.txt","w")
lista=[]
total="Numero total de tramites: " + str(numeroTramitesAtendidos) + "\n"
mediaTramite="Media de duracion tramites: " + str(mediaTramites) + "\n"
desviacionTramite="Desviacion tipica de duracion tramites: " + str(desviacionTramites) + "\n"
mediaeespera="Media de duracion en la sala de espera: " + str(mediaEspera) + "\n"
desviacionespera="Desviacion tipica de duracion en la sala de espera: " + str(desviacionEspera)+  "\n"

f.write(total)

f.write(mediaTramite)
f.write(desviacionTramite)

f.write(mediaeespera)
f.write(desviacionespera)
f.close()
