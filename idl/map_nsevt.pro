pro map_nsevt, evt,hdr,nsmap,effexp=effexp,$
  norm=norm,gsmooth=gsmooth,gs_sig=gs_sig,rebin=rebin,rb_npix=rb_npix,$
  xrange=xrange,yrange=yrange,shxy=shxy

  ; Make a map from a NuSTAR solar coords evt previously loaded via load_nsevt.pro and
  ; possibly filtered by filter_nsevt.pro
  ; 
  ; Input
  ;   evt   - evt structure from load_nsevt.pro
  ;   hdr   - hdr structure from load_nsevt.pro
  ; Output
  ;   nsmap   - the NuSTAR map structure
  ;
  ; Option
  ;   effexp   - Effective exposure in sec (defulat uses one from header)
  ;   norm     - Normalise the map date by the effective exposure (so data is count/s instead of count)
  ;   gsmooth  - Apply a gaussian smoothing to the map (default no)
  ;   gs_sig   - Sigma for gaussian smoothing (default 3 pixels)
  ;   rebin    - Apply a x,y rebinning to the map (default no)
  ;   reb_npix - Number of pixels to rebin map to (same x,y and default is 128)
  ;   xrange   - X-range of the output map in S/C arcsec (default not used)
  ;   yrange   - Y-range of the output map in S/C arcsec (default not used)
  ;   shxy     - Shift the x,y of the map in arcsec (default no)
  ; 
  ;
  ; 11-Feb-2018 IGH
  ; 10-May-2018 IGH   Tidied up comments
  ; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ;

  ; Assumes centre of coords is S/C [0,0]
  centerx=hdr.npix*0.5
  centery=hdr.npix*0.5
  im_size=1400./hdr.pixsize
  im_width=round(im_size*2.)

  pixinds=evt.x+evt.y*hdr.npix
  im_hist=histogram(pixinds, min=0, max=hdr.npix*hdr.npix-1, binsize=1)
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
    time=hdr.tstart,dur=effexp,l0=l0,b0=ang[1],rsun=ang[2],$
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

end