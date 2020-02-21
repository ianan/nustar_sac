# NuSTAR Solar Analysis Code - XSPEC Spectral Fitting

Here we have examples of fitting the NuSTAR spectral files in [XSPEC](https://heasarc.gsfc.nasa.gov/xanadu/xspec/) and then plotting the saved results in IDL. So the starting point assumes you already have your spectral file (.pha) and response files (.rmf .arf). Plotting will work with pha processed through [grppha](https://heasarc.gsfc.nasa.gov/ftools/caldb/help/grppha.txt) -- need to add XSPEC example using grppha pha.

### XSPEC code
These can be run line-by-line or via @filename in the XSPEC environment - although the final output parts within "iplot" needs to be done manually.

Have newer scripts that also output "nice" plots as the fitting is done, as well as python example to plot saved results:
* [*thfprb.xcm*](https://github.com/ianan/nustar_sac/blob/master/xspec/thfprb.xcm) - 1 APEC, 1 FPM(A)
* [*thf2prb.xcm*](https://github.com/ianan/nustar_sac/blob/master/xspec/thf2prb.xcm) - 1 APEC, 2 FPM
* [*th2f2prb.xcm*](https://github.com/ianan/nustar_sac/blob/master/xspec/th2f2prb.xcm) - 2 APEC, 2 FPM
* [*th2f2prbgn.xcm*](https://github.com/ianan/nustar_sac/blob/master/xspec/th2f2prbgn.xcm) - 2 APEC, 2 FPM, Gain
* [*example_xspec.ipynb*](https://github.com/ianan/nustar_sac/blob/master/xspec/example_xspec.ipynb) - Python notebook to plot the output from [*thf2prb.xcm*](https://github.com/ianan/nustar_sac/blob/master/xspec/thf2prb.xcm) 

Fit a single APEC thermal model with coronal abundances to one telescope (FPM):
* [*apec1fit_fpm1_cstat.xcm*](https://github.com/ianan/nustar_sac/blob/master/xspec/apec1fit_fpm1_cstat.xcm) - Uses c-stat test, recommended approach (as likely low count/poisson uncertainty bins).
* [*apec1fit_fpm1_cstat_prb.xcm*](https://github.com/ianan/nustar_sac/blob/master/xspec/apec1fit_fpm1_cstat_prb.xcm) - Uses c-stat test, recommended approach (as likely low count/poisson uncertainty bins). Produces output with larger energy bins, but these wider bins are not used in the fit.
* [*apec1fit_fpm1_chi.xcm*](https://github.com/ianan/nustar_sac/blob/master/xspec/apec1fit_fpm1_chi.xcm) - Uses chi2 test, not recommended - just for testing/OSPEX comparison/massive bins.

Fit a single APEC thermal model with coronal abundances jointly to two telescopes (FPMA+FPMB): 
* [*apec1fit_fpm2_cstat.xcm*](https://github.com/ianan/nustar_sac/blob/master/xspec/apec1fit_fpm2_cstat.xcm) - Uses c-stat test, recommended approach (as likely low count/poisson uncertainty bins).
* [*apec1fit_fpm2_cstat_prb.xcm*](https://github.com/ianan/nustar_sac/blob/master/xspec/apec1fit_fpm2_cstat_prb.xcm) - Uses c-stat test, recommended approach (as likely low count/poisson uncertainty bins). Produces output with larger energy bins, but these wider bins are not used in the fit.

Fit a two APEC thermal models with coronal abundances to one telescope (FPM):
* [*apec2fit_fpm1_cstat_prb.xcm*](https://github.com/ianan/nustar_sac/blob/master/xspec/apec2fit_fpm1_cstat_prb.xcm) - Uses c-stat test, recommended approach (as likely low count/poisson uncertainty bins). Produces output with larger energy bins, but these wider bins are not used in the fit.

Fit a single APEC thermal model with coronal abundances to one telescope (FPM), with one fixed APEC thermal component:
* [*apec2fitfix_fpm1_cstat_prb.xcm*](https://github.com/ianan/nustar_sac/blob/master/xspec/apec2fitfix_fpm1_cstat_prb.xcm) - Uses c-stat test, recommended approach (as likely low count/poisson uncertainty bins). Produces output with larger energy bins, but these wider bins are not used in the fit.

### XSPEC Abundance file
* [*feld92a_coronal0.txt*](https://github.com/ianan/nustar_sac/blob/master/xspec/feld92a_coronal0.txt) - Coronal solar abundances from [Feldman 1992](https://doi.org/10.1086/191698), the same ones used in the solar [CHIANTI](http://www.chiantidatabase.org/) database. Default "abund feld" in XSPEC is photospheric not coronal (from different [Feldman 1992](https://doi.org/10.1088/0031-8949/46/3/002) paper).

### SSWIDL plotting codes
The take the output files produced by the XSPEC code (i.e. mod_apec1fit_fpma_chi.txt and mod_apec1fit_fpma_chi.fits) and plots them with SSWIDL.

* [*batch_plot_xspec_fits.pro*](https://github.com/ianan/nustar_sac/blob/master/xspec/batch_plot_xspec_fits.pro) - Examples of using the plotting code.
* [*plot_xspec1apec.pro*](https://github.com/ianan/nustar_sac/blob/master/xspec/plot_xspec1apec.pro) - Plots the single APEC thermal fit to one telescope, i.e. output from [*apec1fit_fpm1_cstat.xcm*](https://github.com/ianan/nustar_sac/blob/master/xspec/apec1fit_fpm1_cstat.xcm).
* [*plot_xspec1apec_ab.pro*](https://github.com/ianan/nustar_sac/blob/master/xspec/plot_xspec1apec_ab.pro) - Plots the single APEC thermal fit jointly to both telescopes, i.e. output from [*apec1fit_fpm2_cstat.xcm*](https://github.com/ianan/nustar_sac/blob/master/xspec/apec1fit_fpm2_cstat.xcm).
* [*plot_xspec2apec.pro*](https://github.com/ianan/nustar_sac/blob/master/xspec/plot_xspec2apec.pro) - Plots the two APEC thermal fit to one telescope, i.e. output from [*apec2fit_fpm1_cstat.xcm*](https://github.com/ianan/nustar_sac/blob/master/xspec/apec2fit_fpm1_cstat.xcm).
* [*plot_xspec2fixapec.pro*](https://github.com/ianan/nustar_sac/blob/master/xspec/plot_xspec2fixapec.pro) - Plots the one APEC thermal fit, and one fixed APEC thermal component, to one telescope, i.e. output from [*apec2fitfix_fpm1_cstat.xcm*](https://github.com/ianan/nustar_sac/blob/master/xspec/apec2fitfix_fpm1_cstat.xcm).

### Utility codes
* [*post_outset.pro*](https://github.com/ianan/nsigh/blob/master/idl/post_outset.pro) - Sets up the eps plots
* [*exp1.pro*](https://github.com/ianan/nsigh/blob/master/idl/exp1.pro) - Function to get exp format in plot labels
