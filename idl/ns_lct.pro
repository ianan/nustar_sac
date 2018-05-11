pro ns_lct

  ; A colour table the can use for the NuSTAR maps
  ; Just a reverse Brewster one from with IDL, with some tweaks for top and bottom colours
  ; 
  ; 11-May-2018 IGH
  ; 
  
  loadct,74,/silent
  reverse_ct
  tvlct,r,g,b,/get
  r[0]=0
  g[0]=0
  b[0]=0
  r[1]=255
  g[1]=255
  b[1]=255
  r[255]=255
  g[255]=255
  b[255]=255
  tvlct,r,g,b

end  
  