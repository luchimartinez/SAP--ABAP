*&---------------------------------------------------------------------*
*& Report  ZEJERCICIO_8
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT  zejercicio_8.

************************************************************************
* Definición de tablas del sistema                                     *
************************************************************************
TABLES: spfli.

************************************************************************
* Definición de tablas internas                                        *
************************************************************************
TYPES: BEGIN OF t_spfli,
        carrid   TYPE s_carr_id,
        connid   TYPE s_conn_id,
        cityfrom TYPE s_from_cit,
        cityto   TYPE s_to_city,
       END OF t_spfli,

       BEGIN OF t_scarr,
        carrid   TYPE s_carr_id,
        carrname TYPE s_carrname,
       END OF t_scarr,

       BEGIN OF t_salida,
        carrid   TYPE s_carr_id,
        connid   TYPE s_conn_id,
        cityfrom TYPE s_from_cit,
        cityto   TYPE s_to_city,
        carrname TYPE s_carrname,
       END OF t_salida.

************************************************************************
* Definición de estructuras                                            *
************************************************************************
DATA: r_spfli  TYPE t_spfli,
      r_scarr  TYPE t_scarr,
      r_salida TYPE t_salida.

************************************************************************
* Definición de tablas internas                                        *
************************************************************************
DATA: i_spfli  TYPE TABLE OF t_spfli,
      i_scarr  TYPE TABLE OF t_scarr,
      i_salida TYPE TABLE OF t_salida.

************************************************************************
* Definición de pantalla de selección                                  *
************************************************************************
SELECT-OPTIONS: so_conid FOR spfli-connid.

************************************************************************
*                                                                      *
*                       LOGICA DEL PROGRAMA                            *
*                                                                      *
************************************************************************

***Consulta a BBDD SIN JOIN.-> Se utiliza el FOR ALL ENTRIES.
SELECT carrid   "Compañía
       connid   "Numero de vuelo
       cityfrom "Ciudad de origen
       cityto   "ciudad destino
  FROM spfli
  INTO TABLE i_spfli
  WHERE connid IN so_conid.

IF sy-subrc EQ 0.
  SELECT carrid   "Compañía
         carrname "Nombre de la compañía
    FROM scarr
    INTO TABLE i_scarr
    FOR ALL ENTRIES IN i_spfli
    WHERE carrid EQ i_spfli-carrid.

  IF sy-subrc EQ 0.
    WRITE: /, 'Consulta a BBDD SIN JOIN:'.
    PERFORM f_salida.
  ENDIF.
ENDIF.

CLEAR: r_salida,
       i_salida.

***Consulta a BBDD CON JOIN.
SELECT spfli~carrid   "Compañía
       spfli~connid   "Numero de vuelo
       spfli~cityfrom "Ciudad de origen
       spfli~cityto   "ciudad destino
       scarr~carrname "Nombre de la compañía
  FROM spfli
  INNER JOIN scarr
    ON spfli~carrid EQ scarr~carrid
  INTO TABLE i_salida
  WHERE spfli~connid IN so_conid.

IF sy-subrc EQ 0.
  WRITE: /, 'Consulta a BBDD CON JOIN:'.
  PERFORM f_salida_join.
ENDIF.

*&---------------------------------------------------------------------*
*&      Form  F_SALIDA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_salida .

  "Se ordenan las tablas por el campo principal que las une.
  SORT: i_spfli BY carrid,
        i_scarr BY carrid.

  LOOP AT i_spfli INTO r_spfli.

    CLEAR: r_scarr.
    READ TABLE i_scarr INTO r_scarr
         WITH KEY carrid = r_spfli-carrid
                  BINARY SEARCH.

    IF sy-subrc EQ 0.
      r_salida-carrname = r_scarr-carrname.
    ENDIF.

    r_salida-carrid   = r_spfli-carrid.
    r_salida-connid   = r_spfli-connid.
    r_salida-cityfrom = r_spfli-cityfrom.
    r_salida-cityto   = r_spfli-cityto.

    APPEND r_salida TO i_salida.
    CLEAR: r_salida.

  ENDLOOP.

  LOOP AT i_salida INTO r_salida.

    WRITE: / '|', r_salida-carrid,
             '|', r_salida-connid,
             '|', r_salida-cityfrom,
             '|', r_salida-cityto,
             '|', r_salida-carrname..

  ENDLOOP.

ENDFORM.                    " F_SALIDA
*&---------------------------------------------------------------------*
*&      Form  F_SALIDA_JOIN
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_salida_join .

  SORT: i_salida BY carrid.

  LOOP AT i_salida INTO r_salida.
    WRITE: / '|', r_salida-carrid,
             '|', r_salida-connid,
             '|', r_salida-cityfrom,
             '|', r_salida-cityto,
             '|', r_salida-carrname.
  ENDLOOP.

ENDFORM.                    " F_SALIDA_JOIN
