#!/usr/bin/env python3
# -*- coding: utf-8 -*-

from __future__ import print_function
from sklearn.model_selection import GridSearchCV
from sklearn import preprocessing
from sklearn.linear_model import SGDClassifier
from sklearn.pipeline import Pipeline
from sklearn.model_selection import train_test_split
from sklearn.externals import 	joblib
import numpy as np

seed = 1997

X = np.load("datos/optdigits_tra_X.npy")
y =np.load("datos/optdigits_tra_y.npy")
pipe=Pipeline([('Scale',preprocessing.StandardScaler()),
			   ('Norm',preprocessing.Normalizer())])
pipe.fit(X)
X=pipe.transform(X)
# Set the parameters by cross-validation
tuned_parameters = [{'loss':['hinge','log','squared_loss'],'penalty':['l1','l2'],'alpha':[0.001,0.01,0.005]}]

X_train, X_test, y_train, y_test = train_test_split(X, y,
                                                    stratify=y,
                                                    test_size=0.25,
                                                    random_state=seed)

#Fit_intercept lo que hace es centrar los datos con la media y la varianza.
#Esto esta hecho ya en la linea 20
clf = GridSearchCV(SGDClassifier(random_state=seed,fit_intercept=False,tol=1e-6,max_iter=1000), tuned_parameters, cv=5,
                       scoring='accuracy')
clf.fit(X_train, y_train)

print("Best parameters set found on development set:")
print()
print(clf.best_params_)
print()
print("Grid scores on development set:")
print()
means = clf.cv_results_['mean_test_score']
stds = clf.cv_results_['std_test_score']
for mean, std, params in zip(means, stds, clf.cv_results_['params']):
	print("%0.3f (+/-%0.03f) for %r"
              % (mean, std * 2, params))
	
print("\n\n\n END OF TUNNING PARAMETERS!!!\n\n\n")

print ("The model is trained on the full train set and with best parameters")
best_logistic_model=SGDClassifier(**clf.best_params_,fit_intercept=False)
best_logistic_model.fit(X,y)
print("The model is going to be saved in: SGD_model.pkl")
joblib.dump(best_logistic_model,'SGD_model.pkl')
