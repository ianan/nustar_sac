;
; VCOL2ARR - transform a variable length structure into a 2D matrix
;            The input is the data of a variable length column.  Use
;            FXBREADM to read the data, and the result is a structure
;            which has the data, but it's not in array format.  Use
;            this procedure to transform to an array.  
;
;            The output is a 2D array = ARRAY(NCOLS,NROWS) where
;              * NCOLS is the maximum number of elements in a row
;              * NROWS is the number of table rows 
;            The array is filled for row J starting at ARR(0,J).
;            Any unfilled elements are set to zero.
;
; PARAMETERS:
;
;  VCOL - (input) structure produced by FXBREADM after reading variable length
;         column
;
;  ARR - (output) 2D array.
;
;  Originally from https://lost-contact.mit.edu/afs/physics.wisc.edu/home/craigm/lib/idl/util/vcol2arr.pro
;
;
pro vcol2arr, vcol, arr

  ;; Non-structures are returned immediately
  sz = size(vcol)
  if sz(sz(0)+1) NE 8 then begin
      arr = temporary(vcol)
      if sz(0) EQ 1 then arr = reform(arr, /overwrite, 1, sz(1))
      return
  endif

  tn = tag_names(vcol)
  wh = where(tn EQ 'VARICOL', ct)
  if ct EQ 0 then $
    message, 'ERROR: VCOL is not a variable-length array structure'

  ;; Extract the relevant information from the structure before
  ;; destroying it.
  type = vcol.type
  ii = vcol.indices
  nc = ii(1:*) - ii
  ncols = max(nc)
  nrows = vcol.n_rows
  mm = (temporary(vcol)).data

  ;; Make new array
  arr = make_array(ncols, nrows, type=type)

  ;; Fill new array, either by row or by column, whichever uses fewer
  ;; iterations.  Either way produces the same results.
  if ncols LT nrows then begin
      for i = 0, ncols-1 do begin
          wh = where(nc GT i)
          arr(i,wh) = mm(ii(wh)+i)
      endfor
  endif else begin
      for i = 0, nrows-1 do if nc(i) GT 0 then arr(0,i) = mm(ii(i):ii(i+1)-1)
  endelse
  
end