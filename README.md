# Spectral fitting of solar NuSTAR data

This repositry shows example of fitting NuSTAR solar spectra, using either XSPEC (as part of HEASoft) or OSPEX (part of SSWIDL). In both cases the starting point is a spectrum (\*.pha) and response files (\*.arf, \*.rmf) which you will have to create via nuproducts separately (more info below).

### Requirements

For this to work you are going to need some (if not all) of the following installed:

* [HEASoft with the NuSTAR and XSPEC packages](http://heasarc.nasa.gov/lheasoft/download.html)
* The latest [NuSTAR Calibration Files] (http://heasarc.nasa.gov/docs/heasarc/caldb/nustar/)
* [SAOImage DS9](http://ds9.si.edu/site/Home.html)
* [IDL with SSWIDL](http://www.lmsal.com/solarsoft/ssw_setup.html)

### Creating NuSTAR spectral files
