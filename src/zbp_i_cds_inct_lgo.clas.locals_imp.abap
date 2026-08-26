CLASS lhc__inctbdef DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS setDefaultValues FOR DETERMINE ON MODIFY
      keys FOR _inctBdef~setDefaultValues.

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

ENDCLASS.


