pro filter_nsevt,evt,evtf,grade=grade,engrng=engrng,tmrng=tmrng,detid=detid,$
  badpix=badpix,bp_str=bp_str,fpmid=fpmid

  ; Filter a NuSTAR solar coords evt file
  ;
  ; If no evt element matches filter just returns 0
  ;
  ; Both time and energy filter needs a range (2-element array) and returns
  ; range[0] <= data < range[1]
  ;
  ; Format of the time is something sswidl anytim understands, i.e. '15-Jan-2014 12:34:56'
  ;
  ; Input
  ;   evt   - evt structure from load_nsevt.pro
  ; Output
  ;   evtf  - evt structure that's been filtered
  ;
  ; Option
  ;   grade   -  Event grade, =0, =[21,22,23,24] etc (default all)
  ;   engrng  -  Energy range filter: energy[0] <= events < energy[1] (default all)
  ;   tmrng   -  Time range filter: time[0] <= events < time[1] (default all)
  ;   detid   -  Events from chosen detectors =0, =[0,1] (default all 4)
  ;   badpix  -  Remove the default bad pixels (default off)
  ;   fpmid   -  FPM of the evt file, needed for bad pixel stuff (default is A)
  ;   bp_str  -  Provide your own bad pixel list structure, each entry being {fpm:,det:,rawx:,rawy:}
  ;
  ; 11-Feb-2018 IGH
  ; 10-May-2018 IGH   Tidied up comments
  ; 11-May-2018 IGH   Corrected bug so that grade and det filtering works for array of grades/dets
  ; 14-May-2018 IGH   Added bad pixel removal
  ; 30-Sep-2018 IGH   Changed default return when filters no met to 0, instead of original evt
  ; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ;

  evtf=evt

  if (n_elements(fpmid) ne 1) then fpmid='A'

  ; Filter to specific grade(s)
  if (n_elements(grade) gt 0) then begin
    ng=n_elements(grade)
    for g=0,ng-1 do begin
      gidtemp=where(evt.grade eq grade[g],ngidtemp)
      if (ngidtemp gt 0) then begin
        if (g eq 0) then gid=gidtemp else gid=[gid,gidtemp]
      endif
    endfor
    ngid=n_elements(gid)
    if (ngid gt 0) then evtf=evtf[gid] else evtf=0
  endif

  ; Filter to a specific energy range
  if (n_elements(engrng) eq 2) then begin
    pirng=long((engrng-1.6)/0.04)
    eid=where(evtf.pi ge pirng[0] and evtf.pi lt pirng[1],neid)
    if (neid gt 0) then evtf=evtf[eid] else evtf=0
  endif

  ; Filter to a specific time range
  if (n_elements(tmrng) eq 2) then begin
    tr=anytim(tmrng)
    tid=where(evtf.time ge tr[0] and evtf.time lt tr[1],ntid)
    if (ntid gt 0) then evtf=evtf[tid] else evtf=0
  endif

  ; Filter down to one detector
  if (n_elements(detid) gt 0) then begin
    nd=n_elements(detid)
    for d=0,nd-1 do begin
      didtemp=where(evt.det_id eq detid[d],ndidtemp)
      if (ndidtemp gt 0) then begin
        if (d eq 0) then did=didtemp else did=[did,didtemp]
      endif
    endfor
    ndid=n_elements(did)
    if (ndid gt 0) then evtf=evtf[did]
  endif

  ; Filter out the badpixels
  if keyword_set(badpix) then begin
    if (datatype(bp_str) ne 'STC') then begin
      ; Default ones taken from
      ;      https://github.com/NuSTAR/nustar_pysolar/tree/master/nustar_scripts/userbadpix
      bp_info={fpm:'A',det:0,rawx:0, rawy:0}
      bp_str=replicate(bp_info,13)
      bp_str.fpm=['A','A','A','A','A','A','A','A','A','A','A','A','B']
      bp_str.det=[2,2,2,2,3,3,3,3,3,3,3,3,0]
      bp_str.rawx=[16,24,27,27,22,15,5,22,16,18,24,25,24]
      bp_str.rawy=[5,22,6,21,1,3,5,7,11,3,4,5,24]
    endif

    fid=where(bp_str.fpm eq fpmid,nbp)
    if (nbp gt 0) then begin
      use=intarr(n_elements(evtf))+1
      bp_str=bp_str[fid]
      for b=0,nbp-1 do begin
        bdid=where(evtf.det_id eq bp_str[b].det and $
          evtf.rawx eq bp_str[b].rawx and evtf.rawy eq bp_str[b].rawy,nbdid)
        if (nbdid gt 0) then use[bdid]=0
      endfor
      gdp_id=where(use ne 0)
      evtf=evtf[gdp_id]

    endif

  endif

end