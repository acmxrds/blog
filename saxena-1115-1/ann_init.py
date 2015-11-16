__author__ = 'Abhineet Saxena'

from pybrain.structure import FeedForwardNetwork
from pybrain.structure import LinearLayer, SigmoidLayer
from pybrain.structure import FullConnection

# Here we instantiate a Feed-Forward Network.
annet = FeedForwardNetwork()

# Creation of the input layer: Here the integer denotes the number of nodes we wish to have in the layer.
inLayer = LinearLayer(2, 'inlyr')

# Creation of the hidden layer.
hid1Layer = SigmoidLayer(2, 'hiddenlyr')

# Creation of the Output layer.
outLayer = LinearLayer(1, 'outlyr')

# Instantiating the Bias Unit.
bias_val = BiasUnit()

# Adding the corresponding layers to the network.
annet.addInputModule(inLayer)
annet.addModule(hid1Layer)
annet.addModule(bias_val)
annet.addOutputModule(outLayer)

# Adding the connections b/w layers pair-wise.
# Note
# FullConnection denotes all the nodes of one layer are connected to all nodes in the next layer.
annet.addConnection(FullConnection(inLayer, hid1Layer))
annet.addConnection(FullConnection(bias_val, hid1Layer))
annet.addConnection(FullConnection(hid1Layer, outLayer))

# The method performs internal management of the specifications.
annet.sortModules()
