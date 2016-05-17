#!/usr/bin/env python
"""
Implement your own version of logistic regression with stochastic
gradient descent.

Author: <hengte lin>
Email : <linhengte1993@live.cn>
"""

import collections
import math


class LogisticRegressionSGD:

    def __init__(self, eta, mu, n_feature):
        """
        Initialization of model parameters
        """
        self.eta = float(eta)
        self.weight = [0.0] * n_feature
        self.mu=float(mu)

    def fit(self, X, y):
        """
        Update model using a pair of training sample
        """
        wtx=0
        weightnow=self.weight[:]
        for i in X:
            wtx=wtx+self.weight[i[0]]*i[1]#wti*xi
        for i in X:
            b=i[1]*(y-1/(1+math.exp(-wtx)))#(y-h(wt*x))*Xi
            weightnow[i[0]]+=self.eta*b#Wi=Wi+eta*(y-h(wt*x))*Xi
            weightnow[i[0]]-=self.eta*self.mu*(self.weight[i]*2)#when xi is not 0, regularization


    def predict(self, X):
        return 1 if predict_prob(X) > 0.5 else 0

    def predict_prob(self, X):
        return 1.0 / (1.0 + math.exp(-math.fsum((self.weight[f]*v for f, v in X))))
