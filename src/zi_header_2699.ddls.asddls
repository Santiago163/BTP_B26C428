@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Header Data Definition'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZI_HEADER_2699 
 as select from zsoheader_2699
  composition [0..*] of ZI_ITEMS_2699        as _Items
  association [0..1] to ZI_STATUS_2699 as _OrderStatus on $projection.Orderstatus = _OrderStatus.Status
{
  key id                                         as Id,
      email                                      as Email,
      firstname                                  as Firstname,
      lastname                                   as Lastname,
      concat_with_space( firstname, lastname, 1) as CustomerFullName,
      country                                    as Country,
      createon                                   as Createon,
      deliverydate                               as Deliverydate,
      orderstatus                                as Orderstatus,
      imageurl                                   as Imageurl,
      created_by                           as LocalCreatedBy,
      created_at                           as LocalCreatedAt,
      last_changed_by                      as LocalLastChangedBy,
      local_last_changed_at                      as LocalLastChangeAt,
      last_changed_at                            as LastChangeAt,
      _Items,
      _OrderStatus
}
