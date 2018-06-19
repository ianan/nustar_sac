pro plotf_ospex_ns_fvth,f,xlim=xlim,outname=outname,ylim=ylim,outdir=outdir

  ; Plot the output sturcture from the OSPEX single thermal fit in ospex_ns_fvth.pro
  ;
  ; Note: uses the plot function objects that only really work in recent IDL >8.3 (?)
  ;
  ;  Options
  ;     xlim   -   2d array of energy range to plot over
  ;     outname -   postfixname to figure output (default fname from fit stucture)
  ;     outdir  -   output directory for the figure
  ;     ylim    -   2d array of yrange to plot over
  ;
  ; 15-Nov-2017 IGH
  ; 14-May-2018 IGH   Renamed plter to xlim
  ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  
  w=window(dimensions=[350,450],/buffer)
  tkev=0.08617
  mrg=0.2
  if (n_elements(ylim) ne 2) then ylim=[0.5*min(f.cnt_flx[where(f.cnt_flx gt 0)]),2*max(f.cnt_flx)]

  flxmin=(f.cnt_flx-f.ecnt_flx) >ylim[0]
  flxmax=(f.cnt_flx+f.ecnt_flx) <ylim[1]

  id=where(f.cnt_flx gt 0.,nid)

  p0=plot(f.engs,f.cnt_flx,/ylog,/nodata,lines=6,symbol='d',title=f.fpmid+' '+anytim(f.timer[0],/yoh,/trunc),$
    yrange=ylim,xrange=xlim,ytickunits='Scientific',sym_thick=1,sym_size=1,font_size=11,$
    xtitle='',ytitle='count s!U-1!N keV!U-1!N',position=[0.175,0.3,0.975,0.94],/current,xtickformat='(a1)',location=[0,0])

  for i=0,nid-1 do !null=plot(f.engs[id[i]]*[1,1],[flxmin[id[i]],flxmax[id[i]]],thick=1,/over,/current)
  for i=0,nid-1 do !null=plot(f.eengs[*,id[i]],f.cnt_flx[id[i]]*[1,1],thick=1,/over,/current)

  ct1='firebrick'
  plmod=plot(f.engs,f.cnt_flx_mod,color=ct1,thick=2,/over,/current)
  !null=plot(f.eranfit[0]*[1,1],ylim,color='gray',lines=2,/over,/current)
  !null=plot(f.eranfit[1]*[1,1],ylim,color='gray',lines=2,/over,/current)

  resd=(f.cnt_flx-f.cnt_flx_mod)/f.ecnt_flx
  bd=where(finite(resd) ne 1)
  resd[bd]=0
  pres=plot(f.engs,resd,$
    yrange=[-4.5,4.5],xrange=xlim,xtit='Energy [keV]',/stair,thick=1,$
    position=[0.175,0.08,0.975,0.28],ytit='(Obs-Mod)/Err',/current,font_size=11)
  !null=plot(xlim,[0,0],lines=1,/current,/over)

  !null=text(320,390,string(f.parm[1]/tkev,format='(f4.1)')+'$\pm$'+$
    ;    string(f.parmerr[1]/tkev,format='(f4.2)')+' MK ('+string(f.parm[1],format='(f4.2)')+' keV)',$
      string(f.parmerr[1]/tkev,format='(f4.2)')+' MK',$
    /device,color=ct1,align=1,font_size=11)
  !null=text(320,370,string(f.parm[0]*1e3,format='(f4.1)')+'$\pm$'+string(f.parmerr[0]*1e3,format='(f4.2)')+$
    '$\times$10!U46!N cm!U-3!N',/device,color=ct1,align=1,font_size=11)
  !null=text(320,350,'$\chi^2=$ '+strcompress(string(f.chisq,format='(f5.1)'),/rem),/device,color=ct1,align=1,font_size=11)

  if (n_elements(outname) ne 1) then outname=f.fname
  if (n_elements(outdir) ne 1) then outdir=''

  w.save,outdir+'fitvth_'+outname+'.pdf',page_size=w.dimensions/100.
  w.close

end