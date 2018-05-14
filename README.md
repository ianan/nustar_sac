# NuSTAR SAC - NuSTAR Solar Analysis Code

This repo contains code for the analysis of NuSTAR solar data. This is done using the outputs from HEASOFT/NuSTARDAS's nupipeline and nuproducts, mostly in SSWIDL, a bit in XSPEC and a tiny bit in Python. 

If you just want an overview of the obervations look on the [nsovr GitHub page](http://ianan.github.io/nsovr/).

### Requirements

For this to work you are going to need some (if not all) of the following installed:

* [HEASoft with the NuSTAR and XSPEC packages](http://heasarc.nasa.gov/lheasoft/download.html)
* The latest [NuSTAR Calibration Files](http://heasarc.nasa.gov/docs/heasarc/caldb/nustar/)
* [SAOImage DS9](http://ds9.si.edu/site/Home.html)
* [IDL with SSWIDL](http://www.lmsal.com/solarsoft/ssw_setup.html)

### Images/Maps and Time Profiles

The IDL code, using SSWIDL, can take an evt file produced by the nupipeline and filter for certain conditions, make time profiles of the counts (as well as livetimes and CHU combinations), and make map sturctures that work with the SSWIDL [mapping software](https://hesperia.gsfc.nasa.gov/rhessidatacenter/complementary_data/maps/maps.html).

### Python

In this repo are example jupyter notebooks for using Python  but the proper code for this is on the [NuSTAR PySolar repo](https://github.com/NuSTAR/nustar_pysolar).

### Spectral Fitting

We are using two different approaches for the spectral fitting at the moment, with each having pros and cons:
* [SSWIDL/OSPEX](https://hesperia.gsfc.nasa.gov/ssw/packages/spex/doc/ospex_explanation.htm) is the X-ray spectral fitting package in SSWIDL initially designed for RHESSI data, and works with a range of other high energy solar spectra. It's familiar for solar X-ray folk, tried-and-tested, well documented, works from a gui or command-line and contains many models for fitting solar spectra. Unfortunately it can't do joint simulatenous fitting of more than one telescope (so with NuSTAR only FPMA or FPMB, not both), is in IDL (licences/expensive) and (at the moment) the best fit is based on minimising chi-squared so doesn't work well with energy bins with low counts (<10), as assuming gaussin uncertainity on the data.
* [XSPEC](https://heasarc.gsfc.nasa.gov/xanadu/xspec/) is the X-ray spectral fitting package that comes as part of HEASOFT and designed for a variety of high energy astrophysics data. It's familiar for astrophysics X-ray folk, tried-and-tested, well documented, free software, contains many models, can fit more than one spectra simulatenously, and has a variety of approaches to finding the best fit (including ones that work with Gaussian and/or Poission data). Unfortunately it only has a few useful models for solar spectra (but even then, the thermal uses APEC instead of solar's more commonly used CHIANTI, and the solar abundances are photospheric not coronal etc) and the interface/plotting can be a bit "tricky"/limited (end up loading into IDL or Python to make plots). For the latter, the separate [PyXspec](https://heasarc.gsfc.nasa.gov/xanadu/xspec/python/html/index.html) exists and might help, but not tried it.

The spectral code in this repo assumes the input data is a .pha, .rmf and .arf of your NuSTAR region of interest and these are then loaded, fitted and plotted in either SSWIDL/OSPEX or XSPEC. To get these you already need to have the NuSTAR data properly processed - details of how to do this are available on the [NuSTAR PySolar repo](https://github.com/NuSTAR/nustar_pysolar), and older details are also [here on the overview page](https://github.com/ianan/nsigh_all). Once you have processed the data it is recommended to load the .evt file of interest into [SAOImage DS9](http://ds9.si.edu/site/Home.html), this should be the file in origial RA and Dec coordinates, not sun centred. Then in DS9 you can [create](http://ds9.si.edu/doc/ref/region.html) the .reg file of the particular region of interest. Now with this .reg file, you can run nuproducts in your NuSTAR data event_cl/ directory to get the .pha, .rmf and .arf files, via something like 
>nuproducts indir=./ instrument=FPMA steminputs=nu20110114001 outdir=./testxout extended=no runmkarf=yes runmkrmf=yes infile=nu20110114001A06_chu23_S_cl_grade0.evt bkgextract=no srcregionfile=regfile.reg attfile=./nu20110114001_att.fits hkfile=./nu20110114001A_fpm.hk
