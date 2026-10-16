@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Order Status Data Definition'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZI_STATUS_2699 as select from zsostatus_2699
{
        key status as Status,
    description as Description
}
