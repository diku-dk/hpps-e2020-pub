# Working with accellerators

The prerequisite for this lab is:
  * [Video 12](https://sid.erda.dk/share_redirect/bGBNXHzM4g/12%20-%20Accelerators.mp4) ([slides for video 12](https://github.com/diku-dk/hpps-e2020-pub/raw/master/material/6-l-2/12%20-%20Accelerators.pdf))
  
# Working with OpenCL

While OpenCL is originally designed to work with accelerators, the model can also work with multi-core, but rarely gives a great speedup.

However, we can use this to experiment with the OpenCL programming model, even if we do not have an OpenCL compatible graphics card.

TBD

# Working with VHDL

To get started with VHDL and hardware based accellerators you can try to implement a working [ripple-carry adder](https://en.wikipedia.org/wiki/Adder_(electronics)#Ripple-carry_adder), as we presented in the first video.

However, the tools are a bit difficult to get working, so you might want to either use the [GHDL Docker image](https://hub.docker.com/r/ghdl/ghdl) or try it on [ERDA/DAG](https://github.com/diku-dk/hpps-e2020-pub/blob/master/ERDA.md#data-analysis-gateway-dag).

For ERDA, we have prepared all the tools such that you can set up a working environment quickly. Once you have the Jupyter start page on ERDA/DAG, use the console, and run these commands:

```bash
cd ~/work
curl -OL 'https://sid.erda.dk/share_redirect/GkfXNG21i1/ghdl.tar.bz2'
tar -xvf ghdl.tar.bz2
cd ghdl
```

Inside the folder you can now test the GHDL installation, with something like:
```bash
./ghdl --version
```

TBD
