*&---------------------------------------------------------------------*
*& Report  ZEJERCICIO6
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT  zejercicio6.

TYPE-POOLS: slis.
*1)	Se requiere imprimir en pantalla los campos CARRID, CARRNAME, CURRCODE
*y URL de la l�nea Aerea American Airlines, cuyo c�digo de aerol�nea es AA.
*(El maestro de Lineas a�reas es la tabla SCARR, usar la sentencia SELECT
*m�s adecuada). Ver resultado por debug.

TYPES: BEGIN OF ty_scarr,
         carrid   TYPE scarr-carrid,
         carrname TYPE scarr-carrname,
         currcode TYPE scarr-currcode,
         url      TYPE scarr-url,
        END OF ty_scarr.

DATA: it_scarr TYPE TABLE OF ty_scarr,
      wa_scarr TYPE ty_scarr,
      wa_layout   TYPE  slis_layout_alv,
      it_fieldcat TYPE  slis_t_fieldcat_alv,
      wa_fieldcat TYPE slis_fieldcat_alv.

SELECT  carrid carrname currcode url
              FROM scarr
              INTO TABLE it_scarr.

IF sy-subrc = 0.
*  WRITE: wa_scarr,
*         /.
*  ULINE.
  wa_layout-zebra = 'X'.


  wa_fieldcat-fieldname = 'CARRID'.
  wa_fieldcat-tabname = 'IT_SCARR'.
  wa_fieldcat-seltext_s = 'CARRID'.
  wa_fieldcat-seltext_m = 'CARRID'.
  wa_fieldcat-seltext_l = 'CARRID'.

  APPEND wa_fieldcat TO IT_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'CARRNAME'.
  wa_fieldcat-tabname = 'IT_SCARR'.
  wa_fieldcat-seltext_s = '1'.
  wa_fieldcat-seltext_m = '2'.
  wa_fieldcat-seltext_l = '3'.
  wa_fieldcat-outputlen = 100.
  wa_fieldcat-just = 'C'.

  APPEND wa_fieldcat TO IT_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'CURRCODE'.
  wa_fieldcat-tabname = 'IT_SCARR'.
  wa_fieldcat-seltext_s = 'CURRCODE'.
  wa_fieldcat-seltext_m = 'CURRCODE'.
  wa_fieldcat-seltext_l = 'CURRCODE'.

  APPEND wa_fieldcat TO IT_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'URL'.
  wa_fieldcat-tabname = 'IT_SCARR'.
  wa_fieldcat-seltext_s = 'URL'.
  wa_fieldcat-seltext_m = 'URL'.
  wa_fieldcat-seltext_l = 'URL'.

  APPEND wa_fieldcat TO IT_fieldcat.
  CLEAR wa_fieldcat.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program = sy-repid
      is_layout          = wa_layout
      it_fieldcat        = it_fieldcat
    TABLES
      t_outtab           = it_scarr
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.

  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.


ELSE.
  WRITE: 'SCARR NO TIENE DATOS'.
ENDIF.

**2)  Se requiere imprimir solamente el CARRNAME y URL de la l�nea LH,
**realizar otro SELECT (el m�s adecuado) no olvidar de hacer un CLEAR
**de la WA del punto 1 antes de hacer este SELECT.
**(Se debe usar la misma Working Area del punto1)
*CLEAR: wa_scarr.
*SELECT SINGLE carrid carrname currcode url
*              FROM scarr
*              INTO wa_scarr
*              WHERE carrid = 'LH'.
*
*IF sy-subrc = 0.
*  WRITE: /,
*         wa_scarr-carrname,
*         wa_scarr-url.
*  ULINE.
*
*ELSE.
*  WRITE: 'No hay datos'.
*ENDIF.
**3)  Se requiere imprimir en pantalla toda la informaci�n de todos los tipos
**de vuelos (tabla SPFLI) que realiza la l�nea a�rea Lufthansa (LH).
**(Usar el Select Adecuado).
*
*DATA: it_spfli TYPE TABLE OF spfli,
*      wa_spfli TYPE spfli.
*
*SELECT * FROM spfli
*         INTO TABLE it_spfli
*         WHERE carrid = 'LH'.
*
*IF sy-subrc = 0.
*
*  SORT: it_spfli BY carrid connid.
*
*  LOOP AT it_spfli INTO wa_spfli.
*
*    WRITE: /,   wa_spfli-carrid,
*                wa_spfli-connid,
*                wa_spfli-countryfr,
*                wa_spfli-cityfrom,
*                wa_spfli-airpfrom,
*                wa_spfli-countryto,
*                wa_spfli-cityto,
*                wa_spfli-airpto,
*                wa_spfli-fltime,
*                wa_spfli-deptime,
*                wa_spfli-arrtime,
*                wa_spfli-distance,
*                wa_spfli-distid,
*                wa_spfli-fltype,
*                wa_spfli-period.
*  ENDLOOP.
*
*  CLEAR: wa_spfli.
*
*ENDIF.
