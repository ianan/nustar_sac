;
; RMFREAD - read FITS RMF file and return structure
;
; PARAMETERS:
;
;  FILENAME - name of file on disk
;
;  RMF - upon return, a structure containing RMF data & metadata
;
;  STATUS - upon return, 0 for failure, 1 for success
;
;  ERRMSG - upon return, a descriptive error message string
;
;  COMPRESSED - a scalar string value,
;      'COMPRESSED' - return variable-length compressed data as-is
;      'DECOMPRESSED' - decompress variable length data
;      'AUTO' - only decompress variable-length data if practical
;
;
;  The returned variable RMF contains data and metadata.  It is a
;  structure.  The structure contents are:
;
;  RMF = {TYPE: 'RMF', $     ;; Descriptive name of data type
;         FILENAME: '', $    ;; Original input file name
;         AXIS_LABELS: ['',''], $ ;; Name of matrix axes
;         AXIS_UNITS: ['',''], $  ;; Units of matrix axes
;         UNITS: '', $            ;; Units of matrix values
;         NCBINS: 0L, $      ;; Number of PHA matrix elements
;         NEBINS: 0L, $      ;; Number of photon energy matrix elements
;         COMPRESSED: 0L,$   ;; Compressed? 1=yes, 0=no
;         ELIMITS: [0d,0d],$ ;; Photon energy limits of matrix
;         CLIMITS: [0L,0L],$ ;; PHA channel limits of matrix
;         CLASS: '', $       ;; HDUCLAS3 value
;         TELESCOP: '',$     ;; Observatory metadata
;         INSTRUME: '',$     ;; Observatory metadata
;         FILTER: '',$       ;; Observatory metadata
;         CHANTYPE: '',$     ;; 'PHA' or 'PI'
;         EBINTYPE: 0L, $    ;; N/D
;         EBOUNDS: PTR(),$   ;; 2xNCBINS Ebounds (min,max) array
;         EBINS: PTR(),$     ;; 2xNEBINS Photon energy bins ranges
;         GRPDATA: PTR(),$   ;; Grouping data for compressed matrix
;         DATA: PTR()}       ;; Actual spectral matrix data
;
;
; Originally from https://lost-contact.mit.edu/afs/physics.wisc.edu/home/craigm/lib/idl/spectral/rmfread.pro

