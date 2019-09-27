*&---------------------------------------------------------------------*
*&  Include           ZACN_IS_MART_LU_S01
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*& Pantalla de seleccion
*&---------------------------------------------------------------------*

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-001.
PARAMETERS: p_depo TYPE znom_sucursal-deposito OBLIGATORY,
            rb_form RADIOBUTTON GROUP g1,
            rb_alv RADIOBUTTON GROUP g1.
SELECT-OPTIONS: so_pate FOR znom_sucursal-patente.

SELECTION-SCREEN END OF block b1.
