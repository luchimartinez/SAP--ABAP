*&---------------------------------------------------------------------*
*& Report  ZACP_BI_USER10
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

REPORT  zacp_bi_user10.
"
*&---------------------------------------------------------------------*
*& Declaracion de types
*&---------------------------------------------------------------------*

TYPES: BEGIN OF ty_file,
                nro_cliente type zacp_user10-nrocliente, "declaro tipo de tabla transparente q ya cree
                moroso TYPE zacp_user10-moroso,
                fecha TYPE  zacp_user10-fecha,

       END OF ty_file.

*&---------------------------------------------------------------------*
*& Declaracion de datos
*&---------------------------------------------------------------------*

DATA: it_datos TYPE TABLE OF ty_file,  "para convertir el
      wa_datos TYPE ty_file,
      it_txt TYPE TABLE OF string,  "para traer el archivo
      wa_txt TYPE string,
      it_filetable TYPE filetable,
      v_return TYPE i,
      it_bdcdata TYPE TABLE OF bdcdata, "este tipo es NECESARIO para hacer el archivo
      wa_bdcdata TYPE bdcdata.

*&---------------------------------------------------------------------*
*&Selection screen
*&---------------------------------------------------------------------*

SELECTION-SCREEN BEGIN OF block b1 WITH FRAME TITLE text-001.
  PARAMETERS: p_file TYPE string.
SELECTION-SCREEN END OF block b1.

*&---------------------------------------------------------------------*
*&At selection screen
*&---------------------------------------------------------------------*

AT SELECTION-SCREEN on VALUE-REQUEST FOR p_file.

  CALL METHOD cl_gui_frontend_services=>file_open_dialog
    EXPORTING
      window_title            = 'Select file'
      default_extension       = '.txt'
    CHANGING
      file_table              = it_filetable
      rc                      = v_return
    EXCEPTIONS
      file_open_dialog_failed = 1
      cntl_error              = 2
      error_no_gui            = 3
      not_supported_by_gui    = 4
      others                  = 5
          .
   IF sy-subrc = 0.
    CLEAR p_file.
    READ TABLE it_filetable INTO p_file INDEX 1.
    IF sy-subrc NE 0.
      CLEAR p_file.
    ENDIF.
  ENDIF.

*&---------------------------------------------------------------------*
*& Start of selection
*&---------------------------------------------------------------------*

START-OF-SELECTION.

PERFORM leer_archivo.
PERFORM ejecutar_batchinput.

INCLUDE ZACP_BI_USER10_LEER_ARCHIVOF01. " va al final de los perform xq sino no los lee
