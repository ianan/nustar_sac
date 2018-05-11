pro load_nsevt,fname,evt,hdrinfo

  ; Load in a NuSTAR solar coords evt file
  ; Note that the times are converted into anytim format (secs from 1-Jan-1979,
  ; 
  ; Input
  ;   fname      - Name of the evt file (full directory listing(
  ; Output
  ;   evt        - The event list structure
  ;   hdrinfo    - The useful header info 
  ;
 
  ; 11-Feb-2018 IGH
  ; 11-May-2018 IGH   Tidied up comments
  ; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ;
  
  if (n_elements(fname) eq 0) then fname='~/data/heasarc_nustar/ns_20170321/20210015001/event_cl/nu20210015001A06_cl_sunpos.evt'

  ; Load in the file
  evt = mrdfits(fname, 1,evth,/silent)
  
  ; Convert times to anytim format
  nst0=anytim('01-Jan-2010')
  evt.time=evt.time+nst0
  
  ; save some of the header info
  tstart=anytim(sxpar(evth,'TSTART')+nst0,/yoh)
  tstop=anytim(sxpar(evth,'TSTOP')+nst0,/yoh)
  effexp=sxpar(evth,'LIVETIME')
  ontime=sxpar(evth,'ONTIME')
  lvtmp=100.*effexp/ontime

  fpid=strcompress(sxpar(evth,'INSTRUME'),/rem)
  obsid=strcompress(sxpar(evth,'OBS_ID'),/rem)

  ; header info needed for maps
  ttype = where(stregex(evth, "TTYPE", /boolean))
  xt = where(stregex(evth[ttype], 'X', /boolean))
  xpos = (strsplit( (strsplit(evth[ttype[max(xt)]], ' ', /extract))[0], 'E', /extract))[1]
  npix = sxpar(evth, 'TLMAX'+xpos)
  pixsize = abs(sxpar(evth,'TCDLT'+xpos))
  
  hdrinfo={tstart:tstart,tstop:tstop,effexp:effexp,ontime:ontime,lvtmp:lvtmp,$
    fpid:fpid,obsid:obsid,xt:xt,xpos:xpos,npix:npix,pixsize:pixsize}

end