#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue May  1 11:41:15 2018

@author: antoniomanuelfr
"""
import numpy as np
class Datos():
	def __init__(self,w,clas,red,punt):
		self.w=w
		self.clas=clas
		self.red=red
		self.punt=punt
	
	def actualizar(self,clas,red,punt):
		self.clas=clas
		self.red=red
		self.punt=punt
