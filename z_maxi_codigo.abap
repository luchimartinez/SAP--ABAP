*&---------------------------------------------------------------------*
*& Report  ZUSER10_EJ_BAPI
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT  zuser10_ej_bapi.
*&---------------------------------------------------------------------*
*&Declaracion de tablas
*&---------------------------------------------------------------------*
TABLES: mara, makt, bdcdata, bdcmsgcoll.
TYPE-POOLS: slis.
*&---------------------------------------------------------------------*
*&Declaracion de types
*&---------------------------------------------------------------------*
TYPES: BEGIN OF ty_file, "esta tabla tiene los campos a completar del txt
                matnr TYPE mara-matnr,
                maktx TYPE makt-maktx,
                mstae TYPE mara-mstae,
                date TYPE sy-datum,
                msg TYPE string,

       END OF ty_file,

**       BEGIN OF ty_msg, "esta tiene los mismos pero le suma un mensaje a devolver despues
**                kunnr TYPE mara-matnr,
**                razon TYPE makt-maktx,
**                observ TYPE mara-mstae,
**                date TYPE sy-datum,
**                msg TYPE string,
**       END OF ty_msg.
       BEGIN OF t_bapi,
         matnr TYPE mara-matnr, " Material Number
         desc  TYPE bapimatdoa-matl_desc, " Material Description
       END OF t_bapi.

*&---------------------------------------------------------------------*
*&Declarion de datos
*&---------------------------------------------------------------------
DATA: it_file TYPE TABLE OF ty_file, "tabla final con todos los datos correctos
      wa_file TYPE ty_file,
      it_bdc TYPE TABLE OF bdcdata, " NO se usa todavia
      wa_bdc_tab TYPE bdcdata,
      it_file_txt TYPE TABLE OF string,"esta tabla la uso para cambiarle la fecha al formato q me conviene
      wa_file_txt TYPE string,
      it_bdc_msg TYPE TABLE OF bdcmsgcoll, "para mensajes, NO se usa todavia
      wa_bdc_msg TYPE bdcmsgcoll,
      wa_headdata TYPE bapimathead,
      wa_return TYPE bapiret2,
      it_materialdesc TYPE TABLE OF t_bapi,
      it_bapi TYPE TABLE OF t_bapi,
      wa_bapi TYPE t_bapi,
      wa_materialdesc TYPE bapi_makt,
      wa_mt_data TYPE bapimatdoa,
      lv_fecha TYPE c LENGTH 10,
      it_fieldcat TYPE slis_t_fieldcat_alv,
      wa_layout       TYPE slis_layout_alv,
      it_filetable TYPE filetable,
      v_return TYPE i.


FIELD-SYMBOLS <fs_file> TYPE ty_file.

*&---------------------------------------------------------------------*
*&At selection screen
*&---------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-001.
PARAMETERS p_file TYPE string. "DEFAULT 'C:\Users\t11641.training05\Desktop\campos.txt'.
SELECTION-SCREEN END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE text-002.
PARAMETERS: rb_bi RADIOBUTTON GROUP gr1,
            rb_bapi RADIOBUTTON GROUP gr1.
SELECTION-SCREEN END OF BLOCK b2.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.

  CALL METHOD cl_gui_frontend_services=>file_open_dialog
    EXPORTING
      window_title            = 'Ingrese un archivo'
      default_extension       = '.txt'
    CHANGING
      file_table              = it_filetable
      rc                      = v_return
    EXCEPTIONS
      file_open_dialog_failed = 1
      cntl_error              = 2
      error_no_gui            = 3
      not_supported_by_gui    = 4
      OTHERS                  = 5.
  IF sy-subrc = 0.
    READ TABLE it_filetable INTO p_file INDEX 1.


  ENDIF.
*&---------------------------------------------------------------------*
*&Start of selection
*&---------------------------------------------------------------------*
START-OF-SELECTION.

  DATA: v_contador TYPE i.
  v_contador = STRLEN( p_file ). "creo un contador para que me cuente los digitos del archivo q met
  v_contador = v_contador - 3.   "para que reste 3 al largo total

  IF p_file+v_contador(3) <> 'TXT'. "para que se pare en los ultimos tres digitos q se supone es la extension y compruebe si es diferente a txt
    "todo lo q esta entre ' ' va EN MAYUSCULAS
    MESSAGE i001(zu10_error) DISPLAY LIKE 'E'. "s para q no me corteel programa y display like e para q aparezca como si fuera un error
  ELSE.

    PERFORM llenar_tabla.
    PERFORM datos_batch_input.
    PERFORM data_alv.

  ENDIF.
