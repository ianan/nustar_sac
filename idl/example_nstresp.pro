pro example_nstresp

  ; Examples of calculating and using the temperature response from NuSTAR pha/rmf/arf
  ;
  ; 15-May-2018 IGH
  ; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  ; Location and name of some NuSTAR data
  msdir='~/OneDrive - University of Glasgow/work/ns_data/simple_idl/testxout/'
  fname='nu20110114001A06_chu23_S_cl_grade0_sr'

;  load_nsspec, msdir+fname,s
  ; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ; Make and load in the temperature response
  make_nstresp,msdir+fname,tresp,ebands=[2.5,3.5,4.5,5.5]
  nt=n_elements(tresp.tresp[0,*])
  
  window,5,xsize=700,ysize=400
  clearplot
  !p.multi=[0,2,1]
  !x.style=17
  !y.style=17
  linecolors
  cts=[1,8,10,13]
  
  ; Plot the Responses
  plot,10d^tresp.logt*1d-6,tresp.tresp[*,0],/nodata,/ylog,/xlog,xrange=[1,30],yrange=[1d-48,1d-41],$
    xtit='Temperature [MK]',ytit='NuSTAR Thermal Response [count cm!U3!N s!U-1!N]'
  for i=0,nt-1 do oplot, 10d^tresp.logt*1d-6,tresp.tresp[*,i],color=cts[i],thick=4
  
  ; Plot the EM loci curves
  plot,10d^tresp.logt*1d-6,tresp.rate[0]/tresp.tresp[*,0],/nodata,/ylog,/xlog,yrange=[1d40,1d50],xrange=[1,30],$
    xtit='Temperature [MK]',ytit='Emission Measure [cm!U-3!N]'
  for i=0,nt-1 do oplot, 10d^tresp.logt*1d-6,tresp.rate[i]/tresp.tresp[*,i],color=cts[i],thick=2,lines=2
  for i=0,nt-1 do xyouts, 20,10d^(49.-i*0.7),tresp.eid[i],color=cts[i],align=1
  

  stop
end