# NuSTAR Solar Analysis Code - XSPEC Spectral Fitting

Here we have examples of fitting the NuSTAR spectral files in [XSPEC](https://heasarc.gsfc.nasa.gov/xanadu/xspec/) and then plotting the saved results in IDL.

So the starting point assumes you already have your spectral file (.pha) and response files (.rmf .arf).

### XSPEC code

These can be run line-by-line or via @filename in the XSPEC environment - although the final output parts within iplot needs to be done manually.

* [*load_ns_spec.pro*](https://github.com/ianan/nsigh/blob/master/idl/load_ns_spec.pro) - Routine to load in a given pha/rmf/arf files
* [*rmfread.pro*](https://github.com/ianan/nsigh/blob/master/idl/rmfread.pro) - For reading the .rmf file, [originally from](https://lost-contact.mit.edu/afs/physics.wisc.edu/home/craigm/lib/idl/spectral/rmfread.pro)

### SSWIDL plotting codes

The take the output files produced by the XSPEC code

### Utility codes

* [*post_outset.pro*](https://github.com/ianan/nsigh/blob/master/idl/post_outset.pro) - Sets up the eps plots
* [*exp1.pro*](https://github.com/ianan/nsigh/blob/master/idl/exp1.pro) - Function to get exp format in plot labels
