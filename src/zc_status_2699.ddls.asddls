@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Proj.View for order status description'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZC_STATUS_2699 
    provider contract transactional_query
    as projection on ZI_STATUS_2699
{
    key Status,
    Description
}
