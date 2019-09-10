*&---------------------------------------------------------------------*
*& Report  ZUSER10_EJERCIO_WRITE
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT  zuser10_ejercio_write line-SIZE 105. "limita la cantidad de caracteres q se muestran por pantalla
"ZUSER10_TRX_WRITE  transaccion
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
DATA: it_clientes TYPE TABLE OF ty_clientes,
      wa_clientes TYPE ty_clientes.
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
WHERE kunnr in s_kunnr.

IF sy-subrc = 0.
  SORT it_clientes BY kunnr.
  WRITE 'OK'.
ELSE.
  WRITE 'NO SE OBTUVIERON CLIENTES'.
ENDIF.

LOOP at it_clientes into wa_clientes.
  write: /, wa_clientes-kunnr,
           wa_clientes-razon,
           wa_clientes-zobservcli.
  ENDLOOP.
