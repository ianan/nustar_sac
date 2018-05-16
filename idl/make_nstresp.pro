pro make_nstresp,fname,tresp_str,ebands=ebands,spcer=spcer

  ; Make a NuSTAR thermal response for given energy ranges and observation
  ; 
  ; Note that, For something like AIA/XRT the data is DN/s/px and the response is DN cm^5/s/px
  ; Here uses f_vth.pro which produces ph/s/kev/cm^2 for an EM in cm^-3
  ; The NuSTAR SRM=RMF*ARF is cnts cm^2/photons so SRM#f_vth*dE is cnts/s
  ;
  ; Approach here gives you the Volumetric EM as thermal response in units of cnts cm^3/s,
  ; i.e R(T)=SRM#f_vth(EM,T)*dE/EM  so R(T)*EM[cm^-3] would give the observed cnts/s
  ; 
  ; If want/using EM in cm^-5 then need to appropriately divide/multiply by the area of the observation
  ;  
  ; Input
  ;   fname     -   Stem input of the directory and the filename
  ; Output
  ;   tresp_str -  Returns a structure with the all the T response stuff
  ; Option
  ;   ebands    -  Energy bands to work out response over (default 2.5-4, 4-6, 6-10 keV)
  ;   spcer     -  Energy range of response to use (default [1.6,40])
  ;
  ; 15-May-2017 IGH
  ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  if (n_elements(fname) ne 1) then $
    fname='~/OneDrive - University of Glasgow/work/ns_data/simple_idl/testxout/nu20110114001A06_chu23_S_cl_grade0_sr'
    
  ; Energy bands to work out the responses over
  if (n_elements(ebands) lt 2) then ebands=[2.5,4.0,6.0]
  neb=n_elements(ebands)-1
    
  ; Load in the pha, rmf, and arf
  if (n_elements(spcer) ne 2) then spcer=[1.6,40]
  load_nsspec, fname,s,spcer=spcer
  
  de=s.enge[1,0]-s.enge[0,0]
  nengs=n_elements(s.enge[0,*])
  rsp=s.rmf
  for i=0,nengs-1 do rsp[*,i]=s.rmf[*,i]*s.arf[i]
  
  ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ; Use same temperature binning as aia_get_response() though need f_vth only works >1MK
  logt=6.05+indgen(40)*0.05
  tmk=10d^logt*1d-6
  tf=0.08617
  tkev=tmk*tf
  nt=n_elements(logt)
  
  modrate=dblarr(nt,nengs)
  ; This should be in units of [counts cm^3/s] = [counts cm^2/photons]*[photons/cm^2/s/keV]*[keV]/cm^-3
  for i=0,nt-1 do modrate[i,*]=rsp#f_vth(s.enge,[1,tkev[i],1])*de/1d49
  
  ; Create the response for each of the chosen energy bands
  rate=dblarr(neb)
  eid=strarr(neb)
  tresp=dblarr(nt,neb)
  for i=0,neb-1 do begin
    id=where(s.enge[0,*] ge ebands[i] and s.enge[1,*] lt ebands[i+1])
    eid[i]=strcompress(string(ebands[i],format='(f4.1)')+' - '+string(ebands[i+1],format='(f4.1)'),/rem)+' keV'
    rate[i]=total(s.counts[id])/s.livetime
    tresp[*,i]=total(modrate[*,id],2)
  endfor
  
  tresp_str={ebands:ebands,eid:eid,logt:logt,tresp:tresp,tresp_units:'count cm^3 s^-1',rate:rate,rate_units:'count s^-1'}
 
end