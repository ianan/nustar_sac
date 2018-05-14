pro load_nshk,fname,hk,cor=cor

  ; Load in a NuSTAR housekeeping file (livetime)
  ; 
  ; Input
  ;   fname      - Name of the hk file (full directory listing)
  ; Output
  ;   hk         - The housekeeping structure of {time,livetime}
  ; Option
  ;   cor        - Apply -1s correction to times? Shouldn't effect recently processed data (so default no)
  ;
  ; 11-May-2018 IGH   Tidied up comments
  ; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ;
  
  if (n_elements(fname) eq 0) then fname='~/data/heasarc_nustar/ns_20170321/20210015001/hk/nu20210015001A_fpm.hk'
  if keyword_set(cor) then timcor=-1.0 else timcor=0.0
  ; Load in the file
 
  hkin = mrdfits(fname, 1, hkhdr,/silent)
  
  hk={time:anytim(hkin.time+anytim('01-Jan-2010')-timcor),livetime:hkin.livetime}
  
end