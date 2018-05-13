#!/usr/bin/env python3
# -*- coding: utf-8 -*-

from __future__ import print_function
from sklearn.model_selection import GridSearchCV
from sklearn import preprocessing
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import classification_report
from sklearn.pipeline import Pipeline
from sklearn.metrics import confusion_matrix
from sklearn.model_selection import train_test_split
from sklearn.externals import 	joblib
import numpy as np
import itertools
import matplotlib.pyplot as plt

seed = 1997

X = np.load("datos/optdigits_tra_X.npy")
y =np.load("datos/optdigits_tra_y.npy")
X_true_test=np.load("datos/optdigits_tes_X.npy")
y_true_test=np.load("datos/optdigits_tes_y.npy")
class_names=range(0,y.shape[0])
pipe=Pipeline([('Scale',preprocessing.StandardScaler()),
			   ('Norm',preprocessing.Normalizer())])
pipe.fit(X)
X=pipe.transform(X)
X_true_test=pipe.transform(X_true_test)
# Set the parameters by cross-validation
tuned_parameters = [{'penalty': ['l1'], 'solver':['saga'],'C':[0.9,0.5,0.1]},
					 {'penalty': ['l2'], 'solver':['saga'],'C':[0.9,0.5,0.1]}]

iteration = 1000
tolerance = 1e-7

scores = ['precision_macro','recall_macro','accuracy']

X_train, X_test, y_train, y_test = train_test_split(X, y,
                                                    stratify=y,
                                                    test_size=0.25,
                                                    random_state=seed)

for score in scores:
	print("# Tuning hyper-parameters for %s" % score)
	#Fit_intercept lo que hace es centrar los datos con la media y la varianza.
	#Esto esta hecho ya en la linea 20
	clf = GridSearchCV(LogisticRegression(max_iter=1000,random_state=seed,fit_intercept=False), tuned_parameters, cv=5,
                       scoring=score)
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
	X = np.load("datos/optdigits_tra_X.npy")
y =np.load("datos/optdigits_tra_y.npy")
X_true_test=np.load("datos/optdigits_tes_X.npy")
y_true_test=np.load("datos/optdigits_tes_y.npy")
class_names=range(0,y.shape[0])
pipe=Pipeline([('Scale',preprocessing.StandardScaler()),
			   ('Norm',preprocessing.Normalizer())])
pipe.fit(X)
X=pipe.transform(X)

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
        plt.text(j, i, format(cm[i, j], fmt),
                 horizontalalignment="center",
                 color="white" if cm[i, j] > thresh else "black")

    plt.tight_layout()
    plt.ylabel('True label')
    plt.xlabel('Predicted label')

print ("The model is trained on the full train set and with best parameters")
best_logistic_model=LogisticRegression(**clf.best_params_,fit_intercept=False)
best_logistic_model.fit(X,y)
print("The model is going to be saved in: LogicRegresion_model.pkl")
joblib.dump(best_logistic_model,'LogicRegresion_model.pkl')
