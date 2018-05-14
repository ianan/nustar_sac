pro example_nslct

  ; Examples of using the sswidl code with NuSTAR data to make lightcurves
  ;
  ; 11-May-2018 IGH
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
  ; Load in the livetimes from the housekeeping file
  load_nshk,fnhk,hk
  
  ; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ; Load in the CHU info
  load_nschu,fnchu,chu

  ; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ; Produce lightcurve with 10s bins
  time_nsevt,evt,cts,hk,tbin=10

  ; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ; Setup the plot
  clearplot
  window,0,xsize=400,ysize=700
  !p.charsize=2
  !p.multi=[0,1,4]
  !y.style=17
  !x.style=17
  
  ; Plot the counts vs time
  utplot,cts.time,cts.counts,yrange=[min(cts.counts)*0.5,max(cts.counts)*1.1],ytit='NuSTAR counts',timer=timer,psym=10

  ; Plot the chu state vs time
  utplot,chu.time,chu.mask,psym=-4,yrange=[0,8],ytitle='NuSTAR CHUs',yticks=8,yminor=1,ytickname=chu.lab,$
    timer=timer,symsize=0.5
  
  ; PLot the livetime vs time
  utplot,hk.time,hk.livetime*100,/ylog,yrange=[0.5,101],ytit='Livetime %',timer=timer,psym=10
  
  ; Plot the count rate vs time
  utplot,cts.time,cts.rate,yrange=[min(cts.rate)*0.5,max(cts.rate)*1.1],ytit='NuSTAR counts s!U-1!N ',timer=timer,psym=10

;  ; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;  ; Check rate caculation/plot is ok
;  time_nsevt,evt,cts1,hk,tbin=10
;  time_nsevt,evt,cts2,hk,tbin=5
;  time_nsevt,evt,cts3,hk,tbin=20
;  time_nsevt,evt,cts4,hk,tbin=30
;
;  clearplot
;  window,1,xsize=500,ysize=400
;  !p.charsize=1.
;  !p.multi=0
;  !y.style=17
;  !x.style=17
;  utplot,cts1.time,cts1.rate,yrange=[min(cts1.rate)*0.5,max(cts1.rate)*1.1],ytit='NuSTAR counts s!U-1!N ',timer=timer,psym=10
;  linecolors
;  outplot,cts2.time,cts2.rate,color=2,psym=10
;  outplot,cts3.time,cts3.rate,color=7,psym=10
;  outplot,cts4.time,cts4.rate,color=9,psym=10

  stop
end