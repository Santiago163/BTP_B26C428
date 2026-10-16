@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Root view header'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity ZC_HEADER_2699
  provider contract transactional_query
  as projection on ZI_HEADER_2699
{
  key Id,
      Email,
      Firstname,
      Lastname,
      CustomerFullName,
      Country,
      Createon,
      Deliverydate,
      @ObjectModel.text.element: ['OrderStatusDescr']
      @Consumption.valueHelpDefinition: [{
          entity: { name: 'ZC_STATUS_2699', element: 'Status' }
      }]
      Orderstatus,
      Imageurl,

      LocalCreatedBy,
      LocalCreatedAt,
      LocalLastChangedBy,
      LocalLastChangeAt,
      LastChangeAt,
      _OrderStatus.Description as OrderStatusDescr,
      /* Associations */
      _Items : redirected to composition child ZC_ITEMS_2699,
      _OrderStatus
}
