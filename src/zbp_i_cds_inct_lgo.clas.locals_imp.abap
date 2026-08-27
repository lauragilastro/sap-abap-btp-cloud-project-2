CLASS lhc__inctbdef DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS setDefaultValues FOR DETERMINE ON MODIFY
      keys FOR _inctBdef~setDefaultValues.
    METHODS changeStatus FOR MODIFY
      keys FOR ACTION _inctBdef~changeStatus RESULT result.

ENDCLASS.

CLASS lhc__inctbdef IMPLEMENTATION.

  METHOD setDefaultValues.

    DATA lt_update TYPE TABLE FOR UPDATE zi_cds_inct_lgo.


  LOOP AT keys INTO DATA(ls_key).
    APPEND VALUE #(
      %tky           = ls_key-%tky
      status         = 'OP'
      creation_date  = cl_abap_context_info=>get_system_date( )
      %control-status        = if_abap_behv=>mk-on
      %control-creation_date = if_abap_behv=>mk-on
    ) TO lt_update.
  ENDLOOP.


  MODIFY ENTITIES OF zi_cds_inct_lgo
    ENTITY _inctBdef
      UPDATE FIELDS ( status creation_date )
      WITH lt_update.

  ENDMETHOD.

  METHOD changeStatus.

  DATA lv_previous_status TYPE zde_prev_status_lgo.
DATA lv_current_status  TYPE zde_curr_status_lgo.

 " Leer parámetro que entra del popup
  READ TABLE keys INTO DATA(ls_key) INDEX 1.
  lv_current_status = ls_key-%param-new_status.

  " Leer el estado en el que estaba el status
  READ ENTITIES OF zi_cds_inct_lgo IN LOCAL MODE
    ENTITY _inctBdef
      FIELDS ( status )
      WITH CORRESPONDING #( keys )
    RESULT DATA(lt_incident).

  READ TABLE lt_incident INTO DATA(ls_incident) INDEX 1.
  lv_previous_status = ls_incident-status.

IF lv_current_status = 'CO' AND lv_previous_status <> 'IP'.
  RAISE EXCEPTION TYPE zcx_class_messages_lgo
    EXPORTING
      textid = zcx_class_messages_lgo=>error_co.
ENDIF.

IF lv_current_status = 'CL' AND lv_previous_status <> 'CO'.
  RAISE EXCEPTION TYPE zcx_class_messages_lgo
    EXPORTING
      textid = zcx_class_messages_lgo=>error_cl.
ENDIF.

  ENDMETHOD.

ENDCLASS.


