#!/usr/bin/env python3

import sys
import zmq

"""
Helper class for keeping track of exponential weighted moving average
"""
class ewma:
    alpha = None
    value = None

    def __init__(self, alpha):
        self.alpha = alpha
    
    def update(self, value):
        if self.value is None:
            self.value = value
        else:
            self.value = (self.value * self.alpha) + ((1 - self.alpha) * value)

        return self.value

port = "5556"
if len(sys.argv) > 1:
    port = sys.argv[1]
    int(port)
    
topicfilter = "WYP"
if len(sys.argv) > 2:
    topicfilter = sys.argv[2]

# TODO: Create socket, connect, and subscribe to chosen ticker

# Compute the ewma's
fast = ewma(1.0/5)
slow = ewma(1.0/12)

for cnt in range(50):
    # TODO: Read message from socket
    messagedata = "????"

    value = float(messagedata)

    print(topic, value)

    fast.update(value)
    slow.update(value)
    if cnt > 12:
        if fast.value > slow.value:
            print("Going down")
        else:
            print("Going up")

      
