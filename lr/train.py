#!/usr/bin/env python

import sys
import pickle
from optparse import OptionParser

from lrsgd import LogisticRegressionSGD
from utils import parse_svm_light_data

if __name__ == '__main__':
    parser = OptionParser()
    parser.add_option("-e", "--eta", action="store",
                      dest="eta", default=0.01, help="step size", type="float")
    parser.add_option("-c", "--Regularization-Constant", action="store",
                      dest="C", default=0.0, help="regularization strength", type="float")
    parser.add_option("-f", "--feature-num", action="store",
                      dest="n_feature", help="number of features", type="int")
    parser.add_option("-m", "--model-path", action="store", dest="path",
                      default="model.txt", help="path where trained classifier was saved")

    options, args = parser.parse_args(sys.argv)

    classifier = LogisticRegressionSGD(
        options.eta, options.C, options.n_feature)

    for X, y in parse_svm_light_data(sys.stdin):
        classifier.fit(X, y)

    with open(options.path, "wb") as f:
        pickle.dump(classifier, f)
