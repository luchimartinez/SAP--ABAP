*&---------------------------------------------------------------------*
*& Report  Z_EJERCICIO_LOOP_USER10
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT  z_ejercicio_loop_user10.
*&---------------------------------------------------------------------*
*& Declaración de types
*&---------------------------------------------------------------------*
TYPES ty_i_alumnos TYPE STANDARD TABLE OF zestructurauser10. "creo tabla con el tipo de dato estructura q cree antes
*&---------------------------------------------------------------------*
*& Declaracion de datos
*&---------------------------------------------------------------------*
DATA: wa_alumno4 TYPE zestructurauser10, " creo una tabla con el mismo tipo de dato q la it q cree antes asi puedo llenar los mismos
      it_alumnos TYPE ty_i_alumnos. "creo la tabla
*&---------------------------------------------------------------------*
*& START-OF-SELECTION
*&---------------------------------------------------------------------*
START-OF-SELECTION.

  PERFORM llenar_datos_wa.
*&---------------------------------------------------------------------*
*& END-OF-SELECTION
*&---------------------------------------------------------------------*
END-OF-SELECTION.

  PERFORM impresion_registros.

*&---------------------------------------------------------------------*
*&      Form  LLENAR_DATOS_WA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM llenar_datos_wa .
  " lleno registro en la WA

  wa_alumno4-padron = '12345'.
  wa_alumno4-nombre = 'Lucia'.
  wa_alumno4-apellido = 'Martinez'.
  wa_alumno4-nacimiento = '10081991'.
  wa_alumno4-postal = '1234'.

  APPEND wa_alumno4 TO it_alumnos. "Paso el registro a la tabla interna

  " lleno registro en la WA

  wa_alumno4-padron = '6784'.
  wa_alumno4-nombre = 'Sofia'.
  wa_alumno4-apellido = 'Morandi'.
  wa_alumno4-nacimiento = '03062005'.
  wa_alumno4-postal = '3456'.

  APPEND wa_alumno4 TO it_alumnos. "Paso el registro a la tabla interna

  " lleno registro en la WA

  wa_alumno4-padron = '2840'.
  wa_alumno4-nombre = 'Mariano'.
  wa_alumno4-apellido = 'Torres'.
  wa_alumno4-nacimiento = '17052003'.
  wa_alumno4-postal = '5555'.

  APPEND wa_alumno4 TO it_alumnos. "Paso el registro a la tabla interna

  SORT it_alumnos BY apellido DESCENDING. "ordena por apellido en forma descendente

ENDFORM.                    " LLENAR_DATOS_WA
*&---------------------------------------------------------------------*
*&      Form  IMPRESION_REGISTROS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM impresion_registros .

  CONSTANTS: lc_padron TYPE zestructurauser10-padron VALUE '12345', " Declaro e inicializo una costante con el padron sacado de la estructura
             lc_codigopostal TYPE zestructurauser10-postal VALUE'C6666AHH'. " Declaro e inicializo una costante con el valor sacado de la estructura

  READ TABLE it_alumnos INTO wa_alumno4 INDEX 2. "Le mando a leer el 2do registro y si se cargo y esta todo bien que lo imprima
  IF sy-subrc = 0.
    WRITE: / wa_alumno4-apellido.

    MESSAGE i003(z_lucia).
  ELSE.
    MESSAGE e002(z_lucia). " Si no lo encontro mando un mensaje de error
    SKIP.
    ULINE.
  ENDIF.

  READ TABLE it_alumnos INTO wa_alumno4 WITH KEY padron = lc_padron. " Le mando a leer el registro donde el padron sea igual a 12345, si hay alguno q lo imprima
  IF sy-subrc = 0.
    WRITE: / wa_alumno4-padron.
    SKIP.
  ENDIF.

  LOOP AT it_alumnos INTO wa_alumno4. " Hago que recorra la tabla para q cambie el codigo postal
    wa_alumno4-postal = lc_codigopostal. "Este es el codigo postal por cual lo cambio
    MODIFY it_alumnos FROM wa_alumno4 TRANSPORTING postal. "Le digo q modificque la tabla tomando en cuenta el cambio en la WA dentro del campo que aclare

    IF sy-subrc <> 0.
      MESSAGE e001(z_lucia) WITH 'prueba'.
    ENDIF.

    CLEAR wa_alumno4. "Buena practica
  ENDLOOP.

  DELETE it_alumnos WHERE padron = lc_padron. "Borro los registros que el registro sea igual al numero de la constante q declare antes
  IF sy-subrc <> 0.
    WRITE 'ERROR PADRON'.
  ENDIF.

  CLEAR wa_alumno4. "buena practica
  LOOP AT it_alumnos INTO wa_alumno4.

    WRITE: / wa_alumno4-padron,
          / wa_alumno4-nombre,
          / wa_alumno4-apellido,
          / wa_alumno4-nacimiento,
          / wa_alumno4-postal.
    SKIP.
    ULINE.

  ENDLOOP.
ENDFORM.                    " IMPRESION_REGISTROS
