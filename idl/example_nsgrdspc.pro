pro example_nsgrdspc

  ; Examples of using the sswidl code with NuSTAR data to make a GRADE spectrum
  ;
  ; 01-Oct-2018 IGH
  ; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  ; Location and name of some NuSTAR data
  mdir='~/data/heasarc_nustar/ns_20170321/20210015001/'
  nsid='nu20210015001'
  fnevt=mdir+'event_cl/'+nsid+'A06_cl_sunpos.evt'
 
  ; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ; Load in a particular evt file
  load_nsevt,fnevt,evt,hdr

  ; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ; Make the grade spectrum
  make_grdspec,evt,gs
  
  ; Setup the plot
  clearplot
  window,0,xsize=600,ysize=500
  !p.charsize=2
  !p.multi=0
  !y.style=17
  !x.style=17
  !p.thick=1
  loadct,39,/silent
  
  ; Plot the grade spectra
  plot,gs.engs,gs.hhga,/ylog,yrange=[0.5,1.1*max(gs.hhga)],psym=10,xrange=[1.5,8],$
    xtitle='Energy [keV]', ytitle='Counts',ytickf='exp1'
  oplot,gs.engs,gs.hhg0,color=80,psym=10
  oplot,gs.engs,gs.hhg2,color=220,psym=10
  
  xyouts, 7.5,10d^2.5,'GrdAll',/data,align=1,chars=1
  xyouts, 7.5,10d^2.2,'GrdO',/data,align=1,color=80,chars=1
  xyouts, 7.5,10d^1.9,'Grd21-24',/data,align=1,color=220,chars=1
  

  stop
end