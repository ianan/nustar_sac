pro arfread, filename, arf, errmsg=err, status=status, force=force, $
             null=null

  status = 0
  if keyword_set(null) then goto, NULL_OUTPUT

  ;; Open the MATRIX or SPECRESP MATRIX extension, which contains the
  ;; actual matrix
  err = ''
  fxbopen, unit, filename, 'SPECRESP', hh, errmsg=err
  if err NE '' then return

  ;; Read matrix data
  fxbreadm, unit, ['ENERG_LO','ENERG_HI','SPECRESP'], elo, ehi, resp, errmsg=err
  fxbclose, unit
  if err NE '' then return
  
  ;; Check header version first
  hduvers = strtrim(fxpar(hh, 'HDUVERS', count=ct),2)
  if ct EQ 0 then hduvers = strtrim(fxpar(hh, 'HDUVERS2'),2)
  if !err LT 0 AND NOT keyword_set(force) then begin
      err ='ERROR: '+filename+' SPECRESP does not contain a valid header version'
      return
  endif

  ;; Check EBOUNDS formatting, accounting for version changes
  arfversn = strtrim(fxpar(hh, 'ARFVERSN', count=ct),2)
  hduclass = strtrim(fxpar(hh, 'HDUCLASS'),2)
  hduclas1 = strtrim(fxpar(hh, 'HDUCLAS1'),2)
  hduclas2 = strtrim(fxpar(hh, 'HDUCLAS2'),2)
  if (hduclass NE 'OGIP' OR hduclas1 NE 'RESPONSE' $
      OR hduclas2 NE 'SPECRESP') then begin
      if ((double(hduvers) LT 1.1 OR arfversn NE '1992a') $
          AND NOT keyword_set(force)) then begin
          err = 'ERROR: '+filename+' does not contain a valid SPECRESP extension'
          return
      endif
  endif

  ;; Read header values
  telescop = strtrim(fxpar(hh, 'TELESCOP'),2)
  instrume = strtrim(fxpar(hh, 'INSTRUME'),2)
  filter   = strtrim(fxpar(hh, 'FILTER'),2)

  col = fxbcolnum(unit, 'ENERG_LO')
  eunit = strtrim(fxpar(hh, 'TUNIT'+strtrim(col,2), ct),2)
  if ct EQ 0 then eunit = ''

  ebins = transpose([[elo],[ehi]])
  elimits = [min(ebins), max(ebins)]
  nebins = n_elements(elo)
  class = 'FULL'

  if keyword_set(null) then begin
      NULL_OUTPUT:
      eunit = ''
      nebins = 0L
      elimits = [0., 0.]
      class = 'NULL'
      telescop = '' & instrume = '' & filter = ''
  endif

  pointer_create, pebins, value=ebins, /no_copy
  pointer_create, presp,  value=resp,  /no_copy

  axis_labels = ['ENERGY']
  axis_units  = [eunit]
  ebintype    = -1L

  arf = {spluxor_arf, type: 'ARF', filename: filename(0), $
         axis_labels: axis_labels, axis_units: axis_units, $
         nebins: nebins, elimits: elimits, $
         class: class, telescope: telescop, instrument: instrume, $
         filter: filter, ebintype: ebintype, $
         ebins: pebins, data: presp $
        }

  status = 1
  return
end
