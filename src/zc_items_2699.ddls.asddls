@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Items root entity'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity ZC_ITEMS_2699
  as projection on ZI_ITEMS_2699
{
  key Id,
  key UUID,
      Name,
      Description,
      Releasedate,
      Discontinueddate,
      @Semantics.amount.currencyCode: 'Waers'
      Price,
      @Consumption.valueHelpDefinition: [{
          entity: { name: 'I_Currency', element: 'Currency' },
          useForValidation: true
      }]
      Waers,
      @Semantics.quantity.unitOfMeasure: 'DimensionsUom'
      Height,
      @Semantics.quantity.unitOfMeasure: 'DimensionsUom'
      Width,
      @Semantics.quantity.unitOfMeasure: 'DimensionsUom'
      Depth,
      DimensionsUom,
      Quantity,
      UnitOfMeasure,
      LocalCreatedBy,
      LocalCreatedAt,
      LocalLastChangedBy,
      LocalLastChangeAt,
      LastChangeAt,
      /* Associations */
      _Header : redirected to parent ZC_HEADER_2699,
      _Currency
}
