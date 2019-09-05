*&---------------------------------------------------------------------*
*& Report  Z_EJERCICIO2_USER10
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT  z_ejercicio2_user10.
*&---------------------------------------------------------------------*
*& Declaración de datos
*&---------------------------------------------------------------------*
DATA wa_alumnos TYPE zestructurauser10.
CONSTANTS c_total TYPE i VALUE '10'.
*&---------------------------------------------------------------------*
*& Declaración de Pantalla
*&---------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-001.
PARAMETERS: gv_1 TYPE i ,
            gv_2 TYPE i.

SELECTION-SCREEN END OF BLOCK b1.
*&---------------------------------------------------------------------*
*& START-OF-SELECTION
*&---------------------------------------------------------------------*
START-OF-SELECTION.

  wa_alumnos-padron ='1234'.
  wa_alumnos-nombre = 'Luchi'.
  wa_alumnos-apellido = 'Martinez'.
  wa_alumnos-nacimiento = '10081991'.
  wa_alumnos-postal = '1425'.

  WRITE: /'Padron: ',wa_alumnos-padron,
         /'Nombre: ' ,wa_alumnos-nombre,
         /'Apellido: ', wa_alumnos-apellido,
         /'Nacimiento: ', wa_alumnos-nacimiento,
         / 'Postal: ', wa_alumnos-postal.

  SKIP 2.
*&---------------------------------------------------------------------*
*& END-OF-SELECTION
*&---------------------------------------------------------------------*
END-OF-SELECTION.
  PERFORM ejercicio2_byc.

*&---------------------------------------------------------------------*
*&      Form  EJERCICIO2_BYC
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM ejercicio2_byc .

  DATA lv_3 TYPE i.
  lv_3 = gv_1 + gv_2.

  IF lv_3 < c_total.
    WRITE: 'La suma es menor a 10, total: ', lv_3.
  ELSE.
    WRITE: 'La suma es mayor a 10, total: ', lv_3.
  ENDIF.

ENDFORM.                    " EJERCICIO2_BYC
