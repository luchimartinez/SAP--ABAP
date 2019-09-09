*&---------------------------------------------------------------------*
*& Report  ZEJERCICIO6_B
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT  zejercicio6_b.

*Ejercicio 6_B.  Z_USUARIO_6_B
*•  Pantalla de selección: SELECT OPTION SCARR-CARRID Obligatorio.
TABLES: scarr.

TYPES: BEGIN OF ty_scarr,
         carrid TYPE scarr-carrid,
         carrname TYPE scarr-carrname,
       END OF ty_scarr,

       BEGIN OF ty_sflight,
         carrid   TYPE sflight-carrid,
         connid   TYPE sflight-connid,
         fldate   TYPE sflight-fldate,
         price    TYPE sflight-price,
         currency TYPE sflight-currency,
       END OF ty_sflight.

DATA: it_scarr    TYPE TABLE OF ty_scarr,
      it_sflight  TYPE TABLE OF ty_sflight,
      wa_sflight  TYPE ty_sflight,
      wa_scarr    TYPE ty_scarr.

SELECT-OPTIONS: s_carrid FOR scarr-carrid OBLIGATORY.

*•  Buscar en la tabla SCARR los campos: CARRID – CARRNAME
* buscar en el where CARRID con el SO de la pantalla de selección.
SELECT carrid carrname
       FROM scarr
       INTO TABLE it_scarr
       WHERE carrid IN s_carrid.

IF sy-subrc = 0.
  SORT it_scarr BY carrid.
*•  Con los datos de la búsqueda anterior buscar en la tabla SFLIGHT con el campo CARRID. Traer los campos:
*   CARRID – CONNID – FLDATE – PRICE – CURRENCY.
  SELECT carrid connid fldate price currency
         FROM sflight
         INTO TABLE it_sflight
         FOR ALL ENTRIES IN it_scarr
         WHERE carrid = it_scarr-carrid.

  IF sy-subrc = 0.
    SORT it_sflight BY carrid connid.

  ENDIF.
ENDIF.

*•  Mostrar en pantalla los siguientes campos: SFLIGHT-CARRID,
*SCARR-CARRNAME, SFLIGHT-CONNID, SFLIGHT-FLDATE, SFLIGHT-PRICE,
*SFLIGHT-CURRENCY. Para esto loopear la tabla SFLIGHT y
*buscar en CARRNAME en la tabla SCARR.

LOOP AT it_sflight INTO wa_sflight.

  WRITE: /, wa_sflight-carrid.

  READ TABLE it_scarr INTO wa_scarr
    WITH KEY carrid = wa_sflight-carrid
             BINARY SEARCH.

  IF sy-subrc = 0.
    WRITE: wa_scarr-carrname.
  ENDIF.

  WRITE: wa_sflight-connid,
         wa_sflight-fldate,
         wa_sflight-price CURRENCY wa_sflight-currency ,  "para pasar el formato de moneda al pais q corresponde
         wa_sflight-currency.

ENDLOOP.
