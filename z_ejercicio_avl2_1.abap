*&---------------------------------------------------------------------*
*&  Include           Z_USER10_EJERCICIO_AVL2_TOP
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*& Declarar TABLAS
*&---------------------------------------------------------------------*
TABLES scarr.
*&---------------------------------------------------------------------*
*& Declarar tipos
*&---------------------------------------------------------------------*
TYPE-POOLS: slis.
TYPES: BEGIN OF ty_final,
                 mandt TYPE scarr-mandt,
                 carrid TYPE scarr-carrid,
                 carrname TYPE scarr-carrname,
                 currcode TYPE scarr-currcode,
                 url TYPE scarr-url,
        END OF ty_final,

        BEGIN OF t_alv,
         mandt     TYPE mandt,
         carrid    TYPE char3,
         carrname   TYPE char30,
         currcode TYPE char5,
         url TYPE char255,
       END OF t_alv.

*&---------------------------------------------------------------------*
*& Declarar datos
*&---------------------------------------------------------------------*
DATA: it_final TYPE TABLE OF ty_final,
      wa_final TYPE ty_final,
      it_fieldcat TYPE slis_t_fieldcat_alv,
      wa_alv          TYPE t_alv,
      wa_layout       TYPE slis_layout_alv.

*&---------------------------------------------------------------------*
*& Pantalla de seleccion
*&---------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-001.
SELECT-OPTIONS s_carrid FOR scarr-carrid.
SELECTION-SCREEN END OF BLOCK b1.
