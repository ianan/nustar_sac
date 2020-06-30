pro test_nstrep

  ;  Just double checking the python gives the same as the idl version...
  ;
  ;  30-Jun-2020 IGH
  ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  fname='/Users/iain/data/heasarc_nustar/ns_20200129/20515018001/event_cl/xspec_new/nu20515018001A06_cl_grade0_sr'
  load_nsspec, fname,s,spcer=[1.6,40]
  
  ids=indgen(6)*15
  print,s.arf[ids]
  print,s.rmf[ids,ids]
  
  nengs=n_elements(s.arf)
  srm=s.rmf
  for i=0,nengs-1 do srm[*,i]=s.rmf[*,i]*s.arf[i]
  print,srm[ids,ids]
  
  restore,file='fvth_out.dat'
  nt=n_elements(fvth[*,0])
  de=eng[1]-eng[0]
  
  modrate=dblarr(nt,nengs)
  for i=0,nt-1 do modrate[i,*]=srm#reform(fvth[i,*])*de
  print,reform(modrate[20,ids])
  
  plot_oo,eng,modrate[20,*]
  
  make_nstresp,fname,tresp_str,ebands=[2.5,4,6],spcer=[1.6,40]
  
  plot_oo,10^tresp_str.logt,tresp_str.tresp[*,0],chars=2,yrange=[1d-56,1d-41],ystyle=17,xrange=[1e6,2e7],xstyle=17
  oplot,10^tresp_str.logt,tresp_str.tresp[*,1],color=4
  
 

  stop
end