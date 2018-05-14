pro load_nschu,fname,chustr

  ; Load in a NuSTAR chu (camera head unit) file
  ;
  ; Input
  ;   fname      - Name of the chu file (full directory listing)
  ; Output
  ;   chu        - The CHU structure
  ; 
  ; Based on code from BG/KKM 
  ; https://github.com/NuSTAR/nustar_solar/blob/master/depricated/solar_mosaic_20150429/read_chus.pro
  ;
  ; 11-May-2018 IGH
  ; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ;

  if (n_elements(fname) eq 0) then fname='~/data/heasarc_nustar/ns_20170321/20210015001/hk/nu20210015001_chu123.fits'

  for chunum= 1, 3 do begin
    chu = mrdfits(fname, chunum,/silent)
    maxres = 20 ;; [arcsec] maximum solution residual
    qind=1 ; From KKM code...
    if chunum eq 1 then begin
      mask = (chu.valid EQ 1 AND $          ;; Valid solution from CHU
        chu.residual LT maxres AND $  ;; CHU solution has low residuals
        chu.starsfail LT chu.objects AND $ ;; Tracking enough objects
        chu.(qind)(3) NE 1)*chunum^2       ;; Not the "default" solution
    endif else begin
      mask += (chu.valid EQ 1 AND $            ;; Valid solution from CHU
        chu.residual LT maxres AND $    ;; CHU solution has low residuals
        chu.starsfail LT chu.objects AND $ ;; Tracking enough objects
        chu.(qind)(3) NE 1)*chunum^2       ;; Not the "default" solution
    endelse
  endfor

  chutime=anytim(chu.time+anytim('01-Jan-2010'))
  chumask=mask

  ; Set up the y labelling
  ;; mask = 1, chu1 only
  ;; mask = 4, chu2 only
  ;; mask = 9, chu3 only
  ;; mask = 5, chu12
  ;; mask = 10 chu13
  ;; mask = 13 chu23
  ;; mask = 14 chu123

  ; Change the KKM mask setup into something a bit easier to plot
  ; Make deafult value out of range of real values
  newmask=intarr(n_elements(chumask))-5
  id1=where(chumask eq 1,nid1)
  if (nid1 gt 0) then newmask[id1]=1
  id2=where(chumask eq 4,nid2)
  if (nid2 gt 0) then newmask[id2]=2
  id12=where(chumask eq 5,nid12)
  if (nid12 gt 0) then newmask[id12]=3
  id3=where(chumask eq 9,nid3)
  if (nid3 gt 0) then newmask[id3]=4
  id13=where(chumask eq 10,nid13)
  if (nid13 gt 0) then newmask[id13]=5
  id23=where(chumask eq 13,nid23)
  if (nid23 gt 0) then newmask[id23]=6
  id123=where(chumask eq 14,nid123)
  if (nid123 gt 0) then newmask[id123]=7
    
  chustr={time:chutime,mask:newmask,lab:[' ','1','2','12','3','13','23','123',' ']}

 
end