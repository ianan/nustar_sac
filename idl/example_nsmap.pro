pro example_nsmap

  ; Examples of using the sswidl code with NuSTAR data to make maps
  ;
  ; 11-May-2018 IGH
  ; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  ; Location and name of some NuSTAR data
  mdir='~/data/heasarc_nustar/ns_20170321/20210015001/'
  nsid='nu20210015001'
  fnevt=mdir+'event_cl/'+nsid+'A06_cl_sunpos.evt'

  ; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ; Load in a particular evt file
  load_nsevt,fnevt,evt,hdr
  print,'Ontime: ',hdr.ontime
  print,'Eff exp: ', hdr.effexp
  print,'Lvtime %: ',hdr.lvtmp

  ; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ; Filter the file for grade 0 events with energy 2 to 4 keV
  ;  filter_nsevt,evt,evtfbp,grade=0,engrng=[2,4],/badpix,fpmid='A'
  filter_nsevt,evt,evtf,grade=0,engrng=[2,4]

  ; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ; Load in a colour table for NuSTAR maps
  ns_lct
  ; Setup plot
  clearplot
  !p.multi=[0,3,1]
  !p.charsize=1.5
  window,0,xsize=750,ysize=250

  ; Make and plot a map
  map_nsevt,evtf,hdr,map24
  plot_map,map24,/limb,grid_spacing=15,xrange=[-1200,-600],yrange=[-200,400],/log,bot=1,gcolor=0,lcolor=0

  ; Make another map but rebin the data and limit xy-range
  map_nsevt,evtf,hdr,map24rb,/rebin,xrange=[-1200,-600],yrange=[-200,400]
  plot_map,map24rb,/limb,grid_spacing=15,bot=1,gcolor=0,lcolor=0

  ; Make another map but use gaussian smooth and limit xy-range
  map_nsevt,evtf,hdr,map24gs,/gsmooth,xrange=[-1200,-600],yrange=[-200,400]
  plot_map,map24gs,/limb,grid_spacing=15,bot=1,gcolor=0,lcolor=0

  ; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ; Plot a full disk effective exposure normalised, smoothed map, similar to
  ; https://github.com/ianan/nsigh_all/blob/master/maps/maps_20170321/maps_20170321_124251_nu20210015001_FPMA.png
  ; also apply shift by x-30", y+20" (not sure if correct just for testing/example)
  ns_lct
  !p.multi=0
  !p.charsize=1
  window,1,xsize=600,ysize=600
  map_nsevt,evtf,hdr,map24gs,/gsmooth,xrange=[-1500,1500],yrange=[-1500,1500],/norm,shxy=[-30,20]
  plot_map,map24gs,/limb,grid_spacing=15,bot=1,gcolor=0,lcolor=0,/log,dmin=1e-4,dmax=1e2

  ;  ; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ;  ; Filter for grade 0 and grades 21-24 and then plot
  ;  filter_nsevt,evt,evtf0,grade=0
  ;  filter_nsevt,evt,evtf2124,grade=[21,22,23,24]
  ;  ; check filtering worked
  ;  print,unique(evtf0.grade)
  ;  print,unique(evtf2124.grade)
  ;
  ;  ; Load in a colour table for NuSTAR maps
  ;  loadct,39,/silent
  ;  clearplot
  ;  !p.multi=[0,2,1]
  ;  !p.charsize=0.8
  ;  window,2,xsize=500,ysize=250
  ;
  ;  ; Make and plot a map
  ;  map_nsevt,evtf0,hdr,mapg0,xrange=[-1500,-500],yrange=[-500,500]
  ;  plot_map,mapg0,/limb,grid_spacing=15,title='Grade 0'
  ;  map_nsevt,evtf2124,hdr,mapg2124,xrange=[-1500,-500],yrange=[-500,500]
  ;  plot_map,mapg2124,/limb,grid_spacing=15,title='Grade 21-24'
  ;
  ;  ; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ;  ; Filter for grade 0 and per det and then plot
  ;  filter_nsevt,evt,evtf00,grade=0,detid=0
  ;  filter_nsevt,evt,evtf01,grade=0,detid=1
  ;  filter_nsevt,evt,evtf02,grade=0,detid=2
  ;  filter_nsevt,evt,evtf03,grade=0,detid=3
  ;
  ;  loadct,39,/silent
  ;  clearplot
  ;  !p.multi=[0,2,2]
  ;  !p.charsize=0.8
  ;  window,3,xsize=500,ysize=500
  ;
  ;  ; Make and plot a map
  ;  map_nsevt,evtf00,hdr,mapg00,xrange=[-1450,-350],yrange=[-600,500],/gsmooth
  ;  map_nsevt,evtf01,hdr,mapg01,xrange=[-1450,-350],yrange=[-600,500],/gsmooth
  ;  map_nsevt,evtf02,hdr,mapg02,xrange=[-1450,-350],yrange=[-600,500],/gsmooth
  ;  map_nsevt,evtf03,hdr,mapg03,xrange=[-1450,-350],yrange=[-600,500],/gsmooth
  ;  plot_map,mapg00,/limb,grid_spacing=15,title='Grade 0, Det 0',/log,dmn=1,dmax=1e2
  ;  plot_map,mapg01,/limb,grid_spacing=15,title='Grade 0, Det 1',/log,dmn=1,dmax=1e2
  ;  plot_map,mapg02,/limb,grid_spacing=15,title='Grade 0, Det 2',/log,dmn=1,dmax=1e2
  ;  plot_map,mapg03,/limb,grid_spacing=15,title='Grade 0, Det 3',/log,dmn=1,dmax=1e2
  ;
  ;  ; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  stop
end