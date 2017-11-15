PRO POINTER_VALUE, POINTER, VALUE, SET=SET, NO_COPY=NO_COPY, UNSET=UNSET

;+
; NAME:
;    POINTER_VALUE
;
; PURPOSE:
;    Get or set the value of an existing pointer.
;
;    This routine uses pointers if run under IDL5 or higher,
;    and handles if run under IDL4.
;
; CATEGORY:
;    Pointers
;
; CALLING SEQUENCE:
;    POINTER_VALUE, POINTER, VALUE
;
; INPUTS:
;    POINTER    Pointer variable
;    VALUE      When setting a pointer value, the variable which is to be
;               assigned to the pointer.
;
; OPTIONAL INPUTS:
;    None.
;
; INPUT KEYWORD PARAMETERS:
;    SET        If set, causes the pointer value to be set
;               (default is to get the pointer value).
;    NO_COPY    If set, the source value is attached directly to the
;               destination value, and the source value becomes undefined
;               (default is to copy the source value to the destination
;               value, without affecting the source value).
;
; OUTPUT KEYWORD PARAMETERS:
;    None.
;
; OUTPUTS:
;    VALUE      When getting a pointer value (the default), a named variable
;               in which the value is returned.
;
; OPTIONAL OUTPUTS:
;    None.
;
; COMMON BLOCKS:
;    None.
;
; SIDE EFFECTS:
;
; RESTRICTIONS:
;    POINTER must be a valid pointer.
;
;    See also POINTER_CREATE, POINTER_FREE, POINTER_VALID.
;
; EXAMPLE:
;
; ;Create a new pointer, set a value, and then get the value
;
; pointer_create, ptr
; pointer_value, ptr, dist(256), /set
; pointer_value, ptr, val
; help, val
;
; MODIFICATION HISTORY:
; Liam.Gumley@ssec.wisc.edu
; Use FORWARD_FUNCTION, CM, 26 Jun 1999
;-

;- Check arguments

np = n_params()
if np LT 1 then message, 'Usage: POINTER_VALUE, POINTER, VALUE'
if n_elements(pointer) eq 0 then message, 'Argument POINTER is undefined'
if n_elements(pointer) gt 1 then message, 'Argument POINTER must be a scalar'

if keyword_set(unset) then begin
    value = 0
    value1 = temporary(value)
    set = 1
    np = 2
endif

if np ne 2 then message, 'Usage: POINTER_VALUE, POINTER, VALUE'

;- Check keywords

if not keyword_set(set) then set=0 else set=1
if not keyword_set(no_copy) then no_copy=0 else no_copy=1

;- Check pointer validity

forward_function pointer_valid
if not pointer_valid(pointer(0)) then message, 'Argument POINTER is invalid'


;- Get or set the pointer
    
version = long(!version.release)
case 1 of
  version ge 5 : pointer_setgetv5, pointer(0), value, set=set, no_copy=no_copy
  else         : handle_value, pointer(0), value, set=set, no_copy=no_copy
endcase
    
END
