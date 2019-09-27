*&---------------------------------------------------------------------*
*&  Include           ZACN_IS_MART_LU_TOP
*&---------------------------------------------------------------------*
TYPE-POOLS:slis.

TABLES: znom_sucursal.

*&---------------------------------------------------------------------*
*& Declaracion de types
*&---------------------------------------------------------------------*

TYPES: BEGIN OF ty_nomina,
                deposito TYPE znom_sucursal-deposito,
                patente TYPE znom_sucursal-patente,
                marca TYPE znom_sucursal-marca,
                ano TYPE znom_sucursal-ano,
                clase TYPE znom_sucursal-clase,

      END OF ty_nomina,

      BEGIN OF ty_entrega,
               patente TYPE znom_entregas-patente,
               entrega TYPE  znom_entregas-entrega,
               rei_plan TYPE znom_entregas-rei_plan,
               deposito TYPE znom_entregas-deposito,
               km_ent TYPE znom_entregas-km_ent,
               km_plan TYPE znom_entregas-km_plan,

      END OF ty_entrega,

      BEGIN OF ty_reintegro,
               patente TYPE zacn_mart_lu-patente,
               rei_real TYPE zacn_mart_lu-rei_real,
               dep_ent TYPE zacn_mart_lu-dep_ent,
               receptor TYPE zacn_mart_lu-receptor,
               km_ent TYPE zacn_mart_lu-km_ent,

      END OF ty_reintegro,

      BEGIN OF ty_sucursal,
               deposito TYPE zdet_sucursal-deposito,
               nombre TYPE zdet_sucursal-nombre,
               calle TYPE zdet_sucursal-calle,
               altura TYPE zdet_sucursal-altura,
               localidad TYPE zdet_sucursal-localidad,

      END OF ty_sucursal,


      BEGIN OF ty_final,
               patente TYPE znom_sucursal-patente,
               marca TYPE znom_sucursal-marca,
               ano TYPE znom_sucursal-ano,
               clase TYPE znom_sucursal-clase,
               entrega TYPE znom_entregas-entrega,
               rei_real TYPE zacn_mart_lu-rei_real,
               ent_diferida TYPE c LENGTH 1,
               dias_excedido TYPE c LENGTH 1,
               km_excedido TYPE c LENGTH 1,
               comentario TYPE c LENGTH 50,

      END OF ty_final.

*&---------------------------------------------------------------------*
*& Declaracion de datos
*&---------------------------------------------------------------------*

DATA: it_nomina TYPE TABLE OF ty_nomina,
      wa_nomina TYPE ty_nomina,
      it_entrega TYPE TABLE OF ty_entrega,
      wa_entrega TYPE ty_entrega,
      it_reintegro TYPE TABLE OF ty_reintegro,
      wa_reintegro TYPE ty_reintegro,
      it_sucursal TYPE TABLE OF ty_sucursal,
      wa_sucursal TYPE ty_sucursal,
      it_final TYPE TABLE OF ty_final,
      wa_final TYPE ty_final,
      it_fieldcat TYPE slis_t_fieldcat_alv,
      wa_layout TYPE slis_layout_alv.
