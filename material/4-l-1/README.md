# Lab: Investigating the global network

While the internet that we use daily is created to be usable without understanding the inner workings, we can still peak into it and examine how it works.

The prerequisite for this lab is:
  * [Video 7](https://sid.erda.dk/share_redirect/h2afbmlKRA/7%20-%20Lecture.mp4)([slides for video 7](https://github.com/diku-dk/hpps-e2020-pub/raw/master/material/4-l-1/7%20-%20Lecture.pdf))

## Required tools

To peak around the network internals, we need a few network tools. If you are using WSL or Debian/Ubuntu, you can install them needed `traceroute` tool with:

```sh
sudo apt install traceroute
```

If you are using macOS, the tools are installed by default. On Windows (without WSL) you can use the `tracert` tool.

## Warning!

The tools use publicly available services that have entirely legitimate uses for professionals working with internet infrastructure, but some organizations consider probing their networks as a hostile activity. 

Please take this into consideration and try to keep your experiements running for only a short period.

## The ping command

One of the key concepts in networks is the latency, often measured as round-trip-time. When attempting to estimate how well an application can perform on a network, we need to ensure that we can keep the CPU busy for long enough to get a response from a remote host. The primary commandline tool for measuring the round-trip-time is called `ping`. The tool works on the network layer, similar to TCP and UDP, by sending [ICMP](https://en.wikipedia.org/wiki/Internet_Control_Message_Protocol) packages with an "echo request" code. The remote host is often configured to respond with a "echo response" such that the [`ping`](https://en.wikipedia.org/wiki/Ping_(networking_utility)) tool can measure the time between sending and receiving, giving the round-trip-time. In a non-scientific context, the round-trip-time is often somewhat incorrectly referenced as the "ping time".

The first assignment is to try the `ping` tool on some different hosts.

The basic usage of `ping` is simply giving it the hostname (note: it does not like a url, nor a port, as the protocol is not using TCP/UDP):
```
ping diku.dk
```
_Note:_ press CTRL+C if the program does not stop by itself.

On my machine, I get results such as this:
```
PING diku.dk (130.226.237.173): 56 data bytes
64 bytes from 130.226.237.173: icmp_seq=0 ttl=246 time=15.105 ms
64 bytes from 130.226.237.173: icmp_seq=1 ttl=246 time=16.514 ms
64 bytes from 130.226.237.173: icmp_seq=2 ttl=246 time=13.497 ms
64 bytes from 130.226.237.173: icmp_seq=3 ttl=246 time=21.275 ms
64 bytes from 130.226.237.173: icmp_seq=4 ttl=246 time=20.043 ms
^C
--- diku.dk ping statistics ---
5 packets transmitted, 5 packets received, 0.0% packet loss
round-trip min/avg/max/stddev = 13.497/17.287/21.275/2.940 ms
```

After trying the tool, consider the results and apply what you know about the network to explain the variations in time.

To see the effects of physical distance, you can try with these hosts as well (be gentle!):
```
google.com
facebook.com
whitehouse.gov
pinta.it
e-akihabara.jp
```

Observe the RTT for each of these, and also make a note of how the RTT relates to the time-to-live (TTL) value. The `icmp_seq` is a sequence number set by `ping` to avoid measuring a previously transmitted (and delayed) package as a (very fast) response.

## Exploring network routes

In a package, the TTL flag is decremented by each router it touches, such that a package will never stay forever in a misconfigured network. Most routers on the internet are well-behaving and will respond back to the sender if they process a package with `TTL=0`. This is exploited by the `traceroute` tool, which will send packages with `TTL=1`, report who returned it, then set `TTL=2` and so on, thus giving a map of which routers the package has touched.

The tool is invoked similarly to `ping` with just the target domain name:
```
traceroute diku.dk
```

If you have trouble getting the tool to work, you can also use a service such as [Uptrends Treaceroute](https://www.uptrends.com/tools/traceroute) that allows you to try the same destination from different hosts worldwide.

From my test location, I get the following results:
```
traceroute to diku.dk (130.226.237.173), 64 hops max, 52 byte packets
 1  192.168.1.1 (192.168.1.1)  2.546 ms  1.243 ms  1.206 ms
 2  10.116.26.1 (10.116.26.1)  21.556 ms  14.451 ms  17.731 ms
 3  cpe.vlanif200.kh2nqa1.dk.customer.tdc.net (176.22.62.106)  13.318 ms  12.551 ms  14.183 ms
 4  ae0-0.alb2nqp8.dk.ip.tdc.net (83.88.19.117)  14.336 ms  14.613 ms  12.953 ms
 5  dk-bal.nordu.net (109.105.98.232)  13.265 ms  12.331 ms  12.254 ms
 6  dk-uni.nordu.net (109.105.97.136)  12.266 ms
    dk-bal2.nordu.net (109.105.97.49)  12.286 ms  14.500 ms
 7  lgb.core.fsknet.dk (109.105.102.159)  12.473 ms
    ore.core.fsknet.dk (109.105.102.161)  18.759 ms
    lgb.core.fsknet.dk (109.105.102.159)  14.298 ms
 8  ore.core.fsknet.dk (109.105.102.161)  13.099 ms
    100g-lgb.ore.core.fsknet.dk (130.225.245.154)  13.841 ms
    192.38.111.154 (192.38.111.154)  14.098 ms
 9  192.38.111.154 (192.38.111.154)  15.590 ms  14.567 ms *
10  * * *
11  * * *
12  * * *
13  * * *
14  * * *
15  * * *
16  * * *
^C
```

You can see the initial 9 hosts were happy to report that they discarded the package, but when we go further into the DIKU network the routers are configured to not respond to the requests. I eventually pressed CTRL+C to get it to stop. You can also see that the first hop is my router (with an internal IP address). From the latency, you can also deduce that I am probably connected using WiFi.

If you have access to an ethernet cable, try locating the same host with both WiFi and ethernet. And maybe try the same using your phone and see what you get.

I tried from the same start location to `google.com`:
```
traceroute to google.com (172.217.20.46), 64 hops max, 52 byte packets
 1  192.168.1.1 (192.168.1.1)  2.600 ms  1.283 ms  1.508 ms
 2  10.116.26.1 (10.116.26.1)  19.470 ms  17.966 ms  17.934 ms
 3  cpe.vlanif200.kh2nqa1.dk.customer.tdc.net (176.22.62.106)  12.564 ms  10.973 ms  12.213 ms
 4  ae1-0.stkm2nqp7.se.ip.tdc.net (83.88.2.131)  21.401 ms  24.237 ms  23.910 ms
 5  72.14.214.162 (72.14.214.162)  24.438 ms  23.671 ms
    peer-as15169.stkm2nqp7.se.ip.tdc.net (128.76.59.41)  24.098 ms
 6  * * *
 7  108.170.253.177 (108.170.253.177)  30.035 ms
    209.85.246.26 (209.85.246.26)  25.786 ms
    108.170.253.161 (108.170.253.161)  23.267 ms
 8  108.170.253.165 (108.170.253.165)  25.957 ms  23.050 ms  21.886 ms
 9  par10s09-in-f46.1e100.net (172.217.20.46)  22.277 ms
    108.170.254.33 (108.170.254.33)  23.426 ms  23.946 ms
```

In this example you can see that router-hop #6 did not respond, but the hosts afterwards did. 

We can also investigate that from #3 to #4 we get an additional 10ms latency. While there is no agreed upon naming convention, we can guess that #3 is a TDC (now Yousee) owned router in Denmark. We can also make a guess that #4 is also TDC owned router, but in Sweden, explaining the latency we see.

Try the `traceroute` tool with some different hosts (be gentle!).

## Domain names
As you know from the video material, a host on the internet uses an IP address, not a domain name. To make it simpler to use `ping` and `traceroute` they automatically do an IP lookup, and if you review the outputs, you can see that it also reports what IP address it has used.

The basic tool for querying a domain name is the `nslookup` tool. It will query a nameserver for a hostname, and return an IP address, used like this:
```
nslookup google.com
```

If you want to use another nameserver to perform the lookup, you can specify this as a second argument. An easy-to-remember nameserver is run by google at the IP `8.8.8.8`, and you can use it like this:
```
nslookup google.com 8.8.8.8
```

Try looking up the IP address of a few websites. Since this query is hitting a nameserver, which is configured to handle extreme loads, you can be less careful for these queries. If you prefer an online tool, there are several [NSLookup](https://network-tools.com/nslookup/) services

When I try this on a system within UCPH, I get these results:

```
> nslookup google.com
Server:		130.225.212.46
Address:	130.225.212.46#53

Non-authoritative answer:
Name:	google.com
Address: 216.58.207.238
Name:	google.com
Address: 2a00:1450:400f:80c::200e

> nslookup google.com 8.8.8.8
Server:		8.8.8.8
Address:	8.8.8.8#53

Non-authoritative answer:
Name:	google.com
Address: 216.58.211.14
Name:	google.com
Address: 2a00:1450:400f:808::200e

> nslookup google.com 8.8.8.8
Server:		8.8.8.8
Address:	8.8.8.8#53

Non-authoritative answer:
Name:	google.com
Address: 142.250.74.14
Name:	google.com
Address: 2a00:1450:400f:808::200e
```

First, not that the first query and the two later ones return different answers. We can see two IP addresses returned for each, namely an IPv4 and an IPv6. If your system is not configured for IPv6 you will not see that entry.

But why do we get different answers for each query?

The answer is that a domain name can map to multiple IPs, which is used if you run a service that cannot fit on a single machine. In the case og Google and most other large participants, the IPs route into a datacenter. The DNS systems are configured such that they will return IPs that are geographically closest to the client. As a side note, multiple hostnames can also point to the same IP, so we get a full many-to-many system.

## Getting more DNS information

To get all records for a given host, you can try the `dig` tool and ask for `any` records. The results can be complete, but can also be only a subset of the actual data, depending on what the nameserver deems appropriate.

An example query can be:
```
dig google.com any
```

And a response from one system looks like this:
```
; <<>> DiG 9.10.6 <<>> any google.com
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 23163
;; flags: qr rd ra; QUERY: 1, ANSWER: 26, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 512
;; QUESTION SECTION:
;google.com.			IN	ANY

;; ANSWER SECTION:
google.com.		267	IN	A	209.85.233.113
google.com.		267	IN	A	209.85.233.102
google.com.		267	IN	A	209.85.233.139
google.com.		267	IN	A	209.85.233.138
google.com.		267	IN	A	209.85.233.101
google.com.		267	IN	A	209.85.233.100
google.com.		267	IN	AAAA	2a00:1450:4010:c03::71
google.com.		267	IN	AAAA	2a00:1450:4010:c03::66
google.com.		267	IN	AAAA	2a00:1450:4010:c03::8a
google.com.		267	IN	AAAA	2a00:1450:4010:c03::65
google.com.		21567	IN	NS	ns2.google.com.
google.com.		267	IN	TXT	"docusign=1b0a6754-49b1-4db5-8540-d2c12664b289"
google.com.		567	IN	MX	40 alt3.aspmx.l.google.com.
google.com.		267	IN	TXT	"docusign=05958488-4752-4ef2-95eb-aa7ba8a3bd0e"
google.com.		21567	IN	NS	ns1.google.com.
google.com.		567	IN	MX	20 alt1.aspmx.l.google.com.
google.com.		3567	IN	TXT	"globalsign-smime-dv=CDYX+XFHUw2wml6/Gb8+59BsH31KzUr6c1l2BPvqKX8="
google.com.		27	IN	SOA	ns1.google.com. dns-admin.google.com. 344777510 900 900 1800 60
google.com.		3567	IN	TXT	"v=spf1 include:_spf.google.com ~all"
google.com.		567	IN	MX	30 alt2.aspmx.l.google.com.
google.com.		21567	IN	NS	ns3.google.com.
google.com.		567	IN	MX	50 alt4.aspmx.l.google.com.
google.com.		21567	IN	NS	ns4.google.com.
google.com.		21567	IN	CAA	0 issue "pki.goog"
google.com.		3567	IN	TXT	"facebook-domain-verification=22rm551cu4k0ab0bxsw536tlds4h95"
google.com.		567	IN	MX	10 aspmx.l.google.com.

;; Query time: 39 msec
;; SERVER: 8.8.8.8#53(8.8.8.8)
;; WHEN: Tue Dec 01 15:07:50 CET 2020
;; MSG SIZE  rcvd: 813
```

The different records are used for different services. The `A` and `AAAA` records are the IPv4 and IPv6 records, the `MX` are the email exchange (mail servers for email _to_ google.com). There are [many other DNS record types](https://en.wikipedia.org/wiki/List_of_DNS_record_types).

 The `TXT` records are for "free text", but commonly used to implement features that are not yet supported by all name servers, such as the [Sender Policy Framework, SPF](https://tools.ietf.org/html/rfc7208).

 Try using `dig` to query one or more sites and see what you can find. If you query `diku.dk` you will notice that it has a `AFSDB` entry, which is not seen on many other domains.

If you do not have `dig` on your system you can try an [online NSLookup tool](https://network-tools.com/nslookup) and extract the same information. Beware that the information you get dependes on where you query from.

## Locating a host based on IP

There is no real map of where each IP address is located in the world, but many ISP report this information, as it is useful for trafic optimization. 

You can use an IP location tool to figure out where in the world a given IP is located, [but do note that the IP lookup information is not accurate and can be outdated](https://www.theguardian.com/technology/2016/aug/09/maxmind-mapping-lawsuit-kansas-farm-ip-address).

Try to visit an [IP location tool](https://whatismyipaddress.com) and perform a lookup. 

Once you enter the website, you will notice that the reported IP address is _not_ the same as the first hop from the `traceroute` tool above. The reason for this is a [NAT](https://en.wikipedia.org/wiki/Network_address_translation) enabled router that hides your IP on the internal network.

Try to go back and look at one of your `traceroute` results, and try to locate some of the routers using their reported IPs.

## A final word on DNS

You might have noticed that some of the traces you tried report hostnames, while others report just an IP. The cause of this is an feature called [Reverse DNS](https://en.wikipedia.org/wiki/Reverse_DNS_lookup) which assigns a single hostname to an IP. This breaks with the many-to-many approach used elsewhere in the DNS system, but has a few special use cases.

## Going deeper (optional)

A tool for investigating all the details involved in network trafic is a tool such as [Wireshark](https://www.wireshark.org/). It is a bit intrusive to install, so I would only recomend it if you are curious to see what happens. Wireshark is capable of reading every network package handled by your network card, and allows you to investigate features such as TCP sequence numbers, package errors, retransmits, ping messages and many more.

If you want to get a taste of what these raw packet tools can display, there is a brief [Wireshark guide with pictures](https://www.howtogeek.com/104278/how-to-use-wireshark-to-capture-filter-and-inspect-packets/).
