CLASS zcl_status_priority_data DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.
  PUBLIC SECTION.

  INTERFACES if_oo_adt_classrun.

  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.

CLASS zcl_status_priority_data IMPLEMENTATION.

    METHOD if_oo_adt_classrun~main.

    " Insert info in status table
    INSERT zdt_status_lgo FROM @( VALUE #(
          client = sy-mandt
          status_code = 'OP'
          status_description = 'Open' ) ).

    INSERT zdt_status_lgo FROM @( VALUE #(
          client = sy-mandt
          status_code = 'IP'
          status_description = 'In progress' ) ).

    INSERT zdt_status_lgo FROM @( VALUE #(
          client = sy-mandt
          status_code = 'PE'
          status_description = 'Pending' ) ).

    INSERT zdt_status_lgo FROM @( VALUE #(
          client      = sy-mandt
          status_code = 'CO'
          status_description = 'Completed' ) ).

    INSERT zdt_status_lgo FROM @( VALUE #(
          client      = sy-mandt
          status_code = 'CL'
          status_description = 'Closed' ) ).

    INSERT zdt_status_lgo FROM @( VALUE #(
          client      = sy-mandt
          status_code = 'CN'
          status_description = 'Canceled' ) ).

    " Insert info in priority table
    INSERT zdt_priority_lgo FROM @( VALUE #(
          client      = sy-mandt
          priority_code = 'H'
          priority_description = 'High' ) ).

          INSERT zdt_priority_lgo FROM @( VALUE #(
          client      = sy-mandt
          priority_code = 'M'
          priority_description = 'Medium' ) ).

          INSERT zdt_priority_lgo FROM @( VALUE #(
          client      = sy-mandt
          priority_code = 'L'
          priority_description = 'Low' ) ).

    ENDMETHOD.


ENDCLASS.
