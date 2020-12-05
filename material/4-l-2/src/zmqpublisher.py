#!/usr/bin/env python3

import zmq
import random
import sys
import time
import math

"""
Generator class for geometric brownian motion process
- s0: Inital price.
- mu: Interest rate
- sigma: Volatility
"""
class gmb:
    name = None
    st = None
    mu = None
    sigma = None

    def __init__(self, name, s0=100, mu=None, sigma=None):
        if mu is None:
            mu = random.random() / 4
        if sigma is None:
            sigma = random.random() / 20
        self.name = name
        self.st = s0        
        self.mu = mu
        self.sigma = sigma

    def tick(self):
        # Function based on idea by Julian Herrera, https://towardsdatascience.com/create-a-stock-price-simulator-with-python-b08a184f197d
        self.st *= math.exp((self.mu - 0.5 * self.sigma ** 2) * (1. / 365.) + self.sigma * math.sqrt(1./365.) * random.gauss(mu=0, sigma=1))
        return self.st

# Parse input, essentially the port to listen on
port = "5556"
if len(sys.argv) > 1:
    port =  sys.argv[1]
    int(port)

# TODO: set up publisher socket




stocks = list([gmb(x) for x in ['DAT', 'BIT', 'CORE', 'WYP']])

# Keep sending stock data
while True:
    for stock in stocks:
        name = stock.name
        value = stock.tick()

        #TODO: publish data

    time.sleep(1)