#!/usr/bin/env python3
# -*- coding: utf-8 -*-

from __future__ import print_function
import itertools
from sklearn import preprocessing
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import classification_report
from sklearn.pipeline import Pipeline
from sklearn.metrics import confusion_matrix
import numpy as np
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
print()
print("The scores are computed with full test set")

y_true, y_pred = y_true_test, best_logistic_model.predict(X_true_test)
print(classification_report(y_true, y_pred))
print()

print("Confusion Matrix")

confusion_matrix(y_true,y_pred)
plot_confusion_matrix(confusion_matrix,class_names) 