pro rmfread, filename, rmf, errmsg=err, status=status, force=force, $
  compressed=class0, null=null

  status = 0

  if n_params() EQ 0 then begin
    message, 'USAGE: RMFREAD, FILENAME, RMF [, STATUS=, ERRMSG=, COMPRESSED= ]', /info
    message, "   COMPRESSED='COMPRESSED' 'DECOMPRESSED' or 'AUTO'", /info
    return
  endif

  if n_elements(class0) EQ 0 then class0 = 'AUTO'
  if keyword_set(null) then goto, NULL_OUTPUT

  ;; Open the EBOUNDS extension, which contains the energy boundaries of
  ;; each channel
  err = ''
  fxbopen, unit, filename, 'EBOUNDS', hh, errmsg=err
  if err NE '' then return

  ;; Read data values
  fxbreadm, unit, ['CHANNEL', 'E_MIN', 'E_MAX'], channels, emin, emax, $
    errmsg=err
  fxbclose, unit
  if err NE '' then return

  ;; Check header version first
  hduvers = strtrim(fxpar(hh, 'HDUVERS', count=ct),2)
  if ct EQ 0 then hduvers = strtrim(fxpar(hh, 'HDUVERS2'),2)
  if !err LT 0 AND NOT keyword_set(force) then begin
    err = 'ERROR: '+filename+' EBOUNDS does not contain a valid header version'
    return
  endif

  ;; Check EBOUNDS formatting, accounting for version changes
  rmfversn = strtrim(fxpar(hh, 'RMFVERSN'),2)
  hduclass = strtrim(fxpar(hh, 'HDUCLASS'),2)
  hduclas1 = strtrim(fxpar(hh, 'HDUCLAS1'),2)
  hduclas2 = strtrim(fxpar(hh, 'HDUCLAS2'),2)
  if (hduclass NE 'OGIP' OR hduclas1 NE 'RESPONSE' $
    OR hduclas2 NE 'EBOUNDS') then begin
    if ((double(hduvers) LT 1.2 OR rmfversn NE '1992a') $
      AND NOT keyword_set(force)) then begin
      EBOUNDS_HERROR:
      err = 'ERROR: '+filename+' does not contain a valid EBOUNDS extension'
      return
    endif
  endif

  ebounds = transpose([[emin],[emax]])

  ;; Open the MATRIX or SPECRESP MATRIX extension, which contains the
  ;; actual matrix
  err = ''
  fxbopen, unit, filename, 'SPECRESP MATRIX', hh, errmsg=err
  if err NE '' then begin
    err = ''
    fxbopen, unit, filename, 'MATRIX', hh, errmsg=err
  endif
  if err NE '' then return

  ;; Read matrix data
  fxbreadm, unit, ['ENERG_LO','ENERG_HI','N_GRP','F_CHAN','N_CHAN','MATRIX'], $
    elo, ehi, ngrp, fchan, nchan, matrix, errmsg=err
  fxbclose, unit
  if err NE '' then return

  ;; Check header version first
  hduvers = strtrim(fxpar(hh, 'HDUVERS', count=ct),2)
  if ct EQ 0 then hduvers = strtrim(fxpar(hh, 'HDUVERS2'),2)
  if !err LT 0 AND NOT keyword_set(force) then begin
    err = 'ERROR: '+filename+' EBOUNDS does not contain a valid header version'
    return
  endif

  ;; Check EBOUNDS formatting, accounting for version changes
  rmfversn = strtrim(fxpar(hh, 'RMFVERSN', count=ct),2)
  hduclass = strtrim(fxpar(hh, 'HDUCLASS'),2)
  hduclas1 = strtrim(fxpar(hh, 'HDUCLAS1'),2)
  hduclas2 = strtrim(fxpar(hh, 'HDUCLAS2'),2)
  if (hduclass NE 'OGIP' OR hduclas1 NE 'RESPONSE' $
    OR hduclas2 NE 'RSP_MATRIX') then begin
    if ((double(hduvers) LT 1.3 OR rmfversn NE '1992a') $
      AND NOT keyword_set(force)) then begin
      err = 'ERROR: '+filename+' does not contain a valid MATRIX extension'
      return
    endif
  endif

  ;; Read header values
  telescop = strtrim(fxpar(hh, 'TELESCOP'),2)
  instrume = strtrim(fxpar(hh, 'INSTRUME'),2)
  filter   = strtrim(fxpar(hh, 'FILTER'),2)
  chantype = strtrim(fxpar(hh, 'CHANTYPE', count=ct),2)
  if ct EQ 0 then chantype = 'PHA'
  class    = strtrim(fxpar(hh, 'HDUCLAS3',count=ct),2)
  if ct EQ 0 then class = 'UNKNOWN'
  nchans   = fxpar(hh, 'DETCHANS')

  if nchans NE n_elements(emin) then begin
    err = 'ERROR: EBOUNDS and MATRIX extensions in '+filename+' do not match'
    return
  endif

  cunit = ''  ;; Channels are unitless
  ;; Energy units
  col = fxbcolnum(unit, 'ENERG_LO')
  eunit = strtrim(fxpar(hh, 'TUNIT'+strtrim(col,2), count=ct),2)
  if ct EQ 0 then eunit = ''

  ;; Channel limits
  col = fxbcolnum(unit, 'F_CHAN')
  cmin = fxpar(hh, 'TLMIN'+strtrim(col,2), count=ct)
  if ct EQ 0 then cmin = 1
  climits = cmin + [0, nchans-1]

  ;; Matrix units
  col = fxbcolnum(unit, 'MATRIX')
  units = strtrim(fxpar(hh, 'TUNIT'+strtrim(col,2), count=ct),2)
  if ct EQ 0 then units = ''
  ;; for FULL/DETECTOR units are cm^2 default; for REDIST/UNKNOWN
  ;; the matrix is unitless

  ;; Construct final data

  ;; Expand variable-length data to a fixed-size array, then
  ;; concatenate them.
  vcol2arr, ngrp,  ngrp
  vcol2arr, fchan, fchan
  vcol2arr, nchan, nchan
  lchan = fchan + nchan - 1
  nrow1 = n_elements(ngrp)
  ncol1 = n_elements(fchan)/nrow1
  ncol2 = 1 + 2L*ncol1
  grpdata = make_array(value=ngrp(0)*0, ncol2, nrow1)
  grpdata(0:0,*) = ngrp
  grpdata(1:ncol1,*) = fchan
  grpdata(ncol1+1:*,*) = lchan

  nebins = n_elements(elo)
  ebins = transpose([[elo],[ehi]])
  elimits = [min(ebins), max(ebins)]

  vrmf2arr, matrix, nchans, ngrp, fchan, nchan, rmf_arr, $
    compressed=class0, status=rstatus

  axis_labels = ['CHANNEL', 'ENERGY']
  axis_units  = [cunit, eunit]

  if rstatus EQ 0 then begin
    compressed = 1
    rmf_arr = temporary(matrix)
  endif else begin
    compressed = 0
    matrix = 0
    rmf_arr = transpose(rmf_arr)
    axis_labels = [axis_labels(1), axis_labels(0)]
    axis_units  = [axis_units(1),  axis_units(0) ]
  endelse

  if keyword_set(null) then begin
    NULL_OUTPUT:
    ;; Populate the array with null data
    axis_labels = ['CHANNEL', 'ENERGY']
    axis_units  = ['', '']
    nchans = 0L & nebins = 0L & compressed = 0
    elimits = [0., 0]
    climits = [0L, 0]
    class = 'NULL'
    telescop = '' & instrume = '' & filter = '' & chantype = 'PHA'
  endif
  ebintype = -1L

  pebounds = ptr_new(ebounds, /no_copy)
  pebins   = ptr_new(ebins, /no_copy)
  pmatrix  = ptr_new(rmf_arr, /no_copy)
  pgrpdata = ptr_new(grpdata, /no_copy)

  ;; Construct output structure
  rmf = {spluxor_rmf, type: 'RMF', filename: filename(0), $
    axis_labels: axis_labels, axis_units: axis_units, units: units, $
    ncbins: nchans, nebins: nebins, compressed: compressed, $
    elimits: elimits, climits: climits, $
    class: class, telescope: telescop, instrument: instrume, $
    filter: filter, chantype: chantype, ebintype: ebintype, $
    ebounds: pebounds, ebins: pebins, grpdata: pgrpdata, data: pmatrix $
  }

  status = 1
  return
end