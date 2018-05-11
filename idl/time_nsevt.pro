pro time_nsevt,evt,cts,hk,tbin=tbin

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
  ;   
  ; Example
  ;   time_nsevt,evt,tims,counts
  ;   utplot,tims,counts,psym=10  
  ;
  ; 12-Feb-2018 IGH
  ; 10-May-2018 IGH   Tidied up comments
  ; 11-May-2018 IGH   Added option for hk/livetime
  ; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ;

  ; Just do it in seconds from start
  tt=evt.time-evt[0].time

  ; default binning is 60s
  if (n_elements(tbin) ne 1) then tbin=60

  counts=histogram(tt,min=min(tt),max=max(tt),binsize=tbin,loc=xhh)
  tims=xhh+evt[0].time
  
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