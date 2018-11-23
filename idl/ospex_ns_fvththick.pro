pro ospex_ns_fvththick,fiter=fiter, midfiter=midfiter,noplot=noplot, uncert_val=uncert_val,$
  dir=dir, fname=fname,fout=fout,de=de,spcer=spcer,pltxr=pltxr,pltyr=pltyr,$
  loweclim=loweclim

  ; Do a thermal + thick-target (non-thermal) spectral fit to some NuSTAR pha, rmf and arf data
  ; For more info on OSPEX see http://hesperia.gsfc.nasa.gov/ssw/packages/spex/doc/ospex_explanation.htm
  ;
  ; WARNING - THIS IS AN EXAMPLE OF HOW TO DO THE VTH+THICK FIT BUT WILL PROBABLY NEED TWEAKING
  ; WITH YOUR DATA AND OF COURSE MAY NOT BE THE RIGHT MODEL AT ALL TO FIT TO YOUR SPECTRUM !!!
  ;
  ; options
  ;
  ;   fiter       -  Energy range to fit over (default is 2.5 to last bin with >10 counts)
  ;   midfiter    -  Energy range to fit up to on first thermal fit (default 4, should be <fiter[0])
  ;   noplot      -  Don't produce a plot
  ;   uncert_val  -  Systematic error to add to ospex via spex_uncert=uncert_val
  ;   dir         -  Where are your pha, rmf and arf files?
  ;   fname       -  What's the name/id of your pha, rmf and arf file?
  ;   fout        -  Name for the output file, default is just the fname id
  ;   spcer       -  Energy range for the loaded data (default 1.6 to 10 keV)
  ;   de          -  Energy binning for loaded data (dedault is original 0.04 keV)
  ;   pltxr       -  x-range for output plot
  ;   pltyr       -  y-range for output plot
  ;   loweclim    -  Min fit value limit for the low energy cutoff (default E_c=5keV)
  ;
  ; 23-Nov-2018 IGH   Started, based on ospex_ns_fvth2.pro
  ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  ; Load in the spectrum files - IGH defaults, you should obviously change
  if (n_elements(dir) ne 1) then dir='~/OneDrive - University of Glasgow/work/ns_data/simple_idl/testxout/'
  if (n_elements(fname) ne 1) then fname='nu20110114001A06_chu23_S_cl_grade0_sr'
  if (n_elements(fout) ne 1) then fout=fname
  if (n_elements(spcer) ne 2) then spcer=[1.6,10]
  if (n_elements(loweclim) ne 1) then loweclim=5.0
  if (n_elements(midfiter) ne 1) then midfiter=3.0

  if (n_elements(de) eq 1) then load_nsspec, dir+fname,specstr, spcer=spcer,de=de $
  else load_nsspec, dir+fname,specstr, spcer=spcer

  ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ; Get the parms ready for OSPEX
  counts=specstr.counts
  nbins=n_elements(counts)
  enge=specstr.enge
  mide=specstr.engm
  livetime=specstr.livetime
  ontime=specstr.ontime
  t1=specstr.tstrt
  t2=specstr.tstop
  dE=get_edges(enge,/width)
  fpmid=specstr.fpmid

  ; Need SRM which is RMF*ARF [counts per photons * cm^2]
  ; Also OSPEX expects counts per photons/keV so need to divide by dE
  rsp=fltarr(nbins,nbins)
  for rr = 0, nbins-1 do rsp[*,rr]=specstr.rmf[*,rr]*specstr.arf[rr]/dE[rr]

  ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ; start up ospex in noninteractive mode
  set_logenv, 'OSPEX_NOINTERACTIVE', '1'
  o = ospex()
  o->set,spex_fit_manual=0,  spex_autoplot_enable=0, spex_fit_progbar=0, spex_fitcomp_plot_resid=0
  o->set, spex_data_source='SPEX_USER_DATA'
  z = o->get(/spex_data_origunits)
  z.data_name = 'NuSTAR'
  o->set, spex_data_origunits=z
  o->set, spex_detectors=fpmid
  o->set, spex_ut_edges=anytim([t1,t2])
  o->set, spex_fit_time_interval=o->get(/spex_ut_edges)
  o->set, spex_ct_edges=enge
  o->set, mcurvefit_itmax=1000
  o->set, mcurvefit_tol=1e-4

  ; Our data so don't bother with the "use expected errors"
  o->set, spex_error_use_expected=0
  ; Add in 5% uncertainty
  o->set, spex_uncert=0.05
  if (n_elements(uncert_val) ne 0)  then o->set, spex_uncert=uncert_val

  ; Put them and the response into ospex
  o->set, spectrum=counts, errors=sqrt(counts), livetime=livetime+fltarr(nbins), spex_respinfo=rsp

  ; below what number of counts would we consider it to be non-Gaussian (i.e. Poisson) uncertainties?
  gausslim=10.
  if (n_elements(fiter) ne 2) then begin
    ; If no fit range is specified then we fit from 2.5 keV to bins with >10 counts
    ; staring bin in spec_in often 0 so avoid that as well
    maxfite=min(where(counts[1:n_elements(counts)-1] le gausslim))
    fiter=[2.5,enge[1,maxfite]]
  endif

  ; setup the fit and then do it
  o->set, spex_erange=fiter
  ; single thermal fit
  o->set, fit_function='vth+thick2'
  o->set, fit_comp_minima= [1.0e-20, 0.5, 0.01, 1.0e-10, 1.1,1.0, 1.1, loweclim, 100.0]
  o->set, fit_comp_maxima= [1.0e+20, 8.0, 10.0, 1.0e+10, 20.0, 1e+5,20.0, 1000.0, 1.0e+07]
  ; set the thick2 powerlaw break to below the low E cutoff so only get one powerlaw
  ; Also just going to set the high energy cutoff to a large number
  o->set, fit_comp_param=[1e-2, 0.25, 1, 1.e-3, 10.0, 0.5, 5.0, 10.0, 3000.0]

  ; Initially do the fit the thermal over the lower energy range

  o->set, spex_erange=[fiter[0],midfiter]
  o->set, fit_comp_free = [1, 1, 0, 0, 0, 0, 0, 0, 0]
  o->dofit, /all

  ; Then fit the thick2 over the higher energy part
  ; Only varying N, \delta and E_c
  o->set, spex_erange=[midfiter,fiter[1]]
  o->set, fit_comp_free = [0, 0, 0, 1, 0, 0, 1, 1, 0]
  o->dofit, /all

  ; Then both over the whole energy range
  o->set, spex_erange=fiter
  o->set, fit_comp_free = [1, 1, 0, 1, 0, 0, 1, 1, 0]
  o->dofit, /all

  ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ; get the resulting fitted spectrum model and params
  model = o -> calc_func_components(spex_units='flux',/counts,/all_func,this_interval=0)
  parm=o->get(/spex_summ_params)
  parmerr=o->get(/spex_summ_sigmas)
  chisq=o->get(/spex_summ_chisq)

  eranfit=o->get(/spex_erange)
  ;  ; The original data in units of count flux
  ;  ; should be the same as spec_in/dE/(livetime)
  obs=o->calc_summ(item='data_count_flux',errors=err,this_interval=0)
  ;
  ;  ; Also get it in terms of the photon flux
  pmodel = o -> calc_func_components(spex_units='flux',/photons,/all_func,this_interval=0)
  pobs=o->calc_summ(item='data_photon_flux',errors=perr,this_interval=0)
  id0=where(obs eq 0,nid0)
  if (nid0 gt 0) then begin
    pobs[id0]=0.
    perr[id0]=0.
  endif
  ;
  engs=get_edges(model.ct_energy,/mean)
  np=n_elements(engs)

  ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ; Save all the spectra and fit info out
  fit_out={fname:fname,fpmid:fpmid,timer:[t1,t2],dur:livetime,ontime:ontime,$
    eranfit:eranfit,eengs:model.ct_energy,engs:engs,$
    parm:parm,parmerr:parmerr,chisq:chisq[0],$
    cnt:counts,ecnt:sqrt(counts),cnt_mod:model.yvals[*,0]*dE*livetime,$
    cnt_mod1:model.yvals[*,1]*dE*livetime,cnt_mod2:model.yvals[*,2]*dE*livetime,$
    cnt_flx:obs,ecnt_flx:err,cnt_flx_mod:model.yvals[*,0],$
    cnt_flx_mod1:model.yvals[*,1],cnt_flx_mod2:model.yvals[*,2],$
    ph_flx:pobs,eph_flx:perr,ph_flx_mod:pmodel.yvals[*,0],$
    ph_flx_mod1:pmodel.yvals[*,1],ph_flx_mod2:pmodel.yvals[*,2]}

  save,file='fitvththick_'+fout+'.dat',fit_out

  ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ; Make a plot of the spectra and fit
  if (n_elements(pltxr) ne 2) then pltxr=[2.0,6]
  if (n_elements(pltyr) ne 2) then pltyr=[1.5,2e3]
  if (keyword_set(noplot) ne 1 ) then plotp_ospex_ns_fvththick, fit_out,xlim=pltxr,ylim=pltyr,outname=fout

  ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

end