# NuSTAR Solar Analysis Code - SSWIDL

This code works with [SSWIDL](http://www.lmsal.com/solarsoft/ssw_setup.html) to load evt, hk and chu files, filter and produce time profiles and maps, as well as load pha/rmf/arf into [OSPEX](https://hesperia.gsfc.nasa.gov/ssw/packages/spex/doc/ospex_explanation.htm) for spectral fitting.

### Examples
* [*example_nslct.pro*](https://github.com/ianan/nsigh/blob/master/idl/example_nslct.pro) - Load in evt, hk and chu files and plot time profiles of them
* [*example_nsmap.pro*](https://github.com/ianan/nsigh/blob/master/idl/example_nsmap.pro) - Load in an evt, do some filtering, produce and plot some different maps

### NuSTAR Generic Code
* [*load_nsevt.pro*](https://github.com/ianan/nsigh/blob/master/idl/load_nsevt.pro) - Routine to load in a specified event list, evt, file
* [*filter_nsevt.pro*](https://github.com/ianan/nsigh/blob/master/idl/filter_nsevt.pro) - Routine to filter a evt stucture loaded in via  [*load_nsevt.pro*](https://github.com/ianan/nsigh/blob/master/idl/load_nsevt.pro)
* [*load_nshk.pro*](https://github.com/ianan/nsigh/blob/master/idl/load_nshk.pro) - Routine to load in a specific house keeping, hk, file
* [*load_nschu.pro*](https://github.com/ianan/nsigh/blob/master/idl/load_nschu.pro) - Routine to load in a specific camera head unit, chu, file
* [*load_nsspec.pro*](https://github.com/ianan/nsigh/blob/master/idl/load_nsspec.pro) - Routine to load in a given pha/rmf/arf files

### Mapping & Time Profile Code
* [*time_nsevt.pro*](https://github.com/ianan/nsigh/blob/master/idl/time_nsevt.pro) - Make a time profile (counts and rate vs time) from a evt stucture loaded in via  [*load_nsevt.pro*](https://github.com/ianan/nsigh/blob/master/idl/load_nsevt.pro)
* [*map_nsevt.pro*](https://github.com/ianan/nsigh/blob/master/idl/map_nsevt.pro) - Make a SSWIDL map structure from a evt stucture loaded in via  [*load_nsevt.pro*](https://github.com/ianan/nsigh/blob/master/idl/load_nsevt.pro)

### Spectral Fitting Code
* [*ospex_ns_fvth.pro*](https://github.com/ianan/nsigh/blob/master/idl/ospex_ns_fvth.pro) - Loads in a pha/rmf/arf using load_ns_spec.pro and does a single isothermal fit
* [*plotf_ospex_ns_fvth.pro*](https://github.com/ianan/nsigh/blob/master/idl/plotf_ospex_ns_fvth.pro) - Plot the output from ospex_ns_fvth.pro using IDL 8+ plot() function
* [*plotp_ospex_ns_fvth.pro*](https://github.com/ianan/nsigh/blob/master/idl/plotp_ospex_ns_fvth.pro) - Plot the output from ospex_ns_fvth.pro using IDL plot procedure

### Utility Codes
* [*post_outset.pro*](https://github.com/ianan/nsigh/blob/master/idl/post_outset.pro) - Sets up the eps plots
* [*exp1.pro*](https://github.com/ianan/nsigh/blob/master/idl/exp1.pro) - Function to get exp format in plot labels
* [*rmfread.pro*](https://github.com/ianan/nsigh/blob/master/idl/rmfread.pro) - For reading the .rmf file, [originally from](https://lost-contact.mit.edu/afs/physics.wisc.edu/home/craigm/lib/idl/spectral/rmfread.pro)
* [*vcol2arr.pro*](https://github.com/ianan/nsigh/blob/master/idl/vcol2arr.pro) - Used by rmfread.pro, [originally from](https://lost-contact.mit.edu/afs/physics.wisc.edu/home/craigm/lib/idl/util/vcol2arr.pro)
* [*vrmf2arr.pro*](https://github.com/ianan/nsigh/blob/master/idl/vrmf2arr.pro) - Used by rmfread.pro, [originally from](https://lost-contact.mit.edu/afs/physics.wisc.edu/home/craigm/lib/idl/spectral/vrmf2arr.pro)
* [*ns_lct.pro*](https://github.com/ianan/nsigh/blob/master/idl/ns_lct.pro) - Colour table for NuSTAR maps