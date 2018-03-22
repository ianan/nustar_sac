# Analysis of solar NuSTAR data with SSWIDL

This should eventually include loading the data, mapping it, time profiles and spectral fitting with [OSPEX](https://hesperia.gsfc.nasa.gov/ssw/packages/spex/doc/ospex_explanation.htm) (part of SSWIDL).

At the moment it is mostly just loading in the spectral file (.pha) and response files (.rmf .arf) and then doing spectral fititng with OSPEX.

### NuSTAR generic code

* [*load_ns_spec.pro*](https://github.com/ianan/nsigh/blob/master/idl/load_ns_spec.pro) - Routine to load in a given .pha file
* [*rmfread.pro*](https://github.com/ianan/nsigh/blob/master/idl/rmfread.pro) - For reading the .rmf file


### Spectral fitting codes

* [*ospex_ns_fvth.pro*](https://github.com/ianan/nsigh/blob/master/idl/post_outset.pro) - Loads in a pha/rmf/arf using load_ns_spec.pro and does a single isothermal fit
* [*plotf_ospex_ns_fvth.pro*](https://github.com/ianan/nsigh/blob/master/idl/post_outset.pro) - Plot the output from ospex_ns_fvth.pro using IDL 8+ plot() function
* [*plotp_ospex_ns_fvth.pro*](https://github.com/ianan/nsigh/blob/master/idl/post_outset.pro) - Plot the output from ospex_ns_fvth.pro using IDL plot procedure

### Mapping codes

* [*.pro*](https://github.com/ianan/nsigh/blob/master/idl/.pro) - 

### Utility codes

* [*post_outset.pro*](https://github.com/ianan/nsigh/blob/master/idl/post_outset.pro) - Sets up the eps plots
* [*exp1.pro*](https://github.com/ianan/nsigh/blob/master/idl/exp1.pro) - Function to get exp format in plot labels
* [*vcol2arr.pro*](https://github.com/ianan/nsigh/blob/master/idl/vcol2arr.pro) - Used by rmfread.pro
* [*vrmf2arr.pro*](https://github.com/ianan/nsigh/blob/master/idl/vrmf2arr.pro) - Used by rmfread.pro
