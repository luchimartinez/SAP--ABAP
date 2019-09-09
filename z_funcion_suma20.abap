FUNCTION Z_SUMA20_USER10.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(P_A) TYPE  I
*"  EXPORTING
*"     REFERENCE(P_C) TYPE  I
*"----------------------------------------------------------------------

CONSTANTS lp_1 type i value 20.

p_c = p_a + lp_1.

CALL FUNCTION 'POPUP_TO_INFORM'
  EXPORTING
    titel         = 'El resultado es'
    txt1          = p_c .


ENDFUNCTION.
