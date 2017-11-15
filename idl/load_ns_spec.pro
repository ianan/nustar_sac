pro load_ns_spec, fname,spec, spcer=spcer

  ; Load in a set of NuSTAR pha, rmf and arf files and returns a format suitable for
  ; work in IDL and/or with OSPEX
  ;
  ;
  ;   fname -   stem input of the directory and the filename
  ;   spec  -   returns a structure with the spectral info in it all
  ;
  ; optional
  ;   spcer  -  energy range to return the data over 
  ;   
  ;  Note - at the moment assumes uniform binning in E
  ;
  ; 18-Jun-2017   IGH
  ;
  ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  if (n_elements(fname) ne 1) then $
    fname='testxout/nu20110114001A06_chu23_S_cl_grade0_sr'

  ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ; Load in the spectrum
  ssa=mrdfits(fname+'.pha',1,sha)
  counts=ssa.counts
  de=0.04
  engs=1.6+de*ssa.channel
  livetime=sxpar(sha,'LIVETIME')
  ontime=sxpar(sha,'ONTIME')
  fpmid=strcompress(sxpar(sha,'INSTRUME'),/rem)
  tstrt=anytim(anytim(sxpar(sha,'TSTART'))+anytim('01-Jan-2010'),/yoh)
  tstop=anytim(anytim(sxpar(sha,'TSTOP'))+anytim('01-Jan-2010'),/yoh)
  
  ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ; Load in the rmf
  rmfread, fname+'.rmf', rmf_str, compressed='UNCOMPRESSED'
  rmf = transpose(*(rmf_str.data))
  enge = *(rmf_str.ebins)
  engm=get_edges(enge,/mean)

  ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ; Load in the arf
  fxbopen, unit, fname+'.arf', 'SPECRESP', hh, errmsg=err
  fxbreadm, unit, ['ENERG_LO','ENERG_HI','SPECRESP'], elo, ehi, arf, errmsg=err
  fxbclose, unit
  
  if (n_elements(spcer) eq 2) then begin
    ; just make sure don't go beyond the instrument energy range
    spcer=[spcer[0]>1.6,spcer[1]<165.440]
    eid=where(enge[0,*] ge spcer[0] and enge[1,*] le spcer[1])
  endif else begin
    eid=indgen(n_elements(counts))
  endelse

  spec={fpmid:fpmid,tstrt:tstrt,tstop:tstop,livetime:livetime,ontime:ontime,counts:counts[eid],$
    rmf:rmf[min(eid):max(eid),min(eid):max(eid)],arf:arf[eid],enge:enge[*,eid],engm:engm[eid]}
end