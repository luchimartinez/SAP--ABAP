*----------------------------------------------------------------------*
***INCLUDE ZACP_BI_USER10_LEER_ARCHIVOF01 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  LEER_ARCHIVO
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM leer_archivo .

  CALL METHOD cl_gui_frontend_services=>gui_upload
    EXPORTING
      filename                = p_file
      filetype                = 'ASC'
    CHANGING
      data_tab                = it_txt
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
  IF sy-subrc NE 0.
    REFRESH it_txt.
  ENDIF.

ENDFORM.                    " LEER_ARCHIVO
*&---------------------------------------------------------------------*
*&      Form  EJECUTAR_BATCHINPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM ejecutar_batchinput .

  DATA: lv_datum TYPE sy-datum.

  LOOP AT it_txt INTO wa_txt. " si la wa es tipo string la puedo tratar como una variable

    wa_datos-nro_cliente = wa_txt(10).  "paso directamente la cadena de string recortada  las varibles de l wa final para apendearla directo despues
    wa_datos-moroso = wa_txt+10(1).
    wa_datos-fecha = wa_txt+11(8).

    WRITE wa_datos-fecha to lv_datum .

    PERFORM f_rellenar_tabla_bdcdata USING:
            'X' 'SAPMSVMA' '0100' ,
            ' ' 'BDC_CURSOR' 'VIEWNAME' ,
            ' ' 'BDC_OKCODE' '=UPD',
            ' ' 'VIEWNAME' 'ZACP_USER10' ,
            ' ' 'VIMDYNFLDS-LTD_DTA_NO' 'X' ,

            'X' 'SAPLZACP_USER10' '0001' ,
            ' ' 'BDC_CURSOR' 'ZACP_USER10-NROCLIENTE(01)' ,
            ' ' 'BDC_OKCODE' '=NEWL' ,

            'X' 'SAPLZACP_USER10' '0001' ,
            ' ' 'BDC_CURSOR' 'ZACP_USER10-FECHA(01)' ,
            ' ' 'BDC_OKCODE' '=BACK' ,
            ' ' 'ZACP_USER10-NROCLIENTE(01)' wa_datos-nro_cliente ,
            ' ' 'ZACP_USER10-MOROSO(01)' wa_datos-moroso ,
            ' ' 'ZACP_USER10-FECHA(01)' lv_datum ,

            'X' 'SAPLZACP_USER10' '0001' ,
            ' ' 'BDC_CURSOR' 'ZACP_USER10-FECHA(01)' ,
            ' ' 'BDC_OKCODE' '=BACK' ,

            'X' 'SAPLSPO1' '0100' ,
            ' ' 'BDC_OKCODE' '=YES' ,

            'X' 'SAPMSVMA' '0100' ,
            ' ' 'BDC_OKCODE' '/EBACK' ,
            ' ' 'BDC_CURSOR' 'VIEWNAME' .


    CALL TRANSACTION 'SM30' USING it_bdcdata MODE 'N'. "transaccion donde hice la grabacion

    APPEND wa_datos TO it_datos.

    REFRESH it_bdcdata. "hay q limpiarla para q no cargue los mismos datos

  ENDLOOP.

    LOOP AT it_datos INTO wa_datos.

      WRITE: /, wa_datos-nro_cliente,
                wa_datos-moroso,
                wa_datos-fecha.

      CLEAR wa_datos.
    ENDLOOP.

ENDFORM.                    " EJECUTAR_BATCHINPUT
*&---------------------------------------------------------------------*
*&      Form  F_RELLENAR_TABLA_BDCDATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_0110   text
*      -->P_0111   text
*      -->P_0112   text
*----------------------------------------------------------------------*
FORM f_rellenar_tabla_bdcdata  USING  dyn name value.


  IF dyn = 'X'.

    CLEAR wa_bdcdata.
    wa_bdcdata-program = name.
    wa_bdcdata-dynpro = value.
    wa_bdcdata-dynbegin = 'X'.
    APPEND wa_bdcdata TO it_bdcdata.

  ELSE.

    CLEAR wa_bdcdata.
    wa_bdcdata-fnam = name.
    wa_bdcdata-fval = value.
    APPEND wa_bdcdata TO it_bdcdata.

  ENDIF.

ENDFORM.                    " F_RELLENAR_TABLA_BDCDATA
