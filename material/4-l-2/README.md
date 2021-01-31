# Working with network applications

In todays lab we will experiment with networking applications. Ideally, the applications should run on two different hosts, but this requires some setup and is hard to debug. Instead, we will focus on creating and testing applications on a local machine, using the loopback adapter (IP: 127.0.0.1), to communicate between two processes.

If you are using the terminal for debugging, you will need to have two terminals open. If you are using an IDE, such as VSCode, you will need to run two instances.

The prerequisite for this lab is:
  * [Video 8](https://sid.erda.dk/share_redirect/E1AHoSA0B6/8%20-%20Lecture.mp4)([slides for video 8](https://github.com/diku-dk/hpps-e2020-pub/raw/master/material/4-l-2/8%20-%20Lecture.pdf))

## Installing required packages

The ZeroMQ package can be installed with `pip`, using something like:
```
pip install zmq
```

On macOS you need to specify Python3, so the command would be:
```
python3 -m pip install zmq
```

The example project that we will base today on, is a [PyZMQ tutorial](https://learning-0mq-with-pyzmq.readthedocs.io/en/latest/pyzmq/patterns/pubsub.html) which explains how to set up a generic publish/subscribe system.

## The first task: set up a ZeroMQ publisher

In the [src](./src/) folder there is a template file called [`zmqpublisher.py`](./src/zmqpublisher.py) which contains a [stock price simulator](https://towardsdatascience.com/create-a-stock-price-simulator-with-python-b08a184f197d) and some helper code to publish the current stock prices. Inside the file there are two areas marked with **TODO** where you need to fill in some code. You can look at the [PyZMQ tutorial](https://learning-0mq-with-pyzmq.readthedocs.io/en/latest/pyzmq/patterns/pubsub.html) if you need hints for how to solve it.

If you get stuck, there is a reference solution in the [ref](./ref/) folder.

## The second task: set up an automated stock guesser

As before, look in the [src](./src/) folder and find a template file called [`zmqsubscriber.py`](./src/zmqsubscriber.py). The file contains support code for computing the [exponential weighted moving average, EWMA](https://en.wikipedia.org/wiki/Moving_average#Exponential_moving_average) for the a value. The EWMA algorithm that is used on stock pricing is actually the same algorithm that is used to compute the expected RTT for a TCP package when deciding what timeout values to apply.

By applying two different EWMA decays for a signal we can observe the [moving average convergence](https://en.wikipedia.org/wiki/MACD), which can be interpreted as a signal indicating if the price is currently increasing or decreasing.

The code for performing this calculation is included in the template file, and you need to fill in the code that is required to read the data being sent by the server you wrote in the previous task.

Again, the file contains two areas marked with **TODO** where you need to fill in some code. You can look at the [PyZMQ tutorial](https://learning-0mq-with-pyzmq.readthedocs.io/en/latest/pyzmq/patterns/pubsub.html) if you need hints for how to solve it.

If you get stuck, there is a reference solution in the [ref](./ref/) folder.

When you are ready to test the solution, you need at least two terminals (or IDEs) running. One terminal will run the publisher, and the other terminal(s) will run the subscriber. Try starting and stopping multiple subscribers and notice that the underlying connection handling is fully hidden from the publisher code.

## Working with sockets

As explained in the video material, the interface for sockets is really based on C, but is well supported in all programming languages, including Python.

For the assignment, we will not be building the client part, but rely on existing HTTP capable tools, such as your favorite browser.

To get you started with a basic socket server, you can use the ["echo server"](https://realpython.com/python-sockets/#echo-server) example.

If you have the echo server up and running you may want to test it, to see that it is really working. There is a matching ["echo client"](https://realpython.com/python-sockets/#echo-client) that will do just that.

If you use the example, you can craft special messages that can be sent to the server. This is useful both when developing the server, where it is not yet ready to handle real HTTP requests. But it can also be useful later, when you want to test what your server does when seeing invalid requests, as these can generally not be created with existing tools.

An alternative to building your own client could be to use the `netcat` tool, which is often called `nc`. To test the echo server, you can run a command like this:
```
echo "Hello echo server" | nc localhost 65432
```

That will send the string "Hello echo server" to the server, and the output should show the string. If the server is not running, or does not respond, you do not get any output from `netcat`.

You can also use `netcat` to send complete requests stored in files, which is an easy way to store all test requests. Beware that since the HTTP protocol is a text protocol, most text editors will "help" you and change the line endings, which makes the requests invalid HTTP requests. There is an example of such a file in [http-get-example.bin](./src/http-get-example.bin) (remember to use the "raw" button to download the file).

Using such a file, you can send it to your socket server using `netcat`:
```
cat http-get-example.bin | nc localhost 65432
```

## Testing with cURL

Once your server is somewhat standard compliant, you can use a tool such as [`cURL`](https://curl.se/) to test various requests. Using the option `-vvv` toggles very verbose output, which explains how `cURL` parses the results, and what data is sent and received. Many anomalies are detected and reported in this mode. An example session would look like this:

```
curl -vvv http://diku.dk
*   Trying 130.226.237.173...
* TCP_NODELAY set
* Connected to diku.dk (130.226.237.173) port 80 (#0)
> GET / HTTP/1.1
> Host: diku.dk
> User-Agent: curl/7.64.1
> Accept: */*
>
< HTTP/1.1 301 Moved Permanently
< Date: Wed, 02 Dec 2020 21:55:18 GMT
< Server: Apache
< Location: https://di.ku.dk/
< Content-Length: 282
< Connection: close
< Content-Type: text/html; charset=iso-8859-1
<
<!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML 2.0//EN">
<html><head>
<title>301 Moved Permanently</title>
</head><body>
<h1>Moved Permanently</h1>
<p>The document has moved <a href="https://di.ku.dk/">here</a>.</p>
<hr>
<address>Apache Server at diku.dk Port 80</address>
</body></html>
* Closing connection 0
```
