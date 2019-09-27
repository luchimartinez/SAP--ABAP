*&---------------------------------------------------------------------*
*&  Include           ZACN_IS_MART_LU_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  SELECT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM select .

  SELECT deposito patente marca ano clase
  FROM znom_sucursal
  INTO TABLE it_nomina
  WHERE deposito = p_depo
  AND patente IN so_pate.

  IF sy-subrc = 1.
    MESSAGE s001(z_msj_error_mart_lu).
  ENDIF.

  SELECT patente entrega rei_plan deposito km_ent km_plan
  FROM znom_entregas
  INTO TABLE it_entrega
  FOR ALL ENTRIES IN it_nomina
  WHERE patente = it_nomina-patente.

  IF sy-subrc = 1.
    MESSAGE s003(z_msj_error_mart_lu).
  ENDIF.

  SELECT patente rei_real dep_ent receptor km_ent
  FROM zacn_mart_lu
  INTO TABLE it_reintegro
  FOR ALL ENTRIES IN it_entrega
  WHERE patente = it_entrega-patente.

  SELECT SINGLE deposito nombre calle altura localidad
  FROM zdet_sucursal
  INTO wa_sucursal
  WHERE deposito = p_depo.

  IF sy-subrc = 1.
    MESSAGE e002(z_msj_error_mart_lu).
  ENDIF.


  ENDFORM.                    " SELECT
*&---------------------------------------------------------------------*
*&      Form  CARGA_DATOS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form CARGA_DATOS .

DATA: lv_funcion TYPE p.

LOOP AT it_nomina INTO wa_nomina.

    wa_final-patente = wa_nomina-patente.
    wa_final-marca = wa_nomina-marca.
    wa_final-ano = wa_nomina-ano.
    wa_final-clase = wa_nomina-clase.

    READ TABLE it_reintegro INTO wa_reintegro
    WITH KEY patente = wa_nomina-patente

    BINARY SEARCH.

    IF sy-subrc = 0.
      wa_final-rei_real = wa_reintegro-rei_real.
    ELSEIF sy-subrc = 0.
      wa_final-comentario = 'Vehiculo aun no encontrado'.
    ENDIF.

    READ TABLE it_entrega INTO wa_entrega
    WITH KEY patente = wa_nomina-patente

    BINARY SEARCH.

    IF sy-subrc = 0.
      wa_final-entrega = wa_entrega-entrega.
    ENDIF.

    IF wa_entrega-deposito <> wa_reintegro-dep_ent.
      wa_final-ent_diferida = 'X'.
    ENDIF.

    CALL FUNCTION 'HRVE_GET_TIME_BETWEEN_DATES'
      EXPORTING
        beg_date       = wa_entrega-rei_plan
        end_date       = wa_reintegro-rei_real
      IMPORTING
        days           = lv_funcion
      EXCEPTIONS
        invalid_period = 1
        OTHERS         = 2.

    IF lv_funcion > 0.
      wa_final-dias_excedido = 'X'.
    ENDIF.

    IF wa_reintegro-km_ent > wa_entrega-km_plan.
      wa_final-km_excedido = 'X'.
    ENDIF.

    APPEND wa_final TO it_final.

    CLEAR wa_final.

ENDLOOP.


endform.                    " CARGA_DATOS
*&---------------------------------------------------------------------*
*&      Form  ELECCION_VISTA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form ELECCION_VISTA .

if rb_alv is NOT INITIAL.
  PERFORM vista_alv.
elseif rb_form is not INITIAL.
  PERFORM vista_smartform.
ENDIF.

