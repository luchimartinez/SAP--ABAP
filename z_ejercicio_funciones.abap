*&---------------------------------------------------------------------*
*& Report  Z_PRUEBA_USER10
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT  z_prueba_user10.

*&---------------------------------------------------------------------*
*& Declaración de datos
*&---------------------------------------------------------------------*
DATA lp_total TYPE i.
*&---------------------------------------------------------------------*
*& Declaración de Pantalla
*&---------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-001.
PARAMETERS: lp_a TYPE i,
            lp_b TYPE i.
SELECTION-SCREEN END OF BLOCK b1.

SELECTION-SCREEN begin of BLOCK b2 WITH FRAME TITLE text-002.
  PARAMETERS: lp_c TYPE i.
SELECTION-SCREEN END OF BLOCK b2.
*&---------------------------------------------------------------------*
*& START-OF-SELECTION
*&---------------------------------------------------------------------*
START-OF-SELECTION.

  CALL FUNCTION 'Z_SUMA_USER10'
    EXPORTING
      p_a = lp_a
      p_b = lp_b
    IMPORTING
      p_c = lp_total .

  CALL FUNCTION 'Z_SUMA20_USER10'
    EXPORTING
      p_a           = lp_a
   IMPORTING
     P_C           = lp_total .
