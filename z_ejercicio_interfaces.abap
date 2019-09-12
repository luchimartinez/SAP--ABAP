*&---------------------------------------------------------------------*
*& Report  Z_USER10_EJERCICIO_BI
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT  z_user10_ejercicio_bi.
*&---------------------------------------------------------------------*
*&Declarion de tablas
*&---------------------------------------------------------------------*
TABLES: bdcdata, bdcmsgcoll.

*&---------------------------------------------------------------------*
*&Declarion de types
*&---------------------------------------------------------------------*
TYPES: BEGIN OF ty_file,
                kunnr TYPE zuser10cliente-kunnr,
                razon TYPE zuser10cliente-razon,
                observ TYPE zuser10cliente-observ,
       END OF ty_file.
*&---------------------------------------------------------------------*
*&Declarion de datos
*&---------------------------------------------------------------------*
DATA: it_file TYPE TABLE OF ty_file,
      wa_file TYPE ty_file,
      it_bdc TYPE TABLE OF bdcdata, " NO se usa todavia
      wa_bdc_tab TYPE bdcdata,
      it_file_txt TYPE TABLE OF string,
      wa_file_txt TYPE string,
      it_bdc_msg TYPE TABLE OF bdcmsgcoll. "para mensajes, NO se usa todavia
*&---------------------------------------------------------------------*
*&Pantalla de seleccion
*&---------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-001.
PARAMETERS p_file TYPE string DEFAULT 'C:\Users\t11641.training05\Desktop\prov.txt'.
SELECTION-SCREEN END OF BLOCK b1.
*&---------------------------------------------------------------------*
*&Start of selection
*&---------------------------------------------------------------------*
START-OF-SELECTION.

  PERFORM f_leer_file.
  "PERFORM .

  LOOP AT it_file INTO wa_file.
    REFRESH it_bdc.

    PERFORM  f_llenar_it_bdc USING:
          'X'   'SAPMSVMA' '0100',
          ' '   'BDC_CURSOR' 'VIEWNAME',
          ' '   'BDC_OKCODE' '=UPD',

          'X'   'SAPLZUSER10CLIENTE' '0001',
          ' '   'BDC_CURSOR'  'ZUSER10CLIENTE-KUNNR(01)',
          ' '   'BDC_OKCODE'  '=NEWL',

          'X'   'SAPLZUSER10CLIENTE'  '0001',
          ' '   'BDC_CURSOR' 'ZUSER10CLIENTE-KUNNR(01)',
          ' '   'BDC_OKCODE' '/00',
          ' '   'ZUSER10CLIENTE-KUNNR(01)'  wa_file-kunnr,

          'X'   'SAPLZUSER10CLIENTE' '0001',
          ' '   'BDC_CURSOR' 'ZUSER10CLIENTE-RAZON(01)',
          ' '   'BDC_OKCODE'  '/00',
          ' '   'ZUSER10CLIENTE-RAZON(01)'  wa_file-razon,

          'X'   'SAPLZUSER10CLIENTE' '0001',
          ' '   'BDC_CURSOR' 'ZUSER10CLIENTE-OBSERV(01)',
          ' '   'BDC_OKCODE' '/00',
          ' '   'ZUSER10CLIENTE-OBSERV(01)'  wa_file-observ,

          'X'   'SAPLZUSER10CLIENTE' '0001',
          ' '   'BDC_CURSOR' 'ZUSER10CLIENTE-KUNNR(03)',
          ' '   'BDC_OKCODE' '=SAVE',

          'X'   'SAPLZUSER10CLIENTE'  '0001',
          ' '   'BDC_CURSOR' 'ZUSER10CLIENTE-KUNNR(03)',
          ' '   'BDC_OKCODE' '=BACK',

          'X'   'SAPLZUSER10CLIENTE'  '0001',
          ' '   'BDC_CURSOR'  'ZUSER10CLIENTE-KUNNR(03)',
          ' '   'BDC_OKCODE'  '=BACK',

          'X'   'SAPMSVMA'  '0100',
          ' '   'BDC_OKCODE' '/EBACK',
          ' '   'BDC_CURSOR' 'VIEWNAME' .

    CALL TRANSACTION 'SM30' USING it_bdc MODE 'a'.
ENDLOOP.

*&---------------------------------------------------------------------*
*&      Form  F_LEER_FILE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_leer_file .
  CALL METHOD cl_gui_frontend_services=>gui_upload
    EXPORTING
      filename                = p_file " se pone el selector de la ruta donde esta el archivo
    CHANGING
      data_tab                = it_file_txt
    EXCEPTIONS
      file_open_error         = 1
      file_read_error         = 2
      no_batch                = 3
      gui_refuse_filetransfer = 4
      invalid_type            = 5
      no_authority            = 6
      unknown_error           = 7
      bad_data_format         = 8
      header_not_allowed      = 9
      separator_not_allowed   = 10
      header_too_long         = 11
      unknown_dp_error        = 12
      access_denied           = 13
      dp_out_of_memory        = 14
      disk_full               = 15
      dp_timeout              = 16
      not_supported_by_gui    = 17
      error_no_gui            = 18
      OTHERS                  = 19.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
               WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  LOOP AT it_file_txt INTO wa_file_txt.
    SPLIT wa_file_txt AT '|'
    INTO wa_file-kunnr
         wa_file-razon
         wa_file-observ.
    APPEND wa_file TO it_file.

  ENDLOOP.

  REFRESH it_file_txt.

ENDFORM.                    " F_LEER_FILE




                   " F_EXEC_BI
*&---------------------------------------------------------------------*
*&      Form  F_LLENAR_IT_BDC
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_llenar_it_bdc USING dynbegin name value .

  IF dynbegin = 'X'.
    CLEAR wa_bdc_tab.
    MOVE: name TO wa_bdc_tab-program,
          value TO wa_bdc_tab-dynpro,
          'X' TO wa_bdc_tab-dynbegin.
    APPEND wa_bdc_tab TO it_bdc.
  ELSE.
    CLEAR wa_bdc_tab.
    MOVE: name TO wa_bdc_tab-fnam,
          value TO wa_bdc_tab-fval.
    APPEND wa_bdc_tab TO it_bdc.

  ENDIF.

ENDFORM.                    " F_LLENAR_IT_BDC
