*&---------------------------------------------------------------------*
*&  Include           Z_USER10_EJERCICIO_AVL2_FORMS
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Form  LLENAR_TABLA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form LLENAR_TABLA .

select *
from scarr
into table it_final
WHERE carrid in s_carrid.


endform.                    " LLENAR_TABLA


*&---------------------------------------------------------------------*
*&      Form  IMPRIMIR_TABLA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form IMPRIMIR_TABLA .

 DATA: wa_fieldcat TYPE slis_fieldcat_alv.

  wa_fieldcat-fieldname       = 'MANDT'.
  wa_fieldcat-tabname         = 'IT_FINAL'.
  wa_fieldcat-ref_fieldname   = 'MANDT'.
  wa_fieldcat-seltext_m = 'MANDT'.
  wa_fieldcat-seltext_l = 'MANDT'.
  wa_fieldcat-outputlen = 15.
  wa_fieldcat-just = 'C'.

  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname       = 'CARRID'.
  wa_fieldcat-tabname         = 'IT_FINAL'.
  wa_fieldcat-ref_fieldname   = 'SCARR'.
  wa_fieldcat-seltext_m = 'CARRID'.
  wa_fieldcat-seltext_l = 'CARRID'.
  wa_fieldcat-outputlen = 15.
  wa_fieldcat-just = 'C'.

  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname       = 'CARRNAME'.
  wa_fieldcat-tabname         = 'IT_FINAL'.
  wa_fieldcat-ref_fieldname   = 'CARRNAME'.
  wa_fieldcat-seltext_m = 'CARRNAME'.
  wa_fieldcat-seltext_l = 'CARRNAME'.
  wa_fieldcat-outputlen = 15.
  wa_fieldcat-just = 'C'.

  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname       = 'CURRCODE'.
  wa_fieldcat-tabname         = 'IT_FINAL'.
  wa_fieldcat-ref_fieldname   = 'CURRCODE'.
  wa_fieldcat-seltext_m = 'CURRCODE'.
  wa_fieldcat-seltext_l = 'CURRCODE'.
  wa_fieldcat-outputlen = 15.
  wa_fieldcat-just = 'C'.

  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname       = 'URL'.
  wa_fieldcat-tabname         = 'IT_FINAL'.
  wa_fieldcat-ref_fieldname   = 'URL'.
  wa_fieldcat-seltext_m = 'URL'.
  wa_fieldcat-seltext_l = 'URL'.
  wa_fieldcat-outputlen = 50.
  wa_fieldcat-just = 'C'.

  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
   EXPORTING

      I_CALLBACK_PROGRAM                = sy-repid
      IS_LAYOUT                         = wa_layout
      IT_FIELDCAT                       = it_fieldcat
    TABLES
      t_outtab                          = it_final
   EXCEPTIONS
     PROGRAM_ERROR                     = 1
     OTHERS                            = 2
            .
  IF sy-subrc <> 0.
 MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.


endform.                    " IMPRIMIR_TABLA
