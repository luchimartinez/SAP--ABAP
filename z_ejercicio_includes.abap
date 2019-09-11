*&---------------------------------------------------------------------*
*& Report  Z_ACC_TEST_11
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT  zejercicio11.

************************************************************************
* Declaración de includes                                              *
************************************************************************
INCLUDE ZEJERCICIO11_TOP.
INCLUDE ZEJERCICIO11_F01.


************************************************************************
*                                                                      *
*                       LOGICA DEL PROGRAMA                            *
*                                                                      *
************************************************************************
************************************************************************
* Definición de inicializaciones ( INITIALIZATION )                    *
************************************************************************


************************************************************************
* Validaciones de los parámetros de entrada                            *
************************************************************************
*Hay dos formas de verificar que un parametro de la pantalla de seleccion sea obligatiro.
*1- Agregando el comando OBLIGATORY (ver include TOP) o,
*2- Por codigo, comprobando si el campo es inicial. Esta ultima forma de hace en el evento AT SELECTION-SCREEN.
*   Es la mas recomendable por temas de restricciones y comportamientos de las pantallas.
*   Ademas de que permite personalizar el mensaje a mostrar.

AT SELECTION-SCREEN.
  IF so_kunnr[] IS INITIAL.
    MESSAGE e000(zescuelita) WITH text-003.
  ENDIF.

************************************************************************
* Proceso principal ( START-OF-SELECTION )                             *
************************************************************************
START-OF-SELECTION.
  IF rb_listo EQ dc_x.
    v_entregado = dc_x.
  ELSE.
    v_entregado = space.
  ENDIF.

  PERFORM f_obtencion_datos.
  PERFORM f_datos_salida.

************************************************************************
* Acciones de final de proceso ( END-OF-SELECTION )                    *
************************************************************************
END-OF-SELECTION.
  PERFORM f_alv_salida.
