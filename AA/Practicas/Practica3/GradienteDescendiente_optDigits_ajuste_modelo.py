#!/usr/bin/env python3
# -*- coding: utf-8 -*-

from __future__ import print_function
import itertools
from sklearn import preprocessing
from sklearn.pipeline import Pipeline
from sklearn.externals import joblib
from sklearn.metrics import confusion_matrix,classification_report
import numpy as np
import matplotlib.pyplot as plt

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

seed = 1997
X_train=np.load("datos/optdigits_tra_X.npy")
X_test=np.load("datos/optdigits_tes_X.npy")
y_test=np.load("datos/optdigits_tes_y.npy")
class_names=np.unique(y_test)
pipe=Pipeline([('Scale',preprocessing.StandardScaler()),
			   ('Norm',preprocessing.Normalizer())])
pipe.fit(X_train)

X_test=pipe.transform(X_test)


best_logistic_model=joblib.load('SGD_model.pkl')
print ("The model is trained on the full train set and with best parameters")

print("The scores are computed with full test set")

y_true, y_pred = y_test, best_logistic_model.predict(X_test)
print(classification_report(y_true, y_pred))
print()

print("Confusion Matrix")

matrix=confusion_matrix(y_true,y_pred)

plot_confusion_matrix(matrix,class_names,normalize=True) 
