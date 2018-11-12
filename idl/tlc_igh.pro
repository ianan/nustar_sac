pro tlc_igh,test=test,oldtest=oldtest

  ; Some useful combination of colours for doing line plots
  ;
  ; Usage, to load them just do
  ;     tlc_igh
  ;        if you want to see the colours you are loading
  ;     tlc_igh,/test
  ;
  ; 21-Nov-12 IGH
  ; 28-Apr-17 IGH      - based from older tube_line_colors.pro
  ; 25-Apr-18 IGH      - AIA lct ones and improved test plot
  ; 27-Apr-18 IGH      - IRIS lct ones
  ;
  ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ;
  ; Colours and sources:
  ; 1-12    tubeline colors via tfl http://www.tfl.gov.uk/assets/downloads/corporate/tfl-colour-standard-issue03.pdf
  ; 13-16   fainter byrg
  ; 17-20   stronger byrg
  ; 21-23   just bgr
  ; 25-33   colour blind friendly from https://personal.sron.nl/~pault/
  ; 51-68   nice one from http://projects.susielu.com/viz-palette
  ; 101-110 for AIA channels (94,131,171,193,211,355,fe18,304,1600,1700)
  ; 120-128 for IRIS channels
  ; 255     white
  ;
  ;
  ;  Everything else is black rgb(0,0,0)
  ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  rrr=bytarr(256)
  ggg=bytarr(256)
  bbb=bytarr(256)

  rrr[255]=255
  ggg[255]=255
  bbb[255]=255

  tcs=[$

    ; tubelines 1-12
    [  0,  0,  0],$ ;Northern
    [227, 32, 23],$ ;Central
    [  0, 34,136],$ ;Piccadilly
    [  0,120, 42],$ ;District
    [232,106, 16],$ ;Overground
    [  0,160,226],$ ;Victoria
    [215,153,175],$ ;Hammersmith & City
    [118,208,189],$ ;Waterloo & City
    [117, 16, 86],$ ;Metropolitan
    [255,206,  0],$ ;Circle
    [134,143,152],$ ;Jubilee
    [137, 78, 36],$ ;Bakerloo
    ;  [  0,175,173],$ ;DLR not included as similar to Waterloo & City
    [  0,189, 25], $ ;Tramlink
    ; some other primary ones

    ; some fainter byrg 13-16
    [  88,149, 201],[  246,203,100] ,[238,74,88] ,[128,193,121],$
    ; some stonger byrg 17-20
    [ 0,132,209],[  255,211,32] ,[197,0,11] ,[0,128,0],$
    ; just primary bgr 21-23
    [ 0,0,255],[  255,0,0] ,[0,255,0]$

    ]

  ; via https://personal.sron.nl/~pault/ colour blind friendly
  rn=[0,238,51,153,17,238,102,204,255,119,0];[0,0,34,204,238,170,68,102,187];[51, 136, 68, 17, 153, 221, 204, 136, 170]
  gn=[0,119,108,34,170,51,170,204,238,119,0];[0,0,136,187,102,51,119,204,187];[34, 204, 170, 119, 153, 204, 102, 34, 68]
  bn= [0,34,170,136,153,51,85,85,51,119,0];[0,0,51,68,119,119,170,238,187];[136, 238, 153, 51, 51, 119, 119, 85, 153]
  nct=n_elements(tcs[0,*])
  nctn=n_elements(rn)
  tcols=intarr(3,nct+nctn)
  tcols[*,0:nct-1]=tcs

  tcols[0,nct:nct+nctn-1]=rn
  tcols[1,nct:nct+nctn-1]=gn
  tcols[2,nct:nct+nctn-1]=bn


  for i=0, n_elements(tcols[0,*])-1 do begin
    rrr[i]=tcols[0,i]
    ggg[i]=tcols[1,i]
    bbb[i]=tcols[2,i]
  endfor

  ; For AIA lct via make_aia_lct.pro
  ;  (94,131,171,193,211,355,fe18,304,1600,1700)
  ra=[0,25,0,231, 142, 123,  25,  55, 173, 134, 174]
  ga=[0,103,185, 160,  80 , 60 , 80 ,153 ,  0, 134 ,120]
  ba=[0 ,80,173,  0 , 25 , 86 ,142, 197 ,  0,  56 ,120]

  rrr[100:110]=ra
  ggg[100:110]=ga
  bbb[100:110]=ba

  rrnn=[127,  196,  187,  87,  179,  6,  218,  29,  101,  8,  123,  121,  152,  245,  252,  224,  237,  176]
  ggnn=[67,  174,  15,  107,  51,  139,  136,  179,  113,  142,  148,  235,  206,  235,  177,  195,  197,  222]
  bbnn=[179,  10,  164,  210,  29,  4,  46,  144,  20,  178,  202,  208,  91,  89,  83,  172,  255,  223]
  rrr[51:68]=rrnn
  ggg[51:68]=ggnn
  bbb[51:68]=bbnn


  ;  IRIS ones via iris_lct.pro
  wii= ['SJI_5000W', 'SJI_2832', 'SJI_2796', 'SJI_1600W', 'SJI_1400', 'SJI_1330', $
    'FUV', 'NUV', 'SJI_NUV']
  nwii=n_elements(wii)
  ;  rii=bytarr(nwii)
  ;  gii=rii
  ;  bii=rii
  ;  for iii=0,nwii-1 do begin
  ;    iris_lct,wii[iii],rit,git,bit
  ;    rii[iii]=rit[120]
  ;    gii[iii]=git[120]
  ;    bii[iii]=bit[120]
  ;  endfor

  rii=[174, 120, 174, 174, 154, 174, 174, 174, 120]
  gii=[174, 120, 134, 120,  56,  32,  32, 134, 120]
  bii=[120,  56,  56, 120,  29,   0,   0,  56, 120]
  
  rrr[120:120+nwii-1]=rii
  ggg[120:120+nwii-1]=gii
  bbb[120:120+nwii-1]=bii

  ; set the colours to the table
  tvlct,rrr,ggg,bbb

  ; plot them to screen
  if keyword_set(oldtest) then begin
    clearplot
    !p.multi=[0,3,1]
    !y.style=17
    plot,[0,1],[0,n_elements(tcols[0,*])],/nodata,xtickf='(a1)',chars=2
    for i=0, n_elements(tcols[0,*])-1 do oplot, [0,1],i*[1,1],color=i,thick=20
    plot,[0,1],[51,68],/nodata,xtickf='(a1)',chars=2,yticks=17
    for i=51, 68 do oplot, [0,1],i*[1,1],color=i,thick=30
    plot,[0,1],[100,110],/nodata,xtickf='(a1)',chars=2,tit='AIA',yticks=10
    for i=100, 110 do oplot, [0,1],i*[1,1],color=i,thick=50
  endif

  ; plot them to screen
  if keyword_set(test) then begin
    clearplot
    !p.font=0
    !x.style=17
    !y.style=17
    prgb=fltarr(256)
    for i=0,255 do prgb[i]=rrr[i]+ggg[i]+bbb[i]
    id=where(prgb gt 0,nid)
    window,0,xsize=400,ysize=800
    plot,[0,1.15],[0,nid],/nodata,xtickf='(a1)',chars=1,position=[0,0,1,1]
    for i=0, nid-1 do begin
      oplot, [0,1],i*[1,1]+0.2,color=id[i],thick=20
      xyouts, 1.03,i,string(id[i],format='(i3)'),color=id[i],/data
    endfor
  endif

  return
end
