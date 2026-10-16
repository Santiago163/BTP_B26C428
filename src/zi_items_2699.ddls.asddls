@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Items Data Definition'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_ITEMS_2699 as select from zsoitems_2699
 association to parent ZI_HEADER_2699 as _Header on $projection.Id = _Header.Id
    association [0..1] to I_Currency as _Currency on $projection.Waers = _Currency.Currency
{
    key id as Id,
    key item_uuid as UUID,
    name as Name,
    description as Description,
    releasedate as Releasedate,
    discontinueddate as Discontinueddate,
    @Semantics.amount.currencyCode: 'Waers'
    price as Price,
    waers as Waers,
    @Semantics.quantity.unitOfMeasure: 'DimensionsUom'
    height as Height,
    @Semantics.quantity.unitOfMeasure: 'DimensionsUom'
    width as Width,
    @Semantics.quantity.unitOfMeasure: 'DimensionsUom'
    depth as Depth,
    dimensions_uom as DimensionsUom,
    quantity as Quantity,
    unitofmeasure as UnitOfMeasure,
    local_created_by as LocalCreatedBy,
    local_created_at as  LocalCreatedAt,
    local_last_changed_by as LocalLastChangedBy,
    local_last_changed_at as LocalLastChangeAt,    
    last_changed_at as  LastChangeAt,
    _Header,
    _Currency
}

