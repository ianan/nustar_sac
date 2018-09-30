pro ns_lct

  ; A colour table the can use for the NuSTAR maps
  ; Just a reverse Brewster one from with IDL, with some tweaks for top and bottom colours
  ; 
  ; 11-May-2018 IGH
  ; 29-Sep-2018 IGH Added in a grey to index 1, white now 2 and 255
  ; 
  ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  
  loadct,74,/silent
  reverse_ct
  tvlct,r,g,b,/get
  r[0]=0
  g[0]=0
  b[0]=0
  r[1]=130
  g[1]=130
  b[1]=130
  r[2]=255
  g[2]=255
  b[2]=255
  r[255]=255
  g[255]=255
  b[255]=255
  tvlct,r,g,b

end  
  