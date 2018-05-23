#!/usr/bin/env python3
# -*- coding: utf-8 -*-

from __future__ import print_function
from sklearn.model_selection import GridSearchCV
from sklearn import preprocessing
from sklearn.pipeline import Pipeline
from sklearn.model_selection import train_test_split
from sklearn.linear_model import LogisticRegression, Lasso, Ridge
from sklearn.metrics import confusion_matrix, classification_report, mean_squared_error
import matplotlib.pyplot as plt
import numpy as np
import itertools


def plot_confusion_matrix(cm, classes,
                          normalize=False,
                          title='Confusion matrix',
                          cmap=plt.cm.Blues):
	"""
	This function prints and plots the confusion matrix.
	Normalization can be applied by setting `normalize=True`.
	"""
	if normalize:
		cm = cm.astype('float') / cm.sum(axis=1)[:, np.newaxis]
		print("Normalized confusion matrix")
	else:
		print('Confusion matrix, without normalization')

	print(cm)

	plt.imshow(cm, interpolation='nearest', cmap=cmap)
	plt.title(title)
	plt.colorbar()
	tick_marks = np.arange(len(classes))
	plt.xticks(tick_marks, classes, rotation=45)
	plt.yticks(tick_marks, classes)

	fmt = '.2f' if normalize else 'd'
	thresh = cm.max() / 2.
	for i, j in itertools.product(range(cm.shape[0]), range(cm.shape[1])):
		plt.text(j, i, format(cm[i, j], fmt), horizontalalignment="center", color="white" if cm[i, j] > thresh else "black")

	plt.tight_layout()
	plt.ylabel('True label')
	plt.xlabel('Predicted label')
	plt.plot()


seed = 1997

X = np.load("datos/optdigits_tra_X.npy")
y = np.load("datos/optdigits_tra_y.npy")
scale = preprocessing.StandardScaler()
scale.fit(X)

# X=scale.transform(X)
# scale=preprocessing.Normalizer().fit (X)
scale = preprocessing.StandardScaler().fit(X)
X = scale.transform(X)

# Set the parameters by cross-validation
tuned_parameters = [{'penalty': ['l1'], 'C': [0.9, 0.5, 0.2, 0.15, 0.125, 0.1]},
					{'penalty': ['l2'], 'C': [0.9, 0.5, 0.2, 0.15, 0.125, 0.1]}]

# Fit_intercept lo que hace es centrar los datos con la media y la varianza.
# Esto esta hecho ya en la linea 20
clf = GridSearchCV(LogisticRegression(random_state=seed), tuned_parameters, cv=5, scoring='accuracy')
clf.fit(X, y)

print("Best parameters set found on development set:")
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

print("The model is trained on the full train set and with best parameters")
best_logistic_model = LogisticRegression(**clf.best_params_)
best_logistic_model.fit(X, y)

X_test = np.load("datos/optdigits_tes_X.npy")
y_test = np.load("datos/optdigits_tes_y.npy")
class_names = np.unique(y_test)

X_test = scale.transform(X_test)

print("The scores are computed with full test set")

y_true, y_pred = y_test, best_logistic_model.predict(X_test)
print(classification_report(y_true, y_pred))
print()

print("Confusion Matrix")

matrix = confusion_matrix(y_true, y_pred)

plot_confusion_matrix(matrix, class_names)

del X, y, X_test, y_test, clf, best_logistic_model, matrix, means, stds, tuned_parameters

print()
print("\nREGRESION\n")
print()


def gridSearchFunction(Model, parameters, scoring):
	clf = GridSearchCV(Model, parameters, cv=5, scoring=scoring)
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
		print("%0.3f (+/-%0.03f) for %r" % (mean, std * 2, params))
	print("\n\n\n END OF TUNNING PARAMETERS!!!\n\n\n")

	print("The model is trained on the full train set and with best parameters")
	return clf.best_params_


pipe = Pipeline([('Pol', preprocessing.PolynomialFeatures(degree=6)), ('Scale', preprocessing.StandardScaler())])

X = np.load('datos/airfoil_self_noise_X.npy')
y = np.load('datos/airfoil_self_noise_y.npy')
X_train, X_test, y_train, y_test = train_test_split(
	X, y, test_size=0.25, random_state=seed)

pipe.fit(X_train)

X_train = pipe.transform(X_train)
X_test = pipe.transform(X_test)

tuned_parameters_Lasso = [{'alpha': [0.01, 0.05, 0.1, 0.5]}]
tuned_parameters_Ridge = [{'alpha': [0.01, 0.05, 0.1, 0.5]}]

bestLassoParams = gridSearchFunction(Lasso(random_state=seed), tuned_parameters_Lasso, 'neg_mean_squared_error')

bestLasso = Lasso(**bestLassoParams).fit(X_train, y_train)
coefs = bestLasso.coef_
"""
X_train = X_train * coefs.T
X_test = X_test * coefs.T
"""
bestRidgeParams = gridSearchFunction(Ridge(random_state=seed), tuned_parameters_Ridge, 'neg_mean_squared_error')

bestRidge = Ridge(**bestRidgeParams).fit(X_train, y_train)
print("Ridge score with r2: %s" % bestRidge.score(X_test, y_test))
print("Ridge score with MSE: %s" % mean_squared_error(y_test, bestRidge.predict(X_test)))
