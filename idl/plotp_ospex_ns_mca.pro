pro plotp_ospex_ns_mca,fname,outname=outname,ps=ps

  ; Plot the chi-sq map of the Monte Carlo Analysis results forma run of ospex_ns_fvth.pro
  ;
  ; Note: uses the plot procedure so should work with all version of IDL
  ;
  ;  options
  ;     outname -   postfixname to figure output (default fname from fit stucture)
  ;     ps      -   produce postscript plots of the parameter distributions/spread (default no)
  ;
  ; 15-May-2018 IGH
  ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  if (n_elements(fname) ne 1) then fname='test1'
  if (n_elements(outname) ne 1) then outname=fname
  if (n_elements(ps) ne 1) then ps=0

  ;  ; Load in the spectrum fits sturcture
  restore, file='fitvth_'+fname+'.dat'

  ; Load in the Monte Carlo Analysis save file
  restore,file='mca_vth_'+fname+'.sav'
  spex_monte_carlo_results, savefile='mca_vth_'+fname+'.sav', out_struct=mcs,ps=ps

  tkev=0.08617
  ;  print,'EM: ',fit_out.parm[0]*1d49,'  ---   ',mcs[0].v67*1d49
  ;  print,'T: ', fit_out.parm[1]/tkev,'  ---   ',mcs[1].v67/tkev

  ; Based off of the plot parts of spec_monte_carlo_results/chi_map codes
  ; my version for more control on output plots

  nx=74.
  ny=74.
  p1 = reform(savep[0,*])
  p2 = reform(savep[1,*])
  dx = (max(p1) - min(p1)) / (nx-1)
  dy = (max(p2) - min(p2)) / (ny-1)
  x = min(p1) + findgen(nx)*dx
  y = min(p2) + findgen(ny)*dy
  xbin = value_locate(x, p1)
  ybin = value_locate(y, p2)
  cmap = fltarr(nx,ny)
  chi=savechi
  for m = 0L,n_elements(chi)-1 do cmap[xbin[m], ybin[m]]++

  emfac=1d3
  xrmc=minmax(x)*emfac
  yrmc=minmax(y)/tkev

  ; Plot the
  clearplot
  !p.charsize=2
  window,7,xsize=600,ysize=500
  loadct,39,/silent

  ; Swapping the x, y so plot of EM vs T instead of T vs EM
  plot_image,transpose(cmap),origin=[min(y)/tkev,min(x)*emfac],scale=[dy/tkev,dx*emfac],$
    /nosquare,xtitle='T [MK]',ytitle='!3EM x10!U46!N cm!U-3!N',title='chi!U2!N map'

  oplot,yrmc,fit_out.parm[0]*emfac*[1,1]
  oplot,fit_out.parm[1]/tkev*[1,1],xrmc

  oplot,yrmc,emfac*mcs[0].v67[0]*[1,1],lines=2
  oplot,yrmc,emfac*mcs[0].v67[1]*[1,1],lines=2
  oplot,mcs[1].v67[0]*[1,1]/tkev,xrmc,lines=2
  oplot,mcs[1].v67[1]*[1,1]/tkev,xrmc,lines=2

end