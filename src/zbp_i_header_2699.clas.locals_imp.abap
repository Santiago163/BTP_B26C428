CLASS lhc_soheader DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PUBLIC SECTION.
    CLASS-DATA:
      already_saved TYPE abap_boolean.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      keys REQUEST requested_features FOR soheader RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      keys REQUEST requested_authorizations FOR soheader RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      REQUEST requested_authorizations FOR soheader RESULT result.
    METHODS setlastchange FOR DETERMINE ON SAVE
       keys FOR soheader~setlastchange.
    METHODS validateorderemail FOR VALIDATE ON SAVE
       keys FOR soheader~validateorderemail.
    METHODS validateorderstatus FOR VALIDATE ON SAVE
       keys FOR soheader~validateorderstatus.
ENDCLASS.

CLASS lhc_soheader IMPLEMENTATION.

  METHOD get_instance_features.
  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD setLastChange.
    IF lhc_soHeader=>already_saved EQ abap_false.
      lhc_soHeader=>already_saved = abap_true.
      READ ENTITIES OF zi_header_2699 IN LOCAL MODE
          ENTITY soheader
          FIELDS ( Id LastChangeAt )
          WITH CORRESPONDING #(  keys )
          RESULT DATA(lt_headers).

      MODIFY ENTITIES OF zi_header_2699 IN LOCAL MODE
         ENTITY soheader
         UPDATE FIELDS (  LastChangeAt )
         WITH VALUE #(  FOR ls_header IN lt_headers (
             %tky = ls_header-%tky
             LastChangeAt = |{ cl_abap_context_info=>get_system_date( ) }|
               LocalLastChangedBy  = |{ cl_abap_context_info=>get_user_technical_name( )    }|
         ) ).
    ENDIF.

  ENDMETHOD.
  METHOD validateOrderEmail.
    READ ENTITIES OF zi_header_2699 IN LOCAL MODE
          ENTITY soHeader
          FIELDS ( Email )
          WITH CORRESPONDING #(  keys )
          RESULT DATA(lt_headers)
          FAILED DATA(lt_read_failed).

    failed = CORRESPONDING #(  DEEP Lt_read_failed ).

    LOOP AT lt_headers INTO DATA(ls_header).
      APPEND VALUE #( %tky = ls_header-%tky
          %state_area = 'VALIDATE_ORDER_EMAIL'
      ) TO reported-soheader.

      IF ls_header-Email IS INITIAL OR NOT contains( val = ls_header-Email sub = '@' ).
        APPEND VALUE #( %tky = ls_header-%tky ) TO failed-soheader.

        APPEND VALUE #( %tky = ls_header-%tky
            %state_area = 'VALIDATE_ORDER_EMAIL'
            %msg = me->new_message_with_text(
                severity = if_abap_behv_message=>severity-error
                text = |The order email must not be empty or doesn't have correct format|
            )
            %element-orderstatus = if_abap_behv=>mk-on
        ) TO reported-soheader.
      ENDIF.

    ENDLOOP.
  ENDMETHOD.
  METHOD validateOrderStatus.
    READ ENTITIES OF zi_header_2699 IN LOCAL MODE
          ENTITY soheader
          FIELDS ( Orderstatus )
          WITH CORRESPONDING #(  keys )
          RESULT DATA(lt_headers)
          FAILED DATA(lt_read_failed).

    failed = CORRESPONDING #(  DEEP Lt_read_failed ).

    LOOP AT lt_headers INTO DATA(ls_header).
      SELECT SINGLE status
      FROM zsostatus_2699
      WHERE status EQ @ls_header-Orderstatus
      INTO @DATA(lv_status)
      PRIVILEGED ACCESS.

      APPEND VALUE #( %tky = ls_header-%tky
          %state_area = 'VALIDATE_ORDER_STATUS'
      ) TO reported-soheader.

      IF lv_status IS INITIAL.
        APPEND VALUE #( %tky = ls_header-%tky ) TO failed-soheader.

        APPEND VALUE #( %tky = ls_header-%tky
            %state_area = 'VALIDATE_ORDER_STATUS'
            %msg = me->new_message_with_text(
                severity = if_abap_behv_message=>severity-error
                text = |The order status { ls_header-Orderstatus } does not exist|
            )
            %element-orderstatus = if_abap_behv=>mk-on
        ) TO reported-soheader.
      ENDIF.

    ENDLOOP.



  ENDMETHOD.
ENDCLASS.
