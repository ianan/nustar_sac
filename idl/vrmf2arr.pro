pro vrmf2arr, vrmf, ncols, ngrp, fchan, nchan, arr, status=status, $
              compressed=class

  status = 0
  sz = size(vrmf)
  if sz(sz(0)+1) NE 8 then begin
      arr = temporary(vrmf)
      status = 1
      return
  endif

  nrows = vrmf.n_rows
  type  = vrmf.type

  if n_elements(class) EQ 0 then class = 'AUTO'
  if class EQ 'COMPRESSED' then return
  
  if class(0) EQ 'AUTO' then begin
      nmax  = long(nrows)*long(ncols)
      fract = float(vrmf.n_elements)/nmax
      if nmax LT 2L^19 then goto, DECOMPRESS
      if nmax GT 2L^23 then return
      npow = alog10(nmax)/alog10(2.) - 18
      if (1.-fract) GT 1./npow then return
  endif

  DECOMPRESS:
  ii = vrmf.indices
  nc = ii(1:*)-ii
  arr = make_array(ncols, nrows, type=type)
  for i = 0, nrows-1 do begin
      if nc(i) GT 0 then begin
          row = vrmf.data(ii(i):ii(i+1)-1)
          jj = 0L
          for j = 0, ngrp(i)-1 do begin
              arr(fchan(j,i),i) = row(jj+lindgen(nchan(j,i)))
              jj = jj + nchan(j,i)
          endfor
      endif
  endfor

  vrmf = 0
  status = 1
end
