*----------------------------------------------------------------------*
***INCLUDE Z_USER10_EJERCICIO_SMARTFORF01 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  RECUPERO_DATOS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM recupero_datos .

  SELECT carrid connid fldate price currency
  FROM sflight
  INTO TABLE it_sflight
  WHERE price IN so_price
  AND carrid = 'LH'.

  IF sy-subrc = 0.
    SORT it_sflight BY carrid.
  ENDIF.

  SELECT carrid connid cityfrom cityto
  FROM spfli
  INTO TABLE it_spfli
  FOR ALL ENTRIES IN it_sflight
  WHERE carrid = it_sflight-carrid
  AND connid = it_sflight-connid.

  IF sy-subrc = 0.
    SORT it_spfli BY carrid connid. " HAY Q HACER EL SORT SEGUN LOS MISMOS CAMPOS DEL WITH KEY DEL READ TABLE
  ENDIF.

  LOOP AT it_sflight INTO wa_sflight.

    READ TABLE it_spfli INTO wa_spfli
    WITH KEY carrid = wa_sflight-carrid
             connid = wa_sflight-connid
    BINARY SEARCH.

    IF sy-subrc = 0.
      wa_final-cityfrom = wa_spfli-cityfrom.
      wa_final-cityto = wa_spfli-cityto.
    ENDIF.

    "wa_final-carrid = wa_sflight-carrid.
    wa_final-connid = wa_sflight-connid.
    wa_final-fldate = wa_sflight-fldate.
    wa_final-price = wa_sflight-price.
    wa_final-currency = wa_sflight-currency.

    APPEND wa_final TO it_final.
*    WRITE: /  "wa_final-carrid,
*              wa_final-connid,
*              wa_final-fldate ,
*              wa_final-price ,
*              wa_final-currency,
*              wa_final-cityfrom,
*              wa_final-cityto.

     CLEAR: wa_spfli, wa_sflight.

  ENDLOOP.

ENDFORM.                    " RECUPERO_DATOS
*&---------------------------------------------------------------------*
*&      Form  FORMULARIO
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form FORMULARIO .

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
  CALL FUNCTION lv_nombreFuncion
    EXPORTING
      carrid                     = 'LH'
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

endform.                    " FORMULARIO
