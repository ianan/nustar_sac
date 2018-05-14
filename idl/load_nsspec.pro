pro load_nsspec, fname,spec, spcer=spcer,de=de

  ; Load in a set of NuSTAR pha, rmf and arf files and returns a format suitable for
  ; work in IDL and/or with OSPEX
  ;
  ;
  ;   fname -   stem input of the directory and the filename
  ;   spec  -   returns a structure with the spectral info in it all
  ;
  ; optional
  ;   spcer  -  energy range to return the data over
  ;   de     -  change to bigger energy binning (>0.04 keV) needs spcer
  ;
  ;  Note - at the moment assumes uniform binning in E
  ;
  ; 18-Jun-2017   IGH
  ; 08-Dec-2017   IGH
  ; 14-May-2018   IGH   Renamed from load_ns_spec to load_nsspec to be consistent with other load*.pro
  ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  if (n_elements(fname) ne 1) then $
    fname='testxout/nu20110114001A06_chu23_S_cl_grade0_sr'

  ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ; Load in the spectrum
  ssa=mrdfits(fname+'.pha',1,sha)
  counts=ssa.counts
  engs=1.6+0.04*ssa.channel
  
  ;   If no rebinning specified then just set it to actual data dE
  if (n_elements(de) ne 1) then de=engs[1]-engs[0]
  
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

  counts=counts[eid]
  rmf=rmf[min(eid):max(eid),min(eid):max(eid)]
  arf=arf[eid]
  enge=enge[*,eid]
  engm=engm[eid]
  nx=n_elements(engm)

  if (de gt 0.04) then begin

    neid=spcer[0]+de*indgen(2+(spcer[1]-spcer[0])/de)
    nengm=get_edges(neid,/mean)
    nnx=n_elements(nengm)
    ncounts=fltarr(nnx)
    nenge=fltarr(2,nnx)
    for i=0,nnx-1 do nenge[*,i]=[neid[i],neid[i+1]]
    for i=0,nnx-1 do ncounts[i]=total(counts[where(enge[0,*] ge nenge[0,i] and enge[1,*] le nenge[1,i] )])
    
    narf=interpol(arf,engm,nengm)
    
    new_rmf_t=fltarr(nnx,nx)
    for yy=0,nx-1 do new_rmf_t[*,yy]=interpol(rmf[*,yy],engm,nengm)
    new_rmf=fltarr(nnx,nnx)
    for xx=0, nnx-1 do new_rmf[xx,*]=interpol(new_rmf_t[xx,*],engm,nengm)
    ; need this rescaling by the dE - for some reason
    nrmf=(nengm[1]-nengm[0])*new_rmf/(engm[1]-engm[0])

    spec={fpmid:fpmid,tstrt:tstrt,tstop:tstop,livetime:livetime,ontime:ontime,counts:ncounts,$
      rmf:nrmf,arf:narf,enge:nenge,engm:nengm}

  endif else begin

    spec={fpmid:fpmid,tstrt:tstrt,tstop:tstop,livetime:livetime,ontime:ontime,counts:counts,$
      rmf:rmf,arf:arf,enge:enge,engm:engm}
  endelse

;  stop

end