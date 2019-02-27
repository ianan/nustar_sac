pro example_nslct2

  ; Examples of using the sswidl code with NuSTAR data to make lightcurves
  ;
  ; This version does the lightcurve over the just a limited part of the FoV
  ;
  ; 21-Feb-2019 IGH
  ; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  ; Location and name of some NuSTAR data
  mdir='~/data/heasarc_nustar/ns_20170321/20210015001/'
  nsid='nu20210015001'
  fnevt=mdir+'event_cl/'+nsid+'A06_cl_sunpos.evt'
  fnhk=mdir+'hk/'+nsid+'A_fpm.hk'
  fnchu=mdir+'hk/'+nsid+'_chu123.fits'

  ; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ; Load in a particular evt file
  load_nsevt,fnevt,evt,hdr
  timer=minmax(evt.time)

  ; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ; Filter evt for just grade=0, energy=[2.5,10] and x=[-1000,-900], y=[150,250]
  filter_nsevt,evt,evtf,hdr,grade=0,engrng=[2.5,10]
  filter_nsevt,evt,evtxy,hdr,grade=0,engrng=[2.5,10],xyrange=[-1050,-850,50,250]
  
  ; Plot the maps to check the xy filtering did work
  !p.multi=[0,2,1]
  window,1,xsize=900,ysize=450
  ns_lct
  map_nsevt,evtf,hdr,mapf
  plot_map,rebin_map(mapf,1024,1024),/limb,grid_spacing=15,/log,$
    bot=2,top=254,gcolor=1,lcolor=1,xrange=[-1200,-700],yrange=[0,500],tit='Full'
  
  map_nsevt,evtxy,hdr,mapxy
  plot_map,rebin_map(mapxy,1024,1024),/limb,grid_spacing=15,/log,$
    bot=2,top=254,gcolor=1,lcolor=1,xrange=[-1200,-700],yrange=[0,500],tit='XY Range'

  ; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ; Load in the livetimes from the housekeeping file
  load_nshk,fnhk,hk

  ; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ; Load in the CHU info
  load_nschu,fnchu,chu

  ; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ; Produce lightcurve with 10s bins
  time_nsevt,evt,cts,hk,tbin=10
  time_nsevt,evtxy,ctsxy,hk,tbin=10


  ; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ; Setup the plot
  clearplot
  window,0,xsize=400,ysize=700
  !p.charsize=2
  !p.multi=[0,1,4]
  !y.style=17
  !x.style=17

  tlc_igh

  ; Plot the counts vs time
  utplot,cts.time,cts.counts,yrange=[min(cts.counts)*0.5,max(cts.counts)*1.1],ytit='NuSTAR counts',timer=timer,psym=10
  outplot,ctsxy.time,ctsxy.counts,psym=10,color=4

  ; Plot the chu state vs time
  utplot,chu.time,chu.mask,psym=-4,yrange=[0,8],ytitle='NuSTAR CHUs',yticks=8,yminor=1,ytickname=chu.lab,$
    timer=timer,symsize=0.5

  ; PLot the livetime vs time
  utplot,hk.time,hk.livetime*100,/ylog,yrange=[0.5,101],ytit='Livetime %',timer=timer,psym=10

  ; Plot the count rate vs time
  utplot,cts.time,cts.rate,yrange=[min(cts.rate)*0.5,max(cts.rate)*1.1],ytit='NuSTAR counts s!U-1!N ',timer=timer,psym=10
  outplot,ctsxy.time,ctsxy.rate,psym=10,color=4

  stop
end