*&---------------------------------------------------------------------*
*&      Form  LLENAR_TABLA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM llenar_tabla .
  CALL METHOD cl_gui_frontend_services=>gui_upload "la primera es l clase y la segunda el objeto
    EXPORTING
      filename                = p_file
    CHANGING
      data_tab                = it_file_txt  "lo hago ingresar en la txt para cambiarle la fecha
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
      OTHERS                  = 19
          .
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
               WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  LOOP AT it_file_txt INTO wa_file_txt.  "Hago esto para ingresar los datos externos a la tabla principal
    SPLIT wa_file_txt AT ';'
    INTO wa_file-matnr
         wa_file-maktx
         wa_file-mstae
         lv_fecha.

    CONCATENATE lv_fecha+6(4)    "Hago esto para cambiar el formato de fecha de DDMMYYYY a YYYYMMDD
                lv_fecha+3(2)
                lv_fecha(2)
    INTO wa_file-date.

    APPEND wa_file TO it_file.  "aca estan los productos con LAS FECHAS

  ENDLOOP.

  REFRESH it_file_txt.

ENDFORM.                    " LLENAR_TABLA
*&---------------------------------------------------------------------*
*&      Form  DATOS_BATCH_INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM datos_batch_input .

  IF rb_bi IS NOT INITIAL.  " = no esta vacio

    LOOP AT it_file ASSIGNING <fs_file>.  "INTO wa_file.

      PERFORM f_rellenar_tabla_bdcdata USING: 'X' 'SAPLMGMM' '0060' ,
            ' ' 'BDC_CURSOR' 'RMMG1-MATNR' ,
            ' ' 'BDC_OKCODE' '=ENTR' ,
            ' ' 'RMMG1-MATNR' <fs_file>-matnr ,

            'X' 'SAPLMGMM' '0070' ,
            ' ' 'BDC_CURSOR' 'MSICHTAUSW-DYTXT(01)' ,
            ' ' 'BDC_OKCODE' '=ENTR' ,
            ' ' 'MSICHTAUSW-KZSEL(01)' 'X' ,

            'X' 'SAPLMGMM' '4004' ,
            ' ' 'BDC_OKCODE' '=BU' ,
            ' ' 'BDC_SUBSCR' 'SAPLMGMM                                2004TABFRA1'  ,
            ' ' 'BDC_SUBSCR' 'SAPLMGD1                                1002SUB1'.

      IF <fs_file>-date < sy-datum.
        PERFORM f_rellenar_tabla_bdcdata USING ' '  'MAKT-MAKTX'  <fs_file>-maktx.

      ENDIF.

      PERFORM f_rellenar_tabla_bdcdata USING:   ' ' 'BDC_SUBSCR' 'SAPLMGD1                                2001SUB2' ,

            ' ' 'BDC_CURSOR' 'MARA-MSTAE' ,
            ' ' 'MARA-MEINS' 'PC' .

      IF <fs_file>-date > sy-datum.
        PERFORM f_rellenar_tabla_bdcdata USING  ' ' 'MARA-MSTAE' <fs_file>-mstae.
      ENDIF.

      PERFORM f_rellenar_tabla_bdcdata USING: ' ' 'BDC_SUBSCR' 'SAPLMGD1                                2561SUB3' ,

            ' ' 'BDC_SUBSCR' 'SAPLMGD1                                2007SUB4' ,
            ' ' 'BDC_SUBSCR'  'SAPLMGD1                                2005SUB5' ,
            ' ' 'BDC_SUBSCR' 'SAPLMGD1                                2011SUB6' ,
            ' ' 'BDC_SUBSCR' 'SAPLMGD1                                2033SUB7' ,
            ' ' 'BDC_SUBSCR' 'SAPLMGD1                                0001SUB8' ,
            ' ' 'BDC_SUBSCR' 'SAPLMGD1                                0001SUB9' ,
            ' ' 'BDC_SUBSCR' 'SAPLMGD1                                0001SUB10'.

      CALL TRANSACTION 'MM02' USING it_bdc MODE 'N' MESSAGES INTO it_bdc_msg. " con it_bdc le paso las instrucciones de a donde tiene q apuntar
      "NO podes llamar a la tabla q estas loopeando
      LOOP AT it_bdc_msg INTO wa_bdc_msg .
        IF  wa_bdc_msg-msgtyp = 'E'.
          <fs_file>-msg  = 'NO'.
        ELSE.
          <fs_file>-msg = 'OK'.
        ENDIF.

      ENDLOOP.

      REFRESH it_bdc_msg.

    ENDLOOP.

  ELSE.

    PERFORM completar_bapi.

  ENDIF.

