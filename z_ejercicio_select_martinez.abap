*&---------------------------------------------------------------------*
*& Report  Z_EJERCICIO_SELECT_USER10
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT  z_ejercicio_select_user10.
*&---------------------------------------------------------------------*
*& Declaración de types
*&---------------------------------------------------------------------*
TYPES: BEGIN OF ty_scarr,
       carrid TYPE scarr-carrid,
       carrname TYPE scarr-carrname,
       currcode TYPE scarr-currcode,
       url TYPE scarr-url.
TYPES END OF ty_scarr.
*&---------------------------------------------------------------------*
*& Declaración de datos
*&---------------------------------------------------------------------*

DATA: lwa_aerolinea TYPE ty_scarr,
      lwa_vuelos TYPE spfli,
      lit_vuelos TYPE STANDARD TABLE OF spfli.

*&---------------------------------------------------------------------*
*& START-OF-SELECTION
*&---------------------------------------------------------------------*

SELECT SINGLE carrid carrname currcode url
INTO lwa_aerolinea
FROM scarr
WHERE carrid EQ 'AA' .

IF sy-subrc = 0.
  WRITE lwa_aerolinea.
ELSE.
  WRITE 'ERROR'.
ENDIF.
CLEAR lwa_aerolinea.

SKIP.
ULINE.

SELECT SINGLE carrid carrname currcode url "por mas que no utilice dos de estos campos, los pongo igual para que se mantenga la estructura y no me los tire
INTO lwa_aerolinea "en cualquier lado xq estoy usando la misma WA, sino creo otra
FROM scarr
WHERE carrid EQ 'LH' .


IF sy-subrc = 0. "buena practica
  WRITE: lwa_aerolinea-carrname,
         lwa_aerolinea-url.
ELSE.
  WRITE 'ERROR'.
ENDIF.

CLEAR lwa_aerolinea.

SKIP.
ULINE.

SELECT *
INTO TABLE lit_vuelos
FROM spfli
WHERE carrid EQ 'LH'.

IF sy-subrc = 0.
  WRITE 'OK'.
ELSE.
  WRITE 'ERROR'.
ENDIF.

SKIP.
ULINE.
SORT: lit_vuelos BY carrid connid. "buena practica

LOOP AT lit_vuelos INTO lwa_vuelos.
  WRITE:
         /, lwa_vuelos-carrid,
            lwa_vuelos-connid,
            lwa_vuelos-countryfr,
            lwa_vuelos-cityfrom,
            lwa_vuelos-airpfrom,
            lwa_vuelos-countryto,
            lwa_vuelos-cityto,
            lwa_vuelos-airpto,
            lwa_vuelos-fltime,
            lwa_vuelos-deptime,
            lwa_vuelos-arrtime,
            lwa_vuelos-distance,
            lwa_vuelos-distid,
            lwa_vuelos-fltype,
            lwa_vuelos-period.
ENDLOOP.

CLEAR lwa_vuelos.
