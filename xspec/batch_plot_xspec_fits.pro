pro batch_plot_xspec_fits

  ; Some code to plot the different XSPEC fit examples
  ;
  ;
  ; 22-Jan-2018 IGH
  ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  plot_xspec1apec,fname='mod_apec1fit_fpma_chi',titin='FPMA chi2',ylim=[0.5,2e3]
  plot_xspec1apec,fname='mod_apec1fit_fpma_cstat',titin='FPMA C-stat',ylim=[0.5,2e3]
  plot_xspec1apec,fname='mod_apec1fit_fpma_cstat_prb',titin='FPMA C-stat',ylim=[0.5,2e3]
  
  plot_xspec1apec_ab,fname='mod_apec1fit_fpmab_cstat',titin='FPMA & FPMB C-stat',ylim=[0.1,2e3]
  plot_xspec1apec_ab,fname='mod_apec1fit_fpmab_cstat_prb',titin='FPMA & FPMB C-stat',ylim=[0.1,2e3]

  stop
end