pro example_nsspec_model

  ; Comparison of some NuSTAR spectral data and the models in sswidl
  ;
  ; Uses the NuSTAR data from Kris Cooper:
  ;
  ;
  ; 31-Mar-2020 IGH   Started
  ;
  ; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  ;;; Load the spectral information using my idl code

  fnamea='nu80415201001A06_chu2_S_cl_grade0_sr'
  fnameb='nu80415201001B06_chu2_S_cl_grade0_sr'

  load_nsspec, fnamea,sa,spcer=[1.6,12]
  save,file='sa_test.dat',sa
  ;  restore,file='sa_test.dat'
  load_nsspec, fnameb,sb,spcer=[1.6,12]
  save,file='sb_test.dat',sb
  ;  restore,file='sb_test.dat'

  ;;; Just get rid of the first channel weirdness
  sa.counts[0]=1/0.
  sb.counts[0]=1/0.
  de=sa.engm[1]-sa.engm[0]

  ;;; Model thermal spectrum
  mk2kev=0.08617
  em=1.07d46
  tmk=4.13
  modf=f_vth( sa.enge, [em*1d-49, tmk*mk2kev, 1.] )
  ; Convert this to a counts flux spectrum
  modca = sa.arf * (sa.rmf # modf)
  modcb = sb.arf * (sb.rmf # modf)

  ;;; Plot it all
  ;  @post_outset
  ;  figname='nsspec_model.eps'
  ;  set_plot,'ps'
  ;  device, /encapsulated, /color, /isolatin1,/inches, $
  ;    bits=8, xsize=10, ysize=6,file=figname

  ctp=4
  !p.multi=[0,3,2]
  !p.charsize=1.5
  !p.thick=1
  tlc_igh
  plot_oo,sa.engm,sa.counts,psym=1,yrange=[0.5,1e4],xrange=[1,10],$
    xtitle='Energy [keV]',ytitle='counts',ytickf='exp1',title='FPMA',syms=0.5
  plot_oo,sa.engm,sa.counts/sa.livetime/de,psym=1,yrange=[0.3,5e3],xrange=[1,10],$
    xtitle='Energy [keV]',ytitle='counts/s/keV',ytickf='exp1',title='FPMA',syms=0.5
  oplot,sa.engm,modca,color=ctp,thick=4;,psym=10
  plot_oo,sa.engm,modf,yrange=[1e-4,1e4],xrange=[1,10],$
    xtitle='Energy [keV]',ytitle='photons/s/keV/cm2',/nodata,ytickf='exp1'
  oplot,sa.engm,modf,color=ctp,thick=4;,psym=10

  plot_oo,sb.engm,sb.counts,psym=1,yrange=[0.5,1e4],xrange=[1,10],$
    xtitle='Energy [keV]',ytitle='counts',ytickf='exp1',title='FPMB',syms=0.5
  plot_oo,sb.engm,sb.counts/sb.livetime/de,psym=1,yrange=[0.3,5e3],xrange=[1,10],$
    xtitle='Energy [keV]',ytitle='counts/s/keV',ytickf='exp1',title='FPMB',syms=0.5
  oplot,sb.engm,modcb,color=ctp,thick=4;,psym=10
  plot_oo,sb.engm,modf,yrange=[1e-4,1e4],xrange=[1,10],$
    xtitle='Energy [keV]',ytitle='photons/s/keV/cm2',/nodata,ytickf='exp1'
  oplot,sb.engm,modf,color=ctp,thick=4;,psym=10

  xyouts,9,1e3,string(tmk,format='(f5.2)'),color=ctp,/data,align=1,chars=1
  xyouts,9,1e2,string(em,format='(e8.2)'),color=ctp,/data,align=1,chars=1

  ;  device,/close
  ;  set_plot, mydevice
  ;
  ;  convert_eps2pdf,figname,/del

  stop
end