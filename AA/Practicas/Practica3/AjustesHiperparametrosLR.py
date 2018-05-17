#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue May 15 12:15:49 2018

@author: antoniomanuelfr
"""

from sklearn.metrics import mean_squared_error
from sklearn import preprocessing
from sklearn.pipeline import Pipeline
from sklearn.linear_model import Lasso ,Ridge
from sklearn.model_selection import train_test_split
import numpy as np
from sklearn.model_selection import GridSearchCV

def gridSearchFunction(Model,parameters,scoring):
	clf = GridSearchCV(Model, parameters, cv=5,scoring=scoring)
	clf.fit(X_train, y_train)

	print("Best parameters set found on development set for Lasso:")
	print()
	print(clf.best_params_)
	print()
	print("Grid scores on development set:")
	print()
	means = clf.cv_results_['mean_test_score']
	stds = clf.cv_results_['std_test_score']
	for mean, std, params in zip(means, stds, clf.cv_results_['params']):
		print("%0.3f (+/-%0.03f) for %r" % (mean, std * 2, params))
	print("\n\n\n END OF TUNNING PARAMETERS!!!\n\n\n")

	print ("The model is trained on the full train set and with best parameters")
	return clf.best_params_

np.set_printoptions(formatter={'float': lambda x: "{0:0.3f}".format(x)})

seed = 76626194

pipe=Pipeline([ ('Pol',preprocessing.PolynomialFeatures(degree=6)),
				('Scale',preprocessing.StandardScaler()) ])


X = np.load( 'datos/airfoil_self_noise_X.npy')
y = np.load( 'datos/airfoil_self_noise_y.npy' )
X_train, X_test, y_train, y_test = train_test_split(
    X, y, test_size = 0.25, random_state = seed)

pipe.fit( X_train )

X_train = pipe.transform( X_train )
X_test = pipe.transform( X_test )



tuned_parameters_Lasso = [{'alpha': [0.01,0.05,0.1,0.5]}]
tuned_parameters_Ridge = [{'alpha': [0.01,0.05,0.1,0.5]}]

bestLassoParams=gridSearchFunction(Lasso(random_state=seed),tuned_parameters_Lasso,'neg_mean_squared_error')

bestLasso=Lasso(**bestLassoParams).fit(X_train,y_train)
coefs=bestLasso.coef_
"""
X_train = X_train * coefs.T
X_test = X_test * coefs.T
"""
bestRidgeParams=gridSearchFunction(Ridge(random_state=seed),tuned_parameters_Ridge,'neg_mean_squared_error')

bestRidge=Ridge(**bestRidgeParams).fit(X_train,y_train)
print("RidgeCV score with r2: %s" % bestRidge.score(X_test, y_test))
print("RidgeCV score with MSE: %s" % mean_squared_error(y_test,bestRidge.predict(X_test)))