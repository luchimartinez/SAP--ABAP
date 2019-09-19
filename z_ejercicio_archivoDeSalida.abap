*&---------------------------------------------------------------------*
*& Report  Z_USER10_SALIDA_ARCHIVO
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

REPORT  z_user10_salida_archivo.
*& ZUSER10_TRX_EJ16 transaccion correspondiente

*&---------------------------------------------------------------------*
*& Declaracion de types
*&---------------------------------------------------------------------*
TYPES: BEGIN OF ty_fli,
                carrid TYPE spfli-carrid,
                connid TYPE spfli-carrid,
                cityfrom TYPE spfli-cityfrom,
                cityto TYPE spfli-cityto,
       END OF ty_fli,

       BEGIN OF ty_scarr,
                carrid TYPE scarr-carrid,
                carrname TYPE scarr-carrname,
       END OF ty_scarr,

       BEGIN OF ty_final,
                carrid TYPE spfli-carrid,
                connid TYPE spfli-carrid,
                cityfrom TYPE spfli-cityfrom,
                cityto TYPE spfli-cityto,
                carrname TYPE scarr-carrname,
       END OF ty_final.
*&---------------------------------------------------------------------*
*& Declaracion de datos
*&---------------------------------------------------------------------*
DATA: it_fli TYPE TABLE OF ty_fli,
      wa_fli TYPE ty_fli,
      it_scarr TYPE TABLE OF ty_scarr,
      wa_scarr TYPE ty_scarr,
      it_final TYPE TABLE OF  ty_final,
      wa_final TYPE ty_final.
*&---------------------------------------------------------------------*
*& Declaracion de tablas
*&---------------------------------------------------------------------*
TABLES: spfli, scarr.
*&---------------------------------------------------------------------*
*& At selection screen
*&---------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-001.
SELECT-OPTIONS s_connid FOR spfli-connid.
SKIP.
PARAMETERS: p_checkb AS CHECKBOX,
            p_folder TYPE string.
SKIP.
SELECTION-SCREEN END OF BLOCK b1.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_folder.
  PERFORM f_directorio.
*&---------------------------------------------------------------------*
*& Start of selection
*&---------------------------------------------------------------------*
START-OF-SELECTION.

  SELECT carrid connid cityfrom cityto
  FROM spfli
  INTO TABLE it_fli
  WHERE connid IN s_connid.

  IF sy-subrc = 0.

    SELECT carrid carrname
    FROM scarr
    INTO TABLE it_scarr
    FOR ALL ENTRIES IN it_fli
    WHERE carrid = it_fli-carrid.

    WRITE'OK'.
  ELSE.
    WRITE 'NOP'.
  ENDIF.

  SORT: it_fli, it_scarr. "siempre ordenar antes de hacer un read

  LOOP AT it_fli INTO wa_fli. "no es necesario limpiar esta wa xq se pisa constantemente

    READ TABLE it_scarr INTO wa_scarr
    WITH KEY carrid = wa_fli-carrid
    BINARY SEARCH.
    IF sy-subrc = 0.
      wa_final-carrname = wa_scarr-carrname. " si obtuve datos q los copie, si se hace afuera queda vacio
    ENDIF.

    wa_final-carrid = wa_fli-carrid.
    wa_final-connid = wa_fli-connid.
    wa_final-cityfrom = wa_fli-cityfrom.
    wa_final-cityto = wa_fli-cityto.

    APPEND wa_final TO it_final.
    WRITE: /, wa_final-carrid, wa_final-connid, wa_final-cityfrom, wa_final-cityto, wa_final-carrname.
    CLEAR: wa_scarr, wa_final.
  ENDLOOP.

  IF it_final IS INITIAL.
    MESSAGE e208(00) WITH text-003.
  ELSE.
    PERFORM f_down_file.
  ENDIF.

*&---------------------------------------------------------------------*
*&      Form  F_DIRECTORIO
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form F_DIRECTORIO .

  CALL METHOD cl_gui_frontend_services=>directory_browse
    EXPORTING
      window_title    = 'Seleccione la carpeta'
      initial_folder  = 'C:'
    CHANGING
      selected_folder = p_folder
    EXCEPTIONS
      cntl_error      = 1
      error_no_gui    = 2.


endform.                    " F_DIRECTORIO
*&---------------------------------------------------------------------*
*&      Form  F_DOWN_FILE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form F_DOWN_FILE .

DATA: lv_ruta TYPE string.

  CONCATENATE p_folder
              '\'
              'HE AQUI EL ARCHIVO!!!'
              sy-datum
              sy-timlo
              '.txt'
         INTO lv_ruta.


  CALL METHOD cl_gui_frontend_services=>gui_download
    EXPORTING
      filename                = lv_ruta
    CHANGING
      data_tab                = it_final
    EXCEPTIONS
      file_write_error        = 1
      no_batch                = 2
      gui_refuse_filetransfer = 3
      invalid_type            = 4
      no_authority            = 5
      unknown_error           = 6
      header_not_allowed      = 7
      separator_not_allowed   = 8
      filesize_not_allowed    = 9
      header_too_long         = 10
      dp_error_create         = 11
      dp_error_send           = 12
      dp_error_write          = 13
      unknown_dp_error        = 14
      access_denied           = 15
      dp_out_of_memory        = 16
      disk_full               = 17
      dp_timeout              = 18
      file_not_found          = 19
      dataprovider_exception  = 20
      control_flush_error     = 21
      not_supported_by_gui    = 22
      error_no_gui            = 23
      OTHERS                  = 24.

  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
               WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

endform.                    " F_DOWN_FILE
