CLASS lhc__inctbdef DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS setDefaultValues FOR DETERMINE ON MODIFY
      keys FOR _inctBdef~setDefaultValues.
    METHODS changeStatus FOR MODIFY
      keys FOR ACTION _inctBdef~changeStatus RESULT result.
    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
        IMPORTING keys REQUEST requested_authorizations FOR _inctBdef RESULT result.

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
DATA lv_responsible TYPE zde_responsible_lgo.

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

" Authorization section
  READ ENTITIES OF zi_cds_inct_lgo IN LOCAL MODE
    ENTITY _inctBdef
      FIELDS ( responsible )
        WITH CORRESPONDING #( keys )
    RESULT DATA(lt_responsible).

READ TABLE lt_responsible INTO DATA(ls_responsible) INDEX 1.
  lv_responsible = ls_responsible-responsible.

IF lv_current_status = 'IP' AND lv_responsible IS INITIAL.
  RAISE EXCEPTION TYPE zcx_class_messages_lgo
    EXPORTING
      textid = zcx_class_messages_lgo=>error_empty_responsible.

ENDIF.

  " Update INCT
  MODIFY ENTITIES OF zi_cds_inct_lgo IN LOCAL MODE
    ENTITY _inctBdef
      UPDATE
        FIELDS ( status changed_date )
        WITH VALUE #( FOR key IN keys (
          %tky        = key-%tky
          status      = lv_current_status
          changed_date = cl_abap_context_info=>get_system_date( ) ) ).

  " Update History (using composition _toHistory)
  MODIFY ENTITIES OF zi_cds_inct_lgo IN LOCAL MODE
    ENTITY _inctBdef
      CREATE BY \_toHistory
        FIELDS ( previous_status new_status text )
        WITH VALUE #( FOR key IN keys (
          %tky              = key-%tky
          %target = VALUE #( (
            %cid            = 'HIST01'
            previous_status = lv_previous_status
            new_status      = lv_current_status
            text            = ls_key-%param-text ) ) ) ).

  ENDMETHOD.

  METHOD get_instance_authorizations.

  READ ENTITIES OF ZI_CDS_INCT_LGO IN LOCAL MODE
    ENTITY _inctBdef
      FIELDS ( responsible )
      WITH CORRESPONDING #( keys )
    RESULT DATA(lt_incidents).

  LOOP AT lt_incidents INTO DATA(ls_incident).

  AUTHORITY-CHECK OBJECT 'Z_AUTH_LGO' ID 'ACTVT' FIELD '02'.

  DATA(lv_authorized) = COND abap_bool(
    WHEN ls_incident-responsible = sy-uname OR sy-subrc = 0
    THEN abap_true
    ELSE abap_false ).

  APPEND VALUE #(
    %tky                  = ls_incident-%tky
    %action-changeStatus  = COND #( WHEN lv_authorized = abap_true
                                       THEN if_abap_behv=>auth-allowed
                                       ELSE if_abap_behv=>auth-unauthorized )
    ) TO result.

  ENDLOOP.

ENDMETHOD.

ENDCLASS.