ENDFORM.                    " DATOS_BATCH_INPUT
*&---------------------------------------------------------------------*
*&      Form  COMPLETAR_BAPI
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM completar_bapi .

  DATA: lv_dia TYPE tagbez,
        lv_dia_numerico TYPE sy-datum,
        langu TYPE syst-langu.

  FIELD-SYMBOLS <fs_mensaje> TYPE ty_file.

  lv_dia_numerico = sy-datum.

  LOOP AT it_file ASSIGNING <fs_mensaje>.

    CALL FUNCTION 'RH_GET_DATE_DAYNAME'
      EXPORTING
        langu               = 'S'
        date                = lv_dia_numerico
      IMPORTING
        daytxt              = lv_dia
      EXCEPTIONS
        no_langu            = 1
        no_date             = 2
        no_daytxt_for_langu = 3
        invalid_date        = 4
        OTHERS              = 5.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

    CONCATENATE <fs_mensaje>-maktx
              sy-uname
              lv_dia
              INTO <fs_mensaje>-maktx
              SEPARATED BY ' - '.

    wa_headdata-material = <fs_mensaje>-matnr.
    wa_materialdesc-langu     = sy-langu.
    wa_materialdesc-matl_desc = <fs_mensaje>-maktx.

    APPEND wa_materialdesc TO it_materialdesc.

    CALL FUNCTION 'BAPI_MATERIAL_SAVEDATA'
      EXPORTING
        headdata            = wa_headdata
      IMPORTING
        return              = wa_return
      TABLES
        materialdescription = it_materialdesc.

    IF wa_return-type EQ 'S'.
      <fs_mensaje>-msg = 'OK'.
    ELSE.
      <fs_mensaje>-msg = 'no'.
    ENDIF.

    CLEAR wa_materialdesc.
    lv_dia_numerico = lv_dia_numerico + 1.
  ENDLOOP.

  LOOP AT it_file ASSIGNING <fs_file>.

    CALL FUNCTION 'BAPI_MATERIAL_GET_DETAIL'
      EXPORTING
        material              = <fs_file>-matnr
      IMPORTING
        material_general_data = wa_mt_data.


    wa_bapi-matnr = <fs_file>-matnr.
    wa_bapi-desc = wa_mt_data-matl_desc.

    APPEND wa_bapi TO it_bapi.
    CLEAR wa_mt_data.
  ENDLOOP.


ENDFORM.                    " COMPLETAR_BAPI
*&---------------------------------------------------------------------*
*&      Form  COMPLETAR_BI
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_0398   text
*      -->P_0399   text
*      -->P_0400   text
*----------------------------------------------------------------------*
FORM f_rellenar_tabla_bdcdata  USING dyn name value.

  IF dyn = 'X'.

    CLEAR wa_bdc_tab.
    wa_bdc_tab-program = name.
    wa_bdc_tab-dynpro = value.
    wa_bdc_tab-dynbegin = 'X'.
    APPEND wa_bdc_tab TO it_bdc.

  ELSE.

    CLEAR wa_bdc_tab.
    wa_bdc_tab-fnam = name.
    wa_bdc_tab-fval = value.
    APPEND wa_bdc_tab TO it_bdc.

  ENDIF.

ENDFORM.                    " COMPLETAR_FECHA
*&---------------------------------------------------------------------*
*&      Form  COMPLETAR_STATUS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_0420   text
*      -->P_0421   text
*      -->P_WA_FILE_MSTAE  text
*----------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Form  DATA_ALV
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM data_alv .

  DATA: wa_fieldcat TYPE slis_fieldcat_alv.

  wa_fieldcat-fieldname       = 'MATNR'.
  wa_fieldcat-tabname         = 'IT_FILE'.
  wa_fieldcat-ref_fieldname   = 'MANDT'.
  wa_fieldcat-seltext_m = 'MATNR'.
  wa_fieldcat-seltext_l = 'MATNR'.
  wa_fieldcat-outputlen = 15.
  wa_fieldcat-just = 'C'.

  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname       = 'MAKTX'.
  wa_fieldcat-tabname         = 'IT_FILE'.
  wa_fieldcat-ref_fieldname   = 'MAKTX'.
  wa_fieldcat-seltext_m = 'MAKTX'.
  wa_fieldcat-seltext_l = 'MAKTX'.
  wa_fieldcat-outputlen = 30.
  wa_fieldcat-just = 'C'.

  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname       = 'MSTAE'.
  wa_fieldcat-tabname         = 'IT_FILE'.
  wa_fieldcat-ref_fieldname   = 'MSTAE'.
  wa_fieldcat-seltext_m = 'MSTAE'.
  wa_fieldcat-seltext_l = 'MSTAE'.
  wa_fieldcat-outputlen = 15.
  wa_fieldcat-just = 'C'.

  APPEND wa_fieldcat TO it_fieldcat.

  wa_fieldcat-fieldname       = 'MSG'.
  wa_fieldcat-tabname         = 'IT_FILE'.
  wa_fieldcat-ref_fieldname   = 'MSTAE'.
  wa_fieldcat-seltext_m = 'MSG'.
  wa_fieldcat-seltext_l = 'MSG'.
  wa_fieldcat-outputlen = 15.
  wa_fieldcat-just = 'C'.

  APPEND wa_fieldcat TO it_fieldcat.


  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program = sy-repid
      is_layout          = wa_layout
      it_fieldcat        = it_fieldcat
    TABLES
      t_outtab           = it_file
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

ENDFORM.                    " DATA_ALV
