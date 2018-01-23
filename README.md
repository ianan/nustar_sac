# Analysis code for solar NuSTAR data

This repository contains code for the analysis of NuSTAR solar data, in terms of maps and spectral fitting etc. This is done using the outputs from HEASOFT's nupipeline and nuproducts, mostly in SSWIDL and a bit in XSPEC. At the moment, the code focuses on spectral fitting in OSPEX (SSWIDL) and XSPEC. For python things, there will (eventually) be a few example notebooks here but the main code is all on the [NuSTAR PySolar repo](https://github.com/NuSTAR/nustar_pysolar).

### Requirements

For this to work you are going to need some (if not all) of the following installed:

* [HEASoft with the NuSTAR and XSPEC packages](http://heasarc.nasa.gov/lheasoft/download.html)
* The latest [NuSTAR Calibration Files](http://heasarc.nasa.gov/docs/heasarc/caldb/nustar/)
* [SAOImage DS9](http://ds9.si.edu/site/Home.html)
* [IDL with SSWIDL](http://www.lmsal.com/solarsoft/ssw_setup.html)

### Spectral fitting

We are using two different approaches for the spectral fitting at the moment, with each having pros and cons:
* [OSPEX](https://hesperia.gsfc.nasa.gov/ssw/packages/spex/doc/ospex_explanation.htm) is the X-ray spectral fitting package in SSWIDL designed for RHESSI data, and now works with a range of other high energy solar spectra. It's familiar for solar X-ray folk, tried-and-tested, well documented, works from a gui or commandline and contains many models for fitting solar spectra. Unfortunately it can't do joint simulatenous fitting of more than one telescope (so with NuSTAR only FPMA or FPMB, not both), is in IDL (licences/expensive) and the best fit is based on minimising chi-squared, assuming gaussin uncertainity on the data (so it doesn't work well with energy bins with low counts, say <10)
* [XSPEC](https://heasarc.gsfc.nasa.gov/xanadu/xspec/) is the X-ray spectral fitting package that comes as part of HEASOFT and designed for a variety of high energy astrophysics data. It's familiar for astrophysics X-ray folk, tried-and-tested, well documented, free software, contains many models, can fit more than one spectra simulatenously, and has a variety of approaches to finding the best fit (including ones that work with Gaussian and/or Poission data). Unfortunately it only has a few useful models for solar spectra (but even then, the thermal uses APEC instead of solar's more commonly used CHIANTI, and the solar abundances are photospheric not coronal etc) and the interface/plotting can be a bit "tricky"/limited (end up loading into IDL or Python to make plots, separate [PyXspec](https://heasarc.gsfc.nasa.gov/xanadu/xspec/python/html/index.html) exists and might help but not tried it)

The code in this repo assumes the input data is a .pha, .rmf and .arf of your NuSTAR region of interest and these are then loaded, fitted and plotted in either SSWIDL/OSPEX or XSPEC. To get these you already need to have the NuSTAR data properly processed - details of how to do this are available [here on the overview page](https://github.com/ianan/nsigh_all) as well as within the [NuSTAR PySolar repo](https://github.com/NuSTAR/nustar_pysolar). Once you have the data it is recommended to load the .evt file of interest into [SAOImage DS9](http://ds9.si.edu/site/Home.html), this should be the file in origial RA and dec coordinates, not sun centred. Then in DS9 you can [create](http://ds9.si.edu/doc/ref/region.html) the .reg file of the particular region of interest. Now with this .reg file, you can run nuproducts in your NuSTAR data event_cl/ directory to get the .pha, .rmf and .arf files, via something like 
>nuproducts indir=./ instrument=FPMA steminputs=nu20110114001 outdir=./testxout extended=yes runmkarf=yes runmkrmf=yes infile=nu20110114001A06_chu23_S_cl_grade0.evt bkgextract=no srcregionfile=regfile.reg attfile=./nu20110114001_att.fits hkfile=./nu20110114001A_fpm.hk
