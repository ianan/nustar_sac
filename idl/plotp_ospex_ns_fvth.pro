pro plotp_ospex_ns_fvth,f,xlim=xlim,outname=outname,ylim=ylim

  ; Plot the output sturcture from the OSPEX single thermal fit in ospex_ns_fvth.pro
  ;
  ; Note: uses the plot procedure so should work with all version of IDL
  ;
  ;  options
  ;     xlim    -   2d array of xrange to plot over
  ;     outname -   postfixname to figure output (default fname from fit stucture)
  ;     ylim    -   2d array of yrange to plot over
  ;
  ; 15-Nov-2017 IGH
  ; 14-May-2017 IGH   Reanmed plter to xlim
  ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  w=window(dimensions=[350,450],/buffer)
  tkev=0.08617
  mrg=0.2
  if (n_elements(ylim) ne 2) then ylim=[0.5*min(f.cnt_flx[where(f.cnt_flx gt 0)]),2*max(f.cnt_flx)]

  flxmin=(f.cnt_flx-f.ecnt_flx) >ylim[0]
  flxmax=(f.cnt_flx+f.ecnt_flx) <ylim[1]

  id=where(f.cnt_flx gt 0.,nid)

  if (n_elements(outname) ne 1) then outname=f.fname

  @post_outset
  !p.multi=[0,2,1]
  loadct,0,/silent
  linecolors

  ct1=13

  set_plot,'ps'
  device, /encapsulated, /color, /isolatin1,/inches, $
    bits=8, xsize=4, ysize=5,file='fitvth_'+outname+'.eps'

  plot,f.engs,f.cnt_flx,/ylog,/nodata,title=f.fpmid+' '+anytim(f.timer[0],/yoh,/trunc),yrange=ylim,ytickf='exp1',$
    xrange=xlim,xtitle='',ytitle='count s!U-1!N keV!U-1!N',position=[0.175,0.3,0.975,0.94],xtickformat='(a1)'

  for i=0,nid-1 do oplot,f.engs[id[i]]*[1,1],[flxmin[id[i]],flxmax[id[i]]],thick=2
  for i=0,nid-1 do oplot,f.eengs[*,id[i]],f.cnt_flx[id[i]]*[1,1],thick=2

  oplot,f.engs,f.cnt_flx_mod,color=ct1,thick=4
  oplot,f.eranfit[0]*[1,1],ylim,color=150,lines=2,thick=2
  oplot,f.eranfit[1]*[1,1],ylim,color=150,lines=2,thick=2

  resd=(f.cnt_flx-f.cnt_flx_mod)/f.ecnt_flx
  bd=where(finite(resd) ne 1)
  resd[bd]=0
  plot,f.engs,resd,yrange=[-4.5,4.5],xrange=xlim,xtit='Energy [keV]',psym=10,thick=2,$
    position=[0.175,0.1,0.975,0.29],ytit='(Obs-Mod)/Err'
  oplot,xlim,[0,0],lines=1,thick=2

  xyouts,9.6e3,11e3,string(f.parm[1]/tkev,format='(f4.1)')+string(177b)+string(f.parmerr[1]/tkev,format='(f4.2)')+' MK',$
    /device,color=ct1,align=1,chars=1.1
  xyouts,9.6e3,10.2e3,string(f.parm[0]*1e3,format='(f4.1)')+string(177b)+string(f.parmerr[0]*1e3,format='(f4.2)')+$
    'x10!U46!Ncm!U-3!N',/device,color=ct1,align=1,chars=1.1
  xyouts,9.6e3,9.4e3,'!Mc!3!U2!N= '+strcompress(string(f.chisq,format='(f5.1)'),/rem),/device,color=ct1,align=1,chars=1.1

  device,/close
  set_plot, mydevice

end