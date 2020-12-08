# Exercises for computer networks

This page contains the exercise problems related to computer networks for week 4.

**Note:** _The solutions are not hidden on Internet Explorer/Edge_ as it does not support the feature used to hide them. Please use any other browser, or avoid scrolling into the solution.

## Bandwith, round-trip-time, and lantency

The bandwidth and latency are two related, yet very different, concepts and are often a source of confusion.

For the questions below we will assume that signals propagate with **300,000,000 m/s** (approximately the speed of light).

### Latency as a function of distance

Two hosts are communicating over an optic cable and are placed 800 km apart. Calculate the time it takes to for a bit to be transfered from one host to the other.
<details>
  <summary>Open this to see the answer</summary>

  ```
  800 km = 800,000 m
  800,000 / 300,000,000 = 0.002666666667 m/s
  0.002666666667 m/s = 2.66 ms
  ```
  
</details>

### Distance as a function of time

Using the `ping` tool you measure the RTT from your machine to a remote host to be 31 ms. Assuming that the routers add no delays, what is the physical distance to the remote host?

<details>
  <summary>Open this to see the answer</summary>

  ```
  31 ms = 0.031 s
  distance = rtt / 2 = 0.031/2 = 0.0155 s
  300,000,000 * 0,0155 = 4,650,000 m
  4,650,000 m = 4,650 km
  ```
  
</details>

### Latency effects on bandwith

Your network supports sending packages that are at most 1500 bytes long. You measure the RTT to be 20 ms. The machines use a simple protocol that sends a package, and waits for an acknowledgement before sending the next package. How many bytes can you send per second?

<details>
  <summary>Open this to see the answer</summary>

  ```
  20 ms = 0.02 s
  1/0.02 = 50 packages pr. second
  bandwidth = 50 * 1500 = 75,000 b/s, or appx 73.24 KiB/s
  ```
  
</details>

### Latency as a bandwidth limiter

You have leased a dedicated network link between two machines. The seller boasts 100 MiB/s, 2000 byte packages and a 7 ms RTT. You set up the hosts, using a simple protocol that sends a package, and waits for an acknowledgement before sending the next package. What utilization can you report to the seller?

_Note_: To simplify the calculations, the speed here is supplied in **mega bytes**. If you purchase an internet connection, the speed is often reported in **mega bits**, such that 10 Mbits/s is equal to 1.25 MBytes/s.

<details>
  <summary>Open this to see the answer</summary>

  ```
  7 ms = 0.007 s
  1/0.007 = 142.857 packages pr. second
  bandwidth = 142.857 * 2000 = 285,714 b/s, or appx 0.27 MiB/s
  utilization = 0.27/100 = 0.0027, or 0.27%
  ```
  
</details>

### Using in-flight packages to increase utilization

Using the same setup as the previous question, you alter your protocol to support sending 200 packages before waiting for a response. What is your utilization now?

<details>
  <summary>Open this to see the answer</summary>

  ```
  time to send one package with 100 MiB/s = 
    2000 / 100*1024*1024 = 0.019 ms

  time to send 1000 packages with 100 MiB/s = 
    0.019 * 200 = 3.8 ms

  since time to send is less than RTT, we can send
  200 * 2000 bytes pr. 7 ms

  1/0.007 = 142.857 packages pr. second

  bandwidth = 142.857 * 2000 * 200 = 57,142,800 b/s, or appx 54.50 MiB/s
  utilization = 54.5/100 = 0.545, or 54,5%
  same as 0.27% * 200
  ```
  
</details>

### Maximizing the bandwidth

Using the same setup as the previous question, what is the number of packages that you need to send before waiting for a response, in order to use the entire link bandwidth?

<details>
  <summary>Open this to see the answer</summary>

  ```
  time to send one package with 100 MiB/s = 
    2000 / 100*1024*1024 = 0.019 ms

  packages pr 7 ms =
    7 / 0.019 = 368.42 packages

  7ms gives 
    1/0.007 = 142.857 packages pr. second

  bandwidth = 142.857 * 2000 * 368.42 = 105,262,751.88 b/s, or appx 100,38 MiB/s
  (slightly off due to rounding error)
  ```
  
</details>

## URLs and the HTTP protocol

URLs are an integral part of the HTTP protocol, but the URL concept can be applied to other things addressable on the network.

### Disecting a URL

Consider the following URL:
```
afx://example.com/home#work?page=1
```

Name the different parts of the url. You can use a table or list for your response.

<details>
  <summary>Open this to see the answer</summary>

| Text        |  Name          |
|-------------|----------------|
| afx         |  scheme        |
| example.com |  hostname      |
| /home       |  path          |
| #work       |  anchor        |
| ?page=1     |  query string  |

  
</details>

### Constructing a URL

Using the information in the table, construct a single valid URL that contains all the parts.

| Part          | Value            |
|---------------|------------------|
| scheme        | ftp              |
| hostname      | sub.example.com  |
| port          | 731              |
| path          | /work/index.html |
| query string  | ?updated=1       |

<details>
  <summary>Open this to see the answer</summary>

```
ftp://sub.example.com:731/work/index.html?updated=1
```
  
</details>

### Mapping a URL to an HTTP request

Given the following URL, write a valid `HTTP/1.1` request. You can use `\r\n` to indicate a newline:

