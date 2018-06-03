
from sklearn.preprocessing import OneHotEncoder
from sklearn.preprocessing import StandardScaler
from sklearn.ensemble import AdaBoostClassifier, RandomForestClassifier
from sklearn.svm import SVC
from sklearn.neural_network import MLPClassifier
from sklearn.externals import joblib
from imblearn.over_sampling import SMOTE
from imblearn.pipeline import pipeline
from sklearn import tree
from sklearn.model_selection import GridSearchCV
from sklearn.model_selection import train_test_split
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import confusion_matrix, classification_report, auc, roc_curve
import matplotlib.pyplot as plt
import numpy as np
import itertools


def plot_roc_curve(model, X_test, y_test, title):
	probs = model.predict_proba(X_test)
	preds = probs[:, 1]
	fpr, tpr, threshold = roc_curve(y_test, preds)
	roc_auc = auc(fpr, tpr)

	plt.title(title)
	plt.plot(fpr, tpr, 'b', label='AUC = %0.2f' % roc_auc)
	plt.legend(loc='lower right')
	plt.plot([0, 1], [0, 1], 'r--')
	plt.xlim([0, 1])
	plt.ylim([0, 1])
	plt.ylabel('True Positive Rate')
	plt.xlabel('False Positive Rate')
	plt.show()

def plot_confusion_matrix(cm, classes,normalize=False,title='Confusion matrix', cmap=plt.cm.Blues):
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
	plt.show()

def ajuste_modelo(modelo, tuned_parameters, X_train, y_train, X_test, y_test, titulo):
	# Regresión logística
	# Set the parameters by cross-validation

	# Fit_intercept lo que hace es centrar los datos con la media y la varianza.
	# Esto esta hecho ya en la linea 20
	clf = GridSearchCV(modelo(), tuned_parameters, cv=5, n_jobs=5, scoring='f1')
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
	best_model = modelo(random_state=seed,**clf.best_params_)
	best_model.fit(X_train, y_train)
	class_names = np.unique(y_test)

	print("The scores are computed with full test set")
	y_pred_train = best_model.predict(X_train)

	matrix = confusion_matrix(y_train, y_pred_train)
	plot_confusion_matrix(matrix, class_names,title='Matriz de confusion train '+titulo)

	y_true, y_pred = y_test, best_model.predict(X_test)
	print(classification_report(y_true, y_pred))
	print()
	print("Confusion Matrix")

	matrix = confusion_matrix(y_true, y_pred)
	plot_confusion_matrix(matrix, class_names,title='Matriz de confusion '+titulo)
	plot_roc_curve(best_model, X_test, y_test, 'Curva ROC '+titulo)

	print("Introduzca algo por teclado: ")
	#input()
	joblib.dump(best_model, titulo+'.pkl')
	return best_model

seed = 123
np.random.seed(seed)

# Inicio de preprocesado de datos

datos = np.genfromtxt("UCI_Credit_Card.csv", dtype=np.float32, delimiter=',')
y = datos[:, datos.shape[1] - 1]


datos = np.delete(datos, datos.shape[1] - 1, 1)

X_train, X_test, y_train, y_test = train_test_split(datos, y,
													 test_size=0.2, random_state=seed)

CategoricasTrain = X_train[:, 2:10:1]
CategoricasTest = X_test[:, 2:10:1]
X_train = np.delete(X_train, np.arange(2, 11), 1)
X_test = np.delete(X_test, np.arange(2, 11), 1)

CategoricasTrain[CategoricasTrain < 0] = CategoricasTrain[CategoricasTrain < 0] + 11
CategoricasTest[CategoricasTest < 0] = CategoricasTest[CategoricasTest < 0] + 11

labels = np.unique(datos)

enc = OneHotEncoder(dtype=np.float32)
CategoricasTrain = enc.fit_transform(CategoricasTrain).todense()
CategoricasTest = enc.transform(CategoricasTest).todense()

scl = StandardScaler()
X_train = scl.fit_transform(X_train)
X_test = scl.transform(X_test)

X_train = np.concatenate([X_train, CategoricasTrain], 1)
X_test = np.concatenate([X_test, CategoricasTest], 1)

tuned_parameters_RL=[{'Sampling__kind':['borderline1, borderline2'],'ModeloBoosting__n_estimators':[9,10,11,12,13,14], 'ModeloBoosting__learning_rate': [0.9, 0.65, 0.5,0.45, 0.1]}]
#tuned_parameters_BOOSTING=[{'Sampling__kind':['borderline1, borderline2'],'ModeloBoosting__n_estimators':[9,10,11,12,13,14], 'ModeloBoosting__learning_rate': [0.9, 0.65, 0.5,0.45, 0.1]}]
tuned_parameters_RF=[{'Sampling__kind':['borderline1, borderline2'],'ModeloBoosting__n_estimators':[9,10,11,12,13,14], 'ModeloBoosting__learning_rate': [0.9, 0.65, 0.5,0.45, 0.1]}]
tuned_parameters_BOOSTING=[{'n_estimators':[9,10,11,12,13,14], 'learning_rate': [0.9, 0.65, 0.5,0.45, 0.1]}]


X_train, y_train = SMOTE(ratio='minority', random_state=seed, kind='borderline1').fit_sample(X_train, y_train)
## Fin preprocesado de datos

# Regresión logística
# Set the parameters by cross-validation
tuned_parameters_LOG = [{'penalty': ['l1'], 'C': [3,2,0.9, 0.5, 0.2,]},
						 {'penalty': ['l2'], 'C': [3,2,0.9, 0.5, 0.2]}]

# Fit_intercept lo que hace es centrar los datos con la media y la varianza.
# Esto esta hecho ya en la linea 20
#ajuste_modelo(LogisticRegression, tuned_parameters_LOG, X_train, y_train, X_test, y_test, 'Regresion Logistica')

tuned_parameters_TREE=[{'criterion': ['gini', 'entropy']}]
#S=ajuste_modelo(tree.DecisionTreeClassifier, tuned_parameters_TREE, X_train,y_train,X_test,y_test,'Decision Tree')

"""
tuned_parameters_MLP = [{'hidden_layer_sizes': [[1,5], [1,10]],
                         'alpha': [0.0001, 0.001], 
						 'activation':['relu', 'logistic']},{
                        'hidden_layer_sizes': [[2,5], [2,10]],
                         'alpha': [0.0001, 0.001],
						  'activation':['relu', 'logistic']},
                        {'hidden_layer_sizes': [[3,5], [3,10]],
                         'alpha': [0.0001, 0.001],
						  'activation':['relu', 'logistic']}]

ajuste_modelo(MLPClassifier,tuned_parameters_MLP, X_train, y_train, X_test, y_test, 'RRNN')
"""

tuned_parameters_RF=[{'n_estimators': [1,2,3]}]
#RF=ajuste_modelo(BaggingClassifier, tuned_parameters_RF, X_train, y_train, X_test, y_test, 'Random Forest')
#a=RF.feature_importances_
#separo los dos kernels porque el parametro degree solo se usa si se usa el kernel polinomial
iters=10000

#S=ajuste_modelo(SVC, tuned_parameters_SVC,X_train,y_train,X_test,y_test,'SVC')

S=ajuste_modelo(AdaBoostClassifier, tuned_parameters_BOOSTING,X_train,y_train,X_test,y_test,'AdaBoost')
