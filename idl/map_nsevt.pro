pro map_nsevt, evt,hdr,nsmap,effexp=effexp,$
  norm=norm,gsmooth=gsmooth,gs_sig=gs_sig,rebin=rebin,rb_npix=rb_npix,$
  xrange=xrange,yrange=yrange,shxy=shxy,detmap=detmap,dmo=dmo,shevt=shevt

  ; Make a map from a NuSTAR solar coords evt previously loaded via load_nsevt.pro and
  ; possibly filtered by filter_nsevt.pro
  ;
  ; Input
  ;   evt      - evt structure from load_nsevt.pro
  ;   hdr      - hdr structure from load_nsevt.pro
  ; Output
  ;   nsmap    - the NuSTAR map structure
  ;
  ; Option
  ;   effexp   - Effective exposure in sec (defulat uses one from header)
  ;   norm     - Normalise the map date by the effective exposure (so data is count/s instead of count)
  ;   gsmooth  - Apply a gaussian smoothing to the map (default no)
  ;   gs_sig   - Sigma for gaussian smoothing (default 3 pixels)
  ;   rebin    - Apply a x,y rebinning to the map (default no)
  ;   rb_npix  - Number of pixels to rebin map to (same x,y and default is 128)
  ;   xrange   - X-range of the output map in S/C arcsec (default not used)
  ;   yrange   - Y-range of the output map in S/C arcsec (default not used)
  ;   shxy     - Shift x,y of the map in arcsec (default no)
  ;   shevt    - Shift x,y, in acrsec, applied directly to evt before making the map (default no)
  ;   degs     - If using the original files, pixel_size in degs not arcsec (default no)
  ;
  ;
  ; 11-Feb-2018 IGH
  ; 10-May-2018 IGH   Tidied up comments
  ; 21-May-2018 IGH   Option to crudely output map of det id
  ; 23-May-2018 IGH   Change map time to min value of evt.time, instead of hdr.tstart
  ; 30-Sep-2018 IGH   Now will return map even if evt has <2 events
  ;                   Added check for evt input to be eventlist structure
  ; 04-Oct_2018 IGH   Added option to shift evt xy directly 
  ;                   Corrected odd tiny number xc,yc in cases it should be 0                 
  ; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ;

  ; Assumes centre of coords is S/C [0,0]
  centerx=hdr.npix*0.5
  centery=hdr.npix*0.5
  im_size=1400./hdr.pixsize
  im_width=round(im_size*2.)
  
  ; shift to apply to the evt
  if (n_elements(shevt) ne 2) then shevt=[0,0]
  ; need to convert shift from arcsec to pixels
  shevt=round(shevt/hdr.pixsize)
 
  ; Check that evt actually contains events in correct structure
  if (datatype(evt) eq 'STC') then begin
    pixinds=(evt.x+shevt[0])+(evt.y+shevt[1])*hdr.npix
    time_out=anytim(min(evt.time),/yoh,/trunc)
  endif else begin
    pixinds=0
    time_out=anytim(hdr.tstart,/yoh,/trunc)
  endelse
  ; Only run histogram if >1 events
  if (n_elements(pixinds) gt 1) then begin
    im_hist=histogram(pixinds, min=0, max=hdr.npix*hdr.npix-1, binsize=1)
  endif else begin
    im_hist=lonarr(hdr.npix*hdr.npix)
  endelse
  
  im=reform(im_hist, hdr.npix, hdr.npix)
  
  ims=im[(centerx-im_width):(centerx+im_width-1),(centery-im_width):(centery+im_width-1)]
  npp=n_elements(ims[0,*])

  ang=pb0r(hdr.tstart,/arcsec,l0=l0)

  comm=''

  ; Do we want to normalise the map by the effective exposure?
  ; WARNING - this is the original effective exposure header for the whole time range,
  ; so if filtered the time this wont be reflected here unless provide proper effexp
  if (n_elements(effexp) ne 1) then effexp=hdr.effexp
  if keyword_set(norm) then ims=ims/effexp
  if keyword_set(norm) then comm='count s^-1' else comm='count'

  ; Apply a gaussian smooth to the image?
  if keyword_set(gsmooth) then begin
    if (n_elements(gs_sig) ne 1) then gs_sig=3
    ims=gauss_smooth(ims*1.0,gs_sig)
    comm=comm+' GS'
  endif

  ; shift to apply to the map?
  if (n_elements(shxy) ne 2) then shxy=[0,0]

  ; construct the map
  nsmap=make_map(ims*1.0,dx=hdr.pixsize,dy=hdr.pixsize,xc=shxy[0],yc=shxy[1],$
    time=time_out,dur=effexp,l0=l0,b0=ang[1],rsun=ang[2],$
    id=hdr.fpid,comment=comm)

  ; only want part of the map?
  if (n_elements(xrange) eq 2 and n_elements(yrange) eq 2) then begin
    sub_map,nsmap,snsmap,xrange=xrange,yrange=yrange
    nsmap=snsmap
  endif

  ; Apply a rebinning to the map?
  if keyword_set(rebin) then begin
    if (n_elements(rb_npix) ne 1) then rb_npix=128
    nsmap=rebin_map(nsmap,rb_npix,rb_npix)
    nsmap.comment=nsmap.comment+' RB'
  endif

  ; Produce a det map as well?
  if keyword_set(detmap) then begin
    ;;ang=insin*w/(sqrt(2)*D)-(!pi/4)
    
    im_dets=intarr(hdr.npix,hdr.npix)-1
    id3=where(evt.det_id eq 3,nid3)
    if (nid3 gt 0) then for ii=0,nid3-1 do im_dets[evt[id3[ii]].x,evt[id3[ii]].y]=3
    id2=where(evt.det_id eq 2,nid2)
    if (nid2 gt 0) then for ii=0,nid2-1 do im_dets[evt[id2[ii]].x,evt[id2[ii]].y]=2
    id1=where(evt.det_id eq 1,nid1)
    if (nid1 gt 0) then for ii=0,nid1-1 do im_dets[evt[id1[ii]].x,evt[id1[ii]].y]=1
    id0=where(evt.det_id eq 0,nid0)
    if (nid0 gt 0) then for ii=0,nid0-1 do im_dets[evt[id0[ii]].x,evt[id0[ii]].y]=0

    im_dets=im_dets[(centerx-im_width):(centerx+im_width-1),(centery-im_width):(centery+im_width-1)]

    dmo=make_map(im_dets,dx=hdr.pixsize,dy=hdr.pixsize,xc=shxy[0],yc=shxy[1],$
      time=hdr.tstart,dur=effexp,l0=l0,b0=ang[1],rsun=ang[2],$
      id='Det Map')

    ; Also do the submap
    if (n_elements(xrange) eq 2 and n_elements(yrange) eq 2) then begin
      sub_map,dmo,sdmo,xrange=xrange,yrange=yrange
      dmo=sdmo
    endif

  endif
  
  ; final check that the xc, yc are not a tiny number when should be 0
  if (abs(nsmap.xc) lt 1e-4) then nsmap.xc=0
  if (abs(nsmap.yc) lt 1e-4) then nsmap.yc=0

end