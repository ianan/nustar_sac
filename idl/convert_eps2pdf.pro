pro convert_eps2pdf,fname,del=del

  ; File name of eps to convert to pdf
  ; option to delete eps after cponversion
  ;
  ;  Works on macos/linux when ps2pdf installed (gs?)
  ;
  ; Jun-2018 IGH
  ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~`

  
  ; By default will just output pdf in working dir
  ; remove the eps ending of the fig name
  id=strpos(fname,'.eps')

  ; only run if one .eps file end found
  if (id gt 0 and n_elements(id) eq 1) then begin
    outpdf=strmid(fname,0,id)+'.pdf'

    spawn,'ps2pdf -dPDFSETTINGS=/prepress -sEPSCrop ' + fname + ' '+outpdf
    if keyword_set(del) then spawn, 'rm -f '+fname

  endif


end