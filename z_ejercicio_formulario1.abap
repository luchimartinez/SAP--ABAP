*&---------------------------------------------------------------------*
*& Report  Z_USER10_EJERCICIO_SMARTFORMS
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT  z_user10_ejercicio_smartforms.

*&---------------------------------------------------------------------*
*&Declaracion de tablas
*&---------------------------------------------------------------------*
TABLES: sflight, spfli.
*&---------------------------------------------------------------------*
*&Declarcion de data
*&---------------------------------------------------------------------*
DATA: it_sflight TYPE TABLE OF zuser10_itsf,
      wa_sflight TYPE zuser10_itsf,
      it_spfli TYPE TABLE OF zuser10_itsp,
      wa_spfli TYPE zuser10_itsp,
      it_final TYPE TABLE OF zuser10_itfinal,
      wa_final TYPE zuser10_itfinal.

*&---------------------------------------------------------------------*
*&At selection screen
*&---------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-001.
SELECT-OPTIONS so_price for sflight-price.
SELECTION-SCREEN END OF BLOCK b1.

INCLUDE Z_USER10_EJERCICIO_SMARTFORF01.

*&---------------------------------------------------------------------*
*&Start of selection
*&---------------------------------------------------------------------*
START-OF-SELECTION.

PERFORM recupero_datos.
PERFORM formulario.
