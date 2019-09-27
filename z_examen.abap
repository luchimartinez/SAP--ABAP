*&---------------------------------------------------------------------*
*& Report  ZACN_IS_MART_LU
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

REPORT  zacn_is_mart_lu.
"Z_TRX_SF_ML transaccion correspondiente al programa
"Z_MSJ_ERROR_MART_LU  mensajes seteados

INCLUDE zacn_is_mart_lu_top.
INCLUDE zacn_is_mart_lu_s01.
INCLUDE zacn_is_mart_lu_f01.

*&---------------------------------------------------------------------*
*&Start of selection
*&---------------------------------------------------------------------*

START-OF-SELECTION.

  PERFORM select.
  PERFORM carga_datos.
  PERFORM eleccion_vista.
