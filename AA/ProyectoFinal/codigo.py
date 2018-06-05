from sklearn.preprocessing import OneHotEncoder
from sklearn.preprocessing import StandardScaler
from sklearn.ensemble import RandomForestClassifier, AdaBoostClassifier
from sklearn.svm import SVC
from sklearn.neural_network import MLPClassifier
from sklearn.externals import joblib
from imblearn.over_sampling import SMOTE
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
	clf = GridSearchCV(modelo(random_state=seed), tuned_parameters, cv=5, n_jobs=5, scoring='f1')
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
	joblib.dump(best_model, titulo+'-'+tipoSmote+'.pkl')
	return best_model

def preparar_roc(model, X_test, y_test, title_model, title_graph):
	probsmodel = model.predict_proba(X_test)
	predsmodel = probsmodel[:, 1]
	fprmodel, tprmodel, thresholdmodel = roc_curve(y_test, predsmodel)
	roc_auc = auc(fprmodel, tprmodel)

	# method I: plt
	plt.title(title_graph)
	plt.plot(fprmodel, tprmodel, label=title_model+' = %0.2f' % roc_auc)
	plt.legend(loc='lower right')
	plt.plot([0, 1], [0, 1], 'r--')
	plt.xlim([0, 1])
	plt.ylim([0, 1])
	plt.ylabel('True Positive Rate')
	plt.xlabel('False Positive Rate')
seed = 123
np.random.seed(seed)

# Inicio de preprocesado de datos
a=input("Seleccione tipo de SMOTE: \n1 -> Regular \n2 -> Borderline1 \n3 -> Borderline2\n")
if a=='1':
	tipoSmote='regular'
elif a=='2':
	tipoSmote='borderline1'
elif a=='3':
	tipoSmote='borderline2'
else:
	print("No valido.")
	exit(1)

datos = np.genfromtxt("datos/UCI_Credit_Card.csv", dtype=np.float32, delimiter=',')
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

X_train, y_train = SMOTE(ratio='minority', random_state=seed, kind=tipoSmote).fit_sample(X_train, y_train)
## Fin preprocesado de datos

tuned_parameters_LOG = [{'penalty': ['l1'], 'C': [3,2,0.9, 0.5, 0.2,]},
						 {'penalty': ['l2'], 'C': [3,2,0.9, 0.5, 0.2]}]

LOG=ajuste_modelo(LogisticRegression, tuned_parameters_LOG, X_train, y_train, X_test, y_test, 'Regresion-Logistica')

tuned_parameters_RF=[{'n_estimators': [10,15,19,30,35], 'max_features': ['sqrt'], 'max_depth':[10,20,30,35,40,50,60,70], 'min_samples_leaf':[80,90,100]}]
RF=ajuste_modelo(RandomForestClassifier, tuned_parameters_RF, X_train, y_train, X_test, y_test, 'Random-Forest')

tuned_parameters_BOOSTING=[{'n_estimators':[30,40,50,60,70], 'learning_rate': [0.9,0.65,0.5,0.2]}]
BOO=ajuste_modelo(AdaBoostClassifier, tuned_parameters_BOOSTING,X_train,y_train,X_test,y_test,'AdaBoost')

names= ['Boosting', 'Reg. Log.','Random Forest']

models=[BOO,LOG,RF]

for i,j in zip (models,names):
	preparar_roc(i,X_test,y_test,j, 'ROC-'+tipoSmote)

plt.show()