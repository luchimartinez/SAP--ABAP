*&---------------------------------------------------------------------*
*& Report  ZUSER10_EJERCIO_WRITE
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT  zuser10_ejercio_write LINE-SIZE 105. "limita la cantidad de caracteres q se muestran por pantalla
"ZUSER10_TRX_WRITE  transaccion
TYPE-POOLS:slis.
*1)	Se requiere imprimir en pantalla los campos CARRID, CARRNAME, CURRCODE
*y URL de la línea Aerea American Airlines, cuyo código de aerolínea es AA.
*(El maestro de Lineas aéreas es la tabla SCARR, usar la sentencia SELECT
*más adecuada). Ver resultado por debug.
*&---------------------------------------------------------------------*
*&Declaración de types
*&---------------------------------------------------------------------*
TYPES: BEGIN OF ty_clientes,
                kunnr TYPE zclientes_acc-kunnr,
                razon TYPE zclientes_acc-razon,
                zobservcli TYPE zclientes_acc-zobservcli,
  END OF ty_clientes.
*&---------------------------------------------------------------------*
*&Declaración de datos
*&---------------------------------------------------------------------*
DATA: "it_clientes TYPE TABLE OF ty_clientes,
      wa_clientes TYPE ty_clientes.

DATA: it_clientes TYPE TABLE OF ty_clientes,
      wa_cientes TYPE ty_clientes,
      wa_layout   TYPE  slis_layout_alv,
      it_fieldcat TYPE  slis_t_fieldcat_alv,
      wa_fieldcat TYPE slis_fieldcat_alv.
*&---------------------------------------------------------------------*
*&Declaración de tablas
*&---------------------------------------------------------------------*
TABLES zclientes_acc.
*&---------------------------------------------------------------------*
*&Pantalla de seleccion
*&---------------------------------------------------------------------*
SELECT-OPTIONS s_kunnr FOR zclientes_acc-kunnr.
*&---------------------------------------------------------------------*
*&Start of selection
*&---------------------------------------------------------------------*
START-OF-SELECTION.
*Acceder a la tabla Z_CLIENTES_APELLIDOALUMNO (donde APELLIDOALUMNO sea el apellido del alumno que desarrolla el ejercicio y que fue creada con anterioridad) con kunnr = rango de selección por pantalla y recuperar:
*Kunnr (cliente)
*Razón (razón social)
*Observaciones (observaciones)
*Si se recuperan datos, se debe ordenar la tabla por kunnr (cliente).
*De lo contrario, mostrar un mensaje indicando que no se obtuvieron clientes con esa selección.
* Se debe recorrer la tabla con los datos obtenidos en la selección anterior y se deben cargar los datos a la salida por medio de la sentencia write.
* El orden de los mismos es:     | Cliente |  Razón social | Observaciones|


  SELECT kunnr razon zobservcli
  FROM zclientes_acc
  INTO TABLE it_clientes
  WHERE kunnr IN s_kunnr.

  IF sy-subrc = 0.
    SORT it_clientes BY kunnr.
    wa_fieldcat-fieldname ='KUNNR'.
    wa_fieldcat-tabname ='IT_CLIENTES'.
    wa_fieldcat-seltext_s = 'KUNNR'.
    wa_fieldcat-seltext_m = 'KUNNR'.
    wa_fieldcat-seltext_l = 'KUNNR'.
    wa_fieldcat-outputlen = 50.
    wa_fieldcat-just = 'C'.

    APPEND wa_fieldcat TO IT_fieldcat.
    CLEAR wa_fieldcat.


    wa_fieldcat-fieldname ='RAZON'.
    wa_fieldcat-tabname ='IT_CLIENTES'.
    wa_fieldcat-seltext_s = 'RAZON'.
    wa_fieldcat-seltext_m = 'RAZON'.
    wa_fieldcat-seltext_l = 'RAZON'.
    wa_fieldcat-outputlen = 50.
    wa_fieldcat-just = 'C'.

    APPEND wa_fieldcat TO IT_fieldcat.
    CLEAR wa_fieldcat.


    wa_fieldcat-fieldname ='ZOBSERVCLI'.
    wa_fieldcat-tabname ='IT_CLIENTES'.
    wa_fieldcat-seltext_s = 'ZOBSERVCLI'.
    wa_fieldcat-seltext_m = 'ZOBSERVCLI'.
    wa_fieldcat-seltext_l = 'ZOBSERVCLI'.
    wa_fieldcat-outputlen = 50.
    wa_fieldcat-just = 'C'.

    APPEND wa_fieldcat TO IT_fieldcat.
    CLEAR wa_fieldcat.
ELSE.
    WRITE 'NO SE OBTUVIERON CLIENTES'.
  ENDIF.

*  LOOP AT it_clientes INTO wa_clientes.
*    WRITE: /, wa_clientes-kunnr,
*             wa_clientes-razon,
*             wa_clientes-zobservcli.
*  ENDLOOP.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program = sy-repid
      is_layout          = wa_layout
      it_fieldcat        = it_fieldcat
    TABLES
      t_outtab           = it_clientes
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.
