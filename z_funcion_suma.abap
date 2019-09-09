FUNCTION Z_SUMA_USER10 .
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(P_A) TYPE  I
*"     REFERENCE(P_B) TYPE  I
*"  EXPORTING
*"     REFERENCE(P_C) TYPE  I
*"----------------------------------------------------------------------

 p_c = p_a + p_b.

CALL FUNCTION 'POPUP_TO_INFORM'
  EXPORTING
    titel         = 'El resultad es'
    txt1          = p_c .


ENDFUNCTION.