endform.                    " ELECCION_VISTA
*&---------------------------------------------------------------------*
*&      Form  VISTA_ALV
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form VISTA_ALV .

    SORT it_final BY patente.

    DATA: wa_fieldcat TYPE slis_fieldcat_alv.

      wa_fieldcat-fieldname       = 'PATENTE'.
      wa_fieldcat-tabname         = 'IT_FINAL'.
      wa_fieldcat-ref_fieldname   = 'PATENTE'.
      wa_fieldcat-seltext_m = 'PATENTE'.
      wa_fieldcat-seltext_l = 'PATENTE'.
      wa_fieldcat-outputlen = 15.
      wa_fieldcat-just = 'C'.

  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

      wa_fieldcat-fieldname       = 'MARCA'.
      wa_fieldcat-tabname         = 'IT_FINAL'.
      wa_fieldcat-ref_fieldname   = 'MARCA'.
      wa_fieldcat-seltext_m = 'MARCA'.
      wa_fieldcat-seltext_l = 'MARCA'.
      wa_fieldcat-outputlen = 15.
      wa_fieldcat-just = 'C'.

  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

      wa_fieldcat-fieldname       = 'ANO'.
      wa_fieldcat-tabname         = 'IT_FINAL'.
      wa_fieldcat-ref_fieldname   = 'ANO'.
      wa_fieldcat-seltext_m = 'ANO'.
      wa_fieldcat-seltext_l = 'ANO'.
      wa_fieldcat-outputlen = 15.
      wa_fieldcat-just = 'C'.

  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

      wa_fieldcat-fieldname       = 'CLASE'.
      wa_fieldcat-tabname         = 'IT_FINAL'.
      wa_fieldcat-ref_fieldname   = 'CLASE'.
      wa_fieldcat-seltext_m = 'CLASE'.
      wa_fieldcat-seltext_l = 'CLASE'.
      wa_fieldcat-outputlen = 15.
      wa_fieldcat-just = 'C'.

  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

      wa_fieldcat-fieldname       = 'ENTREGA'.
      wa_fieldcat-tabname         = 'IT_FINAL'.
      wa_fieldcat-ref_fieldname   = 'ENTREGA'.
      wa_fieldcat-seltext_m = 'ENTREGA'.
      wa_fieldcat-seltext_l = 'ANO'.
      wa_fieldcat-outputlen = 15.
      wa_fieldcat-just = 'C'.

  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

      wa_fieldcat-fieldname       = 'REI_REAL'.
      wa_fieldcat-tabname         = 'IT_FINAL'.
      wa_fieldcat-ref_fieldname   = 'REI_REAL'.
      wa_fieldcat-seltext_m = 'REI_REAL'.
      wa_fieldcat-seltext_l = 'REI_REAL'.
      wa_fieldcat-outputlen = 15.
      wa_fieldcat-just = 'C'.

  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

      wa_fieldcat-fieldname       = 'ENT_DIFERIDA'.
      wa_fieldcat-tabname         = 'IT_FINAL'.
      wa_fieldcat-ref_fieldname   = 'ENT_DIFERIDA'.
      wa_fieldcat-seltext_m = 'ENT_DIFERIDA'.
      wa_fieldcat-seltext_l = 'ENT_DIFERIDA'.
      wa_fieldcat-outputlen = 15.
      wa_fieldcat-just = 'C'.

  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

      wa_fieldcat-fieldname       = 'DIAS_EXCEDIDO'.
      wa_fieldcat-tabname         = 'IT_FINAL'.
      wa_fieldcat-ref_fieldname   = 'DIAS_EXCEDIDO'.
      wa_fieldcat-seltext_m = 'DIAS_EXCEDIDO'.
      wa_fieldcat-seltext_l = 'DIAS_EXCEDIDO'.
      wa_fieldcat-outputlen = 15.
      wa_fieldcat-just = 'C'.

  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

      wa_fieldcat-fieldname       = 'KM_EXCEDIDO'.
      wa_fieldcat-tabname         = 'IT_FINAL'.
      wa_fieldcat-ref_fieldname   = 'KM_EXCEDIDO'.
      wa_fieldcat-seltext_m = 'KM_EXCEDIDO'.
      wa_fieldcat-seltext_l = 'KM_EXCEDIDO'.
      wa_fieldcat-outputlen = 15.
      wa_fieldcat-just = 'C'.

  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

      wa_fieldcat-fieldname       = 'COMENTARIO'.
      wa_fieldcat-tabname         = 'IT_FINAL'.
      wa_fieldcat-ref_fieldname   = 'COMENTARIO'.
      wa_fieldcat-seltext_m = 'COMENTARIO'.
      wa_fieldcat-seltext_l = 'COMENTARIO'.
      wa_fieldcat-outputlen = 15.
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
endform.                    " VISTA_ALV
*&---------------------------------------------------------------------*
*&      Form  VISTA_SMARTFORM
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form VISTA_SMARTFORM .

data: lv_nombreFuncion type formname.

CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
  EXPORTING
    formname                 = 'ZUSER10_EJ_FORM'
     IMPORTING
   FM_NAME                  = lv_nombreFuncion
 EXCEPTIONS
   NO_FORM                  = 1
   NO_FUNCTION_MODULE       = 2
   OTHERS                   = 3
          .
IF sy-subrc <> 0.
 MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
ENDIF.

if lv_nombreFuncion is not INITIAL .
  CALL FUNCTION '/1BCDWB/SF00000729'
    EXPORTING

      it_final                   = it_final

   EXCEPTIONS
     FORMATTING_ERROR           = 1
     INTERNAL_ERROR             = 2
     SEND_ERROR                 = 3
     USER_CANCELED              = 4
     OTHERS                     = 5
            .
  IF sy-subrc <> 0.
 MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.


  ENDIF.

endform.                    " VISTA_SMARTFORM
