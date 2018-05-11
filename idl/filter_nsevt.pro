pro filter_nsevt,evt,evtf,grade=grade,engrng=engrng,tmrng=tmrng,detid=detid

  ; Filter a NuSTAR solar coords evt file
  ; 
  ; By default will return the full evt if no filter has been used/worked
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
  ;
  ; 11-Feb-2018 IGH
  ; 10-May-2018 IGH   Tidied up comments
  ; 11-May-2018 IGH   Corrected bug so that grade and det filtering works for array of grades/dets
  ; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ;

  evtf=evt
  
  ; filter for grade
  if (n_elements(grade) gt 0) then begin
    ng=n_elements(grade)
    for g=0,ng-1 do begin
      gidtemp=where(evt.grade eq grade[g],ngidtemp)
      if (ngidtemp gt 0) then begin
        if (g eq 0) then gid=gidtemp else gid=[gid,gidtemp]
      endif
    endfor
    ngid=n_elements(gid)
    if (ngid gt 0) then evtf=evtf[gid]
  endif
  
  if (n_elements(engrng) eq 2) then begin
    pirng=long((engrng-1.6)/0.04)
    eid=where(evtf.pi ge pirng[0] and evtf.pi lt pirng[1],neid)
    if (neid gt 0) then evtf=evtf[eid]
  endif
  
  if (n_elements(tmrng) eq 2) then begin
    tr=anytim(tmrng)
    tid=where(evtf.time ge tr[0] and evtf.time lt tr[1],ntid)
    if (ntid gt 0) then evtf=evtf[tid]
  endif
  
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
  
end