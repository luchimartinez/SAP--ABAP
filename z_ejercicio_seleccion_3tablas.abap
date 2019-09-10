*&---------------------------------------------------------------------*
*& Report  Z_USER10_SELECCION_3TABLAS
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT  z_user10_seleccion_3tablas.
*ZUSER10_TRX_SELECT3  transaccion correspondiente
*&---------------------------------------------------------------------*
*&Declaracion de types
*&---------------------------------------------------------------------*
TYPES: BEGIN OF ty_flight,
                carrid TYPE sflight-carrid,
                connid TYPE sflight-connid,
                fldate TYPE sflight-fldate,
                price TYPE sflight-price,
                currency TYPE sflight-currency,
      END OF ty_flight,

      BEGIN OF ty_spfli,
                carrid TYPE spfli-carrid,
                connid TYPE spfli-connid,
                cityfrom TYPE spfli-cityfrom,
                cityto TYPE spfli-cityto,
      END OF ty_spfli,

      BEGIN OF ty_scarr,
               carrid TYPE scarr-carrid,
               carrname TYPE scarr-carrname,
      END OF ty_scarr,

      BEGIN OF ty_final,
               carrid TYPE sflight-carrid,
               connid TYPE sflight-connid,
               fldate TYPE sflight-fldate,
               price TYPE sflight-price,
               currency TYPE sflight-currency,
               cityfrom TYPE spfli-cityfrom,
               cityto TYPE spfli-cityto,
               carrname TYPE scarr-carrname,
        END OF ty_final.
*&---------------------------------------------------------------------*
*&Declaracion de data
*&---------------------------------------------------------------------*
DATA: it_flight TYPE TABLE OF ty_flight,
      wa_flight TYPE ty_flight,
      it_spfli TYPE TABLE OF ty_spfli,
      wa_spfli TYPE ty_spfli,
      it_scarr TYPE TABLE OF ty_scarr,
      wa_scarr TYPE ty_scarr,
      it_final TYPE TABLE OF ty_final,
      wa_final TYPE ty_final.
*&---------------------------------------------------------------------*
*&Declaracion de tablas
*&---------------------------------------------------------------------*
TABLES: sflight.
*&---------------------------------------------------------------------*
*&Pantalla de seleccion
*&---------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-001.
SELECT-OPTIONS: s_flight FOR sflight-fldate,
                s_fligh1 FOR sflight-price.
SELECTION-SCREEN END OF BLOCK b1.
*&---------------------------------------------------------------------*
*&Start of selection
*&---------------------------------------------------------------------*
START-OF-SELECTION.

**La pantalla de selección tendrá los siguientes filtros:
**Rango de fechas (SFLIGHT-FLDATE)
**Rango de precios (SFLIGHT-PRICE)
** Acceder a la tabla SFLIGHT con FLDATE = rango pantalla de selección, PRICE = rango pantalla de selección.
**Y recuperar:
**  CARRID (Denominación breve de la compañía aérea)
**CONNID (Código de conexión de vuelo directo)
**FLDATE (Fecha de vuelo)
**PRICE (Precio del vuelo)
**CURRENCY (Moneda local de la compañía aérea)

** Luego con los resultados obtenidos en la selección anterior acceder a la tabla SPFLI con:
**  CARRID = SFLIGHT- CARRID y CONNID = SFLIGHT- CONNID
**Y recuperar:
**  CARRID (Denominación breve de la compañía aérea)
**CONNID (Código de conexión de vuelo directo)
**  CITYFROM (Ciudad de salida)
**  CITYTO (Ciudad de llegada)

** Luego con los resultados obtenidos en la primera selección acceder a la tabla SCARR con:
**  CARRID = SFLIGHT- CARRID
**Y recuperar:
**  CARRID (Denominación breve de la compañía aérea)
**  CARRNAME (Nombre de una compañía aérea)
**Luego completar la tabla principal recorriendo la primera y leyendo las otras en cada iteración.

  SELECT carrid connid fldate price currency
  FROM sflight
  INTO TABLE it_flight
  WHERE fldate IN s_flight
  AND price IN s_fligh1.

  IF sy-subrc = 0.

    SELECT carrid connid cityfrom cityto
    FROM spfli
    INTO TABLE it_spfli
    FOR ALL ENTRIES IN it_flight
    WHERE carrid = it_flight-carrid
    AND connid = it_flight-connid.

    SELECT carrid carrname
    FROM scarr
    INTO TABLE it_scarr
    FOR ALL ENTRIES IN it_flight
    WHERE carrid = it_flight-carrid.

    IF sy-subrc = 0.
      PERFORM completar_tabla.
    ENDIF.

  ENDIF.
*&---------------------------------------------------------------------*
*&      Form  COMPLETAR_TABLA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM completar_tabla .

  SORT: it_flight, it_spfli, it_scarr BY carrid.

  LOOP AT it_flight INTO wa_flight.

    READ TABLE it_spfli INTO wa_spfli
    WITH KEY carrid = wa_flight
             connid = wa_flight-connid
    BINARY SEARCH.

    IF sy-subrc = 0.
      wa_final-cityfrom = wa_spfli-cityfrom.
      wa_final-cityto = wa_spfli-cityto.
    ENDIF.

    READ TABLE it_scarr INTO wa_scarr
    WITH KEY carrid = wa_flight-carrid
    BINARY SEARCH.

    IF sy-subrc = 0.
      wa_final-carrname = wa_scarr-carrname.
    ENDIF.

    wa_final-carrid = wa_flight-carrid.
    wa_final-connid = wa_flight-connid.
    wa_final-fldate = wa_flight-fldate.
    wa_final-price = wa_flight-price.
    wa_final-currency = wa_flight-currency.

    APPEND wa_final TO it_final.

    CLEAR: wa_spfli, wa_scarr, wa_final.

  ENDLOOP.

  SORT it_final.

  LOOP AT it_final INTO wa_final.
    WRITE: /  wa_final-carrid,
              wa_final-connid,
              wa_final-fldate,
              wa_final-price CURRENCY wa_final-currency, "para poner el tipo de moneda en el formato de pais correspondiente
              wa_final-currency,
              wa_final-cityfrom,
              wa_final-cityto,
              wa_final-carrname.

    at END OF connid. " para poner linea separatoria cuando cambia el connid
    ULINE.
    ENDAT.
  ENDLOOP.

ENDFORM.                    " COMPLETAR_TABLA
