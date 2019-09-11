*&---------------------------------------------------------------------*
*& Report  Z_USER10_EJERCICIO_AVL2
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

REPORT  Z_USER10_EJERCICIO_AVL2.
* ZUSER10_TRX_EJ6 transaccion correspondiente

INCLUDE Z_USER10_EJERCICIO_AVL2_TOP.
INCLUDE Z_USER10_EJERCICIO_AVL2_FORMS.

*&---------------------------------------------------------------------*
*& Start of selection
*&---------------------------------------------------------------------*
START-OF-SELECTION.

PERFORM llenar_tabla.
PERFORM imprimir_tabla.
