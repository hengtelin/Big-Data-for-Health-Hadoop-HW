#!/usr/bin/env python
from __future__ import print_function
import sys
import pickle
from optparse import OptionParser
from lrsgd import LogisticRegressionSGD
from utils import parse_svm_light_line

parser = OptionParser()
parser.add_option("-e", "--eta", action="store", dest="eta",
                  default=0.01, help="step size")
parser.add_option("-c", "--Regularization-Constant", action="store", dest="C",
                  default=0.0, help="regularization strength")
parser.add_option("-f", "--feature-num", action="store", dest="n_feature",
                  help="number of features", type="int")
options, args = parser.parse_args(sys.argv)

classifier = LogisticRegressionSGD(options.eta, options.C, options.n_feature)

for line in sys.stdin:

    key, value = line.split("\t", 1)
    value = value.strip()
    X, y = parse_svm_light_line(value)
    classifier.fit(X, y)

pickle.dump(classifier, sys.stdout)
