__author__ = 'Abhineet Saxena'

from pybrain.datasets import SupervisedDataSet
from pybrain.supervised.trainers import BackpropTrainer
from pybrain.tools.shortcuts import buildNetwork

import random as rnd


# A function to round-off the obtained values.
def roundOff(xvar):
    if xvar < 0.5:
        return 0
    else:
        return 1


# Here we define the data model for the XOR function.
# Each sublist [Inputs, Output] consists of the #following tuples: Inputs: (x,y) and Output: (x XOR y).
dataModel = [[(0, 0), (0,)], [(0, 1), (1,)], [(1, 0), (1,)], [(1, 1), (0,)]]

# Instantiating the Network.
annet = buildNetwork(2, 2, 1, bias=True)

# To view the structure of the Network.
print annet

# Creation of the default dataset for backpropagation.
datset = SupervisedDataSet(2, 1)
for inputs, target in dataModel:
    datset.addSample(inputs, target)

# Creation of the training dataset which would be used to train the network till convergence.
training_set = SupervisedDataSet(2, 1)

for iter in xrange(1000):
    # Randomly selecting input-output records from the 4 possible, valid inputs for the XOR gate.
    rand_val = rnd.randint(0, 3)
    inputs, target = dataModel[rand_val]
    training_set.addSample(inputs, target)

# Setting up the trainer which utilizes Back-Propagation technique. Here 'datset' simply serves as the default dataset.
# It won't be utilized for training the network.
trainer = BackpropTrainer(annet, datset, learningrate=0.01, momentum=0.9)

# Training the set for 15 max. learning cycles till convergence using training_set as training data.
trainer.trainUntilConvergence(verbose=True,
                              trainingData=training_set,
                              validationData=datset,
                              maxEpochs=15)

# Running the network on sample input values
print 'The output for 0,0 is: ', roundOff(annet.activate([0, 0]))
print 'The output for 0,1 is: ', roundOff(annet.activate([0, 1]))
print 'The output for 1,0 is: ', roundOff(annet.activate([1, 0]))
print 'The output for  1,1 is: ', roundOff(annet.activate([1, 1]))