```
http://example.com/home#work?page=1
```

<details>
  <summary>Open this to see the answer</summary>

```
GET /home#work?page=1 HTTP/1.1\r\n
Host: example.com\r\n
\r\n
```
  
</details>

### Constructing a URL from an HTTP request

Consider the following HTTP request:
```
POST /work/data?fresh=true HTTP/1.1\r\n
Host: inter.example.com\r\n
User-Agent: my-client\r\n
Accept-Language: en\r\n
\r\n
```

Provide a URL that could have lead to this request being sent.

<details>
  <summary>Open this to see the answer</summary>

```
http://inter.example.com/work/data?fresh=true
```
  
</details>

## IP addresses, CIDR and subnets

Grouping networks into subnets is a key concept in IP-based routing.

### Mapping from CIDR to subnet masks

For each of the following CIDR notations, provide the subnet mask:

* 129.168.4.0/24
* 56.32.0.0/16
* 230.178.44.153/23

<details>
  <summary>Open this to see the answer</summary>

* 129.168.4.0/24
  * 255.255.255.0

* 56.32.0.0/16
  * 255.255.0.0

* 230.178.44.153/23
  * Actually invalid CIDR, but the IP has no effect on the mask
  * 255.255.254.0
  
</details>

### Computing the subnet mask from a host count

You have been tasked with setting up a private network. The company currently has 1200 hosts and estimates the buildings maximum capacity to be 10x. Advise the company on what IP range and subnet mask they should use, ensuring that the values can accomodate their maximum capacity.

<details>
  <summary>Open this to see the answer</summary>

The number of hosts required would be 1200 * 10 = 12,000.
Nearest power of 2 is 16,384, or 2^14.
In other words they need 14 unassigned bits.

Suggested IP range in CIDR could be: 192.168.0.0/18
The subnet mask would be: 255.255.192.0
  
</details>

### Checking if an IP is on a given subnet

Checking your machine setup, you see that the machine has the IP address 10.0.0.5 and subnet mask 255.0.0.0. For each of the hosts listed, mark them as local (on the same subnet) or remote (on another subnet):

* 10.0.0.1
* 10.1.0.1
* 10.1.1.1
* 9.0.0.5
* 11.11.0.1

<details>
  <summary>Open this to see the answer</summary>

* 10.0.0.1
  * local
* 10.1.0.1
  * local
* 10.1.1.1
  * local
* 9.0.0.5
  * remote
* 11.11.0.1
  * remote

</details>

### Port numbers

The TCP protocol adds a two port numbers to each message. Describe the purpose of these two ports and explain why they are not in the network layer (IP).

<details>
  <summary>Open this to see the answer</summary>

An IP number is for addressing a host. A port number is for addressing a process. There are two numbers as we address both the sender and recipient process.

The network layer is only responsible for routing packages between hosts, it does not have any need to address processes.

</details>


## Routing IP packages

You are managing a router that uses the longest prefix matching rule. You have inserted the table shown below into the router.

| Prefix        | Link  |
|---------------|-------|
| 128.0.0.0/9   | A     |
| 128.1.0.0/16  | B     |
| 128.2.0.0/24  | C     |
| 128.1.7.0/26  | A     |
| 128.1.7.0/27  | C     |
| other         | D     |

Given each of these addresses, give the port the address is routed to.

* 128.1.0.1
* 128.1.7.2
* 128.128.0.0
* 128.2.1.1
* 128.3.1.1

<details>
  <summary>Open this to see the answer</summary>

* 128.1.0.1
  * B
* 128.1.7.2
  * C
* 128.128.0.0
  * D
* 128.2.1.1
  * C
* 128.3.1.1
  * A

</details>

## DNS lookup

The domain name system is both an application using the internet to function, as well as a key component for making other applications work.

### Looking up an address

Assume that all DNS servers have just rebooted and you are the first person making a lookup (i.e. no responses are cached). You try to resolve the domain `www.diku.dk` from your laptop. Describe what requests and responses would be exchanged.

<details>
  <summary>Open this to see the answer</summary>

1. Laptop sends request for `www.diku.dk` to ISP DNS server
2. ISP DNS sends request for `.dk` to root DNS
3. ISP DNS receives server `1.1.1.1` as the `.dk` server
4. ISP DNS sends request for `diku.dk` to `1.1.1.1`
5. ISP DNS recieves `2.2.2.2` as the `diku.dk` server
6. ISP DNS sends request for `www.diku.dk` to `2.2.2.2`
7. ISP DNS receives response `3.3.3.3` as `www.diku.dk`
8. Laptop receives `3.3.3.3` as `www.diku.dk`

</details>

### Looking up a second address

Assume that the previous request succeeded, and the name servers have cached reponses. Describe the exchanges that occur when attempting to resolve `di.ku.dk`.

<details>
  <summary>Open this to see the answer</summary>

1. Laptop sends request for `di.ku.dk` to ISP DNS server
2. ISP DNS sends request for `ku.dk` to `1.1.1.1` (cached `.dk` server)
5. ISP DNS recieves `4.4.4.4` as the `ku.dk` server
6. ISP DNS sends request for `di.ku.dk` to `4.4.4.4`
7. ISP DNS receives response `5.5.5.5` as `di.ku.dk`
8. Laptop receives `5.5.5.5` as `di.ku.dk`

</details>

