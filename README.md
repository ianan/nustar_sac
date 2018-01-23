# Analysis code for solar NuSTAR data

This repository shows code for the analysis of NuSTAR solar data, in terms of maps and spectral fitting etc. This is done using the outputs from HEASOFT's nupipeline and nuproducts, mostly in SSWIDL and a bit in XSPEC. At the moment, the code mostly is on spectral fitting in OSPEX (SSWIDL) and XSPEC.

For python things, there will (eventually) be a few example notebooks here but the main code is all on the [NuSTAR PySolar repo](https://github.com/NuSTAR/nustar_pysolar).

### Requirements

For this to work you are going to need some (if not all) of the following installed:

* [HEASoft with the NuSTAR and XSPEC packages](http://heasarc.nasa.gov/lheasoft/download.html)
* The latest [NuSTAR Calibration Files](http://heasarc.nasa.gov/docs/heasarc/caldb/nustar/)
* [SAOImage DS9](http://ds9.si.edu/site/Home.html)
* [IDL with SSWIDL](http://www.lmsal.com/solarsoft/ssw_setup.html)

### Spectral fitting

We are using two different approaches for the spectral fitting at the moment, with each having pros and cons:
* [OSPEX](https://hesperia.gsfc.nasa.gov/ssw/packages/spex/doc/ospex_explanation.htm) is the X-ray spectral fitting package in SSWIDL designed for RHESSI data, and now works with a range of other high energy solar spectra. It's familiar for solar X-ray folk, tried-and-tested, well documented, works from a gui or commandline and contains many models for fitting solar spectra. Unfortunately it can't do joint simulatenous fitting of more than one telescope (so with NuSTAR only FPMA or FPMB, not both), is in IDL (licences/expensive) and the best fit is based on minimising chi-squared, assuming gaussin uncertainity on the data (so it doesn't work well with energy bins with low counts, say <10)
* [XSPEC](https://heasarc.gsfc.nasa.gov/xanadu/xspec/) is the X-ray spectral fitting package that comes as part of HEASOFT and designed for a variety of high energy astrophysics data. It's familiar for astrophysics X-ray folk, tried-and-tested, well documented, free software, contains many models, can fit more than one spectra simulatenously, and has a variety of appraoches to finding the best fit (including ones that work with Gaussian and/or Poission data, and many more). Unfortunately it only has a few useful models for solar spectra (but even thermal uses APEC instead of solar's more commonly used CHIANTI, and the solar abundances are photospheric not coronal etc) and the interface/plotting can be a bit "tricky"/limited (end up loading into IDL or Python to make plots, separate [PyXspec](https://heasarc.gsfc.nasa.gov/xanadu/xspec/python/html/index.html) exists and might help but not tried it)

The code in this repo assumes having the input data is a .pha, .rmf and .arf of your NuSTAR region of interest and these are then be loaded, fitted then plotted in either OSPEX or XSPEC.
