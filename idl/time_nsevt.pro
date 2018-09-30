pro time_nsevt,evt,cts,hk,tbin=tbin,tstart=tstart,tend=tend

  ; Make a timeprofile for a NuSTAR evt data
  ;
  ; Input
  ;   evt   - evt structure from load_nsevt.pro
  ; Output
  ;   cts   - structure of time binning (in anytim format), counts and possibly count rate (livetime corrected)
  ;
  ; Option
  ;   hk     - provide the hk sturcture to get the livetime correctd rate as well
  ;   tbin   - time binning in seconds (default 60s), needs to be >1s when used with hk
  ;   tstart - time to start binnning from
  ;   tend   - time to end binning at
  ;
  ; Example
  ;   time_nsevt,evt,tims,counts
  ;   utplot,tims,counts,psym=10
  ;
  ; 12-Feb-2018 IGH
  ; 10-May-2018 IGH   Tidied up comments
  ; 11-May-2018 IGH   Added option for hk/livetime
  ; 03-Jun-2018 IGH   Added tstart/tend option
  ; 21-Sep-2018 IGH   Corrected tstart/tend default bug
  ; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ;

  ; default binning is 60s
  if (n_elements(tbin) ne 1) then tbin=60
  if (n_elements(tstart) ne 1) then tstart=min(evt.time) else tstart=anytim(tstart)
  if (n_elements(tend) ne 1) then tend=max(evt.time) else tend=anytim(tend)
  
  ; Just do it in seconds from start
  tt=evt.time-tstart

  counts=histogram(tt,min=0,max=tend-tstart-tbin,binsize=tbin,loc=xhh)
  tims=xhh+tstart

  ; If hk structure from load_nshk.pro provided also work out the livetime corrected rate
  if (size(hk,/tname) eq 'STRUCT') then begin
    nt=n_elements(tims)
    ltimes=fltarr(nt)
    for t=0,nt-1 do begin
      tid=where(hk.time ge tims[t] and hk.time lt tims[t]+tbin,ntid)
      if (ntid gt 0) then ltimes[t]=mean(hk.livetime[tid])
    endfor
    cts={time:tims,counts:counts,rate:counts/(tbin*ltimes),livefrac:ltimes}
  endif else begin
    cts={time:tims,counts:counts}
  endelse

end