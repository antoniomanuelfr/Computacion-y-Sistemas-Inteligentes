import numpy as np
import matplotlib.pyplot as plt


def simula_unif(N=2, dims=2, size=(0, 1)):
    m = np.random.uniform(low=size[0],
                          high=size[1],
                          size=(N, dims))

    return m


def label_data(x1, x2):
    y = np.sign((x1-0.2)**2 + x2**2 - 0.6)
    idx = np.random.choice(range(y.shape[0]), size=(int(y.shape[0]*0.1)), replace=True)
    y[idx] *= -1

    return y


# #Generate data
# X = simula_unif(N=1000, dims=2, size=(-1, 1))
# y = label_data(X[:, 0], X[:, 1])
#
# #Plot data
# plt.scatter(X[:, 0], X[:, 1], c=y)
# plt.show()
