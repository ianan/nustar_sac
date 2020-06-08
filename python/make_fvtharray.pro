pro make_fvtharray,spcer=spcer

  ; Make and save out an array of fvth model photon spectrum to be used elsewhere.....
  ; .... especially in python
  ; 
  ; 08-Jun-2020 IGH  
  ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    
  ; Load in the pha, rmf, and arf
  if (n_elements(spcer) ne 2) then spcer=[1.6,40]
  de=0.04
  nengs=(spcer[1]-spcer[0])/de
  engs=dblarr(2,nengs)
  engs[0,*]=spcer[0]+de*findgen(nengs)
  engs[1,*]=engs[0,*]+de
  
  ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ; Use same temperature binning as aia_get_response() though need f_vth only works >1MK
  ntr=40
  dt=(8.0-6.0)/ntr
  logt=6.0+dt+indgen(ntr)*dt

  tmk=10d^logt*1d-6
  tf=0.08617
  tkev=tmk*tf
  nt=n_elements(logt)
  
  fvth=dblarr(nt,nengs)
  for i=0,nt-1 do fvth[i,*]=f_vth(engs,[1,tkev[i],1])
  
  comment='engs are start per bin'
  eng=reform(engs[0,*])
  save,file='fvth_out.dat',eng,logt,fvth,comment
 
end