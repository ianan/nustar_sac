# NuSTAR Solar Analysis Code - XSPEC Spectral Fitting

Here we have examples of fitting the NuSTAR spectral files in [XSPEC](https://heasarc.gsfc.nasa.gov/xanadu/xspec/) and then plotting the saved results in IDL. So the starting point assumes you already have your spectral file (.pha) and response files (.rmf .arf).

### XSPEC code

These can be run line-by-line or via @filename in the XSPEC environment - although the final output parts within "iplot" needs to be done manually.

Fit a single APEC thermal model with coronal abunances to one telescope (FPM):
* [*apec1fit_fpm1_cstat.xcm*](https://github.com/ianan/nustar_sac/blob/master/xspec/apec1fit_fpm1_cstat.xcm) - Uses c-stat test, recommended approach (as likely low count/poisson uncertainty bins).
* [*apec1fit_fpm1_cstat_pbr.xcm*](https://github.com/ianan/nustar_sac/blob/master/xspec/apec1fit_fpm1_cstat_pbr.xcm) - Uses c-stat test, recommended approach (as likely low count/poisson uncertainty bins). Produces output with larger energy bins, but these wider bins are not used in the fit.
* [*apec1fit_fpm1_chi.xcm*](https://github.com/ianan/nustar_sac/blob/master/xspec/apec1fit_fpm1_chi.xcm) - Uses chi2 test, not recommended - just for testing/OSPEX comparison/massive bins.

Fit a single APEC thermal model with coronal abunances to two telescopes (FPMs) simultaneously: 
* [*apec1fit_fpm2_cstat.xcm*](https://github.com/ianan/nustar_sac/blob/master/xspec/apec1fit_fpm2_cstat.xcm) - Uses c-stat test, recommended approach (as likely low count/poisson uncertainty bins).
* [*apec1fit_fpm2_cstat_pbr.xcm*](https://github.com/ianan/nustar_sac/blob/master/xspec/apec1fit_fpm2_cstat_pbr.xcm) - Uses c-stat test, recommended approach (as likely low count/poisson uncertainty bins). Produces output with larger energy bins, but these wider bins are not used in the fit.

### XSPEC Abundance file
* [*feld92a_coronal0.txt*](https://github.com/ianan/nustar_sac/blob/master/xspec/feld92a_coronal0.txt) - Coronal solar abundances from [Feldman 1992](https://doi.org/10.1086/191698), the same ones used in the solar [CHIANTI](http://www.chiantidatabase.org/) database. Default "abund feld" in XSPEC is photospheric not coronal (from different [Feldman 1992](https://doi.org/10.1088/0031-8949/46/3/002) paper).

### SSWIDL plotting codes

The take the output files produced by the XSPEC code

### Utility codes

* [*post_outset.pro*](https://github.com/ianan/nsigh/blob/master/idl/post_outset.pro) - Sets up the eps plots
* [*exp1.pro*](https://github.com/ianan/nsigh/blob/master/idl/exp1.pro) - Function to get exp format in plot labels
