pro plot_xspec1apec,fname=fname,fiter=fiter,ylim=ylim,xlim=xlim,titin=titin,dir=dir,emscale=emscale

  ; Plot the output from a XSPEC fit with a single APEC thermal model for a single FPM
  ;
  ; Note: uses the plot procedure so should work with all version of IDL
  ;
  ;  fname   - Name of the XSPEC save files
  ;  fiter   - Need to manually give in the energy range you fitted over (2d array, def 2.5-5)
  ;  ylim    - Y range of output plot (2d array, def 1,2e3)
  ;  xlim    - X range of output plot (2d array. def 2.5,6)
  ;  titin   - Title of plot (str, def fname)
  ;  dir     - Where the files are
  ;  emscale - Value to scale EM by when labelling plot (def 1d-46)
  ;
  ; 22-Jan-2018 IGH
  ; 08-Oct-2018 IGH corrected clim/plter typo
  ; 17-Oct-2018 IGH improved handling/displaying of errors when none found
  ;                 added emscal option
  ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  if (n_elements(fname) ne 1) then fname='mod_apec1fit_fpma_cstat'
  if (n_elements(dir) ne 1) then dir=''
  if (n_elements(fiter) ne 2) then fiter=[2.5,5.0]
  if (n_elements(ylim) ne 2) then ylim=[1.5,2e3]
  if (n_elements(xlim) ne 2) then xlim=[2.0,6.0]
  if (n_elements(titin) ne 1) then titin=fname
  if (n_elements(emscale) ne 1) then emscale=1d-46

  ; To convert the APEC model params to MK and cm^-3
  kev2mk=0.0861733
  emfact=3.5557d-42

  ;  Load in the fits file containting the results, filenames and exposire time
  xft=mrdfits(dir+fname+'.fits',1,xfth)

  ; Theses variable names work for a single APEC model
  ; APEC norm is 1e-14/(4piD_A^2) *\int n_e n_p dV (https://heasarc.gsfc.nasa.gov/xanadu/xspec/manual/node133.html)
  t1=xft[0].kt1/kev2mk
  em1=xft[0].norm4/emfact

  ; Confidence of the parameters - two numbers as probably not symetric
  ; Mind that these are th 2.7\sigma (90%?) values not 1\sigma like OSPEX!
  t1_cr=xft[0].ekt1/kev2mk
  em1_cr=xft[0].enorm4/emfact

  print,'TMK -- Confidence range:',t1, ' -- ',t1_cr
  print,'EM -- Confidence range:',em1, ' -- ',em1_cr

  ;  Load in the plot data
  xout = read_ascii(dir+fname+'.txt', DATA_START=4)
  brkln=where(finite(xout.field1[0,*],/nan))

  ; The text file just lists the three plots  (counts, photons, ratio) on top of each other
  ; so find where one plot ends and another starts
  id1=0+indgen(brkln[0])
  id2=brkln[0]+indgen(brkln[1]-brkln[0]-1)+1
  id3=brkln[1]+indgen(n_elements(xout.field1[0,*])-brkln[1]-1)+1

  engs1=xout.field1[0,id1]
  de1=2*xout.field1[1,id1[0]]
  data1=xout.field1[2,id1]
  edata1=xout.field1[3,id1]
  totmod1=xout.field1[4,id1]
  mod11=totmod1

  ; Plot using the older procedures
  ; should work on all versions of idl

  @post_outset
  !p.multi=[0,2,1]
  loadct,0,/silent
  linecolors

  ct1=1

  set_plot,'ps'
  device, /encapsulated, /color, /isolatin1,/inches, $
    bits=8, xsize=4, ysize=5,file=dir+'fitx_'+fname+'.eps'

  tit_str=titin+' ('+string(xft[0].exposure,format='(f5.2)')+'s)'
  
  plot,engs1,data1,/ylog,/nodata,title=tit_str,yrange=ylim,ytickf='exp1',$
    xrange=xlim,xtitle='',ytitle='count s!U-1!N keV!U-1!N',position=[0.175,0.3,0.975,0.94],xtickformat='(a1)'
  id=where(data1 gt 0.,nid)
  for i=0,nid-1 do oplot,engs1[id[i]]+[-de1*0.5,de1*0.5],data1[id[i]]*[1,1],thick=2

  dtmin=(data1-edata1) >ylim[0]
  dtmax=(data1+edata1) <ylim[1]

  for i=0,nid-1 do oplot,engs1[id[i]]*[1,1],[dtmin[id[i]],dtmax[id[i]]],thick=2

  oplot,engs1,mod11,color=ct1,thick=4
  oplot,fiter[0]*[1,1],ylim,color=150,lines=2,thick=2
  oplot,fiter[1]*[1,1],ylim,color=150,lines=2,thick=2

  resd1=(data1-totmod1)/edata1
  bd=where(finite(resd1) ne 1)
  resd1[bd]=0
  plot,engs1,resd1,yrange=[-4.5,4.5],xrange=xlim,xtit='Energy [keV]',psym=10,thick=2,$
    position=[0.175,0.1,0.975,0.29],ytit='(Obs-Mod)/Err'
  oplot,xlim,[0,0],lines=1,thick=2

  if (t1_cr[0] ne 0.0) then tl=string((t1-t1_cr[0]),format='(f5.2)')  else tl='x.xx'
  if (t1_cr[1] ne 0.0) then tu=string((t1_cr[1]-t1 ),format='(f5.2)') else tu='x.xx'
  xyouts,5.5e3,11e3,string(t1,format='(f5.2)'),/device,color=ct1,align=1,chars=1.1
  xyouts,6.4e3,11e3,'!U+'+tu+'!N',/device,color=ct1,align=1,chars=1.1
  xyouts,6.4e3,11e3,'!D-'+tl+'!N',/device,color=ct1,align=1,chars=1.1
  xyouts,9.6e3,11e3,'!N MK ('+string(t1*kev2mk,format='(f5.2)')+' keV)',/device,color=ct1,align=1,chars=1.1
  
  if (em1_cr[0] ne 0.0) then eml=string((em1-em1_cr[0])*emscale,format='(f5.2)') else eml='x.xx'
  if (em1_cr[1] ne 0.0) then emu=string((em1_cr[1]-em1 )*emscale,format='(f5.2)') else emu='x.xx'
  xyouts,6.5e3,10e3,string(em1*emscale,format='(f5.2)'),/device,color=ct1,align=1,chars=1.1
  xyouts,7.4e3,10e3,'!U+'+emu+'!N',/device,color=ct1,align=1,chars=1.1
  xyouts,7.4e3,10e3,'!D-'+eml+'!N',/device,color=ct1,align=1,chars=1.1
  xyouts,9.6e3,10e3,'!Nx10!U'+string(alog10(1/emscale),format='(i2)')+'!Ncm!U-3!N',/device,color=ct1,align=1,chars=1.1


  device,/close
  set_plot, mydevice

end