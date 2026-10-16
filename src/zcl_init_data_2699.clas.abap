CLASS zcl_init_data_2699 DEFINITION
  PUBLIC

  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES: BEGIN OF typ_s_status,
             status TYPE zsoheader_2699-orderstatus,
           END OF typ_s_status,
           typ_t_status          TYPE STANDARD TABLE OF typ_s_status
                           WITH NON-UNIQUE DEFAULT KEY,
           typ_t_zordstatus_2699 TYPE STANDARD TABLE OF zsostatus_2699,
           BEGIN OF typ_s_items,
             name           TYPE zde_name_2699,
             description    TYPE zde_desc_2699,
             price          TYPE zde_price_2699,
             waers          TYPE waers,
             height         TYPE zde_height_2699,
             width          TYPE zde_width_2699,
             depth          TYPE zde_depth_2699,
             dimensions_uom TYPE meins,
             unitofmeasure  TYPE meins,
           END OF typ_s_items,
           typ_t_items TYPE STANDARD TABLE OF typ_s_items
                            WITH NON-UNIQUE DEFAULT KEY.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.

    CLASS-METHODS: get_order_status
      EXPORTING
        st_status       TYPE typ_t_status
        st_status_descr TYPE typ_t_zordstatus_2699,
      get_items
        RETURNING VALUE(rt_items) TYPE typ_t_items.

  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_init_data_2699 IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    DATA: lt_header       TYPE STANDARD TABLE OF zsoheader_2699,
          lt_items        TYPE STANDARD TABLE OF zsoitems_2699,
          lt_status_descr TYPE STANDARD TABLE OF zsostatus_2699,
          lt_order_status TYPE typ_t_status,
          lv_count_header TYPE i,
          lv_count_item   TYPE i,
          lv_id_header    TYPE zsoheader_2699-id,
          lv_id_item      TYPE zsoitems_2699-item_uuid,
          lv_quantity     TYPE i.

    get_order_status(
        IMPORTING
        st_status = lt_order_status
        st_status_descr = lt_status_descr
    ).
    DATA(lt_items_random) = get_items( ).

    out->write( 'Deleting previous data' ).

    DELETE FROM zsoheader_2699.
    DELETE FROM zsoitems_2699.
    DELETE FROM zsostatus_2699.

    DATA(lo_rand) = cl_abap_random=>create( ).

    lv_count_header = 1.
    DO 20 TIMES.
      FINAL(lv_total_items) = lo_rand->intinrange( low = 1 high = 4 ).
      lv_id_header = |{ lv_count_header }|.

      DATA(lv_items_status) = lines(  lt_order_status ).
      DATA(lv_num) = lo_rand->intinrange( low = 1 high = lv_items_status ).
      READ TABLE lt_order_status INTO DATA(ls_order_status) INDEX lv_num.


      lt_header = VALUE #( BASE lt_header (
        id = |{ lv_id_header }|
        email = 'santiagosebastian@gmail.com'
        firstname = 'Santiago'
        lastname = 'Acosta'
        country = 'Ecuador'
        created_by = |{ cl_abap_context_info=>get_user_technical_name( ) }|
        createon = |{ cl_abap_context_info=>get_system_date( ) }|
        deliverydate = |{ cl_abap_context_info=>get_system_date( ) }|
        orderstatus = |{ ls_order_status-status }|
        imageurl = ''
      ) ).

      lv_count_item = 1.
      DO lv_total_items TIMES.
        DATA(lv_num_random_item) = lo_rand->intinrange( low = 1 high = lines(  lt_items_random ) ).
        READ TABLE lt_items_random INTO DATA(ls_item_random) INDEX lv_num_random_item.

        lv_id_item = |{ lv_count_header }:{ lv_count_item }|.
        lv_quantity = lo_rand->intinrange( low = 1 high = 6 ).
        lt_items = VALUE  #(  BASE lt_items (
          id = |{ lv_id_header }|
          item_uuid = |{ lv_id_item }|
          name = ls_item_random-name
          description = ls_item_random-description
          releasedate = |{ cl_abap_context_info=>get_system_date( ) }|
          price = ls_item_random-price * lv_quantity
          waers = ls_item_random-waers
          height = ls_item_random-height
          width = ls_item_random-width
          depth = ls_item_random-depth
          dimensions_uom = ls_item_random-dimensions_uom
          quantity = lv_quantity
          unitofmeasure = ls_item_random-unitofmeasure
        ) ).
        lv_count_item = lv_count_item + 1.

      ENDDO.

      lv_count_header = lv_count_header + 1.
    ENDDO.

    INSERT zsoheader_2699 FROM TABLE @lt_header.
    INSERT zsoitems_2699 FROM TABLE @lt_items.
    INSERT zsostatus_2699 FROM TABLE @lt_status_descr.

  ENDMETHOD.

  METHOD get_order_status.
    st_status = VALUE #( ( status = 1 )  ( status = 2 )
        ( status = 3 )  ( status = 4 ) ( status = 5 )
    ).

    st_status_descr = VALUE #( ( status = 1 description = 'New' )
                               ( status = 2 description = 'Processing' )
                               ( status = 3 description = 'Shipped' )
                               ( status = 4 description = 'Received' ) ( status = 5 description = 'Cancelled' )
    ).
  ENDMETHOD.

  METHOD get_items.
    rt_items = VALUE #(
   (
      name = 'Claw Hammer 16oz' description = 'Steel claw hammer' price = 25
      waers = 'USD' height = 30 width = 12 depth = 4 dimensions_uom = 'CM'
      unitofmeasure = 'ST'
   )
   (
      name = 'Impact Drill 750W' description = 'impact drill' price = 38
      waers = 'USD' height = 25 width = 20 depth = 8 dimensions_uom = 'CM'
      unitofmeasure = 'ST'
   )
   (
      name = 'Screwdriver Set 6pcs' description = 'Phillips screwdrivers' price = 45
      waers = 'USD' height = 22 width = 15 depth = 4 dimensions_uom = 'CM'
      unitofmeasure = 'ST'
   )
   (
      name = 'Adjustable Wrench 12in' description = 'wrench' price = 65
      waers = 'USD' height = 30 width = 8 depth = 2 dimensions_uom = 'CM'
      unitofmeasure = 'ST'
   )
   (
      name = 'Combination Pliers 8in' description = 'pliers' price = 32
      waers = 'USD' height = 20 width = 7 depth = 2 dimensions_uom = 'CM'
      unitofmeasure = 'ST'
   )
   (
      name = 'Professional Hand Saw' description = 'saw for wood cutting' price = 35
      waers = 'USD' height = 45 width = 15 depth = 3 dimensions_uom = 'CM'
      unitofmeasure = 'ST'
   )
   (
      name = 'Measuring Tape 5m' description = 'measuring tape' price = 22
      waers = 'USD' height = 8 width = 8 depth = 4 dimensions_uom = 'CM'
      unitofmeasure = 'ST'
   )
   (
      name = 'Metal Toolbox' description = 'metal toolbox' price = 28
      waers = 'USD' height = 20 width = 40 depth = 20 dimensions_uom = 'CM'
      unitofmeasure = 'ST'
   )
       ).
  ENDMETHOD.
ENDCLASS.
