*&---------------------------------------------------------------------*
*& Report  Z_USER10_SELECCION_2TABLAS
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT  z_user10_seleccion_2tablas.
" tansaccion = ZUSER10_TRX_SELECT2
*&---------------------------------------------------------------------*
*& Declaracion de types
*&---------------------------------------------------------------------*
TYPES: BEGIN OF ty_fli,
                carrid TYPE spfli-carrid,
                connid TYPE spfli-carrid,
                cityfrom TYPE spfli-cityfrom,
                cityto TYPE spfli-cityto,
       END OF ty_fli,

       BEGIN OF ty_scarr,
                carrid TYPE scarr-carrid,
                carrname TYPE scarr-carrname,
       END OF ty_scarr,

       BEGIN OF ty_final,
                carrid TYPE spfli-carrid,
                connid TYPE spfli-carrid,
                cityfrom TYPE spfli-cityfrom,
                cityto TYPE spfli-cityto,
                carrname TYPE scarr-carrname,
       END OF ty_final.
*&---------------------------------------------------------------------*
*& Declaracion de datos
*&---------------------------------------------------------------------*
DATA: it_fli TYPE TABLE OF ty_fli,
      wa_fli TYPE ty_fli,
      it_scarr TYPE TABLE OF ty_scarr,
      wa_scarr TYPE ty_scarr,
      it_final TYPE TABLE OF  ty_final,
      wa_final TYPE ty_final.
*&---------------------------------------------------------------------*
*& Declaracion de tablas
*&---------------------------------------------------------------------*
TABLES: spfli, scarr.
*&---------------------------------------------------------------------*
*& Pantalla de seleccion
*&---------------------------------------------------------------------*
SELECT-OPTIONS s_connid FOR spfli-connid.
*&---------------------------------------------------------------------*
*& Start of selection
*&---------------------------------------------------------------------*
START-OF-SELECTION.

  SELECT carrid connid cityfrom cityto
  FROM spfli
  INTO TABLE it_fli
  WHERE connid IN s_connid.

  IF sy-subrc = 0.

    SELECT carrid carrname
    FROM scarr
    INTO TABLE it_scarr
    FOR ALL ENTRIES IN it_fli
    WHERE carrid = it_fli-carrid.

    WRITE'OK'.
  ELSE.
    WRITE 'NOP'.
  ENDIF.

  SORT: it_fli, it_scarr. "siempre ordenar antes de hacer un read

  LOOP AT it_fli INTO wa_fli. "no es necesario limpiar esta wa xq se pisa constantemente

    READ TABLE it_scarr INTO wa_scarr
    WITH KEY carrid = wa_fli-carrid
    BINARY SEARCH.
    IF sy-subrc = 0.
      wa_final-carrname = wa_scarr-carrname. " si obtuve datos q los copie, si se hace afuera queda vacio
    ENDIF.

    wa_final-carrid = wa_fli-carrid.
    wa_final-connid = wa_fli-connid.
    wa_final-cityfrom = wa_fli-cityfrom.
    wa_final-cityto = wa_fli-cityto.


    APPEND wa_final TO it_final.
    WRITE: /, wa_final-carrid, wa_final-connid, wa_final-cityfrom, wa_final-cityto, wa_final-carrname.
    CLEAR: wa_scarr, wa_final.
  ENDLOOP.
